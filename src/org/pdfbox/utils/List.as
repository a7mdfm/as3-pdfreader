package org.pdfbox.utils {

	public interface List
	{	
		function add ( obj:Object ):Boolean;
		
		function get(index:int):Object;		
		
		function removeAt(index:int):Object;
		
		function remove(element:*):Boolean;	
		
		function contains(element:Object):Boolean;

		function size():int;
		
		function clear():void;
		
		function indexOf( o:Object ):int;
		
		function isEmpty():Boolean;

		function toArray():Array;
	}
}