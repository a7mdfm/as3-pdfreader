package org.pdfbox.pdmodel.common
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSBoolean;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSFloat;
	import org.pdfbox.cos.COSInteger;
	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSString;
	import org.pdfbox.utils.HashMap;
	import org.pdfbox.utils.Map;



	/**
	 * This is a Map that will automatically sync the contents to a COSDictionary.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.10 $
	 */
	public class COSDictionaryMap implements Map
	{
	    private var map:COSDictionary;
	    private var actuals:Map;

	    /**
	     * Constructor for this map.
	     *
	     * @param actualsMap The map with standard java objects as values.
	     * @param dicMap The map with COSBase objects as values.
	     */
	    public function COSDictionaryMap( actualsMap:Map, dicMap:COSDictionary )
	    {
			actuals = actualsMap;
			map = dicMap;
	    }


	    /**
	     * {@inheritDoc}
	     */
	    public function size():uint
	    {
			return map.size();
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function isEmpty():Boolean
	    {
			return size() == 0;
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function containsKey(key:Object):Boolean
	    {
			return map.keyList().contains( key );
	    }
		
		public function getKeySet():Array
		{
			return map.keyList();
		}

	    /**
	     * {@inheritDoc}
	     */
	    public function containsValue(value:Object):Boolean
	    {
			return actuals.containsValue( value );
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function get(key:Object):Object
	    {
			return actuals.get( key );
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function put(key:Object, value:Object):Object
	    {
			var object:COSObjectable = value as COSObjectable;

			map.setItem( COSName.getPDFName(key as String), object.getCOSObject() );
			return actuals.put( key, value );
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function remove(key:Object):Object
	    {
			map.removeItem( COSName.getPDFName( key as String ) );
			return actuals.remove( key );
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function clear():void
	    {
			map.clear();
			actuals.clear();
	    }

	    /**
	     * {@inheritDoc}
	     */
	    public function equals(o:Object):Boolean
	    {
			var retval:Boolean = false;
			if( o is COSDictionaryMap )
			{
				var other:COSDictionaryMap = o as COSDictionaryMap;
				retval = other.map.equals( this.map );
			}
			return retval;
	    }

	    /**
	     * {@inheritDoc}
	     *
	    public function toString():String
	    {
			return actuals.toString();
	    }*/

	    /**
	     * This will take a map&lt;java.lang.String,org.pdfbox.pdmodel.COSObjectable&gt;
	     * and convert it into a COSDictionary&lt;COSName,COSBase&gt;.
	     *
	     * @param someMap A map containing COSObjectables
	     *
	     * @return A proper COSDictionary
	     */
	    public static function convert( someMap:Map ):COSDictionary
	    {
			var keys:Array = someMap.getKeySet();
			var dic:COSDictionary = new COSDictionary();
			for (var i:uint = 0, len:uint = keys.length; i < len;i++)
			{
				var name:String =  keys[i] as String;
				var object:COSObjectable = someMap.get( keys ) as COSObjectable;
				dic.setItem( COSName.getPDFName( name ), object.getCOSObject() );
			}
			return dic;
	    }
	    
	    /**
	     * This will take a COS dictionary and convert it into COSDictionaryMap.  All cos
	     * objects will be converted to their primitive form.
	     * 
	     * @param map The COS mappings.
	     * @return A standard java map.
	     * @throws IOException If there is an error during the conversion.
	     */
	    public static function convertBasicTypesToMap( map:COSDictionary ) :COSDictionaryMap
	    {
			var retval:COSDictionaryMap = null;
			if( map != null )
			{
				var actualMap:HashMap = new HashMap();
				var keys:Array = map.keyList();
				for (var i:uint = 0, len:uint = keys.length; i < len;i++)
				{
					var key:COSName = keys[i] as COSName;
					var cosObj:COSBase = map.getDictionaryObject( key );
					var actualObject:Object = null;
					if( cosObj is COSString )
					{
						actualObject = (cosObj as COSString).getString();
					}
					else if( cosObj is COSInteger )
					{
						actualObject = (cosObj as COSInteger).intValue();
					}
					else if( cosObj is COSName )
					{
						actualObject = (cosObj as COSName).getName();
					}
					else if( cosObj is COSFloat )
					{
						actualObject = (cosObj as COSInteger).floatValue();
					}
					else if( cosObj is COSBoolean )
					{
						actualObject = (cosObj as COSBoolean).getValue() ? true : false;
					}
					else
					{
						throw new Error( "Error:unknown type of object to convert:" + cosObj );
					}
					actualMap.put( key.getName(), actualObject );
				}
				retval = new COSDictionaryMap( actualMap, map );
			}
			
			return retval;
	    }
	}
}