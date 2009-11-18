package org.pdfbox.cos
{
	
	import flash.utils.ByteArray;
	
	import org.pdfbox.utils.HashMap;
	import org.pdfbox.utils.ByteUtil;
	import org.pdfbox.utils.COSHEXTable;
	

	/**
	 * This class represents a PDF named object.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.42 $
	 */
	public final class COSName extends COSBase
	{
		/**
		 * Note: This is synchronized because a HashMap must be synchronized if accessed by 
		 * multiple threads.
		 */
		private static var nameMap:HashMap = new HashMap();//8192

		
		/**
		 * A common COSName value.
		 */
		public static const A:COSName= new COSName( "A" );
		/**
		 * A common COSName value.
		 */
		public static const AA:COSName= new COSName( "AA" );
		/**
		* A common COSName value.
		*/
		public static const ACRO_FORM:COSName= new COSName( "AcroForm" );
		/**
		* A common COSName value.
		*/
		public static const ANNOTS:COSName= new COSName( "Annots" );
		/**
		 * A common COSName value.
		 */
		public static const ART_BOX:COSName= new COSName("ArtBox" );
		/**
		* A common COSName value.
		*/
		public static const ASCII85_DECODE:COSName= new COSName( "ASCII85Decode" );
		/**
		* A common COSName value.
		*/
		public static const ASCII85_DECODE_ABBREVIATION:COSName= new COSName( "A85" );
		/**
		* A common COSName value.
		*/
		public static const ASCII_HEX_DECODE:COSName= new COSName( "ASCIIHexDecode" );
		/**
		* A common COSName value.
		*/
		public static const ASCII_HEX_DECODE_ABBREVIATION:COSName= new COSName( "AHx" );
		/**
		* A common COSName value.
		*/
		public static const AP:COSName= new COSName( "AP" );
		/**
		 * A common COSName value.
		 */
		public static const B:COSName= new COSName( "B" );
		/**
		* A common COSName value.
		*/
		public static const BASE_ENCODING:COSName= new COSName( "BaseEncoding" );
		/**
		* A common COSName value.
		*/
		public static const BASE_FONT:COSName= new COSName( "BaseFont" );
		/**
		* A common COSName value.
		*/
		public static const BBOX:COSName= new COSName( "BBox" );
		/**
		 * A common COSName value.
		 */
		public static const BLEED_BOX:COSName= new COSName("BleedBox" );
		/**
		* A common COSName value.
		*/
		public static const CATALOG:COSName= new COSName( "Catalog" );
		/**
		* A common COSName value.
		*/
		public static const CALGRAY:COSName= new COSName( "CalGray" );
		/**
		* A common COSName value.
		*/
		public static const CALRGB:COSName= new COSName( "CalRGB" );
		/**
		* A common COSName value.
		*/
		public static const CCITTFAX_DECODE:COSName= new COSName( "CCITTFaxDecode" );
		/**
		* A common COSName value.
		*/
		public static const CCITTFAX_DECODE_ABBREVIATION:COSName= new COSName( "CCF" );
		/**
		* A common COSName value.
		*/
		public static const COLORSPACE:COSName= new COSName( "ColorSpace" );
		/**
		* A common COSName value.
		*/
		public static const CONTENTS:COSName= new COSName( "Contents" );
		/**
		* A common COSName value.
		*/
		public static const COUNT:COSName= new COSName( "Count" );
		/**
		 * A common COSName value.
		 */
		public static const CROP_BOX:COSName= new COSName(  "CropBox" );
		/**
		 * A common COSName value.
		 */
		public static const DCT_DECODE:COSName= new COSName( "DCTDecode" );
		/**
		 * A common COSName value.
		 */
		public static const DCT_DECODE_ABBREVIATION:COSName= new COSName( "DCT" );
		/**
		 * A common COSName value.
		 */
		public static const DESCENDANT_FONTS:COSName= new COSName(  "DescendantFonts" );
		/**
		 * A common COSName value.
		 */
		public static const DEST:COSName= new COSName(  "Dest" );
		/**
		* A common COSName value.
		*/
		public static const DEVICECMYK:COSName= new COSName( "DeviceCMYK" );
		/**
		* A common COSName value.
		*/
		public static const DEVICEGRAY:COSName= new COSName( "DeviceGray" );
		/**
		* A common COSName value.
		*/
		public static const DEVICEN:COSName= new COSName( "DeviceN" );
		/**
		* A common COSName value.
		*/
		public static const DEVICERGB:COSName= new COSName( "DeviceRGB" );
		/**
		 * A common COSName value.
		 */
		public static const DIFFERENCES:COSName= new COSName( "Differences" );
		/**
		* A common COSName value.
		*/
		public static const DV:COSName= new COSName( "DV" );
		/**
		* A common COSName value.
		*/
		public static const ENCODING:COSName= new COSName( "Encoding" );
		/**
		 * A common COSName value.
		 */
		public static const ENCODING_90MS_RKSJ_H:COSName= new COSName( "90ms-RKSJ-H" );
		/**
		 * A common COSName value.
		 */
		public static const ENCODING_90MS_RKSJ_V:COSName= new COSName( "90ms-RKSJ-V" );
		/**
		 * A common COSName value.
		 */
		public static const ENCODING_ETEN_B5_H:COSName= new COSName( "ETen?B5?H" );
		/**
		 * A common COSName value.
		 */
		public static const ENCODING_ETEN_B5_V:COSName= new COSName( "ETen?B5?V" );
		/**
		 * A common COSName value.
		 */
		public static const FIELDS:COSName= new COSName( "Fields" );
		/**
		* A common COSName value.
		*/
		public static const FILTER:COSName= new COSName( "Filter" );
		/**
		* A common COSName value.
		*/
		public static const FIRST_CHAR:COSName= new COSName( "FirstChar" );
		/**
		* A common COSName value.
		*/
		public static const FLATE_DECODE:COSName= new COSName( "FlateDecode" );
		/**
		* A common COSName value.
		*/
		public static const FLATE_DECODE_ABBREVIATION:COSName= new COSName( "Fl" );
		/**
		* A common COSName value.
		*/
		public static const FONT:COSName= new COSName( "Font" );
		/**
		 * A common COSName value.
		 */
		public static const FONT_FILE:COSName= new COSName("FontFile");
		/**
		 * A common COSName value.
		 */
		public static const FONT_FILE2:COSName= new COSName("FontFile2");
		/**
		 * A common COSName value.
		 */
		public static const FONT_FILE3:COSName= new COSName("FontFile3");
		/**
		 * A common COSName value.
		 */
		public static const FONT_DESC:COSName= new COSName("FontDescriptor");
		/**
		 * A common COSName value.
		 */
		public static const FONT_MATRIX:COSName= new COSName("FontMatrix" );
		/**
		* A common COSName value.
		*/
		public static const FORMTYPE:COSName= new COSName( "FormType" );
		/**
		* A common COSName value.
		*/
		public static const FRM:COSName= new COSName( "FRM" );
		/**
		 * A common COSName value.
		 */
		 public static const H:COSName= new COSName( "H" );
		/**
		* A common COSName value.
		*/
		public static const HEIGHT:COSName= new COSName( "Height" );
		/**
		* A common COSName value.
		*/
		public static const ICCBASED:COSName= new COSName( "ICCBased" );
		/**
		* A common COSName value.
		*/
		public static const IDENTITY_H:COSName= new COSName( "Identity-H" );
		/**
		* A common COSName value.
		*/
		public static const IMAGE:COSName= new COSName( "Image" );
		/**
		* A common COSName value.
		*/
		public static const INDEXED:COSName= new COSName( "Indexed" );
		/**
		 * A common COSName value.
		 */
		public static const INFO:COSName= new COSName( "Info" );
		/**
		* A common COSName value.
		*/
		public static const JPX_DECODE:COSName= new COSName( "JPXDecode" );
		/**
		* A common COSName value.
		*/
		public static const KIDS:COSName= new COSName( "Kids" );
		/**
		* A common COSName value.
		*/
		public static const LAB:COSName= new COSName( "Lab" );
		/**
		* A common COSName value.
		*/
		public static const LAST_CHAR:COSName= new COSName( "LastChar" );
		/**
		* A common COSName value.
		*/
		public static const LENGTH:COSName= new COSName( "Length" );
		/**
		 * A common COSName value.
		 */
		public static const LENGTH1:COSName= new COSName( "Length1" );
		/**
		* A common COSName value.
		*/
		public static const LZW_DECODE:COSName= new COSName( "LZWDecode" );
		/**
		* A common COSName value.
		*/
		public static const LZW_DECODE_ABBREVIATION:COSName= new COSName( "LZW" );
		/**
		* A common COSName value.
		*/
		public static const MAC_ROMAN_ENCODING:COSName= new COSName( "MacRomanEncoding" );
		/**
		* A common COSName value.
		*/
		public static const MATRIX:COSName= new COSName( "Matrix" );
		/**
		 * A common COSName value.
		 */
		public static const MEDIA_BOX:COSName= new COSName(  "MediaBox" );
		/**
		 * A common COSName value.
		 */
		public static const METADATA:COSName= new COSName(  "Metadata" );
		/**
		* A common COSName value.
		*/
		public static const N:COSName= new COSName( "N" );
		/**
		* A common COSName value.
		*/
		public static const NAME:COSName= new COSName( "Name" );
		/**
		* A common COSName value.
		*/
		public static const P:COSName= new COSName( "P" );
		/**
		* A common COSName value.
		*/
		public static const PAGE:COSName= new COSName( "Page" );
		/**
		* A common COSName value.
		*/
		public static const PAGES:COSName= new COSName( "Pages" );
		/**
		* A common COSName value.
		*/
		public static const PARENT:COSName= new COSName( "Parent" );
		/**
		* A common COSName value.
		*/
		public static const PATTERN:COSName= new COSName( "Pattern" );
		/**
		* A common COSName value.
		*/
		public static const PDF_DOC_ENCODING:COSName= new COSName( "PDFDocEncoding" );
		/**
		* A common COSName value.
		*/
		public static const PREV:COSName= new COSName( "Prev" );
		/**
		 * A common COSName value.
		 */
		 public static const R:COSName= new COSName( "R" );
		/**
		* A common COSName value.
		*/
		public static const RESOURCES:COSName= new COSName( "Resources" );
		/**
		* A common COSName value.
		*/
		public static const ROOT:COSName= new COSName( "Root" );
		/**
		 * A common COSName value.
		 */
		public static const ROTATE:COSName= new COSName(  "Rotate" );
		/**
		* A common COSName value.
		*/
		public static const RUN_LENGTH_DECODE:COSName= new COSName( "RunLengthDecode" );
		/**
		* A common COSName value.
		*/
		public static const RUN_LENGTH_DECODE_ABBREVIATION:COSName= new COSName( "RL" );
		/**
		* A common COSName value.
		*/
		public static const SEPARATION:COSName= new COSName( "Separation" );
		/**
		* A common COSName value.
		*/
		public static const STANDARD_ENCODING:COSName= new COSName( "StandardEncoding" );
		/**
		* A common COSName value.
		*/
		public static const SUBTYPE:COSName= new COSName( "Subtype" );
		/**
		 * A common COSName value.
		 */
		public static const TRIM_BOX:COSName= new COSName("TrimBox" );
		/**
		 * A common COSName value.
		 */
		public static const TRUE_TYPE:COSName= new COSName("TrueType" );
		/**
		* A common COSName value.
		*/
		public static const TO_UNICODE:COSName= new COSName( "ToUnicode" );
		/**
		* A common COSName value.
		*/
		public static const TYPE:COSName= new COSName( "Type" );
		/**
		 * A common COSName value.
		 */
		public static const TYPE0:COSName= new COSName(  "Type0" );
		/**
		* A common COSName value.
		*/
		public static const V:COSName= new COSName( "V" );
		/**
		 * A common COSName value.
		 */
		 public static const VERSION:COSName= new COSName( "Version" );
		/**
		* A common COSName value.
		*/
		public static const WIDTHS:COSName= new COSName( "Widths" );
		/**
		* A common COSName value.
		*/
		public static const WIN_ANSI_ENCODING:COSName= new COSName( "WinAnsiEncoding" );
		/**
		* A common COSName value.
		*/
		public static const XOBJECT:COSName= new COSName( "XObject" );
		
		/**
		 * The prefix to a PDF name.
		 */
		public static const NAME_PREFIX:Array= [ 47 ] ; // The / character
		/**
		 * The escape character for a name.
		 */
		public static const NAME_ESCAPE:Array= [ 35 ];  //The # character

		private var name:String;
		private var hashCode:int;

		/**
		 * This will get a COSName object with that name.
		 *
		 * @param aName The name of the object.
		 *
		 * @return A COSName with the specified name.
		 */
		public static function getPDFName( aName:String):COSName{
			var name:COSName= null;
			if( aName != null )
			{
				name = COSName(nameMap.get( aName ));
				if( name == null )
				{
					//name is added to map in the constructor
					name = new COSName( aName );
				}
			}
			return name;
		}

		/**
		 * Private constructor.  This will limit the number of COSName objects.
		 * that are created.
		 *
		 * @param aName The name of the COSName object.
		 */
		public function COSName( aName:String)
		{
			name = aName;
			nameMap.put( aName, this );
			//hashCode = name.hashCode();
		}

		/**
		 * This will get the name of this COSName object.
		 *
		 * @return The name of the object.
		 */
		public function getName():String{
			return name;
		}

		/**
		 * {@inheritDoc}
		 */
		public function toString():String{
			return "[ COSName :" + name + " ]";
		}

		/**
		 * {@inheritDoc}
		 */
		public function equals( o:Object):Boolean{
			var retval:Boolean = this == o;
			if( !retval && o is COSName )
			{
				var other:COSName= COSName(o);
				retval = (name == other.getName());
			}
			return retval;
		}

		/**
		 * {@inheritDoc}
		 */
		//TODO
		/*public function hashCode():int{
			return hashCode;
		}*/
		
		/**
		 * {@inheritDoc}
		 */
		public function compareTo(o:Object):int{
			var other:COSName= o as COSName;
			return this.name.localeCompare( other.name );
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
			return visitor.visitFromName(this);
		}
		
		/**
		 * This will output this string as a PDF object.
		 *  
		 * @param output The stream to write to.
		 * @throws IOException If there is an error writing to the stream.
		 */
		public function writePDF( output:ByteArray ):void
		{
			output.writeBytes( ByteUtil.toByteArray(NAME_PREFIX));
			var bytes:ByteArray= ByteUtil.getBytes(getName());
			for (var i:int= 0; i < bytes.length;i++)
			{
				var current:int = ((bytes[i] + 256) % 256);
				var s:String = String.fromCharCode(current);

				if(current <= 32|| current >= 127||
				   s == '(' ||
				   s == ')' ||
				   s == '[' ||
				   s == ']' ||
				   s == '/' ||
				   s == '%' ||
				   s == '<' ||
				   s == '>' ||
				   current == NAME_ESCAPE[0] )
				{
					output.writeBytes(ByteUtil.toByteArray(NAME_ESCAPE));
					output.writeByte(COSHEXTable.TABLE[current]);
				}
				else
				{
					output.writeByte(current);
				}
			}
		}
	}
}