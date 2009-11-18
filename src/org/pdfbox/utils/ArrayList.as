package org.pdfbox.utils 
{
	
	/**
	 *  one wrapped array
	 *  I need Collect ? or List  -- 
	 * 
	 *  @author: walktree
	 *  
	 */
	public class ArrayList implements List 
	{
		
		protected var _data:Array;
		
		public function ArrayList( len:int = 0 ) 
		{
			this.clear();
			
			if (len) {
				_data = new Array(len);
			}
		}
		
		public function clear():void {
			this._data = [];
		}
		
		public function add ( obj:Object ):Boolean {
			this._data.push(obj);
			return true;
		}
		
		public function addAll ( collect:Array, startIndex:int = -1 ):void {
			if ( startIndex >= 0) {
				this._data.splice(startIndex, 0, collect);
			}else {
				this._data.push(collect); 
			}
		}
		
		public function addAt ( i:int, obj:Object):void {
			this._data.splice( i, 0, obj );
		}
		
		public function get ( i:int ):Object {
			return this._data[i];
		}
		
			
		public function contains ( obj:Object ):Boolean {
			var index:int = this.indexOf(obj);
			
			return index == -1;
		}	
				
		public function indexOf( obj:Object ):int {
			return this._data.indexOf(obj);			
		}
		
		public function removeAt ( i:int ):Object {
			return this._data.splice( i, 1 )[0];
		}
		
		public function remove ( obj:* ):Boolean {
			var index:int = this.indexOf(obj);
			if (index != -1) {
				
				_data.splice(index, 1);
				return true;
			}
			return false;
		}
		/*
		 *  remove elements which are in "collect"
		 */ 
		public function removeAll ( collect:Array ):void {
			
			var func:Function = function(element:*, index:int, arr:Array):Boolean { 
				return collect.indexOf(element) == -1;
			}

			this._data = this._data.filter(func);
		}
		/*
		 *  keep the same elements 
		 */ 
		public function retainAll ( collect:Array ):void {
			var func:Function = function(element:*, index:int, arr:Array):Boolean { 
				return collect.indexOf(element) != -1;
			}
			
			this._data = this._data.filter(func);
		}
		
		public function set (i:int, obj:Object):Object {
			var old:Object = get(i);
			this._data[i] = obj;
			return old;
		}
		
		public function size():int {
			return this._data.length;
		}
		
		public function isEmpty():Boolean {
			return this.size() < 1;
		}
		
		public function toArray():Array {
			return this._data;
		}
		
		public function toString():String {
			
			return "[ ArrayList >" + this._data + "]"
		}
	}
	
}