package org.pdfbox.utils 
{
	/**
	 * ...
	 * @author walktree
	 */
	public interface Map
	{
		
		function size():uint
		
		function put(key:Object, value:Object):Object
		
		function get(key:Object):Object
		
		function remove(key:Object):Object
		
		function isEmpty():Boolean
		
	}

}