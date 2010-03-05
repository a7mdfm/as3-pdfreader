package org.pdfbox.utils
{


	import org.pdfbox.pdmodel.PDFPage;

	/**
	 * This class is a comparator for TextPosition operators.
	 */
	public class TextPositionComparator
	{
		private var thePage:PDFPage;
		
		/**
		 * Constuctor, comparison of TextPosition depends on the rotation
		 * of the page.
		 * @param page The page that the text position is on.
		 */
		public function TextPositionComparator( page:PDFPage )
		{
			thePage = page;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public function compare(o1:*, o2:*):int
		{
			return 0;
			/*int retval = 0;
			TextPosition pos1 = (TextPosition)o1;
			TextPosition pos2 = (TextPosition)o2;
			int rotation = thePage.findRotation();
			float x1 = 0;
			float x2 = 0;
			float pos1YBottom = 0;
			float pos2YBottom = 0;
			if( rotation == 0 )
			{
				x1 = pos1.getX();
				x2 = pos2.getX();
				pos1YBottom = pos1.getY();
				pos2YBottom = pos2.getY();
			}
			else if( rotation == 90 )
			{
				x1 = pos1.getY();
				x2 = pos2.getX();
				pos1YBottom = pos1.getX();
				pos2YBottom = pos2.getY();
			}
			else if( rotation == 180 )
			{
				x1 = -pos1.getX();
				x2 = -pos2.getX();
				pos1YBottom = -pos1.getY();
				pos2YBottom = -pos2.getY();
			}
			else if( rotation == 270 )
			{
				x1 = -pos1.getY();
				x2 = -pos2.getY();
				pos1YBottom = -pos1.getX();
				pos2YBottom = -pos2.getX();
			}
			float pos1YTop = pos1YBottom - pos1.getHeight();
			float pos2YTop = pos2YBottom - pos2.getHeight();

			float yDifference = Math.abs( pos1YBottom-pos2YBottom);
			//we will do a simple tolerance comparison.
			if( yDifference < .1 || 
				(pos2YBottom >= pos1YTop && pos2YBottom <= pos1YBottom) ||
				(pos1YBottom >= pos2YTop && pos1YBottom <= pos2YBottom))
			{
				if( x1 < x2 )
				{
					retval = -1;
				}
				else if( x1 > x2 )
				{
					retval = 1;
				}
				else
				{
					retval = 0;
				}
			}
			else if( pos1YBottom < pos2YBottom )
			{
				retval = -1;
			}
			else
			{
				return 1;
			}
			
			return retval;*/
		}
	}
    
}