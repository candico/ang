<cfsilent>
<cfif local.RC.VIEWEDIT eq 'new'>
	<cfscript>
		lock scope="Session" type="Readonly" Timeout="3" {
			fileUploadArr = structKeyExists(Session, 'fileUploadArr') ? Duplicate(Session.fileUploadArr) : arrayNew(1);
		}
		ret = fileUploadArr[local.RC.id];
		getdocQry.filename = ret.UPLOADRES.CLIENTFILE;
		getdocQry.mime = ret.UPLOADRES.CONTENTTYPE & "/" & ret.UPLOADRES.CONTENTSUBTYPE;
		getdocQry.data = ret.BINARYFILE;
	</cfscript>
<cfelse>
	<cfquery name="getdocQry" datasource="#Application.settings.dsn#">
		SELECT
			FILENAME,
			DATA,
			MIME
		FROM
			FSM_DOCUMENTS     
		WHERE
			ID = #rc.doc_id#           
	</cfquery>
</cfif>
</cfsilent>
<cfheader name="Content-disposition" value="inline;filename=#getdocQry.filename#"> 
<cfheader name="Content-type" value="#getdocQry.mime#"> 
<cfcontent reset="Yes" variable="#getdocQry.data#" />