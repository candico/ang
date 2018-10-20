<cfcomponent accessors="Yes">	

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function externExists
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="externExists" access="public" returntype="boolean">   
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_EXTERNS     
			WHERE     
	            ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
    </cffunction>  

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNSMGridDataQry	
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getNSMGridDataQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
		<cfargument name="office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
			SELECT                
	            ST.STAFF_MEMBER_ID,
                ST.USER_ID,
                NVL(ST.STAFF_TYPE, 'N/A') STAFF_TYPE,
                ST.FG,
                NVL(ST.CONTRACT_ID, 0) CONTRACT_ID,
                ST.CONTRACT_VERSION,
                NVL(ST.START_DATE, 'N/A') START_DATE,
                NVL(ST.END_DATE, 'N/A') END_DATE,  
                NVL(ST.LAST_NAME, 'N/A') LAST_NAME,
                NVL(ST.FIRST_NAME, 'N/A') FIRST_NAME,
                NVL(ST.OFFICE_ID, -1) OFFICE_ID,
                NVL(ST.OFFICE, 'N/A') OFFICE,
                NVL(ST.EMAIL, 'N/A') EMAIL,
                '' JOB              
			FROM
            	MV_FSM_CURRENT_LOCAL_STAFF ST
			WHERE
            	ST.OFFICE_ID = NVL(<cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" null="#office_id EQ 0#"/>, OFFICE_ID) 
                <!---ST.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer"> --->       
                AND PKG_FSM_SMM.F_CHK_VIEW_NSM_LIST(
                <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer">, 
                ST.STAFF_MEMBER_ID, 
                ST.FG) != 'N'
			UNION ALL 
			SELECT                
	            ST.STAFF_MEMBER_ID,
                ST.USER_ID,
                NVL(ST.STAFF_TYPE, 'N/A') STAFF_TYPE,
                ST.FG,
                NVL(ST.CONTRACT_ID, 0) CONTRACT_ID,
                ST.CONTRACT_VERSION,
                NVL(ST.START_DATE, 'N/A') START_DATE,
                NVL(ST.END_DATE, 'N/A') END_DATE,  
                NVL(ST.LAST_NAME, 'N/A') LAST_NAME,
                NVL(ST.FIRST_NAME, 'N/A') FIRST_NAME,
                NVL(ST.OFFICE_ID, -1) OFFICE_ID,
                NVL(ST.OFFICE, 'N/A') OFFICE,
                NVL(ST.EMAIL, 'N/A') EMAIL,
                '' JOB            
			FROM
            	MV_FSM_CURRENT_EXPERT_STAFF ST
			WHERE
            	ST.OFFICE_ID = NVL(<cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" null="#office_id EQ 0#"/>, OFFICE_ID)  
                <!---ST.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer">--->   
                AND PKG_FSM_SMM.F_CHK_VIEW_NSM_LIST(
                <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer">, 
                ST.STAFF_MEMBER_ID,
                ST.FG) != 'N'
            ORDER BY
                OFFICE,
                STAFF_TYPE,
                LAST_NAME,
                FIRST_NAME                                                        
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getStaffMemberDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getStaffMemberDetailsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	       
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                AES.CONTRACT_ID,
                AES.CONTRACT_VERSION,
                AES.STAFF_MEMBER_ID,
                AES.LAST_NAME,
                AES.FIRST_NAME,
                AES.OFFICE_ID,
                AES.OFFICE HOME_OFFICE,
                AES.EMAIL,
                AES.CONTRACT_START,
                AES.CONTRACT_END,
                AES.EXT_TYPE,
                AES.CONTRACT_ROLE,
                AES.POSITION_ROLE,
                AES.FG FUNCTION_GROUP,
                AES.STEP 
            FROM
            	V_FSM_ALL_EXT_STAFF AES
            WHERE
            	AES.STAFF_MEMBER_ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
            UNION    
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
                TBL_OFFICES TOF,
                TBL_POSITIONS POS,
                TBL_ROLES RO2
            WHERE
                CO.ID = CV.CONTRACTID
                AND CV.PRIMARYROLEID = RO1.ID(+)
                AND EX.ID = CO.EXTERNID
                AND TOF.ID = CV.ASSIGNOFFICEID                                         
                AND EX.ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND POS.ASSIGNCONTRACTID(+) = CV.CONTRACTID
                AND POS.ROLEID = RO2.ID(+)                 
		</cfquery>                
           
        
		<cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getWorkflowDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getWorkflowDetailsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	   
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
            SELECT
                SL.ID,
                US.FNAME || ' ' || US.LNAME INITIATOR,
                US2.FNAME || ' ' || US2.LNAME ASSIGNEE,
                ST.STATUS_CODE STATUS_CODE,
                TO_CHAR(SL.CREATED_ON,'DD/MM/YYYY HH24:MI') CREATED_ON,    
                SL.COMMENTS
            FROM
                FSM_SMM_STATUS_LOG SL,
                FSM_STATUSES ST,
                FSM_USERS US,
                FSM_USERS US2
            WHERE
                SL.STAFF_MEMBER_ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
                AND SL.STATUS_ID = ST.ID
                AND SL.CREATED_BY = US.ID
                AND SL.ASSIGNEE_ID = US2.ID(+)
                AND SL.WORKFLOW_ID = 
                (
                    SELECT
                      SL2.WORKFLOW_ID
                    FROM
                      FSM_SMM_STATUS_LOG SL2
                    WHERE
                      SL2.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
                      AND SL2.IS_CURRENT = 'Y' 
                )                
            ORDER BY
				SL.ID DESC                
        </cfquery>        
        
        <cfreturn ls.qry>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getWorkflowStatus
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getWorkflowStatus" access="public" returntype="string">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls.result = "">	   
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
            SELECT                
                ST.STATUS_CODE STATUS_CODE                
            FROM
                FSM_SMM_STATUS_LOG SL,
                FSM_STATUSES ST
            WHERE
                SL.STAFF_MEMBER_ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
                AND SL.STATUS_ID = ST.ID
                AND SL.IS_CURRENT = 'Y'
        </cfquery>        
        
        <cfif ls.qry.recordCount EQ 1>
	        <cfset ls.result = ls.qry.status_code>	
        </cfif>
        
        <cfreturn ls.result>
	</cffunction>             
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyStaffMember
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyContract
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyContractVersion
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewNsm
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewNsm" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_VIEW_NSM(
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
	Function chkAddNsm
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkAddNsm" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_ADD_NSM(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />
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
        <cfset ls.retval = "">
        
        <cfstoredproc procedure="PKG_FSM_SMM.P_WF_START" datasource="#Application.settings.dsn#">
            <cfprocparam value="#user_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#del_user_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#office_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#staff_member_id#" cfsqltype="CF_SQL_INTEGER"> 
            <cfprocparam value="#ls.retval#" cfsqltype="CF_SQL_VARCHAR">            
        </cfstoredproc>  
        
        <cfreturn ls.retval>        
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
        <cfset ls.retval = "">  
        
        <cfstoredproc procedure="PKG_FSM_SMM.P_WF_ACCEPT" datasource="#Application.settings.dsn#">
            <cfprocparam value="#user_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#del_user_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#office_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#staff_member_id#" cfsqltype="CF_SQL_INTEGER"> 
            <cfprocparam value="#ls.retval#" cfsqltype="CF_SQL_VARCHAR">            
        </cfstoredproc>          
        
        <cfreturn ls.retval>        
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
        <cfargument name="comments" type="string" required="true" /> 
        
        <cfset var ls = {}>   
        <cfset ls.retval = ""> 

        <cfstoredproc procedure="PKG_FSM_SMM.P_WF_REJECT" datasource="#Application.settings.dsn#">
            <cfprocparam value="#user_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#del_user_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#office_id#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam value="#staff_member_id#" cfsqltype="CF_SQL_INTEGER"> 
            <cfprocparam value="#comments#" cfsqltype="CF_SQL_VARCHAR"> 
            <cfprocparam value="#ls.retval#" cfsqltype="CF_SQL_VARCHAR">            
        </cfstoredproc>  
        
        <cfreturn ls.retval>          
	</cffunction>                            
    
</cfcomponent>    