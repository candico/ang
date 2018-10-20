<cfsilent>
<cfquery name="getdocQry" datasource="#Application.settings.dsn#">
	SELECT
    	DL_UPLD_DATA DATA,
    	DL_UPLD_MIME MIME,
        DL_UPLD_NAME FILENAME
	FROM
    	TBL_ADM_DOC   
	WHERE
    	ID = 8         
</cfquery>
</cfsilent>
<cfheader name="Content-disposition" value="inline;filename=#getdocQry.filename#"> 
<cfheader name="Content-type" value="#getdocQry.mime#"> 
<cfcontent reset="Yes" variable="#getdocQry.data#" />