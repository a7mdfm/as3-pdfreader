package org.pdfbox.utils 
{
    
	/*
	 *  
	 * hashMap class
	 * 
	 * @author: walktree
	 * 
	 */ 
	import flash.utils.Dictionary;
	
	public class HashMap implements Map{
			
			private var _keys:Array;
			
			private var _props:Dictionary;
			
			public function HashMap()
			{
				this.clear();
			}
			public function clear():void
			{
				_props = new Dictionary(true);
				if ( _keys != null ) {
					_keys.length = 0;
				}else {
					_keys = new Array();
				}
			}
			
			public function containsKey(key:Object):Boolean
			{				
				return _props[key] != undefined;
			}
			
			public function containsValue(value:Object):Boolean
			{				
				var len:uint = this.size();
				if(len > 0){
					for(var i:uint = 0 ; i < len ; i++){
						if(_props[_keys[i]] == value) return true;
					}
				}
				return false;
			}
			
			/*
			 *  find element by key
			 *  
			 *  if key is Object then use special method "equals" 
			 * 
			 *  In ActionScript 3.0,  {1:1} != {1:1} 
			 */
			
			public function get(key:Object):Object
			{
				if (key == null) {
					return null;
				}
				if( key is String || key is Number || key is Boolean ){
					return _props[key];
				}
				//when key is complex data,then try to use "equals"
				for (var i:int = 0, len:int = this.size(); i < len; i++) {
					var obj:Object = this._keys[i];
					if ( key == obj || (key.equals && key.equals(obj)) ) {
						return _props[obj];
					}
				}
				return null;
			}
			
			public function put(key:Object, value:Object):Object
			{
				var result:Object = null;
				if(this.containsKey(key)){
					result = this.get(key);
					_props[key] = value;
				}else{
					_props[key] = value;
					_keys.push(key);
				}
				return result;
			}
			public function remove(key:Object):Object
			{
				var result:Object = null;
				if(this.containsKey(key)){
						delete _props[key];
						var index:int = _keys.indexOf(key);
						if(index > -1){
								this._keys.splice(index,1);
						}
				}
				return result;
			}

			public function size():uint{
					return this._keys.length;
			}
			public function isEmpty():Boolean{
					return this.size() < 1;
			}
			
			public function getKeySet():Array
			{
				return _keys;
			}
			
			public function values():Array
			{
				var result:Array = new Array();
				var len:uint = this.size();
				if(len > 0){
						for(var i:uint = 0;i<len;i++){
								result.push(_props[_keys[i]]);
						}
				}
				return result;
			}
	}
	
}