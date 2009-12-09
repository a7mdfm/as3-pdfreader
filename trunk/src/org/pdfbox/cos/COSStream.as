package org.pdfbox.cos
{
	import flash.utils.ByteArray;
	import org.pdfbox.pdfparser.PDFStreamParser;
	
	import org.pdfbox.filter.FilterManager;
	import org.pdfbox.filter.Filter;
	
	import org.pdfbox.utils.ByteUtil;
	/**
	 * This class represents a stream object in a PDF document.
	 */
	public class COSStream extends COSDictionary
	{
	    //private static const BUFFER_SIZE:int=16384;

	    //private var file:RandomAccess;
	    /**
	     * The stream with all of the filters applied.
	     */
	    public var filteredStream:ByteArray;

	    /**
	     * The stream with no filters, this contains the useful data.
	     */
	    public var unFilteredStream:ByteArray;

	    /**
	     * Constructor.
	     *
	     * @param dictionary The dictionary that is associated with this stream.
	     * @param storage The intermediate storage for the stream.
	     */
	    public function COSStream( dictionary:COSDictionary = null, file:Object = null)
	    {
			super(dictionary);
			//file = storage;
	    }
		
		public function getFilterManager():FilterManager
		{
			/**
			 * @todo move this to PDFdocument or something better
			 */
			return new FilterManager();
		}

	    /**
	     * This will replace this object with the data from the new object.  This
	     * is used to easily maintain referential integrity when changing references
	     * to new objects.
	     *
	     * @param stream The stream that have the new values in it.
	     */
	    public function replaceWithStream( stream:COSStream):void{
			this.clear();
			this.addAll( stream );

			filteredStream = stream.filteredStream;
			unFilteredStream = stream.unFilteredStream;
	    }

	    /**
	     * This will get the scratch file associated with this stream.
	     *
	     * @return The scratch file where this stream is being stored.
	     */
	    /*public function getScratchFile():RandomAccess{
		return file;
	    }*/

	    /**
	     * This will get all the tokens in the stream.
	     *
	     * @return All of the tokens in the stream.
	     *
	     * @throws IOException If there is an error parsing the stream.
	     */
	    public function getStreamTokens():Array
	    {
			//TODO
			var parser:PDFStreamParser= new PDFStreamParser( this );
			parser.parse();
			return parser.getTokens();
	    }

	    /**
	     * This will get the stream with all of the filters applied.
	     *
	     * @return the bytes of the physical (endoced) stream
	     *
	     * @throws IOException when encoding/decoding causes an exception
	     */
	    public function getFilteredStream():ByteArray
	    {
			if( filteredStream == null )
			{
				doEncode();
			}
			//var position:Number= filteredStream.position;
			//var length:Number= filteredStream.length;

			//var input:ByteArray = new ByteArray( file, position, length );
			//return new BufferedInputStream( input, BUFFER_SIZE );
			

			//TODO
			return filteredStream;
	    }

	    /**
	     * This will get the logical content stream with none of the filters.
	     *
	     * @return the bytes of the logical (decoded) stream
	     *
	     * @throws IOException when encoding/decoding causes an exception
	     */
	    public function getUnfilteredStream():ByteArray
	    {
			if( unFilteredStream == null )
			{
				doDecode();
			}			
			return unFilteredStream;
	    }

	    /**
	     * visitor pattern double dispatch method.
	     *
	     * @param visitor The object to notify when visiting this object.
	     * @return any object, depending on the visitor implementation, or null
	     * @throws COSVisitorException If an error occurs while visiting this object.
	     */
	    override public function accept(visitor:ICOSVisitor):Object
	    {
			return visitor.visitFromStream(this);
	    }

	    private function doDecode( filterName:COSName = null):void
	    {
			//
			var filters:COSBase;
			if ( filterName == null) {
				filters = getFilters();
			}else {
				filters = filterName;	
			}
			trace("filters:" + filters);
			if( filters == null )
			{
				//there is no filter to apply
				unFilteredStream = this.filteredStream;
			}			
			else if( filters is COSName )
			{
				$doDecode( filters as COSName );
			}
			else if( filters is COSArray )
			{
				// apply filters in reverse order
				var  filterArray:COSArray = filters as COSArray;
				for ( var i:int = 0,len:int = filterArray.size(); i < len; i++ )
				{
					var filterName:COSName = filterArray.get( i ) as COSName;
					trace(filterName+":"+unFilteredStream);
					$doDecode( filterName );
					trace("--------:"+unFilteredStream);
				}
			}			
	    }
		private function $doDecode( filterName:COSName ):void
		{
			var manager:FilterManager = getFilterManager();
			var filter:Filter = manager.getFilter( filterName );
			
			unFilteredStream = new ByteArray();
			filter.decode( filteredStream, unFilteredStream, null );			
		}

	    /**
	     * This will encode the logical byte stream applying all of the filters to the stream.
	     *
	     * @throws IOException If there is an error applying a filter to the stream.
	     */
	    private function doEncode( filterName:COSName = null ):void
	    {
			var manager:FilterManager = getFilterManager();
			var filter:Filter = manager.getFilter( filterName );
			var input:ByteArray = new ByteArray();
			
			filter.encode( unFilteredStream, filteredStream, null );
	    }

	    /**
	     * This will return the filters to apply to the byte stream.
	     * The method will return
	     * - null if no filters are to be applied
	     * - a COSName if one filter is to be applied
	     * - a COSArray containing COSNames if multiple filters are to be applied
	     *
	     * @return the COSBase object representing the filters
	     */
	    public function getFilters():COSBase{
			return getDictionaryObject(COSName.FILTER);
	    }

	    /**
	     * This will create a new stream for which filtered byte should be
	     * written to.  You probably don't want this but want to use the
	     * createUnfilteredStream, which is used to write raw bytes to.
	     *
	     * @param expectedLength An entry where a length is expected.
	     *
	     * @return A stream that can be written to.
	     *
	     * @throws IOException If there is an error creating the stream.
	     */
	    public function createFilteredStream( expectedLength:COSBase = null ):ByteArray
	    {
			filteredStream = new ByteArray();
			unFilteredStream = null;
			return filteredStream;
	    }

	    /**
	     * set the filters to be applied to the stream.
	     *
	     * @param filters The filters to set on this stream.
	     *
	     * @throws IOException If there is an error clearing the old filters.
	     */
	    public function setFilters(filters:COSBase):void
	    {
			setItem(COSName.FILTER, filters);
			// kill cached filtered streams
			filteredStream = null;
	    }

	    /**
	     * This will create an output stream that can be written to.
	     *
	     * @return An output stream which raw data bytes should be written to.
	     *
	     * @throws IOException If there is an error creating the stream.
	     */
	    public function createUnfilteredStream():ByteArray
	    {
			unFilteredStream = new ByteArray( );
			filteredStream = null;
			return unFilteredStream;
	    }
	}
}