package org.pdfbox.pdmodel
{
	import flash.utils.ByteArray;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.cos.COSInteger;
	import org.pdfbox.pdmodel.common.COSArrayList;
	import org.pdfbox.pdmodel.common.COSObjectable;
	import org.pdfbox.pdmodel.common.PDFRectangle;
	import org.pdfbox.pdmodel.common.PDFStream;
	import org.pdfbox.pdmodel.interactive.pagenavigation.PDFThreadBead;
	import org.pdfbox.utils.ArrayList;
	
	import org.pdfbox.utils.List;
	
	public class PDFPage implements COSObjectable
	{
		public static const PAGE_SIZE_LETTER:PDFRectangle = new PDFRectangle( 612, 792 );
		
		private var page:COSDictionary;
		
		public function PDFPage( pageDic:COSDictionary = null )
		{
			if (pageDic != null) {
				page = pageDic;
			}else {
				page = new COSDictionary();
				page.setItem( COSName.TYPE, COSName.PAGE );
				setMediaBox( PAGE_SIZE_LETTER );
			}
		}
		
		public function getCOSObject():COSBase
		{
			return page;
		}
		
		public function getCOSDictionary():COSDictionary
		{
			return page;
		}
				
		public function getParent():PDFPageNode
		{
			var parent:PDFPageNode = null;
			var parentDic:COSDictionary = page.getDictionaryObject( COSName.PARENT, "P" ) as COSDictionary;
			if( parentDic != null )
			{
				parent = new PDFPageNode( parentDic );
			}
			return parent;
		}
		
		public function setParent( parent:PDFPageNode ):void
		{
			page.setItem( COSName.PARENT, parent.getDictionary() );
		}

		/**
		 * This will get the resources at this page and not look up the hierarchy.
		 * This attribute is inheritable, and findResources() should probably used.
		 * This will return null if no resources are available at this level.
		 *
		 * @return The resources at this level in the hierarchy.
		 */
		public function getResources():PDFResources
		{
			var retval:PDFResources = null;
			var resources:COSDictionary = page.getDictionaryObject( COSName.RESOURCES ) as COSDictionary;
			if( resources != null )
			{
				retval = new PDFResources( resources );
			}
			return retval;
		}
		
		/**
		 * This will find the resources for this page by looking up the hierarchy until
		 * it finds them.
		 *
		 * @return The resources at this level in the hierarchy.
		 */
		public function findResources():PDFResources
		{
			var retval:PDFResources = getResources();
			var parent:PDFPageNode = getParent();
			if( retval == null && parent != null )
			{
				retval = parent.findResources();
			}
			return retval;
		}
		
		/**
		 * This will set the resources for this page.
		 *
		 * @param resources The new resources for this page.
		 */
		public function setResources( resources:PDFResources ):void
		{
			page.setItem( COSName.RESOURCES, resources );
		}
		
		public function getContents() :PDFStream
		{
			return PDFStream.createFromCOS( page.getDictionaryObject( COSName.CONTENTS ) );
		}
		
		public function setContents( contents:PDFStream ):void
		{
			page.setItem( COSName.CONTENTS, contents );
		}
		
		/**
		 * This will get a list of PDThreadBead objects, which are article threads in the
		 * document.  This will return an empty list of there are no thread beads.
		 * 
		 * @return A list of article threads on this page.
		 */
		public function getThreadBeads():List
		{
			var beads:COSArray = page.getDictionaryObject( COSName.B ) as COSArray;
			if( beads == null )
			{
				beads = new COSArray();
			}
			var pdObjects:ArrayList = new ArrayList();
			for( var i:int=0; i<beads.size(); i++)
			{
				var beadDic:COSDictionary = beads.getObject( i ) as COSDictionary;			  
				var bead:PDFThreadBead = null;
				//in some cases the bead is null
				if( beadDic != null )
				{
					bead = new PDFThreadBead( beadDic );
				}
				pdObjects.add( bead );
			}
			return new COSArrayList(pdObjects, beads);
			
		}
		
		/**
		 * This will set the list of thread beads.
		 * 
		 * @param beads A list of PDThreadBead objects or null.
		 */
		public function setThreadBeads( beads:List ):void
		{
			page.setItem( COSName.B, COSArrayList.converterToCOSArray( beads ) );
		}
		
		public function setParent( parent:PDFPageNode ):void
		{
			page.setItem( COSName.PARENT, parent.getDictionary() );
		}
		
		public function getMediaBox():PDFRectangle
		{
			var retval:PDFRectangle = null;
			var array:COSArray = page.getDictionaryObject( COSName.MEDIA_BOX ) as COSArray;
			if( array != null )
			{
				retval = new PDFRectangle( );
				retval.setCOSArray( array );
			}
			return retval;
		}
		public function setMediaBox( mediaBox:PDFRectangle ):void
		{
			if( mediaBox == null )
			{
				page.removeItem( COSName.MEDIA_BOX );
			}
			else
			{
				page.setItem( COSName.MEDIA_BOX, mediaBox.getCOSArray() );
			}
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
			var retval:int;
			var value:COSNumber = page.getDictionaryObject( COSName.ROTATE ) as COSNumber;
			if( value != null )
			{
				retval = value.intValue();
				return retval;
			}else {
				return NaN
			}			
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
			if( !isNaN(rotation) )
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
			
		public function equals( other:Object ):Boolean
		{
			return other is PDFPage && (other as PDFPage).getCOSObject() == this.getCOSObject();
		}
	
		public function toString():String {
			return "[ " + page + " ]";
		}

	}
	
}