package org.pdfbox.pdmodel 
{
	
	import org.pdfbox.pdfparser.PDFParser;
	import org.pdfbox.cos.COSDocument;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSInteger;
	import org.pdfbox.cos.COSName;

	import org.pdfbox.io.FileInputStream;
	
	public class PDFDocument 
	{
		
		private var document:COSDocument;
		private var documentCatalog:PDFDocumentCatalog;
		
		private var documentInformation:PDFDocumentInformation;
		
		/**
		 * 'private' constructor
		 * 
		 * @param	doc  COSDocument object
		 */
		public function PDFDocument( doc:COSDocument = null ) 
		{
			if ( doc != null ) {
				document = doc;
			}else {
				document = new COSDocument();
			}
			
			var trailer:COSDictionary = document.getTrailer();
			if( trailer == null ){
				//First we need a trailer
				trailer = new COSDictionary();
				document.setTrailer( trailer );
				
				//Next we need the root dictionary.
				var rootDictionary:COSDictionary = new COSDictionary();
				trailer.setItem( COSName.ROOT, rootDictionary );
				rootDictionary.setItem( COSName.TYPE, COSName.CATALOG );
				rootDictionary.setItem( COSName.VERSION, COSName.getPDFName( "1.4" ) );
				
				//next we need the pages tree structure
				var pages:COSDictionary = new COSDictionary();
				rootDictionary.setItem( COSName.PAGES, pages );
				pages.setItem( COSName.TYPE, COSName.PAGES );
				var kidsArray:COSArray = new COSArray();
				pages.setItem( COSName.KIDS, kidsArray );
				pages.setItem( COSName.COUNT, new COSInteger( 0 ) );
			}
		}
		
		/**
		 * 
		 * @param	input pdf file byteArray
		 * @return
		 */
		public static function load( input:FileInputStream ):PDFDocument
		{
			var parser:PDFParser = new PDFParser( input );
			parser.parse();
			return parser.getPDFDocument();
		}	
		
		public function getDocumentCatalog():PDFDocumentCatalog
		{
			if( documentCatalog == null )
			{
				var trailer:COSDictionary = document.getTrailer();
				var infoDic:COSDictionary = trailer.getDictionaryObject( COSName.ROOT ) as COSDictionary;
				if( infoDic == null )
				{
					documentCatalog = new PDFDocumentCatalog( this );
				}else
				{
					documentCatalog = new PDFDocumentCatalog( this, infoDic );
				}

			}
			return documentCatalog;
		}
		
		public function getDocument():COSDocument
		{
			return document;
		}
		/**
		 * check the pdf file is encrypted
		 * 
		 * @return
		 */
		public function isEncrypted():Boolean {
			return document.isEncrypted();
		}
		
		public function getDocumentInformation():PDFDocumentInformation
		{
			if( documentInformation == null )
			{
				var trailer:COSDictionary = document.getTrailer();			
				var infoDic:COSDictionary = trailer.getDictionaryObject( COSName.INFO ) as COSDictionary;
				if( infoDic == null )
				{
					infoDic = new COSDictionary();
					trailer.setItem( COSName.INFO, infoDic );
				}
				documentInformation = new PDFDocumentInformation( infoDic );
			}
			return documentInformation;
		}

		
	}
	
}