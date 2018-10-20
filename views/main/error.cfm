<!---<cfset request.layout = false />--->
<cfset environment = getEnvironment()>
<cfswitch expression="#environment#">
	<cfcase value="local,local.croesev,local.ec-home">
    <!---no mail--->
   
    
    </cfcase>
	<cfcase value="test">
    <!---no mail--->
    
    </cfcase>   
	<cfcase value="acceptance">
    <!---send mail--->
    
    </cfcase>      
	<cfdefaultcase>
    <!---Assumed to be production--->
    <!---polite description of error--->
    <!---send mail--->
    
    </cfdefaultcase>
</cfswitch>

<!--- courtesy of Andreas Schuldhaus --->
<div style="width: 50%; color: red; border: 2px dotted red; background-color: #f9f9f9; padding: 10px;">
	<h1 style="color: red;">ERROR in VIEWS/MAIN/ERROR.CFM !</h1>
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

<cfoutput>

getEnvironment(): #getEnvironment()#

</cfoutput>