package org.pdfbox.tools
{	
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import org.pdfbox.pdmodel.common.PDFMatrix;
	import org.pdfbox.utils.ArrayList;
	import org.pdfbox.utils.Stack;
	import org.pdfbox.utils.Matrix2;
	import org.pdfbox.utils.HashMap;
	import org.pdfbox.utils.TextPosition;
		
	import org.pdfbox.cos.COSObject;
	import org.pdfbox.cos.COSStream;

	import org.pdfbox.pdmodel.PDFPage;
	
	import org.pdfbox.pdmodel.PDFResources;
	
	import org.pdfbox.pdmodel.font.PDFont;
	import org.pdfbox.pdmodel.graphics.PDFGraphicsState;
	import org.pdfbox.utils.PDFOperator;
	
	import org.pdfbox.operator.OperatorProcessor;
	import org.pdfbox.operator.BeginText;
	import org.pdfbox.operator.Concatenate;
	import org.pdfbox.operator.EndText;
	import org.pdfbox.operator.GRestore;
	import org.pdfbox.operator.GSave;
	import org.pdfbox.operator.Invoke;
	import org.pdfbox.operator.MoveAndShow;
	import org.pdfbox.operator.MoveText;
	import org.pdfbox.operator.MoveTextSetLeading;
	import org.pdfbox.operator.NextLine;
	import org.pdfbox.operator.SetCharSpacing;
	import org.pdfbox.operator.SetGraphicsStateParameters;
	import org.pdfbox.operator.SetHorizontalTextScaling;
	import org.pdfbox.operator.SetLineWidth;
	import org.pdfbox.operator.SetMatrix;
	import org.pdfbox.operator.SetMoveAndShow;
	import org.pdfbox.operator.SetTextFont;
	import org.pdfbox.operator.SetTextLeading;
	import org.pdfbox.operator.SetTextRenderingMode;
	import org.pdfbox.operator.SetTextRise;
	import org.pdfbox.operator.SetWordSpacing;
	import org.pdfbox.operator.ShowText;
	import org.pdfbox.operator.ShowTextGlyph;

	/**
	 * This class will run through a PDF content stream and execute certain operations
	 * and provide a callback interface for clients that want to do things with the stream.
	 * See the PDFTextStripper class for an example of how to use this class.
	 */
	public class PDFStreamEngine
	{
		private static var SPACE_BYTES:ByteArray = new ByteArray(); 
		SPACE_BYTES.writeByte(32);

		private var graphicsState:PDFGraphicsState = null;

		private var textMatrix:Matrix2 = null;
		private var textLineMatrix:Matrix2 = null;
		private var graphicsStack:Stack = new Stack();
		private var resources:PDFResources = null;
		
		private var operators:HashMap = new HashMap();
		
		private var streamResourcesStack:Stack = new Stack();
		
		private var page:PDFPage;
		
		private var documentFontCache:HashMap = new HashMap();
		
		
		
		/**
		 * Constructor with engine properties.  The property keys are all
		 * PDF operators, the values are class names used to execute those
		 * operators.
		 * 
		 * @param properties The engine properties.
		 * 
		 */
		public function PDFStreamEngine( properties:Object = null ):void
		{
			///*
			var props:Object = new Object();
			props['BT'] = new BeginText();
			props['cm'] = new Concatenate();
			props['Do'] = new Invoke();
			props['ET'] = new EndText();
			props['gs'] = new SetGraphicsStateParameters();
			props['q'] = new GSave();
			props['Q'] = new GRestore();
			props['T*'] = new NextLine();
			props['Tc'] = new SetCharSpacing();
			props['Td'] = new MoveText();
			props['TD'] = new MoveTextSetLeading();
			props['Tf'] = new SetTextFont();
			props['Tj'] = new ShowText();
			props['TJ'] = new ShowTextGlyph();
			props['TL'] = new SetTextLeading();
			props['Tm'] = new SetMatrix();
			props['Tr'] = new SetTextRenderingMode();
			props['Ts'] = new SetTextRise();
			props['Tw'] = new SetWordSpacing();
			props['Tz'] = new SetHorizontalTextScaling();
			props['w'] = new SetLineWidth();
			props['\'']= new MoveAndShow();
			props['\"']= new SetMoveAndShow();		
			//*/
			if ( props != null ) {
				
				for ( var prop:* in props ) {
					var op:OperatorProcessor = props[prop] as OperatorProcessor;
					//trace(op);
					if ( op ) {
						//var op:OperatorProcessor = new cls() as OperatorProcessor;
						//trace('op');
						registerOperatorProcessor(prop, op);
					}
				}
			}			
		}
		
		/**
		 * Register a custom operator processor with the engine.
		 * 
		 * @param operator The operator as a string.
		 * @param op Processor instance.
		 */
		public function registerOperatorProcessor( operator:String, op:OperatorProcessor ):void
		{
			op.setContext( this );
			operators.put( operator, op );
		}
		
		/**
		 * This method must be called between processing documents.  The 
		 * PDFStreamEngine caches information for the document between pages
		 * and this will release the cached information.  This only needs
		 * to be called if processing a new document.
		 *
		 */
		public function resetEngine():void
		{
			documentFontCache.clear();
		}

		/**
		 * This will process the contents of the stream.
		 *
		 * @param aPage The page.
		 * @param resources The location to retrieve resources.
		 * @param cosStream the Stream to execute.
		 * 
		 *
		 * @throws IOException if there is an error accessing the stream.
		 */
		public function processStream( aPage:PDFPage, resources:PDFResources,  cosStream:COSStream ):void
		{
			graphicsState = new PDFGraphicsState();
			textMatrix = null;
			textLineMatrix = null;
			graphicsStack.clear();
			streamResourcesStack.clear();
			
			processSubStream( aPage, resources, cosStream );
		}
		
		/**
		 * Process a sub stream of the current stream.
		 * 
		 * @param aPage The page used for drawing.
		 * @param resources The resources used when processing the stream.
		 * @param cosStream The stream to process.
		 * 
		 * @throws IOException If there is an exception while processing the stream.
		 */
		public function processSubStream( aPage:PDFPage, resources:PDFResources, cosStream:COSStream ):void
		{
			page = aPage;
			if( resources != null )
			{
				var sr:StreamResources = new StreamResources();
				sr.fonts = resources.getFonts( documentFontCache ) as HashMap;
				//sr.colorSpaces = resources.getColorSpaces();
				//sr.xobjects = resources.getXObjects();
				//sr.graphicsStates = resources.getGraphicsStates();
				sr.resources = resources;
				streamResourcesStack.push(sr);
			}
			try
			{
				var arguments:Array = new Array();
				var tokens:Array = cosStream.getStreamTokens();
				if( tokens != null )
				{
					for ( var i:int = 0, len:int = tokens.length; i < len; i++)
					{
						var next:Object = tokens[i];
						if( next is COSObject )
						{
							arguments.push( (next as COSObject).getObject() );
						}
						else if( next is PDFOperator )
						{
							processOperator( next as PDFOperator, arguments );
							arguments = new Array();
						}
						else
						{
							arguments.push( next );
						}
					}
				}
			}
			finally
			{
				if( resources != null )
				{
					streamResourcesStack.pop();
				}
			}
			
		}

		/**
		 * A method provided as an event interface to allow a subclass to perform
		 * some specific functionality when a character needs to be displayed.
		 *
		 * @param text The character to be displayed.
		 */
		protected function showCharacter( text:TextPosition ):void
		{
			//subclasses can override to provide specific functionality.
		}

		/**
		 * You should override this method if you want to perform an action when a
		 * string is being shown.
		 *
		 * @param string The string to display.
		 *
		 * @throws IOException If there is an error showing the string
		 */
		
		public function showString( string:ByteArray ) :void
		{
			var spaceWidth:Number = 0;
			var spacing:Number = 0;
			var stringResult:String = '';
			
			var characterHorizontalDisplacement:Number = 0;
			var characterVerticalDisplacement:Number = 0;
			var spaceDisplacement:Number = 0;
			var fontSize:Number = graphicsState.getTextState().getFontSize();			
			//100f
			var horizontalScaling:Number = graphicsState.getTextState().getHorizontalScalingPercent()/0x100f;
			var verticalScaling:Number = horizontalScaling;//not sure if this is right but what else to do???
			var rise:Number = graphicsState.getTextState().getRise();
			var wordSpacing:Number = graphicsState.getTextState().getWordSpacing();
			var characterSpacing:Number = graphicsState.getTextState().getCharacterSpacing();
			
			var wordSpacingDisplacement:Number = 0;
			
			var font:PDFont = graphicsState.getTextState().getFont();
			
			//This will typically be 1000 but in the case of a type3 font
			//this might be a different number
			var glyphSpaceToTextSpaceFactor:Number = 1/font.getFontMatrix().getValue( 0, 0 );
			var averageWidth:Number = font.getAverageFontWidth();

			
			var initialMatrix:Matrix2 = new Matrix2();
			//TODO
			
			initialMatrix.setValue(0,0,1);
			initialMatrix.setValue(0,1,0);
			initialMatrix.setValue(0,2,0);
			initialMatrix.setValue(1,0,0);
			initialMatrix.setValue(1,1,1);
			initialMatrix.setValue(1,2,0);
			initialMatrix.setValue(2,0,0);
			initialMatrix.setValue(2,1,rise);
			initialMatrix.setValue(2,2,1);
			

			//this
			var codeLength:int = 1;
			var ctm:Matrix2 = graphicsState.getCurrentTransformationMatrix();
			
			//lets see what the space displacement should be
			spaceDisplacement = (font.getFontWidth( SPACE_BYTES, 0, 1 )/glyphSpaceToTextSpaceFactor);
			if( spaceDisplacement == 0 )
			{
				spaceDisplacement = (averageWidth/glyphSpaceToTextSpaceFactor);
				//The average space width appears to be higher than necessary
				//so lets make it a little bit smaller.
				spaceDisplacement *= .80;
			}
			var pageRotation:int = page.findRotation();
			var trm:Matrix2 = initialMatrix.multiply( textMatrix ).multiply( ctm );
			var x:Number = trm.getValue(2,0);
			var y:Number = trm.getValue(2,1);
			if( pageRotation == 0 )
			{
				trm.setValue( 2,1, -y + page.findMediaBox().getHeight() );
			}
			else if( pageRotation == 90 )
			{
				trm.setValue( 2,0, y );
				trm.setValue( 2,1, x );
			}
			else if( pageRotation == 270 )
			{
				trm.setValue( 2,0, -y  + page.findMediaBox().getHeight() );
				trm.setValue( 2,1, x );
			}
			for( var i:int=0; i<string.length; i+=codeLength )
			{
				codeLength = 1;

				var c:String = font.encode( string, i, codeLength );
				if( c == null && i+1<string.length)
				{
					//maybe a multibyte encoding
					codeLength++;
					c = font.encode( string, i, codeLength );
				}
				stringResult += c;

				//todo, handle horizontal displacement
				characterHorizontalDisplacement += (font.getFontWidth( string, i, codeLength )/glyphSpaceToTextSpaceFactor);
				characterVerticalDisplacement = 
					Math.max( 
						characterVerticalDisplacement, 
						font.getFontHeight( string, i, codeLength)/glyphSpaceToTextSpaceFactor);


				// PDF Spec - 5.5.2 Word Spacing
				//
				// Word spacing works the same was as character spacing, but applies
				// only to the space character, code 32.
				//
				// Note: Word spacing is applied to every occurrence of the single-byte
				// character code 32 in a string.  This can occur when using a simple
				// font or a composite font that defines code 32 as a single-byte code.
				// It does not apply to occurrences of the byte value 32 in multiple-byte
				// codes.
				//
				// RDD - My interpretation of this is that only character code 32's that
				// encode to spaces should have word spacing applied.  Cases have been
				// observed where a font has a space character with a character code
				// other than 32, and where word spacing (Tw) was used.  In these cases,
				// applying word spacing to either the non-32 space or to the character
				// code 32 non-space resulted in errors consistent with this interpretation.
				//
				if( (string[i] == 0x20) && c == " " )
				{
					spacing += wordSpacing + characterSpacing;
				}
				else
				{
					spacing += characterSpacing;
				}
				// We want to update the textMatrix using the width, in text space units.
				//
				
			}
			
			//The adjustment will always be zero.  The adjustment as shown in the
			//TJ operator will be handled separately.
			var adjustment:Number=0;
			//todo, need to compute the vertical displacement
			var ty:Number = 0;
			var tx:Number = ((characterHorizontalDisplacement-adjustment/glyphSpaceToTextSpaceFactor)*fontSize + spacing)
					   *horizontalScaling;
			
			var xScale:Number = trm.getXScale();
			var yScale:Number = trm.getYScale(); 
			var xPos:Number = trm.getXPosition();
			var yPos:Number = trm.getYPosition();
			spaceWidth = spaceDisplacement * xScale * fontSize;
			wordSpacingDisplacement = wordSpacing*xScale * fontSize;
			var td:Matrix2 = new Matrix2();
			td.setValue( 2, 0, tx );
			td.setValue( 2, 1, ty );            
			
			var xPosBefore:Number = textMatrix.getXPosition();
			var yPosBefore:Number = textMatrix.getYPosition();
			textMatrix = td.multiply( textMatrix );

			var totalStringWidth:Number = 0;
			var totalStringHeight:Number = characterVerticalDisplacement * fontSize * yScale;
			if( pageRotation == 0 )
			{
				totalStringWidth = (textMatrix.getXPosition() - xPosBefore);
			}
			else if( pageRotation == 90 )
			{
				totalStringWidth = (textMatrix.getYPosition() - yPosBefore);
			}
			else if( pageRotation == 270 )
			{
				totalStringWidth = (yPosBefore - textMatrix.getYPosition());
			}
			showCharacter(
					new TextPosition(
						xPos,
						yPos,
						xScale,
						yScale,
						totalStringWidth,
						totalStringHeight,
						spaceWidth,
						stringResult.toString(),
						font,
						fontSize,
						wordSpacingDisplacement ));
		}
		
		/**
		 * This is used to handle an operation.
		 *
		 * @param operation The operation to perform.
		 * @param arguments The list of arguments.
		 *
		 * @throws IOException If there is an error processing the operation.
		 */
		public function $processOperator( operation:String, args:Array ):void
		{
			var oper:PDFOperator = PDFOperator.getOperator( operation );
			processOperator( oper, args );
		}

		/**
		 * This is used to handle an operation.
		 *
		 * @param operator The operation to perform.
		 * @param arguments The list of arguments.
		 *
		 * @throws IOException If there is an error processing the operation.
		 */
		public function processOperator( oper:Object, args:Array ) :void
		{
			var operation:String;
			var operator:PDFOperator;
			if ( oper is PDFOperator ) { 
				operator = oper as PDFOperator;
				operation = operator.getOperation();
			}else {
				$processOperator(oper as String, args);
				return;
			}
			var processor:OperatorProcessor = operators.get( operation ) as OperatorProcessor;
			if( processor != null )
			{
				processor.process( operator, args );
			}
		} 
	   
		/**
		 * @return Returns the colorSpaces.
		 */
		/*public Map getColorSpaces() 
		{
			return ((StreamResources) streamResourcesStack.peek()).colorSpaces;
		}*/
		
		/**
		 * @return Returns the colorSpaces.
		 */
		/*public Map getXObjects() 
		{
			return ((StreamResources) streamResourcesStack.peek()).xobjects;
		}
		*/
		/**
		 * @param value The colorSpaces to set.
		 */
		/*public void setColorSpaces(Map value) 
		{
			((StreamResources) streamResourcesStack.peek()).colorSpaces = value;
		}*/
		/**
		 * @return Returns the fonts.
		 */
		public function getFonts():HashMap 
		{
			return (streamResourcesStack.peek() as StreamResources).fonts;
		}
		/**
		 * @param value The fonts to set.
		 */
		public function setFonts(value:HashMap):void
		{
			( streamResourcesStack.peek() as StreamResources).fonts = value;
		}
		/**
		 * @return Returns the graphicsStack.
		 */
		public function getGraphicsStack():Stack
		{
			return graphicsStack;
		}
		/**
		 * @param value The graphicsStack to set.
		 */
		public function setGraphicsStack(value:Stack):void
		{
			graphicsStack = value;
		}
		/**
		 * @return Returns the graphicsState.
		 */
		public function getGraphicsState():PDFGraphicsState
		{
			return graphicsState;
		}
		/**
		 * @param value The graphicsState to set.
		 */
		public function setGraphicsState(value:PDFGraphicsState):void
		{
			graphicsState = value;
		}
		/**
		 * @return Returns the graphicsStates.
		 */
		public function getGraphicsStates():HashMap 
		{
			return (streamResourcesStack.peek() as StreamResources).graphicsStates;
		}
		/**
		 * @param value The graphicsStates to set.
		 */
		public function setGraphicsStates(value:HashMap):void 
		{
			(streamResourcesStack.peek() as StreamResources).graphicsStates = value;
		}
		/**
		 * @return Returns the textLineMatrix.
		 */
		public function getTextLineMatrix():Matrix2
		{
			return textLineMatrix;
		}
		/**
		 * @param value The textLineMatrix to set.
		 */
		public function setTextLineMatrix(value:Matrix2 = null):void
		{
			textLineMatrix = value;
		}
		/**
		 * @return Returns the textMatrix.
		 */
		public function getTextMatrix():Matrix2 
		{
			return textMatrix;
		}
		/**
		 * @param value The textMatrix to set.
		 */
		public function setTextMatrix( value:Matrix2 = null ):void
		{
			textMatrix = value;
		}
		/**
		 * @return Returns the resources.
		 */
		public function getResources():PDFResources
		{
			return (streamResourcesStack.peek() as StreamResources).resources;
		}
		
		/**
		 * Get the current page that is being processed.
		 * 
		 * @return The page being processed.
		 */
		public function getCurrentPage():PDFPage
		{
			return page;
		}
	}
}
import org.pdfbox.pdmodel.PDFResources;
import org.pdfbox.utils.HashMap;

/**
 * This is a simple internal class used by the Stream engine to handle the 
 * resources stack.
 */
class StreamResources
{
	public var fonts:HashMap;
	public var colorSpaces:HashMap;
	public var xobjects:HashMap;
	public var graphicsStates:HashMap;
	public var resources:PDFResources;
}