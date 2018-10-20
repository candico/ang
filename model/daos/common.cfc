<cfcomponent accessors="Yes">

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Function getMaritalStatusesQry
Function getAllStringRefs
Function getAllStrings
Function setAllStrings
Function getAllFSMCountriesEN
Function getAllFSMCountriesFR	
Function setAllFSMCountries	
Function getAllFSMCitizenshipsEN
Function getAllFSMCitizenshipsFR
setAllFSMCountries	
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getMaritalStatusesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getMaritalStatusesQry" access="public" returntype="query">	
    	<cfargument name="lang_code" default="EN">        
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT 
            	ID MARITAL_STATUS_ID,
	            TRANSLATIONLBL MARITAL_STATUS
            FROM 
            	TBL_MARIAGE_STATUS MS
			WHERE
        	    MS.LG = <cfqueryparam value="#Arguments.lang_code#" cfsqltype="cf_sql_varchar" />                               
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllStringRefs
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->            
    
    <cffunction name="getAllStringRefs" access="public" returntype="query">
		<cfset var ls = {}>	
    	
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT DISTINCT
                STR_CODE,    
                STR,
                APP_NAME,        
                MODULE
            FROM
                FSM_STRINGS   
        </cfquery>	
        
        <cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllStrings
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
    <cffunction name="getAllStrings" access="public" returntype="query">	
		<cfset var ls = {}>	
            
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                *
            FROM
                FSM_STRINGS   
        </cfquery>	
        
        <cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function setAllStrings
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->       
    
	<cffunction name="setAllStrings" access="public">    
	    <cfset var ls = {}>	
        
        <cfset qRef = getAllStringRefs()>
        <cfset qStr = getAllStrings()>      
    	
        <cfset EN = StructNew()>
        <cfset FR = StructNew()>
        
        <!--- <cflock timeout="5" throwontimeout="Yes" type="Exclusive" scope="Application"> --->
		   <cfif StructKeyExists(Application, "EN")>
                <cfset StructDelete(Application.EN, "STRINGS")>
            </cfif>
            <cfif StructKeyExists(Application, "FR")>
                <cfset StructDelete(Application.FR, "STRINGS")>
            </cfif>
        <!--- </cflock> --->

            <cfloop query="qRef">        
                <cfset varname = "EN.STRINGS." & qRef.app_name & "." & qRef.module & ".LIB." & qRef.str_code>
                <cfset varnameJS = "EN.STRINGS." & qRef.app_name & "." & qRef.module & ".JS." & qRef.str_code>		
                <cfset temp = SetVariable(varname,qRef.str_code)>
                <cfset str1 = Replace(qRef.str_code, '"', '\"', "ALL")>
                <cfset str2 = Replace(str1, "'", "\'", "ALL")>	
                <cfset temp = SetVariable(varnameJS,str2)>		
                
                <cfset varname = "FR.STRINGS." & qRef.app_name & "." & qRef.module & ".LIB." & qRef.str_code>
                <cfset varnameJS = "FR.STRINGS." & qRef.app_name & "." & qRef.module & ".JS." & qRef.str_code>	
                <cfset temp = SetVariable(varname,qRef.str_code)>
                <cfset str1 = Replace(qRef.str_code, '"', '\"', "ALL")>
                <cfset str2 = Replace(str1, "'", "\'", "ALL")>	
                <cfset temp = SetVariable(varnameJS,str2)>
            </cfloop>		
            
            <cfloop query="qStr">
                <cfif qStr.lang_code EQ "EN">
                    <cfset varname = "EN.STRINGS." & qStr.app_name & "." & qStr.module & ".LIB." & qStr.str_code>
                    <cfset varnameJS = "EN.STRINGS." & qStr.app_name & "." & qStr.module & ".JS." & qStr.str_code>
                <cfelseif qStr.lang_code EQ "FR">
                    <cfset varname = "FR.STRINGS." & qStr.app_name & "." & qStr.module & ".LIB." & qStr.str_code>
                    <cfset varnameJS = "FR.STRINGS." & qStr.app_name & "." & qStr.module & ".JS." & qStr.str_code>
                </cfif>
                <cfset SetVariable(varname,qStr.str)>
                <cfset str1 = Replace(qStr.str, '"', '\"', "ALL")>
                <cfset str2 = Replace(str1, "'", "\'", "ALL")>	
                <cfset SetVariable(varnameJS,str2)>	
            </cfloop>

        <!--- <cflock timeout="5" throwontimeout="Yes" type="Exclusive" scope="Application"> --->
            <cfset Application.EN.STRINGS = Duplicate(EN.STRINGS)>
            <cfset Application.FR.STRINGS = Duplicate(FR.STRINGS)>
        <!--- </cflock> --->
        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllFSMCountriesEN
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
    <cffunction name="getAllFSMCountriesEN" access="public" returntype="query">	
		<cfset var ls = {}>	
            
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
          	SELECT
                CTRY_ID,
                'EN' AS LANG_CODE,                
                ALPHA3,
                EN_NAME AS STR                
            FROM
                FSM_COUNTRIES 
			WHERE
            	ALPHA3 NOT IN('ATA','BVT') <!---///hard-coded!!! --->        
            ORDER BY
              	4 
        </cfquery>	
        
        <cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllFSMCountriesFR
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
    <cffunction name="getAllFSMCountriesFR" access="public" returntype="query">	
		<cfset var ls = {}>	
            
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
          	SELECT
                CTRY_ID,
                'FR' AS LANG_CODE,                
                ALPHA3,
                FR_NAME AS STR                
            FROM
                FSM_COUNTRIES  
			WHERE
            	ALPHA3 NOT IN('ATA','BVT') <!---///hard-coded!!! --->                       
            ORDER BY
              	4 
        </cfquery>	
        
        <cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function setAllFSMCountries
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="setAllFSMCountries" access="public">    
	    <cfset var ls = {}>	
        <cfset ls.EN = {}>
        <cfset ls.EN.LIB = []>
        <cfset ls.EN.JS = []>        
        <cfset ls.FR = {}>
		<cfset ls.FR.LIB = []>
        <cfset ls.FR.JS = []>        
        
        <cfset qStrEN = getAllFSMCountriesEN()>  
        <cfset qStrFR = getAllFSMCountriesFR()> 
        
        <!--- <cflock timeout="5" throwontimeout="Yes" type="Exclusive" scope="Application"> --->
        
            <cfloop query="qStrEN">
                <cfset ls.ctry = {}>
                <cfset ls.ctry["code"] = qStrEN.alpha3>
                <cfset ls.ctry["name"] = qStrEN.str>
                <cfset ArrayAppend(ls.EN.LIB, ls.ctry)>            
                
                <cfset ls.str1 = Replace(qStrEN.str, '"', '\"', "ALL")>
                <cfset ls.str2 = Replace(ls.str1, "'", "\'", "ALL")>	
                
                <cfset ls.ctry = {}>
                <cfset ls.ctry["code"] = qStrEN.alpha3>
                <cfset ls.ctry["name"] = ls.str2>
                <cfset ArrayAppend(ls.EN.JS, ls.ctry)> 
            </cfloop>  
            
            <cfloop query="qStrFR">
                <cfset ls.ctry = {}>
                <cfset ls.ctry["code"] = qStrFR.alpha3>
                <cfset ls.ctry["name"] = qStrFR.str>
                <cfset ArrayAppend(ls.FR.LIB, ls.ctry)>            
                
                <cfset ls.str1 = Replace(qStrFR.str, '"', '\"', "ALL")>
                <cfset ls.str2 = Replace(ls.str1, "'", "\'", "ALL")>	
                
                <cfset ls.ctry = {}>
                <cfset ls.ctry["code"] = qStrFR.alpha3>
                <cfset ls.ctry["name"] = ls.str2>
                <cfset ArrayAppend(ls.FR.JS, ls.ctry)> 
            </cfloop>          
           
            <cfset Application.EN.COUNTRIES = Duplicate(ls.EN)>
            <cfset Application.FR.COUNTRIES = Duplicate(ls.FR)>
        
        <!--- </cflock> --->  
        
	</cffunction>    
        
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllFSMCitizenshipsEN
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
    <cffunction name="getAllFSMCitizenshipsEN" access="public" returntype="query">	
		<cfset var ls = {}>	
            
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
          	SELECT
                CTRY_ID,
                'EN' AS LANG_CODE,                
                ALPHA3,
                EN_CITIZ STR                
            FROM
                FSM_COUNTRIES 
			WHERE
            	ALPHA3 NOT IN('ATA','BVT')  <!---///hard-coded!!! --->                 
            ORDER BY
              	4 
        </cfquery>	
        
        <cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllFSMCitizenshipsFR
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
    <cffunction name="getAllFSMCitizenshipsFR" access="public" returntype="query">	
		<cfset var ls = {}>	
            
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
          	SELECT
                CTRY_ID,
                'FR' AS LANG_CODE,                
                ALPHA3,
                FR_CITIZ AS STR                
            FROM
                FSM_COUNTRIES    
			WHERE
            	ALPHA3 NOT IN('ATA','BVT') <!---///hard-coded!!! --->                           
            ORDER BY
              	4 
        </cfquery>	
        
        <cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function setAllFSMCitizenships
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="setAllFSMCitizenships" access="public">    
	    <cfset var ls = {}>	
        <cfset ls.EN = {}>
        <cfset ls.EN.LIB = []>
        <cfset ls.EN.JS = []>        
        <cfset ls.FR = {}>
		<cfset ls.FR.LIB = []>
        <cfset ls.FR.JS = []>        
        
        <cfset qStrEN = getAllFSMCitizenshipsEN()>  
        <cfset qStrFR = getAllFSMCitizenshipsFR()> 
        
        <!--- <cflock timeout="5" throwontimeout="Yes" type="Exclusive" scope="Application"> --->
        
            <cfloop query="qStrEN">
                <cfset ls.citiz = {}>
                <cfset ls.citiz["code"] = qStrEN.alpha3>
                <cfset ls.citiz["name"] = qStrEN.str>
                <cfset ArrayAppend(ls.EN.LIB, ls.citiz)>            
                
                <cfset ls.str1 = Replace(qStrEN.str, '"', '\"', "ALL")>
                <cfset ls.str2 = Replace(ls.str1, "'", "\'", "ALL")>	
                
                <cfset ls.citiz = {}>
                <cfset ls.citiz["code"] = qStrEN.alpha3>
                <cfset ls.citiz["name"] = ls.str2>
                <cfset ArrayAppend(ls.EN.JS, ls.citiz)> 
            </cfloop>  
            
            <cfloop query="qStrFR">
                <cfset ls.citiz = {}>
                <cfset ls.citiz["code"] = qStrFR.alpha3>
                <cfset ls.citiz["name"] = qStrFR.str>
                <cfset ArrayAppend(ls.FR.LIB, ls.citiz)>            
                
                <cfset ls.str1 = Replace(qStrFR.str, '"', '\"', "ALL")>
                <cfset ls.str2 = Replace(ls.str1, "'", "\'", "ALL")>	
                
                <cfset ls.citiz = {}>
                <cfset ls.citiz["code"] = qStrFR.alpha3>
                <cfset ls.citiz["name"] = ls.str2>
                <cfset ArrayAppend(ls.FR.JS, ls.citiz)> 
            </cfloop>          
           
            <cfset Application.EN.CITIZENSHIPS = Duplicate(ls.EN)>
            <cfset Application.FR.CITIZENSHIPS = Duplicate(ls.FR)>
        
        <!--- </cflock> --->
        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getUnsentMailMessagesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getUnsentMailMessagesQry" access="public" returntype="query">	
    	<cfargument name="lang_code" default="EN">        
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT 
            	ID,
                SENDER,
            	RECIPIENTS,
                SUBJECT,
                BODY
            FROM 
            	FSM_MESSAGES
			WHERE
        	    SENT IS NULL
                AND STATUS = 1;                              
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function sendMailMessage
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="sendMailMessage" access="public" returntype="struct">	
	    <cfargument name="message_id" type="numeric" required="true" />
	    <cfargument name="sender" type="string" required="true" />
    	<cfargument name="recipients" type="string" required="true" />
        <cfargument name="subject" type="string" required="true" />
        <cfargument name="bosy" type="string" required="true" />     
        
        <cfset var ls = {}>	        	
        <cfset ls.retval = {result:"OK"}>        
        
        <cfmail
	        from = "#sender#"
			to = "#recipients#"
        	subject="#subject#"        
        >
        	#body#          
        </cfmail>     
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            UPDATE 
            	FSM_MESSAGES
			SET
            	SENT_ON = SYSDATE                
			WHERE
        	    ID = <cfqueryparam value="#message_id#" cfsqltype="cf_sql_varchar" />                               
		</cfquery> 
        
		<cfreturn ls.retval>
	</cffunction>             
    
</cfcomponent>