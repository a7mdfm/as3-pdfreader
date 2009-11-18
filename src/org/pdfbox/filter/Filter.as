package org.pdfbox.filter
{
	import flash.utils.ByteArray;
	import org.pdfbox.cos.COSDictionary;

	/**
	 * This is the interface that will be used to apply filters to a byte stream.
	 */
	public interface Filter
	{
		/**
		 * This will decode some compressed data.
		 *
		 * @param compressedData The compressed byte stream.
		 * @param result The place to write the uncompressed byte stream.
		 * @param options The options to use to encode the data.
		 *
		 */
		function decode( compressedData:ByteArray, result:ByteArray, options:COSDictionary = null ):void;

		/**
		 * This will encode some data.
		 *
		 * @param rawData The raw data to encode.
		 * @param result The place to write to encoded results to.
		 * @param options The options to use to encode the data.
		 *
		 */
		function encode( rawData:ByteArray, result:ByteArray, options:COSDictionary = null ):void;
	}
}