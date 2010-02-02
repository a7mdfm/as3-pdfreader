package org.pdfbox.operator {

	import org.pdfbox.cos.COSName;
	import org.pdfbox.pdmodel.graphics.PDFExtendedGraphicsState;
	import org.pdfbox.utils.PDFOperator;

	/**
	 * <p>Structal modification of the PDFEngine class :
	 * the long sequence of conditions in processOperator is remplaced by
	 * this strategy pattern.</p>
	 * 
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.5 $
	 */

	public class SetGraphicsStateParameters extends OperatorProcessor 
	{
		/**
		 * gs Set parameters from graphics state parameter dictionary.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 * @throws IOException If an error occurs while processing the font.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			//set parameters from graphics state parameter dictionary
			var graphicsName:COSName = arguments.get( 0 ) as COSName;
			var gs:PDFExtendedGraphicsState = (context as PDFExtendedGraphicsState).getGraphicsStates().get( graphicsName.getName() );
			gs.copyIntoGraphicsState( context.getGraphicsState() );
		}
	}
}
