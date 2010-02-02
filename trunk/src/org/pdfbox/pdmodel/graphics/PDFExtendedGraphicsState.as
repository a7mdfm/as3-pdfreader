package org.pdfbox.pdmodel.graphics{

	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSFloat;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSNumber;

	import org.pdfbox.pdmodel.common.COSObjectable;


	/**
	 * This class represents the graphics state dictionary that is stored in the PDF document.
	 * The PDGraphicsStateValue holds the current runtime values as a stream is being executed.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.5 $
	 */
	public class PDFExtendedGraphicsState implements COSObjectable
	{
		private static const LW:COSName = COSName.getPDFName( "LW" );
		private static const LC:COSName = COSName.getPDFName( "LC" );
		private static const LJ:COSName = COSName.getPDFName( "LJ" );
		private static const ML:COSName = COSName.getPDFName( "ML" );
		private static const D:COSName = COSName.getPDFName( "D" );
		private static const RI:COSName = COSName.getPDFName( "RI" );
		private static const OP:COSName = COSName.getPDFName( "OP" );
		private static const OP_NS:COSName = COSName.getPDFName( "op" );
		private static const OPM:COSName = COSName.getPDFName( "OPM" );
		private static const FONT:COSName = COSName.getPDFName( "Font" );
		private static const FL:COSName = COSName.getPDFName( "FL" );
		private static const SM:COSName = COSName.getPDFName( "SM" );
		private static const SA:COSName = COSName.getPDFName( "SA" );
		private static const CA:COSName = COSName.getPDFName( "CA" );
		private static const CA_NS:COSName = COSName.getPDFName( "ca" );
		private static const AIS:COSName = COSName.getPDFName( "AIS" );
		private static const TK:COSName= COSName.getPDFName( "TK" );

		/**
		 * Rendering intent constants, see PDF Reference 1.5 Section 4.5.4 Rendering Intents.
		 */
		public static const RENDERING_INTENT_ABSOLUTE_COLORIMETRIC:String = "AbsoluteColorimetric";
		/**
		 * Rendering intent constants, see PDF Reference 1.5 Section 4.5.4 Rendering Intents.
		 */
		public static const RENDERING_INTENT_RELATIVE_COLORIMETRIC:String = "RelativeColorimetric";
		/**
		 * Rendering intent constants, see PDF Reference 1.5 Section 4.5.4 Rendering Intents.
		 */
		public static const RENDERING_INTENT_SATURATION:String = "Saturation";
		/**
		 * Rendering intent constants, see PDF Reference 1.5 Section 4.5.4 Rendering Intents.
		 */
		public static const RENDERING_INTENT_PERCEPTUAL:String = "Perceptual";


		private var graphicsState:COSDictionary;

		/**
		 * Default constructor, creates blank graphics state.
		 */
		public function PDFExtendedGraphicsState(dictionary:COSDictionary = null)
		{
			if ( dictionary != null ) {
				graphicsState = dictionary;
			}else {
				graphicsState = new COSDictionary();
				graphicsState.setItem( COSName.TYPE, COSName.getPDFName( "ExtGState" ) );
			}
			
		}

		/**
		 * This will implement the gs operator.
		 *
		 * @param gs The state to copy this dictionaries values into.
		 *
		 * @throws IOException If there is an error copying font information.
		 */
		public function copyIntoGraphicsState( gs:PDFGraphicsState ):void
		{
			/*Iterator keys = graphicsState.keyList().iterator();
			while( keys.hasNext() )
			{
				COSName key = (COSName)keys.next();
				if( key.equals( LW ) )
				{
					gs.setLineWidth( getLineWidth().doubleValue() );
				}
				else if( key.equals( LC ) )
				{
					gs.setLineCap( getLineCapStyle() );
				}
				else if( key.equals( LJ ) )
				{
					gs.setLineJoin( getLineJoinStyle() );
				}
				else if( key.equals( ML ) )
				{
					gs.setMiterLimit( getMiterLimit().doubleValue() );
				}
				else if( key.equals( D ) )
				{
					gs.setLineDashPattern( getLineDashPattern() );
				}
				else if( key.equals( RI ) )
				{
					gs.setRenderingIntent( getRenderingIntent() );
				}
				else if( key.equals( OPM ) )
				{
					gs.setOverprintMode( getOverprintMode().doubleValue() );
				}
				else if( key.equals( FONT ) )
				{
					PDFontSetting setting = getFontSetting();
					gs.getTextState().setFont( setting.getFont() );
					gs.getTextState().setFontSize( setting.getFontSize() );
				}
				else if( key.equals( FL ) )
				{
					gs.setFlatness( getFlatnessTolerance().floatValue() );
				}
				else if( key.equals( SM ) )
				{
					gs.setSmoothness( getSmoothnessTolerance().floatValue() );
				}
				else if( key.equals( SA ) )
				{
					gs.setStrokeAdjustment( getAutomaticStrokeAdjustment() );
				}
				else if( key.equals( CA ) )
				{
					gs.setAlphaConstants( getStrokingAlpaConstant().floatValue() );
				}/**
				else if( key.equals( CA_NS ) )
				{
				}/
				else if( key.equals( AIS ) )
				{
					gs.setAlphaSource( getAlphaSourceFlag() );
				}
				else if( key.equals( TK ) )
				{
					gs.getTextState().setKnockoutFlag( getTextKnockoutFlag() );
				}
			}*/
		}

		/**
		 * This will get the underlying dictionary that this class acts on.
		 *
		 * @return The underlying dictionary for this class.
		 */
		public function getCOSDictionary():COSDictionary
		{
			return graphicsState;
		}

		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject():COSBase
		{
			return graphicsState;
		}

		/**
		 * This will get the line width.  This will return null if there is no line width
		 *
		 * @return null or the LW value of the dictionary.
		 */
		public function getLineWidth():Number
		{
			return getFloatItem( LW );
		}

		/**
		 * This will set the line width.
		 *
		 * @param width The line width for the object.
		 */
		public function setLineWidth( width:Number ):void
		{
			setFloatItem( LW, width );
		}

		/**
		 * This will get the line cap style.
		 *
		 * @return null or the LC value of the dictionary.
		 */
		public function getLineCapStyle():int
		{
			return graphicsState.getInt( LC );
		}

		/**
		 * This will set the line cap style for the graphics state.
		 *
		 * @param style The new line cap style to set.
		 */
		public function setLineCapStyle( style:int ):void
		{
			graphicsState.setInt( LC, style );
		}

		/**
		 * This will get the line join style.
		 *
		 * @return null or the LJ value in the dictionary.
		 */
		public function getLineJoinStyle():int
		{
			return graphicsState.getInt( LJ );
		}

		/**
		 * This will set the line join style.
		 *
		 * @param style The new line join style.
		 */
		public function setLineJoinStyle( style:int ):void
		{
			graphicsState.setInt( LJ, style );
		}


		/**
		 * This will get the miter limit.
		 *
		 * @return null or the ML value in the dictionary.
		 */
		public function getMiterLimit():Number
		{
			return getFloatItem( ML );
		}

		/**
		 * This will set the miter limit for the graphics state.
		 *
		 * @param miterLimit The new miter limit value
		 */
		public function setMiterLimit( miterLimit:Number ):void
		{
			setFloatItem( ML, miterLimit );
		}

		/**
		 * This will get the dash pattern.
		 *
		 * @return null or the D value in the dictionary.
		 */
		public function getLineDashPattern():PDFLineDashPattern
		{
			var retval:PDFLineDashPattern = null;
			var dp:COSArray = graphicsState.getDictionaryObject( D ) as COSArray;
			if( dp != null )
			{
				retval = new PDFLineDashPattern( dp );
			}
			return retval;
		}

		/**
		 * This will set the dash pattern for the graphics state.
		 *
		 * @param dashPattern The dash pattern
		 */
		public function setLineDashPattern( dashPattern:PDFLineDashPattern ):void
		{
			graphicsState.setItem( D, dashPattern.getCOSObject() );
		}

		/**
		 * This will get the rendering intent.
		 *
		 * @return null or the RI value in the dictionary.
		 */
		public function getRenderingIntent():String
		{
			return graphicsState.getNameAsString( "RI" );
		}

		/**
		 * This will set the rendering intent for the graphics state.
		 *
		 * @param ri The new rendering intent
		 */
		public function setRenderingIntent( ri:String ):void
		{
			graphicsState.setName( "RI", ri );
		}

		/**
		 * This will get the overprint control.
		 *
		 * @return The overprint control or null if one has not been set.
		 */
		public function getStrokingOverprintControl():Boolean
		{
			return graphicsState.getBoolean( OP, false );
		}

		/**
		 * This will get the overprint control(OP).
		 *
		 * @param op The overprint control.
		 */
		public function setStrokingOverprintControl( op:Boolean ):void
		{
			graphicsState.setBoolean( OP, op );
		}

		/**
		 * This will get the overprint control for non stroking operations.  If this
		 * value is null then the regular overprint control value will be returned.
		 *
		 * @return The overprint control or null if one has not been set.
		 */
		public function getNonStrokingOverprintControl():Boolean 
		{
			return graphicsState.getBoolean( OP_NS, getStrokingOverprintControl() );
		}

		/**
		 * This will get the overprint control(OP).
		 *
		 * @param op The overprint control.
		 */
		public function setNonStrokingOverprintControl( op:Boolean ):void
		{
			graphicsState.setBoolean( OP_NS, op );
		}

		/**
		 * This will get the overprint control mode.
		 *
		 * @return The overprint control mode or null if one has not been set.
		 */
		public function getOverprintMode():Number
		{
			return getFloatItem( OPM );
		}

		/**
		 * This will get the overprint mode(OPM).
		 *
		 * @param overprintMode The overprint mode
		 */
		public function setOverprintMode( overprintMode:Number ):void
		{
			setFloatItem( OPM, overprintMode );
		}

		/**
		 * This will get the font setting of the graphics state.
		 *
		 * @return The font setting.
		 */
		/*public PDFontSetting getFontSetting()
		{
			PDFontSetting setting = null;
			COSArray font = (COSArray)graphicsState.getDictionaryObject( FONT );
			if( font != null )
			{
				setting = new PDFontSetting( font );
			}
			return setting;
		}*/

		/**
		 * This will set the font setting for this graphics state.
		 *
		 * @param fs The new font setting.
		 */
		/*public function setFontSetting( PDFontSetting fs ):void
		{
			graphicsState.setItem( FONT, fs );
		}*/

		/**
		 * This will get the flatness tolerance.
		 *
		 * @return The flatness tolerance or null if one has not been set.
		 */
		public function getFlatnessTolerance():Number
		{
			return getFloatItem( FL );
		}

		/**
		 * This will get the flatness tolerance.
		 *
		 * @param flatness The new flatness tolerance
		 */
		public function setFlatnessTolerance( flatness:Number ):void
		{
			setFloatItem( FL, flatness );
		}

		/**
		 * This will get the smothness tolerance.
		 *
		 * @return The smothness tolerance or null if one has not been set.
		 */
		public function getSmoothnessTolerance():Number
		{
			return getFloatItem( SM );
		}

		/**
		 * This will get the smoothness tolerance.
		 *
		 * @param smoothness The new smoothness tolerance
		 */
		public function setSmoothnessTolerance( smoothness:Number ):void
		{
			setFloatItem( SM, smoothness );
		}

		/**
		 * This will get the automatic stroke adjustment flag.
		 *
		 * @return The automatic stroke adjustment flag or null if one has not been set.
		 */
		public function getAutomaticStrokeAdjustment():Boolean
		{
			return graphicsState.getBoolean( SA,false );
		}

		/**
		 * This will get the automatic stroke adjustment flag.
		 *
		 * @param sa The new automatic stroke adjustment flag.
		 */
		public function setAutomaticStrokeAdjustment( sa:Boolean ):void
		{
			graphicsState.setBoolean( SA, sa );
		}

		/**
		 * This will get the stroking alpha constant.
		 *
		 * @return The stroking alpha constant or null if one has not been set.
		 */
		public function getStrokingAlpaConstant():Number
		{
			return getFloatItem( CA );
		}

		/**
		 * This will get the stroking alpha constant.
		 *
		 * @param alpha The new stroking alpha constant.
		 */
		public function setStrokingAlphaConstant( alpha:Number ):void
		{
			setFloatItem( CA, alpha );
		}

		/**
		 * This will get the non stroking alpha constant.
		 *
		 * @return The non stroking alpha constant or null if one has not been set.
		 */
		public function getNonStrokingAlpaConstant():Number
		{
			return getFloatItem( CA_NS );
		}

		/**
		 * This will get the non stroking alpha constant.
		 *
		 * @param alpha The new non stroking alpha constant.
		 */
		public function setNonStrokingAlphaConstant( alpha:Number ):void
		{
			setFloatItem( CA_NS, alpha );
		}

		/**
		 * This will get the alpha source flag.
		 *
		 * @return The alpha source flag.
		 */
		public function getAlphaSourceFlag():Boolean
		{
			return graphicsState.getBoolean( AIS, false );
		}

		/**
		 * This will get the alpha source flag.
		 *
		 * @param alpha The alpha source flag.
		 */
		public function setAlphaSourceFlag( alpha:Boolean ):void
		{
			graphicsState.setBoolean( AIS, alpha );
		}

		/**
		 * This will get the text knockout flag.
		 *
		 * @return The text knockout flag.
		 */
		public function getTextKnockoutFlag():Boolean
		{
			return graphicsState.getBoolean( TK,true );
		}

		/**
		 * This will get the text knockout flag.
		 *
		 * @param tk The text knockout flag.
		 */
		public function setTextKnockoutFlag( tk:Boolean ):void
		{
			graphicsState.setBoolean( TK, tk );
		}

		/**
		 * This will get a float item from the dictionary.
		 *
		 * @param key The key to the item.
		 *
		 * @return The value for that item.
		 */
		private function getFloatItem( key:COSName ):Number
		{
			var retval:Number;
			var value:COSNumber = graphicsState.getDictionaryObject( key ) as COSNumber;
			if( value != null )
			{
				retval =  value.floatValue();
			}
			return retval;
		}

		/**
		 * This will set a float object.
		 *
		 * @param key The key to the data that we are setting.
		 * @param value The value that we are setting.
		 */
		private function setFloatItem( key:COSName, value:Number ):void
		{
			if( isNaN(value))
			{
				graphicsState.removeItem( key );
			}
			else
			{
				graphicsState.setItem( key, new COSFloat( value) );
			}
		}
	}
}