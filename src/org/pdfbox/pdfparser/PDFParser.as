package org.pdfbox.pdfparser  
{
	
	import flash.utils.ByteArray;
	import org.pdfbox.pdmodel.PDFDocument;
	import org.pdfbox.cos.COSDocument;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSObject;
	import org.pdfbox.cos.COSStream;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.utils.COSObjectKey;
	import org.pdfbox.utils.ByteUtil;
	import org.pdfbox.io.FileInputStream;
	
	import org.pdfbox.log.PDFLogger;
	
	public class PDFParser extends BaseParser
	{
		
		private static var SPACE_BYTE:int = 32;

		private static var PDF_HEADER:String = "%PDF-";
	
		public function PDFParser( source:FileInputStream ) 
		{
			super(source);
		}
		
		public function parse():void
		{
			document = new COSDocument();
			
			var header:String = readLine();		
			document.setHeaderString( header );
			//PDFLogger.log( "Header>>"+header );
			
			if( header.length < PDF_HEADER.length+1 )
            {
                throw( "Error: Header is corrupt '" + header + "'" );
            }
			
			var headerStart:int = header.indexOf( PDF_HEADER );
            //
            if( headerStart > 0 )
            {
                //trim off any leading characters
                header = header.substring( headerStart, header.length );
            }

            var pdfVersion:String = header.substring(PDF_HEADER.length, Math.min( header.length, PDF_HEADER.length + 3)  );			
            document.setVersion( parseFloat(pdfVersion) );
			//PDFLogger.log( "PDF Version>>" + pdfVersion );
			
			skipHeaderFillBytes();

			// start parse object
			///*
			var nextObject:Object;
            var wasLastParsedObjectAnXref:Boolean = false;
			
			while( (nextObject = parseObject()) != null && !pdfSource.isEOF())
			{
				if( nextObject is PDFXref )
				{
					var xref:PDFXref = nextObject as PDFXref;
					addXref(xref);
					wasLastParsedObjectAnXref = true;
				}
				else
				{
					wasLastParsedObjectAnXref = false;
				}
				skipSpaces();
			}			
			if( document.getTrailer() == null )
			{
				var trailer:COSDictionary = new COSDictionary();
				var xrefIter:Array = document.getObjectsByName( "XRef" );
				for (var k:int = 0, len:int = xrefIter.length; k < len; k++)
				{
					var next:COSStream = COSObject(xrefIter[k]).getObject() as COSStream;
					trailer.addAll( next );
				}
				document.setTrailer( trailer );
			}
			if( !document.isEncrypted() )
			{
				document.dereferenceObjectStreams();
			}
			
			//remove byte data
			pdfSource = null;
		}
		
		public function getPDFDocument() :PDFDocument
		{
			return new PDFDocument( document );
		}
		
		//read one line from the binary stream		
		protected function readLine():String
		{
			var c:int= pdfSource.read();
			while(isWhitespace(c) && c != -1)
			{
				c = pdfSource.read();
			}
			var out:Array= new Array();
			
			while( !isEOL(c) && c != -1)
			{
				out.push( String.fromCharCode( c ));
				c = pdfSource.read();
			}
			while( isEOL(c) && c != -1)
			{
				c = pdfSource.read();
			}
			if (c != -1)
			{
				pdfSource.unread(c);
			}
			return out.join("");
		}
		
		//
		protected function skipHeaderFillBytes():void
		{
			skipSpaces();
			var c:int = pdfSource.peek();
			
			if( !isDigit(c) )
			{
				// => skip until EOL
				//PDFLogger.log(readLine());
			}
		}	
		
		private function parseObject():Object
		{
			var object:Object;			
			skipSpaces();
			var peekedChar:String = String.fromCharCode(pdfSource.peek());			
			//if is endobj,just move on
			while( peekedChar == 'e' )
			{
				//there are times when there are multiple endobj, so lets
				readString();
				skipSpaces();
				peekedChar = String.fromCharCode(pdfSource.peek());
			}
			//PDFLogger.log ("       || parseObject peekedChar:"+peekedChar );
			if( pdfSource.isEOF() )
			{
				//"Skipping because of EOF" );
				//end of file we will return a null object
			}else if ( peekedChar == 'x' || peekedChar == 't' ||	peekedChar == 's')
			{
				// x -- xref    t -- trailer    s -- startxref
				//PDFLogger.log ("parseObject() parsing xref" );

				//FDF documents do not always have the xref
				if( peekedChar == 'x' || peekedChar == 't' )
				{
					object = parseXrefSection();
				}
				
				//if peeked char is xref or startxref
				if( peekedChar == 'x' || peekedChar == 's')
				{
					skipSpaces();
					while( String.fromCharCode(pdfSource.peek()) == 'x' )
					{
						parseXrefSection();
					}
					var startxref:String = readString();
					//PDFLogger.log ("parseObject() startxref:"+startxref );
					if( startxref !=  "startxref" )
					{
						throw ( "expected='startxref' actual='" + startxref + "' " + pdfSource );
					}
					skipSpaces();
					//read some integer that is in the stream but PDFBox doesn't use
					readInt();
				}

				//This MUST be readLine because readString strips out comments
				//and it will think that %% is a comment in from of the EOF
				var eof:String = readExpectedString( FILE_END );
				if( eof.indexOf( FILE_END )== -1 && !pdfSource.isEOF() )
				{
					throw ( "expected='"+FILE_END+"' actual='" + eof + "' next=" + readString() + " next=" +readString() );
				}
				else if( !pdfSource.isEOF() )
				{
					
					//we might really be at the end of the file, there might just be some crap at the
					//end of the file.
					//pdfSource.fillBuffer();
					if( pdfSource.bytesAvailable < 1000 )
					{						
						//We need to determine if we are at the end of the file.
						var data:ByteArray = new ByteArray();

						var amountRead:int = pdfSource.readMostBytes( data,0,1000 );
						if( amountRead != -1 )
						{
							pdfSource.unreadBytes( data );
						}
						var atEndOfFile:Boolean = true;//we assume yes unless we find another.
						for( var i:int=0; i<amountRead-3 && atEndOfFile; i++ )
						{
							atEndOfFile = !(String.fromCharCode(data[i]) == 'E' &&
											String.fromCharCode(data[i+1]) == 'O' &&
											String.fromCharCode(data[i+2]) == 'F' );
						}
						if( atEndOfFile )
						{
							pdfSource.readBytes( data, 0, data.length )
							//while( pdfSource.readBytes( data, 0, data.length ) != -1 )							
							//{
								//read until done.
							//}
						}
					}
				}
			}else
			{
				var number:int = -1;
				var genNum:int = -1;
				var objectKey:String = null;
				var missingObjectNumber:Boolean = false;
				try
				{
					var peeked:String = String.fromCharCode(pdfSource.peek());
					if( peeked == '<' )
					{
						missingObjectNumber = true;
					}
					else
					{
						number = readInt();
					}
				}
				catch( e:Error )
				{
					//ok for some reason "GNU Ghostscript 5.10" puts two endobj
					//statements after an object, of course this is nonsense
					//but because we want to support as many PDFs as possible
					//we will simply try again
					number = readInt();
				}
				if( !missingObjectNumber )
				{
					skipSpaces();
					genNum = readInt();

					objectKey = readString( 3 );
					//PDFLogger.log( "parseObject() num=" + number + " genNumber=" + genNum + " key='" + objectKey + "'" );
					if( objectKey !=  "obj" )
					{
						throw ("expected='obj' actual='" + objectKey + "' " + pdfSource );
					}
				}else
				{
					number = -1;
					genNum = -1;
				}

				skipSpaces();
				
				//
				var pb:COSBase = parseDirObject();
				//
				var endObjectKey:String = readString();
				//PDFLogger.log("endkey:" + endObjectKey + ":"+ (endObjectKey ==  "stream"));
				if( endObjectKey == "stream")
				{
					//这里非常重要，解析流内容
					pdfSource.unreadBytes( ByteUtil.getBytes(endObjectKey) );
					pdfSource.unreadBytes( ByteUtil.getBytes(' ') );
					if( pb is COSDictionary )
					{
						pb = parseCOSStream( COSDictionary(pb) );
					}
					else
					{
						// this is not legal
						// the combination of a dict and the stream/endstream forms a complete stream object
						throw("stream not preceded by dictionary");
					}
					endObjectKey = readString();
				}
				var key:COSObjectKey = new COSObjectKey( number, genNum );
				var pdfObject:COSObject = document.getObjectFromPool( key );				
				pdfObject.setObject(pb);
				object = pdfObject;				

				if( endObjectKey !=  "endobj" )
				{
					if( !pdfSource.isEOF() )
					{
						try
						{
							//It is possible that the endobj  is missing, there
							//are several PDFs out there that do that so skip it and move on.
							parseFloat( endObjectKey );
							pdfSource.unread( SPACE_BYTE );
							pdfSource.unreadBytes( ByteUtil.getBytes(endObjectKey) );
						}
						catch( e:Error )
						{
							//we will try again incase there was some garbage which
							//some writers will leave behind.
							var secondEndObjectKey:String = readString();
							if( secondEndObjectKey != "endobj" )
							{
								if( isClosing(pdfSource.peek()) )
								{
									//found a case with 17506.pdf object 41 that was like this
									//41 0 obj [/Pattern /DeviceGray] ] endobj
									//notice the second array close, here we are reading it 
									//and ignoring and attempting to continue
									pdfSource.read();
								}
								skipSpaces();
								var thirdPossibleEndObj:String = readString();
								if( thirdPossibleEndObj != "endobj" )
								{
									throw ("expected='endobj' firstReadAttempt='" + endObjectKey + "' " +										"secondReadAttempt='" + secondEndObjectKey + "' " + pdfSource);
								}
							}
						}
					}
				}
				//
				skipSpaces();

			}
			//System.out.println( "parsed=" + object );
			return object;
		}
		
		protected function parseXrefSection():PDFXref
		{
			//PDFLogger.log("parseXrefSection");
			var params:Array = new Array(2);
			parseXrefTable(params);
			parseTrailer();
			//PDFLogger.log("End parseXrefSection");
			return new PDFXref(params[0], params[1]);
		}
		
		protected function parseXrefTable(params:Array):void
		{
			var nextLine:String;

			nextLine = readLine();			
			if( nextLine == "xref" )
			{
				params[0] = readInt();
				params[1] = readInt();
				nextLine = readString();
			}
			skipSpaces();
			while( nextLine !=  "trailer"  && !pdfSource.isEOF() && !isEndOfName(String.fromCharCode(pdfSource.peek())) )
			{
				//skip past all the xref entries.
				nextLine = readString();
				skipSpaces();
			}
			skipSpaces();
		}
		
		private function parseTrailer() :void
		{
			//PDFLogger.log("parseTrailer ------------------------------------");
			var parsedTrailer:COSDictionary = parseCOSDictionary();
			var docTrailer:COSDictionary = document.getTrailer();
			if( docTrailer == null )
			{
				document.setTrailer( parsedTrailer );
			}
			else
			{
				docTrailer.addAll( parsedTrailer );
			}
		}
		

	}
	
}