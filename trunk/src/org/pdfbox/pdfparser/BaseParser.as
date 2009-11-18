package org.pdfbox.pdfparser
{
	
	import org.pdfbox.io.FileInputStream;	
	
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSNull;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSBoolean;
	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSStream;
	import org.pdfbox.cos.COSString;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.cos.COSInteger;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSDocument;
	import org.pdfbox.cos.COSObject;
	
	import org.pdfbox.utils.COSObjectKey	
	import org.pdfbox.utils.ByteUtil;
	
	import org.pdfbox.log.PDFLogger;
	
	import flash.utils.ByteArray;
	
	public class BaseParser 
	{
		
		public static var ENDSTREAM:Array = [ 101, 110, 100, 115, 116, 114, 101, 97, 109 ];
		
		protected var pdfSource:FileInputStream;
		
		protected var document:COSDocument;
		
		private var xrefs:Array = new Array();
		
		public static var DEF:String = "def";
		
		protected var FILE_END:String = "%%EOF";
		
		//
		
		public function BaseParser( source:ByteArray ) 
		{
			if ( source is FileInputStream) {
				pdfSource = source as FileInputStream;
			}else {
				pdfSource = new FileInputStream();
				pdfSource.data = source;
			}
		}
		
		protected function isHexDigit(ch:String):Boolean
		{
			//return (ch >= '0' && ch <= '9') || 	(ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F');	
			
			var c:int = ch.charCodeAt(0);
			return (c >= 48 && c <= 57) || 	(c >= 97 && c <= 122) || (c >= 65 && c <= 90);	
		}
		
		protected function isDigit( c:int ):Boolean
		{
			return c >= 48 && c <= 57;
		}
		
		protected function isWhitespace( c:int):Boolean{
			return c == 0|| c == 9|| c == 12|| c == 10|| c == 13|| c == 32;
		}
		
		protected function isEOL(c:int):Boolean{
			return c == 10|| c == 13;
		}
		protected function isEndOfName(ch:String):Boolean{
			return (ch == ' ' || ch.charCodeAt(0) == 13|| ch.charCodeAt(0) == 10|| ch.charCodeAt(0) == 9|| ch == '>' || ch == '<'
            || ch == '[' || ch =='/' || ch ==']' || ch ==')' || ch =='(' ||
            ch.charCodeAt(0) == -1//EOF
            );
		}
		protected function isClosing(c:int):Boolean{
			return String.fromCharCode(c) == ']';
		}
		
		protected function skipSpaces():void
		{
			if (pdfSource.isEOF()) {
				return;
			}
			var c:int= pdfSource.read();
			// identical to, but faster as: isWhiteSpace(c) || c == 37
			while(c == 0|| c == 9|| c == 12|| c == 10|| c == 13|| c == 32|| c == 37)		//37 is the % character
			{
				if ( c == 37)
				{
					// skip past the comment section
					c = pdfSource.read();
					while(!isEOL(c) && c != -1)
					{
						c = pdfSource.read();
					}
				}
				else 
				{
					c = pdfSource.read();
				}
			}
			if (c != -1)
			{
				pdfSource.unread(c);
			}			
		}
		
		protected function readExpectedString( theString:String ):String
		{
			var c:int = pdfSource.read();
			// != -1 ---  it could work now,but i think i need to remove it in some day,may be...
			while( isWhitespace(c) && c != -1)
			{
				c = pdfSource.read();
			}
			var buffer:Array = new Array( theString.length );
			var charsRead:int = 0;
			while( !isEOL(c) && c != -1 && charsRead < theString.length )
			{
				var next:String = String.fromCharCode(c);
				buffer.push( next );
				if( theString.charAt( charsRead ) == next )
				{
					charsRead++;
				}
				else
				{
					throw( "Error: Expected to read '" + theString +
						"' instead started reading '" +buffer.toString() + "'" );
				}
				c = pdfSource.read();
			}
			while( isEOL(c) && c != -1 )
			{
				try{
					c = pdfSource.read();
				}catch (e:Error) {
					c = -1;
					break;
				}
			}
			if (c != -1)
			{
				pdfSource.unread(c);
			}
			return buffer.join("");
		}

		
		//-----------------------
		
		protected function readString( length:int = 0 ):String 
		{
			skipSpaces();
			var buffer:Array = new Array();
			var c:int = pdfSource.read();
			
			if ( length == 0 ){
				while( !isEndOfName(String.fromCharCode(c)) && !isClosing(c) && c != -1)
				{
					buffer.push( String.fromCharCode(c));
					c = pdfSource.read();
				}
			}else {
				var tmp:String = String.fromCharCode(c);
				while ( !isWhitespace(c) && !isClosing(c) && c != -1 && buffer.length < length && tmp != '[' &&	tmp != '<' &&	tmp != '(' &&				tmp != '/' )
				{
					buffer.push( String.fromCharCode(c));
					c = pdfSource.read();
					tmp = String.fromCharCode(c);
				}
			}
			if (c != -1)
			{
				pdfSource.unread(c);
			}
			return buffer.join("");
		}
	
		protected function readInt():int
		{
			skipSpaces();
			var retval:int= 0;

			var lastByte:int= 0;
			var intBuffer:Array= new Array();
			while( (lastByte = pdfSource.read() ) != 32&&
			lastByte != 10&&
			lastByte != 13&&
			lastByte != 0&& 
			lastByte != -1)
			{
				intBuffer.push( String.fromCharCode(lastByte ));
			}
			
			retval = int( intBuffer.join("") );
			
			return retval;
		}
		
		protected function parseDirObject():COSBase
		{
			var retval:COSBase;

			skipSpaces();
			var nextByte:int = pdfSource.peek();
			var c:String = String.fromCharCode(nextByte);
			
			//PDFLogger.log("parseDirObject>>" + nextByte + ":" + c);
			switch(c)
			{
				case '<':
				{
					var leftBracket:int = pdfSource.read();//pull off first left bracket
					c = String.fromCharCode(pdfSource.peek()); //check for second left bracket
					pdfSource.unread( leftBracket );					
					
					if(c == '<')
					{						
						retval = parseCOSDictionary();
						skipSpaces();
					}
					else
					{						
						retval = parseCOSString();						
					}
					break;
				}
				case '[': // array
				{
					retval = parseCOSArray();
					break;
				}
				case '(':
					retval = parseCOSString();
					break;
				case '/':   // name
					retval = parseCOSName();
					break;
				case 'n':   // null
				{
					var nullString:String = readString();
					if( nullString !=  "null" )
					{
						throw ("Expected='null' actual='" + nullString + "'");
					}
					retval = COSNull.NULL;
					break;
				}
				case 't':
				{
					var trueBytes:ByteArray = new ByteArray();
					pdfSource.readBytes( trueBytes, 0, 4 );
					var trueString:String = ByteUtil.toStringFromBytes( trueBytes, 0, 4 );
					if( trueString ==  "true" )
					{
						retval = COSBoolean.TRUE;
					}
					else
					{
						throw( "expected true actual='" + trueString + "' " + pdfSource );
					}
					break;
				}
				case 'f':
				{
					var falseBytes:ByteArray = new ByteArray();
					pdfSource.readBytes( falseBytes, 0, 5 );
					var falseString:String = ByteUtil.toStringFromBytes( falseBytes, 0, 5 );
					if( falseString ==  "false" )
					{
						retval = COSBoolean.FALSE;
					}
					else
					{
						throw ( "expected false actual='" + falseString + "' " + pdfSource );
					}
					break;
				}
				case 'R':					
					pdfSource.read();
					retval = new COSObject(null);
					break;
				case String.fromCharCode( -1):					
					return null;
				default:
				{
					//PDFLogger.log("default:" + c +":" + isDigit(nextByte));
					if( isDigit(nextByte) || c == '-' || c == '+' || c == '.')
					{
						var buf:String = '';
						var ic:int = pdfSource.read();
						c = String.fromCharCode(ic);
						while( this.isDigit( ic )||
							   c == '-' ||
							   c == '+' ||
							   c == '.' ||
							   c == 'E' ||
							   c == 'e' )
						{
							buf +=  c ;
							ic = pdfSource.read();
							c = String.fromCharCode(ic);
						}
						if( ic != -1 )
						{
							pdfSource.unread( ic );
						}
						//strange ???
						retval = COSNumber.get( buf );
					}
					else
					{
						//This is not suppose to happen, but we will allow for it
						//so we are more compatible with POS writers that don't
						//follow the spec
						var badString:String = readString();
						//throw new IOException( "Unknown dir object c='" + c +
						//"' peek='" + (char)pdfSource.peek() + "' " + pdfSource );
						if( badString == null || badString.length == 0 )
						{
							var peek:int = pdfSource.peek();
							// we can end up in an infinite loop otherwise
							throw ( "Unknown dir object c='" + c);
							//throw ( "Unknown dir object c='" + c +	"' cInt=" + (int)c + " peek='" + String.fromCharCode(peek) + "' peekInt=" + peek + " " + pdfSource );
						}

					}
				}
			}
			//PDFLogger.log("parseDirObject ---------" + retval);
			return retval;
		}
		
		protected function parseCOSStream( dic:COSDictionary ) :COSStream
		{
			var stream:COSStream = new COSStream( dic );
			
			var out:ByteArray;
			//try{
				var streamString:String = readString();
				//long streamLength;

				if (streamString != "stream")
				{
					throw("expected='stream' actual='" + streamString + "'");
				}

				//PDF Ref 3.2.7 A stream must be followed by either
				//a CRLF or LF but nothing else.

				var whitespace:int = pdfSource.read();
				
				//see brother_scan_cover.pdf, it adds whitespaces
				//after the stream but before the start of the 
				//data, so just read those first
				while (whitespace == 0x20)
				{
					whitespace = pdfSource.read();
				}

				if( whitespace == 0x0D )
				{
					whitespace = pdfSource.read();
					if( whitespace != 0x0A )
					{
						pdfSource.unread( whitespace );
						//The spec says this is invalid but it happens in the real
						//world so we must support it.
						//throw new IOException("expected='0x0A' actual='0x" +
						//    Integer.toHexString(whitespace) + "' " + pdfSource);
					}
				}
				else if (whitespace == 0x0A)
				{
					//that is fine
				}
				else
				{
					//we are in an error.
					//but again we will do a lenient parsing and just assume that everything
					//is fine
					pdfSource.unread( whitespace );
					//throw new IOException("expected='0x0D or 0x0A' actual='0x" +
					//Integer.toHexString(whitespace) + "' " + pdfSource);

				}


				var streamLength:COSBase = dic.getDictionaryObject(COSName.LENGTH);
				/*long length = -1;
				if( streamLength instanceof COSNumber )
				{
					length = ((COSNumber)streamLength).intValue();
				}
				else if( streamLength instanceof COSObject &&
						 ((COSObject)streamLength).getObject() instanceof COSNumber )
				{
					length = ((COSNumber)((COSObject)streamLength).getObject()).intValue();
				}*/

				//length = -1;
				//streamLength = null;

				//Need to keep track of the
				out = stream.createFilteredStream( streamLength );
				var endStream:String = null;
				//the length is wrong in some pdf documents which means
				//that PDFBox must basically ignore it in order to be able to read
				//the most number of PDF documents.  This of course is a penalty hit,
				//maybe I could implement a faster parser.
				/**if( length != -1 )
				{
					byte[] buffer = new byte[1024];
					int amountRead = 0;
					int totalAmountRead = 0;
					while( amountRead != -1 && totalAmountRead < length )
					{
						int maxAmountToRead = Math.min(buffer.length, (int)(length-totalAmountRead));
						amountRead = pdfSource.read(buffer,0,maxAmountToRead);
						totalAmountRead += amountRead;
						if( amountRead != -1 )
						{
							out.write( buffer, 0, amountRead );
						}
					}
				}
				else
				{**/
					readUntilEndStream( out );
				/**}*/
				skipSpaces();
				endStream = readString();
				if (endStream != "endstream")
				{
					readUntilEndStream( out );
					endStream = readString();
					if( endStream != "endstream" )
					{
						throw ("expected='endstream' actual='" + endStream + "' " + pdfSource);
					}
				}
			//}

			return stream;
		}
		
		private function readUntilEndStream( out:ByteArray ) :void
		{
			//PDFLogger.log("readUnitilEndStream:" + pdfSource.peek() );
			
			var currentIndex:int = 0;
			var byteRead:int = 0;
			//this is the additional bytes buffered but not written
			var additionalBytes:int=0;
			var buffer:Array = new Array(ENDSTREAM.length+additionalBytes);
			var writeIndex:int = 0;
			
			//FIXME
			//stop just meet "endstream"
			//not sure
			while(!cmpCircularBuffer( buffer, currentIndex, ENDSTREAM ) )
			//while(!cmpCircularBuffer( buffer, currentIndex, ENDSTREAM ) && byteRead != -1 )
			{
				writeIndex = currentIndex - buffer.length;
				if( writeIndex >= 0 )
				{
					//read all stream byte
					//TODO -- do you read the "endstream"???
					out.writeByte( buffer[writeIndex%buffer.length] );
				}
				byteRead = pdfSource.read();
				buffer[currentIndex%buffer.length] = byteRead;
				currentIndex++;
			}
			pdfSource.unreadBytes( ByteUtil.toByteArray(ENDSTREAM) );
		}
		
		/**
		 * This basically checks to see if the next compareTo.length bytes of the
		 * buffer match the compareTo byte array.
		 */		
		private function cmpCircularBuffer( buffer:Array, currentIndex:int, compareTo:Array ):Boolean
		{
			var cmpLen:int = compareTo.length;
			var buflen:int = buffer.length;
			var match:Boolean = true;
			var off:int = currentIndex-cmpLen;
			if( off < 0 )
			{
				match = false;
			}
			for( var i:int=0; match && i<cmpLen; ++i )
			{
				match = buffer[(off+i)%buflen] == compareTo[i];
			}
			return match;
		}
		
		protected function parseCOSDictionary():COSDictionary
		{
			//PDFLogger.log("parseCOSDictionary>>");
			var c:String = pdfSource.readChar();
			if( c != '<')
			{
				throw( "expected='<' actual='" + c + "'" );
			}
			c = pdfSource.readChar();
			if( c != '<')
			{
				throw( "expected='<' actual='" + c + "' " + pdfSource );
			}
			skipSpaces();
			var obj:COSDictionary = new COSDictionary();
			var done:Boolean = false;
			while( !done )
			{
				skipSpaces();
				c = String.fromCharCode(pdfSource.peek());
				if( c == '>')
				{
					done = true;
				}
				else
				{
					var key:COSName = parseCOSName();
					var value:COSBase = parseCOSDictionaryValue();
					skipSpaces();
					if( String.fromCharCode(pdfSource.peek()) == 'd' )
					{
						//if the next string is 'def' then we are parsing a cmap stream
						//and want to ignore it, otherwise throw an exception.
						var potentialDEF:String = readString();
						if( potentialDEF != DEF )
						{
							//TODO
							pdfSource.unreadBytes( ByteUtil.getBytes(potentialDEF) );
						}
						else
						{
							skipSpaces();
						}
					}

					if( value == null )
					{
						throw("Bad Dictionary Declaration " + pdfSource );
					}					
					obj.setItem( key, value );
				}
			}
			var ch:String = pdfSource.readChar();
			if( ch != '>' )
			{
				throw ( "expected='>' actual='" + ch + "'" );
			}
			ch = pdfSource.readChar();
			if( ch != '>' )
			{
				throw( "expected='>' actual='" + ch + "'" );
			}
			return obj;
		}
		
		protected function parseCOSString():COSString {
			
			var nextChar:String = pdfSource.readChar();
			var retval:COSString = new COSString();
			var openBrace:String;
			var closeBrace:String;
			if( nextChar == '(' )
			{
				openBrace = '(';
				closeBrace = ')';
			}
			else if( nextChar == '<' )
			{
				openBrace = '<';
				closeBrace = '>';
			}
			else
			{
				throw( "parseCOSString string should start with '(' or '<' and not '" +
									   nextChar + "' " + pdfSource );
			}

			//This is the number of braces read
			//
			var braces:int = 1;
			var c:int = pdfSource.read();
			//Fix the bug 
			//while( braces > 0 && c != -1)
			while( braces > 0 )
			{				
				var ch:String = String.fromCharCode(c);
				var nextc:int = -2; // not yet read
								
				//PDFLogger.log( "Parsing COSString character " + c + ":" + ch);
				if(ch == closeBrace)
				{
					braces--;					
					var nextThreeBytes:ByteArray = new ByteArray()
					pdfSource.readMostBytes(nextThreeBytes,0,3);
					
					//lets handle the special case seen in Bull  River Rules and Regulations.pdf
					//The dictionary looks like this
					//    2 0 obj
					//    <<
					//        /Type /Info
					//        /Creator (PaperPort http://www.scansoft.com)
					//        /Producer (sspdflib 1.0 http://www.scansoft.com)
					//        /Title ( (5)
					//        /Author ()
					//        /Subject ()
					//
					// Notice the /Title, the braces are not even but they should
					// be.  So lets assume that if we encounter an this scenario
					//   <end_brace><new_line><opening_slash> then that
					// means that there is an error in the pdf and assume that
					// was the end of the document.					
					
					if( nextThreeBytes.length == 3 )
					{
						if( nextThreeBytes[0] == 0x0d &&
							nextThreeBytes[1] == 0x0a &&
							nextThreeBytes[2] == 0x2f )
						{
							braces = 0;
						}
					}
					pdfSource.unreadBytes( nextThreeBytes );					
					if( braces != 0 )
					{
						retval.append( ch );
					}
				}
				else if( ch == openBrace )
				{
					braces++;
					retval.append( ch );
				}
				else if( ch == '\\' )
				{
					 //patched by ram
					var next:String = pdfSource.readChar();
					switch(next)
					{
						case 'n':
							retval.append( '\n' );
							break;
						case 'r':
							retval.append( '\r' );
							break;
						case 't':
							retval.append( '\t' );
							break;
						case 'b':
							retval.append( '\b' );
							break;
						case 'f':
							retval.append( '\f' );
							break;
						case '(':
						case ')':
						case '\\':
							retval.append( next );
							break;
						case 10:
						case 13:
							//this is a break in the line so ignore it and the newline and continue
							c = pdfSource.read();
							while( isEOL(c) && c != -1)
							{
								c = pdfSource.read();
							}
							nextc = c;
							break;
						case '0':
						case '1':
						case '2':
						case '3':
						case '4':
						case '5':
						case '6':
						case '7':
						{
							var octal:Array = new Array();
							octal.push( next );
							c = pdfSource.read();
							var digit:String = String.fromCharCode(c);
							if( c >= 48 && c <= 55 )
							{
								octal.push( digit );
								c = pdfSource.read();
								digit = String.fromCharCode(c);
								//if ( digit >= '0' && digit <= '7' )
								if( c >= 48 && c <= 55 )
								{
									octal.push( digit );
								}
								else 
								{
									nextc = c;
								}
							}
							else
							{
								nextc = c;
							}   

							var character:int = 0;

							character = parseInt( octal.join(), 8 );
							
							retval.append( character );
							break;
						}
						default:
						{
							retval.append( '\\' );
							retval.append( next );
							//another ficken problem with PDF's, sometimes the \ doesn't really
							//mean escape like the PDF spec says it does, sometimes is should be literal
							//which is what we will assume here.
							//throw new IOException( "Unexpected break sequence '" + next + "' " + pdfSource );
						}
					}
				}
				else
				{
					if( openBrace == '<' )
					{
						if( isHexDigit(ch) )
						{
							retval.append( ch );
						}
					}
					else
					{
						retval.append( ch );
					}
				}
				if (nextc != -2)
				{
					c = nextc;
				}
				else 
				{
					c = pdfSource.read();
				}
			}//end while
			if (c != -1)
			{
				pdfSource.unread(c);
			}
			if( openBrace == '<' )
			{
				retval = COSString.createFromHexString( retval.getString() );
			}
			//PDFLogger.log("parseCOSString ---------" + retval);
			return retval;
		}
		
		private function parseCOSDictionaryValue():COSBase
		{
			//PDFLogger.log("parseCOSDictionaryValue>>");
			
			var retval:COSBase = null;
			var number:COSBase = parseDirObject();
			skipSpaces();
			var next:String = String.fromCharCode(pdfSource.peek());			
			if( next >= "0" && next <= "9" )
			{
				var generationNumber:COSBase = parseDirObject();
				skipSpaces();
				var r:String = pdfSource.readChar();
				if( r != 'R' )
				{
					throw( "expected='R' actual='" + r + "' " + pdfSource );
				}
				var key:COSObjectKey = new COSObjectKey(( number as COSInteger).intValue(),
													( generationNumber as COSInteger).intValue());
				retval = document.getObjectFromPool(key);
			}
			else
			{
				retval = number;
			}
			//PDFLogger.log("parseCOSDictionaryValue>>"+next);
			return retval;
		}

		
		protected function parseCOSName():COSName {			
			var retval:COSName = null;
			var c:int = pdfSource.read();
			if( String.fromCharCode(c) != '/')
			{
				throw("expected='/' actual='" + String.fromCharCode(c) + "'-" + c + " " + pdfSource );
			}
			// costruisce il nome
			var buffer:Array = new Array();
			c = pdfSource.read();
			while( c != -1 )
			{
				var ch:String = String.fromCharCode(c);				
				if(ch == '#')
				{
					var ch1:String = pdfSource.readChar();
					var ch2:String = pdfSource.readChar();

					// Prior to PDF v1.2, the # was not a special character.  Also,
					// it has been observed that various PDF tools do not follow the
					// spec with respect to the # escape, even though they report
					// PDF versions of 1.2 or later.  The solution here is that we
					// interpret the # as an escape only when it is followed by two
					// valid hex digits.
					//
					if (isHexDigit(ch1) && isHexDigit(ch2))
					{
						var hex:String = "" + ch1 + ch2;
						
						buffer.push( String(parseInt(hex, 16)));
	
						c = pdfSource.read();
					}
					else
					{
						pdfSource.unread(ch2.charCodeAt(0));
						c = ch1.charCodeAt(0);
						buffer.push( ch );
					}
				}
				else if (isEndOfName(ch))
				{
					break;
				}
				else
				{
					buffer.push( ch );
					c = pdfSource.read();
				}
			}//End while
			if (c != -1)
			{
				pdfSource.unread(c);
			}
			//PDFLogger.log("parseCOSName>>"+buffer.join(""));
			retval = COSName.getPDFName( buffer.join("") );
			return retval;
		}
		protected function parseBoolean():COSBoolean {
			var retval:COSBoolean = null;
			var c:String = String.fromCharCode(pdfSource.peek());
			if( c == 't' )
			{					
				var trueArray:ByteArray = new ByteArray();
				pdfSource.readBytes( trueArray, 0, 4 );
				var trueString:String = ByteUtil.toStringFromBytes( trueArray, 0, 4 );
				if( trueString !=  "true" )
				{
					throw( "Error parsing boolean: expected='true' actual='" + trueString + "'" );
				}
				else
				{
					retval = COSBoolean.TRUE;
				}
			}
			else if( c == 'f' )
			{
				var falseBytes:ByteArray = new ByteArray();
				pdfSource.readBytes( falseBytes, 0, 5 );
				var falseString:String = ByteUtil.toStringFromBytes( falseBytes, 0, 5 );

				if( falseString != "false" )
				{
					throw( "Error parsing boolean: expected='true' actual='" + falseString + "'" );
				}
				else
				{
					retval = COSBoolean.FALSE;
				}
			}
			else
			{
				throw( "Error parsing boolean expected='t or f' actual='" + c + "'" );
			}
			return retval;
		}
		
		protected function parseCOSArray():COSArray
		{			
			//PDFLogger.log("start parseCOSArray");
			var ch:String = pdfSource.readChar();
			if( ch != '[')
			{
				throw( "expected='[' actual='" + ch + "'" );
			}
			var po:COSArray = new COSArray();
			var pbo:COSBase = null;
			skipSpaces();
			var i:int = 0;
			while( ((i = pdfSource.peek()) > 0) && (String.fromCharCode(i) != ']') )
			{
				pbo = parseDirObject();	
				// *** 
				// COSArray: [0 0 595.3 841.9]  or [ 3 0 R]
				// if is COSObject,the get (i-1) and (i-2) to get the real object by object ID 
				// when pbo is "R" ( cosobject ) 
				// ***
				if( pbo is COSObject && po.size() >= 2 )
				{
					var genNumber:COSInteger = po.removeAt( po.size() -1 ) as COSInteger;
					//id
					var number:COSInteger = po.removeAt( po.size() -1 ) as COSInteger;					
					if( genNumber && number){
						var key:COSObjectKey = new COSObjectKey(number.intValue(), genNumber.intValue());
						//put into object pool
						//if it's object reference,then will be replaced when find the real object
						pbo = document.getObjectFromPool(key);
					}
				}
				if( pbo != null )
				{
					po.add( pbo );
				}
				else
				{
					//it could be a bad object in the array which is just skipped
				}
				skipSpaces();
			}
			//PDFLogger.log("]"+pdfSource.position+":"+String.fromCharCode(pdfSource.peek()));
			pdfSource.read(); //read ']'
			skipSpaces();
			//PDFLogger.log("End parseCOSArray:"+po.getArray());
			return po;
		}



		/**
		 * This will add an xref.
		 *
		 * @param xref The xref to add.
		 */
		public function addXref( xref:PDFXref):void{
			xrefs.push(xref);
		}

		/**
		 * This will get all of the xrefs.
		 *
		 * @return A list of all xrefs.
		 */
		public function getXrefs():Array{
			return xrefs;
		}
		
	}
	
}