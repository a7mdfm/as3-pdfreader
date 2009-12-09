package org.pdfbox.filter{


	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import org.pdfbox.io.ASCII85InputStream;
	import org.pdfbox.io.ASCII85OutputStream;

	import org.pdfbox.cos.COSDictionary;

	/**
	 * This is the used for the ASCIIHexDecode filter.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.7 $
	 */
	public class ASCII85Filter implements Filter
	{
		/**
		 * This will decode some compressed data.
		 *
		 * @param compressedData The compressed byte stream.
		 * @param result The place to write the uncompressed byte stream.
		 * @param options The options to use to encode the data.
		 *
		 * @throws IOException If there is an error decompressing the stream.
		 */
		public function decode(compressedData:ByteArray, result:ByteArray, options:COSDictionary = null) :void
		{
			var instream:ASCII85InputStream = null;
			try
			{
				instream = new ASCII85InputStream(compressedData);
				var buffer:ByteArray = new ByteArray(); //1024
				var amountRead:int = 0;
				while( (amountRead = instream.readto( buffer, 0, 1024) ) != -1 )
				{
					result.writeBytes(buffer, 0, amountRead);
				}
			}
			finally
			{
				if(instream != null )
				{
					instream.close();
				}
			}
		}

		/**
		 * This will encode some data.
		 *
		 * @param rawData The raw data to encode.
		 * @param result The place to write to encoded results to.
		 * @param options The options to use to encode the data.
		 *
		 * @throws IOException If there is an error compressing the stream.
		 */
		public function encode( rawData:ByteArray, result:ByteArray, options:COSDictionary = null ):void
		{
			/*
			var os:ASCII85OutputStream = new ASCII85OutputStream(result);
			var buffer:Array = new Array(1024);
			var amountRead:int = 0;
			while( (amountRead = rawData.read( buffer, 0, 1024 )) != -1 )
			{
				os.write( buffer, 0, amountRead );
			}
			os.close();
			result.flush();
			*/
		}
	}
}