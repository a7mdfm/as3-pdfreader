package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.utils.ByteArray;	
	
	import org.pdfbox.io.FileInputStream;
	import org.pdfbox.io.ASCII85InputStream;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class IOTest extends Sprite 
	{
		
		//
		
		public function IOTest():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			runTest();
		}
		
		private function runTest():void
		{
			
			var s:String = "47 61 75 61 3A 5F 2F 3D 6C 5A 25 23 34 34 35 4B 6F 5D 32 3A 5A 54 27 2A 32 4E 70 46 2C 47 58 2A 33 2C 40 44 58 2E 65 3E 25 33 38 3E 3A 5C 72 5D 74 5B 67 46 6B 66 5C 40 25 2C 53 54 4B 31 2B 5D 60 4E 68 25 69 2F 42 33 42 31 3C 6B 4A 2F 39 2E 2B 59 2A 57 4A 39 5E 40 35 47 32 46 2A 72 27 36 56 26 2E 4A 4E 5B 57 6B 2B 21 6E 66 4D 5B 4B 50 73 5A 58 52 36 46 3E 51 62 25 30 4E 2A 5F 50 70 6C 70 6E 6D 68 29 3E 6B 4E 49 6F 57 45 62 30 39 34 54 22 6C 5E 61 24 5E 56 50 2E 3D 64 4F 35 70 38 4C 2D 68 5C 4D 37 51 43 34 5F 71 66 54 4C 5E 46 3C 34 5B 31 60 21 31 24 6C 3D 3E 5B 3D 2E 34 5B 4B 23 6B 71 3D 3A 5F 55 5D 32 71 5C 2C 44 67 5E 24 3E 71 21 6C 74 34 34 50 3B 65 62 75 55 62 4E 5E 4C 24 36 4B 57 6C 69 6E 40 34 39 38 21 6E 6E 57 35 5A 49 4A 6B 4D 39 4C 2F 66 6B 4D 39 73 23 5E 4F 70 61 2B 72 4D 29 50 72 33 6C 2F 3D 50 48 5F 54 27 35 34 5F 38 29 5C 27 69 59 45 35 4A 28 56 36 63 63 44 74 40 6E 50 65 63 4B 33 61 36 52 47 67 42 42 2D 25 6E 3E 29 2E 23 34 41 61 59 56 5F 2A 2C 52 5A 28 4A 41 5C 56 73 54 6E 5C 40 24 21 75 29 22 5B 6D 33 31 3A 72 33 3E 50 22 5C 25 6F 25 62 61 4D 6A 4A 72 3C 23 6F 5B 30 48 23 5E 35 58 27 70 6C 5C 27 39 49 35 59 30 28 62 33 4E 49 6C 3F 45 5E 43 4A 5F 3F 31 2D 49 3E 74 55 3B 44 72 5B 34 47 67 6E 2B 44 35 44 5F 3A 26 59 3C 44 35 71 68 49 6D 23 42 22 27 61 3C 75 2A 37 5D 64 67 53 6D 54 52 6F 68 69 25 7E 3E 0D 0A"; 
			
			var bytes:ByteArray = new ByteArray();
			var arr:Array = s.split(" ");
			for (var i:int = 0; i < arr.length; i++)
			{
				bytes.writeByte ( parseInt(arr[i], 16) );
			}
			//trace(bytes.length);

			var stream:ASCII85InputStream = new ASCII85InputStream(bytes);
			var result:ByteArray = new ByteArray();
			var buffer:ByteArray = new ByteArray(); //1024
			
			var amountRead:int = 0;
			while( (amountRead = stream.readto( buffer, 0, 1024) ) != -1 )
			{
				result.writeBytes(buffer, 0, amountRead);
			}
			trace(result);
			result.uncompress();
			trace(result);
		}
		
	}
	
}