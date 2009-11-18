package org.pdfbox.pdmodel.graphics.color
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSName;

	import org.pdfbox.pdmodel.common.COSObjectable;

	/**
	 * This class represents a color space in a pdf document.
	 */
	public interface PDFColorSpace extends COSObjectable
	{
		/**
		 * This will return the name of the color space.
		 *
		 * @return The name of the color space.
		 */
		function getName():String;

		/**
		 * This will get the number of components that this color space is made up of.
		 *
		 * @return The number of components in this color space.
		 *
		 * @throws IOException If there is an error getting the number of color components.
		 */
		function getNumberOfComponents():int

		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		/*public COSBase getCOSObject()
		{
			return COSName.getPDFName( getName() );
		}*/

		/**
		 * Create a Java colorspace for this colorspace.
		 *
		 * @return A color space that can be used for Java AWT operations.
		 *
		 * @throws IOException If there is an error creating the color space.
		 */
		//public abstract ColorSpace createColorSpace() throws IOException;
		
		/**
		 * Create a Java color model for this colorspace.
		 *
		 * @param bpc The number of bits per component.
		 * 
		 * @return A color model that can be used for Java AWT operations.
		 *
		 * @throws IOException If there is an error creating the color model.
		 */
		//public ColorModel createColorModel( int bpc ) throws IOException;
	}
}