package org.pdfbox.operator{

	import org.pdfbox.cos.COSFloat;
	import org.pdfbox.utils.PDFOperator;

	/**
	 *
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class : the long sequence of 
	 *    conditions in processOperator is remplaced by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.5 $
	 */
	public class NextLine extends OperatorProcessor 
	{
		/**
		 * process : T* Move to start of next text line.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 *
		 * @throws IOException If there is an error during processing.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void {
			//move to start of next text line
			var args:Array = new Array();
			args.push(new COSFloat(0.0));
			// this must be -leading instead of just leading as written in the 
			// specification (p.369) the acrobat reader seems to implement it the same way
			args.push(new COSFloat(-1*context.getGraphicsState().getTextState().getLeading()));
			// use Td instead of repeating code
			context.processOperator("Td", args);
			
		}
	}
}