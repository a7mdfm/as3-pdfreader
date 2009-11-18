package org.pdfbox.pdmodel.interactive.documentnavigation.outline
{

	import org.pdfbox.cos.COSDictionary;

	/**
	 * This represents an outline in a pdf document.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.2 $
	 */
	public class PDFDocumentOutline extends PDFOutlineNode
	{   
				
		/**
		 * Constructor for an existing document outline.
		 * 
		 * @param dic The storage dictionary.
		 */
		public function PDFDocumentOutline( dic:COSDictionary = null )
		{
			super( dic );
			if ( dic == null) {
				node.setName( "Type", "Outlines" );
			}
		}
	}
}
