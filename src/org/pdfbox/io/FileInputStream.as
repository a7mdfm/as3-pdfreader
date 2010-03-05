package org.pdfbox.io  
{
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 */
	public class FileInputStream extends ByteArray
	{	
		public function set data ( ba:ByteArray ):void {
			
			this.position = 0;
			writeBytes(ba);
			this.position = 0;
		}
		
		/**
		 * get the next byte and don't move the position
		 * @return
		 */
		public function peek():Number
		{
			if ( !this.bytesAvailable ) {
				return NaN;
			}
			var result:int = this.readByte();			
			unread( result );
			return result;
		}
		
		public function read():Number {
			if ( !this.bytesAvailable ) {
				return NaN;
			}
			return this.readByte();
		}
		
		public function readChar():String {
			var i:int = read();
			if ( isNaN(i) ) {
				return null;
			}
			return String.fromCharCode(i);
		}
		
		public function reset():void {
			this.length = 0;
		}
		
		/**
		 * 
		 * @param	ba
		 * @param	offset
		 * @param	len
		 * @return
		 */
		public function readMostBytes( ba:ByteArray, offset:int, len:int):int {
			
			if ( this.bytesAvailable < 1 ) {
				return -1;
			}
			if (this.bytesAvailable < len ) {
				len = this.bytesAvailable;
				
				readBytes(ba, offset, len);
				return -1;
			}
			readBytes(ba, offset, len);
			return this.position;
		}
		
		/*public function unreadBytes ( ba:ByteArray, offset:int, len:int) :void {
			this.writeBytes(ba, offset, len);
		}*/
		
		public function unread(i:Object):void {
			
			var k:int;
			if ( i is String) {
				k = String(i).charCodeAt(0);
			}else {
				k = int(i);
			}
			
			this.position--;
			writeByte( k );
			this.position--;
		}
		
		public function unreadBytes ( ba:ByteArray ):void {
			/*ba.position = 0;
			while (ba.bytesAvailable) {
				unread(ba.readByte());
			}*/
			var len:int = ba.length;
			this.position -= len;
			this.writeBytes (ba);
			this.position -= len;
		}
		
		public function isEOF():Boolean
		{
			return this.bytesAvailable < 1;
			//var peek:int = peek();
			//return peek == -1;
		}			
	}	
}