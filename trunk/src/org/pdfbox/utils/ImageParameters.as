package org.pdfbox.utils
{

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSInteger;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSNumber;

	//import org.pdfbox.pdmodel.common.COSArrayList;


	/**
	 * This contains all of the image parameters for in inlined image.
	 */
	public class ImageParameters
	{
		private var dictionary:COSDictionary;

		/**
		 * Constructor.
		 */
		public function ImageParameters( params:COSDictionary = null)
		{
			dictionary = (params == null)?new COSDictionary():params;
		}
		
		/**
		 * This will get the dictionary that stores the image parameters.
		 * 
		 * @return The COS dictionary that stores the image parameters.
		 */
		public function getDictionary():COSDictionary
		{
			return dictionary;
		}

		private function getCOSObject( abbreviatedName:String, name:String ):COSBase
		{
			var retval:COSBase = dictionary.getDictionaryObject( COSName.getPDFName( abbreviatedName ) );
			if( retval == null )
			{
				retval = dictionary.getDictionaryObject( COSName.getPDFName( name ) );
			}
			return retval;
		}

		private function getNumberOrNegativeOne( abbreviatedName:String, name:String ):int
		{
			var retval:int = -1;
			var number:COSNumber = getCOSObject( abbreviatedName, name ) as COSNumber;
			if( number != null )
			{
				retval = number.intValue();
			}
			return retval;
		}

		/**
		 * The bits per component of this image.  This will return -1 if one has not
		 * been set.
		 *
		 * @return The number of bits per component.
		 */
		public function getBitsPerComponent():int
		{
			return getNumberOrNegativeOne( "BPC", "BitsPerComponent" );
		}

		/**
		 * Set the number of bits per component.
		 *
		 * @param bpc The number of bits per component.
		 */
		public function setBitsPerComponent( bpc:int ):void
		{
			dictionary.setItem( COSName.getPDFName( "BPC" ), new COSInteger( bpc ) );
		}


		/**
		 * This will get the color space or null if none exists.
		 *
		 * @return The color space for this image.
		 *
		 * @throws IOException If there is an error getting the colorspace.
		 *
		public PDColorSpace getColorSpace() throws IOException
		{
			COSBase cs = getCOSObject( "CS", "ColorSpace" );
			PDColorSpace retval = null;
			if( cs != null )
			{
				retval = PDColorSpaceFactory.createColorSpace( cs );
			}
			return retval;
		}

		/**
		 * This will set the color space for this image.
		 *
		 * @param cs The color space for this image.
		 *
		public void setColorSpace( PDColorSpace cs )
		{
			COSBase base = null;
			if( cs != null )
			{
				base = cs.getCOSObject();
			}
			dictionary.setItem( COSName.getPDFName( "CS" ), base );
		}
		*/

		/**
		 * The height of this image.  This will return -1 if one has not
		 * been set.
		 *
		 * @return The height.
		 */
		public function getHeight():int
		{
			return getNumberOrNegativeOne( "H", "Height" );
		}

		/**
		 * Set the height of the image.
		 *
		 * @param h The height of the image.
		 */
		public function setHeight( h:int ):void
		{
			dictionary.setItem( COSName.getPDFName( "H" ), new COSInteger( h ) );
		}

		/**
		 * The width of this image.  This will return -1 if one has not
		 * been set.
		 *
		 * @return The width.
		 */
		public function getWidth():int
		{
			return getNumberOrNegativeOne( "W", "Width" );
		}

		/**
		 * Set the width of the image.
		 *
		 * @param w The width of the image.
		 */
		public function setWidth( w:int ):void
		{
			dictionary.setItem( COSName.getPDFName( "W" ), new COSInteger( w ) );
		}
		
		/**
		 * This will get the list of filters that are associated with this stream.  Or
		 * null if there are none.
		 * @return A list of all encoding filters to apply to this stream.
		 *
		public List getFilters()
		{
			List retval = null;
			COSBase filters = dictionary.getDictionaryObject( new String[] {"Filter", "F"} );
			if( filters instanceof COSName )
			{
				COSName name = (COSName)filters;
				retval = new COSArrayList( name.getName(), name, dictionary, "Filter" );
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
		public function setFilters( List filters ):void
		{
			COSBase obj = COSArrayList.convertStringListToCOSNameCOSArray( filters );
			dictionary.setItem( "Filter", obj );
		}
		*/
	}
}