package org.pdfbox.pdfparser 
{
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class PDFXref 
	{
		
		private var _count:Number;
		private var _start:Number;

		/**
		 * constructor.
		 *
		 * @param startValue The start attribute.
		 * @param countValue The count attribute.
		 */
		public function PDFXref( startValue:Number, countValue:Number )
		{
			this.start = startValue;
			this.count = countValue;
		}

		/**
		 * This will get the count attribute.
		 *
		 * @return The count.
		 */
		public function get count():Number
		{
			return _count;
		}

		/**
		 * This will get the start attribute.
		 *
		 * @return The start.
		 */
		public function get start():Number
		{
			return _start;
		}

		/**
		 * This will set the count attribute.
		 *
		 * @param newCount The new count.
		 */
		public function set count(newCount:Number):void
		{
			_count = newCount;
		}

		/**
		 * This will set the start attribute.
		 *
		 * @param newStart The new start attribute.
		 */
		public function set start(newStart:Number):void
		{
			_start = newStart;
		}
		
	}
	
}