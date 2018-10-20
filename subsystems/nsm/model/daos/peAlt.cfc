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
                TBL_CONTRACTS_VERSIONS_ALT CV,
                TBL_CONTRACTS_ALT CO,
                TBL_EXTERNS_ALT EX
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
                    	TBL_CONTRACTS_VERSIONS_ALT CV2
                    WHERE 
                   	 CV2.CONTRACTID = CV.CONTRACTID 
                )	
        </cfquery>  
        
		<cfreturn ls.qry>        
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getExperiencesQry
	// The max() should not be necessary
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getExperiencesQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT
            	T1.ID EXP_ID,
                T1.COUNTRYID COUNTRY_CODE,
                T1.CITY,
                T1.COMPANY ORG,
                T1.JOBTITLE JOB,
                TO_CHAR(T1.STARTDATE, 'DD/MM/YYYY') START_DATE,
                TO_CHAR(T1.ENDDATE, 'DD/MM/YYYY') END_DATE,
                T1.TAKEN_PERIOD EXP_IS_ACCEPTED,
                T1.FULL_PART_TIME WORKING_TIME_PCT,
                T1.RECEIVED_CERTIF CERT_WAS_RECEIVED,
                T1.PROPOSED_CERTIF CERT_IS_DECLARATION,
                T1.VALIDATED_PCT RELEVANCE_PCT,
                T1.DELETED
            FROM
            (
                SELECT
                	XP.ID,
                    XP.COUNTRYID,
                    XP.CITY,
                    XP.COMPANY,
                    XP.JOBTITLE,
                    XP.STARTDATE,
                    XP.ENDDATE,
                    XP.TAKEN_PERIOD,
                    XP.FULL_PART_TIME,
                    XP.RECEIVED_CERTIF,
                    XP.PROPOSED_CERTIF,
                    XP.VALIDATED_PCT,
                    NVL(XP.DELETED,'N') DELETED
                FROM
	                TBL_EXPERIENCES_ALT XP                
            ) T1,
            (
                SELECT 
	                XP.ID,
    	            MAX(XP.VERS_NUM)
                FROM 
        	        TBL_EXPERIENCES_ALT XP
                WHERE
            	    XP.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />   
                GROUP BY 
                	XP.ID
            ) T2
            WHERE
	            T1.ID = T2.ID   
			ORDER BY
            	T1.STARTDATE DESC                   
        </cfquery>   
        
		<cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getExperienceQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getExperienceQry" access="public" returntype="query">
		<cfargument name="experience_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT
                ID EXP_ID,
                COUNTRYID COUNTRY_CODE,
                CITY,
                COMPANY ORG,
                JOBTITLE JOB,
                TO_CHAR(STARTDATE, 'DD/MM/YYYY') START_DATE,
                TO_CHAR(ENDDATE, 'DD/MM/YYYY') END_DATE,
                TAKEN_PERIOD EXP_IS_ACCEPTED,
                FULL_PART_TIME WORKING_TIME_PCT,
                RECEIVED_CERTIF CERT_WAS_RECEIVED,
                PROPOSED_CERTIF CERT_IS_DECLARATION,
                VALIDATED_PCT RELEVANCE_PCT,
                NVL(DELETED,'N') DELETED
            FROM
	            TBL_EXPERIENCES_ALT
            WHERE
    	        ID = <cfqueryparam value="#experience_id#" cfsqltype="cf_sql_integer" />                  
        </cfquery>   
        
		<cfreturn ls.qry>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasExperience" access="public" returntype="boolean">       
	    <cfargument name="experience_id" type="numeric" required="true" />
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>        
        
       <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
              COUNT(*) CNT
            FROM
	            TBL_EXPERIENCES_ALT
            WHERE 
    	        ID = <cfqueryparam value="#experience_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>  
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>            
        
        <cfreturn ls.retval>    
    </cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyExperience" access="public" returntype="struct"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = {result:"OK"}>         
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_EXPERIENCES_ALT
            SELECT
	            *
            FROM
    	        TBL_EXPERIENCES
            WHERE
                ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
                AND VERS_NUM =
                (
                    SELECT
	                    MAX(VERS_NUM)
                    FROM
    	                TBL_EXPERIENCES
                    WHERE
        	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
                )                   
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAndUpdateExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="copyAndUpdateExperience" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = copyExperience(id).result>
    	    <cfset ls.result2 = updateExperience(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="deleteExperience" access="public" returntype="struct"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = {result:"OK"}>   
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	TBL_EXPERIENCES_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewExperienceId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewExperienceId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_EXPERIENCES_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createExperience" access="public" returntype="struct"> 
        <cfargument name="username" type="string" required="true" />
		<cfargument name="staff_member_id" type="numeric" required="true" />  
        <cfargument name="id" type="numeric" required="true" />        
  
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>          
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_EXPERIENCES_ALT
            (
                ID,
                VERS_NUM,
                EXTERNID,
                CRTBY,
                CRTON                    
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />, 
                2, <!---vers_num - avoid auto-increment in on-insert trigger---> 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery>      

		<cfreturn ls.retval>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createAndUpdateExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createAndUpdateExperience" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" />        
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = createExperience(username, staff_member_id, id).result>
    	    <cfset ls.result2 = updateExperience(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>      
       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updateExperience" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" /> 
        <cfargument name="id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>    
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
            	TBL_EXPERIENCES_ALT
            SET             	
                COUNTRYID = <cfqueryparam value="#rc.country_code#" cfsqltype="cf_sql_varchar" />,
                CITY = <cfqueryparam value="#rc.city#" cfsqltype="cf_sql_varchar" />,
                COMPANY = <cfqueryparam value="#rc.org#" cfsqltype="cf_sql_varchar" />,
                JOBTITLE = <cfqueryparam value="#rc.job#" cfsqltype="cf_sql_varchar" />,               
                STARTDATE = TO_DATE(<cfqueryparam value="#rc.start_date#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
				ENDDATE = TO_DATE(<cfqueryparam value="#rc.end_date#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                TAKEN_PERIOD = <cfqueryparam value="#rc.exp_is_accepted#" cfsqltype="cf_sql_varchar" />,
                FULL_PART_TIME = <cfqueryparam value="#rc.working_time_pct#" cfsqltype="cf_sql_integer" null="#rc.working_time_pct EQ ''#"/>,
                RECEIVED_CERTIF = <cfqueryparam value="#rc.cert_was_received#" cfsqltype="cf_sql_varchar" />,
                PROPOSED_CERTIF = <cfqueryparam value="#rc.cert_is_declaration#" cfsqltype="cf_sql_varchar" />,
                VALIDATED_PCT = <cfqueryparam value="#rc.relevance_pct#" cfsqltype="cf_sql_numeric" null="#rc.relevance_pct EQ ''#"/>,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />           
		</cfquery> 
        
        <cfreturn ls.retval>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isExperienceRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="isExperienceRemoved" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_EXPERIENCES_ALT  
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
	Function RemoveExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="RemoveExperience" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" /> 
	   
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>      

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_EXPERIENCES_ALT  
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
	Function restoreExperience
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="restoreExperience" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />       
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>        

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_EXPERIENCES_ALT 
			SET
            	DELETED = NULL,
                MODON = SYSDATE,
                MODBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewWorkflowId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewWorkflowId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                FSM_WORKFLOW_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
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
                        EXTERNID,
                        NVL(MODON,CRTON) LAST_UPDATED_ON,
                        NVL(MODBY,CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_EXPERIENCES_ALT
                    WHERE 
                        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                )
            WHERE
	            ROWNUM = 1  
		</cfquery>  
        
        <cfreturn ls.qry>
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