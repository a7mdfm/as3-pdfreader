package org.pdfbox.cos
{


	/**
	 * An interface for visiting a PDF document at the type (COS) level.
	 */
	public interface ICOSVisitor
	{
		/**
		 * Notification of visit to Array object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromArray( obj:COSArray ) :Object;

		/**
		 * Notification of visit to boolean object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromBoolean( obj:COSBoolean ):Object;

		/**
		 * Notification of visit to dictionary object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromDictionary( obj:COSDictionary ):Object;

		/**
		 * Notification of visit to document object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromDocument( obj:COSDocument ):Object

		/**
		 * Notification of visit to float object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromFloat( obj:COSFloat ):Object

		/**
		 * Notification of visit to integer object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromInt( obj:COSInteger ) :Object

		/**
		 * Notification of visit to name object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromName( obj:COSName ):Object;

		/**
		 * Notification of visit to null object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromNull( obj:COSNull ):Object

		/**
		 * Notification of visit to stream object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromStream( obj:COSStream ):Object

		/**
		 * Notification of visit to string object.
		 *
		 * @param obj The Object that is being visited.
		 * @return any Object depending on the visitor implementation, or null
		 * @throws COSVisitorException If there is an error while visiting this object.
		 */
		function visitFromString( obj:COSString ) :Object
	}
}