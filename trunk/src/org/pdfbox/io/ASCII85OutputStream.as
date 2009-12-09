package org.pdfbox.io{

	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;
	import org.pdfbox.io.FileInputStream;

	/**
	 * This class represents an ASCII85 output stream.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.7 $
	 */
	public class ASCII85OutputStream 
	{

		private var lineBreak:int;
		private var count:int;

		private var indata:Array;
		private var outdata:Array;

		/**
		 * Function produces five ASCII printing characters from
		 * four bytes of binary data.
		 */
		private var maxline:int;
		private var flushed:Boolean;
		private var terminator:String;
		
		private var out:FileInputStream

		/**
		 * Constructor.
		 *
		 * @param out The output stream to write to.
		 */
		public function ASCII85OutputStream( $out:IDataOutput ):void
		{
			out = new FileInputStream();
			out.date = $out as ByteArray;
			
			lineBreak = 36*2;
			maxline = 36*2;
			count=0;
			indata=new Array(4);
			outdata=new Array(5);
			flushed=true;
			terminator='~';
		}

		/**
		 * This will set the terminating character.
		 *
		 * @param term The terminating character.
		 */
		public function setTerminator(term:String):void
		{
			if(term<118 || term>126 || term=='z')
			{
				throw new Error("Terminator must be 118-126 excluding z");
			}
			terminator=term;
		}

		/**
		 * This will get the terminating character.
		 *
		 * @return The terminating character.
		 */
		public function getTerminator():String
		{
			return terminator;
		}

		/**
		 * This will set the line length that will be used.
		 *
		 * @param l The length of the line to use.
		 */
		public function setLineLength(l:int):void
		{
			if( lineBreak > l )
			{
				lineBreak = l;
			}
			maxline=l;
		}

		/**
		 * This will get the length of the line.
		 *
		 * @return The line length attribute.
		 */
		public function getLineLength():int
		{
			return maxline;
		}

		/**
		 * This will transform the next four ascii bytes.
		 */s
		private final function transformASCII85():void
		{
			var word:Number;
			word=( (((indata[0] << 8) | (indata[1] &0xFF)) << 16) |
			( (indata[2] & 0xFF) << 8) | (indata[3] & 0xFF)
			)    & 0xFFFFFFFF;
			// System.out.println("word=0x"+Long.toString(word,16)+" "+word);

			if (word == 0 )
			{
				outdata[0]=String('z').charCodeAt(0);
				outdata[1]=0;
				return;
			}
			var x:Number;
			x=word/(85*85*85*85);
			// System.out.println("x0="+x);
			outdata[0]=x+String('!').charCodeAt(0);
			word-=x*85*85*85*85;

			x=word/(85*85*85);
			// System.out.println("x1="+x);
			outdata[1]=x+String('!').charCodeAt(0);
			word-=x*85*85*85;

			x=word/(85*85);
			// System.out.println("x2="+x);
			outdata[2]=x+String('!').charCodeAt(0);
			word-=x*85*85;

			x=word/85;
			// System.out.println("x3="+x);
			outdata[3]=x+String('!').charCodeAt(0);

			// word-=x*85L;

			// System.out.println("x4="+(word % 85L));
			outdata[4]=word%85+String('!').charCodeAt(0); 
		}

		/**
		 * This will write a single byte.
		 *
		 * @param b The byte to write.
		 *
		 * @throws IOException If there is an error writing to the stream.
		 */
		public function final write( b:int):void
		{
			flushed=false;
			indata[count++]=b;
			if(count < 4 )
			{
				return;
			}
			transformASCII85();
			for(var i:int=0;i<5;i++)
			{
				if(outdata[i]==0)
				{
					break;
				}
				out.writeByte(outdata[i]);
				if(--lineBreak==0)
				{
					out.writeUTF('\n');
					lineBreak=maxline;
				}
			}
			count = 0;
		}

		/**
		 * This will write a chunk of data to the stream.
		 *
		 * @param b The byte buffer to read from.
		 * @param off The offset into the buffer.
		 * @param sz The number of bytes to read from the buffer.
		 *
		 * @throws IOException If there is an error writing to the underlying stream.
		 */
		public final function writes(b:Array, off:int, sz:int):void
		{
			for(var iL:int=0;i<sz;i++)
			{
				if(count < 3)
				{
					indata[count++]=b[off+i];
				}
				else
				{
					write(b[off+i]);
				}
			}
		}

		/**
		 * This will flush the data to the stream.
		 *
		 * @throws IOException If there is an error writing the data to the stream.
		 */
		public final function flush():void
		{
			if(flushed)
			{
				return;
			}
			if(count > 0 )
			{
				for( var i:int=count; i<4; i++ )
				{
					indata[i]=0;
				}
				transformASCII85();
				if(outdata[0]=='z')
				{
					for( i=0;i<5;i++) // expand 'z',
					{
						outdata[i]=String('!').charCodeAt(0);
					}
				}
				for( i=0;i<count+1;i++)
				{
					out.writeByte(outdata[i]);
					if(--lineBreak==0)
					{
						out.writeUTF('\n');
						lineBreak=maxline;
					}
				}
			}
			if(--lineBreak==0)
			{
				out.writeUTF('\n');
			}
			out.writeUTF(terminator);
			out.writeUTF('\n');
			count = 0;
			lineBreak=maxline;
			flushed=true;
		}

		/**
		 * This will close the stream.
		 *
		 * @throws IOException If there is an error closing the wrapped stream.
		 */
		public function close():void
		{
			
			indata=outdata=null;
		}

		/**
		 * This will flush the stream.
		 *
		 * @throws Throwable If there is an error.
		 */
		protected function finalize() :void
		{
			flush();	
		}
	}
}