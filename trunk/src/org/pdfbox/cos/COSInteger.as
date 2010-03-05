package org.pdfbox.cos
{
	import flash.utils.ByteArray;
	import org.pdfbox.utils.ByteUtil;
	/**
	 *
	 * This class represents an integer number in a PDF document.
	 */
	public class COSInteger extends COSNumber
	{

		private var value:Number;

		/**
		 * constructor.
		 *
		 * @param val The integer value of this object.
		 */
		public function COSInteger( val:Object )
		{
			if( val != null){
				if ( val is String) {
					value = parseInt( String(val) );
				}else {
					value = Number(val);
				}
			}
		}

		/**
		 * {@inheritDoc}
		 */
		override public function equals( o:Object ):Boolean
		{
			return o is COSInteger && (o as COSInteger).intValue() == intValue();
		}

		/**
		 * {@inheritDoc}
		 */
		public function hashCode():int
		{
			//taken from java.lang.Long
			return int(value ^ (value >> 32));
		}

		/**
		 * {@inheritDoc}
		 */
		public function toString():String
		{
			return "[ COSInt > " + value + " ]";
		}
		
		/**
		 * Change the value of this reference.
		 * 
		 * @param newValue The new value.
		 */
		public function setValue( newValue:Number ):void
		{
			value = newValue;
		}

		/**
		 * polymorphic access to value as float.
		 *
		 * @return The float value of this object.
		 */
		override public function floatValue():Number
		{
			return value;
		}

		/**
		 * polymorphic access to value as float.
		 *
		 * @return The double value of this object.
		 */
		override public function doubleValue():Number
		{
			return value;
		}

		/**
		 * Polymorphic access to value as int
		 * This will get the integer value of this object.
		 *
		 * @return The int value of this object,
		 */
		override public function intValue():int
		{
			return int(value);
		}

		/**
		 * Polymorphic access to value as int
		 * This will get the integer value of this object.
		 *
		 * @return The int value of this object,
		 */
		override public function longValue():Number
		{
			return value;
		}

		/**
		 * visitor pattern double dispatch method.
		 *
		 * @param visitor The object to notify when visiting this object.
		 * @return any object, depending on the visitor implementation, or null
		 * @throws COSVisitorException If an error occurs while visiting this object.
		 */
		override public function accept( visitor:ICOSVisitor ) :Object
		{
			return visitor.visitFromInt(this);
		}
		
		/**
		 * This will output this string as a PDF object.
		 *  
		 * @param output The stream to write to.
		 * @throws IOException If there is an error writing to the stream.
		 */
		public function writePDF( output:ByteArray ) :void
		{
			output.writeBytes(ByteUtil.getBytes( String(value) ));
		}
	}
}