<cfheader name="Content-disposition" value="inline;filename=#rc.fileName#"> 
<cfheader name="Content-type" value="#rc.mimeType#"> 
<cfcontent reset="Yes" variable="#rc.fileData#">