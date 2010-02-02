package org.pdfbox.operator{

	import org.pdfbox.cos.COSName;
	import org.pdfbox.cos.COSStream;
	import org.pdfbox.pdmodel.PDFPage;
	import org.pdfbox.pdmodel.PDFResources;
	//import org.pdfbox.pdmodel.graphics.xobject.PDXObject;
	//import org.pdfbox.pdmodel.graphics.xobject.PDXObjectForm;
	import org.pdfbox.utils.PDFOperator;


	/**
	 * Invoke named XObject.
	 * 
	 * @author <a href="mailto:ben@benlitchfield.com">Ben Litchfield</a>
	 * @author Mario Ivankovits
	 * 
	 * @version $Revision: 1.8 $
	 */
	public class Invoke extends OperatorProcessor
	{
		private var inProcess:Array = new Array();

		/**
		 * process : Do - Invoke a named xobject.
		 * @param operator The operator that is being executed.
		 * @param arguments List
		 *
		 * @throws IOException If there is an error processing this operator.
		 */
		override public function process( operator:PDFOperator, arguments:Array):void 
		{
			/*
			var name:COSName = arguments.get( 0 ) as COSName;

			if (inProcess.contains(name))
			{
				// avoid recursive loop
				return;
			}

			inProcess.add(name);

			try
			{
				//PDResources res = context.getResources();

				Map xobjects = context.getXObjects();
				PDXObject xobject = (PDXObject) xobjects.get(name.getName());

				if(xobject instanceof PDXObjectForm)
				{
					PDXObjectForm form = (PDXObjectForm)xobject;
					COSStream invoke = (COSStream)form.getCOSObject();
					PDResources pdResources = form.getResources();
					PDPage page = context.getCurrentPage();
					if(pdResources == null)
					{
						pdResources = page.findResources();
					}

					getContext().processSubStream( page, pdResources, invoke );
				}
			}
			finally
			{
				inProcess.remove(name);
			}
			*/
		}
	}
}