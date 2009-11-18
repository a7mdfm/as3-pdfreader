package org.pdfbox.pdmodel.interactive.documentnavigation.outline
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;

	import org.pdfbox.pdmodel.common.COSObjectable;

	/**
	 * This represents an node in an outline in a pdf document.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.3 $
	 */
	public class PDFOutlineNode implements COSObjectable
	{   
		/**
		 * The dictionary for this node.
		 */
		protected var node:COSDictionary;
		
		/**
		 * Default Constructor.
		 * 
		 * @param dict The dictionary storage.
		 */
		public function PDFOutlineNode( COSDictionary dict = null )
		{
			node = (dict == null)?new COSDictionary():dict;
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return node;
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSDictionary():COSDictionary
		{
			return node;
		}
		
		/**
		 * Get the parent of this object.  This will either be a DocumentOutline or an OutlineItem.
		 * 
		 * @return The parent of this object, or null if this is the document outline and there
		 * is no parent.
		 */
		public function getParent():PDFOutlineNode
		{
			var retval:PDFOutlineNode = null;
			var parent:COSDictionary = node.getDictionaryObject( "Parent", "P" ) as COSDictionary;
			if( parent != null )
			{
				if( parent.getDictionaryObject( "Parent", "P" ) == null )
				{
					retval = new PDDocumentOutline( parent );
				}
				else
				{
					retval = new PDOutlineItem( parent );
				}
			}
			
			return retval;
		}
		
		/**
		 * Set the parent of this object, this is maintained by these objects and should not
		 * be called by any clients of PDFBox code.
		 * 
		 * @param parent The parent of this object.
		 */
		protected function setParent( parent:PDFOutlineNode ):void
		{
			node.setItem( "Parent", parent );
		}
		
		/**
		 * append a child node to this node.
		 * 
		 * @param outlineNode The node to add.
		 */
		public function appendChild( outlineNode:PDFOutlineItem ):void
		{
			outlineNode.setParent( this );
			if( getFirstChild() == null )
			{
				int currentOpenCount = getOpenCount();
				setFirstChild( outlineNode );
				//1 for the the item we are adding;
				int numberOfOpenNodesWeAreAdding = 1;
				if( outlineNode.isNodeOpen() )
				{
					numberOfOpenNodesWeAreAdding += outlineNode.getOpenCount();
				}
				if( isNodeOpen() )
				{
					setOpenCount( currentOpenCount + numberOfOpenNodesWeAreAdding );
				}
				else
				{
					setOpenCount( currentOpenCount - numberOfOpenNodesWeAreAdding );
				}
				updateParentOpenCount( numberOfOpenNodesWeAreAdding );
			}
			else
			{
				PDOutlineItem previousLastChild = getLastChild();
				previousLastChild.insertSiblingAfter( outlineNode );
			}
			setLastChild( outlineNode );
		}
		
		/**
		 * Return the first child or null if there is no child.
		 * 
		 * @return The first child.
		 */
		public PDOutlineItem getFirstChild()
		{
			PDOutlineItem last = null;
			COSDictionary lastDic = (COSDictionary)node.getDictionaryObject( "First" );
			if( lastDic != null )
			{
				last = new PDOutlineItem( lastDic );
			}
			return last;
		}
		
		/**
		 * Set the first child, this will be maintained by this class.
		 * 
		 * @param outlineNode The new first child.
		 */
		protected void setFirstChild( PDOutlineNode outlineNode )
		{
			node.setItem( "First", outlineNode );
		}
		
		/**
		 * Return the last child or null if there is no child.
		 * 
		 * @return The last child.
		 */
		public PDOutlineItem getLastChild()
		{
			PDOutlineItem last = null;
			COSDictionary lastDic = (COSDictionary)node.getDictionaryObject( "Last" );
			if( lastDic != null )
			{
				last = new PDOutlineItem( lastDic );
			}
			return last;
		}
		
		/**
		 * Set the last child, this will be maintained by this class.
		 * 
		 * @param outlineNode The new last child.
		 */
		protected void setLastChild( PDOutlineNode outlineNode )
		{
			node.setItem( "Last", outlineNode );
		}
		
		/**
		 * Get the number of open nodes.  Or a negative number if this node
		 * is closed.  See PDF Reference for more details.  This value
		 * is updated as you append children and siblings.
		 * 
		 * @return The Count attribute of the outline dictionary.
		 */
		public function getOpenCount():int
		{
			return node.getInt( "Count", 0 );
		}
		
		/**
		 * Set the open count.  This number is automatically managed for you
		 * when you add items to the outline.
		 * 
		 * @param openCount The new open cound.
		 */
		protected function setOpenCount( openCount:int ):void
		{
			node.setInt( "Count", openCount );
		}
		
		/**
		 * This will set this node to be open when it is shown in the viewer.  By default, when 
		 * a new node is created it will be closed.
		 * This will do nothing if the node is already open.
		 */
		public function openNode():void
		{
			//if the node is already open then do nothing.
			if( !isNodeOpen() )
			{
				var openChildrenCount:int = 0;
				var currentChild:PDFOutlineItem = getFirstChild();
				while( currentChild != null )
				{
					//first increase by one for the current child
					openChildrenCount++;
					//then increase by the number of open nodes the child has
					if( currentChild.isNodeOpen() )
					{
						openChildrenCount += currentChild.getOpenCount();
					}
					currentChild = currentChild.getNextSibling();
				}
				setOpenCount( openChildrenCount );
				updateParentOpenCount( openChildrenCount );
			}
		}
		
		/**
		 * Close this node.
		 *
		 */
		public function closeNode():void
		{
			//if the node is already closed then do nothing.
			if( isNodeOpen() )
			{
				var openCount:int = getOpenCount();
				updateParentOpenCount( -openCount );
				setOpenCount( -openCount );
			}
		}
		
		/**
		 * Node is open if the open count is greater than zero.
		 * @return true if this node is open.
		 */
		public boolean isNodeOpen()
		{
			return getOpenCount() > 0;
		}
		
		/**
		 * The count parameter needs to be updated when you add or remove elements to 
		 * the outline.  When you add an element at a lower level then you need to 
		 * increase all of the parents.
		 * 
		 * @param amount The amount to update by.
		 */
		protected void updateParentOpenCount( int amount )
		{
			PDOutlineNode parent = getParent();
			if( parent != null )
			{
				int currentCount = parent.getOpenCount();
				//if the currentCount is negative or it is absent then
				//we will treat it as negative.  The default is to be negative.
				boolean negative = currentCount < 0 || 
					parent.getCOSDictionary().getDictionaryObject( "Count" ) == null;
				currentCount = Math.abs( currentCount );
				currentCount += amount;
				if( negative )
				{
					currentCount = -currentCount;
				}
				parent.setOpenCount( currentCount );
				//recursively call parent to update count, but the parents count is only
				//updated if this is an open node
				if( !negative )
				{
					parent.updateParentOpenCount( amount );
				}
			}
		}
	}
}
