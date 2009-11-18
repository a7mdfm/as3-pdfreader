package org.pdfbox.pdfparser
{


	import flash.utils.ByteArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSBoolean;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSNull;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.cos.COSObject;
	import org.pdfbox.cos.COSStream;

	//import org.pdfbox.pdmodel.common.PDStream;
	import org.pdfbox.utils.PDFOperator;
	import org.pdfbox.utils.ImageParameters;
	
	import org.pdfbox.utils.ArrayList;

	/**
	 * This will parse a PDF byte stream and extract operands and such.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.32 $
	 */
	public class PDFStreamParser extends BaseParser
	{
		private var streamObjects:ArrayList = new ArrayList( );
		//private RandomAccess file;
		private var lastBIToken:PDFOperator = null;
		
		/**
		 * Constructor.
		 *
		 * @param stream The stream to parse.
		 *
		 */
		public function PDFStreamParser( stream:COSStream )
		{
			super( stream.getUnfilteredStream() );
		}

		/**
		 * This will parse the tokens in the stream.  This will close the
		 * stream when it is finished parsing.
		 *
		 * @throws IOException If there is an error while parsing the stream.
		 */
		public function parse():void
		{
			try
			{
				var token:Object = null;
				while( (token = parseNextToken()) != null )
				{
					streamObjects.add( token );
				}
			}
			finally
			{
				pdfSource = null;
			}
		}

		/**
		 * This will get the tokens that were parsed from the stream.
		 *
		 * @return All of the tokens in the stream.
		 */
		public function getTokens():Array
		{
			return streamObjects.toArray();
		}

		/**
		 * This will parse the next token in the stream.
		 *
		 * @return The next token in the stream or null if there are no more tokens in the stream.
		 *
		 * @throws IOException If an io error occurs while parsing the stream.
		 */
		private function parseNextToken():Object
		{
			var retval:Object = null;

			skipSpaces();
			var nextByte:int = pdfSource.peek();
			if( nextByte == -1 )
			{
				return null;
			}
			var c:String = String.fromCharCode(nextByte);
			var next:String;
			
			switch(c)
			{
				case '<':
				{
					var leftBracket:int = pdfSource.read();//pull off first left bracket
					c = String.fromCharCode(pdfSource.peek()); //check for second left bracket
					pdfSource.unread( leftBracket ); //put back first bracket
					if(c == '<')
					{

						var pod:COSDictionary = parseCOSDictionary();
						skipSpaces();
						if(String.fromCharCode(pdfSource.peek()) == 's')
						{
							retval = parseCOSStream( pod );
						}
						else
						{
							retval = pod;
						}
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
				case '(': // string
					retval = parseCOSString();
					break;
				case '/':   // name
					retval = parseCOSName();
					break;
				case 'n':   // null
				{
					var nullString:String = readString();
					if( nullString == "null" )
					{
						retval = COSNull.NULL;
					}
					else
					{
						retval = PDFOperator.getOperator( nullString );
					}
					break;
				}
				case 't':
				case 'f':
				{
					next = readString();
					if( next ==  "true" )
					{
						retval = COSBoolean.TRUE;
						break;
					}
					else if( next == "false" )
					{
						retval = COSBoolean.FALSE;
					}
					else
					{
						retval = PDFOperator.getOperator( next );
					}
					break;
				}
				case 'R':
				{
					var line:String = readString();
					if( line == "R" )
					{
						retval = new COSObject( null );
					}
					else
					{
						retval = PDFOperator.getOperator( line );
					}
					break;
				}
				case '0':
				case '1':
				case '2':
				case '3':
				case '4':
				case '5':
				case '6':
				case '7':
				case '8':
				case '9':
				case '-':
				case '+':
				case '.':
				{
					if( this.isDigit(nextByte) || c == '-' || c == '+' || c == '.')
					{
						var buf:String = '';
						//TODO
						while( isDigit( nextByte )|| c== '-' || c== '+' || c =='.' )
						{							
							buf +=  c;
							pdfSource.read();
							//
							nextByte = pdfSource.peek();
							c = String.fromCharCode(nextByte);
						}
						retval = COSNumber.get( buf );
					}
					else
					{
						throw ( "Unknown dir object c='" + c +
							"' peek='" + pdfSource.peek() );
					}
					break;
				}
				case 'B':
				{
					next = readString();
					retval = PDFOperator.getOperator( next );

					if( next == "BI" )
					{
						lastBIToken = retval as PDFOperator;
						var imageParams:COSDictionary = new COSDictionary();
						lastBIToken.setImageParameters( new ImageParameters( imageParams ) );
						var nextToken:Object = null;
						while( (nextToken = parseNextToken()) is COSName )
						{
							var value:Object = parseNextToken();
							imageParams.setItem( nextToken as COSName, value as COSBase );
						}
						//final token will be the image data, maybe??
						var imagePD:PDFOperator = nextToken as PDFOperator;
						lastBIToken.setImageData( imagePD.getImageData() );
					}
					break;
				}
				case 'I':
				{
					//ImageParameters imageParams = lastBIToken.getImageParameters();
					
					//int expectedBytes = (int)Math.ceil(imageParams.getHeight() * imageParams.getWidth() *
					//                    (imageParams.getBitsPerComponent()/8) );
					//Special case for ID operator
					var id:String = "" + String.fromCharCode(pdfSource.read()) + String.fromCharCode(pdfSource.read());
					if( id !=  "ID" )
					{
						throw( "Error: Expected operator 'ID' actual='" + id + "'" );
					}
					var imageData:ByteArray = new ByteArray();
					//boolean foundEnd = false;
					if( this.isWhitespace(pdfSource.peek()) )
					{
						//pull off the whitespace character
						pdfSource.read();
					}
					var twoBytesAgo:int = 0;
					var lastByte:int = pdfSource.read();
					var currentByte:int = pdfSource.read();
					var count:int = 0;
					//PDF spec is kinda unclear about this.  Should a whitespace
					//always appear before EI? Not sure, I found a PDF
					//(UnderstandingWebSphereClassLoaders.pdf) which has EI as part
					//of the image data and will stop parsing prematurely if there is
					//not a check for <whitespace>EI<whitespace>.
					while( !(isWhitespace( twoBytesAgo ) &&
							 String.fromCharCode(lastByte) == 'E' &&
							 String.fromCharCode(currentByte) == 'I' &&
							 isWhitespace(pdfSource.peek()) //&&
							 //amyuni2_05d__pdf1_3_acro4x.pdf has image data that
							 //is compressed, so expectedBytes is useless here.
							 //count >= expectedBytes
							 ) &&
						   !pdfSource.isEOF() )
					{
						imageData.writeByte( lastByte );
						twoBytesAgo = lastByte;
						lastByte = currentByte;
						currentByte = pdfSource.read();
						count++;
					}
					pdfSource.unread( 'I' ); //unread the EI operator
					pdfSource.unread( 'E' );
					retval = PDFOperator.getOperator( "ID" );
					(retval as PDFOperator).setImageData( imageData );
					break;
				}
				case ']':
				{
					// some ']' around without its previous '['
					// this means a PDF is somewhat corrupt but we will continue to parse.
					pdfSource.read();
					retval = COSNull.NULL;  // must be a better solution than null...
					break;
				}
				default:
				{
					//we must be an operator
					var operator:String = readOperator();
					//TODO,trim
					if( operator.length == 0 )
					{
						//we have a corrupt stream, stop reading here
						retval = null;
					}
					else
					{
						retval = PDFOperator.getOperator( operator );
					}
				}

			}

			return retval;
		}

		/**
		 * This will read an operator from the stream.
		 *
		 * @return The operator that was read from the stream.
		 *
		 * @throws IOException If there is an error reading from the stream.
		 */
		protected function readOperator():String
		{
			skipSpaces();

			//average string size is around 2 and the normal string buffer size is
			//about 16 so lets save some space.
			var buffer:String = '';
			while(
				!isWhitespace(pdfSource.peek()) &&
				!isClosing(pdfSource.peek()) &&
				!pdfSource.isEOF() &&
				String.fromCharCode(pdfSource.peek()) != '[' &&
				String.fromCharCode(pdfSource.peek()) != '<' &&
				String.fromCharCode(pdfSource.peek()) != '(' &&
				String.fromCharCode(pdfSource.peek()) != '/' &&
				String.fromCharCode(pdfSource.peek()) < '0' ||
				String.fromCharCode(pdfSource.peek()) > '9'  )
			{
				buffer += pdfSource.readChar();
			}
			return buffer;
		}
	}
}