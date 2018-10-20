<cfheader name="Content-disposition" value="attachment;filename=eval.pdf"> 
<cfheader name="Content-type" value="application/pdf"> 
<cfcontent variable="#request.evalPDF#">