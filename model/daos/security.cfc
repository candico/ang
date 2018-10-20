<cfcomponent accessors="Yes">	 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function validateLoginQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     

	<cffunction name="validateLoginQry" access="public" returntype="query">
		<cfargument name="username" type="string" required="true" />
        
        <cfset var ls = {}>	 
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
            SELECT   
                VP.*            
            FROM                 
                V_FSM_PROFILES VP               
            WHERE 
                VP.USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />   
		</cfquery>                       
        
		<cfreturn ls.qry>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function validateUsername
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     

	<cffunction name="validateUsername" access="public" returntype="string">
	    <cfargument name="username" type="string" required="true" />   
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SECURITY.F_CHK_USERNAME(
   				<cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />               
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getUserDataQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     

	<cffunction name="getUserDataQry" access="public" returntype="query">
		<cfargument name="username" type="string" required="true" />
        
        <cfset var ls = {}>	 
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
            SELECT   
                VP.*            
            FROM                 
                V_FSM_PROFILES VP               
            WHERE 
                VP.USERNAME = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />   
		</cfquery>                       
        
		<cfreturn ls.qry>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRolesByUserQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     

	<cffunction name="getRolesByUserQry" access="public" returntype="query">	
        <cfset var ls = {}>	 
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
            SELECT
            	*
            FROM
            	V_FSM_ROLES_BY_USER
            WHERE
            	VISIBILITY = 1
           		AND OFFICE_ID != 0  <!---Brussels HQ---> 
		</cfquery>                       
        
		<cfreturn ls.qry>
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRolesListQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     

	<cffunction name="getRolesListQry" access="public" returntype="query">
		<cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	   
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT        
				LISTAGG(ROLE_ID, ',') WITHIN GROUP (ORDER BY ROLE_ID) AS ROLE_ID_LIST
            FROM
                (
                SELECT
                	ROLE_ID
                FROM
	                FSM_ROLES_BY_USER
                WHERE
    	            USER_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> 
        	        AND OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                 
                )        
        </cfquery>
        
		<cfreturn ls.qry>
	</cffunction>     

	<cffunction name="getRolesCodesQry" access="public" returntype="query">
		<cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
        
         <cfquery name="qry" datasource="#Application.settings.dsn#">        
            SELECT DISTINCT FSM_ROLES.ROLE_CODE
			FROM FSM_ROLES_BY_USER INNER JOIN FSM_ROLES ON FSM_ROLES_BY_USER.ROLE_ID = FSM_ROLES.ID
			WHERE FSM_ROLES_BY_USER.USER_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <!--- AND FSM_ROLES_BY_USER.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer"> --->
		<cfreturn qry>
	</cffunction>

</cfcomponent>
