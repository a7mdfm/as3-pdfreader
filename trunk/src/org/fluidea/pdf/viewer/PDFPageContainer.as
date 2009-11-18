package org.fluidea.pdf.viewer
{
	import flash.display.Sprite;
	
	import org.pdfbox.pdmodel.PDFPage;

	import org.pdfbox.pdmodel.common.PDFRectangle;

	/**
	 * This is a simple JPanel that can be used to display a PDF page.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.4 $
	 */
	public class PDFPageContainer extends Sprite
	{

		private var page:PDFPage;
		private PageDrawer drawer = null;
		private Dimension pageDimension = null;

		/**
		 * Constructor.
		 * 
		 * @throws IOException If there is an error creating the Page drawing objects.
		 */
		public function PDFPageContainer()
		{
			drawer = new PageDrawer();
		}

		/**
		 * This will set the page that should be displayed in this panel.
		 *
		 * @param pdfPage The page to draw.
		 */
		public void setPage( PDPage pdfPage )
		{
			page = pdfPage;
			PDRectangle pageSize = page.findMediaBox();
			int rotation = page.findRotation();
			pageDimension = pageSize.createDimension();
			if( rotation == 90 || rotation == 270 )
			{
				pageDimension = new Dimension( pageDimension.height, pageDimension.width );
			}
			setSize( pageDimension );
			setBackground( java.awt.Color.white );
		}

		/**
		 * {@inheritDoc}
		 */
		public void paint(Graphics g )
		{
			try
			{
				g.setColor( getBackground() );
				g.fillRect( 0, 0, getWidth(), getHeight() );
				drawer.drawPage( g, page, pageDimension );
			}
			catch( IOException e )
			{
				e.printStackTrace();
			}
		}
	}
}