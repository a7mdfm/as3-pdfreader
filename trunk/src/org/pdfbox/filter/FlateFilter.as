package org.pdfbox.filter
{

	import flash.utils.ByteArray;
	
	import org.pdfbox.cos.COSDictionary;

	/**
	 * This is the used for the FlateDecode filter.
	 */
	public class FlateFilter implements Filter
	{
		//private static const BUFFER_SIZE:int = 2048;

		/**
		 * This will decode some compressed data.
		 * 
		 * @param compressedData
		 *            The compressed byte stream.
		 * @param result
		 *            The place to write the uncompressed byte stream.
		 * @param options
		 *            The options to use to encode the data.
		 * 
		 */

		public function decode(compressedData:ByteArray, result:ByteArray, options:COSDictionary = null ):void
		{
			compressedData.uncompress();
			compressedData.readBytes(result, 0);
		}

		

		/**
		 * This will encode some data.
		 * 
		 * @param rawData
		 *            The raw data to encode.
		 * @param result
		 *            The place to write to encoded results to.
		 * @param options
		 *            The options to use to encode the data.
		 * 
		 */
		public function encode( rawData:ByteArray, result:ByteArray, options:COSDictionary = null ) :void
		{
			rawData.compress();
			result.writeBytes(rawData);
		}
	}
}