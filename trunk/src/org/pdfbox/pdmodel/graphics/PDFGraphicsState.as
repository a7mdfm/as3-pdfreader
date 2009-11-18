package org.pdfbox.pdmodel.graphics
{

	import flash.geom.Matrix;
	import org.pdfbox.utils.ICloneable;

	import org.pdfbox.pdmodel.text.PDFTextState;
	

	import org.pdfbox.pdmodel.graphics.color.PDFColorSpaceInstance;

	/**
	 * This class will hold the current state of the graphics parameters when executing a
	 * content stream.
	 */
	public class PDFGraphicsState implements ICloneable
	{
		private var currentTransformationMatrix:Matrix = new Matrix();

		//Here are some attributes of the Graphics state, but have not been created yet.
		//
		//clippingPath
		//private PDColorSpaceInstance strokingColorSpace = new PDColorSpaceInstance();
		//private PDColorSpaceInstance nonStrokingColorSpace = new PDColorSpaceInstance();
		private var textState:PDFTextState = new PDFTextState();
		private var lineWidth:Number = 0;
		private var lineCap:int = 0;
		private var lineJoin:int = 0;
		private var miterLimit:Number = 0;
		private var lineDashPattern:PDLineDashPattern;
		private var renderingIntent:String;
		private var strokeAdjustment:Boolean = false;
		//blend mode
		//soft mask
		private var alphaConstants:Number = 0;
		private var alphaSource:Boolean = false;

		//DEVICE DEPENDENT parameters
		private var overprint:Boolean  = false;
		private var overprintMode:Number = 0;
		//black generation
		//undercolor removal
		//transfer
		//halftone
		private var flatness:Number = 1.0;
		private var smoothness:Number = 0;

		/**
		 * Get the value of the CTM.
		 *
		 * @return The current transformation matrix.
		 */
		public function getCurrentTransformationMatrix():Matrix
		{
			return currentTransformationMatrix;
		}

		/**
		 * Set the value of the CTM.
		 *
		 * @param value The current transformation matrix.
		 */
		public function setCurrentTransformationMatrix(value:Matrix):void
		{
			currentTransformationMatrix = value;
		}

		/**
		 * Get the value of the line width.
		 *
		 * @return The current line width.
		 */
		public function getLineWidth():Number
		{
			return lineWidth;
		}

		/**
		 * set the value of the line width.
		 *
		 * @param value The current line width.
		 */
		public function setLineWidth(value:Number)
		{
			lineWidth = value;
		}

		/**
		 * Get the value of the line cap.
		 *
		 * @return The current line cap.
		 */
		public function getLineCap():int
		{
			return lineCap;
		}

		/**
		 * set the value of the line cap.
		 *
		 * @param value The current line cap.
		 */
		public function setLineCap(value:int):void
		{
			lineCap = value;
		}

		/**
		 * Get the value of the line join.
		 *
		 * @return The current line join value.
		 */
		public function getLineJoin():int
		{
			return lineJoin;
		}

		/**
		 * Get the value of the line join.
		 *
		 * @param value The current line join
		 */
		public function setLineJoin(value:int):void
		{
			lineJoin = value;
		}

		/**
		 * Get the value of the miter limit.
		 *
		 * @return The current miter limit.
		 */
		public function getMiterLimit():Number
		{
			return miterLimit;
		}

		/**
		 * set the value of the miter limit.
		 *
		 * @param value The current miter limit.
		 */
		public function setMiterLimit(value:Number):void
		{
			miterLimit = value;
		}

		/**
		 * Get the value of the stroke adjustment parameter.
		 *
		 * @return The current stroke adjustment.
		 */
		public function isStrokeAdjustment():Boolean
		{
			return strokeAdjustment;
		}

		/**
		 * set the value of the stroke adjustment.
		 *
		 * @param value The value of the stroke adjustment parameter.
		 */
		public function setStrokeAdjustment(value:Boolean):void
		{
			strokeAdjustment = value;
		}

		/**
		 * Get the value of the alpha constants property.
		 *
		 * @return The value of the alpha constants parameter.
		 */
		public function getAlphaConstants():Number
		{
			return alphaConstants;
		}

		/**
		 * set the value of the alpha constants property.
		 *
		 * @param value The value of the alpha constants parameter.
		 */
		public function setAlphaConstants(value:Number):void
		{
			alphaConstants = value;
		}

		/**
		 * get the value of the alpha source property.
		 *
		 * @return The value of the alpha source parameter.
		 */
		public function isAlphaSource():Boolean
		{
			return alphaSource;
		}

		/**
		 * set the value of the alpha source property.
		 *
		 * @param value The value of the alpha source parameter.
		 */
		public function setAlphaSource(value:Boolean):void
		{
			alphaSource = value;
		}

		/**
		 * get the value of the overprint property.
		 *
		 * @return The value of the overprint parameter.
		 */
		public function isOverprint():Boolean
		{
			return overprint;
		}

		/**
		 * set the value of the overprint property.
		 *
		 * @param value The value of the overprint parameter.
		 */
		public function setOverprint(value:Boolean):void
		{
			overprint = value;
		}

		/**
		 * get the value of the overprint mode property.
		 *
		 * @return The value of the overprint mode parameter.
		 */
		public function getOverprintMode():Number
		{
			return overprintMode;
		}

		/**
		 * set the value of the overprint mode property.
		 *
		 * @param value The value of the overprint mode parameter.
		 */
		public function setOverprintMode(value:Number):void
		{
			overprintMode = value;
		}

		/**
		 * get the value of the flatness property.
		 *
		 * @return The value of the flatness parameter.
		 */
		public function getFlatness():Number
		{
			return flatness;
		}

		/**
		 * set the value of the flatness property.
		 *
		 * @param value The value of the flatness parameter.
		 */
		public function setFlatness(value:Number):void
		{
			flatness = value;
		}

		/**
		 * get the value of the smoothness property.
		 *
		 * @return The value of the smoothness parameter.
		 */
		public function getSmoothness():Number
		{
			return smoothness;
		}

		/**
		 * set the value of the smoothness property.
		 *
		 * @param value The value of the smoothness parameter.
		 */
		public function setSmoothness(value:Number):void
		{
			smoothness = value;
		}

		/**
		 * This will get the graphics text state.
		 *
		 * @return The graphics text state.
		 */
		public function getTextState():PDFTextState
		{
			return textState;
		}

		/**
		 * This will set the graphics text state.
		 *
		 * @param value The graphics text state.
		 */
		public function setTextState(value:PDFTextState):void
		{
			textState = value;
		}

		/**
		 * This will get the current line dash pattern.
		 *
		 * @return The line dash pattern.
		 */
		public function getLineDashPattern():PDFLineDashPattern
		{
			return lineDashPattern;
		}

		/**
		 * This will set the current line dash pattern.
		 *
		 * @param value The new line dash pattern.
		 */
		public function setLineDashPattern( value:PDFLineDashPattern):void
		{
			lineDashPattern = value;
		}

		/**
		 * This will get the rendering intent.
		 *
		 * @see PDExtendedGraphicsState
		 *
		 * @return The rendering intent
		 */
		public function getRenderingIntent():String
		{
			return renderingIntent;
		}

		/**
		 * This will set the rendering intent.
		 *
		 * @param value The new rendering intent.
		 */
		public function setRenderingIntent(value:String):void
		{
			renderingIntent = value;
		}

		/**
		 * {@inheritDoc}
		 */
		public function clone():Object
		{
			var clone:PDFGraphicsState = new PDFGraphicsState;

			clone.setTextState( textState.clone() );
			clone.setCurrentTransformationMatrix( currentTransformationMatrix.clone() );

			return clone;
		}

		/**
		 * This will get the current stroking colorspace.
		 *
		 * @return The current stroking colorspace.
		 */
		public function getStrokingColorSpace():PDFColorSpaceInstance
		{
			return strokingColorSpace;
		}

		/**
		 * This will set the current stroking colorspace.
		 *
		 * @param value The new stroking colorspace instance.
		 */
		public function setStrokingColorSpace(value:PDFColorSpaceInstance):void
		{
			strokingColorSpace = value;
		}

		/**
		 * This will get the nonstroking color space instance.
		 *
		 * @return The colorspace instance.
		 */
		public function getNonStrokingColorSpace():PDFColorSpaceInstance
		{
			return nonStrokingColorSpace;
		}

		/**
		 * This will set the non-stroking colorspace instance.
		 *
		 * @param value The non-stroking colorspace instance.
		 */
		public function setNonStrokingColorSpace(value:PDFColorSpaceInstance):void
		{
			nonStrokingColorSpace = value;
		}
	}
}