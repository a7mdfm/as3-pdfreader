package org.pdfbox.operator{

	import org.pdfbox.utils.Matrix2;
	import org.pdfbox.utils.PDFOperator;
	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.cos.COSString;

	/**
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class : the long sequence of 
	 *    conditions in processOperator is remplaced by this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.6 $
	 */

	public class ShowTextGlyph extends OperatorProcessor 
	{
		/**
		 * TJ Show text, allowing individual glyph positioning.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 * @throws IOException If there is an error processing this operator.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			var array:COSArray = arguments.get( 0 ) as COSArray;
			var adjustment:Number=0;
			for( var i:int=0; i<array.size(); i++ )
			{
				var next:COSBase = array.get( i ) as COSBase;
				if( next is COSNumber )
				{
					adjustment = (next as COSNumber).floatValue();

					var adjMatrix:Matrix2 = new Matrix2();
					adjustment=(-adjustment/1000)*context.getGraphicsState().getTextState().getFontSize() *
						(context.getGraphicsState().getTextState().getHorizontalScalingPercent()/100);
					adjMatrix.setValue( 2, 0, adjustment );
					context.setTextMatrix( adjMatrix.multiply( context.getTextMatrix() ) );
				}
				else if( next is COSString )
				{
					context.showString( (next as COSString).getBytes() );
				}
				else
				{
					throw new Error( "Unknown type in array for TJ operation:" + next );
				}
			}
		}

	}
}
