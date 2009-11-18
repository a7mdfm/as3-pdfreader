package org.pdfbox.pdmodel
{


	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSStream;
	import org.pdfbox.cos.COSString;

	import org.pdfbox.pdmodel.common.COSObjectable;


	/**
	 * This class represents the acroform of a PDF document.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.21 $
	 */
	public class PDFDocumentCatalog implements COSObjectable
	{
	    private var root:COSDictionary;
	    private var document:PDFDocument;

	    //private var acroForm:PDAcroForm = null;
	    
	    /**
	     * Page mode where neither the outline nor the thumbnails
	     * are displayed.
	     */
	    public static const PAGE_MODE_USE_NONE:String = "UseNone";
	    /**
	     * Show bookmarks when pdf is opened.
	     */
	    public static const PAGE_MODE_USE_OUTLINES:String = "UseOutlines";
	    /**
	     * Show thumbnails when pdf is opened.
	     */
	    public static const PAGE_MODE_USE_THUMBS:String = "UseThumbs";
	    /**
	     * Full screen mode with no menu bar, window controls.
	     */
	    public static const PAGE_MODE_FULL_SCREEN:String = "FullScreen";
	    /**
	     * Optional content group panel is visible when opened.
	     */
	    public static const PAGE_MODE_USE_OPTIONAL_CONTENT:String = "UseOC";
	    /**
	     * Attachments panel is visible.
	     */
	    public static const PAGE_MODE_USE_ATTACHMENTS:String = "UseAttachments";
	    
	    /**
	     * Display one page at a time.
	     */
	    public static const PAGE_LAYOUT_SINGLE_PAGE:String = "SinglePage";
	    /**
	     * Display the pages in one column.
	     */
	    public static const PAGE_LAYOUT_ONE_COLUMN:String = "OneColumn";
	    /**
	     * Display the pages in two columns, with odd numbered pagse on the left.
	     */
	    public static const PAGE_LAYOUT_TWO_COLUMN_LEFT:String = "TwoColumnLeft";
	    /**
	     * Display the pages in two columns, with odd numbered pagse on the right.
	     */
	    public static const PAGE_LAYOUT_TWO_COLUMN_RIGHT:String ="TwoColumnRight";
	    /**
	     * Display the pages two at a time, with odd-numbered pages on the left.
	     * @since PDF Version 1.5
	     */
	    public static const PAGE_LAYOUT_TWO_PAGE_LEFT:String = "TwoPageLeft";
	    /**
	     * Display the pages two at a time, with odd-numbered pages on the right.
	     * @since PDF Version 1.5
	     */
	    public static const PAGE_LAYOUT_TWO_PAGE_RIGHT:String = "TwoPageRight";
	    
	    
	    
	    /**
	     * Constructor.
	     *
	     * @param doc The document that this catalog is part of.
	     */
	    public function PDFDocumentCatalog( doc:PDFDocument, rootDictionary:COSDictionary = null )
	    {
			document = doc;
			if( rootDictionary != null){
				root = rootDictionary;
			}else{
				root = new COSDictionary();
				root.setItem( COSName.TYPE, new COSString( "Catalog" ) );
				document.getDocument().getTrailer().setItem( COSName.ROOT, root );
			}
			//TODO
			//document.getDocument().getTrailer().setItem( COSName.ROOT, root );
	    }
	    
	    /**
	     * Convert this standard java object to a COS object.
	     *
	     * @return The cos object that matches this Java object.
	     */
	    public function getCOSObject():COSBase
	    {
			return root;
	    }

	    /**
	     * Convert this standard java object to a COS object.
	     *
	     * @return The cos object that matches this Java object.
	     */
	    public function getCOSDictionary():COSDictionary
	    {
			return root;
	    }

	    /**
	     * This will get the documents acroform.  This will return null if
	     * no acroform is part of the document.
	     *
	     * @return The documents acroform.
	     */
	    /*public function getAcroForm():PDFAcroForm
	    {
			if( acroForm == null )
			{
				COSDictionary acroFormDic =
				(COSDictionary)root.getDictionaryObject( COSName.ACRO_FORM );
				if( acroFormDic != null )
				{
				acroForm = new PDAcroForm( document, acroFormDic );
				}
			}
			return acroForm;
	    }*/
	    
	    /**
	     * Set the acro form for this catalog.
	     * 
	     * @param acro The new acro form.
	     */
	    /*public function setAcroForm( acro:PDAcroForm ):void
	    {
			root.setItem( COSName.ACRO_FORM, acro );
	    }*/

	    /**
	     * This will get the root node for the pages.
	     *
	     * @return The parent page node.
	     */
	    public function getPages():PDFPageNode
	    {
			return new PDFPageNode( root.getDictionaryObject( COSName.PAGES ) as COSDictionary );
	    }

	    /**
	     * The PDF document contains a hierarchical structure of PDPageNode and PDPages, which
	     * is mostly just a way to store this information.  This method will return a flat list
	     * of all PDPage objects in this document.
	     *
	     * @return A list of PDPage objects.
	     */
	    public function getAllPages():Array
	    {
			var retval:Array = new Array();
			var rootNode:PDFPageNode = getPages();
			//old (slower):
			//getPageObjects( rootNode, retval );
			rootNode.getAllKids(retval);
			return retval;
	    }
	    
	    /**
	     * Get the viewer preferences associated with this document or null if they
	     * do not exist.
	     * 
	     * @return The document's viewer preferences.
	     */
	   /* public function getViewerPreferences():PDViewerPreferences
	    {
			var retval:PDViewerPreferences = null;
			var dict:COSDictionary = COSDictionary(root).getDictionaryObject( "ViewerPreferences" );
			if( dict != null )
			{
				retval = new PDViewerPreferences( dict );
			}
			
			return retval;
	    }*/
	    
	    /**
	     * Set the viewer preferences.
	     * 
	     * @param prefs The new viewer preferences.
	     */
	    /*public function setViewerPreferences( prefs:PDViewerPreferences ):void
	    {
			root.setItem( "ViewerPreferences", prefs );
	    }*/
	    
	    /**
	     * Get the outline associated with this document or null if it
	     * does not exist.
	     * 
	     * @return The document's outline.
	     */
	    /*public function getDocumentOutline():PDDocumentOutline
	    {
			PDDocumentOutline retval = null;
			COSDictionary dict = (COSDictionary)root.getDictionaryObject( "Outlines" );
			if( dict != null )
			{
				retval = new PDDocumentOutline( dict );
			}
			
			return retval;
	    }*/
	    
	    /**
	     * Set the document outlines.
	     * 
	     * @param outlines The new document outlines.
	     */
	   /* public function setDocumentOutline( outlines:PDDocumentOutline ):void
	    {
			root.setItem( "Outlines", outlines );
	    }*/
	    
	    /**
	     * Get the list threads for this pdf document.
	     * 
	     * @return A list of PDThread objects.
	     */
	   /* public function getThreads():Array
	    {
			var array:COSArray = root.getDictionaryObject( "Threads" ) as COSArray;
			if( array == null )
			{
				array = new COSArray();
				root.setItem( "Threads", array );
			}
			List pdObjects = new ArrayList();
			for( int i=0; i<array.size(); i++ )
			{
				pdObjects.add( new PDThread( (COSDictionary)array.getObject( i ) ) );
			}
			return new COSArrayList( pdObjects, array );
	    }*/
	    
	    /**
	     * Set the list of threads for this pdf document.
	     * 
	     * @param threads The list of threads, or null to clear it.
	     */
	    /*public void setThreads( List threads )
	    {
			root.setItem( "Threads", COSArrayList.converterToCOSArray( threads ) );
	    }*/
	    
	    /**
	     * Get the metadata that is part of the document catalog.  This will 
	     * return null if there is no meta data for this object.
	     * 
	     * @return The metadata for this object.
	     */
	    /*public function getMetadata():PDMetadata
	    {
			var retval:PDMetadata = null;
			var stream:COSStream = root.getDictionaryObject( "Metadata" ) as COSStream;
			if( stream != null )
			{
				retval = new PDMetadata( stream );
			}
			return retval;
		}*/
	    
	    /**
	     * Set the metadata for this object.  This can be null.
	     * 
	     * @param meta The meta data for this object.
	     */
	    /*public function setMetadata( meta:PDMetadata ):void
	    {
			root.setItem( "Metadata", meta );
	    }*/
	    
	    /**
	     * Set the Document Open Action for this object.
	     * 
	     * @param action The action you want to perform.
	     */
	   /* public void setOpenAction( PDDestinationOrAction action )
	    {
			root.setItem( COSName.getPDFName("OpenAction"), action );
	    }*/

	    /**
	     * Get the Document Open Action for this object.
	     *
	     * @return The action to perform when the document is opened.
	     * 
	     * @throws IOException If there is an error creating the destination
	     * or action.
	     */
	   /* public PDDestinationOrAction getOpenAction() throws IOException
	    {
			PDDestinationOrAction action = null;
			COSBase actionObj = root.getDictionaryObject("OpenAction");
			
			if( actionObj == null )
			{
				//no op
			}
			else if( actionObj instanceof COSDictionary )
			{
				action = PDActionFactory.createAction((COSDictionary)actionObj);
			}
			else if( actionObj instanceof COSArray )
			{
				action = PDDestination.create( actionObj );
			}
			else
			{
				throw( "Unknown OpenAction " + actionObj );
			}
			
			return action;
	    }    */
	    /**
	     * @return The Additional Actions for this Document 
	     */
	    /*public PDDocumentCatalogAdditionalActions getActions()
	    {
			COSDictionary addAct = (COSDictionary) root.getDictionaryObject("AA");
			if (addAct == null)
			{
				addAct = new COSDictionary();
				root.setItem("AA", addAct);
			}       
			return new PDDocumentCatalogAdditionalActions(addAct);
	    }*/
	    
	    /**
	     * Set the additional actions for the document.
	     * 
	     * @param actions The actions that are associated with this document.
	     */
	    /*public void setActions( PDDocumentCatalogAdditionalActions actions )
	    {
			root.setItem("AA", actions );
	    }*/
	    
	    /**
	     * @return The names dictionary for this document or null if none exist.
	     */
	   /* public PDDocumentNameDictionary getNames()
	    {
			PDDocumentNameDictionary nameDic = null;
			COSDictionary names = (COSDictionary) root.getDictionaryObject("Names");
			if(names != null)
			{
				nameDic = new PDDocumentNameDictionary(this,names);
			}       
			return nameDic;
	    }*/
	    
	    /**
	     * Set the names dictionary for the document.
	     * 
	     * @param names The names dictionary that is associated with this document.
	     */
	    /*public void setNames( PDDocumentNameDictionary names )
	    {
			root.setItem("Names", names );
	    }
	    */
	    /**
	     * Get info about doc's usage of tagged features.  This will return
	     * null if there is no information.
	     * 
	     * @return The new mark info. 
	     */
	    /*public function getMarkInfo():PDMarkInfo
	    {
			var retval:PDMarkInfo = null;
			var dic:COSDictionary = root.getDictionaryObject( "MarkInfo" ) as COSDictionary;
			if( dic != null )
			{
				retval = new PDMarkInfo( dic );
			}
			return retval;
	    }*/
	    
	    /**
	     * Set information about the doc's usage of tagged features.
	     * 
	     * @param markInfo The new MarkInfo data.
	     */
	   /* public void setMarkInfo( PDMarkInfo markInfo ):void
	    {
			root.setItem( "MarkInfo", markInfo );
	    }*/
	    
	    /**
	     * Set the page display mode, see the PAGE_MODE_XXX constants.
	     * @return A string representing the page mode.
	     */
	    public function getPageMode():String
	    {
			return root.getNameAsString( "PageMode", PAGE_MODE_USE_NONE );
	    }
	    
	    /**
	     * Set the page mode.  See the PAGE_MODE_XXX constants for valid values.
	     * @param mode The new page mode.
	     */
	    public function setPageMode( mode:String ):void
	    {
			root.setName( "PageMode", mode );
	    }
	    
	    /**
	     * Set the page layout, see the PAGE_LAYOUT_XXX constants.
	     * @return A string representing the page layout.
	     */
	    public function getPageLayout():String
	    {
			return root.getNameAsString( "PageLayout", PAGE_LAYOUT_SINGLE_PAGE );
	    }
	    
	    /**
	     * Set the page layout.  See the PAGE_LAYOUT_XXX constants for valid values.
	     * @param layout The new page layout.
	     */
	    public function setPageLayout( layout:String ):void
	    {
			root.setName( "PageLayout", layout );
	    }
	    
	    /**
	     * Document level information in the URI.
	     * @return Document level URI.
	     */
	   /* public PDActionURI getURI()
	    {
			PDActionURI retval = null;
			COSDictionary uri = (COSDictionary)root.getDictionaryObject( "URI" );
			if( uri != null )
			{
				retval = new PDActionURI( uri );
			}
			return retval;
	    }*/
	    
	    /**
	     * Set the document level uri.
	     * @param uri The new document level uri.
	     */
	   /* public function setURI( uri:PDActionURI ):void
	    {
			root.setItem( "URI", uri );
	    }*/
	    
	    /**
	     * Get the document's structure tree root.
	     * 
	     * @return The document's structure tree root or null if none exists.
	     */
	    /*public function getStructureTreeRoot():PDStructureTreeRoot
	    {
			var treeRoot:PDStructureTreeRoot = null;
			var dic:COSDictionary = COSDictionary(root).getDictionaryObject( "StructTreeRoot" );
			if( dic != null )
			{
				treeRoot = new PDStructureTreeRoot( dic );
			}
			return treeRoot;
	    }*/
	    
	    /**
	     * Set the document's structure tree root.
	     * 
	     * @param treeRoot The new structure tree.
	     */
	   /* public function setStructureTreeRoot( treeRoot:PDStructureTreeRoot ):void
	    {
			root.setItem( "StructTreeRoot", treeRoot );
	    }*/
	    
	    /**
	     * The language for the document.
	     * 
	     * @return The language for the document.
	     */
	    public function getLanguage():String
	    {
			return root.getString( "Lang" );
	    }
	    
	    /**
	     * Set the Language for the document.
	     * 
	     * @param language The new document language.
	     */
	    public function setLanguage( language:String ):void
	    {
			root.setName( "Lang", language );
	    }

	}
}