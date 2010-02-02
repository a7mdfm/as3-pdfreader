package org.pdfbox.operator{

import org.pdfbox.cos.COSNumber;
import org.pdfbox.utils.Matrix2;
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
 * @version $Revision: 1.4 $
 */
public class MoveText extends OperatorProcessor 
{

    /**
     * process : Td : Move text position.
     * @param operator The operator that is being executed.
     * @param arguments List
     */
    override public function process( operator:PDFOperator, arguments:Array):void 
    {
        var x:COSNumber = arguments.get( 0 ) as COSNumber;
        var y:COSNumber = arguments.get( 1 ) as COSNumber;
        var td:Matrix2 = new Matrix2();
        td.setValue( 2, 0, x.floatValue() );//.* textMatrix.getValue(0,0) );
        td.setValue( 2, 1, y.floatValue() );//* textMatrix.getValue(1,1) );
        //log.debug( "textLineMatrix before " + textLineMatrix );
        context.setTextLineMatrix( td.multiply( context.getTextLineMatrix() ) ); //textLineMatrix.multiply( td );
        //log.debug( "textLineMatrix after " + textLineMatrix );
        context.setTextMatrix( context.getTextLineMatrix().copy() );
    }
}
}
