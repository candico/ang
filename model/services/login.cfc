<cfcomponent accessors="Yes">

    <cfproperty name="securityService">

	<cffunction name="isAuthenticated" returntype="struct">	
    
        <cfset var ls = {}>	 
        
        <cfset ls.retval = {}>   
        <cfset ls.retval.isAuthenticated = false>  
        
        <cfif IsUserLoggedIn()>
	        <cfset ls.retval.isAuthenticated = true>
            <cfreturn ls.retval>
        </cfif>
        
        <cflogin idletimeout="3600">     
        
			<cfset ls.username = "No name yet">
            
            <cfif isDefined("cflogin.name")>
                <cfset ls.username = cflogin.name>
                <cfset ls.vl = Variables.securityService.validateLogin( ls.username )>
                <cfif ls.vl.result EQ "OK">
	                <cfloginuser name="#cflogin.name#" password="" roles="admin,sysadmin">
				    <cfset ls.retval.isAuthenticated = true>    
				<cfelse>
	                <cfset ls.retval.isAuthenticated = false>                                      
                </cfif>   
            </cfif>
            
<!---            <cflog
                text = "In CFLOGIN - Username: #ls.username#"
                type = "information"
                application = "yes"
                file = "log_#LSDateFormat(Now(), 'ddmmyy')#"                    
            > --->
        
        </cflogin>  		
            
		<cfreturn ls.retval>      		
	</cffunction>
    
    <cffunction name="logout">         
        <cflock scope="session" type="exclusive" timeout="10" throwOnTimeout="yes">
            <cfset StructDelete(Session, 'user')>
        </cflock>
        <!--- <cfset Session.user = {}> --->
        <!--- <cfset StructClear(Session)> --->
        <!--- <cfset getPageContext().getSession().invalidate()> --->
        <!--- <cflogout> --->
	</cffunction>
    
</cfcomponent>    