package org.pdfbox.operator{

	import org.pdfbox.cos.COSNumber;
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
	public class SetCharSpacing extends OperatorProcessor 
	{
		/**
		 * process : Tc Set character spacing.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			//set character spacing
			if( arguments.size() > 0 )
			{
				//There are some documents which are incorrectly structured, and have
				//a wrong number of arguments to this, so we will assume the last argument 
				//in the list
				var charSpacing:Object = arguments.get( arguments.size()-1 );
				if( charSpacing is COSNumber )
				{
					var characterSpacing:COSNumber = charSpacing as COSNumber;
					context.getGraphicsState().getTextState().setCharacterSpacing( characterSpacing.floatValue() );
				}
			}
		}
	}
}
