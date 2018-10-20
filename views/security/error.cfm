<cfheader statusCode="406">
<cfset environment = getEnvironment()>
<cfif StructKeyExists(Session, "username")>
	<cfset authenticatedUser = Session.username>
<cfelse>    
	<cfset authenticatedUser = "Unknown user">
</cfif>    

<cfsavecontent variable="longError">

<!--- courtesy of Andreas Schuldhaus --->

<div style="width: 50%; color: red; border: 2px dotted red; background-color: #f9f9f9; padding: 10px;">
	<h1 style="color: red;">ERROR in SECURITY/ERROR.CFM !</h1>
	<div style="width: 100%; text-align: left;">
		<p><b>An error occurred!!</b></p>
        
		<cfoutput>
			<cfif structKeyExists( request, 'failedAction' )>
                <!--- sanitize user supplied value before displaying it --->
				<b>Action:</b> #replace( request.failedAction, "<", "&lt;", "all" )#<br/>
                <cfdump var="#request.exception.cause#" label="request.exception.cause">
			<cfelse>
				<b>Action:</b> unknown<br/>
			</cfif>
			<b>Error:</b> #request.exception.cause.message#<br/>
			<b>Type:</b> #request.exception.cause.type#<br/>
			<b>Details:</b> #request.exception.cause.detail#<br/>
		</cfoutput>
        
	</div>
</div>

</cfsavecontent>

<cfsavecontent variable="shortError">
        
<cfoutput>	
	<b>Error:</b> #Request.exception.cause.message#<br/>
	<b>Type:</b> #Request.exception.cause.type#<br/>
	<b>Details:</b> #Request.exception.cause.detail#<br/>
</cfoutput>

</cfsavecontent>

<cffunction name="dbLog" returntype="numeric">
	<cfargument name="authUser">
	<cfargument name="error">        
    
    <cfquery name="getNewLogIdQry" datasource="#Application.settings.dsn#">                    
        SELECT 
            FSM_ERROR_LOG_SEQ.NEXTVAL ID
        FROM 
            DUAL                                
    </cfquery>      
    
    <cfquery datasource="#Application.settings.dsn#">                 
        INSERT INTO FSM_ERROR_LOG
        (
        	ID, 
            AUTH_USER,
            ERROR,
            TS
        )
        VALUES
        (		
            <cfqueryparam value="#getNewLogIdQry.id#" cfsqltype="cf_sql_numeric" />,  
            <cfqueryparam value="#authUser#" cfsqltype="cf_sql_varchar" />,
            <cfqueryparam value="#error#" cfsqltype="cf_sql_varchar" />,
            SYSDATE
        )          
    </cfquery>   
    
	<cfreturn getNewLogIdQry.id>

</cffunction>

<cffunction name="sendErrorMessage" returntype="string">
</cffunction>

<cfoutput>

<cfswitch expression="#environment#">
    <cfcase value="local,local.croesev,local.ec-home">
    <cfset request.layout = false />
    <!---no mail--->
    <!---<cfset dbLog(authenticatedUser, shortError)>--->
    #longError#
    </cfcase>

    <cfcase value="local.curcilj">
        <cfset request.layout = false />
        #longError#
    </cfcase>

    <cfcase value="prod">
        <cfset request.layout = false />
        #shortError#
    </cfcase>
	
    <cfcase value="dev">
        <cfset request.layout = false />
        #longError#
    </cfcase>

	<cfcase value="test">
        <!---send mail--->
    
    </cfcase>    
	<cfcase value="acc">
        <cfset request.layout = false>
        #longError#
    </cfcase>

	<cfdefaultcase>
    <!---Assumed to be production--->
    <!---polite description of error--->
    <!---send mail--->
    
    </cfdefaultcase>
</cfswitch>

<!---environment: #environment#
<br />
CGI.SERVER_NAME: #CGI.SERVER_NAME#
<cfdump var="#URL#">--->

</cfoutput>


