package org.pdfbox.pdmodel.interactive.pagenavigation
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;

	import org.pdfbox.pdmodel.PDFDocumentInformation;
	import org.pdfbox.pdmodel.common.COSObjectable;

	/**
	 * This a single thread in a PDF document.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.2 $
	 */
	public class PDFThread implements COSObjectable
	{
		
		
		private var thread:COSDictionary;

		/**
		 * Constructor that is used for a preexisting dictionary.
		 *
		 * @param t The underlying dictionary.
		 */
		public function PDFThread( t:COSDictionary = null )
		{
			if ( t == null ) {
				thread = new COSDictionary();
				thread.setName( "Type", "Thread" );
			}else {
				thread = t;
			}
		}
		
		/**
		 * This will get the underlying dictionary that this object wraps.
		 *
		 * @return The underlying info dictionary.
		 */
		public function getDictionary():COSDictionary
		{
			return thread;
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return thread;
		}
		
		/**
		 * Get info about the thread, or null if there is nothing.
		 * 
		 * @return The thread information.
		 */
		public function getThreadInfo():PDFDocumentInformation
		{
			var retval:PDFDocumentInformation = null;
			var info:COSDictionary = thread.getDictionaryObject( "I" ) as COSDictionary;
			if( info != null )
			{
				retval = new PDFDocumentInformation( info );
			}
			
			return retval;
		}
		
		/**
		 * Set the thread info, can be null.
		 * 
		 * @param info The info dictionary about this thread.
		 */
		public function setThreadInfo( info:PDFDocumentInformation ):void
		{
			thread.setItem( "I", info );
		}
		
		/**
		 * Get the first bead in the thread, or null if it has not been set yet.  This
		 * is a required field for this object.
		 * 
		 * @return The first bead in the thread.
		 */
		public function getFirstBead():PDFThreadBead
		{
			var retval:PDFThreadBead = null;
			var bead:COSDictionary = thread.getDictionaryObject( "F" ) as COSDictionary;
			if( bead != null )
			{
				retval = new PDFThreadBead( bead );
			}
			
			return retval;
		}
		
		/**
		 * This will set the first bead in the thread.  When this is set it will
		 * also set the thread property of the bead object.  
		 * 
		 * @param bead The first bead in the thread.
		 */
		public function setFirstBead( bead:PDFThreadBead ):void
		{
			if( bead != null )
			{
				bead.setThread( this );
			}
			thread.setItem( "F", bead );
		}
		
		
	}
}