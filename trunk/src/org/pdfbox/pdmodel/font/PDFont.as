package org.pdfbox.pdmodel.font
{

import org.pdfbox.cos.COSArray;
import org.pdfbox.cos.COSBase;
import org.pdfbox.cos.COSDictionary;
import org.pdfbox.cos.COSFloat;
import org.pdfbox.cos.COSName;
import org.pdfbox.cos.COSNumber;
import org.pdfbox.cos.COSStream;

import org.pdfbox.utils.HashMap;

//import org.pdfbox.pdmodel.common.COSArrayList;
import org.pdfbox.pdmodel.common.COSObjectable;
//import org.pdfbox.pdmodel.common.PDMatrix;
import org.pdfbox.pdmodel.common.PDFRectangle;



/**
 * This is the base class for all PDF fonts.
 *
 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
 * @version $Revision: 1.43 $
 */
public class PDFont implements COSObjectable
{

    /**
     * The cos dictionary for this font.
     */
    protected var font:COSDictionary;

    /**
     * This is only used if this is a font object and it has an encoding.
     */
    //private var fontEncoding:Encoding = null;
    /**
     * This is only used if this is a font object and it has an encoding and it is
     * a type0 font with a cmap.
     */
    //private var cmap:CMap = null;

    private static var afmResources:HashMap = new HashMap();
    private static var cmapObjects:HashMap = new HashMap();
    private static var afmObjects:HashMap = new HashMap();
    private static var cmapSubstitutions:HashMap = new HashMap();
	

    /**
     * This will clear AFM resources that are stored statically.
     * This is usually not a problem unless you want to reclaim
     * resources for a long running process.
     *
     * SPECIAL NOTE: The font calculations are currently in COSObject, which
     * is where they will reside until PDFont is mature enough to take them over.
     * PDFont is the appropriate place for them and not in COSObject but we need font
     * calculations for text extractaion.  THIS METHOD WILL BE MOVED OR REMOVED
     * TO ANOTHER LOCATION IN A FUTURE VERSION OF PDFBOX.
     */
    public static function clearResources():void
    {
        afmObjects.clear();
        cmapObjects.clear();
    }

    /**
     * Constructor.
     *
     * @param fontDictionary The font dictionary according to the PDF specification.
     */
    public function PDFont( fontDictionary:COSDictionary = null )
    {
        if (fontDictionary) {
			font = fontDictionary;
		}else {
			font = new COSDictionary();
			font.setItem( COSName.TYPE, COSName.FONT );
		}
       
    }

    /**
     * {@inheritDoc}
     */
    public function getCOSObject():COSBase
    {
        return font;
    }
}
}