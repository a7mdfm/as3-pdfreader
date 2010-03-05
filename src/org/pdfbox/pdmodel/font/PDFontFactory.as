package org.pdfbox.pdmodel.font{

	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.utils.Map;

	/**
	 * This will create the correct type of font based on information in the dictionary.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.6 $
	 */
	public class PDFontFactory
	{
		
		
		/**
		 * Create a font from the dictionary.  Use the fontCache to get the existing
		 * object instead of creating it.
		 * 
		 * @param dic The font dictionary.
		 * @param fontCache The font cache.
		 * @return The PDModel object for the cos dictionary.
		 * @throws IOException If there is an error creating the font.
		 */
		public static function createFontIn( dic:COSDictionary, fontCache:Map ):PDFont
		{
			var font:PDFont = null;
			if( fontCache != null )
			{
				font = fontCache.get( dic ) as PDFont;
			}
			if( font == null )
			{
				font = createFont( dic );
				if( fontCache != null )
				{
					fontCache.put( dic, font );
				}
			}
			return font;
		}

		/**
		 * This will create the correct font based on information in the dictionary.
		 *
		 * @param dic The populated dictionary.
		 *
		 * @return The corrent implementation for the font.
		 *
		 * @throws IOException If the dictionary is not valid.
		 */
		public static function createFont( dic:COSDictionary ):PDFont
		{
			var retval:PDFont = null;

			var type:COSName = dic.getDictionaryObject( COSName.TYPE ) as COSName;
			if( !type.equals( COSName.FONT ) )
			{
				throw new Error( "Cannot create font if /Type is not /Font.  Actual=" +type );
			}

			var subType:COSName = dic.getDictionaryObject( COSName.SUBTYPE ) as COSName;
			if( subType.equals( COSName.getPDFName( "Type1" ) ) )
			{
				retval = new PDType1Font( dic );
			}
			else if( subType.equals( COSName.getPDFName( "MMType1" ) ) )
			{
				retval = new PDMMType1Font( dic );
			}
			else if( subType.equals( COSName.getPDFName( "TrueType" ) ) )
			{
				retval = new PDTrueTypeFont( dic );
			}
			else if( subType.equals( COSName.getPDFName( "Type3" ) ) )
			{
				retval = new PDType3Font( dic );
			}
			else if( subType.equals( COSName.getPDFName( "Type0" ) ) )
			{
				retval = new PDType0Font( dic );
			}
			else if( subType.equals( COSName.getPDFName( "CIDFontType0" ) ) )
			{
				retval = new PDCIDFontType0Font( dic );
			}
			else if( subType.equals( COSName.getPDFName( "CIDFontType2" ) ) )
			{
				retval = new PDCIDFontType2Font( dic );
			}
			else
			{
				throw new Error( "Unknown font subtype=" + subType );
			}

			return retval;
		}
	}
}