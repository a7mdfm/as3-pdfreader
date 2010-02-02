package org.pdfbox.filter{
	
	import flash.utils.ByteArray;
	
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.utils.COSHEXTable;
	
	import org.pdfbox.log.PDFLogger;

	/**
	 * This is the used for the ASCIIHexDecode filter.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.9 $
	 */
	public class ASCIIHexFilter implements Filter
	{

		/**
		 * Whitespace.
		 *   0  0x00  Null (NUL)
		 *   9  0x09  Tab (HT)
		 *  10  0x0A  Line feed (LF)
		 *  12  0x0C  Form feed (FF)
		 *  13  0x0D  Carriage return (CR)
		 *  32  0x20  Space (SP)  
		 */

		private function isWhitespace(c:int):Boolean 
		{
			return c == 0 || c == 9 || c == 10 || c == 12 || c == 13 || c == 32;
		}
		
		private function isEOD(c:int):Boolean 
		{
			return (c == 62); // '>' - EOD
		}
		
		/**
		  * {@inheritDoc}
		  */
		public function decode( compressedData:ByteArray, result:ByteArray, options:COSDictionary ):void 
		{
			var value:int = 0;
			var firstByte:int = 0;
			var secondByte:int = 0;
			while ( (firstByte = compressedData.readByte()) != -1) 
			{
				// always after first char
				while(isWhitespace(firstByte))
				{
					firstByte = compressedData.read();
				}
				if(isEOD(firstByte))
				{
					break;
				}
		   
				if(REVERSE_HEX[firstByte] == -1)
				{
					PDFLogger.log("Invalid Hex Code; int: " + firstByte );
				}
				value = REVERSE_HEX[firstByte] * 16;
				secondByte = compressedData.readByte();
		   
				if(isEOD(secondByte)) 
				{
					// second value behaves like 0 in case of EOD
					result.writeByte( value );
					break;
				}
				if(secondByte >= 0) 
				{
					if(REVERSE_HEX[secondByte] == -1)
					{
						PDFLogger.log("Invalid Hex Code; int: " + secondByte);
					}
					value += REVERSE_HEX[secondByte];
				}
				result.writeByte( value );
			}
		}

		private static var REVERSE_HEX:Array =
		{
			-1, //0
			-1, //1
			-1, //2
			-1, //3
			-1, //4
			-1, //5
			-1, //6
			-1, //7
			-1, //8
			-1, //9
			-1, //10
			-1, //11
			-1, //12
			-1, //13
			-1, //14
			-1, //15
			-1, //16
			-1, //17
			-1, //18
			-1, //19
			-1, //20
			-1, //21
			-1, //22
			-1, //23
			-1, //24
			-1, //25
			-1, //26
			-1, //27
			-1, //28
			-1, //29
			-1, //30
			-1, //31
			-1, //32
			-1, //33
			-1, //34
			-1, //35
			-1, //36
			-1, //37
			-1, //38
			-1, //39
			-1, //40
			-1, //41
			-1, //42
			-1, //43
			-1, //44
			-1, //45
			-1, //46
			-1, //47
			 0, //48
			 1, //49
			 2, //50
			 3, //51
			 4, //52
			 5, //53
			 6, //54
			 7, //55
			 8, //56
			 9, //57
			-1, //58
			-1, //59
			-1, //60
			-1, //61
			-1, //62
			-1, //63
			-1, //64
			10, //65
			11, //66
			12, //67
			13, //68
			14, //69
			15, //70
			-1, //71
			-1, //72
			-1, //73
			-1, //74
			-1, //75
			-1, //76
			-1, //77
			-1, //78
			-1, //79
			-1, //80
			-1, //81
			-1, //82
			-1, //83
			-1, //84
			-1, //85
			-1, //86
			-1, //87
			-1, //88
			-1, //89
			-1, //90
			-1, //91
			-1, //92
			-1, //93
			-1, //94
			-1, //95
			-1, //96
			10, //97
			11, //98
			12, //99
			13, //100
			14, //101
			15, //102
		};

		/**
		 * {@inheritDoc}
		 */
		public function encode( rawData:ByteArray, result:ByteArray, options:COSDictionary ):void 
		{
			/*
			var byteRead:int = 0;
			while( (byteRead = rawData.readByte()) != -1 )
			{
				var value:int = (byteRead+256)%256;
				result.writeBytes( COSHEXTable.TABLE[value] );
			}			
			*/
		}
	}
}
