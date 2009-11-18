package org.fluidea.pdf
{
	import flash.utils.ByteArray;
	
	import flash.display.Sprite;
	
	import org.pdfbox.io.FileInputStream;	
	import org.pdfbox.log.PDFLogger;
	import org.pdfbox.pdfparser.PDFParser;	
	import org.pdfbox.pdmodel.PDFDocument;
	import org.pdfbox.pdmodel.PDFDocumentInformation;
	import org.pdfbox.utils.DateUtil;	
	
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class PDFReader extends Sprite
	{
		
		private var document:PDFDocument;
		
		public function PDFReader( stream:ByteArray ) 
		{
			parse( stream );
		}
		
		private function parse( stream:ByteArray ):void {
			
			var file:FileInputStream = new FileInputStream();
			file.data = stream;
			document = PDFDocument.load( file );
		}
		
		
		public function printFileInfo():void {
			
			var info:PDFDocumentInformation = document.getDocumentInformation();
			
			PDFLogger.log( "作者：" + info.getAuthor() );
			PDFLogger.log( "标题：" + info.getTitle() );
			PDFLogger.log( "工具：" + info.getCreator() + ", "+info.getProducer());
			PDFLogger.log( "创建日期：" + DateUtil.DateToString(info.getCreationDate()) );		
			PDFLogger.log( "是否加密：" + (document.isEncrypted() == true?'是':'否') );	
			PDFLogger.log( "关键字：" + info.getKeywords() );	
			
			var pages:Array = document.getDocumentCatalog().getAllPages();
			PDFLogger.log("页数:" + pages.length);
		}
		
		
	}
	
}