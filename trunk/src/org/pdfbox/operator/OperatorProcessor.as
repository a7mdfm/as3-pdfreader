package org.pdfbox.operator
{

	import org.pdfbox.utils.PDFOperator;
	import org.pdfbox.tools.PDFStreamEngine;

	/**
	 *
	 * <p>Titre : OperatorProcessor</p>
	 * <p>Description : This class is the strategy abstract class
	 * in the strategy GOF pattern. After instancated, you must ever call
	* the setContext method to initiamise OPeratorProcessor</p>
	 * <p>Copyright : Copyright (c) 2004</p>
	 * <p>Socit : DBGS</p>
	 * @author Huault : huault@free.fr
	 * @version $Revision: 1.3 $
	 */
	public class OperatorProcessor 
	{

	    /**
	     * The stream engine processing context.
	     */
	    protected var context:PDFStreamEngine = null;


	    /**
	     * Get the context for processing.
	     * 
	     * @return The processing context.
	     */
	    protected function getContext():PDFStreamEngine
	    {
			return context;
	    }

	    /**
	     * Set the processing context.
	     * 
	     * @param ctx The context for processing.
	     */
	    public function setContext(ctx:PDFStreamEngine):void
	    {
			context = ctx;
	    }

	    /**
	     * process the operator.
	     * @param operator The operator that is being processed.
	     * @param arguments arguments needed by this operator.
	     *
	     * @throws IOException If there is an error processing the operator.
	     */
	    public function process( operator:PDFOperator, arguments:Array):void 
		{
			
		}
	}
}
