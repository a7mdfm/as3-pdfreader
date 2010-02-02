package org.pdfbox.operator{

	import org.pdfbox.utils.Matrix2;
	import org.pdfbox.utils.PDFOperator;

	/**
	 *
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class :
	* the long sequence of conditions in processOperator is remplaced
	* by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.5 $
	 */
	public class BeginText extends OperatorProcessor
	{

		/**
		 * process : BT : Begin text object.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 */
		override public function process( operator:PDFOperator, arguments:Array):void {
			context.setTextMatrix( new Matrix2());
			context.setTextLineMatrix( new Matrix2() );
		}
	}

}
