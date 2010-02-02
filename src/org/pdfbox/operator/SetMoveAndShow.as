package org.pdfbox.operator{

	import org.pdfbox.utils.PDFOperator;

	/**
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class : the long sequence of conditions 
	 *    in processOperator is remplaced by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.6 $
	 */

	public class SetMoveAndShow extends OperatorProcessor 
	{
		/**
		 * " Set word and character spacing, move to next line, and show text.
		 * @param operator The operator that is being executed.
		 * @param arguments List.
		 * @throws IOException If there is an error processing the operator.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void {
			//Set word and character spacing, move to next line, and show text
			//
			context.processOperator("Tw", arguments.subList(0,1));
			context.processOperator("Tc", arguments.subList(1,2));
			context.processOperator("'", arguments.subList(2,3));
		}
	}
}
