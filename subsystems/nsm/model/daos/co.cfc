<cfcomponent accessors="Yes">

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getStaffMemberQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getStaffMemberQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT
                CV.CONTRACTID CONTRACT_ID,
                CV.VERSION CONTRACT_VERSION,
                CV.INGROUP FG,
                EX.ID STAFF_MEMBER_ID,
                UPPER(EX.SURNAME) AS LAST_NAME,
                INITCAP(EX.NAME) AS FIRST_NAME,
                CV.ASSIGNOFFICEID OFFICE_ID,
                NVL(LOWER(EMAILOFFICIAL),LOWER(EMAILPERSONAL)) EMAIL,
                TO_CHAR(CV.STARTDATE,'DD/MM/YYYY') CONTRACT_START,
                TO_CHAR(CV.ENDDATE,'DD/MM/YYYY') CONTRACT_END,
                DECODE(CV.TYPE,'LOC','NS','EXP','TS',CV.TYPE) EXT_TYPE
            FROM
                TBL_CONTRACTS_VERSIONS CV,
                TBL_CONTRACTS CO,
                TBL_EXTERNS EX
            WHERE
                EX.ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
                AND CO.ID = CV.CONTRACTID
                AND EX.ID = CO.EXTERNID
                AND SYSDATE > CV.STARTDATE 
                AND (SYSDATE < CV.ENDDATE OR CV.ENDDATE IS NULL)
                AND CV.VERSION =
                (
                    SELECT 
                    	MAX(CV2.VERSION)
                    FROM 
                    	TBL_CONTRACTS_VERSIONS CV2
                    WHERE 
                   	 CV2.CONTRACTID = CV.CONTRACTID 
                )	
        </cfquery>  
        
		<cfreturn ls.qry>        
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getContracts Qry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getContractsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">     
            SELECT               
	            CV.ID VERSION_ID,
                CO.ID CONTRACT_ID,
                CO.EXTERNID STAFF_MEMBER_ID,                  
                
                POS.ROLEID POSITION_ROLE_ID,
                (SELECT R.NAME FROM TBL_ROLES R WHERE R.ID = POS.ROLEID) POSITION_ROLE,
                (SELECT R.ABREV FROM TBL_ROLES R WHERE R.ID = POS.ROLEID) POSITION_ROLE_CODE,  
                
                CV.PRIMARYROLEID CONTRACT_ROLE_ID,
                (SELECT R.NAME FROM TBL_ROLES R WHERE R.ID = CV.PRIMARYROLEID) CONTRACT_ROLE,
                (SELECT R.ABREV FROM TBL_ROLES R WHERE R.ID = CV.PRIMARYROLEID) CONTRACT_ROLE_CODE,                              
                
                TO_CHAR(CV.STARTDATE,'DD/MM/YYYY') START_DATE,
                DECODE(CV.ENDDATE,'31-DEC-99','31/12/2099','','31/12/2099',TO_CHAR(CV.ENDDATE,'DD/MM/YYYY')) END_DATE,
                
                (SELECT NAME FROM TBL_UNITS U WHERE U.ID = CV.UNIT) UNIT,   
                
                TOF.ID OFFICE_ID,
                TOF.CITY OFFICE,
                TOF.COUNTRYID COUNTRY_CODE,
                
                DECODE(CV.INGROUP,1,'I',2,'II',3,'III',4,'IV',5,'V',6,'VI') FUNCTION_GROUP, 
                CV.INGROUP,
                CV.INSTEP STEP,
                
                CV.VERSION CONTRACT_VERSION,
                (SELECT MAX(TCV2.VERSION) FROM TBL_CONTRACTS_VERSIONS TCV2 WHERE TCV2.CONTRACTID = CV.CONTRACTID) MAX_CONTRACT_VERSION,                
                
                CV.UPLD_NAME FILE_NAME,
                <!---DBMS_LOB.GETLENGTH(CV.UPLD_DATA) FILE_SIZE,--->
                
                CV.COMMENTS,
                CV.APDREFERENCE APD_REFERENCE,
                CV.STATUS,
                NVL(DELETED,'N') DELETED
            FROM 	
                TBL_CONTRACTS_VERSIONS CV,              
                TBL_CONTRACTS CO,
                TBL_EXTERNS EX,
                TBL_OFFICES TOF,
                TBL_POSITIONS POS
            WHERE 
                CO.ID = CV.CONTRACTID             
                AND CO.EXTERNID = EX.ID  
                AND CV.ASSIGNOFFICEID = TOF.ID
                AND CV.ID = POS.ASSIGNCONTRACTID(+)
                AND CO.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
            ORDER BY 
                CV.STARTDATE DESC, 
                CV.VERSION DESC                                       
        </cfquery>  
        
		<cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasContractDoc" access="public" returntype="boolean">       
	    <cfargument name="contract_file_id" type="numeric" required="true" />
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>        
        
       <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
				COUNT(*) CNT
            FROM
	            TBL_CONTRACTS_VERSIONS_DOC
            WHERE 
    	        ID = <cfqueryparam value="#contract_file_id#" cfsqltype="cf_sql_integer" /> 	
                AND DELETED IS NULL
		</cfquery>  
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>            
        
        <cfreturn ls.retval>    
    </cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getContractDocsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getContractDocsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
            SELECT
                DOC.ID,
                DOC.CO_ID VERSION_ID, <!---this is the CONTRACT VERION NUMBER!--->
                DOC.EXTERNID STAFF_MEMBER_ID, 
                'N' DELETED,
                DOC.TYPE,                
                Hash_MD5_Blob(DOC.UPLD_DATA) UPLD_HASH,                
                DOC.UPLD_NAME,
                DT.TYPE_CODE
            FROM
                TBL_CONTRACTS_VERSIONS_DOC DOC,
                FSM_DOCUMENT_TYPES DT
            WHERE
                DOC.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND DOC.TYPE = DT.ID
                AND DOC.DELETED IS NULL                   
        </cfquery>
        
        <cfreturn ls.qry>  
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewAltCo
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewAltCo" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_VIEW_ALT_PE_CO(
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
	Function chkEditCo
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditCo" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_EDIT_PE_CO(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>      
      
    
</cfcomponent>    