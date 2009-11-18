package org.pdfbox.pdmodel.graphics.color
{


	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSFloat;
	
	
	/**
	 * This class represents a color space and the color value for that colorspace.
	 *
	 */
	public class PDFColorSpaceInstance
	{
	    private var colorSpace:PDFColorSpace = new PDDeviceGray();
	    private var colorSpaceValue:COSArray = new COSArray();
	    
	    /**
	     * Default constructor.
	     *
	     */
	    public function PDFColorSpaceInstance()
	    {
			colorSpaceValue.add( new COSFloat( 0 ) );
	    }
	    
	    /**
	     * Create the current color from the colorspace and values.
	     * @return The current awt color.
	     * @throws IOException If there is an error creating the color.
	     */
	    public Color createColor():
	    {
			Color retval = null;
			float[] components = colorSpaceValue.toFloatArray();
			if( components.length == 3 )
			{
				//for some reason, when using RGB and the RGB colorspace
				//the new Color doesn't maintain exactly the same values
				//I think some color conversion needs to take place first
				//for now we will just make rgb a special case.
				retval = new Color( components[0], components[1], components[2] );
			}
			else
			{
				ColorSpace cs = colorSpace.createColorSpace();
				retval = new Color( cs, components, 1f );
			}
			return retval;
	    }
	    
	    /**
	     * Constructor with an existing color set.  Default colorspace is PDDeviceGray.
	     * 
	     * @param csValues The color space values.
	     */
	    public PDColorSpaceInstance( COSArray csValues )
	    {
			colorSpaceValue = csValues;
	    }


	    /**
	     * This will get the current colorspace.
	     *
	     * @return The current colorspace.
	     */
	    public PDColorSpace getColorSpace()
	    {
			return colorSpace;
	    }

	    /**
	     * This will set the current colorspace.
	     *
	     * @param value The new colorspace.
	     */
	    public void setColorSpace(PDColorSpace value)
	    {
			colorSpace = value;
	    }

	    /**
	     * This will get the color space values.  Either 1 for gray or 3 for RGB.
	     *
	     * @return The colorspace values.
	     */
	    public float[] getColorSpaceValue()
	    {
			return colorSpaceValue.toFloatArray();
	    }
	    
	    /**
	     * This will get the color space values.  Either 1 for gray or 3 for RGB.
	     *
	     * @return The colorspace values.
	     */
	    public COSArray getCOSColorSpaceValue()
	    {
			return colorSpaceValue;
	    }

	    /**
	     * This will update the colorspace values.
	     *
	     * @param value The new colorspace values.
	     */
	    public void setColorSpaceValue(float[] value)
	    {
			colorSpaceValue.setFloatArray( value );
	    }
	}
}
