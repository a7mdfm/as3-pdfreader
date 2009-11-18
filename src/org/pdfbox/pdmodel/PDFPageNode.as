package org.pdfbox.pdmodel
{

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.cos.COSInteger;

	//import org.pdfbox.pdmodel.common.COSArrayList;
	import org.pdfbox.pdmodel.common.COSObjectable;
	import org.pdfbox.pdmodel.common.PDFRectangle;

	/**
	 * This represents a page node in a pdf document.
	 */
	public class PDFPageNode implements COSObjectable
	{
	    private var page:COSDictionary;

	    /**
	     * Creates a new instance of PDPage.
	     *
	     * @param pages The dictionary pages.
	     */
	    public function PDFPageNode( pages:COSDictionary = null )
	    {
			if (pages) {				
				page = pages;
			}else{
				page = new COSDictionary();
				page.setItem( COSName.TYPE, COSName.PAGES );
				page.setItem( COSName.KIDS, new COSArray() );
				page.setItem( COSName.COUNT, new COSInteger( 0 ) );
			}
	    }

	    /**
	     * This will update the count attribute of the page node.  This only needs to
	     * be called if you add or remove pages.  The PDDocument will call this for you
	     * when you use the PDDocumnet persistence methods.  So, basically most clients
	     * will never need to call this.
	     *
	     * @return The update count for this node.
	     */
	    public function updateCount():Number
	    {
			var totalCount:int = 0;
			/*
			List kids = getKids();
			Iterator kidIter = kids.iterator();
			while( kidIter.hasNext() )
			{
				var next:Object = kidIter.next();
				if( next is PDPage )
				{
				totalCount++;
				}
				else
				{
				var node:PDFPageNode = (PDFPageNode)next;
				totalCount += node.updateCount();
				}
			}
			page.setItem( COSName.COUNT, new COSInteger( totalCount ) );
			*/
			return totalCount;
	    }

	    /**
	     * This will get the count of descendent page objects.
	     *
	     * @return The total number of descendent page objects.
	     */
	    public function getCount():Number
	    {
			return COSNumber(page.getDictionaryObject( COSName.COUNT )).intValue();
	    }

	    /**
	     * This will get the underlying dictionary that this class acts on.
	     *
	     * @return The underlying dictionary for this class.
	     */
	    public function getDictionary():COSDictionary
	    {
			return page;
	    }

	    /**
	     * This is the parent page node.
	     *
	     * @return The parent to this page.
	     */
	    public function getParent():PDFPageNode
	    {
			var parent:PDFPageNode = null;
			var parentDic:COSDictionary = page.getDictionaryObject( "Parent", "P" ) as COSDictionary;
			if( parentDic != null )
			{
				parent = new PDFPageNode( parentDic );
			}
			return parent;
	    }

	    /**
	     * This will set the parent of this page.
	     *
	     * @param parent The parent to this page node.
	     */
	    public function setParent( parent:PDFPageNode ):void
	    {
			page.setItem( COSName.PARENT, parent.getDictionary() );
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function getCOSObject():COSBase
	    {
			return page;
	    }

	    /**
	     * This will return all kids of this node, either PDFPageNode or PDPage.
	     *
	     * @return All direct descendents of this node.
	     */
	    /*public function getKids():Array
	    {
			var actuals:Array = new Array();
			var kids:COSArray = $getAllKids(actuals, page, false);
			return new COSArrayList( actuals, kids );
	    }*/
	    
	    /**
	     * This will return all kids of this node as PDPage.
	     *
	     * @param result All direct and indirect descendents of this node are added to this list.
	     */
	    public function getAllKids(result:Array):void
	    {
			$getAllKids(result, page, true);
	    }
	    
	    /**
	     * This will return all kids of the given page node as PDPage.
	     *
	     * @param result All direct and optionally indirect descendents of this node are added to this list.
	     * @param page Page dictionary of a page node.
	     * @param recurse if true indirect descendents are processed recursively
	     */
	    private function $getAllKids( result:Array, page:COSDictionary, recurse:Boolean ):COSArray
	    {
			var kids:COSArray = page.getDictionaryObject( COSName.KIDS ) as COSArray;
			
			for( var i:int=0; i<kids.size(); i++ )
			{
				var obj:COSBase = kids.getObject( i );	
				if (obj is COSDictionary)
				{
					var kid:COSDictionary = obj as COSDictionary;
					
					if( COSName.PAGE.equals( kid.getDictionaryObject( COSName.TYPE ) ) )
					//if( COSName.PAGE == kid.getDictionaryObject( COSName.TYPE ) )
					{
						result.push( new PDFPage( kid ) );
					}
					else
					{
						if (recurse)
						{
							$getAllKids(result, kid, recurse);
						}
						else 
						{
							result.add( new PDFPageNode( kid ) );
						}
					}
				}
			}
			return kids;
	    }

	    /**
	     * This will get the resources at this page node and not look up the hierarchy.
	     * This attribute is inheritable, and findResources() should probably used.
	     * This will return null if no resources are available at this level.
	     *
	     * @return The resources at this level in the hierarchy.
	     *
	    public function getResources():PDFResources
	    {
			return null;
	    }

	    /**
	     * This will find the resources for this page by looking up the hierarchy until
	     * it finds them.
	     *
	     * @return The resources at this level in the hierarchy.
	     *
	    public function findResources():PDResources
	    {
			PDResources retval = getResources();
			PDFPageNode parent = getParent();
			if( retval == null && parent != null )
			{
				retval = parent.findResources();
			}
			return retval;
	    }

	    **
	     * This will set the resources for this page.
	     *
	     * @param resources The new resources for this page.
	     *
	    public void setResources( PDResources resources )
	    {
		if( resources == null )
		{
		    page.removeItem( COSName.RESOURCES );
		}
		else
		{
		    page.setItem( COSName.RESOURCES, resources.getCOSDictionary() );
		}
	    }
		*/

	    /**
	     * This will get the MediaBox at this page and not look up the hierarchy.
	     * This attribute is inheritable, and findMediaBox() should probably used.
	     * This will return null if no MediaBox are available at this level.
	     *
	     * @return The MediaBox at this level in the hierarchy.
	     */
	    public function getMediaBox():PDFRectangle
	    {
			var retval:PDFRectangle = null;
			var array:COSArray = page.getDictionaryObject( COSName.MEDIA_BOX ) as COSArray;
			if( array != null )
			{
				//retval = new PDFRectangle( array );
			}
			return retval;
	    }

	    /**
	     * This will find the MediaBox for this page by looking up the hierarchy until
	     * it finds them.
	     *
	     * @return The MediaBox at this level in the hierarchy.
	     */
	    public function findMediaBox():PDFRectangle
	    {
			var retval:PDFRectangle = getMediaBox();
			var parent:PDFPageNode = getParent();
			if( retval == null && parent != null )
			{
				retval = parent.findMediaBox();
			}
			return retval;
	    }

	    /**
	     * This will set the mediaBox for this page.
	     *
	     * @param mediaBox The new mediaBox for this page.
	     */
	    public function setMediaBox( mediaBox:PDFRectangle ):void
	    {
			if( mediaBox == null )
			{
				page.removeItem( COSName.MEDIA_BOX  );
			}
			else
			{
				//TODO
				//page.setItem( COSName.MEDIA_BOX , mediaBox.getCOSArray() );
			}
	    }

	/**
	     * This will get the CropBox at this page and not look up the hierarchy.
	     * This attribute is inheritable, and findCropBox() should probably used.
	     * This will return null if no CropBox is available at this level.
	     *
	     * @return The CropBox at this level in the hierarchy.
	     */
	   /* public PDRectangle getCropBox()
	    {
			PDRectangle retval = null;
			COSArray array = (COSArray)page.getDictionaryObject( COSName.CROP_BOX );
			if( array != null )
			{
				retval = new PDRectangle( array );
			}
			return retval;
	    }*/

	    /**
	     * This will find the CropBox for this page by looking up the hierarchy until
	     * it finds them.
	     *
	     * @return The CropBox at this level in the hierarchy.
	     */
	   /* public PDRectangle findCropBox()
	    {
			PDRectangle retval = getCropBox();
			PDFPageNode parent = getParent();
			if( retval == null && parent != null )
			{
				retval = findParentCropBox( parent );
			}

			//default value for cropbox is the media box
			if( retval == null )
			{
				retval = findMediaBox();
			}
			return retval;
	    }*/

	    /**
	     * This will search for a crop box in the parent and return null if it is not
	     * found.  It will NOT default to the media box if it cannot be found.
	     *
	     * @param node The node
	     */
	    /*private function findParentCropBox( node:PDFPageNode ):PDRectangle
	    {
			PDRectangle rect = node.getCropBox();
			PDFPageNode parent = node.getParent();
			if( rect == null && parent != null )
			{
				rect = findParentCropBox( node );
			}
			return rect;
	    }*/

	    /**
	     * This will set the CropBox for this page.
	     *
	     * @param cropBox The new CropBox for this page.
	     */
	   /* public function setCropBox( cropBox:PDRectangle ):void
	    {
			if( cropBox == null )
			{
				page.removeItem( COSName.CROP_BOX );
			}
			else
			{
				page.setItem( COSName.CROP_BOX, cropBox.getCOSArray() );
			}
	    }*/

	    /**
	     * A value representing the rotation.  This will be null if not set at this level
	     * The number of degrees by which the page should
	     * be rotated clockwise when displayed or printed. The value must be a multiple
	     * of 90.
	     *
	     * This will get the rotation at this page and not look up the hierarchy.
	     * This attribute is inheritable, and findRotation() should probably used.
	     * This will return null if no rotation is available at this level.
	     *
	     * @return The rotation at this level in the hierarchy.
	     */
	    public function getRotation():int
	    {
			var retval:int = 0;
			var value:COSNumber = page.getDictionaryObject( COSName.ROTATE ) as COSNumber;
			if( value != null )
			{
				retval = int( value.intValue() );
			}
			return retval;
	    }

	    /**
	     * This will find the rotation for this page by looking up the hierarchy until
	     * it finds them.
	     *
	     * @return The rotation at this level in the hierarchy.
	     */
	    public function findRotation():int
	    {
			var retval:int = 0;
			var rotation:int = getRotation();
			if( rotation != 0 )
			{
				retval = rotation;
			}
			else
			{
				var parent:PDFPageNode = getParent();
				if( parent != null )
				{
				retval = parent.findRotation();
				}
			}

			return retval;
	    }

	    /**
	     * This will set the rotation for this page.
	     *
	     * @param rotation The new rotation for this page.
	     */
	    public function setRotation( rotation:int ):void
	    {
			page.setItem( COSName.ROTATE, new COSInteger( rotation ) );
	    }
		
		public function toString():String
		{
			return "[ PDFPage >> " + page + " ]";
		}
	}
}