package org.fluidea.controls
{
	import flash.display.Sprite;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;

	import flashx.textLayout.compose.IFlowComposer;
	import flashx.textLayout.compose.StandardFlowComposer;
	import flashx.textLayout.container.DisplayObjectContainerController;
	import flashx.textLayout.container.IContainerController;
	import flashx.textLayout.conversion.ImportExportConfiguration;
	import flashx.textLayout.conversion.ITextImporter;
	import flashx.textLayout.conversion.TextFilter;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompletionEvent;
	import flashx.textLayout.events.FlowOperationEvent;
	import flashx.textLayout.events.SelectionEvent;
	import flashx.textLayout.formats.CharacterFormat;
	import flashx.textLayout.formats.ContainerFormat;
	import flashx.textLayout.formats.ICharacterFormat;
	import flashx.textLayout.formats.IContainerFormat;
	import flashx.textLayout.formats.IParagraphFormat;
	import flashx.textLayout.formats.ParagraphFormat;
	import flashx.textLayout.operations.ApplyFormatOperation;
	import flashx.textLayout.operations.CutOperation;
	import flashx.textLayout.operations.DeleteTextOperation;
	import flashx.textLayout.operations.FlowOperation;
	import flashx.textLayout.operations.FlowTextOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	import flashx.textLayout.operations.SplitParagraphOperation;
	
	import mx.utils.TextUtil;
	/**
	 * ...
	 * @author walktree
	 */
	public class TextView extends Sprite
	{
		private var textFlow:TextFlow;
		
		private var hostCharacterFormat:CharacterFormat = new CharacterFormat();
		
		private var hostParagraphFormat:ParagraphFormat = new ParagraphFormat();
		
		private var hostContainerFormat:ContainerFormat = new ContainerFormat();
		
		
		//
		private var selectionActiveIndexChanged:Boolean = false;
		
		private var _selectionActiveIndex:int = -1;
		
		public function set selectionActiveIndex(value:int):void
		{
			if (value == _selectionActiveIndex)
				return;
        
			_selectionActiveIndex = value;
			selectionActiveIndexChanged = true;

			updateDisplayList();
		}
		
		public function get selectionActiveIndex():int
		{
			return _selectionActiveIndex;
		}
		
		//----------
		private var selectionAnchorIndexChanged:Boolean = false;
		
		private var _selectionAnchorIndex:int = -1;
		
		public function get selectionAnchorIndex():int
		{
			return _selectionAnchorIndex;
		}
	
		//----------------
		private var textChanged:Boolean = false;
		
		private var styleChanged:Boolean = true;
		
		private var textInvalid:Boolean = false;
				
		private var _text:String;
		
		public function set text(s:String):void {
			
			_text = s;
			textChanged = true;
			updateDisplayList();
		}
		
		public function get text():String {
			if (textInvalid)
			{
				_text = TextUtil.extractText(textFlow);
				textInvalid = false;
			}
			return _text;
		}
		
		
		private var sizeChanged:Boolean = false;
		/*
		 *  width
		 */
		private var _width:Number = 20;
		
		override public function set width(w:Number):void {
			
			_width = w;
			sizeChanged = true;
			updateDisplayList();
		}
		
		override public function get width():Number {
			return _width;
		}
		
		/*
		 *  height
		 */
		private var _height:Number = 20;
		
		override public function set height(w:Number):void {
			
			_height = w;
			sizeChanged = true;
			updateDisplayList();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		public function setStyle(styleProp:String, value:Object):void {
			setHostFormat(styleProp, value);
		}
		
		private function setHostFormat(styleProp:String,value:Object):void
		{
			var kind:String = TextUtil.FORMAT_MAP[styleProp];

			if (kind == TextUtil.CONTAINER)
				hostContainerFormat[styleProp] = value;
			
			else if (kind == TextUtil.PARAGRAPH)
				hostParagraphFormat[styleProp] = value;
			
			else if (kind == TextUtil.CHARACTER)
				hostCharacterFormat[styleProp] = value;
		}
		
		//--------------------
		
		//		
		private static var staticImportExportConfiguration:ImportExportConfiguration;
		
		public function TextView() 
		{
			if (!staticImportExportConfiguration)
			{
				staticImportExportConfiguration =
					ImportExportConfiguration.defaultConfiguration;
				
				ImportExportConfiguration.restoreDefaults();
			}		
			
			textFlow = createEmptyTextFlow();
			
			initStyle();		 
			
		}
		
		private function createEmptyTextFlow():TextFlow
		{
			var textFlow:TextFlow = new TextFlow();
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement = new SpanElement();
			textFlow.replaceChildren(0, 0, p);
			p.replaceChildren(0, 0, span);
			return textFlow;
		}
		
		private function initStyle():void {
			setHostFormat("fontSize", 15);
			setHostFormat("color", 0x006699);
		}
		
		private function updateDisplayList():void {
			
			var flowComposer:IFlowComposer;
			
			if (textChanged || styleChanged) {
				
				if (textFlow && textFlow.flowComposer &&
                textFlow.flowComposer.numControllers)
				{
					textFlow.flowComposer.removeControllerAt(0);
				}
			
				if (textFlow != null) {
					if (text) {
						textFlow = createTextFlowFromMarkup(text);
					}				
				}else {
					textFlow = createEmptyTextFlow();
				}		
				
				
				textFlow.hostCharacterFormat = hostCharacterFormat;
				textFlow.hostParagraphFormat = hostParagraphFormat;
				textFlow.hostContainerFormat = hostContainerFormat;
			
				// Tell it where to create its TextLines.
				flowComposer = new StandardFlowComposer();
				
				flowComposer.addController(
					new DisplayObjectContainerController(this));
				textFlow.flowComposer = flowComposer;
				
				// Give it an EditManager to make it editable.
				textFlow.interactionManager = new TextViewEditManager();
				
				addListeners(textFlow);
				
				textChanged = false;
				styleChanged = false;
			}
			
			if (selectionAnchorIndexChanged || selectionActiveIndexChanged)
			{
				textFlow.interactionManager.setSelection(
					_selectionAnchorIndex, _selectionActiveIndex);
				
				selectionAnchorIndexChanged = false;
				selectionActiveIndexChanged = false;
			}
			
			flowComposer = textFlow.flowComposer;
			var containerController:IContainerController = flowComposer.getControllerAt(0);
			containerController.setCompositionSize(width, height);
			flowComposer.updateAllContainers();			
		}
		
		private function addListeners(textFlow:TextFlow):void
		{
			 textFlow.addEventListener(SelectionEvent.SELECTION_CHANGE, textFlow_selectionChangeHandler);
			 
			 textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_END, editManager_operationEndHandler);
		}
		
		 private function textFlow_selectionChangeHandler(
                        event:SelectionEvent):void
		{
			_selectionAnchorIndex = textFlow.interactionManager.anchorPosition;
			_selectionActiveIndex = textFlow.interactionManager.activePosition;
			
			//dispatchEvent(new FlexEvent(FlexEvent.SELECTION_CHANGE));
		}
		
		private function editManager_operationEndHandler(event:FlowOperationEvent):void
		{			
			textInvalid = true;		
		}
		
		public function setSelection(anchorIndex:int = 0,
                                 activeIndex:int = int.MAX_VALUE):void
		{
			textFlow.interactionManager.setSelection(anchorIndex, activeIndex);
		}
	
		public function insertText(text:String):void
		{
			EditManager(textFlow.interactionManager).insertText(text);
		}
		public function appendText(text:String):void
		{
			textFlow.interactionManager.setSelection(int.MAX_VALUE, int.MAX_VALUE);
			EditManager(textFlow.interactionManager).insertText(text);
		}
		public function insertImage(source:Object,width:Number,height:Number):void
		{
			EditManager(textFlow.interactionManager).insertInlineGraphic(source,width,height);
		}
		
		public function export():XML
		{
			return XML(TextFilter.export(textFlow, TextFilter.TEXT_LAYOUT_FORMAT, ConversionType.STRING_TYPE));
			return XML(TextFilter.export(textFlow, TextFilter.TEXT_LAYOUT_FORMAT,
										 ConversionType.XML_TYPE));
		}
				
		private function createTextFlowFromMarkup(markup:Object):TextFlow
		{

			if (markup is String)
			{
				markup = '<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">' +
						 markup +
						 '</TextFlow>';
			}
			
			return TextFilter.importToFlow(markup, TextFilter.TEXT_LAYOUT_FORMAT,
										   staticImportExportConfiguration);
		}
		
	}
	
}

import flashx.textLayout.edit.EditManager;
import flashx.textLayout.operations.FlowOperation;

class TextViewEditManager extends EditManager
{
    public function TextViewEditManager()
    {
        super();
    }

    public function execute(flowOperation:FlowOperation):void
    {
        doOperation(flowOperation);
    }
}