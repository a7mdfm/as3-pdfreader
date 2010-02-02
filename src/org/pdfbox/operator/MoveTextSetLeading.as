package org.pdfbox.operator{


	import org.pdfbox.cos.COSFloat;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.utils.ArrayList;
	import org.pdfbox.utils.PDFOperator;

	/**
	 *
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class :
	 * the long sequence of conditions in processOperator is remplaced by
	 * this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.5 $
	 */
	public class MoveTextSetLeading extends OperatorProcessor 
	{

		/**
		 * process : TD Move text position and set leading.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 *
		 * @throws IOException If there is an error during processing.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void{
			//move text position and set leading
			var y:COSNumber = arguments.get( 1 ) as COSNumber;
			
			var args:ArrayList = new ArrayList();
			args.add(new COSFloat(-1*y.floatValue()));
			context.processOperator("TL", args);
			context.processOperator("Td", arguments);

		}
	}
}
