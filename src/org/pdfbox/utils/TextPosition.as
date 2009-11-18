package org.pdfbox.utils
{

	import org.pdfbox.pdmodel.font.PDFont;

	/**
	 * This represents a character and a position on the screen of those characters.
	 */
	public class TextPosition
	{
	    public var x:Number;
	    public var y:Number;
	    public var xScale:Number;
	    public var yScale:Number;
	    public var width:Number;
	    public var height:Number;
	    public var widthOfSpace:Number;
	    public var c:String;
	    public var font:PDFont;
	    public var fontSize:Number;
	    public var wordSpacing:Number;

	    /**
	     * Constructor.
	     *
	     * @param xPos The x coordinate of the character.
	     * @param yPos The y coordinate of the character.
	     * @param xScl The x scaling of the character.
	     * @param yScl The y scaling of the character.
	     * @param widthValue The width of the character.
	     * @param heightValue The height of the character.
	     * @param spaceWidth The width of the space character.
	     * @param string The character to be displayed.
	     * @param currentFont The current for for this text position.
	     * @param fontSizeValue The new font size.
	     * @param ws The word spacing parameter
	     */
	    public function TextPosition(
			xPos:Number,
			yPos:Number,
			xScl:Number,
			yScl:Number,
			widthValue:Number,
			heightValue:Number,
			spaceWidth:Number,
			string:String,
			currentFont:PDFont,
			fontSizeValue:Number,
			ws:Number
			)
	    {
			this.x = xPos;
			this.y = yPos;
			this.xScale = xScl;
			this.yScale = yScl;
			this.width = widthValue;
			this.height = heightValue;
			this.widthOfSpace = spaceWidth;
			this.c = string;
			this.font = currentFont;
			this.fontSize = fontSizeValue;
			this.wordSpacing = ws;
	    }

	    /**
	     * This will the character that will be displayed on the screen.
	     *
	     * @return The character on the screen.
	     */
	    public function getCharacter():String
	    {
			return c;
	    }
    }
}