package org.pdfbox.operator{

	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.utils.PDFOperator;


	/**
	 * <p>Structal modification of the PDFEngine class :
	 * the long sequence of conditions in processOperator is remplaced by
	 * this strategy pattern.</p>
	 * 
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.5 $
	 */

	public class SetLineWidth extends OperatorProcessor 
	{
		/**
		 * w Set line width.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 * @throws IOException If an error occurs while processing the font.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			var width:COSNumber = arguments.get( 0 ) as COSNumber;
			context.getGraphicsState().setLineWidth( width.doubleValue() );
		}
	}
}
