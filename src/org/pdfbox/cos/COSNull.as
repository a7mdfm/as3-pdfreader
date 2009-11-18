package org.pdfbox.cos
{
	import flash.utils.ByteArray;
	import org.pdfbox.utils.ByteUtil;
	/**
	 * This class represents a null PDF object.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.13 $
	 */
	public class COSNull extends COSBase
	{
		/**
		 * The null token.
		 */
		public static const NULL_BYTES:Array = [ 110, 117, 108, 108 ]; //"null".getBytes( "ISO-8859-1" );
		
		/**
		 * The one null object in the system.
		 */
		public static const NULL:COSNull = new COSNull();

		/**
		 * Constructor.
		 */
		public function COSNull()
		{
			//limit creation to one instance.
		}

		/**
		 * visitor pattern double dispatch method.
		 *
		 * @param visitor The object to notify when visiting this object.
		 * @return any object, depending on the visitor implementation, or null
		 * @throws COSVisitorException If an error occurs while visiting this object.
		 */
		override public function accept( visitor:ICOSVisitor ):Object
		{
			return visitor.visitFromNull( this );
		}
		
		/**
		 * This will output this string as a PDF object.
		 *  
		 * @param output The stream to write to.
		 * @throws IOException If there is an error writing to the stream.
		 */
		//TODO
		public function writePDF( output:ByteArray ):void
		{
			output.writeBytes ( ByteUtil.toByteArray(NULL_BYTES) );
		}
	}
}