package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLStream;
	import flash.net.URLRequest;	
	
	import flash.utils.ByteArray;
	
	import org.fluidea.controls.Button;	
	
	// import PDFBox library
	import org.pdfbox.io.FileInputStream;
	import org.pdfbox.pdmodel.PDFDocument;
	import org.pdfbox.pdmodel.PDFDocumentCatalog;
	import org.pdfbox.pdmodel.PDFPage;
	import org.pdfbox.pdmodel.PDFDocumentInformation;	
	import org.pdfbox.pdmodel.common.PDFStream;
	
	import org.pdfbox.tools.PDFTextStripper;
	import org.pdfbox.tools.PDFStreamEngine;
	import org.pdfbox.utils.DateUtil;
	
	import org.pdfbox.log.PDFLogger;
	
	/**
	 * Extract text from pdf file
	 * @author walktree 
	 */
	public class Demo_Text extends Sprite 
	{
		
		// UI objects
		private var output_txt:TextField;		
		private var file_txt:TextField;		
		private var load_btn:Button;
		
		//load file in binary format 		
		private var file_Loader:URLStream;
		
		// PDFDocument,the root object
		private var document:PDFDocument;
		
		public function Demo_Text():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = "noScale";
			
			createChildren();
			
			addEvents();
			
			//
			PDFLogger.callBack = output;
		}
		
		// create displayObject
		private function createChildren():void
		{
			
			load_btn = new Button("Parse PDF");
			addChild(load_btn);
			
			load_btn.x = load_btn.y = 10;
			
			file_txt = new TextField();
			file_txt.width = 380;
			file_txt.height = 20;
			file_txt.multiline = false;
			file_txt.type = "input";
			file_txt.defaultTextFormat = new TextFormat( "Arial", 12);
			file_txt.border = true;
			file_txt.borderColor = 0x808888;
			file_txt.x = 88;
			file_txt.y = 10;
			file_txt.text = "test.pdf";
			addChild(file_txt);
			
			output_txt = new TextField();
			output_txt.width = 460;
			output_txt.height = 320;
			output_txt.defaultTextFormat = new TextFormat( "Arial", 12);
			output_txt.border = true;
			output_txt.borderColor = 0x808888;
			output_txt.wordWrap = true;
			
			output_txt.x = 10;
			output_txt.y = 40;
			
			addChild(output_txt);
		}
		
		private function addEvents():void 
		{
			load_btn.buttonMode = true;
			load_btn.addEventListener ( MouseEvent.CLICK, onClick);
		}
		
		private function onClick (e:Event):void
		{
			output_txt.text = "";
			var f:String = file_txt.text;
			output ( "start loading ...");
			
			load_btn.mouseEnabled = false;
			//
			
			if ( file_Loader == null ) {
				file_Loader = new URLStream();
				file_Loader.addEventListener(ProgressEvent.PROGRESS, onLoadProcess);
				file_Loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				file_Loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
				file_Loader.addEventListener(Event.COMPLETE, onFileLoaded);
			}
			file_Loader.load ( new URLRequest (f) );
		}
		
		private function onLoadError(e:Event):void
		{
			output ( "PDF File load error..." );
			load_btn.mouseEnabled = true;
		}
		
		private function onLoadProcess(e:ProgressEvent):void 
		{
			output_txt.text = "";		
			var p:int = Math.floor(e.bytesLoaded / e.bytesTotal * 100);
			output ( "loading file " + p + "% ..." );
		}
		
		private function onFileLoaded(e:Event):void 
		{
			load_btn.mouseEnabled = true;
			output ( "PDF File loaded..." );
			output ( "开始解析文件..." );
			
			//read bytes
			var stream:ByteArray = new ByteArray();			
			file_Loader.readBytes(stream);
			//
			var file:FileInputStream = new FileInputStream();
			file.data = stream;
			// create document
			document = PDFDocument.load( file );
			
			output ( "解析完成，下面输出文件的基本信息： ");
			output ( "++++++++++++++++++++++++++++++++++++++ ");
			
			printFileInfo();
			
			output ( "++++++++++++++++++++++++++++++++++++++ ");
			
			printPageInfo();
		}
		
		private function printFileInfo():void 
		{
			var info:PDFDocumentInformation = document.getDocumentInformation();
			
			PDFLogger.log( "作者：" + info.getAuthor() );
			PDFLogger.log( "标题：" + info.getTitle() );
			PDFLogger.log( "工具：" + info.getCreator() + ", " + info.getProducer());
			PDFLogger.log( "创建日期：" + DateUtil.DateToString(info.getCreationDate()) );		
			PDFLogger.log( "是否加密：" + (document.isEncrypted() == true?'是':'否') );	
			PDFLogger.log( "关键字：" + info.getKeywords() );	
	
		}
		
		private function printPageInfo():void {
			var pages:Array = document.getDocumentCatalog().getAllPages();
			PDFLogger.log("页数:" + pages.length);			
			
			var len:int = pages.length;
			//len = 1;
			for (var i:int = 0; i < len; i++) {
				var page:PDFPage = pages[i] as PDFPage;
				var stream:PDFStream = page.getContents();
				var bytes:ByteArray = stream.getByteArray();
				PDFLogger.log ("Page " + (i + 1) + ": " + bytes+":"+bytes.length);
				var pdfStreamEngine:PDFStreamEngine = new PDFStreamEngine();
				pdfStreamEngine.processStream(page, null, stream.getStream());
			}
			
			
			//
			/*
			var stripper:PDFTextStripper = new PDFTextStripper();
			
			var output:ByteArray = new ByteArray();
            
            stripper.setSortByPosition( sort );
			stripper.setStartPage( 1 );
            stripper.setEndPage( 1 );
            stripper.writeText( document, output );
			*/
			
		}
		
		private function output ( s:String ):void
		{
			s += "\n";
			
			output_txt.appendText ( s );
		}
		
	}
	
}