package org.pdfbox.operator {

	import org.pdfbox.utils.PDFOperator;

	/**
	 *
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class : the long sequence of 
	 *    conditions in processOperator is remplaced by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.4 $
	 */

	public class GSave extends OperatorProcessor
	{
		/**
		 * process : q : Save graphics state.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			context.getGraphicsStack().push( context.getGraphicsState().clone() );
		}

	}
}