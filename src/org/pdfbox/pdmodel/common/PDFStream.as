package org.pdfbox.pdmodel.common
{
	
	import flash.utils.ByteArray;
	import org.pdfbox.utils.List;
	import org.pdfbox.utils.ArrayList;
	
	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSStream;

	import org.pdfbox.filter.Filter;
	import org.pdfbox.filter.FilterManager;

	import org.pdfbox.pdmodel.PDFDocument;

	import org.pdfbox.pdmodel.common.filespecification.PDFileSpecification;

	/**
	 * A PDStream represents a stream in a PDF document.  Streams are tied to a single
	 * PDF document.
	 */

	public class PDFStream implements COSObjectable
	{
		private var stream:COSStream;
		
		/**
		 * This will create a new PDStream object.
		 * 
		 * @param document The document that the stream will be part of.
		 */
		/*public function PDFStream( document:PDFDocument )
		{
			stream = new COSStream( );
		}*/
		
		/**
		 * Constructor.
		 *
		 * @param str The stream parameter.
		 */
		public function PDFStream( str:COSStream )
		{
			stream = str;
		}
				
		/**
		 * Constructor.  Reads all data from the input stream and embeds it into the
		 * document, this will close the InputStream.
		 *
		 * @param doc The document that will hold the stream.
		 * @param str The stream parameter.
		 * @param filtered True if the stream already has a filter applied.
		 * @throws IOException If there is an error creating the stream in the document.
		 *
		public function PDFStream( doc:PDFDocument, str:ByteArray, filtered:Boolean = false )
		{
			var output:ByteArray = null;
			try
			{
				stream = new COSStream( );
				if( filtered )
				{
					output = stream.createFilteredStream();
				}
				else
				{
					output = stream.createUnfilteredStream();
				}
				// TODO -- FIXME
				// 1024
				var buffer:ByteArray = new ByteArray();
				var amountRead:int = -1;
				while( str.bytesAvailable >= 1024 )
				{
					str.readBytes(buffer, 0, 1024);
					output.writeBytes( buffer, 0, 1024 );
				}
			}
			finally
			{
				if( output != null )
				{
					output = null;
				}
				if( str != null )
				{
					str = null;
				}
			}
		}*/
		
		/**
		 * If there are not compression filters on the current stream then this
		 * will add a compression filter, flate compression for example.
		 */
		public function addCompression():void
		{
			var filters:List = getFilters();
			if( filters == null )
			{
				filters = new ArrayList();
				filters.add( COSName.FLATE_DECODE );
				setFilters( filters );
			}
		}
		
		/**
		 * Create a pd stream from either a regular COSStream on a COSArray of cos streams.
		 * @param base Either a COSStream or COSArray.
		 * @return A PDStream or null if base is null.
		 * @throws IOException If there is an error creating the PDStream.
		 */
		public static function createFromCOS( base:COSBase ):PDFStream
		{
			var retval:PDFStream = null;
			if( base is COSStream )
			{
				retval = new PDFStream( base as COSStream );
			}
			else if( base is COSArray )
			{
				retval = new PDFStream( new COSStreamArray( base as COSArray ) );
			}
			else
			{
				if( base != null )
				{
					throw( "Contents are unknown type:" + base );
				}
			}
			return retval;
		}


		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return stream;
		}
		
		/**
		 * This will get a stream that can be written to.
		 * 
		 * @return An output stream to write data to.
		 * 
		 * @throws IOException If an IO error occurs during writing.
		 */
		public function createOutputStream():ByteArray
		{
			return stream.createUnfilteredStream();
		}
		
		/**
		 * This will get a stream that can be read from.
		 * 
		 * @return An input stream that can be read from.
		 * 
		 * @throws IOException If an IO error occurs during reading.
		 */
		public function createInputStream():ByteArray
		{
			return stream.getUnfilteredStream();
		}
		
		/**
		 * This will get a stream with some filters applied but not others.  This is useful
		 * when doing images, ie filters = [flate,dct], we want to remove flate but leave dct
		 * 
		 * @param stopFilters A list of filters to stop decoding at.
		 * @return A stream with decoded data.
		 * @throws IOException If there is an error processing the stream.
		 */
		/*public function getPartiallyFilteredStream( stopFilters:List ):ByteArray
		{
			var manager:FilterManager = stream.getFilterManager();
			var iuputs:ByteArray = stream.getFilteredStream();
			var outputs:ByteArray = new ByteArrayOutputStream();
			var filters:List = getFilters();			
			var nextFilter:String = null;
			var done:Boolean = false;
			
			var i:int = 0;
			while( i < filters.size() && !done )
			{
				os.reset();
				nextFilter = filters.get(i) as String;
				if( stopFilters.contains( nextFilter ) )
				{
					done = true;
				}
				else
				{
					var filter:Filter = manager.getFilter( COSName.getPDFName(nextFilter) );
					filter.decode( iuputs, outputs, stream );					
				}
				i++;
			}
			return iuputs;
		}*/
		
		/**
		 * Get the cos stream associated with this object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getStream():COSStream
		{
			return stream;
		}
		
		/**
		 * This will get the length of the filtered/compressed stream.  This is readonly in the 
		 * PD Model and will be managed by this class.
		 * 
		 * @return The length of the filtered stream.
		 */
		public function getLength():int
		{
			return stream.getInt( "Length", 0 );
		}
		
		/**
		 * This will get the list of filters that are associated with this stream.  Or
		 * null if there are none.
		 * @return A list of all encoding filters to apply to this stream.
		 */
		public function getFilters():COSArrayList
		{
			var retval:COSArrayList = null;
			var filters:COSBase = stream.getFilters();
			if( filters is COSName )
			{
				var name:COSName = filters as COSName; 
				retval = new COSArrayList( name.getName(), name, stream, "Filter" );
			}
			else if( filters is COSArray )
			{
				retval = COSArrayList.convertCOSNameCOSArrayToList( filters as COSArray );
			}
			return retval;
		}
		
		/**
		 * This will set the filters that are part of this stream.
		 * 
		 * @param filters The filters that are part of this stream.
		 */
		public function setFilters( filters:List ):void
		{
			var obj:COSBase = COSArrayList.convertStringListToCOSNameCOSArray( filters );
			stream.setItem( "Filter", obj );
		}
		
		/**
		 * Get the list of decode parameters.  Each entry in the list will refer to 
		 * an entry in the filters list.
		 * 
		 * @return The list of decode parameters.
		 * 
		 * @throws IOException if there is an error retrieving the parameters.
		 *
		public List getDecodeParams() throws IOException
		{
			List retval = null;
			
			COSBase dp = stream.getDictionaryObject( "DecodeParms" );
			if( dp == null )
			{
				//See PDF Ref 1.5 implementation note 7, the DP is sometimes used instead.
				dp = stream.getDictionaryObject( "DP" );
			}
			if( dp instanceof COSDictionary )
			{
				Map map = COSDictionaryMap.convertBasicTypesToMap( (COSDictionary)dp );
				retval = new COSArrayList(map, dp, stream, "DecodeParams" );
			}
			else if( dp instanceof COSArray )
			{
				COSArray array = (COSArray)dp;
				List actuals = new ArrayList();
				for( int i=0; i<array.size(); i++ )
				{
					actuals.add( 
						COSDictionaryMap.convertBasicTypesToMap( 
							(COSDictionary)array.getObject( i ) ) );
				}
				retval = new COSArrayList(actuals, array);
			}
			
			return retval;
		}
		
		/**
		 * This will set the list of decode params.
		 * 
		 * @param decodeParams The list of decode params.
		 *
		public void setDecodeParams( List decodeParams )
		{
			stream.setItem(
				"DecodeParams", COSArrayList.converterToCOSArray( decodeParams ) );
		}
		
		/**
		 * This will get the file specification for this stream.  This is only
		 * required for external files.
		 * 
		 * @return The file specification.
		 * 
		 * @throws IOException If there is an error creating the file spec.
		 *
		public PDFileSpecification getFile() throws IOException
		{
			COSBase f = stream.getDictionaryObject( "F" );
			PDFileSpecification retval = PDFileSpecification.createFS( f );
			return retval;
		}
		
		/**
		 * Set the file specification.
		 * @param f The file specification.
		 *
		public void setFile( PDFileSpecification f )
		{
			stream.setItem( "F", f );
		}
		
		/**
		 * This will get the list of filters that are associated with this stream.  Or
		 * null if there are none.
		 * @return A list of all encoding filters to apply to this stream.
		 *
		public List getFileFilters()
		{
			List retval = null;
			COSBase filters = stream.getDictionaryObject( "FFilter" );
			if( filters instanceof COSName )
			{
				COSName name = (COSName)filters;
				retval = new COSArrayList( name.getName(), name, stream, "FFilter" );
			}
			else if( filters instanceof COSArray )
			{
				retval = COSArrayList.convertCOSNameCOSArrayToList( (COSArray)filters );
			}
			return retval;
		}
		
		/**
		 * This will set the filters that are part of this stream.
		 * 
		 * @param filters The filters that are part of this stream.
		 *
		public void setFileFilters( List filters )
		{
			COSBase obj = COSArrayList.convertStringListToCOSNameCOSArray( filters );
			stream.setItem( "FFilter", obj );
		}
		
		/**
		 * Get the list of decode parameters.  Each entry in the list will refer to 
		 * an entry in the filters list.
		 * 
		 * @return The list of decode parameters.
		 * 
		 * @throws IOException if there is an error retrieving the parameters.
		 *
		public List getFileDecodeParams() throws IOException
		{
			List retval = null;
			
			COSBase dp = stream.getDictionaryObject( "FDecodeParms" );
			if( dp instanceof COSDictionary )
			{
				Map map = COSDictionaryMap.convertBasicTypesToMap( (COSDictionary)dp );
				retval = new COSArrayList(map, dp, stream, "FDecodeParams" );
			}
			else if( dp instanceof COSArray )
			{
				COSArray array = (COSArray)dp;
				List actuals = new ArrayList();
				for( int i=0; i<array.size(); i++ )
				{
					actuals.add( 
						COSDictionaryMap.convertBasicTypesToMap( 
							(COSDictionary)array.getObject( i ) ) );
				}
				retval = new COSArrayList(actuals, array);
			}
			
			return retval;
		}
		
		/**
		 * This will set the list of decode params.
		 * 
		 * @param decodeParams The list of decode params.
		 *
		public void setFileDecodeParams( List decodeParams )
		{
			stream.setItem(
				"FDecodeParams", COSArrayList.converterToCOSArray( decodeParams ) );
		}
		
		/**
		 * This will copy the stream into a byte array. 
		 * 
		 * @return The byte array of the filteredStream
		 * @throws IOException When getFilteredStream did not work
		 */
		public function getByteArray():ByteArray
		{
			var output:ByteArray = new ByteArray();
			var buf:ByteArray = new ByteArray();
			//[1024];
			//var inputStream:ByteArray = null;
			try
			{
				var input:ByteArray = createInputStream();
				input.position = 0;
				input.readBytes(output);
				/*var amountRead:int = -1;
				while( (amountRead = input.read( buf )) != -1)
				{
					output.write( buf, 0, amountRead );
				}*/
			}
			finally
			{
				//
			}
			return output;
		}
		
		/**
		 * A convenience method to get this stream as a string.  Uses
		 * the default system encoding. 
		 * 
		 * @return a String representation of this (input) stream, with the
		 * platform default encoding.
		 * 
		 * @throws IOException if there is an error while converting the stream 
		 *                     to a string.
		 */
		public function getInputStreamAsString() :String
		{
			var bStream:ByteArray = getByteArray();
			return bStream.toString();
		}
		
		/**
		 * Get the metadata that is part of the document catalog.  This will 
		 * return null if there is no meta data for this object.
		 * 
		 * @return The metadata for this object.
		 */
		/*public PDMetadata getMetadata()
		{
			PDMetadata retval = null;
			COSStream mdStream = (COSStream)stream.getDictionaryObject( "Metadata" );
			if( mdStream != null )
			{
				retval = new PDMetadata( mdStream );
			}
			return retval;
		}*/
		
		/**
		 * Set the metadata for this object.  This can be null.
		 * 
		 * @param meta The meta data for this object.
		 */
		/*public void setMetadata( PDMetadata meta )
		{
			stream.setItem( "Metadata", meta );
		}*/
	}
}