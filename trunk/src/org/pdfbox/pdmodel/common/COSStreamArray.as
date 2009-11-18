package org.pdfbox.pdmodel.common
{
	import flash.utils.ByteArray;
	import org.pdfbox.utils.ArrayList;

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSStream;
	import org.pdfbox.cos.ICOSVisitor;

	import org.pdfbox.pdfparser.PDFStreamParser;

	/**
	 * This will take an array of streams and sequence them together.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.9 $
	 */
	public class COSStreamArray extends COSStream
	{
	    private var streams:COSArray;

	    /**
	     * The first stream will be used to delegate some of the methods for this
	     * class.
	     */
	    private var firstStream:COSStream;

	    /**
	     * Constructor.
	     *
	     * @param array The array of COSStreams to concatenate together.
	     */
	    public function COSStreamArray(  array:COSArray ):void
	    {
			super( new COSDictionary(), null );
			streams = array;
			if( array.size() > 0 )
			{
				firstStream = array.getObject( 0 ) as COSStream;
			}
	    }

	    /**
	     * This will get an object from this streams dictionary.
	     *
	     * @param key The key to the object.
	     *
	     * @return The dictionary object with the key or null if one does not exist.
	     */
	   /* public function getItem( key:COSName ):COSBase
	    {
			return firstStream.getItem( key );
	    }*/

	   /**
	     * This will get an object from this streams dictionary and dereference it
	     * if necessary.
	     *
	     * @param key The key to the object.
	     *
	     * @return The dictionary object with the key or null if one does not exist.
	     */
	    /*public function getDictionaryObject( key:COSName ):COSBase
	    {
			return firstStream.getDictionaryObject( key );
	    }*/

	    /**
	     * {@inheritDoc}
	     */
	    override public function toString():String
	    {
			return "COSStreamArray{}";
	    }

	    /**
	     * This will get all the tokens in the stream.
	     *
	     * @return All of the tokens in the stream.
	     *
	     * @throws IOException If there is an error parsing the stream.
	     */
	    override public function getStreamTokens():Array
	    {
			var retval:Array = null;
			if( streams.size() > 0 )
			{
				var parser:PDFStreamParser = new PDFStreamParser( this );
				parser.parse();
				retval = parser.getTokens();
			}
			else
			{
				retval = new Array();
			}
			return retval;
	    }

	    /**
	     * This will get the dictionary that is associated with this stream.
	     *
	     * @return the object that is associated with this stream.
	     */
	    public function getDictionary():COSDictionary
	    {
			return firstStream;
	    }

	    /**
	     * This will get the stream with all of the filters applied.
	     *
	     * @return the bytes of the physical (endoced) stream
	     *
	     * @throws IOException when encoding/decoding causes an exception
	     */
	    override public function getFilteredStream():ByteArray
	    {
			throw( "Error: Not allowed to get filtered stream from array of streams." );
			/**
			Vector inputStreams = new Vector();
			byte[] inbetweenStreamBytes = "\n".getBytes();

			for( int i=0;i<streams.size(); i++ )
			{
				COSStream stream = (COSStream)streams.getObject( i );
			}

			return new SequenceInputStream( inputStreams.elements() );
			**/
	    }

	    /**
	     * This will get the logical content stream with none of the filters.
	     *
	     * @return the bytes of the logical (decoded) stream
	     *
	     * @throws IOException when encoding/decoding causes an exception
	     */
	    /*public function getUnfilteredStream() :ByteArray
	    {
			Vector inputStreams = new Vector();
			byte[] inbetweenStreamBytes = "\n".getBytes();

			for( int i=0;i<streams.size(); i++ )
			{
				COSStream stream = (COSStream)streams.getObject( i );
				inputStreams.add( stream.getUnfilteredStream() );
				//handle the case where there is no whitespace in the
				//between streams in the contents array, without this
				//it is possible that two operators will get concatenated
				//together
				inputStreams.add( new ByteArrayInputStream( inbetweenStreamBytes ) );
			}

			return new SequenceInputStream( inputStreams.elements() );
	    }
*/
	    /**
	     * visitor pattern double dispatch method.
	     *
	     * @param visitor The object to notify when visiting this object.
	     * @return any object, depending on the visitor implementation, or null
	     * @throws COSVisitorException If an error occurs while visiting this object.
	     */
	    override public function accept( visitor:ICOSVisitor) :Object
	    {
			return streams.accept( visitor );
	    }


	    /**
	     * This will return the filters to apply to the byte stream
	     * the method will return.
	     * - null if no filters are to be applied
	     * - a COSName if one filter is to be applied
	     * - a COSArray containing COSNames if multiple filters are to be applied
	     *
	     * @return the COSBase object representing the filters
	     */
	    override public function getFilters():COSBase
	    {
			return firstStream.getFilters();
	    }

	    /**
	     * This will create a new stream for which filtered byte should be
	     * written to.  You probably don't want this but want to use the
	     * createUnfilteredStream, which is used to write raw bytes to.
	     *
	     * @return A stream that can be written to.
	     *
	     * @throws IOException If there is an error creating the stream.
	     */
	    /*public function createFilteredStream():ByteArray
	    {
			return firstStream.createFilteredStream();
	    }*/

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
	    override public function createFilteredStream( expectedLength:COSBase = null ) :ByteArray
	    {
			return firstStream.createFilteredStream( expectedLength );
	    }

	    /**
	     * set the filters to be applied to the stream.
	     *
	     * @param filters The filters to set on this stream.
	     *
	     * @throws IOException If there is an error clearing the old filters.
	     */
	    override public function setFilters(filters:COSBase):void
	    {
			//should this be allowed?  Should this
			//propagate to all streams in the array?
			firstStream.setFilters( filters );
	    }

	    /**
	     * This will create an output stream that can be written to.
	     *
	     * @return An output stream which raw data bytes should be written to.
	     *
	     * @throws IOException If there is an error creating the stream.
	     */
	    override public function createUnfilteredStream():ByteArray
	    {
			return firstStream.createUnfilteredStream();
	    }
	    
	    /**
	     * Appends a new stream to the array that represents this object's stream.
	     * 
	     * @param streamToAppend The stream to append.
	     */
	    public function appendStream( streamToAppend:COSStream):void
	    {
			streams.add(streamToAppend);
	    }
	}

}