package org.pdfbox.pdfparser
{
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDocument;
	import org.pdfbox.cos.COSInteger;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.cos.COSObject;
	import org.pdfbox.cos.COSStream;
	
	import org.pdfbox.utils.ArrayList;

	/**
	 * This will parse a PDF 1.5 object stream and extract all of the objects from the stream.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.6 $
	 */
	public class PDFObjectStreamParser extends BaseParser
	{
		private var streamObjects:ArrayList = null;
		private var objectNumbers:ArrayList = null;
		private var stream:COSStream;

		/**
		 * Constructor.
		 *
		 * @param strm The stream to parse.
		 * @param doc The document for the current parsing.
		 *
		 * @throws IOException If there is an error initializing the stream.
		 */
		public function PDFObjectStreamParser( strm:COSStream, doc:COSDocument )
		{
		   super( strm.getUnfilteredStream() );
		   document = doc ;
		   stream = strm;
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
				//need to first parse the header.
				var numberOfObjects:int = stream.getInt( "N" );
				objectNumbers = new ArrayList( );
				streamObjects = new ArrayList( );
				for( var i:int=0; i<numberOfObjects; i++ )
				{
					var objectNumber:int = readInt();
					var offset:int = readInt();
					objectNumbers.add(  objectNumber );
				}
				var object:COSObject = null;
				var cosObject:COSBase = null;
				var objectCounter:int = 0;
				while( (cosObject = parseDirObject()) != null )
				{
					object = new COSObject(cosObject);
					object.setGenerationNumber( COSNumber.ZERO );
					var objNum:COSInteger = 
						new COSInteger( objectNumbers.get( objectCounter) );
					object.setObjectNumber( objNum );
					streamObjects.add( object );
					objectCounter++;
				}
			}
			finally
			{
				pdfSource = null;
			}
		}

		/**
		 * This will get the objects that were parsed from the stream.
		 *
		 * @return All of the objects in the stream.
		 */
		public function getObjects():Array
		{
			return streamObjects.toArray();
		}
		
	}
}