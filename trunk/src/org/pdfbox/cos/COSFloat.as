package org.pdfbox.cos
{

	import flash.utils.ByteArray;
	import org.pdfbox.utils.ByteUtil;

	/**
	 * This class represents a floating point number in a PDF document.
	 */
	public class COSFloat extends COSNumber
	{
		private var value:Number;

		/**
		 * Constructor.
		 *
		 * @param aFloat The primitive float object that this object wraps.
		 */
		public function COSFloat( aFloat:Object )
		{
			if ( aFloat is String) {				
				value = parseFloat( String(aFloat) );
			}else if (aFloat is Number) {
				value = Number(aFloat);
			}
		}
		
		/**
		 * Set the value of the float object.
		 * 
		 * @param floatValue The new float value.
		 */
		public function setValue( floatValue:Number):void{
			value = floatValue;
		}

		/**
		 * The value of the float object that this one wraps.
		 *
		 * @return The value of this object.
		 */
		override public function floatValue():Number{
			return value;
		}

		/**
		 * The value of the double object that this one wraps.
		 *
		 * @return The double of this object.
		 */
		override public function doubleValue():Number{
			return value;
		}

		/**
		 * This will get the integer value of this object.
		 *
		 * @return The int value of this object,
		 */
		override public function longValue():Number{
			return value;
		}

		/**
		 * This will get the integer value of this object.
		 *
		 * @return The int value of this object,
		 */
		override public function intValue():int{
			return int(value);
		}

		/**
		 * {@inheritDoc}
		 */
		override public function equals( o:Object):Boolean{
			return o is COSFloat && COSFloat(o).floatValue() == floatValue();
		}

		/**
		 * {@inheritDoc}
		 */
		/*public function hashCode():int{
			return Float.floatToIntBits(value);
		}*/

		/**
		 * {@inheritDoc}
		 */
		public function toString():String{
			return "[ COSFloat >" + value + "]";
		}

		/**
		 * visitor pattern double dispatch method.
		 *
		 * @param visitor The object to notify when visiting this object.
		 * @return any object, depending on the visitor implementation, or null
		 * @throws COSVisitorException If an error occurs while visiting this object.
		 */
		override public function accept(visitor:ICOSVisitor):Object
		{
			return visitor.visitFromFloat(this);
		}
		
		/**
		 * This will output this string as a PDF object.
		 *  
		 * @param output The stream to write to.
		 * @throws IOException If there is an error writing to the stream.
		 */
		public function writePDF( output:ByteArray):void
		{			
			output.writeFloat( value );
		}
	}
}