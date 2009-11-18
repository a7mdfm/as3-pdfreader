package org.pdfbox.cos
{
	import org.pdfbox.utils.HashMap;
	import org.pdfbox.cos.COSInteger;

	/**
	 * This class represents an abstract number in a PDF document.
	 */
	public class COSNumber extends COSBase
	{
		/**
		 * ZERO.
		*/
		//public static var ZERO:COSInteger = new COSInteger( 0 );
		public static var ZERO:COSInteger;
		/**
		 * ONE.
		*/
		public static var ONE:COSInteger;
		private static var COMMON_NUMBERS:HashMap = new HashMap();


		//COMMON_NUMBERS.put( "0", ZERO );
		//COMMON_NUMBERS.put( "1", ONE );
		
		
		/**
		 * This will get the float value of this number.
		 *
		 * @return The float value of this object.
		 */
		public function floatValue():Number {
			return 0;
		}

		/**
		 * This will get the double value of this number.
		 *
		 * @return The double value of this number.
		 */
		public function doubleValue():Number {
			return 0;
		}

		/**
		 * This will get the integer value of this number.
		 *
		 * @return The integer value of this number.
		 */
		public function intValue():int {
			return 0;
		}

		/**
		 * This will get the long value of this number.
		 *
		 * @return The long value of this number.
		 */
		public function longValue():Number {
			return 0;
		}
		
		public static function initValue():void {
			ZERO = new COSInteger( 0 );
			ONE = new COSInteger( 1 );
			
			COMMON_NUMBERS.put( "0", ZERO );
			COMMON_NUMBERS.put( "1", ONE );
		}

		/**
		 * This factory method will get the appropriate number object.
		 *
		 * @param number The string representation of the number.
		 *
		 * @return A number object, either float or int.
		 *
		 * @throws IOException If the string is not a number.
		 */
		public static function get( number:String ):COSNumber
		{
			if ( ZERO == null) {
				initValue();
			}
			var result:COSNumber = COMMON_NUMBERS.get( number ) as COSNumber;
			if( result == null )
			{
				if (number.indexOf('.') >= 0)
				{
					result = new COSFloat( number );
				}
				else
				{
					result = new COSInteger( number );
				}
			}
			return result;
		}
	}
}