package org.pdfbox.filter 
{
	
	/**
	 * ...
	 * @author walktree
	 */
	public class LZWFilter implements Filter
	{
		
		/**
		 * This will decode some compressed data.
		 * 
		 * @param compressedData
		 *            The compressed byte stream.
		 * @param result
		 *            The place to write the uncompressed byte stream.
		 * @param options
		 *            The options to use to encode the data.
		 * 
		 */

		public function decode(compressedData:ByteArray, result:ByteArray, options:COSDictionary = null ):void
		{
			//
		}

		

		/**
		 * This will encode some data.
		 * 
		 * @param rawData
		 *            The raw data to encode.
		 * @param result
		 *            The place to write to encoded results to.
		 * @param options
		 *            The options to use to encode the data.
		 * 
		 */
		public function encode( rawData:ByteArray, result:ByteArray, options:COSDictionary = null ) :void
		{
			//
		}
		
		
	    public function compress( str:String ):String
        {
            var i:Number    ;
            var size:Number ;
            var xstr:String;
            var chars:Number = 256;
            var original:String = new String(str) ;
            var dict:Array = new Array();
            for ( i = 0 ; i<chars ; i++ ) 
            {
                dict[String(i)] = i;
            }
            var current:String ;
            var result:String = new String("");
            var splitted:Array = original.split("");
            var buffer:Array = new Array();
            size = splitted.length ;
            for ( i = 0 ; i<=size ; i++) 
            {
                current = new String(splitted[i]) ;
                xstr = (buffer.length == 0) ? String(current.charCodeAt(0)) : ( buffer.join("-") + "-" + String(current.charCodeAt(0) ) ) ;
                if (dict[xstr] !== undefined)
                {
                    buffer.push(current.charCodeAt(0));
                } 
                else 
                {
                    result += String.fromCharCode(dict[buffer.join("-")]);
                    dict[xstr] = chars;
                    chars++;
                    buffer = new Array();
                    buffer.push(current.charCodeAt(0));
                }
            }
            return result;
        }

        public function decompress( str:String ):String
        {
            var i:Number ;
            var chars:Number = 256;
            var dict:Array = new Array();
            for (i = 0; i<chars; i++) 
            {
                dict[i] = String.fromCharCode(i);
            }
            var original:String = new String(str) ;
            var splitted:Array  = original.split("");
            var size:Number     = splitted.length ;
            var buffer:String   = new String("");
            var chain:String    = new String("");
            var result:String   = new String("");
            for ( i = 0; i<size ; i++ ) 
            {
                var code:Number    = original.charCodeAt(i);
                var current:String = dict[code];
                if (buffer == "") 
                {
                    buffer = current;
                    result += current;
                }
                else 
                {
                    if (code<=255) 
                    {
                        result += current ;
                        chain   = buffer + current ;
                        dict[chars] = chain ;
                        chars++ ;
                        buffer = current ;
                    } 
                    else 
                    {
                        chain = dict[code];
                        if (chain == null) 
                        {
                            chain = buffer + buffer.slice(0,1) ;
                        }
                        result += chain;
                        dict[chars] = buffer + chain.slice(0,1);
                        chars++;
                        buffer = chain;
                    }
                }
            }
            return result;
        }        
	}
	
}