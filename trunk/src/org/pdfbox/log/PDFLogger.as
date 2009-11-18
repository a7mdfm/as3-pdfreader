package org.pdfbox.log
{
	
	import org.pdfbox.PDFConstant;
	
	public class PDFLogger
	{
		
		public static var callBack:Function;
		/*
		 *  log function 
		 */
		public static function log ( o:Object ):void
		{
			if ( PDFConstant.DEBUG_ENABLED )
			{
				var s:String = "[ LOG ] " + o.toString();
				if ( callBack == null ){
					trace(s);
				}else {
					callBack(s);
				}
			}
		}
	}
}