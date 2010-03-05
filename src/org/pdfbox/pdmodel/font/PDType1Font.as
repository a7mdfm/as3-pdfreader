package org.pdfbox.pdmodel.font{

	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;

	import org.pdfbox.utils.Map;
	import org.pdfbox.utils.HashMap;

	/**
	 * This is implementation of the Type1 Font.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.11 $
	 */
	public class PDType1Font extends PDFont
	{
		/**
		 * Standard Base 14 Font.
		 */
		public static const TIMES_ROMAN:PDType1Font = new PDType1Font( "Times-Roman" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const TIMES_BOLD:PDType1Font = new PDType1Font( "Times-Bold" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const TIMES_ITALIC:PDType1Font = new PDType1Font( "Times-Italic" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const TIMES_BOLD_ITALIC:PDType1Font = new PDType1Font( "Times-BoldItalic" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const HELVETICA:PDType1Font = new PDType1Font( "Helvetica" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const HELVETICA_BOLD:PDType1Font = new PDType1Font( "Helvetica-Bold" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const HELVETICA_OBLIQUE:PDType1Font = new PDType1Font( "Helvetica-Oblique" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const HELVETICA_BOLD_OBLIQUE:PDType1Font = new PDType1Font( "Helvetica-BoldOblique" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const COURIER:PDType1Font = new PDType1Font( "Courier" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const COURIER_BOLD:PDType1Font = new PDType1Font( "Courier-Bold" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const COURIER_OBLIQUE:PDType1Font = new PDType1Font( "Courier-Oblique" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const COURIER_BOLD_OBLIQUE:PDType1Font = new PDType1Font( "Courier-BoldOblique" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const SYMBOL:PDType1Font = new PDType1Font( "Symbol" );
		/**
		 * Standard Base 14 Font.
		 */
		public static const ZAPF_DINGBATS:PDType1Font = new PDType1Font( "ZapfDingbats" );
		
		
		private static var STANDARD_14:Map = new HashMap();
		static
		{
			STANDARD_14.put( TIMES_ROMAN.getBaseFont(), TIMES_ROMAN );
			STANDARD_14.put( TIMES_BOLD.getBaseFont(), TIMES_BOLD );
			STANDARD_14.put( TIMES_ITALIC.getBaseFont(), TIMES_ITALIC );
			STANDARD_14.put( TIMES_BOLD_ITALIC.getBaseFont(), TIMES_BOLD_ITALIC );
			STANDARD_14.put( HELVETICA.getBaseFont(), HELVETICA );
			STANDARD_14.put( HELVETICA_BOLD.getBaseFont(), HELVETICA_BOLD );
			STANDARD_14.put( HELVETICA_OBLIQUE.getBaseFont(), HELVETICA_OBLIQUE );
			STANDARD_14.put( HELVETICA_BOLD_OBLIQUE.getBaseFont(), HELVETICA_BOLD_OBLIQUE );
			STANDARD_14.put( COURIER.getBaseFont(), COURIER );
			STANDARD_14.put( COURIER_BOLD.getBaseFont(), COURIER_BOLD );
			STANDARD_14.put( COURIER_OBLIQUE.getBaseFont(), COURIER_OBLIQUE );
			STANDARD_14.put( COURIER_BOLD_OBLIQUE.getBaseFont(), COURIER_BOLD_OBLIQUE );
			STANDARD_14.put( SYMBOL.getBaseFont(), SYMBOL );
			STANDARD_14.put( ZAPF_DINGBATS.getBaseFont(), ZAPF_DINGBATS );
		}
		
		//private Font awtFont = null;
		
		/**
		 * Constructor.
		 *
		public function PDType1Font():void
		{
			font.setItem( COSName.SUBTYPE, COSName.getPDFName( "Type1" ) );
		}*/

		/**
		 * Constructor.
		 *
		 * @param fontDictionary The font dictionary according to the PDF specification.
		 */
		public function PDType1Font( fontDictionary:COSDictionary )
		{
			super( fontDictionary );
		}
		
		/**
		 * Constructor.
		 *
		 * @param baseFont The base font for this font.
		 *
		public function PDType1Font( baseFont:String )
		{
			this();
			setBaseFont( baseFont );
		}*/
		
		/**
		 * A convenience method to get one of the standard 14 font from name.
		 * 
		 * @param name The name of the font to get.
		 * 
		 * @return The font that matches the name or null if it does not exist.
		 */
		public static function getStandardFont( name:String ):PDType1Font
		{
			return STANDARD_14.get( name ) as PDType1Font;
		}
		
		/**
		 * This will get the names of the standard 14 fonts.
		 * 
		 * @return An array of the names of the standard 14 fonts.
		 */
		public static function getStandard14Names():Array
		{
			return STANDARD_14.getKeySet();
		}
		
		/**
		 * {@inheritDoc}
		 *
		public function drawString( String string, Graphics g, float fontSize, 
			float xScale, float yScale, float x, float y ) throws IOException
		{
			if( awtFont == null )
			{
				String baseFont = this.getBaseFont();
				if( baseFont.equals( TIMES_ROMAN.getBaseFont() ) )
				{
					awtFont = new Font( "Times New Roman", Font.PLAIN, 1 );
				}
				else if( baseFont.equals( TIMES_ITALIC.getBaseFont() ) )
				{
					awtFont = new Font( "Times New Roman", Font.ITALIC, 1 );
				}
				else if( baseFont.equals( TIMES_BOLD.getBaseFont() ) )
				{
					awtFont = new Font( "Times New Roman", Font.BOLD, 1 );
				}
				else if( baseFont.equals( TIMES_BOLD_ITALIC.getBaseFont() ) )
				{
					awtFont = new Font( "Times New Roman", Font.BOLD | Font.ITALIC, 1 );
				}
				else if( baseFont.equals( HELVETICA.getBaseFont() ) )
				{
					awtFont = new Font( "Helvetica", Font.PLAIN, 1 );
				}
				else if( baseFont.equals( HELVETICA_BOLD.getBaseFont() ) )
				{
					awtFont = new Font( "Helvetica", Font.BOLD, 1 );
				}
				else if( baseFont.equals( HELVETICA_BOLD_OBLIQUE.getBaseFont() ) )
				{
					awtFont = new Font( "Helvetica", Font.BOLD | Font.ITALIC, 1 );
				}
				else if( baseFont.equals( HELVETICA_OBLIQUE.getBaseFont() ) )
				{
					awtFont = new Font( "Helvetica", Font.ITALIC, 1 );
				}
				else if( baseFont.equals( COURIER.getBaseFont() ) )
				{
					awtFont = new Font( "Courier", Font.PLAIN, 1 );
				}
				else if( baseFont.equals( COURIER_BOLD.getBaseFont() ) )
				{
					awtFont = new Font( "Courier", Font.BOLD, 1 );
				}
				else if( baseFont.equals( COURIER_BOLD_OBLIQUE.getBaseFont() ) )
				{
					awtFont = new Font( "Courier", Font.BOLD | Font.ITALIC, 1 );
				}
				else if( baseFont.equals( COURIER_OBLIQUE.getBaseFont() ) )
				{
					awtFont = new Font( "Courier", Font.ITALIC, 1 );
				}
				else if( baseFont.equals( SYMBOL.getBaseFont() ) )
				{
					awtFont = new Font( "Symbol", Font.PLAIN, 1 );
				}
				else if( baseFont.equals( ZAPF_DINGBATS.getBaseFont() ) )
				{
					awtFont = new Font( "ZapfDingbats", Font.PLAIN, 1 );
				}
				else
				{
					awtFont = new Font( "Arial", Font.PLAIN, 1 );
					//throw new IOException( "Not yet implemented:" + getClass().getName() + " " +  
					//this.getBaseFont() + 
					//" "  + this + " " + TIMES_ROMAN );
				}
			}
			AffineTransform at = new AffineTransform();
			at.scale( xScale, yScale );
			
			Graphics2D g2d = (Graphics2D)g;
			g2d.setRenderingHint( RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON );
			g2d.setFont( awtFont.deriveFont( at ).deriveFont( fontSize ) );
			//g2d.getFontRenderContext().getTransform().scale( xScale, yScale );
			
			g2d.drawString( string, (int)x, (int)y );
		}*/
	}
}