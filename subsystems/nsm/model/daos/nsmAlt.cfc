<cfcomponent accessors="Yes">	 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getStaffMemberDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getStaffMemberDetailsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                CV.CONTRACTID CONTRACT_ID,
                CV.VERSION CONTRACT_VERSION,
                EX.ID STAFF_MEMBER_ID,
                UPPER(EX.SURNAME) AS LAST_NAME,
                INITCAP(EX.NAME) AS FIRST_NAME,
                CV.ASSIGNOFFICEID OFFICE_ID,
                TOF.CITY HOME_OFFICE,
                NVL(LOWER(EMAILOFFICIAL),LOWER(EMAILPERSONAL)) EMAIL,
                TO_CHAR(CV.STARTDATE,'DD/MM/YYYY') CONTRACT_START,
                TO_CHAR(CV.ENDDATE,'DD/MM/YYYY') CONTRACT_END,
                DECODE(CV.TYPE,'LOC','NS','EXP','TS',CV.TYPE) EXT_TYPE,
                RO1.NAME CONTRACT_ROLE,
                RO2.NAME POSITION_ROLE,
                CV.INGROUP FUNCTION_GROUP,
                CV.INSTEP STEP                
            FROM
                TBL_CONTRACTS_VERSIONS_ALT CV,
                TBL_CONTRACTS_ALT CO,
                TBL_EXTERNS_ALT EX,
                TBL_ROLES RO1,
                TBL_ROLES RO2,
                TBL_POSITIONS POS,
                TBL_OFFICES TOF
            WHERE
                CO.ID = CV.CONTRACTID
                AND CV.PRIMARYROLEID = RO1.ID
                AND EX.ID = CO.EXTERNID
                AND TOF.ID = CV.ASSIGNOFFICEID
                AND POS.ASSIGNCONTRACTID = CV.CONTRACTID
                AND POS.ROLEID = RO2.ID
                AND SYSDATE > CV.STARTDATE 
                AND (SYSDATE < CV.ENDDATE OR CV.ENDDATE IS NULL)
                AND EX.ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND CV.VERSION =
                (
                    SELECT 
                    	MAX(CV2.VERSION)
                    FROM 
	                    TBL_CONTRACTS_VERSIONS_ALT CV2
                    WHERE 
    	                CV2.CONTRACTID = CV.CONTRACTID 
                )        	     
            ORDER BY
            	CV.CONTRACTID             
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewStaffMemberId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewStaffMemberId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_EXTERNS_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createStaffMember
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createStaffMember" access="public" returntype="string"> 
	    <cfargument name="username" type="string" required="true" />
	    <cfargument name="staff_member_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">           
         	INSERT INTO TBL_EXTERNS_ALT
            (
            	ID,
                SURNAME,
                NAME,
                VERS_NUM,
                CRTBY,
                CRTON
            )
            VALUES
            (
	            <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                'LAST NAME', 
                'FIRST NAME',
                0,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE  
            )        
		</cfquery>
        
        <cfreturn ls.retval> 
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewFsmUserId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewFsmUserId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                FSM_USERS_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createFsmUser
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createFsmUser" access="public" returntype="string"> 
	    <cfargument name="user_id" type="numeric" required="true" /> 
	    <cfargument name="del_user_id" type="any" required="true" />         
	    <cfargument name="id" type="numeric" required="true" />                 
	    <cfargument name="staff_member_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">           
         	INSERT INTO FSM_USERS
            (
            	ID,    
                TMP_EXTERN_ID,
                CREATED_BY, 
                DEL_CREATED_BY, 
                CREATED_ON                
            )
            VALUES
            (
	            <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" />,  
                SYSDATE 
            )        
		</cfquery>
        
        <cfreturn ls.retval> 
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateFsmUser
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="updateFsmUser" access="public" returntype="string"> 
	    <cfargument name="user_id" type="numeric" required="true" /> 
	    <cfargument name="del_user_id" type="numeric" required="true" />         
	    <cfargument name="id" type="numeric" required="true" />                 
	    <cfargument name="rc" type="numeric" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">           
         	UPDATE 
            	FSM_USERS
            SET
                LNAME = <cfqueryparam value="#rc.lname#" cfsqltype="cf_sql_varchar" />, 
                FNAME = <cfqueryparam value="#rc.fname#" cfsqltype="cf_sql_integer" />,
                DOB = TO_DATE(<cfqueryparam value="#rc.dob#" cfsqltype="cf_sql_varchar" />, 'DD/MM/YYYY'),
                USERNAME = <cfqueryparam value="#rc.username#" cfsqltype="cf_sql_varchar" />,
                EMAIL = <cfqueryparam value="#rc.email#" cfsqltype="cf_sql_varchar" />,
                EMAIL2 = <cfqueryparam value="#rc.email2#" cfsqltype="cf_sql_varchar" />,
                ENVIRONMENT = <cfqueryparam value="#rc.environment#" cfsqltype="cf_sql_varchar" />,
                MODIFIED_BY = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />,
                DEL_MODIFIED_BY = <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" />,
                MODIFIED_ON = SYSDATE
			WHERE      
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
		</cfquery>
        
        <cfreturn ls.retval> 
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewContractId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewContractId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_CONTRACTSID_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createContract (Stub)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createContract" access="public" returntype="string"> 
	    <cfargument name="id" type="numeric" required="true" /> 
	    <cfargument name="extern_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">           
         	INSERT INTO TBL_CONTRACTS_ALT
            (
            	ID,
                EXTERNID
            )
            VALUES
            (
	            <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#extern_id#" cfsqltype="cf_sql_integer" />                  
            )        
		</cfquery>
        
        <cfreturn ls.retval> 
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewContractVersionId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewContractVersionId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_CONTRACTS_VERSIONS_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createContractVersion
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createContractVersion" access="public" returntype="string"> 
	    <cfargument name="username" type="string" required="true" />
	    <cfargument name="id" type="numeric" required="true" />      
	    <cfargument name="contract_id" type="numeric" required="true" />              
        <cfargument name="data" type="struct" required="true" />      
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">           
         	INSERT INTO TBL_CONTRACTS_VERSIONS_ALT
            (
            	ID,
                CONTRACTID,
                TYPE,
                ASSIGNOFFICEID,
                PRIMARYROLEID,    
                INGROUP,
                INSTEP,            
                STARTDATE,
                ENDDATE,                
                VERSION,
                CRTBY,
                CREATIONDATE
            )
            VALUES
            (
	            <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#contract_id#" cfsqltype="cf_sql_varchar" />, 
                <cfqueryparam value="#data.type#" cfsqltype="cf_sql_varchar" />,
                <cfqueryparam value="#data.officeId#" cfsqltype="cf_sql_integer" />,
                NULL, <!---PRIMARYROLEID--->
                NULL, <!---INGROUP--->
                NULL, <!---INSTEP--->
                NULL, <!---STARTDATE--->
                NULL, <!---ENDDATE--->
                0,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE  
            )        
		</cfquery>
        
        <cfreturn ls.retval> 
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkEditNsm
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditNsm" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_EDIT_NSM(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkWfStart
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkWfStart" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />      
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_WF_START(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function wfStart
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="wfStart" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />  
		<cfargument name="del_user_id" type="numeric" required="true" />              
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_WF_START(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>      
                      
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkWfAccept
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkWfAccept" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_WF_ACCEPT(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function wfAccept
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="wfAccept" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />  
		<cfargument name="del_user_id" type="numeric" required="true" />              
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_WF_ACCEPT(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkWfReject
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkWfReject" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_WF_REJECT(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function wfReject
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="wfReject" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />  
		<cfargument name="del_user_id" type="numeric" required="true" />              
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_WF_REJECT(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasAnyUpdate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="hasAnyUpdate" access="public" returntype="string"> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_HAS_ANY_UPDATE(   			
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>                           
    
</cfcomponent>    