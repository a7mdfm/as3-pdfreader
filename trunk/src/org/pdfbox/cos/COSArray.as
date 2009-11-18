package org.pdfbox.cos
{

	import org.pdfbox.pdmodel.common.COSObjectable;
	
	import org.pdfbox.utils.ArrayList;

	/**
	 * An array of PDFBase objects as part of the PDF document.
	 *
	 */
	public class COSArray extends COSBase
	{
		private var objects:ArrayList = new ArrayList();

		/**
		 * Constructor.
		 */
		public function COSArray()
		{
			//default constructor
		}
		
		public function getArray():Array {
			return objects.toArray();
		}
		
		/**
		 * This will add an object to the array.
		 *
		 * @param object The object to add to the array.
		 */
		public function add( object:Object ):void
		{
			if (object is COSBase) {
				objects.add( object );
			}else if ( object is COSObjectable ){
				objects.add( COSObjectable(object).getCOSObject() );
			}
		}

		/**
		 * Add the specified object at the ith location and push the rest to the
		 * right.
		 *
		 * @param i The index to add at.
		 * @param object The object to add at that index.
		 */
		public function addAt( i:int, object:COSBase):void
		{
			objects.addAt( i, object );
		}

		/**
		 * This will remove all of the objects in the collection.
		 */
		public function clear():void
		{
			objects.clear();
		}

		/**
		 * This will remove all of the objects in the collection.
		 *
		 * @param objectsList The list of objects to remove from the collection.
		 */
		public function removeAll( objectsList:Array ):void
		{
			objects.removeAll( objectsList );
		}

		/**
		 * This will retain all of the objects in the collection.
		 *
		 * @param objectsList The list of objects to retain from the collection.
		 */
		public function retainAll( objectsList:Array ):void
		{
			objects.retainAll( objectsList );
		}

		/**
		 * This will add an object to the array.
		 *
		 * @param objectsList The object to add to the array.
		 */
		public function addAll( objectsList:Object,i:int = -1 ):void
		{
			if ( objectsList is COSArray) {
				
				//TODO
				objects.addAll( COSArray(objectsList).getArray() );
				
			}else if(objectsList is Array) {
				objects.addAll( objectsList as Array,i );
			}
		}

		/**
		 * This will set an object at a specific index.
		 *
		 * @param index zero based index into array.
		 * @param object The object to set.
		 */
		public function set( index:int, object:COSBase ):void
		{
			if ( object is COSBase) {
				objects.set( index, object );
			} else if (object is int) {
				objects.set( index, new COSInteger( int(object) ) );
			} else if (object is COSObjectable) {
				var base:COSBase = null;
				if( object != null )
				{
					base = object.getCOSObject();
				}
				objects.set( index, base );
			}
		}
		
		/**
		 * This will get an object from the array.  This will dereference the object.
		 * If the object is COSNull then null will be returned.
		 *
		 * @param index The index into the array to get the object.
		 *
		 * @return The object at the requested index.
		 */
		public function getObject( index:int ):COSBase
		{
			var obj:Object = objects.get( index );
			if( obj is COSObject )
			{
				obj = (obj as COSObject).getObject();
			}
			if( obj is COSNull )
			{
				obj = null;
			}
			return obj as COSBase;
		}

		/**
		 * This will get an object from the array.  This will NOT derefernce
		 * the COS object.
		 *
		 * @param index The index into the array to get the object.
		 *
		 * @return The object at the requested index.
		 */
		public function get( index:int ):COSBase
		{
			return objects.get( index ) as COSBase;
		}
		
		
		/**
		 * Get the value of the array as an integer, return the default if it does
		 * not exist.
		 * 
		 * @param index The value of the array.
		 * @param defaultValue The value to return if the value is null.
		 * @return The value at the index or the defaultValue.
		 */
		public function getInt( index:int, defaultValue:int = -1):int
		{
			var retval:int = defaultValue;
			if( index < size() )
			{
				var number: COSNumber = get( index ) as COSNumber;
				if( number != null )
				{
					retval = number.intValue();
				}
			}
			return retval;
		}
		
		/**
		 * Set the value in the array as an integer.
		 * 
		 * @param index The index into the array.
		 * @param value The value to set.
		 */
		public function setInt( index:int, value:int ):void
		{
			set( index, new COSInteger( value ) );
		}
		
		/**
		 * Set the value in the array as a name.
		 * @param index The index into the array.
		 * @param name The name to set in the array.
		 */
		public function setName( index:int, name:String ):void
		{
			set( index, COSName.getPDFName( name ) );
		}
		
		
		/**
		 * Get an entry in the array that is expected to be a COSName.
		 * @param index The index into the array.
		 * @param defaultValue The value to return if it is null.
		 * @return The value at the index or defaultValue if none is found.
		 */
		public function getName( index:int, defaultValue:String = null ):String
		{
			var retval:String = defaultValue;
			if( index < size() )
			{
				var name:COSName = get( index ) as COSName;
				if( name != null )
				{
					retval = name.getName();
				}
			}
			return retval;
		}
		
		/**
		 * Set the value in the array as a string.
		 * @param index The index into the array.
		 * @param string The string to set in the array.
		 */
		public function setString( index:int, string:String ):void
		{
			set( index, new COSString( string ) );
		}
				
		/**
		 * Get an entry in the array that is expected to be a COSName.
		 * @param index The index into the array.
		 * @param defaultValue The value to return if it is null.
		 * @return The value at the index or defaultValue if none is found.
		 */
		public function getString( index:int, defaultValue:String = null ):String
		{
			var retval:String = defaultValue;
			if( index < size() )
			{
				var string:COSString = get( index ) as COSString;
				if( string != null )
				{
					retval = string.getString();
				}
			}
			return retval;
		}

		/**
		 * This will get the size of this array.
		 *
		 * @return The number of elements in the array.
		 */
		public function size():int
		{
			return objects.size();
		}

		/**
		 * This will remove an element from the array.
		 *
		 * @param i The index of the object to remove.
		 *
		 * @return The object that was removed.
		 */
		public function removeAt( i:int ):COSBase
		{
			return objects.removeAt( i ) as COSBase;
		}

		/**
		 * This will remove an element from the array.
		 *
		 * @param o The object to remove.
		 *
		 * @return The object that was removed.
		 */
		public function remove( o:COSBase ):Boolean
		{
			return objects.remove( o );
		}

		/**
		 * {@inheritDoc}
		 */
		public function toString():String
		{
			return "[ COSArray > " + objects.toString() + "]";
		}

		/**
		 * Get access to the list.
		 *
		 * @return an iterator over the array elements
		 */
		//TODO
/*		public Iterator iterator()
		{
			return objects.iterator();
		}*/

		/**
		 * This will return the index of the entry or -1 if it is not found.
		 *
		 * @param object The object to search for.
		 * @return The index of the object or -1.
		 */
		public function indexOf( object:COSBase ):int
		{
			var retval:int = -1;
			for( var i:int=0; retval < 0&& i<size(); i++ )
			{
				var obj:Object = get(i);
				if( obj.equals && obj.equals( object ) )
				{
					retval = i;
					break;
				}
			}
			return retval;
		}
	
		
		/**
		 * This will add the object until the size of the array is at least 
		 * as large as the parameter.  If the array is already larger than the
		 * parameter then nothing is done.
		 * 
		 * @param size The desired size of the array.
		 * @param object The object to fill the array with.
		 */
		public function growToSize( size:int, object:COSBase = null):void
		{
			while( this.size() < size )
			{
				add( object );
			}
		}

		/**
		 * visitor pattern double dispatch method.
		 *
		 * @param visitor The object to notify when visiting this object.
		 * @return any object, depending on the visitor implementation, or null
		 * @throws COSVisitorException If an error occurs while visiting this object.
		 */
		override public function accept( visitor:ICOSVisitor ):Object
		{
			return visitor.visitFromArray(this);
		}
		
		/**
		 * This will take an COSArray of numbers and convert it to a float[].
		 * 
		 * @return This COSArray as an array of float numbers.
		 */
		public function toFloatArray():Array
		{
			var retval:Array = new Array();
			for( var i:int=0; i<size(); i++ )
			{
				retval[i] = (getObject( i ) as COSNumber).floatValue();
			}
			return retval;
		}
		
		/**
		 * Clear the current contents of the COSArray and set it with the float[].
		 * 
		 * @param value The new value of the float array.
		 */
		public function setFloatArray( value:Array ):void
		{
			this.clear();
			for( var i:int=0; i<value.length; i++ )
			{
				add( new COSFloat( value[i] ) );
			}
		}
	}

}