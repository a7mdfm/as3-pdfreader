package org.pdfbox.pdmodel.common
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSStream;
	import org.pdfbox.cos.COSString;

	/**
	 * A PDTextStream class is used when the PDF specification supports either
	 * a string or a stream for the value of an object.  This is usually when
	 * a value could be large or small, for example a JavaScript method.  This
	 * class will help abstract that and give a single unified interface to
	 * those types of fields.
	 */
	public class PDFTextStream implements COSObjectable
	{
	    private COSString string;
	    private COSStream stream;

	    /**
	     * Constructor.
	     *
	     * @param str The string parameter.
	     */
	    public PDFTextStream( COSString str )
	    {
		string = str;
	    }

	    /**
	     * Constructor.
	     *
	     * @param str The string parameter.
	     */
	    public PDTextStream( String str )
	    {
		string = new COSString( str );
	    }

	    /**
	     * Constructor.
	     *
	     * @param str The stream parameter.
	     */
	    public PDTextStream( COSStream str )
	    {
		stream = str;
	    }

	    /**
	     * This will create the text stream object.  base must either be a string
	     * or a stream.
	     *
	     * @param base The COS text stream object.
	     *
	     * @return A PDTextStream that wraps the base object.
	     */
	    public function static PDTextStream createTextStream( COSBase base )
	    {
		PDTextStream retval = null;
		if( base instanceof COSString )
		{
		    retval = new PDTextStream( (COSString) base );
		}
		else if( base instanceof COSStream )
		{
		    retval = new PDTextStream( (COSStream)base );
		}
		return retval;
	    }

	    /**
	     * Convert this standard java object to a COS object.
	     *
	     * @return The cos object that matches this Java object.
	     */
	    public COSBase getCOSObject()
	    {
		COSBase retval = null;
		if( string == null )
		{
		    retval = stream;
		}
		else
		{
		    retval = string;
		}
		return retval;
	    }

	    /**
	     * This will get this value as a string.  If this is a stream then it
	     * will load the entire stream into memory, so you should only do this when
	     * the stream is a manageable size.
	     *
	     * @return This value as a string.
	     *
	     * @throws IOException If an IO error occurs while accessing the stream.
	     */
	    public String getAsString() throws IOException
	    {
		String retval = null;
		if( string != null )
		{
		    retval = string.getString();
		}
		else
		{
		    ByteArrayOutputStream out = new ByteArrayOutputStream();
		    byte[] buffer = new byte[ 1024 ];
		    int amountRead = -1;
		    InputStream is = stream.getUnfilteredStream();
		    while( (amountRead = is.read( buffer ) ) != -1 )
		    {
			out.write( buffer, 0, amountRead );
		    }
		    retval = new String( out.toByteArray() );
		}
		return retval;
	    }

	    /**
	     * This is the preferred way of getting data with this class as it uses
	     * a stream object.
	     *
	     * @return The stream object.
	     *
	     * @throws IOException If an IO error occurs while accessing the stream.
	     */
	    public InputStream getAsStream() throws IOException
	    {
		InputStream retval = null;
		if( string != null )
		{
		    retval = new ByteArrayInputStream( string.getBytes() );
		}
		else
		{
		    retval = stream.getUnfilteredStream();
		}
		return retval;
	    }
	}
}