package org.fluidea.controls 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * simple button
	 */
	public class Button extends Sprite
	{
		
		private var txt:TextField;	
		
		public function Button(label:String) 
		{
			createChildren(label);
			
			drawBox();
			
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
		private function createChildren(s:String):void {
			txt = new TextField();
			txt.text = s;
			txt.selectable = false;
			txt.autoSize = "left";
			txt.setTextFormat(new TextFormat("Arial", 12));
			txt.x = 2;
			
			addChild(txt);
		}
		
		private function drawBox():void {
			var g:Graphics = this.graphics;
			g.lineStyle(1, 0x808888);
			g.beginFill(0xEFEFEF);
			g.drawRect(0, 0, txt.textWidth + 6, txt.textHeight + 4);
			g.endFill();
		}
	}
	
}