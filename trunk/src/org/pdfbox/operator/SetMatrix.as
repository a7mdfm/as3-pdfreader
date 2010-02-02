package org.pdfbox.operator{

	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.utils.Matrix2;
	import org.pdfbox.utils.PDFOperator;

	/**
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class : the long sequence of conditions 
	 *    in processOperator is remplaced by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.4 $
	 */

	public class SetMatrix extends OperatorProcessor 
	{

		/**
		 * Tm Set text matrix and text line matrix.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			//Set text matrix and text line matrix
			var a:COSNumber = arguments.get( 0 ) as COSNumber;
			var b:COSNumber = arguments.get( 1 ) as COSNumber;
			var c:COSNumber = arguments.get( 2 ) as COSNumber;
			var d:COSNumber = arguments.get( 3 ) as COSNumber;
			var e:COSNumber = arguments.get( 4 ) as COSNumber;
			var f:COSNumber = arguments.get( 5 ) as COSNumber;

			var textMatrix:Matrix2 = new Matrix2();
			textMatrix.setValue( 0, 0, a.floatValue() );
			textMatrix.setValue( 0, 1, b.floatValue() );
			textMatrix.setValue( 1, 0, c.floatValue() );
			textMatrix.setValue( 1, 1, d.floatValue() );
			textMatrix.setValue( 2, 0, e.floatValue() );
			textMatrix.setValue( 2, 1, f.floatValue() );
			context.setTextMatrix( textMatrix );
			context.setTextLineMatrix( textMatrix.copy() );
		}
	}
}