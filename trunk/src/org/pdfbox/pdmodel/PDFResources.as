package org.pdfbox.pdmodel
{


	import org.pdfbox.utils.HashMap;
	import org.pdfbox.utils.Map;

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSStream;

	import org.pdfbox.pdmodel.common.COSDictionaryMap;
	import org.pdfbox.pdmodel.common.COSObjectable;
	
	import org.pdfbox.pdmodel.font.PDFontFactory;
	/*
	import org.pdfbox.pdmodel.graphics.PDExtendedGraphicsState;

	import org.pdfbox.pdmodel.graphics.color.PDColorSpaceFactory;

	import org.pdfbox.pdmodel.graphics.xobject.PDXObject;
	import org.pdfbox.pdmodel.graphics.xobject.PDXObjectImage;
	*/

	/**
	 * This represents a set of resources available at the page/pages/stream level.
	 */
	public class PDFResources implements COSObjectable
	{
		private var resources:COSDictionary;

		/**
		 * Default constructor.
		 */
		public function PDFResources( resourceDictionary:COSDictionary = null )
		{
			resources = ( resourceDictionary == null )? new COSDictionary():resourceDictionary;
		}

		/**
		 * This will get the underlying dictionary.
		 *
		 * @return The dictionary for these resources.
		 */
		public function getCOSDictionary():COSDictionary
		{
			return resources;
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return resources;
		}
		
		/**
		 * This will get the map of fonts.  This will never return null.  The keys are string
		 * and the values are PDFont objects.
		 *
		 * @param fontCache A map of existing PDFont objects to reuse. 
		 * @return The map of fonts.
		 *
		 * @throws IOException If there is an error getting the fonts.
		 */
		public function getFonts( fontCache:HashMap = null ):Map
		{
			var retval:Map = null;
			var fonts:COSDictionary = resources.getDictionaryObject( COSName.FONT ) as COSDictionary;

			if( fonts == null )
			{
				fonts = new COSDictionary();
				resources.setItem( COSName.FONT, fonts );
			}

			var actuals:HashMap = new HashMap();
			retval = new COSDictionaryMap( actuals, fonts );
			var fontNames:Array = fonts.keyList();
			for ( var i:int = 0, len:int = fontNames.length; i < len;i++ )
			{
				var  fontName:COSName = fontNames[i] as COSName;
				var font:COSBase = fonts.getDictionaryObject( fontName );				
				//data-000174.pdf contains a font that is a COSArray, looks to be an error in the
				//PDF, we will just ignore entries that are not dictionaries.
				if( font is COSDictionary )
				{
					var fontDictionary:COSDictionary = font as COSDictionary;
					//actuals.put( fontName.getName(), PDFontFactory.createFontIn( fontDictionary, fontCache ) );
				}
			}
			return retval;
		}
		
		/**
		 * This will get the map of PDXObjects that are in the resource dictionary.
		 *   
		 * @return The map of xobjects.
		 * 
		 * @throws IOException If there is an error creating the xobjects.
		 *
		public Map getXObjects() throws IOException
		{
			Map retval = null;
			COSDictionary xobjects = (COSDictionary)resources.getDictionaryObject( "XObject" );
			
			if( xobjects == null )
			{
				xobjects = new COSDictionary();
				resources.setItem( "XObject", xobjects );
			}
		
			Map actuals = new HashMap();
			retval = new COSDictionaryMap( actuals, xobjects );
			Iterator imageNames = xobjects.keyList().iterator();
			while( imageNames.hasNext() )
			{
				COSName objName = (COSName)imageNames.next();
				COSBase cosObject = xobjects.getDictionaryObject(objName);
				PDXObject xobject = PDXObject.createXObject( cosObject );
				if( xobject !=null )
				{     
					actuals.put( objName.getName(), xobject);
				} 
			}
			return retval;
		}
		
		/**
		 * This will get the map of images.  An empty map will be returned if there
		 * are no underlying images.
		 * So far the keys are COSName of the image
		 * and the value is the corresponding PDXObjectImage.
		 *   
		 * @author By BM
		 * @return The map of images.
		 * @throws IOException If there is an error writing the picture.
		 *
		public Map getImages() throws IOException
		{
			Map retval = null;
			COSDictionary images = (COSDictionary)resources.getDictionaryObject( "XObject" );
			
			if( images == null )
			{
				images = new COSDictionary();
				resources.setItem( "XObject", images );
			}

			Map actuals = new HashMap();
			retval = new COSDictionaryMap( actuals, images );
			Iterator imageNames = images.keyList().iterator();
			while( imageNames.hasNext() )
			{
				COSName imageName = (COSName)imageNames.next();
				COSStream image = (COSStream)(images.getDictionaryObject(imageName));
				
				COSName subType =(COSName)image.getDictionaryObject(COSName.SUBTYPE); 
				if( subType.equals(COSName.IMAGE) )
				{
					PDXObjectImage ximage = (PDXObjectImage)PDXObject.createXObject( image );
					if( ximage !=null )
					{     
						actuals.put( imageName.getName(), ximage);
					} 
				}
			}
			return retval;
		}

		/**
		 * This will set the map of fonts.
		 *
		 * @param fonts The new map of fonts.
		 *
		public void setFonts( Map fonts )
		{
			resources.setItem( COSName.FONT, COSDictionaryMap.convert( fonts ) );
		}

		/**
		 * This will get the map of colorspaces.  This will return null if the underlying
		 * resources dictionary does not have a colorspace dictionary.  The keys are string
		 * and the values are PDColorSpace objects.
		 *
		 * @return The map of colorspaces.
		 *
		 * @throws IOException If there is an error getting the colorspaces.
		 *
		public Map getColorSpaces() throws IOException
		{
			Map retval = null;
			COSDictionary colorspaces = (COSDictionary)resources.getDictionaryObject( COSName.getPDFName( "ColorSpace" ) );

			if( colorspaces != null )
			{
				Map actuals = new HashMap();
				retval = new COSDictionaryMap( actuals, colorspaces );
				Iterator csNames = colorspaces.keyList().iterator();
				while( csNames.hasNext() )
				{
					COSName csName = (COSName)csNames.next();
					COSBase cs = colorspaces.getDictionaryObject( csName );
					actuals.put( csName.getName(), PDColorSpaceFactory.createColorSpace( cs ) );
				}
			}
			return retval;
		}

		/**
		 * This will set the map of colorspaces.
		 *
		 * @param colorspaces The new map of colorspaces.
		 *
		public void setColorSpaces( Map colorspaces )
		{
			resources.setItem( COSName.getPDFName( "ColorSpace" ), COSDictionaryMap.convert( colorspaces ) );
		}

		/**
		 * This will get the map of graphic states.  This will return null if the underlying
		 * resources dictionary does not have a graphics dictionary.  The keys are the graphic state
		 * name as a String and the values are PDExtendedGraphicsState objects.
		 *
		 * @return The map of extended graphic state objects.
		 *
		public Map getGraphicsStates()
		{
			Map retval = null;
			COSDictionary states = (COSDictionary)resources.getDictionaryObject( COSName.getPDFName( "ExtGState" ) );

			if( states != null )
			{
				Map actuals = new HashMap();
				retval = new COSDictionaryMap( actuals, states );
				Iterator names = states.keyList().iterator();
				while( names.hasNext() )
				{
					COSName name = (COSName)names.next();
					COSDictionary dictionary = (COSDictionary)states.getDictionaryObject( name );
					actuals.put( name.getName(), new PDExtendedGraphicsState( dictionary ) );
				}
			}
			return retval;
		}

		/**
		 * This will set the map of graphics states.
		 *
		 * @param states The new map of states.
		 *
		public void setGraphicsStates( Map states )
		{
			Iterator iter = states.keySet().iterator();
			COSDictionary dic = new COSDictionary();
			while( iter.hasNext() )
			{
				String name = (String)iter.next();
				PDExtendedGraphicsState state = (PDExtendedGraphicsState)states.get( name );
				dic.setItem( COSName.getPDFName( name ), state.getCOSObject() );
			}
			resources.setItem( COSName.getPDFName( "ExtGState" ), dic );
		}*/
	}
}