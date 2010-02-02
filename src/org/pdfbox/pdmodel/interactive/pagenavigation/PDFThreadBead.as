package org.pdfbox.pdmodel.interactive.pagenavigation{

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;

	import org.pdfbox.pdmodel.PDFPage;
	import org.pdfbox.pdmodel.common.COSObjectable;
	import org.pdfbox.pdmodel.common.PDFRectangle;

	/**
	 * This a single bead in a thread in a PDF document.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.4 $
	 */
	public class PDFThreadBead implements COSObjectable
	{
		
		
		private var bead:COSDictionary;

		/**
		 * Constructor that is used for a preexisting dictionary.
		 *
		 * @param b The underlying dictionary.
		 */
		public function PDFThreadBead( b:COSDictionary = null )
		{
			if ( b == null ) {
				bead = new COSDictionary();
				bead.setName( "Type", "Bead" );
				setNextBead( this );
				setPreviousBead( this );
			}else {
				bead = b;
			}
		}

		/**
		 * This will get the underlying dictionary that this object wraps.
		 *
		 * @return The underlying info dictionary.
		 */
		public function getDictionary():COSDictionary
		{
			return bead;
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return bead;
		}
		
		/**
		 * This will get the thread that this bead is part of.  This is only required
		 * for the first bead in a thread, so other beads 'may' return null.
		 * 
		 * @return The thread that this bead is part of.
		 */
		public function getThread():PDFThread
		{
			var retval:PDFThread = null;
			var dic:COSDictionary = bead.getDictionaryObject( "T" ) as COSDictionary;
			if( dic != null )
			{
				retval = new PDFThread( dic );
			}
			return retval;
		}
		
		/**
		 * Set the thread that this bead is part of.  This is only required for the
		 * first bead in a thread.  Note: This property is set for you by the PDThread.setFirstBead() method.
		 * 
		 * @param thread The thread that this bead is part of.
		 */
		public function setThread( thread:PDFThread ):void
		{
			bead.setItem( "T", thread );
		}
		
		/**
		 * This will get the next bead.  If this bead is the last bead in the list then this
		 * will return the first bead. 
		 * 
		 * @return The next bead in the list or the first bead if this is the last bead.
		 */
		public function getNextBead():PDFThreadBead
		{
			return new PDFThreadBead(  bead.getDictionaryObject( "N" ) as COSDictionary );
		}
		
		/**
		 * Set the next bead in the thread.
		 * 
		 * @param next The next bead.
		 */
		protected function setNextBead( next:PDFThreadBead ):void
		{
			bead.setItem( "N", next );
		}
		
		/**
		 * This will get the previous bead.  If this bead is the first bead in the list then this
		 * will return the last bead. 
		 * 
		 * @return The previous bead in the list or the last bead if this is the first bead.
		 */
		public function getPreviousBead():PDFThreadBead
		{
			return new PDFThreadBead( bead.getDictionaryObject( "V" ) as COSDictionary );
		}
		
		/**
		 * Set the previous bead in the thread.
		 * 
		 * @param previous The previous bead.
		 */
		protected function setPreviousBead( previous:PDFThreadBead ):void
		{
			bead.setItem( "V", previous );
		}
		
		/**
		 * Append a bead after this bead.  This will correctly set the next/previous beads in the
		 * linked list.
		 * 
		 * @param append The bead to insert.
		 */
		public function appendBead( append:PDFThreadBead ):void
		{
			var nextBead:PDFThreadBead = getNextBead();
			nextBead.setPreviousBead( append );
			append.setNextBead( nextBead );
			setNextBead( append );
			append.setPreviousBead( this );
		}
		
		/**
		 * Get the page that this bead is part of.
		 * 
		 * @return The page that this bead is part of.
		 */
		public function getPage():PDFPage
		{
			var page:PDFPage = null;
			var dic:COSDictionary = bead.getDictionaryObject( "P" ) as COSDictionary;
			if( dic != null )
			{
				page = new PDFPage( dic );
			}
			return page;
		}
		
		/**
		 * Set the page that this bead is part of.  This is a required property and must be
		 * set when creating a new bead.  The PDPage object also has a list of beads in the natural
		 * reading order.  It is recommended that you add this object to that list as well.
		 * 
		 * @param page The page that this bead is on.
		 */
		public function setPage( page:PDFPage ):void
		{
			bead.setItem( "P", page );
		}
		
		/**
		 * The rectangle on the page that this bead is part of.
		 * 
		 * @return The part of the page that this bead covers.
		 */
		public function getRectangle():PDFRectangle
		{
			var rect:PDFRectangle = null;
			var array:COSArray = bead.getDictionaryObject( COSName.R ) as COSArray; 
			if( array != null )
			{
				rect = new PDFRectangle();
				rect.setCOSArray( array );
			}
			return rect;
		}
		
		/**
		 * Set the rectangle on the page that this bead covers.
		 * 
		 * @param rect The portion of the page that this bead covers.
		 */
		public function setRectangle( rect:PDFRectangle ):void
		{
			bead.setItem( COSName.R, rect );
		}
	}
}