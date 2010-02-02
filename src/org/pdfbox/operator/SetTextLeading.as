package org.pdfbox.operator{

	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.utils.PDFOperator;

	/**
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class :
	*  the long sequence of conditions in processOperator is remplaced
	* by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.4 $
	 */

	public class SetTextLeading extends OperatorProcessor 
	{
		/**
		 * TL Set text leading.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			var leading:COSNumber = arguments.get( 0 ) as COSNumber;
			context.getGraphicsState().getTextState().setLeading( leading.floatValue() );
		}

	}
}
