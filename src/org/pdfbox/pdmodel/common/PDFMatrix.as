package org.pdfbox.pdmodel.common{

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSFloat;
	import org.pdfbox.cos.COSNumber;
	import org.pdfbox.utils.ICloneable;

	/**
	 * This class will be used for matrix manipulation.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.3 $
	 */
	public class PDFMatrix implements COSObjectable
	{
		private var matrix:COSArray;

		/**
		 * Constructor.
		 */
		public function PDFMatrix( array:COSArray = null ):void
		{
			if ( array != null ) {
				matrix = array;
			}else{
				matrix = new COSArray();
				matrix.add( new COSFloat( 1.0 ) );
				matrix.add( new COSFloat( 0.0 ) );
				matrix.add( new COSFloat( 0.0 ) );
				matrix.add( new COSFloat( 0.0 ) );
				matrix.add( new COSFloat( 1.0 ) );
				matrix.add( new COSFloat( 0.0 ) );
				matrix.add( new COSFloat( 0.0 ) );
				matrix.add( new COSFloat( 0.0 ) );
				matrix.add( new COSFloat( 1.0 ) );
			}
		}


		/**
		 * This will get the underlying array value.
		 *
		 * @return The cos object that this object wraps.
		 */
		public function getCOSArray():COSArray
		{
			return matrix;
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return matrix;
		}
		

		/**
		 * This will get a matrix value at some point.
		 *
		 * @param row The row to get the value from.
		 * @param column The column to get the value from.
		 *
		 * @return The value at the row/column position.
		 */
		public function getValue( row:int, column:int ):Number
		{
			return (matrix.get( row*3 + column ) as COSNumber).floatValue();
		}

		/**
		 * This will set a value at a position.
		 *
		 * @param row The row to set the value at.
		 * @param column the column to set the value at.
		 * @param value The value to set at the position.
		 */
		public function setValue( row:int, column:int, value:Number ):void
		{
			matrix.set( row*3+column, new COSFloat( value ) );
		}
	}
}