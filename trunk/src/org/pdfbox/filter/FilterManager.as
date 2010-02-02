package org.pdfbox.filter
{
	
	import org.pdfbox.utils.HashMap;
	
	import org.pdfbox.cos.COSName;

	/**
	 * This will contain manage all the different types of filters that are available.
	 */
	public class FilterManager
	{
		private var filters:HashMap = new HashMap();

		/**
		 * Constructor.
		 */
		public function FilterManager()
		{
			var flateFilter:Filter = new FlateFilter();
			//var dctFilter:Filter = new DCTFilter();
			//var ccittFaxFilter:Filter = new CCITTFaxDecodeFilter();
			//var lzwFilter:Filter = new LZWFilter();
			//var asciiHexFilter:Filter = new ASCIIHexFilter();
			var ascii85Filter:Filter = new ASCII85Filter();
			//var runLengthFilter:Filter = new RunLengthDecodeFilter();

			addFilter( COSName.FLATE_DECODE, flateFilter );
			addFilter( COSName.FLATE_DECODE_ABBREVIATION, flateFilter );
			addFilter( COSName.ASCII85_DECODE, ascii85Filter );
			addFilter( COSName.ASCII85_DECODE_ABBREVIATION, ascii85Filter );
			
			/*
			addFilter( COSName.DCT_DECODE, dctFilter );
			addFilter( COSName.DCT_DECODE_ABBREVIATION, dctFilter );
			addFilter( COSName.CCITTFAX_DECODE, ccittFaxFilter );
			addFilter( COSName.CCITTFAX_DECODE_ABBREVIATION, ccittFaxFilter );
			addFilter( COSName.LZW_DECODE, lzwFilter );
			addFilter( COSName.LZW_DECODE_ABBREVIATION, lzwFilter );
			addFilter( COSName.ASCII_HEX_DECODE, asciiHexFilter );
			addFilter( COSName.ASCII_HEX_DECODE_ABBREVIATION, asciiHexFilter );
			addFilter( COSName.ASCII85_DECODE, ascii85Filter );
			addFilter( COSName.ASCII85_DECODE_ABBREVIATION, ascii85Filter );
			addFilter( COSName.RUN_LENGTH_DECODE, runLengthFilter );
			addFilter( COSName.RUN_LENGTH_DECODE_ABBREVIATION, runLengthFilter );
			*/
		}

		/**
		 * This will get all of the filters that are available in the system.
		 *
		 * @return All available filters in the system.
		 */
		public function getFilters():Array
		{
			return filters.values();
		}

		/**
		 * This will add an available filter.
		 *
		 * @param filterName The name of the filter.
		 * @param filter The filter to use.
		 */
		public function addFilter( filterName:COSName, filter:Filter ):void
		{
			filters.put( filterName, filter );
		}

		/**
		 * This will get a filter by name.
		 *
		 * @param filterName The name of the filter to retrieve.
		 *
		 * @return The filter that matches the name.
		 *
		 * @throws IOException If the filter could not be found.
		 */
		public function getFilter( _filterName:Object ):Filter
		{
			var filterName:COSName;
			if ( _filterName is String) {
				filterName = COSName.getPDFName( String(filterName) );
			}else if (_filterName is COSName) {
				filterName = _filterName as COSName;
			}
			var filter:Filter = filters.get( filterName ) as Filter;
			
			if( filter == null )
			{
				//编码暂时不支持
				throw new Error( "sorry," + filterName +  " not supported now" );
			}

			return filter;
		}
		
	}
}