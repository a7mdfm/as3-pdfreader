package org.pdfbox.cos
{
	import flash.utils.ByteArray;
	
	import org.pdfbox.utils.ArrayList;
	import org.pdfbox.utils.HashMap;
	import org.pdfbox.utils.ByteUtil;
	import org.pdfbox.utils.COSObjectKey;
	
	import org.pdfbox.pdfparser.PDFObjectStreamParser;

/**
 * This is the in-memory representation of the PDF document.  You need to call
 * close() on this object when you are done using it!!
 */
public class COSDocument extends COSBase
{
    private var version:Number;
    
    /**
     * added objects (actually preserving original sequence).
     */
    private var objects:ArrayList= new ArrayList();
    
    /**
     * a pool of objects read/referenced so far
     * used to resolve indirect object references.
     */
    private var objectPool:HashMap= new HashMap();

    /**
     * Document trailer dictionary.
     */
    private var trailer:COSDictionary;

    /**
     * This file will store the streams in order to conserve memory.
     */
    //private var scratchFile:RandomAccess= null;
    
    //private var tmpFile:File= null;
    
    private var headerString:String= "%PDF-1.4";

    /**
     * Constructor that will create a create a scratch file in the
     * following directory.
     *
     * @param scratchDir The directory to store a scratch file.
     *
     *  @throws IOException If there is an error creating the tmp file.
     */
    public function COSDocument( scratchDir:String = null )
    {
        //tmpFile = File.createTempFile( "pdfbox", "tmp", scratchDir );
        //scratchFile = new RandomAccessFile( tmpFile, "rw" );
    }

    /**
     * This will get the first dictionary object by type.
     *
     * @param type The type of the object.
     *
     * @return This will return an object with the specified type.
     */
   /* public function getObjectByType( type:String):COSObject{
        return getObjectByType( COSName.getPDFName( type ) );
    }*/
    
    /**
     * This will get the first dictionary object by type.
     *
     * @param type The type of the object.
     *
     * @return This will return an object with the specified type.
     */
    public function getObjectByType( type:COSName):COSObject {
		
        var retval:COSObject= null;        
		var len:int = objects.size();		
		for ( var i:int = 0; i < len && retval == null ; i++) 
        {
            var object:COSObject= objects.get(i) as COSObject;
            var realObject:COSBase= object.getObject();
            if( realObject is COSDictionary )
            {
                var dic:COSDictionary= realObject as COSDictionary;
                var objectType:COSName= dic.getItem( COSName.TYPE ) as COSName;
                if( objectType != null && objectType.equals( type ) )
                {
                    retval = object;
                }
            }
        }
        return retval;
    }
    
    /**
     * This will get all dictionary objects by type.
     *
     * @param type The type of the object.
     *
     * @return This will return an object with the specified type.
     */
    public function getObjectsByName( type:String):Array{
        return getObjectsByType( COSName.getPDFName( type ) );
    }
    
    /**
     * This will get a dictionary object by type.
     *
     * @param type The type of the object.
     *
     * @return This will return an object with the specified type.
     */
    public function getObjectsByType( type:COSName):Array {
		
        var retval:Array= new Array();
        var len:int = objects.size();		
		for ( var i:int = 0; i < len ; i++) 
        {
            var object:COSObject= objects.get(i) as COSObject;

            var realObject:COSBase= object.getObject();
            if( realObject is COSDictionary )
            {
                var dic:COSDictionary= realObject as COSDictionary;
                var objectType:COSName= dic.getItem( COSName.TYPE ) as COSName;
                if( objectType != null && objectType == type )
                {
                    retval.push( object );
                }
            }
        }
        return retval;
    }

    /**
     * This will print contents to stdout.
     */
    public function print():void{
        var len:int = objects.size();		
		for ( var i:int = 0; i < len ; i++) 
        {
            var object:COSObject= objects.get(i) as COSObject;
            //trace( object);
        }
    }

    /**
     * This will set the version of this PDF document.
     *
     * @param versionValue The version of the PDF document.
     */
    public function setVersion( versionValue:Number):void{
        version = versionValue;
    }

    /**
     * This will get the version of this PDF document.
     *
     * @return This documents version.
     */
    public function getVersion():Number{
        return version;
    }

    /**
     * This will tell if this is an encrypted document.
     *
     * @return true If this document is encrypted.
     */
    public function isEncrypted():Boolean{
        var encrypted:Boolean= false;
        if( trailer != null )
        {
            encrypted = trailer.getDictionaryObject( "Encrypt" ) != null;
        }
        return encrypted;
    }

    /**
     * This will get the encryption dictionary if the document is encrypted or null
     * if the document is not encrypted.
     *
     * @return The encryption dictionary.
     */
    public function getEncryptionDictionary():COSDictionary{
        return trailer.getDictionaryObject( COSName.getPDFName( "Encrypt" ) ) as COSDictionary;
    }

    /**
     * This will set the encryption dictionary, this should only be called when
     * encypting the document.
     *
     * @param encDictionary The encryption dictionary.
     */
    public function setEncryptionDictionary( encDictionary:COSDictionary):void{
        trailer.setItem( COSName.getPDFName( "Encrypt" ), encDictionary );
    }

    /**
     * This will get the document ID.
     *
     * @return The document id.
     */
    public function getDocumentID():COSArray{
        return getTrailer().getItem(COSName.getPDFName("ID")) as COSArray;
    }

    /**
     * This will set the document ID.
     *
     * @param id The document id.
     */
    public function setDocumentID( id:COSArray):void{
        getTrailer().setItem(COSName.getPDFName("ID"), id);
    }

    /**
     * This will create an object for this document.
     *
     * Create an indirect object out of the direct type and include in the document
     * for later lookup via document a map from direct object to indirect object
     * is maintained. this provides better support for manual PDF construction.
     *
     * @param base the base object to wrap in an indirect object.
     *
     * @return The pdf object that wraps the base, or creates a new one.
     */
    /**
    public COSObject createObject( COSBase base )
    {
        COSObject obj = (COSObject)objectMap.get(base);
        if (obj == null)
        {
            obj = new COSObject( base );
            obj.addTo(this);
        }
        return obj;
    }**/

    /**
     * This will get the document catalog.
     *
     * Maybe this should move to an object at PDFEdit level
     *
     * @return catalog is the root of all document activities
     *
     * @throws IOException If no catalog can be found.
     */
    public function getCatalog():COSObject
    {
        var catalog:COSObject= getObjectByType( COSName.CATALOG );
        if( catalog == null )
        {
            throw( "Catalog cannot be found" );
        }
        return catalog;
    }

    /**
     * This will get a list of all available objects.
     *
     * @return A list of all objects.
     */
    public function getObjects():ArrayList{
        return objects;
    }

    /**
     * This will get the document trailer.
     *
     * @return the document trailer dict
     */
    public function getTrailer():COSDictionary{
        return trailer;
    }

    /**
     * // MIT added, maybe this should not be supported as trailer is a persistence construct.
     * This will set the document trailer.
     *
     * @param newTrailer the document trailer dictionary
     */
    public function setTrailer(newTrailer:COSDictionary):void {		
        trailer = newTrailer;
    }

    /**
     * visitor pattern double dispatch method.
     *
     * @param visitor The object to notify when visiting this object.
     * @return any object, depending on the visitor implementation, or null
     * @throws COSVisitorException If an error occurs while visiting this object.
     */
    override public function accept(visitor:ICOSVisitor):Object
    {
        return visitor.visitFromDocument( this );
    }

    /**
     * This will close all storage and delete the tmp files.
     *
     *  @throws IOException If there is an error close resources.
     */
    public function close():void
    {
       //
    }

    /**
     * The sole purpose of this is to inform a client of PDFBox that they
     * did not close the document.
     */
    protected function finalize():void{
       //
    }
    /**
     * @return Returns the headerString.
     */
    public function getHeaderString():String{
        return headerString;
    }
    /**
     * @param header The headerString to set.
     */
    public function setHeaderString(header:String):void{
        headerString = header;
    }
    
    /**
     * This method will search the list of objects for types of ObjStm.  If it finds
     * them then it will parse out all of the objects from the stream that is contains.
     * 
     * @throws IOException If there is an error parsing the stream.
     */
    public function dereferenceObjectStreams():void
    {
        var objStm:Array = getObjectsByName( "ObjStm" );
		var len:int = objStm.length;
		
        for ( var i:int = 0; i < len; i++)		
        {
            var objStream:COSObject= objStm[i] as COSObject;
            var stream:COSStream = objStream.getObject() as COSStream;
			
            var parser:PDFObjectStreamParser = new PDFObjectStreamParser( stream, this );
            parser.parse();
            var compressedObjects:Array = parser.getObjects();
            
			for ( var k:int = 0; k < compressedObjects.length;k++)
            {
                var next:COSObject= compressedObjects[i] as COSObject;
                var key:COSObjectKey= new COSObjectKey( next.getObjectNumber().intValue(),next.getObjectNumber().intValue() );
                var obj:COSObject= getObjectFromPool( key );
                obj.setObject( next.getObject() );
            }
			//*/
        }
    }
    
    /**
     * This will add an object to this document.
     * the method checks if obj is already present as there may be cyclic dependencies
     *
     * @param obj The object to add to the document.
     * @return The object that was actually added to this document, if an object reference already 
     * existed then that will be returned.
     * 
     * @throws IOException If there is an error adding the object.
     */
    public function addObject(obj:COSObject):COSObject
    {
        var key:COSObjectKey= null;
        if( obj.getObjectNumber() != null )
        {
            key = new COSObjectKey( obj.getObjectNumber().longValue(),obj.getObjectNumber().longValue() );
			
        }
        var fromPool:COSObject= getObjectFromPool( key );
        fromPool.setObject( obj.getObject() );
        return fromPool;
    }
    
    /**
     * This will get an object from the pool.
     *
     * @param key The object key.
     *
     * @return The object in the pool or a new one if it has not been parsed yet.
     *
     * @throws IOException If there is an error getting the proxy object.
     */
    public function getObjectFromPool(key:COSObjectKey):COSObject
    {		
        var obj:COSObject= null;
        if( key != null )
        {			
            obj = objectPool.get(key) as COSObject;
        }
        if (obj == null)
        {
            // this was a forward reference, make "proxy" object
            obj = new COSObject(null);
            if( key != null )
            {
                obj.setObjectNumber( new COSInteger( key.getNumber() ) );
                obj.setGenerationNumber( new COSInteger( key.getGeneration() ) );
                objectPool.put(key, obj);
            }
            objects.add( obj );            
        }
        
        return obj;
    }
}
}