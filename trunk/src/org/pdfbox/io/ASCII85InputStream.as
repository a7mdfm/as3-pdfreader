package org.pdfbox.io {
	
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import org.pdfbox.io.FileInputStream;

	/**
	 * This class represents an ASCII85 stream.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.6 $
	 */
	public class ASCII85InputStream 
	{
		private var index:int;
		private var n:int;
		private var eof:Boolean;

		private var ascii:Array;
		private var b:Array;
		
		private var instream:FileInputStream;

		/**
		 * Constructor.
		 *
		 * @param is The input stream to actually read from.
		 */
		public function ASCII85InputStream( $instream:IDataInput ):void
		{
			instream = new FileInputStream();
			instream.data = $instream as ByteArray;
			
			index = 0;
			n = 0;
			eof = false;
			ascii = new Array(5);
			b = new Array(4);
		}

		/**
		 * This will read the next byte from the stream.
		 *
		 * @return The next byte read from the stream.
		 *
		 * @throws IOException If there is an error reading from the wrapped stream.
		 */
		public final function read():int
		{
			var k:int;
			var z:String;
			var zz:int;
			
			if( index >= n )
			{
				if(eof)
				{
					return -1;
				}
				index = 0;
				do
				{
					zz = instream.read();
					if( isNaN(zz))
					{
						eof=true;
						return -1;
					}
					z = String.fromCharCode(zz);
				}  while( z=='\n' || z=='\r' || z==' ');

				if (z == '~' || z=='x')
				{
					eof=true;
					ascii=b=null;
					n = 0;
					return -1;
				}
				else if (z == 'z')
				{
					b[0]=b[1]=b[2]=b[3]=0;
					n = 4;
				}
				else
				{
					ascii[0]=z; // may be EOF here....
					for (k=1;k<5;++k)
					{
						do
						{
							zz = instream.read();
							if(isNaN(zz))
							{
								eof=true;
								return -1;
							}
							z=String.fromCharCode(zz);
						} while ( z=='\n' || z=='\r' || z==' ' );
						ascii[k]=z;
						if (z == '~' || z=='x')
						{
							break;
						}
					}
					n = k - 1;
					if ( n==0 )
					{
						eof = true;
						ascii = null;
						b = null;
						return -1;
					}
					if ( k < 5 )
					{
						for (++k; k < 5; ++k )
						{
							ascii[k] = 0x21;
						}
						eof=true;
					}
					// decode stream
					var t:Number=0;
					for ( k=0; k<5; ++k)
					{
						var temp:int = ascii[k] - 0x21;
						z=String.fromCharCode(temp);
						if (temp < 0 || temp > 93)
						{
							n = 0;
							eof = true;
							ascii = null;
							b = null;
							throw new Error("Invalid data in Ascii85 stream");
						}
						t = (t * 85) + temp;
					}
					for ( k = 3; k>=0; --k)
					{
						b[k] = t & 0xFF;
						t>>>=8;
					}
				}
			}
			return b[index++] & 0xFF;
		}

		/**
		 * This will read a chunk of data.
		 *
		 * @param data The buffer to write data to.
		 * @param offset The offset into the data stream.
		 * @param len The number of byte to attempt to read.
		 *
		 * @return The number of bytes actually read.
		 *
		 * @throws IOException If there is an error reading data from the underlying stream.
		 */
		public final function readto(data:ByteArray, offset:int, len:int):int
		{
			if(eof && index>=n)
			{
				return -1;
			}
			for(var i:int=0;i<len;i++)
			{
				if(index<n)
				{
					data[i+offset]=b[index++];
				}
				else
				{
					var t:int = read();
					if ( isNaN(t) )
					{
						return i;
					}
					data[i+offset]=t;
				}
			}
			return len;
		}

		/**
		 * This will close the underlying stream and release any resources.
		 *
		 * @throws IOException If there is an error closing the underlying stream.
		 */
		public function close():void
		{
			ascii = null;
			eof = true;
			b = null;
		}

		/**
		 * non supported interface methods.
		 *
		 * @return False always.
		 */
		public function markSupported():Boolean
		{
			return false;
		}

		/**
		 * Unsupported.
		 *
		 * @param nValue ignored.
		 *
		 * @return Always zero.
		 */
		public function skip(nValue:Number):Number
		{
			return 0;
		}
		
		/**
		 * Unsupported.
		 *
		 * @return Always zero.
		 */
		public function available():int
		{
			return 0;
		}

		/**
		 * Unsupported.
		 *
		 * @param readlimit ignored.
		 */
		public function mark(readlimit:int):void
		{
		}

		/**
		 * Unsupported.
		 *
		 * @throws IOException telling that this is an unsupported action.
		 */
		public function reset():void
		{
			throw new Error("Reset is not supported");
		}

	}
}