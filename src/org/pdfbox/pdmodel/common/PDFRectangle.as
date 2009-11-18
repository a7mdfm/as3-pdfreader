package org.pdfbox.pdmodel.common
{

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSFloat;
	import org.pdfbox.cos.COSNumber;
	
	import flash.geom.Rectangle;

	/**
	 * This represents a rectangle in a PDF document.
	 */
	public class PDFRectangle implements COSObjectable
	{
		private var rectArray:COSArray;
		
		/**
		 * Constructor.
		 *
		 * @param width The width of the rectangle.
		 * @param height The height of the rectangle.
		 */
		public function PDFRectangle( width:Number = 0, height:Number = 0 )
		{
			rectArray = new COSArray();
			rectArray.add( new COSFloat( 0.0 ) );
			rectArray.add( new COSFloat( 0.0 ) );
			rectArray.add( new COSFloat( width ) );
			rectArray.add( new COSFloat( height ) );
		}
		
		public function getCOSObject():COSBase
		{
			return rectArray;
		}
		
		/*
		 *  TODO
		 */ 
		public function createDimension():Rectangle
		{
			return new Rectangle( 0,0, getWidth(), getHeight() );
		}

		/**
		 * Constructor.
		 *
		 * @param box The non PD bouding box.
		 */
		/*public function PDRectangle( BoundingBox box )
		{
			rectArray = new COSArray();
			rectArray.add( new COSFloat( box.getLowerLeftX() ) );
			rectArray.add( new COSFloat( box.getLowerLeftY() ) );
			rectArray.add( new COSFloat( box.getUpperRightX() ) );
			rectArray.add( new COSFloat( box.getUpperRightY() ) );
		}
*/
		/**
		 * Constructor.
		 *
		 * @param array An array of numbers as specified in the PDF Reference for a rectangle type.
		 */
		public function setCOSArray( array:COSArray ):void
		{
			rectArray = array;
		}
		
		
		public function getCOSArray():COSArray
		{
			return rectArray;
		}

		/**
		 * This will get the lower left x coordinate.
		 *
		 * @return The lower left x.
		 */
		public function getLowerLeftX():Number
		{
			return (rectArray.get(0) as COSNumber).floatValue();
		}

		/**
		 * This will set the lower left x coordinate.
		 *
		 * @param value The lower left x.
		 */
		public function setLowerLeftX( value:Number):void
		{
			rectArray.set(0, new COSFloat( value ) );
		}

		/**
		 * This will get the lower left y coordinate.
		 *
		 * @return The lower left y.
		 */
		public function getLowerLeftY():Number
		{
			return (rectArray.get(1) as COSNumber).floatValue();
		}

		/**
		 * This will set the lower left y coordinate.
		 *
		 * @param value The lower left y.
		 */
		public function setLowerLeftY(value:Number):void
		{
			rectArray.set(1, new COSFloat( value ) );
		}

		/**
		 * This will get the upper right x coordinate.
		 *
		 * @return The upper right x .
		 */
		public function getUpperRightX():Number
		{
			return (rectArray.get(2) as COSNumber).floatValue();
		}

		/**
		 * This will set the upper right x coordinate.
		 *
		 * @param value The upper right x .
		 */
		public function setUpperRightX(value:Number):void
		{
			rectArray.set(2, new COSFloat( value ) );
		}

		/**
		 * This will get the upper right y coordinate.
		 *
		 * @return The upper right y.
		 */
		public function getUpperRightY():Number
		{
			return (rectArray.get(3) as COSNumber).floatValue();
		}

		/**
		 * This will set the upper right y coordinate.
		 *
		 * @param value The upper right y.
		 */
		public function setUpperRightY(value:Number):void
		{
			rectArray.set(3, new COSFloat( value ) );
		}

		/**
		 * This will get the width of this rectangle as calculated by
		 * upperRightX - lowerLeftX.
		 *
		 * @return The width of this rectangle.
		 */
		public function getWidth():Number
		{
			return getUpperRightX() - getLowerLeftX();
		}

		/**
		 * This will get the height of this rectangle as calculated by
		 * upperRightY - lowerLeftY.
		 *
		 * @return The height of this rectangle.
		 */
		public function getHeight():Number
		{
			return getUpperRightY() - getLowerLeftY();
		}
		
		/**
		 * Method to determine if the x/y point is inside this rectangle.
		 * @param x The x-coordinate to test.
		 * @param y The y-coordinate to test.
		 * @return True if the point is inside this rectangle.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			var llx:Number = getLowerLeftX();
			var urx:Number = getUpperRightX();
			var lly:Number = getLowerLeftY();
			var ury:Number = getUpperRightY();
			
			//var rect:Rectangle = new Rectangle();
			//return rect.contains(x, y);
			return x >= llx && x <= urx &&
				   y >= lly && y <= ury;
		}
		
		public function move(horizontalAmount:Number, verticalAmount:Number):void
		{
			setUpperRightX(getUpperRightX() + horizontalAmount);
			setLowerLeftX(getLowerLeftX() + horizontalAmount);
			setUpperRightY(getUpperRightY() + verticalAmount);
			setLowerLeftY(getLowerLeftY() + verticalAmount);
		}

		/**
		 * This will create a translated rectangle based off of this rectangle, such
		 * that the new rectangle retains the same dimensions(height/width), but the
		 * lower left x,y values are zero. <br />
		 * 100, 100, 400, 400 (llx, lly, urx, ury ) <br />
		 * will be translated to 0,0,300,300
		 *
		 * @return A new rectangle that has been translated back to the origin.
		 */
		public function createRetranslatedRectangle():PDFRectangle
		{
			var retval:PDFRectangle = new PDFRectangle();
			retval.setUpperRightX( getWidth() );
			retval.setUpperRightY( getHeight() );
			return retval;
		}
		
		public function toString():String
		{
			return rectArray.toString();
		}
		
	}
}