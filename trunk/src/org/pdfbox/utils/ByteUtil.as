package org.pdfbox.utils 
{
	
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author walktree
	 */
	public class ByteUtil 
	{
		
		public static function parseChar ( s:String ):int {
			
			if ( s.length > 1 ) {
				throw( 'sorry,only support char ' );
			}
			
			return s.charCodeAt(0);
		}
		
		public static function toStringFromBytes ( ba:ByteArray,offset:int, len:int = 0) :String {
			
			var s:String = "";
			
			ba.position = offset;
			
			if (len == 0) {
				len = ba.bytesAvailable;
			}
			for (var i:int = 0; i < len; i++) {
				s += String.fromCharCode(ba.readByte());
			}
			return s;
		}
		
		/*
		 *  char code Array -> byteArray
		 */ 
		public static function toByteArray ( codes:Array ):ByteArray {
			
			var output:ByteArray = new ByteArray();
			
			for (var i:int = 0, len:int = codes.length; i < len; i++) {
				output.writeByte( codes[i] );
			}
			output.position = 0;
			return output;
			
		}
		
		public static function getBytes ( value:String, charSet:String = "utf-8" ):ByteArray {
			var output:ByteArray = new ByteArray();
			output.writeMultiByte( value, charSet);
			output.position = 0;
			return output;
		}
	}
	
}