package org.pdfbox.utils 
{
	
	/**
	 * ...
	 * @author walktree
	 */

	import flash.geom.Matrix;

	public class Matrix2 implements ICloneable
	{
		private var single:Array = [
			1,0,0,
			0,1,0,
			0,0,1
		];

		/**
		 * Create an affine transform from this matrix's values.
		 * 
		 * @return An affine transform with this matrix's values.
		 */
		public function createAffineTransform():Matrix
		{
			var retval:Matrix = new Matrix(
				single[0], single[1], 
				single[3], single[4],
				single[6], single[7] );
			return retval;
		}
		
		/**
		 * Set the values of the matrix from the AffineTransform.
		 * 
		 * @param af The transform to get the values from.
		 */
		public function setFromAffineTransform( af:Matrix ):void
		{
			single[0] = af.a;
			single[1] = af.b;
			single[3] = af.c;
			single[4] = af.d;
			single[6] = af.tx;
			single[7] = af.ty;
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
			return single[row*3+column];
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
			single[row*3+column] = value;
		}
		
		/**
		 * Return a single dimension array of all values in the matrix.
		 * 
		 * @return The values ot this matrix.
		 */
		public function getValues():Array
		{
			var retval:Array = new Array(3);
			retval[0] = new Array(3);
			retval[0][0] = single[0];
			retval[0][1] = single[1];
			retval[0][2] = single[2];
			retval[1] = new Array(3);
			retval[1][0] = single[3];
			retval[1][1] = single[4];
			retval[1][2] = single[5];
			retval[2] = new Array(3);
			retval[2][0] = single[6];
			retval[2][1] = single[7];
			retval[2][2] = single[8];
			return retval;
		}
		
		/**
		 * Return a single dimension array of all values in the matrix.
		 * 
		 * @return The values ot this matrix.
		 */
		/*public double[][] getValuesAsDouble()
		{
			double[][] retval = new double[3][3];
			retval[0][0] = single[0];
			retval[0][1] = single[1];
			retval[0][2] = single[2];
			retval[1][0] = single[3];
			retval[1][1] = single[4];
			retval[1][2] = single[5];
			retval[2][0] = single[6];
			retval[2][1] = single[7];
			retval[2][2] = single[8];
			return retval;
		}*/

		/**
		 * This will take the current matrix and multipy it with a matrix that is passed in.
		 *
		 * @param b The matrix to multiply by.
		 *
		 * @return The result of the two multiplied matrices.
		 */
		public function multiply( b:Matrix2 ):Matrix2
		{
			var result:Matrix2 = new Matrix2();

			var bMatrix:Array = b.single;
			var resultMatrix:Array = result.single;
			resultMatrix[0] = single[0] * bMatrix[0] + single[1] * bMatrix[3] + single[2] * bMatrix[6];
			resultMatrix[1] = single[0] * bMatrix[1] + single[1] * bMatrix[4] + single[2] * bMatrix[7];
			resultMatrix[2] = single[0] * bMatrix[2] + single[1] * bMatrix[5] + single[2] * bMatrix[8];
			resultMatrix[3] = single[3] * bMatrix[0] + single[4] * bMatrix[3] + single[5] * bMatrix[6];
			resultMatrix[4] = single[3] * bMatrix[1] + single[4] * bMatrix[4] + single[5] * bMatrix[7];
			resultMatrix[5] = single[3] * bMatrix[2] + single[4] * bMatrix[5] + single[5] * bMatrix[8];
			resultMatrix[6] = single[6] * bMatrix[0] + single[7] * bMatrix[3] + single[8] * bMatrix[6];
			resultMatrix[7] = single[6] * bMatrix[1] + single[7] * bMatrix[4] + single[8] * bMatrix[7];
			resultMatrix[8] = single[6] * bMatrix[2] + single[7] * bMatrix[5] + single[8] * bMatrix[8];

			return result;
		}
		
		/**
		 * Create a new matrix with just the scaling operators.
		 * 
		 * @return A new matrix with just the scaling operators.
		 */
		public function extractScaling():Matrix2
		{
			var retval:Matrix2 = new Matrix2();
			
			retval.single[0] = this.single[0];
			retval.single[4] = this.single[4];
			
			return retval;
		}
		
		/**
		 * Convenience method to create a scaled instance. 
		 * 
		 * @param x The xscale operator.
		 * @param y The yscale operator.
		 * @return A new matrix with just the x/y scaling
		 */
		public static function getScaleInstance( x:Number, y:Number):Matrix2
		{
			var retval:Matrix2 = new Matrix2();
			
			retval.single[0] = x;
			retval.single[4] = y;
			
			return retval;
		}
		
		/**
		 * Create a new matrix with just the translating operators.
		 * 
		 * @return A new matrix with just the translating operators.
		 */
		public function extractTranslating():Matrix2
		{
			var retval:Matrix2 = new Matrix2();
			
			retval.single[6] = this.single[6];
			retval.single[7] = this.single[7];
			
			return retval;
		}
		
		/**
		 * Convenience method to create a translating instance. 
		 * 
		 * @param x The x translating operator.
		 * @param y The y translating operator.
		 * @return A new matrix with just the x/y translating.
		 */
		public static function getTranslatingInstance( x:Number, y:Number ):Matrix2
		{
			var retval:Matrix2 = new Matrix2();
			
			retval.single[6] = x;
			retval.single[7] = y;
			
			return retval;
		}

		/**
		 * Clones this object.
		 * @return cloned matrix as an object.
		 */
		public function clone():Object
		{
			var clone:Matrix2 = new Matrix2();
			clone.single = this.single.slice();
			return clone;
		}

		/**
		 * This will copy the text matrix data.
		 *
		 * @return a matrix that matches this one.
		 */
		public function copy():Matrix2
		{
			return clone() as Matrix2;
		}

		/**
		 * This will return a string representation of the matrix.
		 *
		 * @return The matrix as a string.
		 */
		public function toString():String
		{
			var result:String = "" ;
			result +=  "[[" ;
			result +=( single[0] + "," );
			result +=( single[1] + "," );
			result +=( single[2] + "][");
			result +=( single[3] + "," );
			result +=( single[4] + "," );
			result +=( single[5] + "][");
			result +=( single[6] + "," );
			result +=( single[7] + "," );
			result +=( single[8] + "]]");
			
			return result;
		}
		
		/**
		 * Get the xscaling factor of this matrix.
		 * @return The x-scale.
		 */
		public function getXScale():Number
		{
			var xScale:Number = single[0];
			
			/**
			 * BM: if the trm is rotated, the calculation is a little more complicated 
			 * 
			 * The rotation matrix multiplied with the scaling matrix is:
			 * (   x   0   0)    ( cos  sin  0)    ( x*cos x*sin   0)
			 * (   0   y   0) *  (-sin  cos  0)  = (-y*sin y*cos   0)
			 * (   0   0   1)    (   0    0  1)    (     0     0   1)
			 *
			 * So, if you want to deduce x from the matrix you take
			 * M(0,0) = x*cos and M(0,1) = x*sin and use the theorem of Pythagoras
			 * 
			 * sqrt(M(0,0)^2+M(0,1)^2) =
			 * sqrt(x2*cos2+x2*sin2) =
			 * sqrt(x2*(cos2+sin2)) = <- here is the trick cos2+sin2 is one
			 * sqrt(x2) =
			 * abs(x) 
			 */
			if( !(single[1]==0.0 && single[3]==0.0) )
			{
				xScale = Math.sqrt(Math.pow(single[0], 2)+
										  Math.pow(single[1], 2));
			} 
			return xScale;
		}
		
		/**
		 * Get the y scaling factor of this matrix.
		 * @return The y-scale factor.
		 */
		public function getYScale():Number
		{
			var yScale:Number = single[4];
			if( !(single[1]==0.0 && single[3]==0.0) )
			{
				yScale = Math.sqrt(Math.pow(single[3], 2)+
										  Math.pow(single[4], 2));
			} 
			return yScale;
		}
		
		/**
		 * Get the x position in the matrix.
		 * @return The x-position.
		 */
		public function getXPosition():Number
		{
			return single[6];
		}
		
		/**
		 * Get the y position.
		 * @return The y position.
		 */
		public function getYPosition():Number
		{
			return single[7];
		}
	}
	
}