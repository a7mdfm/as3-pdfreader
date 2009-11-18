package org.pdfbox.pdmodel.common
{

	import org.pdfbox.cos.COSBase;

	/**
	 * This is an interface to represent a PDModel object that holds two COS objects.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.2 $
	 */
	public interface DualCOSObjectable
	{
	    /**
	     * Convert this standard java object to a COS object.
	     *
	     * @return The cos object that matches this Java object.
	     */
	    function getFirstCOSObject():COSBase;

	    /**
	     * Convert this standard java object to a COS object.
	     *
	     * @return The cos object that matches this Java object.
	     */
	    function getSecondCOSObject():COSBase;
	}

}