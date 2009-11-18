package org.pdfbox.pdmodel.text
{

	import org.pdfbox.pdmodel.font.PDFont;
	import org.pdfbox.utils.ICloneable;

	/**
	 * This class will hold the current state of the text parameters when executing a
	 * content stream.
	 */
	public class PDFTextState implements ICloneable
	{
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_FILL_TEXT:int = 0;
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_STROKE_TEXT:int = 1;
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_FILL_THEN_STROKE_TEXT:int = 2;
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_NEITHER_FILL_NOR_STROKE_TEXT:int = 3;
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_FILL_TEXT_AND_ADD_TO_PATH_FOR_CLIPPING:int = 4;
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_STROKE_TEXT_AND_ADD_TO_PATH_FOR_CLIPPING:int = 5;
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_FILL_THEN_STROKE_TEXT_AND_ADD_TO_PATH_FOR_CLIPPING:int = 6;
		/**
		 * See PDF Reference 1.5 Table 5.3.
		 */
		public static const RENDERING_MODE_ADD_TEXT_TO_PATH_FOR_CLIPPING:int = 7;


		//these are set default according to PDF Reference 1.5 section 5.2
		private var characterSpacing:Number = 0;
		private var wordSpacing:Number = 0;
		private var horizontalScaling:Number = 100;
		private var leading:Number = 0;
		private var font:PDFont;
		private var fontSize:Number;
		private var renderingMode:int = 0;
		private var rise:Number = 0;
		private var knockout:Boolean = true;

		/**
		 * Get the value of the characterSpacing.
		 *
		 * @return The current characterSpacing.
		 */
		public function getCharacterSpacing():Number
		{
			return characterSpacing;
		}

		/**
		 * Set the value of the characterSpacing.
		 *
		 * @param value The characterSpacing.
		 */
		public function setCharacterSpacing(value:Number):void
		{
			characterSpacing = value;
		}

		/**
		 * Get the value of the wordSpacing.
		 *
		 * @return The wordSpacing.
		 */
		public function getWordSpacing():Number
		{
			return wordSpacing;
		}

		/**
		 * Set the value of the wordSpacing.
		 *
		 * @param value The wordSpacing.
		 */
		public function setWordSpacing(value:Number):void
		{
			wordSpacing = value;
		}

		/**
		 * Get the value of the horizontalScaling.  The default is 100.  This value
		 * is the percentage value 0-100 and not 0-1.  So for mathematical operations
		 * you will probably need to divide by 100 first.
		 *
		 * @return The horizontalScaling.
		 */
		public function getHorizontalScalingPercent():Number
		{
			return horizontalScaling;
		}

		/**
		 * Set the value of the horizontalScaling.
		 *
		 * @param value The horizontalScaling.
		 */
		public function setHorizontalScalingPercent(value:Number):void
		{
			horizontalScaling = value;
		}

		/**
		 * Get the value of the leading.
		 *
		 * @return The leading.
		 */
		public function getLeading():Number
		{
			return leading;
		}

		/**
		 * Set the value of the leading.
		 *
		 * @param value The leading.
		 */
		public function setLeading(value:Number):void
		{
			leading = value;
		}

		/**
		 * Get the value of the font.
		 *
		 * @return The font.
		 */
		public function getFont():PDFont
		{
			return font;
		}

		/**
		 * Set the value of the font.
		 *
		 * @param value The font.
		 */
		public function setFont(value:PDFont):void
		{
			font = value;
		}

		/**
		 * Get the value of the fontSize.
		 *
		 * @return The fontSize.
		 */
		public function getFontSize():Number
		{
			return fontSize;
		}

		/**
		 * Set the value of the fontSize.
		 *
		 * @param value The fontSize.
		 */
		public function setFontSize(value:Number):void
		{
			fontSize = value;
		}

		/**
		 * Get the value of the renderingMode.
		 *
		 * @return The renderingMode.
		 */
		public function getRenderingMode():int
		{
			return renderingMode;
		}

		/**
		 * Set the value of the renderingMode.
		 *
		 * @param value The renderingMode.
		 */
		public function setRenderingMode(value:int):void
		{
			renderingMode = value;
		}

		/**
		 * Get the value of the rise.
		 *
		 * @return The rise.
		 */
		public function getRise():Number
		{
			return rise;
		}

		/**
		 * Set the value of the rise.
		 *
		 * @param value The rise.
		 */
		public function setRise(value:Number):void
		{
			rise = value;
		}

		/**
		 * Get the value of the knockout.
		 *
		 * @return The knockout.
		 */
		public function getKnockoutFlag():Boolean
		{
			return knockout;
		}

		/**
		 * Set the value of the knockout.
		 *
		 * @param value The knockout.
		 */
		public function setKnockoutFlag(value:Boolean):void
		{
			knockout = value;
		}

		/**
		 * {@inheritDoc}
		 */
		public function clone():Object
		{
			
			return null;
		}
	}
}