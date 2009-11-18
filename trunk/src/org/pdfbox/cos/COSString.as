package org.pdfbox.cos
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.pdfbox.utils.ByteUtil;
	import org.pdfbox.utils.COSHEXTable;
	
	public class COSString extends COSBase
	{
		/**
		 * One of the open string tokens.
		 */
		public static const STRING_OPEN:Array=  [ 40 ]; //"(".getBytes();
		/**
		 * One of the close string tokens.
		 */
		public static const STRING_CLOSE:Array= [ 41 ]; //")".getBytes( "ISO-8859-1" );
		/**
		 * One of the open string tokens.
		 */
		public static const HEX_STRING_OPEN:Array= [ 60 ]; //"<".getBytes( "ISO-8859-1" );
		/**
		 * One of the close string tokens.
		 */
		public static const HEX_STRING_CLOSE:Array= [ 62 ]; //">".getBytes( "ISO-8859-1" );
		/**
		 * the escape character in strings.
		 */
		public static const ESCAPE:Array= [ 92 ]; //"\\".getBytes( "ISO-8859-1" );

		/**
		 * CR escape characters.
		 */
		public static const CR_ESCAPE:Array= [ 92, 114 ]; //"\\r".getBytes( "ISO-8859-1" );
		/**
		 * LF escape characters.
		 */
		public static const LF_ESCAPE:Array= [ 92, 110 ]; //"\\n".getBytes( "ISO-8859-1" );
		/**
		 * HT escape characters.
		 */
		public static const HT_ESCAPE:Array= [ 92, 116 ]; //"\\t".getBytes( "ISO-8859-1" );
		/**
		 * BS escape characters.
		 */
		public static const BS_ESCAPE:Array= [ 92, 98 ]; //"\\b".getBytes( "ISO-8859-1" );
		/**
		 * FF escape characters.
		 */
		public static const FF_ESCAPE:Array= [ 92, 102 ]; //"\\f".getBytes( "ISO-8859-1" );
		
		private var out:ByteArray= new ByteArray();

		/** 
		 * Forces the string to be serialized in literal form but not hexa form. 
		 */
		private var forceLiteralForm:Boolean= false;
		
		/**
		 * constructor for ease of manual PDF construction.
		 *
		 * @param value The string value of the object.
		 */
		public function COSString( value:Object = null)
		{
			
			if( value is String){
			
				var unicode16:Boolean= false;
				//var chars:Array= value.split();
				for( var i:int=0; i<String(value).length; i++ )
				{
					//TODO
					// Chinese will be negative
					if( String(value).charCodeAt(i) > 255 || String(value).charCodeAt(i) < 0 )
					{
						unicode16 = true; 
					}
				}
				if( unicode16 )
				{
					out.writeByte( 0xFE);
					out.writeByte( 0xFF);
					// *****************************
					out.endian = Endian.BIG_ENDIAN;
					//UTF-16BE
					out.writeBytes( ByteUtil.getBytes( String(value),"unicode" ) );
				}
				else
				{
					out.writeBytes( ByteUtil.getBytes( String(value),"iso-8859-1"));
				}
			}else if ( value is ByteArray) {
				
				out.writeBytes( value as ByteArray );
			}
		}

		
		/**
		 * Forces the string to be written in literal form instead of hexadecimal form. 
		 * 
		 * @param v if v is true the string will be written in literal form, otherwise it will
		 * be written in hexa if necessary.
		 */
		
		public function setForceLiteralForm(v:Boolean):void{
			forceLiteralForm = v;
		}
		
		/**
		 * This will create a COS string from a string of hex characters.
		 * 
		 * @param hex A hex string.
		 * @return A cos string with the hex characters converted to their actual bytes.
		 * @throws IOException If there is an error with the hex string.
		 */
		public static function createFromHexString( hex:String):COSString
		{			
			var retval:COSString= new COSString();
			var hexBuffer:String = hex;
			//if odd number then the last hex digit is assumed to be 0
			if( hexBuffer.length % 2== 1)
			{
				hexBuffer += "0";
			}			
			for( var i:int=0; i<hexBuffer.length;i+=2)
			{
				var hexChars:String= "" + hexBuffer.charAt( i ) + hexBuffer.charAt( i+1 );
				retval.append( parseInt( hexChars, 16) );
				
			}			
			return retval;
		}
		
		/**
		 * This will take this string and create a hex representation of the bytes that make the string.
		 * 
		 * @return A hex string representing the bytes in this string.
		 */
		public function getHexString():String{
			var retval:String= new String();
			var data:ByteArray= getBytes();
			for( var i:int=0; i<data.length; i++ )
			{
				retval+= ( COSHEXTable.HEX_TABLE[ (data[i]+256)%256] );
			}
			
			return retval;
		}

		/**
		 * This will get the string that this object wraps.
		 *
		 * @return The wrapped string.
		 */
		public function getString():String{
			var retval:String;
			var encoding:String= "ISO-8859-1";
			var data:ByteArray = getBytes();
			data.position = 0;
			
			//trace("string:" + data[0] + ":" + data[1]);
			/*
			data.position = 0;
			var start:int= 0;
			if( data.length > 2)
			{
				if( data[0] == 0xFF&& data[1] == 0xFE )
				{
					//encoding = "UTF-16LE";
					start = 2;
					data.endian = Endian.LITTLE_ENDIAN;
				}
				else if( data[0] == 0xFE && data[1] == 0xFF)
				{
					//encoding = "UTF-16BE";
					start = 2;
					data.endian = Endian.BIG_ENDIAN;
				}
				//
				encoding = "unicode";
				//
				retval = data.toString();
			}else {
				retval = data.readMultiByte(data.length - start, encoding);
			}			
			*/
			//TODO
			//retval = ByteUtil.toStringFromBytes(ba,encoding);
			//retval = data.readMultiByte(data.length - start, encoding);
			
			if( data.length > 2)
			{
				if ( (data[0] == 0xFF && data[1] == 0xFE) || (data[0] == 0xFE && data[1] == 0xFF)  )
				{
					retval = data.toString();
					
					return retval;
				}				
			}			
			retval = data.readMultiByte(data.length, encoding);
			
			return retval;
		}

		/**
		 * This will append a byte[] to the string.
		 *
		 * @param data The byte[] to add to this string.
		 *
		 * @throws IOException If an IO error occurs while writing the byte.
		 */
		public function append( data:Object ):void 
		{			
			if ( data is int) {
				out.writeByte ( int(data) );
			}else if ( data is String) {
				out.writeByte (String(data).charCodeAt(0));
			}else if ( data is Array ) {
				out.writeObject ( data);
			}
			
		}

		/**
		 * This will reset the internal buffer.
		 */
		public function reset():void{
			out.position = 0;
		}

		/**
		 * This will get the bytes of the string.
		 *
		 * @return A byte array that represents the string.
		 */
		public function getBytes():ByteArray
		{
			return out;
		}

		/**
		 * {@inheritDoc}
		 */
		public function toString():String{
			//return "COSString{" + ByteUtil.toStringFromBytes(getBytes()) + "}";
			return "[ COSString:"+getString() +"]";
		}
		
		/**
		 * This will output this string as a PDF object.
		 *  
		 * @param output The stream to write to.
		 * @throws IOException If there is an error writing to the stream.
		 */
		public function writePDF( output:ByteArray):void
		{
			var outsideASCII:Boolean= false;
			//Lets first check if we need to escape this string.
			var bytes:ByteArray= getBytes();
			for( var i:int=0; i<bytes.length && !outsideASCII; i++ )
			{
				//if the byte is negative then it is an eight bit byte and is
				//outside the ASCII range.
				outsideASCII = bytes[i] <0;
			}
			if( !outsideASCII || forceLiteralForm )
			{
				output.writeBytes( ByteUtil.toByteArray(STRING_OPEN));
				for( i = 0; i<bytes.length; i++ )
				{
					var b:int= (bytes[i]+256)%256;
					switch( b )
					{
						case '(':
						case ')':
						case '\\':
						{
							output.writeBytes( ByteUtil.toByteArray(ESCAPE));
							output.writeByte(b);
							break;
						}
						case String.fromCharCode(10): //LF
						{
							output.writeBytes( ByteUtil.toByteArray(LF_ESCAPE) );
							break;
						}
						case String.fromCharCode(13): // CR
						{
							output.writeBytes( ByteUtil.toByteArray(CR_ESCAPE) );
							break;
						}
						case '\t':
						{
							output.writeBytes( ByteUtil.toByteArray(HT_ESCAPE) );
							break;
						}
						case '\b':
						{
							output.writeBytes( ByteUtil.toByteArray(BS_ESCAPE) );
							break;
						}
						case '\f':
						{
							output.writeBytes( ByteUtil.toByteArray(FF_ESCAPE) );
							break;
						}
						default:
						{
							output.writeByte( b );
						}
					}
				}
				output.writeBytes( ByteUtil.toByteArray(STRING_CLOSE) );
			}
			else
			{
				output.writeBytes( ByteUtil.toByteArray(HEX_STRING_OPEN) );
				for(i=0; i<bytes.length; i++ )
				{
					output.writeByte( COSHEXTable.TABLE[ (bytes[i]+256)%256] );
				}
				output.writeBytes( ByteUtil.toByteArray(HEX_STRING_CLOSE) );
			}
		}



		/**
		 * visitor pattern double dispatch method.
		 *
		 * @param visitor The object to notify when visiting this object.
		 * @return any object, depending on the visitor implementation, or null
		 * @throws COSVisitorException If an error occurs while visiting this object.
		 */
		override public function accept(visitor:ICOSVisitor):Object
		{
			return visitor.visitFromString( this );
		}

		/**
		 * {@inheritDoc}
		 */
		public function equals(obj:Object):Boolean{
			return (obj is COSString) && COSString(obj).getBytes() == getBytes();
		}

		/**
		 * {@inheritDoc}
		 */
		//TODO
		/*public function hashCode():int{
			return getBytes().hashCode();
		}*/
	}
}