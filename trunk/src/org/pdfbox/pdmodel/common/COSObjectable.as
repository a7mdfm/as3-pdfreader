package org.pdfbox.pdmodel.common
{

	import org.pdfbox.cos.COSBase;

	/**
	 * This is an interface used to get/create the underlying COSObject.
	 */
	
	public interface COSObjectable
	{
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		function getCOSObject():COSBase;
	}
}