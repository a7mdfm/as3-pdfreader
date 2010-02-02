package org.pdfbox.operator{


	import org.pdfbox.cos.COSString;
	import org.pdfbox.utils.PDFOperator;

	/**
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class :
	 * the long sequence of conditions in processOperator
	 * is remplaced by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.4 $
	 */

	public class ShowText extends OperatorProcessor 
	{

		/**
		 * Tj show Show text.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 *
		 * @throws IOException If there is an error processing this operator.
		 */
		override public function process( operator:PDFOperator, arguments:Array) :void
		{
			var string:COSString = arguments.get( 0 ) as COSString;
			context.showString( string.getBytes() );
		}

	}
}
