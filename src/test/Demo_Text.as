package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
		private var file_loader:URLLoader;
		
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
			file_txt.text = "simple1.pdf";
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
			
			if ( file_loader == null ) {
				file_loader = new URLLoader();
				file_loader.dataFormat = URLLoaderDataFormat.BINARY;
				file_loader.addEventListener(ProgressEvent.PROGRESS, onLoadProcess);
				file_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				file_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
				file_loader.addEventListener(Event.COMPLETE, onFileLoaded);
			}
			file_loader.load ( new URLRequest (f) );
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
			var file:FileInputStream = new FileInputStream();
			file.data = file_loader.data as ByteArray;
			// create document
			document = PDFDocument.load( file );
			
			/*
			 * PDF文件的版本较多，最新的版本功能很多。由于PDF文件中的对象是紧密联系在一起的，彼此相互依赖，一旦遇到无法识别的对象，程序可能会陷入死循环。
			 * 
			 * 如果现在SWF没有crash，也没有抛出异常，那恭喜了，已成功解析完整个该死的PDF文件。			 
			 *  
			 * 所谓的成功解析是按照预定格式，读明白了所有的数据，并转换为程序语言中的对象。
			 * 接下来的工作，就是顺藤摸瓜，按照逻辑关系，把这些对象串联起来，并提取出其中的内容，比如文本、图片。
			 * 
			 * 不过到现在已经可以长舒一口气了，可以说，万里长征已经走到了近4/5处，前面依然很艰险
			 * 
			 * Let's Go!
			 * 
			 */
			
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
			
			// PDFDocumentCatalog对象包括文件的目录信息和页面信息 

			var fileCatalog:PDFDocumentCatalog = document.getDocumentCatalog();
			
			var pages:Array = fileCatalog.getAllPages();
			PDFLogger.log("页数:" + pages.length);			
			
			var len:int = pages.length;
			len = 1;
			for (var i:int = 0; i < len; i++) {
				var page:PDFPage = pages[i] as PDFPage;
				var stream:PDFStream = page.getContents();
				var bytes:ByteArray = stream.getByteArray();
				PDFLogger.log ("Page " + (i + 1) + " : " + bytes);
				//var pdfStreamEngine:PDFStreamEngine = new PDFStreamEngine();
				//pdfStreamEngine.processStream(page, null, stream.getStream());
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