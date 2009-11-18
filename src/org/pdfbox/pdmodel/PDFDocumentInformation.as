package org.pdfbox.pdmodel
{

	import org.pdfbox.cos.COSBase;
	import org.pdfbox.cos.COSDictionary;
	import org.pdfbox.cos.COSName;

	import org.pdfbox.pdmodel.common.COSObjectable;
	/**
	 * This is the document metadata.  Each getXXX method will return the entry if
	 * it exists or null if it does not exist.  If you pass in null for the setXXX
	 * method then it will clear the value.
	 *
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @version $Revision: 1.12 $
	 */
	public class PDFDocumentInformation implements COSObjectable
	{
		private static const TITLE:COSName = COSName.getPDFName( "Title" );
		private static const AUTHOR:COSName = COSName.getPDFName( "Author" );
		private static const SUBJECT:COSName = COSName.getPDFName( "Subject" );
		private static const KEYWORDS:COSName = COSName.getPDFName( "Keywords" );
		private static const CREATOR:COSName = COSName.getPDFName( "Creator" );
		private static const PRODUCER:COSName = COSName.getPDFName( "Producer" );
		private static const CREATION_DATE:COSName = COSName.getPDFName( "CreationDate" );
		private static const MODIFICATION_DATE:COSName = COSName.getPDFName( "ModDate" );
		private static const TRAPPED:COSName = COSName.getPDFName( "Trapped" );
		
		private var info:COSDictionary;

		
		/**
		 * Constructor.
		 */
		public function PDFDocumentInformation( dic:COSDictionary = null )
		{
			if ( dic ) {
				info = dic;
			}else {
				info = new COSDictionary();	
			}
		}

		/**
		 * This will get the underlying dictionary that this object wraps.
		 *
		 * @return The underlying info dictionary.
		 */
		public function getDictionary():COSDictionary
		{
			return info;
		}
		
		/**
		 * Convert this standard java object to a COS object.
		 *
		 * @return The cos object that matches this Java object.
		 */
		public function getCOSObject(): COSBase
		{
			return info;
		}

		/**
		 * This will get the title of the document.  This will return null if no title exists.
		 *
		 * @return The title of the document.
		 */
		public function getTitle():String
		{
			return info.getString( TITLE );
		}

		/**
		 * This will set the title of the document.
		 *
		 * @param title The new title for the document.
		 */
		public function setTitle( title:String ):void
		{
			info.setName( TITLE, title );
		}

		/**
		 * This will get the author of the document.  This will return null if no author exists.
		 *
		 * @return The author of the document.
		 */
		public function getAuthor():String
		{
			return info.getString( AUTHOR );
		}

		/**
		 * This will set the author of the document.
		 *
		 * @param author The new author for the document.
		 */
		public function setAuthor( author:String ):void
		{
			info.setName( AUTHOR, author );
		}

		/**
		 * This will get the subject of the document.  This will return null if no subject exists.
		 *
		 * @return The subject of the document.
		 */
		public function getSubject():String
		{
			return info.getString( SUBJECT );
		}

		/**
		 * This will set the subject of the document.
		 *
		 * @param subject The new subject for the document.
		 */
		public function setSubject( subject:String ):void
		{
			info.setName( SUBJECT, subject );
		}

		/**
		 * This will get the keywords of the document.  This will return null if no keywords exists.
		 *
		 * @return The keywords of the document.
		 */
		public function getKeywords():String
		{
			return info.getString( KEYWORDS );
		}

		/**
		 * This will set the keywords of the document.
		 *
		 * @param keywords The new keywords for the document.
		 */
		public function setKeywords( keywords:String ):void
		{
			info.setName( KEYWORDS, keywords );
		}

		/**
		 * This will get the creator of the document.  This will return null if no creator exists.
		 *
		 * @return The creator of the document.
		 */
		public function getCreator():String
		{
			return info.getString( CREATOR );
		}

		/**
		 * This will set the creator of the document.
		 *
		 * @param creator The new creator for the document.
		 */
		public function setCreator( creator:String ):void
		{
			info.setName( CREATOR, creator );
		}

		/**
		 * This will get the producer of the document.  This will return null if no producer exists.
		 *
		 * @return The producer of the document.
		 */
		public function getProducer():String
		{
			return info.getString( PRODUCER );
		}

		/**
		 * This will set the producer of the document.
		 *
		 * @param producer The new producer for the document.
		 */
		public function setProducer( producer:String ):void
		{
			info.setName( PRODUCER, producer );
		}

		/**
		 * This will get the creation date of the document.  This will return null if no creation date exists.
		 *
		 * @return The creation date of the document.
		 * 
		 * @throws IOException If there is an error creating the date.
		 */
		public function getCreationDate() :Date
		{			
			return info.getDate( CREATION_DATE );
		}

		/**
		 * This will set the creation date of the document.
		 *
		 * @param date The new creation date for the document.
		 */
		public function setCreationDate( date:Date ):void
		{
			info.setDate( CREATION_DATE, date );
		}

		/**
		 * This will get the modification date of the document.  This will return null if no modification date exists.
		 *
		 * @return The modification date of the document.
		 * 
		 * @throws IOException If there is an error creating the date.
		 */
		public function getModificationDate() :Date
		{
			return info.getDate( MODIFICATION_DATE );
		}

		/**
		 * This will set the modification date of the document.
		 *
		 * @param date The new modification date for the document.
		 */
		public function setModificationDate( date:Date ):void
		{
			info.setDate( MODIFICATION_DATE, date );
		}

		/**
		 * This will get the trapped value for the document.
		 * This will return null if one is not found.
		 *
		 * @return The trapped value for the document.
		 */
		public function getTrapped():String
		{
			return info.getNameAsString( TRAPPED );
		}
		
		/**
		 *  This will get the value of a custom metadata information field for the document.
		 *  This will return null if one is not found.
		 *
		 * @param fieldName Name of custom metadata field from pdf document.
		 * 
		 * @return String Value of metadata field
		 * 
		 * @author  Gerardo Ortiz
		 */
		public function getCustomMetadataValue( fieldName:String ):String
		{
			return info.getString( fieldName );
		}
		
		/**
		 * Set the custom metadata value.
		 * 
		 * @param fieldName The name of the custom metadata field.
		 * @param fieldValue The value to the custom metadata field.
		 */
		public function setCustomMetadataValue( fieldName:String, fieldValue:String ):void
		{
			info.setName( fieldName, fieldValue );
		}

		/**
		 * This will set the trapped of the document.  This will be
		 * 'True', 'False', or 'Unknown'.
		 *
		 * @param value The new trapped value for the document.
		 */
		public function setTrapped( value:String ):void
		{
			if( value != null && value != "True" && value != "False"  && value != "Unknown" )
			{
				throw( "Valid values for trapped are " +"'True', 'False', or 'Unknown'" );
			}

			info.setName( TRAPPED, value );
		}
		
		public function toString():String
		{
			return "[ PDF INFORMATION >>" + 
			"Author:"+this.getAuthor() + ", Title:"+this.getTitle() + ", Creator:" + this.getCreator()+ ",Producer:"+ this.getProducer() +" ]";
		}
	}
}