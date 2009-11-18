package org.pdfbox.cos 
{
	
	//import org.pdfbox.filter.FilterManager;
	import org.pdfbox.pdmodel.common.COSObjectable;


	/**
	 * The base object that all objects in the PDF document will extend.
	 *
	 */
	public class COSBase implements COSObjectable
	{
		/**
		 * Constructor.
		 */
		public function COSBase()
		{
		}		
		
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return this;
		}

		public function accept( visitor:ICOSVisitor ):Object {
			//
			return null;
		}
	}
}