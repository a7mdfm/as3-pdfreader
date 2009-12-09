package org.pdfbox.pdmodel.graphics.color{
	
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSName;
	
	/**
	 * This class represents a Gray color space.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.6 $
	 */
	public class PDFDeviceGray implements PDFColorSpace
	{
		/**
		 * The name of this color space.
		 */
		public static const  NAME:String = "DeviceGray";

		/**
		 * The abbreviated name of this color space.
		 */
		public static const ABBREVIATED_NAME:String = "G";

		/**
		 * This will return the name of the color space.
		 *
		 * @return The name of the color space.
		 */
		public function getName():String
		{
			return NAME;
		}

		/**
		 * This will get the number of components that this color space is made up of.
		 *
		 * @return The number of components in this color space.
		 *
		 * @throws IOException If there is an error getting the number of color components.
		 */
		public function getNumberOfComponents() :int
		{
			return 1;
		}
		
		public function getCOSObject():COSBase
		{
			return COSName.getPDFName( getName() );
		}

		/**
		 * Create a Java colorspace for this colorspace.
		 *
		 * @return A color space that can be used for Java AWT operations.
		 *
		 * @throws IOException If there is an error creating the color space.
		 */
		/*
		public ColorSpace createColorSpace() throws IOException
		{
			return ColorSpace.getInstance( ColorSpace.CS_GRAY );
		}*/
		
		/**
		 * Create a Java color model for this colorspace.
		 *
		 * @param bpc The number of bits per component.
		 * 
		 * @return A color model that can be used for Java AWT operations.
		 *
		 * @throws IOException If there is an error creating the color model.
		 */
		/*
		public ColorModel createColorModel( int bpc ) throws IOException
		{
			ColorSpace cs = ColorSpace.getInstance(ColorSpace.CS_GRAY);
			int[] nBits = {bpc};
			ColorModel colorModel = new ComponentColorModel(cs, nBits, false,false,
					Transparency.OPAQUE,DataBuffer.TYPE_BYTE);
			return colorModel;

		}*/
	}
}