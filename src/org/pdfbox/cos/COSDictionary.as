package org.pdfbox.cos
{
	import org.pdfbox.utils.ArrayList;
	import org.pdfbox.utils.ByteUtil;
	import org.pdfbox.utils.HashMap;
	
	import org.pdfbox.utils.DateUtil;

	import org.pdfbox.pdmodel.common.COSObjectable;

/**
 * This class represents a dictionary where name/value pairs reside.
 */
public class COSDictionary extends COSBase
{
    private static var PATH_SEPARATOR:String= "/";
    
    /**
     * These are all of the items in the dictionary.
     */
    public var items:HashMap= new HashMap();

    /**
     * Used to store original sequence of keys, for testing.
     */
    public var keys:ArrayList= new ArrayList();


    /**
     * Copy Constructor.  This will make a shallow copy of this dictionary.
     *
     * @param dict The dictionary to copy.
     */
    public function COSDictionary( dict:COSDictionary = null )
    {
		if(dict){
			items = dict.items;
			keys = dict.keys;
		}
    }
    
    /**
     * @see java.util.Map#containsValue(java.lang.Object)
     * 
     * @param value The value to find in the map.
     * 
     * @return true if the map contains this value.
     */
    public function containsValue( value:Object):Boolean{
        var contains:Boolean= items.containsValue( value );
        if( !contains && value is COSObject )
        {
            contains = items.containsValue( COSObject(value).getObject());
        }
        return contains;
    }
    
    /**
     * Search in the map for the value that matches the parameter
     * and return the first key that maps to that value.
     * 
     * @param value The value to search for in the map.
     * @return The key for the value in the map or null if it does not exist.
     */
    public function getKeyForValue( value:Object):COSName{
        var key:COSName = null;
		
		var _keys:Array = items.getKeySet();
		
		for ( var i:int = 0, len:int = _keys.length; i < len; i++) {
			var s:Object =_keys[i];
			var nextValue:Object = items.get( s );
			if ( (nextValue != null && nextValue == value) || ( nextValue is COSObject && COSObject(nextValue).getObject() == value )) {
				key = COSName(s);				
			}
		}
		
        return key;
    }

    /**
     * This will return the number of elements in this dictionary.
     *
     * @return The number of elements in the dictionary.
     */
    public function size():int{
        return keys.size();
    }

    /**
     * This will clear all items in the map.
     */
    public function clear():void{
        items.clear();
        keys.clear();
    }    
    /**
     * This is a special case of getDictionaryObject that takes multiple keys, it will handle
     * the situation where multiple keys could get the same value, ie if either CS or ColorSpace
     * is used to get the colorspace.
     * This will get an object from this dictionary.  If the object is a reference then it will
     * dereference it and get it from the document.  If the object is COSNull then
     * null will be returned.  
     *
     * @param firstKey The first key to try.
     * @param secondKey The second key to try.
     *
     * @return The object that matches the key.
     */
    public function getDictionaryObject( firstKey:Object, secondKey:String = null):COSBase 
	{
		var _key:COSName;
		if (firstKey is String) {
			_key = COSName.getPDFName( String(firstKey) );
		}else if (firstKey is COSName ) {
			_key = firstKey as COSName;
		}		
        var retval:COSBase = $getDictionaryObject( _key );
		
		if (secondKey == null) {
			return retval;
		}
        if( retval == null )
        {
            retval = $getDictionaryObject( COSName.getPDFName( secondKey ) );
        }
        return retval;
    }
    
    /**
     * This is a special case of getDictionaryObject that takes multiple keys, it will handle
     * the situation where multiple keys could get the same value, ie if either CS or ColorSpace
     * is used to get the colorspace.
     * This will get an object from this dictionary.  If the object is a reference then it will
     * dereference it and get it from the document.  If the object is COSNull then
     * null will be returned.  
     *
     * @param keyList The list of keys to find a value.
     *
     * @return The object that matches the key.
     */
    public function getDictionaryObjectFromArray( keyList:Array):COSBase{
        var retval:COSBase= null;
        for( var i:int=0; i<keyList.length && retval == null; i++ )
        {
            retval = getDictionaryObject( COSName.getPDFName( keyList[i] ) ); 
        }
        return retval;
    }

    /**
     * This will get an object from this dictionary.  If the object is a reference then it will
     * dereference it and get it from the document.  If the object is COSNull then
     * null will be returned.
     *
     * @param key The key to the object that we are getting.
     *
     * @return The object that matches the key.
     */
    private function $getDictionaryObject( key:COSName):COSBase{
        var retval:COSBase = COSBase(items.get( key ));
		
        if( retval is COSObject )
        {
            retval = COSObject(retval).getObject();
        }
        if( retval is COSNull )
        {
            retval = null;
        }
        return retval;
    }

    /**
     * This will set an item in the dictionary.  If value is null then the result
     * will be the same as removeItem( key ).
     *
     * @param key The key to the dictionary object.
     * @param value The value to the dictionary object.
     */
    private function $setItem( key:COSName, value:COSBase):void{
        if( value == null )
        {
            removeItem( key );
        }
        else
        {
            if (!items.containsKey(key))
            {
                // insert only if not already there
                keys.add(key);
            }
            items.put( key, value );
        }
    }

    /**
     * This will set an item in the dictionary.  If value is null then the result
     * will be the same as removeItem( key ).
     *
     * @param key The key to the dictionary object.
     * @param value The value to the dictionary object.
     */
    public function setItem( key:Object, value:Object ):void {
		var _key:COSName;
		
		if ( key is String) {
			_key = COSName.getPDFName( String(key) );
		}else if ( key is COSName ) {
			_key = key as COSName;
		}
		
        var base:COSBase = null;
		
		if ( value is Boolean ) {
			base = COSBoolean.getBoolean( Boolean(value) );
		}else if ( value is COSObjectable) {
            base = (value as COSObjectable).getCOSObject();
        }else if ( value is String ) {
			base = COSName.getPDFName( String(value) );
		}else if ( value is int ) {
			base = new COSInteger(int(value));
		}else if ( value is Number ) {
			base = new COSFloat(Number(value));
		}
        $setItem( _key, base );
    }
	
	public function setName( key:Object, value:String ):void
    {
        var _key:COSName;
		if ( key is String) {
			_key = COSName.getPDFName( String(key) );
		}else if ( key is COSName) {
			_key = key as COSName;
		}
		
		var name:COSName = null;
        if( value != null )
        {
            name = COSName.getPDFName( value );
        }
        setItem( _key, name );
    }
	
	//TODO
    public function setDate( key:COSName, date:Date):void{
        setItem( key, date.toString() );
    }
    
    /**
     * Set the value of a date entry in the dictionary.
     * 
     * @param embedded The embedded dictionary.
     * @param key The key to the date value.
     * @param date The date value.
     */
    /*public function setEmbeddedDate( embedded:String, key:String, date:Date):void{
        setEmbeddedDate( embedded, COSName.getPDFName( key ), date );
    }*/

    public function setEmbeddedDate( embedded:String, key:Object, date:Date):void{
        var dic:COSDictionary = COSDictionary(getDictionaryObject( embedded ));
		
		var _key:COSName;
		
		if ( key is String) {
			_key = COSName.getPDFName( String(key) );
		}else if ( key is COSName) {
			_key = key as COSName;
		}
		
        if( dic == null && date != null )
        {
            dic = new COSDictionary();
            setItem( embedded, dic );
        }
        if( dic != null )
        {
            dic.setDate( _key, date );
        }
    }
    
    /**
     * This is a convenience method that will convert the value to a COSString
     * object.  If it is null then the object will be removed.
     *
     * @param embedded The embedded dictionary to set the item in.
     * @param key The key to the object,
     * @param value The string value for the name.
     */
   /* public function setEmbeddedString( embedded:String, key:String, value:String):void{
        setEmbeddedString( embedded, COSName.getPDFName( key ), value );
    }*/

    public function setEmbeddedString( embedded:String, key:Object, value:String):void{
        var dic:COSDictionary= COSDictionary(getDictionaryObject( embedded ));
        if( dic == null && value != null )
        {
            dic = new COSDictionary();
            setItem( embedded, dic );
        }
        if( dic != null )
        {
            dic.setItem( key, value );
        }
    }
        
    /**
     * This is a convenience method that will convert the value to a COSInteger
     * object.  
     *
     * @param embeddedDictionary The embedded dictionary.
     * @param key The key to the object,
     * @param value The int value for the name.
     */
    /*public function setEmbeddedInt( embeddedDictionary:String, key:String, value:int):void{
        setEmbeddedInt( embeddedDictionary, COSName.getPDFName( key ), value );
    }*/

    /**
     * This is a convenience method that will convert the value to a COSInteger
     * object.
     *
     * @param embeddedDictionary The embedded dictionary.
     * @param key The key to the object,
     * @param value The int value for the name.
     */
    public function setEmbeddedInt( embeddedDictionary:String, key:Object, value:int):void{
        var embedded:COSDictionary= COSDictionary(getDictionaryObject( embeddedDictionary ));
        if( embedded == null )
        {
            embedded = new COSDictionary();
            setItem( embeddedDictionary, embedded );
        }
        embedded.setItem( key, value );
    }
    
    /**
     * This is a convenience method that will convert the value to a COSFloat
     * object.
     *
     * @param key The key to the object,
     * @param value The int value for the name.
     */
    public function setFloat( key:Object, value:Number):void{
        var fltVal:COSFloat= new COSFloat( value );
        setItem( key, fltVal );
    }

    /**
     * This is a convenience method that will get the dictionary object that
     * is expected to be a name and convert it to a string.  Null is returned
     * if the entry does not exist in the dictionary.
     *
     * @param key The key to the item in the dictionary.
     * @return The name converted to a string.
     */
    public function getNameAsString( key:Object,defaultValue:String = null):String {
		
		var _key:COSName;
		if ( key is String ) {
			_key = COSName.getPDFName( String(key) );
		} else if ( key is COSName ) {
			_key = key as COSName;
		}
		
        var retval:String= null;
        var name:COSName= COSName(getDictionaryObject( _key ));
        if( name != null )
        {
            retval = name.getName();
        }
		if (retval == null) {
			retval = defaultValue;
		}
        return retval;
    }

    /**
     * This is a convenience method that will get the dictionary object that
     * is expected to be a name and convert it to a string.  Null is returned
     * if the entry does not exist in the dictionary.
     *
     * @param key The key to the item in the dictionary.
     * @return The name converted to a string.
     */
    public function getString( key:Object,defaultValue:String = null):String {
		var _key:COSName;
		if ( key is String ) {
			_key = COSName.getPDFName( String(key) );
		} else if ( key is COSName ) {
			_key = key as COSName;
		}
		
        var retval:String= null;
        var name:COSString= COSString(getDictionaryObject( _key ));
        if( name != null )
        {
            retval = name.getString();
        }
		if( retval == null )
        {
            retval = defaultValue;
        }
        return retval;
    }
    
    /**
     * This is a convenience method that will get the dictionary object that
     * is expected to be a name and convert it to a string.  Null is returned
     * if the entry does not exist in the dictionary.
     *
     * @param embedded The embedded dictionary.
     * @param key The key to the item in the dictionary.
     * @param defaultValue The default value to return.
     * @return The name converted to a string.
     */
    public function getEmbeddedString( embedded:String, key:Object, defaultValue:String = null):String {
		
		var _key:COSName;
		if ( key is String ) {
			_key = COSName.getPDFName( String(key) );
		} else if ( key is COSName ) {
			_key = key as COSName;
		}
		
        var retval:String= defaultValue;
        var dic:COSDictionary= COSDictionary(getDictionaryObject( embedded ));
        if( dic != null )
        {
            retval = dic.getString( key, defaultValue );
        }
        return retval;
    }
    
    /**
     * This is a convenience method that will get the dictionary object that
     * is expected to be a date.  Null is returned
     * if the entry does not exist in the dictionary.
     *
     * @param key The key to the item in the dictionary.
     * @param defaultValue The default value to return.
     * @return The name converted to a string.
     * @throws IOException If there is an error converting to a date.
     */
    public function getDate( key:Object, defaultValue:Date = null):Date
    {
		var _key:COSName;
		if ( key is String ) {
			_key = COSName.getPDFName( String(key) );
		} else if ( key is COSName ) {
			_key = key as COSName;
		}
		
		var date:COSString = getDictionaryObject( _key ) as COSString;
        var retval:Date = DateUtil.formatToDate(date.getString());
		//retval.setMilliseconds( Date.parse( date.getString() ) );
        if( retval == null )
        {
            retval = defaultValue;
        }
        return retval;
    }
    
    /**
     * This is a convenience method that will get the dictionary object that
     * is expected to be a date.  Null is returned
     * if the entry does not exist in the dictionary.
     *
     * @param embedded The embedded dictionary to get.
     * @param key The key to the item in the dictionary.
     * @param defaultValue The default value to return.
     * @return The name converted to a string.
     * @throws IOException If there is an error converting to a date.
     */
    public function getEmbeddedDate( embedded:String, key:Object, defaultValue:Date = null):Date
    {
		var _key:COSName;
		if ( key is String ) {
			_key = COSName.getPDFName( String(key) );
		} else if ( key is COSName ) {
			_key = key as COSName;
		}
		
        var retval:Date= defaultValue;
        var eDic:COSDictionary= COSDictionary(getDictionaryObject( embedded ));
        if( eDic != null )
        {
            retval = eDic.getDate( _key, defaultValue );
        }
        return retval;
    }

    /**
     * This is a convenience method that will get the dictionary object that
     * is expected to be a COSBoolean and convert it to a primitive boolean.
     *
     * @param key The key to the item in the dictionary.
     * @param defaultValue The value returned if the entry is null.
     *
     * @return The entry converted to a boolean.
     */
    public function getBoolean( key:Object, defaultValue:Boolean = false):Boolean {
		
		var _key:COSName;
		if ( key is String ) {
			_key = COSName.getPDFName( String(key) );
		} else if ( key is COSName ) {
			_key = key as COSName;
		}
        var retval:Boolean= defaultValue;
        var bool:COSBoolean= COSBoolean(getDictionaryObject( _key ));
        if( bool != null )
        {
            retval = bool.getValue();
        }
        return retval;
    }    
    
    /**
     * Get an integer from an embedded dictionary.  Useful for 1-1 mappings.
     * 
     * @param embeddedDictionary The name of the embedded dictionary.
     * @param key The key in the embedded dictionary.
     * @param defaultValue The value if there is no embedded dictionary or it does not contain the key.
     * 
     * @return The value of the embedded integer.
     */
    public function getEmbeddedInt( embeddedDictionary:String, key:Object, defaultValue:int = -1):int {
		var _key:COSName;
		if ( key is String ) {
			_key = COSName.getPDFName( String(key) );
		} else if ( key is COSName ) {
			_key = key as COSName;
		}
        var retval:int= defaultValue;
        var embedded:COSDictionary= COSDictionary(getDictionaryObject( embeddedDictionary ));
        if( embedded != null )
        {
            retval = embedded.getInt( _key, defaultValue );
        }
        return retval;
    }    
    
    public function getInt( key:Object, defaultValue:int = -1 ):int {
	
		var keyList:Array;
		
		if ( key is String) {
			keyList = [String(key)];
		}else if ( key is COSName ) {
			keyList = [(key as COSName).getName()];
			
		}else if ( key is Array) {
			keyList = key as Array;
		}
        var retval:int= defaultValue;
        var obj:COSNumber= this.getDictionaryObjectFromArray( keyList ) as COSNumber;
        if( obj != null )
        {
            retval = obj.intValue();
        }
        return retval;
    }
	/*
    public function getLong( key:String):Number{
        return getLong( COSName.getPDFName( key ) );
    }

   
    public function getLong( key:COSName):Number{
        return getLong( key, -1L);
    }
    
    
    public function getLong( keyList:Array, defaultValue:Number):Number{
        var retval:Number= defaultValue;
        var obj:COSNumber= COSNumber(getDictionaryObject( keyList ));
        if( obj != null )
        {
            retval = obj.longValue();
        }
        return retval;
    }
 
    public function getLong( key:String, defaultValue:Number):Number{
        return getLong( new String []{ key }, defaultValue );
    }

    public function getLong( key:COSName, defaultValue:Number):Number{
        return getLong(key.getName(), defaultValue );
    }

    public function getFloat( key:COSName, defaultValue:Number = -1):Number{
        var retval:Number= defaultValue;
        var obj:COSNumber= COSNumber(getDictionaryObject( key ));
        if( obj != null )
        {
            retval = obj.floatValue();
        }
        return retval;
    }

    */
    public function removeItem( key:COSName):void{
        keys.remove( key );
        items.remove( key );
    }

    /**
     * This will do a lookup into the dictionary.
     *
     * @param key The key to the object.
     *
     * @return The item that matches the key.
     */
    public function getItem( key:COSName):COSBase{
        return items.get( key ) as COSBase;
    }

    /**
     * This will get the keys for all objects in the dictionary in the sequence that
     * they were added.
     *
     * @return a list of the keys in the sequence of insertion
     *
     */
    public function keyList():Array{
        return keys.toArray();
    }

    /**
     * This will get all of the values for the dictionary.
     *
     * @return All the values for the dictionary.
     */
    public function getValues():Array{
        return items.values();
    }
	
	public function toString():String {
		
		return "[ COSDictionary : " + this.keyList() + "]";
	}

    /**
     * visitor pattern double dispatch method.
     *
     * @param visitor The object to notify when visiting this object.
     * @return The object that the visitor returns.
     *
     * @throws COSVisitorException If there is an error visiting this object.
     */
    override public function accept(visitor:ICOSVisitor):Object
    {
        return visitor.visitFromDictionary(this);
    }

    public function addAll( dic:COSDictionary ):void{
        //TODO
		//trace("addAll:" + dic);
		var dicKeys:Array = dic.keyList();
		for ( var i:int = 0, len:int = dicKeys.length; i < len;i++)
        {
            var key:COSName= dicKeys[i] as COSName;
            var value:COSBase = dic.getItem( key );
            setItem( key, value );
        }
    }
    //TODO
    /*
     * This will add all of the dictionarys keys/values to this dictionary, but only
     * if they don't already exist.  If a key already exists in this dictionary then 
     * nothing is changed.
     *
     * @param dic The dic to get the keys from.
     *
    public function mergeInto( dic:COSDictionary):void{
        var dicKeys:Iterator= dic.keyList().iterator();
        while( dicKeys.hasNext() )
        {
            var key:COSName= COSName(dicKeys.next());
            var value:COSBase= dic.getItem( key );
            if( getItem( key ) == null )
            {
                setItem( key, value );
            }
        }
    }
    
    /**
     * Nice method, gives you every object you want
     * Arrays works properly too. Try "P/Annots/[k]/Rect"
     * where k means the index of the Annotsarray.
     *
     * @param objPath the relative path to the object.
     * @return the object
     *
    public function getObjectFromPath(objPath:String):COSBase{
        var retval:COSBase= null;
        var path:Array= objPath.split(PATH_SEPARATOR);
        retval = this;

        for (var i:int= 0; i < path.length; i++)
        {
            if(retval instanceof COSArray)
            {
                var idx:int= new Integer(path[i].replaceAll("\\[","").replaceAll("\\]","")).intValue();
                retval = (COSArray(retval)).getObject(idx);
            }
            else if (retval instanceof COSDictionary)
            {
                retval = (COSDictionary(retval)).getDictionaryObject( path[i] );
            }
        }
        return retval;
    }
	*/
	}
}