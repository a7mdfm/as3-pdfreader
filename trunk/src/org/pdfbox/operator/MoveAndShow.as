package org.pdfbox.operator{

	import org.pdfbox.utils.PDFOperator;

	/**
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class :
	* the long sequence of conditions in processOperator is remplaced by
	* this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.5 $
	 */
	public class MoveAndShow extends OperatorProcessor 
	{
		/**
		 * ' Move to next line and show text.
		 * @param arguments List
		 * @param operator The operator that is being executed.
		 * @throws IOException If there is an error processing the operator.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void 
		{
			// Move to start of next text line, and show text
			//

			context.processOperator("T*", null);
			context.processOperator("Tj", arguments);
		}

	}
}
