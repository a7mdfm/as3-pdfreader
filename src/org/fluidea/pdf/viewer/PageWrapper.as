package org.fluidea.pdf.viewer
{

	import org.fluidea.pdf.PDFReader;
	import org.pdfbox.pdmodel.PDFPage;

	/**
	 * A class to handle some prettyness around a single PDF page.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.5 $
	 */
	public class PageWrapper 
	{
	    private JPanel pageWrapper = new JPanel();
	    private PDFPagePanel pagePanel = null;
	    private var reader:PDFReader = null;

	    private static final int SPACE_AROUND_DOCUMENT = 20;

	    /**
	     * Constructor.
	     * 
	     * @param aReader The reader application that holds this page.
	     * 
	     * @throws IOException If there is an error creating the page drawing objects.
	     */
	    public PageWrapper( PDFReader aReader ) throws IOException
	    {
			reader = aReader;
			pagePanel = new PDFPagePanel();
			pageWrapper.setLayout( null );
			pageWrapper.add( pagePanel );
			pagePanel.setLocation( SPACE_AROUND_DOCUMENT, SPACE_AROUND_DOCUMENT );
			pageWrapper.setBorder( javax.swing.border.LineBorder.createBlackLineBorder() );
			pagePanel.addMouseMotionListener( this );
	    }

	    /**
	     * This will display the PDF page in this component.
	     *
	     * @param page The PDF page to display.
	     */
	    public void displayPage( PDPage page )
	    {
			pagePanel.setPage( page );
			pagePanel.setPreferredSize( pagePanel.getSize() );
			Dimension d = pagePanel.getSize();
			d.width+=(SPACE_AROUND_DOCUMENT*2);
			d.height+=(SPACE_AROUND_DOCUMENT*2);

			pageWrapper.setPreferredSize( d );
			pageWrapper.validate();
	    }

	    /**
	     * This will get the JPanel that can be displayed.
	     *
	     * @return The panel with the displayed PDF page.
	     */
	    public JPanel getPanel()
	    {
		return pageWrapper;
	    }
	    
	    /**
	     * {@inheritDoc}
	     */
	    public void mouseDragged(MouseEvent e)
	    {
		//do nothing when mouse moves.
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public void mouseMoved(MouseEvent e)
	    {
		//reader.getBottomStatusPanel().getStatusLabel().setText( e.getX() + "," + (pagePanel.getHeight() - e.getY()) );
		reader.getBottomStatusPanel().getStatusLabel().setText( e.getX() + "," + e.getY() );
	    }
	}
}