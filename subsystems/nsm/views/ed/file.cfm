<cfsetting enablecfoutputonly = true>
<!---<cfquery name="qry" datasource="#Application.settings.dsn#">
    SELECT
        UPLD_DATA FILE_DATA,
        UPLD_NAME FILE_NAME,
        UPLD_MIME MIME_TYPE                     
    FROM
        TBL_EXTERN_EDUCATIONS          
    WHERE 
        ID = <cfqueryparam value="#rc.diploma_id#" cfsqltype="cf_sql_integer">    
    UNION ALL
    SELECT
        UPLD_DATA FILE_DATA,
        UPLD_NAME FILE_NAME,
        UPLD_MIME MIME_TYPE                   
    FROM
        TBL_EXTERN_EDUCATIONS_ALT           
    WHERE 
        ID = <cfqueryparam value="#rc.diploma_id#" cfsqltype="cf_sql_integer">  
</cfquery> ---> 
<cfquery name="qry" datasource="#Application.settings.dsn#">
SELECT              
AD.CV_UPLD_DATA DATA,
AD.CV_UPLD_NAME FILE_NAME, 
AD.CV_UPLD_MIME FILE_MIME,
AD.ID 
FROM 
TBL_ADM_DOC AD 
where 
AD.id = 14
</cfquery>   
<cfheader name="Content-disposition" value="attachment;filename=staff.pdf"> 
<cfheader name="Content-type" value="application/pdf"> 
<cfcontent variable="#qry.data#" />