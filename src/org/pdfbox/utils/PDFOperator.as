package org.pdfbox.utils
{
	import flash.utils.ByteArray;
	/**
	 * This class represents an Operator in the content stream.
	 */
	public class PDFOperator
	{
	    private var theOperator:String;
	    private var imageData:ByteArray;
	    private var imageParameters:ImageParameters;

	    private static var operators:HashMap = new HashMap();

	    /**
	     * Constructor.
	     *
	     * @param aOperator The operator that this object will represent.
	     */
	    public function PDFOperator( aOperator:String )
	    {
			theOperator = aOperator;
			if( aOperator.substr(0,1) == "/" )
			{
				throw( "Operators are not allowed to start with / '" + aOperator + "'" );
			}
	    }

	    /**
	     * This is used to create/cache operators in the system.
	     *
	     * @param operator The operator for the system.
	     *
	     * @return The operator that matches the operator keyword.
	     */
	    public static function getOperator( operator:String ):PDFOperator
	    {
			var operation:PDFOperator = null;
			if( operator == "ID" || operator == "BI" )
			{
				//we can't cache the ID operators.
				operation = new PDFOperator( operator );
			}
			else
			{
				operation = operators.get( operator ) as PDFOperator;
				if( operation == null )
				{
					operation = new PDFOperator( operator );
					operators.put( operator, operation );
				}
			}

			return operation;
	    }

	    /**
	     * This will get the operation that this operator represents.
	     *
	     * @return The string representation of the operation.
	     */
	    public function getOperation():String
	    {
			return theOperator;
	    }

	    /**
	     * This will print a string rep of this class.
	     *
	     * @return A string rep of this class.
	     */
	    public function toString():String
	    {
			return "[ PDFOperator >> " + theOperator + " ]";
	    }

	    /**
	     * This is the special case for the ID operator where there are just random
	     * bytes inlined the stream.
	     *
	     * @return Value of property imageData.
	     */
	    public function getImageData():ByteArray
	    {
			return this.imageData;
	    }

	    /**
	     * This will set the image data, this is only used for the ID operator.
	     *
	     * @param imageDataArray New value of property imageData.
	     */
	    public function setImageData( imageDataArray:ByteArray):void
	    {
			imageData = imageDataArray;
	    }

	    /**
	     * This will get the image parameters, this is only valid for BI operators.
	     *
	     * @return The image parameters.
	     */
	    public function getImageParameters():ImageParameters
	    {
			return imageParameters;
	    }

	    /**
	     * This will set the image parameters, this is only valid for BI operators.
	     *
	     * @param params The image parameters.
	     */
	    public function setImageParameters( params:ImageParameters):void
	    {
			imageParameters = params;
	    }
	}
}