package org.pdfbox.pdmodel.common.filespecification
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSString;

	import org.pdfbox.pdmodel.common.COSObjectable;

	/**
	 * This represents a file specification.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.4 $
	 */
	public class PDFileSpecification extends COSObjectable
	{

		/**
		 * A file specfication can either be a COSString or a COSDictionary.  This
		 * will create the file specification either way.
		 *
		 * @param base The cos object that describes the fs.
		 *
		 * @return The file specification for the COSBase object.
		 * 
		 * @throws IOException If there is an error creating the file spec.
		 */
		public static function createFS( base:COSBase ):PDFileSpecification
		{
			var retval:PDFileSpecification = null;
			if( base == null )
			{
				//then simply return null
			}
			else if( base is COSString )
			{
				retval = new PDSimpleFileSpecification( base as COSString );
			}
			else if( base is COSDictionary )
			{
				retval = new PDComplexFileSpecification( base as COSDictionary );
			}
			else
			{
				throw ( "Error: Unknown file specification " + base );
			}
			return retval;
		}

		/**
		 * This will get the file name.
		 *
		 * @return The file name.
		 */
		public function getFile():Strig
		{
			
		}

		/**
		 * This will set the file name.
		 *
		 * @param file The name of the file.
		 */
		public function setFile( file:String ):void
		{
			
		}
	}
}