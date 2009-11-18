package org.pdfbox.pdmodel.common.filespecification
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSString;

	/**
	 * A file specification that is just a string.
	 * 
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.2 $
	 */
	public class PDFSimpleFileSpecification extends PDFileSpecification
	{
		private var file:COSString;
		
		/**
		 * Constructor.
		 *
		 */

		public function PDFSimpleFileSpecification( fileName:COSString = null )
		{
			file = (fileName == null)? new COSString( "" ) : fileName;
		}

		/**
		 * This will get the file name.
		 *
		 * @return The file name.
		 */
		public function getFile():void
		{
			return file.getString();
		}

		/**
		 * This will set the file name.
		 *
		 * @param fileName The name of the file.
		 */
		override public function setFile( fileName:String ):void
		{
			file = new COSString( fileName );
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		override public function getCOSObject():COSBase
		{
			return file;
		}
	}
}
