package org.pdfbox.utils 
{
	
	/**
	 * ...
	 * @author walktree
	 */
	public class Stack extends ArrayList
	{
		
		public function Stack() 
		{
			super();
		}
		
		public function peek():Object
		{
			return _data[_data.length-1];
		}
		
		public function push(item:*):*
		{
			_data.push(item);
			return item;
		}
		
		public function pop():*{
			return _data.pop();
		}
		
	}
	
}