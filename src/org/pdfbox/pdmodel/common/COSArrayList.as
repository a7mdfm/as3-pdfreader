package org.pdfbox.pdmodel.common
{
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSArray;
	import org.pdfbox.cos.COSString;
	import org.pdfbox.cos.COSDictionary;
	
	import org.pdfbox.utils.ArrayList;
	import org.pdfbox.utils.List;
	
	public class COSArrayList implements List
	{
		private var array:COSArray;
		private var actual:ArrayList;
		
		private var parentDict:COSDictionary;
		private var dictKey:String;
	
		public function COSArrayList( actualObject:Object = null, item:COSBase = null, dictionary:COSDictionary = null, dictionaryKey:String = null)
		{
			array = new COSArray();			
			actual = new ArrayList();
			
			if(item){
				array.add( item );
			}
			if (actualObject) {
				actual.add( actualObject );
			}
			
			parentDict = dictionary;
			dictKey = dictionaryKey;
		}
		
		public function setData( actualList:List, cosArray:COSArray ):void
		{
			actual = actualList as ArrayList;
			array = cosArray;
		}
		
		public static function convertStringListToCOSNameCOSArray(  strings:List ):COSArray
		{
			var retval:COSArray = new COSArray();
			for( var i:int=0; i<strings.size(); i++ )
			{
				var next:Object = strings.get( i );
				if( next is COSName )
				{
					retval.add( next as COSName );
				}
				else
				{
					retval.add( COSName.getPDFName( String(next) ) );
				}
			}
			return retval;
		}
		
		public static function convertCOSNameCOSArrayToList( nameArray:COSArray ):COSArrayList
		{
			var retval:COSArrayList = null;
			if( nameArray != null )
			{
				var names:ArrayList = new ArrayList();
				for( var i:int=0; i<nameArray.size(); i++ )
				{
					names.add( (nameArray.getObject( i ) as COSName).getName() );
				}
				retval = new COSArrayList();
				retval.setData(names, nameArray );
			}
			return retval;
		}
		
		public static function convertIntegerCOSArrayToList():COSArrayList
		{
			
		}
		public static function converterToCOSArray( cosObjectableList:List ):COSArrayList
		{
			var array:COSArray;
			if( cosObjectableList != null )
			{
				if( cosObjectableList is COSArrayList )
				{
					//if it is already a COSArrayList then we don't want to recreate the array, we want to reuse it.
					array = (cosObjectableList as COSArrayList).getCosArray();
				}
				else
				{
					array = new COSArray();
					Iterator iter = cosObjectableList.iterator();
					while( iter.hasNext() )
					{
						Object next = iter.next();
						if( next instanceof String )
						{
							array.add( new COSString( (String)next ) );
						}
						else if( next instanceof Integer || next instanceof Long )
						{
							array.add( new COSInteger( ((Number)next).longValue() ) );
						}
						else if( next instanceof Float || next instanceof Double )
						{
							array.add( new COSFloat( ((Number)next).floatValue() ) );
						}
						else if( next instanceof COSObjectable )
						{
							COSObjectable object = (COSObjectable)next;
							array.add( object.getCOSObject() );
						}
						else if( next instanceof DualCOSObjectable )
						{
							DualCOSObjectable object = (DualCOSObjectable)next;
							array.add( object.getFirstCOSObject() );
							array.add( object.getSecondCOSObject() );
						}
						else if( next == null )
						{
							array.add( COSNull.NULL );
						}
						else
						{
							//
						}
					}
				}
			}
			return array;
		}
		public function size():int
		{
			return actual.size();
		}
		
		public function isEmpty():Boolean
		{
			return actual.isEmpty();
		}
		
		public function clear():void
		{
			return actual.clear();
		}

		public function contains( o:Object ):Boolean
		{
			return actual.contains(o);
		}
		public function toArray():Array
		{
			return actual.toArray();
		}
		public function add( o:Object ):Boolean
		{
			if( parentDict != null )
			{
				parentDict.setItem( dictKey, array );
				//clear the parent dict so it doesn't happen again, there might be
				//a usecase for keeping the parentDict around but not now.
				parentDict = null;
			}
			//string is a special case because we can't subclass to be COSObjectable
			if( o is String )
			{
				array.add( new COSString( String(o) ) );
			}
			else if( o is DualCOSObjectable )
			{
				var dual:DualCOSObjectable = o as DualCOSObjectable;
				array.add( dual.getFirstCOSObject() );
				array.add( dual.getSecondCOSObject() );
			}
			else
			{
				array.add( (o as COSObjectable).getCOSObject() );
			}
			return actual.add(o);
		}
		
		public function addAt( index:int,element:Object ):void
		{
			//when adding if there is a parentDict then change the item 
			//in the dictionary from a single item to an array.
			if( parentDict != null )
			{
				parentDict.setItem( dictKey, array );
				//clear the parent dict so it doesn't happen again, there might be
				//a usecase for keeping the parentDict around but not now.
				parentDict = null;
			}
			actual.add( element );
			if( element is String )
			{
				array.addAt(index, new COSString( String(element)) );
			}
			else if( element is DualCOSObjectable )
			{
				var dual:DualCOSObjectable = element as DualCOSObjectable;
				array.addAt( index*2, dual.getFirstCOSObject() );
				array.addAt( index*2+1, dual.getSecondCOSObject() );
			}
			else
			{
				array.addAt( index, (COSObjectable(element)).getCOSObject() );
			}
		}
		
		public function get( index:int ):Object
		{
			return actual.get( index );

		}

		public function remove(o:*):Boolean
		{
			var retval:Boolean = true;
			var index:int = actual.indexOf( o );
			if( index >= 0 )
			{
				actual.removeAt( index );
				array.removeAt( index );
			}
			else
			{
				retval = false;
			}
			return retval;
		}
		
		public function removeAt( index:int ):Object
		{
			if( array.size() > index && array.get( index ) is DualCOSObjectable )
			{
				//remove both objects
				array.removeAt( index );
				array.removeAt( index );
			}
			else
			{
				array.removeAt( index );
			}
			return actual.removeAt( index );
		}
		
		public function indexOf( o:Object ):int
		{
			return actual.indexOf( o );
		}
		
		public function getCosArray():COSArray 
		{
			return this.array;
		}
	}
}