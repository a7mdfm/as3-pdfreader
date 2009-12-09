package org.pdfbox.pdmodel.graphics
{

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSInteger;
	import org.pdfbox.cos.COSNumber;

	import org.pdfbox.pdmodel.common.COSArrayList;
	import org.pdfbox.pdmodel.common.COSObjectable;

	import org.pdfbox.utils.List;

	/**
	 * This class represents the line dash pattern for a graphics state.  See PDF
	 * Reference 1.5 section 4.3.2
	 */
	public class PDFLineDashPattern implements COSObjectable
	{
	    private var lineDashPattern:COSArray = null;

	    /**
	     * Creates a blank line dash pattern.  With no dashes and a phase of 0.
	     */
	    public function PDFLineDashPattern( ldp:COSArray = null )
	    {
			if( ldp == null ){
				lineDashPattern = new COSArray();
				lineDashPattern.add( new COSArray() );
				lineDashPattern.add( new COSInteger( 0 ) );
			}else{
				lineDashPattern = ldp;
			}
	    }

	    /**
	     * Constructs a line dash pattern from an existing array.
	     *
	     * @param ldp The existing line dash pattern.
	     *
	    public PDLineDashPattern( COSArray ldp = null )
	    {
			lineDashPattern = ldp;
	    }
	    
	    /**
	     * Constructs a line dash pattern from an existing array.
	     *
	     * @param ldp The existing line dash pattern.
	     * @param phase The phase for the line dash pattern.
	     *
	    public PDLineDashPattern( COSArray ldp, int phase )
	    {
			lineDashPattern = new COSArray();
			lineDashPattern.add( ldp );
			lineDashPattern.add( new COSInteger( phase ) );
	    }
	    */

	    /**
	     * {@inheritDoc}
	     */
	    public function getCOSObject():COSBase
	    {
			return lineDashPattern;
	    }

	    /**
	     * This will get the line dash pattern phase.  The dash phase specifies the
	     * distance into the dash pattern at which to start the dash.
	     *
	     * @return The line dash pattern phase.
	     */
	    public function getPhaseStart():int
	    {
			var phase:COSNumber = lineDashPattern.get( 1 ) as COSNumber;
			return phase.intValue();
	    }

	    /**
	     * This will set the line dash pattern phase.
	     *
	     * @param phase The new line dash patter phase.
	     */
	    public function setPhaseStart( phase:int ):void
	    {
			lineDashPattern.set( 1, new COSInteger( phase ) );
	    }

	    /**
	     * This will return a list of java.lang.Integer objects that represent the line
	     * dash pattern appearance.
	     *
	     * @return The line dash pattern.
	     */
	    public function getDashPattern():List
	    {
			var dashPatterns:COSArray = lineDashPattern.get( 0 ) as COSArray;
			return COSArrayList.convertIntegerCOSArrayToList( dashPatterns );
	    }
	    
	    /**
	     * Get the line dash pattern as a COS object.
	     * 
	     * @return The cos array line dash pattern.
	     */
	    public function getCOSDashPattern():COSArray
	    {
			return lineDashPattern.get( 0 ) as COSArray;
	    }

	    /**
	     * This will replace the existing line dash pattern.
	     *
	     * @param dashPattern A list of java.lang.Integer objects.
	     */
	    public function setDashPattern( dashPattern:List ):void
	    {
			lineDashPattern.set( 0, COSArrayList.converterToCOSArray( dashPattern ) );
	    }
	}
}