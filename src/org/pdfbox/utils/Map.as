package org.pdfbox.utils 
{
	/**
	 * ...
	 * @author walktree
	 */
	public interface Map
	{
		
		function clear():void
		
		function size():uint
		
		function put(key:Object, value:Object):Object
		
		function get(key:Object):Object
		
		function remove(key:Object):Object
		
		function isEmpty():Boolean
		
		function containsValue(o:Object):Boolean
		
		function equals(o:Object):Boolean
		
		function getKeySet():Array
		
	}

}