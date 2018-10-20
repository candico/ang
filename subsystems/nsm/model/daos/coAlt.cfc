<cfcomponent accessors="Yes">
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getContracts Qry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getContractsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                  
            SELECT               
                CO.EXTERNID STAFF_MEMBER_ID, 
                CO.ID CONTRACT_ID,
                CV.ID VERSION_ID,
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
                'N' DELETED
            FROM 	
                TBL_CONTRACTS_VERSIONS_ALT CV,              
                TBL_CONTRACTS_ALT CO,
                TBL_EXTERNS EX,
                TBL_OFFICES TOF,
                TBL_POSITIONS POS
            WHERE 
                CO.ID = CV.CONTRACTID             
                AND CO.EXTERNID = EX.ID  
                AND CV.ASSIGNOFFICEID = TOF.ID
                AND CV.ID = POS.ASSIGNCONTRACTID(+)
                AND DELETED IS NULL
                AND CO.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
			UNION
            SELECT               
                CO.EXTERNID STAFF_MEMBER_ID, 
                CO.ID CONTRACT_ID,
                CV.ID VERSION_ID,
                POS.ROLEID POSITION_ROLE_ID,
                (SELECT R.NAME FROM TBL_ROLES R WHERE R.ID = POS.ROLEID) POSITION_ROLE,
                (SELECT R.ABREV FROM TBL_ROLES R WHERE R.ID = POS.ROLEID) POSITION_ROLE_CODE,  
                CV.PRIMARYROLEID CONTRACT_ROLE_ID,
                (SELECT R.NAME FROM TBL_ROLES R WHERE R.ID = CV.PRIMARYROLEID) CONTRACT_ROLE,
                (SELECT R.ABREV FROM TBL_ROLES R WHERE R.ID = CV.PRIMARYROLEID) CONTRACT_ROLE_CODE,    
                TO_CHAR(CV.STARTDATE,'DD/MM/YYYY') START_DATE,
                DECODE(CV.ENDDATE,'31-DEC-99','OPEN-ENDED','','OPEN-ENDED',TO_CHAR(CV.ENDDATE,'DD/MM/YYYY')) END_DATE,
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
                TBL_CONTRACTS_VERSIONS_ALT CV,              
                TBL_CONTRACTS_ALT CO,
                TBL_EXTERNS_ALT EX,
                TBL_OFFICES TOF,
                TBL_POSITIONS POS
            WHERE 
                CO.ID = CV.CONTRACTID             
                AND CO.EXTERNID = EX.ID  
                AND CV.ASSIGNOFFICEID = TOF.ID
                AND CV.ID = POS.ASSIGNCONTRACTID(+)
                AND CO.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
            ORDER BY 
                START_DATE DESC, 
                CONTRACT_VERSION DESC            
        </cfquery>  
        
		<cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasContractDoc" access="public" returntype="boolean">       
	    <cfargument name="contract_doc_id" type="numeric" required="true" />
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>        
        
       <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
				COUNT(*) CNT
            FROM
	            TBL_CONTRACTS_VERSIONS_DOC_ALT
            WHERE 
    	        ID = <cfqueryparam value="#contract_doc_id#" cfsqltype="cf_sql_integer" /> 	
		</cfquery>  
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>            
        
        <cfreturn ls.retval>    
    </cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewContractDocId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewContractDocId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_CONTRACTS_VERSIONS_DOC_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createAndUpdateContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createAndUpdateContractDoc" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="version_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" />        
        <cfargument name="type_id" type="numeric" required="true" />  
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {result:"OK"}>         
        
        <cftransaction>
        
	        <cfset ls.result1 = createContractDoc(username, staff_member_id, id, version_id).result>
    	    <cfset ls.result2 = updateContractDoc(username, id, type_id).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getTypeId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="getTypeId" access="public" returntype="numeric"> 
        <cfargument name="type_code" type="string" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = 0>        
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	ID
            FROM
	            FSM_DOCUMENT_TYPES
            WHERE
    	        TYPE_CODE = <cfqueryparam value="#type_code#" cfsqltype="cf_sql_varchar" />     
        </cfquery>
        
        <cfif ls.qry.recordCount EQ 1>
        	<cfset ls.retval = ls.qry.id> 
        </cfif>
        
        <cfreturn ls.retval>
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyContractDoc" access="public" returntype="struct"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval["result"] = "OK">       
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_CONTRACTS_VERSIONS_DOC_ALT
            SELECT
	            *
            FROM
    	        TBL_CONTRACTS_VERSIONS_DOC
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />                                 
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isContractDocRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="Removed" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_CONTRACTS_VERSIONS_DOC_ALT 
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />   
                AND DELETED IS NOT NULL         
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
    </cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function RemoveContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="RemoveContractDoc" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" /> 
	   
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>      

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_CONTRACTS_VERSIONS_DOC_ALT  
			SET
            	DELETED = 'Y',
                MODON = SYSDATE,
                MODBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function UpdateContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="UpdateContractDoc" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="type_id" type="numeric" required="true" />         
	   
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>      

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_CONTRACTS_VERSIONS_DOC_ALT  
			SET
            	TYPE = <cfqueryparam value='#type_id#' cfsqltype='cf_sql_numeric'>,            
                MODBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>,
                MODON = SYSDATE   
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>             
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="deleteContractDoc" access="public" returntype="struct"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = {result:"OK"}>         
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	TBL_CONTRACTS_VERSIONS_DOC_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
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
                NVL(DOC.DELETED, 'N') DELETED,
                DOC.TYPE,                
                Hash_MD5_Blob(DOC.UPLD_DATA) UPLD_HASH,                
                DOC.UPLD_NAME,
                DT.TYPE_CODE
            FROM
                TBL_CONTRACTS_VERSIONS_DOC_ALT DOC,
                FSM_DOCUMENT_TYPES DT
            WHERE
                DOC.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND DOC.TYPE = DT.ID                     
        </cfquery>
        
        <cfreturn ls.qry>  
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getContractDocQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getContractDocQry" access="public" returntype="query"> 
        <cfargument name="file_id" type="string" required="true" />  
		<cfargument name="hash" type="string" required="true" /> 
        
        <cfset var ls = {}>      
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                UPLD_DATA FILE_DATA,
                UPLD_NAME FILE_NAME,
                UPLD_MIME MIME_TYPE,
                MODBY,
                MODON                
			FROM
				TBL_CONTRACTS_VERSIONS_DOC         
            WHERE 
            	ID = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">    
                AND Hash_MD5_Blob (UPLD_DATA) = '#hash#'     
			UNION ALL
            SELECT
                UPLD_DATA FILE_DATA,
                UPLD_NAME FILE_NAME,
                UPLD_MIME MIME_TYPE,
                MODBY,
                MODON                
			FROM
				TBL_CONTRACTS_VERSIONS_DOC_ALT           
            WHERE 
            	ID = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">      
                AND Hash_MD5_Blob (UPLD_DATA) = '#hash#'                      
		</cfquery>                
        
        <cfreturn ls.qry>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createContractDoc" access="public" returntype="struct"> 
        <cfargument name="username" type="string" required="true" />
		<cfargument name="staff_member_id" type="numeric" required="true" />
		<cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="version_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>  
                    
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_CONTRACTS_VERSIONS_DOC_ALT
            (
                ID,      
                CO_ID,          
                EXTERNID,                
                CRTBY,
                CRTON
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#version_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery>    

		<cfreturn ls.retval>        
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAndUpdateContractDoc
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="copyAndUpdateContractDoc" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = copyContractDoc(id).result>
    	    <cfset ls.result2 = updateContractDoc(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateContractDocFile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="updateContractDocFile" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />
        <cfargument name="id" type="numeric" required="true" />  
        <cfargument name="filefield" type="string" required="true" />        
        <cfargument name="rc" type="struct" required="true" />   
        
        <cfset var ls = {}>
        <cfset ls.retval = {"result":"OK"}>         
            
		<cfset ls.tmp_file_dir = GetTempDirectory()>            

        <cffile 
            action="upload"           
            filefield="#filefield#" 
            destination="#ls.tmp_file_dir#" 
            nameconflict="makeunique" 
            accept="application/pdf, image/jpg, image/jpeg"
        >                    

        <cffile	
            action = "readbinary" 
            file = "#ls.tmp_file_dir##cffile.serverFile#" 
            variable="ls.file_blob"
        >          
            
        <cfquery datasource="#Application.settings.dsn#">
            UPDATE 
                TBL_CONTRACTS_VERSIONS_DOC_ALT  
            SET            	
                UPLD_DATA =  <cfqueryparam value="#ls.file_blob#" cfsqltype="cf_sql_blob">,
                UPLD_NAME = <cfqueryparam value="#file.clientFile#" cfsqltype="cf_sql_varchar">,
                <!---UPLD_MIME = <cfqueryparam value="#file.contentType#/#file.contentSubType#" cfsqltype="cf_sql_varchar">, ---> 
                UPLD_MIME = <cfqueryparam value="#file.contentSubType#" cfsqltype="cf_sql_varchar">,                           
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">,
                MODON = SYSDATE                                              
            WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">    
        </cfquery>        
        
       <cffile 
            action="delete" 
            file="#ls.tmp_file_dir##cffile.serverFile#"
        >   
    
        <cfreturn ls.retval>
	</cffunction>                 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getLastUpdateQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  

	<cffunction name="getLastUpdateQry" access="public" returntype="query">
        <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>     
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
            SELECT
	            EXTERNID STAFF_MEMBER_ID,
                LAST_UPDATED_ON,
                LAST_UPDATED_BY
            FROM
                (                        
                    SELECT
                        T1.EXTERNID,
                        T2.CREATIONDATE LAST_UPDATED_ON,
                        NULL LAST_UPDATED_BY    
                    FROM
                        TBL_CONTRACTS_ALT T1,
                        TBL_CONTRACTS_VERSIONS_ALT T2
                    WHERE 
                        T1.ID = T2.CONTRACTID
                        AND T1.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">                      
                )
			UNION
            SELECT
	            EXTERNID STAFF_MEMBER_ID,
                LAST_UPDATED_ON,
                LAST_UPDATED_BY
            FROM
                (                        
                    SELECT
                        T1.EXTERNID,
                        T1.CRTON LAST_UPDATED_ON,
                        NULL LAST_UPDATED_BY    
                    FROM
                        TBL_CONTRACTS_VERSIONS_DOC T1                        
                    WHERE 
                        T1.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">                     
                )                
            WHERE
	            ROWNUM = 1  
		</cfquery>  
        
        <cfreturn ls.qry>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function insertStatusLog
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="insertStatusLog" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />     
        <cfargument name="office_id" type="numeric" required="true" />  
    	<cfargument name="staff_member_id" type="numeric" required="true" />        
        <cfargument name="log_status_code" type="string" required="true" />          
        
        <cfset var ls = {}>
        
        <cftransaction> 
        
        	<cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
                SELECT
               		ST.STATUS_CODE,
                    SL.WORKFLOW_ID
                FROM
	                FSM_SMM_STATUS_LOG SL,
    	            FSM_STATUSES ST
                WHERE
        	        SL.STAFF_MEMBER_ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
            	    AND SL.IS_CURRENT = 'Y'
                	AND SL.STATUS_ID = ST.ID   
            </cfquery>    
            
            <cfif ls.qry.recordCount EQ 0 OR ls.qry.status_code NEQ log_status_code>
            	<!---no point in duplicating the current status--->
                
                <cfif ls.qry.recordCount EQ 0>
                	<cfset ls.workflow_id = getNewWorkflowId()>
				<cfelse>
                	<cfset ls.workflow_id = ls.qry.workflow_id>                	                    				
				</cfif>
        
                <cfquery datasource="#Application.settings.dsn#">       
                    UPDATE 
                    	FSM_SMM_STATUS_LOG
                    SET    
                        IS_CURRENT = 'N'
                    WHERE
                        STAFF_MEMBER_ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                        AND IS_CURRENT = 'Y' 
                        AND WORKFLOW_ID = <cfqueryparam value="#ls.workflow_id#" cfsqltype="cf_sql_integer" /> 
                </cfquery>          
                
                <cfquery datasource="#Application.settings.dsn#">       
                    INSERT INTO FSM_SMM_STATUS_LOG 
                    (
                        STAFF_MEMBER_ID,
                        STATUS_ID,
                        OFFICE_ID,
                        IS_CURRENT,
                        WORKFLOW_ID,
                        CREATED_BY,
                        DEL_CREATED_BY,
                        CREATED_ON
                    )  
                    SELECT
                        <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                        ST.ID,
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                        'Y',
                        <cfqueryparam value="#ls.workflow_id#" cfsqltype="cf_sql_integer" />,  
                        <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />,                        
                        <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" />,
                        SYSDATE                      
                    FROM
                        FSM_STATUSES ST
                    WHERE
                        ST.STATUS_CODE = <cfqueryparam value="#log_status_code#" cfsqltype="cf_sql_varchar" /> 
                </cfquery>  
            
            </cfif>  
        
        </cftransaction>  
        
		<cfreturn "OK">
	       
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function transactQry()
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="transactQry" access="public" returntype="struct"> 
        <cfargument name="calls" type="array" required="true" />           
        
        <cfset var ls = {}>
        <cfset ls.retval["result"] = "OK">
        <cfset ls.retval["retvals"] = []> 
        
        <cftransaction>
			
            <cfloop array="#calls#" index="ls.idx">            
            
                <cfinvoke
                	method="#ls.idx.func#"   
                    returnvariable="ls.returnVariable"             	
	                argumentCollection="#ls.idx.args#"
                >
                
                <cfset ls.tmp = {}>				
                <cfset ls.tmp["func"] = ls.idx.func>  
                <cfset ls.tmp["retval"] = structKeyExists(ls, "returnVariable") ? ls.returnVariable : "N/A"> 
                <cfset ArrayAppend(ls.retval.retvals, ls.tmp)>
            
            </cfloop>  
        
        </cftransaction>     
        
        <cfreturn ls.retval>        
	</cffunction>        
    
</cfcomponent>    