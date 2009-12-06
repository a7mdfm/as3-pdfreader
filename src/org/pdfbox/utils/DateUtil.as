package org.pdfbox.utils 
{
	
	/**
	 * ...
	 * @author walktree
	 */
	public class DateUtil 
	{
		
		//public static const CURRENT_TIMEZONE:int = 8 * 60;
		
		// D:20081223203027+08'00'
		
		/*
		 *  format the time string to date and calculate the time on your timezone
		 */ 
		public static function formatToDate( value:String ):Date
		{
			var date:Date = new Date();
			
			var tmp:Array = value.split(":");
			var dateString:String = tmp[0];
			if (tmp.length > 0) {
				dateString = tmp[tmp.length - 1];
			}
			var offsetString:String;
			var sign:int = 1;
			var index:int = dateString.indexOf('+');
			if (index != -1) {	
				offsetString = dateString.substring(index+1);
				dateString = dateString.substring(0, index);
			}
			index = dateString.indexOf('-');
			if ( index != -1) {
				sign = -1;
				offsetString = dateString.substring(index+1);
				dateString = dateString.substring(0, index);
			}
			var arr:Array = offsetString.split("'");
			var offsetHour:Number = Number(arr[0]);
			var offsetMin:Number = Number(arr[1]);
			
			var offset:int = (offsetHour * 60 + offsetMin ) * sign;		
			var myTimeZone:int = date.getTimezoneOffset();
			
			offset = myTimeZone + offset;			
			
			date.setFullYear( Number(dateString.substr(0, 4)));
			date.setMonth( Number(dateString.substr(4, 2)) -1);
			date.setDate(Number(dateString.substr(6, 2)));
			date.setHours( Number(dateString.substr(8, 2)));
			date.setMinutes( Number(dateString.substr(10, 2)));
			date.setSeconds( Number(dateString.substr(12, 2)));
			
			var milSec:int = date.getMilliseconds() + offset * 60 * 1000;
			date.setMilliseconds(milSec);
			
			return date;
		}
		/*
		 *  $date	the Date Object
		 *  @format	the format: Y.M.D h:m:s
		 */ 
		
		public static function DateToString( date:Date, format:String = "Y.M.D h:m:s"):String 
		{
			if ( date == null ) {
				return '';
			}
			var year:Number = date.getFullYear();
			var month:Number = date.getMonth() + 1;
			var day:Number = date.getDate();
			
			var hour:Number = date.getHours();
			var min:Number = date.getMinutes();
			var s:Number = date.getSeconds();
			
			var result:String = format;
			result = result.replace(/Y/g, year);
			result = result.replace(/M/g, month);
			result = result.replace(/D/g, day);
			result = result.replace(/h/g, hour);
			result = result.replace(/m/g, min);
			result = result.replace(/s/g, s);
			
			return result;
		}
	}
	
}