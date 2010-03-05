package org.pdfbox.operator{


	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.pdmodel.font.PDFont;
	import org.pdfbox.utils.PDFOperator;

	/**
	 * <p>Titre : PDFEngine Modification.</p>
	 * <p>Description : Structal modification of the PDFEngine class :
	 * the long sequence of conditions in processOperator is remplaced by
	 * this strategy pattern</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Sociét?: DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.5 $
	 */

	public class SetTextFont extends OperatorProcessor 
	{
		/**
		 * Tf selectfont Set text font and size.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 * @throws IOException If an error occurs while processing the font.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void
		{
			//there are some documents that are incorrectly structured and 
			//arguments are in the wrong spot, so we will silently ignore them
			//if there are no arguments
			if( arguments.length >= 2 )
			{
				//set font and size
				var fontName:COSName = arguments[ 0 ] as COSName;
				var fontSize:Number = (arguments[ 1 ] as COSNumber ).floatValue();
				context.getGraphicsState().getTextState().setFontSize( fontSize );
		
				//old way
				//graphicsState.getTextState().getFont() = (COSObject)stream.getDictionaryObject( fontName );
				//if( graphicsState.getTextState().getFont() == null )
				//{
				//    graphicsState.getTextState().getFont() = (COSObject)graphicsState.getTextState().getFont()
				//                                           Dictionary.getItem( fontName );
				//}
				trace(context.getFonts());
				context.getGraphicsState().getTextState().setFont( context.getFonts().get( fontName.getName() ) as PDFont );
				if( context.getGraphicsState().getTextState().getFont() == null )
				{
					throw new Error( "Error: Could not find font(" + fontName + ") in map=" + context.getFonts() );
				}
			}
		}

	}
}
