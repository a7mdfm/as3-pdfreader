package org.pdfbox.pdmodel
{
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSArray;
	import org.pdfbox.pdmodel.common.COSObjectable;
	import org.pdfbox.pdmodel.common.PDFRectangle;
	import org.pdfbox.pdmodel.common.PDFStream;
	
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
			var parentDic:COSDictionary = page.getDictionaryObject( "Parent", "P" ) as COSDictionary;
			if( parentDic != null )
			{
				parent = new PDFPageNode( parentDic );
			}
			return parent;
		}
		
		public function getContents() :PDFStream
		{
			return PDFStream.createFromCOS( page.getDictionaryObject( COSName.CONTENTS ) );
		}
		
		public function setContents( contents:PDFStream ):void
		{
			page.setItem( COSName.CONTENTS, contents );
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
		 * This will get the resources at this page and not look up the hierarchy.
		 * This attribute is inheritable, and findResources() should probably used.
		 * This will return null if no resources are available at this level.
		 *
		 * @return The resources at this level in the hierarchy.
		 */
		/*public PDResources getResources()
		{
			PDResources retval = null;
			COSDictionary resources = (COSDictionary)page.getDictionaryObject( COSName.RESOURCES );
			if( resources != null )
			{
				retval = new PDResources( resources );
			}
			return retval;
		}*/
		
		public function toString():String {
			return "[ " + page + " ]";
		}

	}
	
}