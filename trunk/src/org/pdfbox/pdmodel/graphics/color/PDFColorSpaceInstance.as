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
	    private var colorSpace:PDFColorSpace = new PDFDeviceGray();
	    private var colorSpaceValue:COSArray = new COSArray();
	    
	    /**
	     * Default constructor.
	     *
	     */
	    public function PDFColorSpaceInstance( csValues:COSArray = null )
	    {
			colorSpaceValue.add( new COSFloat( 0 ) );
			
			if ( csValues ) {
				colorSpaceValue = csValues;
			}
	    }
	    
	    /**
	     * Create the current color from the colorspace and values.
	     * @return The current awt color.
	     * @throws IOException If there is an error creating the color.
	     */
	    
		/*public Color createColor():
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
	    }*/
	    

	    /**
	     * This will get the current colorspace.
	     *
	     * @return The current colorspace.
	     */
	    public function getColorSpace():PDFColorSpace
	    {
			return colorSpace;
	    }

	    /**
	     * This will set the current colorspace.
	     *
	     * @param value The new colorspace.
	     */
	    public function setColorSpace(value:PDFColorSpace):void
	    {
			colorSpace = value;
	    }

	    /**
	     * This will get the color space values.  Either 1 for gray or 3 for RGB.
	     *
	     * @return The colorspace values.
	     */
	    public function getColorSpaceValue():Array
	    {
			return colorSpaceValue.toFloatArray();
	    }
	    
	    /**
	     * This will get the color space values.  Either 1 for gray or 3 for RGB.
	     *
	     * @return The colorspace values.
	     */
	    public function getCOSColorSpaceValue():COSArray
	    {
			return colorSpaceValue;
	    }

	    /**
	     * This will update the colorspace values.
	     *
	     * @param value The new colorspace values.
	     */
	    public function setColorSpaceValue(value:Array):void
	    {
			colorSpaceValue.setFloatArray( value );
	    }
	}
}
