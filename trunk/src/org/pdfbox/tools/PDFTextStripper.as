package org.pdfbox.tools
{

	import flash.utils.ByteArray;
	
	import org.pdfbox.cos.COSDocument;
	import org.pdfbox.cos.COSStream;
	
	import org.pdfbox.utils.List;
	import org.pdfbox.utils.TextPosition;
	import org.pdfbox.utils.TextPositionComparator;

	import org.pdfbox.pdmodel.PDFDocument;
	import org.pdfbox.pdmodel.PDFPage;

	import org.pdfbox.pdmodel.common.PDFRectangle;
	import org.pdfbox.pdmodel.common.PDFStream;

	//import org.pdfbox.pdmodel.interactive.documentnavigation.outline.PDFOutlineItem;
	//import org.pdfbox.pdmodel.interactive.pagenavigation.PDThreadBead;


	/**
	 * This class will take a pdf document and strip out all of the text and ignore the
	 * formatting and such.
	 */
	public class PDFTextStripper extends PDFStreamEngine
	{   
		private var currentPageNo:int = 0;
		private var startPage:int = 1;
		private var endPage:int = Number.MAX_VALUE;
		//private var startBookmark:PDFOutlineItem = null;
		private var startBookmarkPageNumber:int = -1;
		//private var endBookmark:PDFOutlineItem = null;
		private var endBookmarkPageNumber:int = -1;
		private var document:PDFDocument;
		private var suppressDuplicateOverlappingText:Boolean = true;
		private var shouldSeparateByBeads:Boolean = true;
		private var sortByPosition:Boolean = false;
		//TODO
		private var pageArticles:Array = null;
		/**
		 * The charactersByArticle is used to extract text by article divisions.  For example
		 * a PDF that has two columns like a newspaper, we want to extract the first column and
		 * then the second column.  In this example the PDF would have 2 beads(or articles), one for
		 * each column.  The size of the charactersByArticle would be 5, because not all text on the 
		 * screen will fall into one of the articles.  The five divisions are shown below
		 * 
		 * Text before first article
		 * first article text
		 * text between first article and second article
		 * second article text
		 * text after second article
		 * 
		 * Most PDFs won't have any beads, so charactersByArticle will contain a single entry.
		 */
		protected var charactersByArticle:Array = new Array();
		
		private var characterListMapping:HashMap = new HashMap();
		
		private var lineSeparator:String = "\n";
		private var pageSeparator:String = "\n";
		private var wordSeparator:String = " ";
		
		/**
		 * The stream to write the output to.
		 */
		protected var output:ByteArray;
			
		/**
		 * Instantiate a new PDFTextStripper object.  Loading all of the operator mappings
		 * from the properties object that is passed in.
		 * 
		 * @param props The properties containing the mapping of operators to PDFOperator 
		 * classes.
		 * 
		 * @throws IOException If there is an error reading the properties.
		 */
		public function PDFTextStripper( props:Object = null )
		{
			super( props );
		}

		/**
		 * This will return the text of a document.  See writeText. <br />
		 * NOTE: The document must not be encrypted when coming into this method.
		 *
		 * @param doc The document to get the text from.
		 *
		 * @return The text of the PDF document.
		 *
		 * @throws IOException if the doc state is invalid or it is encrypted.
		 */
		public function getText( doc:PDFDocument ):String
		{
			var outputStream:ByteArray = new ByteArray();
			writeText( doc, outputStream );
			return outputStream.toString();
		}

		/**
		 * This will take a PDDocument and write the text of that document to the print writer.
		 *
		 * @param doc The document to get the data from.
		 * @param outputStream The location to put the text.
		 *
		 * @throws IOException If the doc is in an invalid state.
		 */
		public function writeText( doc:PDFDocument, outputStream:ByteArray ):void
		{
			resetEngine();

			currentPageNo = 0;
			document = doc;
			output = outputStream;
			startDocument(document);

			if( document.isEncrypted() )
			{
				// We are expecting non-encrypted documents here, but it is common
				// for users to pass in a document that is encrypted with an empty
				// password (such a document appears to not be encrypted by
				// someone viewing the document, thus the confusion).  We will
				// attempt to decrypt with the empty password to handle this case.
				//
				try
				{
					document.decrypt("");
				}
				catch ( e:Error )
				{
					throw("Error decrypting document, details: " + e);
				}            
			}

			processPages( document.getDocumentCatalog().getAllPages() );
			endDocument(document);
		}

		/**
		 * This will process all of the pages and the text that is in them.
		 *
		 * @param pages The pages object in the document.
		 *
		 * @throws IOException If there is an error parsing the text.
		 */
		protected function processPages( pages:Array ):void
		{
			/*if( startBookmark != null )
			{
				startBookmarkPageNumber = getPageNumber( startBookmark, pages );
			}
			
			if( endBookmark != null )
			{
				endBookmarkPageNumber = getPageNumber( endBookmark, pages );
			}
			
			if( startBookmarkPageNumber == -1 && startBookmark != null &&
				endBookmarkPageNumber == -1 && endBookmark != null &&
				startBookmark.getCOSObject() == endBookmark.getCOSObject() )
			{
				//this is a special case where both the start and end bookmark
				//are the same but point to nothing.  In this case
				//we will not extract any text.
				startBookmarkPageNumber = 0;
				endBookmarkPageNumber = 0;
			}*/
					
			for (var i:int = 0; i < pages.length; i++) {
				var page:PDFPage = pages[i] as PDFPage;
				var contentStream:PDFStream = page.getContents();
				if( contentStream != null )
				{
					var contents:COSStream = contentStream.getStream();
					processPage( page, contents );
				}
			}
		}
		
		/*private function getPageNumber( bookmark:PDFOutlineItem, allPages:List ):int
		{
			var pageNumber:int = -1;
			var page:PDFPage = bookmark.findDestinationPage( document );
			if( page != null )
			{
				pageNumber = allPages.indexOf( page )+1;//use one based indexing
			}
			return pageNumber;
		}*/
		
		/**
		 * This method is available for subclasses of this class.  It will be called before processing
		 * of the document start.
		 * 
		 * @param pdf The PDF document that is being processed.
		 * @throws IOException If an IO error occurs.
		 */
		protected function startDocument( pdf:PDFDocument ):void
		{
			// no default implementation, but available for subclasses    
		}
		
		/**
		 * This method is available for subclasses of this class.  It will be called after processing
		 * of the document finishes.
		 * 
		 * @param pdf The PDF document that is being processed.
		 * @throws IOException If an IO error occurs.
		 */
		protected function endDocument( pdf:PDFDocument ) :void
		{
			// no default implementation, but available for subclasses
		}

		/**
		 * This will process the contents of a page.
		 *
		 * @param page The page to process.
		 * @param content The contents of the page.
		 *
		 * @throws IOException If there is an error processing the page.
		 */
		protected function processPage( page:PDFPage, content:COSStream ):void
		{
			currentPageNo++;
			if( currentPageNo >= startPage && currentPageNo <= endPage &&
				(startBookmarkPageNumber == -1 || currentPageNo >= startBookmarkPageNumber ) && 
				(endBookmarkPageNumber == -1 || currentPageNo <= endBookmarkPageNumber ))
			{
				startPage( page );
				pageArticles = page.getThreadBeads();
				var numberOfArticleSections:int = 1 + pageArticles.size() * 2;
				if( !shouldSeparateByBeads )
				{
					numberOfArticleSections = 1;
				}
				var originalSize:int = charactersByArticle.size();
				charactersByArticle.setSize( numberOfArticleSections );
				for(var i:int=0; i<numberOfArticleSections; i++ )
				{
					if( numberOfArticleSections < originalSize )
					{
						(charactersByArticle.get( i ) as List).clear();
					}
					else
					{
						charactersByArticle.set( i, new ArrayList() );
					}
				}
				
				characterListMapping.clear();
				processStream( page, page.findResources(), content );
				flushText();
				endPage( page );
			}
			
		}
		
		/**
		 * Start a new paragraph.  Default implementation is to do nothing.  Subclasses
		 * may provide additional information.
		 * 
		 * @throws IOException If there is any error writing to the stream.
		 */
		protected function startParagraph() :void
		{
			//default is to do nothing.
		}
		
		/**
		 * End a paragraph.  Default implementation is to do nothing.  Subclasses
		 * may provide additional information.
		 * 
		 * @throws IOException If there is any error writing to the stream.
		 */
		protected function endParagraph():void
		{
			//default is to do nothing
		}
		
		/**
		 * Start a new page.  Default implementation is to do nothing.  Subclasses
		 * may provide additional information.
		 * 
		 * @param page The page we are about to process.
		 * 
		 * @throws IOException If there is any error writing to the stream.
		 */
		protected function startPage( page:PDFPage ) :void
		{
			//default is to do nothing.
		}
		
		/**
		 * End a page.  Default implementation is to do nothing.  Subclasses
		 * may provide additional information.
		 * 
		 * @param page The page we are about to process.
		 * 
		 * @throws IOException If there is any error writing to the stream.
		 */
		protected function endPage( page:PDFPage ) :void
		{
			//default is to do nothing
		}

		/**
		 * This will print the text to the output stream.
		 *
		 * @throws IOException If there is an error writing the text.
		 */
		protected function flushText() :void
		{
			var currentY:Number = -1;
			var lastBaselineFontSize:Number = -1;
			var endOfLastTextX:Number = -1;
			var startOfNextWordX:Number = -1;
			var lastWordSpacing:Number = -1;
			var lastProcessedCharacter:TextPosition = null;
			
			for( var i:int=0; i<charactersByArticle.size(); i++)
			{
				startParagraph();
				var textList:List = charactersByArticle.get( i ) as List;
				if( sortByPosition )
				{
					var comparator:TextPositionComparator = new TextPositionComparator( getCurrentPage() );
					Collections.sort( textList, comparator );
				}
				/*
				Iterator textIter = textList.iterator();
				while( textIter.hasNext() )
				{
					TextPosition position = (TextPosition)textIter.next();
					var characterValue:String = position.getCharacter();
					
					//wordSpacing = position.getWordSpacing();
					float wordSpacing = 0;
					
					if( wordSpacing == 0 )
					{
						//try to get width of a space character
						wordSpacing = position.getWidthOfSpace();
						//if still zero fall back to getting the width of the current
						//character
						if( wordSpacing == 0 )
						{
							wordSpacing = position.getWidth();
						}
					}
					
					
					// RDD - We add a conservative approximation for space determination.
					// basically if there is a blank area between two characters that is
					//equal to some percentage of the word spacing then that will be the
					//start of the next word
					if( lastWordSpacing <= 0 )
					{
						startOfNextWordX = endOfLastTextX + (wordSpacing* 0.50f);
					}
					else
					{
						startOfNextWordX = endOfLastTextX + (((wordSpacing+lastWordSpacing)/2f)* 0.50f);
					}
					
					lastWordSpacing = wordSpacing;
		
					// RDD - Here we determine whether this text object is on the current
					// line.  We use the lastBaselineFontSize to handle the superscript
					// case, and the size of the current font to handle the subscript case.
					// Text must overlap with the last rendered baseline text by at least
					// a small amount in order to be considered as being on the same line.
					//
					int verticalScaling = 1;
					if( lastBaselineFontSize < 0 || position.getFontSize() < 0 )
					{
						verticalScaling = -1;
					}
					if (currentY != -1 &&
						((position.getY() < (currentY - (lastBaselineFontSize * 0.9f * verticalScaling))) ||
						 (position.getY() > (currentY + (position.getFontSize() * 0.9f * verticalScaling)))))
					{
						output.write(getLineSeparator());
						endOfLastTextX = -1;
						startOfNextWordX = -1;
						currentY = -1;
						lastBaselineFontSize = -1;
					}
		
					if (startOfNextWordX != -1 && startOfNextWordX < position.getX() &&
					   lastProcessedCharacter != null &&
					   //only bother adding a space if the last character was not a space
					   lastProcessedCharacter.getCharacter() != null &&
					   !lastProcessedCharacter.getCharacter().endsWith( " " ) )
					{
						output.write(getWordSeparator());
					}
		
					if (currentY == -1)
					{
						currentY = position.getY();
					}
		
					if (currentY == position.getY())
					{
						lastBaselineFontSize = position.getFontSize();
					}
		
					// RDD - endX is what PDF considers to be the x coordinate of the
					// end position of the text.  We use it in computing our metrics below.
					//
					endOfLastTextX = position.getX() + position.getWidth();
		
		
					if (characterValue != null)
					{
						writeCharacters( position );
					}
					else
					{
						//Position.getString() is null so not writing anything
					}
					lastProcessedCharacter = position;
				}
				*/
				endParagraph();
			}
			

			// RDD - newline at end of flush - required for end of page (so that the top
			// of the next page starts on its own line.
			//
			output.write(getPageSeparator());

			output.flush();
		}
		
		/**
		 * Write the string to the output stream.
		 *  
		 * @param text The text to write to the stream.
		 * @throws IOException If there is an error when writing the text.
		 */
		protected function writeCharacters( text:TextPosition ):void
		{
			output.write( text.getCharacter() );
		}

		/**
		 * This will determine of two floating point numbers are within a specified variance.
		 *
		 * @param first The first number to compare to.
		 * @param second The second number to compare to.
		 * @param variance The allowed variance.
		 */
		private function within( first:Number, second:Number, variance:Number ):Boolean
		{
			return second > first - variance && second < first + variance;
		}

		/**
		 * This will show add a character to the list of characters to be printed to
		 * the text file.
		 *
		 * @param text The description of the character to display.
		 */
		protected function showCharacter( text:TextPosition ):void
		{
			var showCharacter:Boolean = true;
			if( suppressDuplicateOverlappingText )
			{
				showCharacter = false;
				var textCharacter:String = text.getCharacter();
				var textX:Number = text.getX();
				var textY:Number = text.getY();
				var sameTextCharacters:List = characterListMapping.get( textCharacter ) as List;
				if( sameTextCharacters == null )
				{
					sameTextCharacters = new ArrayList();
					characterListMapping.put( textCharacter, sameTextCharacters );
				}
		
				// RDD - Here we compute the value that represents the end of the rendered
				// text.  This value is used to determine whether subsequent text rendered
				// on the same line overwrites the current text.
				//
				// We subtract any positive padding to handle cases where extreme amounts
				// of padding are applied, then backed off (not sure why this is done, but there
				// are cases where the padding is on the order of 10x the character width, and
				// the TJ just backs up to compensate after each character).  Also, we subtract
				// an amount to allow for kerning (a percentage of the width of the last
				// character).
				//
				var suppressCharacter:Boolean = false;
				var tolerance:Number = (text.getWidth()/textCharacter.length())/3.0;
				for( var i:int=0; i<sameTextCharacters.size() && textCharacter != null; i++ )
				{
					var character:TextPosition = sameTextCharacters.get( i ) as TextPosition;
					var charCharacter:String = character.getCharacter();
					var charX:Number = character.getX();
					var charY:Number = character.getY();
					//only want to suppress
					
					if( charCharacter != null &&
						//charCharacter.equals( textCharacter ) &&
						within( charX, textX, tolerance ) &&
						within( charY, 
								textY, 
								tolerance ) )
					{
						suppressCharacter = true;
					}
				}
				if( !suppressCharacter )
				{
					sameTextCharacters.add( text );
					showCharacter = true;
				}
			}
			
			if( showCharacter )
			{
				//if we are showing the character then we need to determine which
				//article it belongs to.
				var foundArticleDivisionIndex:int = -1;
				var notFoundButFirstLeftAndAboveArticleDivisionIndex:int = -1;
				var notFoundButFirstLeftArticleDivisionIndex:int = -1;
				var notFoundButFirstAboveArticleDivisionIndex:int = -1;
				var x:Number = text.getX();
				var y:Number = text.getY();
				if( shouldSeparateByBeads )
				{
					for( i=0; i<pageArticles.size() && foundArticleDivisionIndex == -1; i++ )
					{
						PDThreadBead bead = (PDThreadBead)pageArticles.get( i );
						if( bead != null )
						{
							PDRectangle rect = bead.getRectangle();
							if( rect.contains( x, y ) )
							{
								foundArticleDivisionIndex = i*2+1;
							}
							else if( (x < rect.getLowerLeftX() ||
									  y < rect.getUpperRightY()) &&
								notFoundButFirstLeftAndAboveArticleDivisionIndex == -1)
							{
								notFoundButFirstLeftAndAboveArticleDivisionIndex = i*2;
							}
							else if( x < rect.getLowerLeftX() &&
									notFoundButFirstLeftArticleDivisionIndex == -1)
							{
								notFoundButFirstLeftArticleDivisionIndex = i*2;
							}
							else if( y < rect.getUpperRightY() &&
									notFoundButFirstAboveArticleDivisionIndex == -1)
							{
								notFoundButFirstAboveArticleDivisionIndex = i*2;
							}                        
						}
						else
						{
							foundArticleDivisionIndex = 0;
						}
					}
				}
				else
				{
					foundArticleDivisionIndex = 0;
				}
				int articleDivisionIndex = -1;
				if( foundArticleDivisionIndex != -1 )
				{
					articleDivisionIndex = foundArticleDivisionIndex;
				}
				else if( notFoundButFirstLeftAndAboveArticleDivisionIndex != -1 )
				{
					articleDivisionIndex = notFoundButFirstLeftAndAboveArticleDivisionIndex;
				}
				else if( notFoundButFirstLeftArticleDivisionIndex != -1 )
				{
					articleDivisionIndex = notFoundButFirstLeftArticleDivisionIndex;
				}
				else if( notFoundButFirstAboveArticleDivisionIndex != -1 )
				{
					articleDivisionIndex = notFoundButFirstAboveArticleDivisionIndex;
				}
				else
				{
					articleDivisionIndex = charactersByArticle.size()-1;
				}
				List textList = (List) charactersByArticle.get( articleDivisionIndex );
				textList.add( text );
			}
		}

		public function getStartPage():int
		{
			return startPage;
		}
		
		public function setStartPage( startPageValue:int ):void
		{
			startPage = startPageValue;
		}

		public function getEndPage():int
		{
			return endPage;
		}

		public function setEndPage( endPageValue:int ):void
		{
			endPage = endPageValue;
		}

		/**
		 * @return Returns the suppressDuplicateOverlappingText.
		 */
		public function shouldSuppressDuplicateOverlappingText():Boolean
		{
			return suppressDuplicateOverlappingText;
		}
		
		/**
		 * Get the current page number that is being processed.
		 * 
		 * @return A 1 based number representing the current page.
		 */
		protected function getCurrentPageNo():int
		{
			return currentPageNo;
		}

		/**
		 * The output stream that is being written to.
		 * 
		 * @return The stream that output is being written to.
		 */
		protected function getOutput():ByteArray
		{
			return output;
		}
		
		/**
		 * Character strings are grouped by articles.  It is quite common that there
		 * will only be a single article.  This returns a List that contains List objects,
		 * the inner lists will contain TextPosition objects.
		 * 
		 * @return A double List of TextPositions for all text strings on the page.
		 */
		protected function getCharactersByArticle():Array
		{
			return charactersByArticle;
		}
		
		/**
		 * By default the text stripper will attempt to remove text that overlapps each other.
		 * Word paints the same character several times in order to make it look bold.  By setting
		 * this to false all text will be extracted, which means that certain sections will be 
		 * duplicated, but better performance will be noticed.
		 * 
		 * @param suppressDuplicateOverlappingTextValue The suppressDuplicateOverlappingText to set.
		 */
		public function setSuppressDuplicateOverlappingText( suppressDuplicateOverlappingTextValue:Boolean):void
		{
			this.suppressDuplicateOverlappingText = suppressDuplicateOverlappingTextValue;
		}
		
		/**
		 * This will tell if the text stripper should separate by beads.
		 * 
		 * @return If the text will be grouped by beads.
		 */
		public function shouldSeparateByBeads():Boolean
		{
			return shouldSeparateByBeads;
		}
		
		/**
		 * Set if the text stripper should group the text output by a list of beads.  The default value is true!
		 * 
		 * @param aShouldSeparateByBeads The new grouping of beads.
		 */
		public function setShouldSeparateByBeads( aShouldSeparateByBeads:Boolean ):void
		{
			this.shouldSeparateByBeads = aShouldSeparateByBeads;
		}
		
		/**
		 * Get the bookmark where text extraction should end, inclusive.  Default is null.
		 * 
		 * @return The ending bookmark.
		 *
		public function getEndBookmark():PDFOutlineItem
		{
			return endBookmark;
		}
		
		/**
		 * Set the bookmark where the text extraction should stop.
		 * 
		 * @param aEndBookmark The ending bookmark.
		 *
		public function setEndBookmark( aEndBookmark:PDFOutlineItem ):void
		{
			endBookmark = aEndBookmark;
		}
		
		/**
		 * Get the bookmark where text extraction should start, inclusive.  Default is null.
		 * 
		 * @return The starting bookmark.
		 *
		public function getStartBookmark():PDFOutlineItem
		{
			return startBookmark;
		}
		
		/**
		 * Set the bookmark where text extraction should start, inclusive.
		 * 
		 * @param aStartBookmark The starting bookmark.
		 *
		public function setStartBookmark( aStartBookmark:PDFOutlineItem):void
		{
			startBookmark = aStartBookmark;
		}

		/**
		 * This will tell if the text stripper should sort the text tokens
		 * before writing to the stream.
		 * 
		 * @return true If the text tokens will be sorted before being written.
		 */
		public function shouldSortByPosition() :Boolean
		{
			return sortByPosition;
		}

		public function setSortByPosition( newSortByPosition:Boolean ) :void
		{
			sortByPosition = newSortByPosition;
		}
	}
}