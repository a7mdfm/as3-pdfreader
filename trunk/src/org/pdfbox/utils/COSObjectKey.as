package org.pdfbox.utils
{

	import org.pdfbox.cos.COSObject;

	/**
	 * Object representing the physical reference to an indirect pdf object.
	 */
	public class COSObjectKey
	{
	    private var number:Number;
	    private var generation:Number;

	    /*
	    public COSObjectKey(COSObject object)
	    {
		this( object.getObjectNumber().longValue(), object.getGenerationNumber().longValue() );
	    }
	    */
	    
	    /**
	     * PDFObjectKey constructor comment.
	     *
	     * @param num The object number.
	     * @param gen The object generation number.
	     */
	    public function COSObjectKey(num:Number, gen:Number)
	    {
			setNumber(num);
			setGeneration(gen);
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function equals( obj:Object ):Boolean
	    {
			return (obj is COSObjectKey) &&  COSObjectKey(obj).getNumber() == getNumber() &&  COSObjectKey(obj).getGeneration() == getGeneration();
	    }

	    /**
	     * This will get the generation number.
	     *
	     * @return The objects generation number.
	     */
	    public function getGeneration():Number
	    {
			return generation;
	    }
	    /**
	     * This will get the objects id.
	     *
	     * @return The object's id.
	     */
	    public function getNumber():Number
	    {
			return number;
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function hashCode():int
	    {
			return int(number + generation);
	    }
	    /**
	     * This will set the objects generation number.
	     *
	     * @param newGeneration The objects generation number.
	     */
	    public function setGeneration(newGeneration:Number):void
	    {
			generation = newGeneration;
	    }
	    /**
	     * This will set the objects id.
	     *
	     * @param newNumber The objects number.
	     */
	    public function setNumber(newNumber:Number):void
	    {
			number = newNumber;
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function toString():String
	    {
			return "" + getNumber() + " " + getGeneration() + " R";
	    }
    }
}