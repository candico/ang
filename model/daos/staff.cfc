<cfcomponent accessors="Yes">	

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getCurrentWorkflowsQry
	Get all current workflows pertaining to the current user
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getCurrentWorkflowsQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
		<cfargument name="office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	         
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
			SELECT <!---Office-based roles--->
                T1.ROLE_CODE,
                T2.OFFICE_ID,
                T2.ID WORKFLOW_ID,
                T2.CREATED_ON SINCE,
                T2.STAFF_MEMBER_ID,
                T2.INITIATOR,
                T2.STAFF_MEMBER,
                T2.STATUS_CODE,
                T2.COMMENTS
            FROM
            (
                SELECT
                	RBU.USER_ID,
	                RO.ROLE_CODE                    
                FROM
    	            FSM_ROLES_BY_USER RBU,
        	        FSM_ROLES RO
                WHERE
            	    RBU.USER_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />
                	AND RBU.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />
	                AND RO.ID = RBU.ROLE_ID
    	            AND RO.ROLE_CODE IN ('SMM_FIELD_VERIFIER','SMM_FIELD_VALIDATOR')
            ) T1,
            (
                SELECT
                    SL.ID,
                    SL.OFFICE_ID,
                    TO_CHAR(SL.CREATED_ON, 'DD/MM/YYYY') CREATED_ON,
                    SL.STAFF_MEMBER_ID,
                    US.ID USER_ID,
                    US.LNAME || ' ' || US.FNAME INITIATOR,
                    AES.LAST_NAME || ' ' || AES.FIRST_NAME STAFF_MEMBER,
                    ST.STATUS_CODE,
                    SL.COMMENTS
                FROM
                    FSM_SMM_STATUS_LOG SL,
                    FSM_STATUSES ST,
                    FSM_USERS US,
                    V_FSM_ALL_EXT_STAFF AES
                WHERE
                    SL.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />
                    AND SL.STATUS_ID = ST.ID
                    AND SL.IS_CURRENT = 'Y'
                    AND SL.CREATED_BY = US.ID
                    AND ST.STATUS_CODE IN ('SMM_FIELD_VERIFICATION_PENDING', 'SMM_FIELD_VALIDATION_PENDING')
                    AND AES.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
            ) T2   
            WHERE
            	T1.USER_ID != T2.USER_ID <!---Cannot validate or verify own edits--->
            UNION                          
            SELECT <!---Non-office-based roles--->
                T1.ROLE_CODE,
                T2.OFFICE_ID,
                T2.ID WORKFLOW_ID,
                T2.CREATED_ON SINCE,
                T2.STAFF_MEMBER_ID,
                T2.INITIATOR,
                T2.STAFF_MEMBER,
                T2.STATUS_CODE,
                T2.COMMENTS
            FROM
            (
                SELECT DISTINCT
                	RBU.USER_ID,
	                RO.ROLE_CODE
                FROM
    	            FSM_ROLES_BY_USER RBU,
        	        FSM_ROLES RO
                WHERE
            	    RBU.USER_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />                	
	                AND RO.ID = RBU.ROLE_ID
    	            AND RO.ROLE_CODE IN ('SMM_HQ_VERIFIER','SMM_HQ_VALIDATOR')
            ) T1,
            (
                SELECT
                    SL.ID,
                    SL.OFFICE_ID,
                    TO_CHAR(SL.CREATED_ON, 'DD/MM/YYYY') CREATED_ON,
                    SL.STAFF_MEMBER_ID,
                    US.ID USER_ID,
                    US.LNAME || ' ' || US.FNAME INITIATOR,
                    AES.LAST_NAME || ' ' || AES.FIRST_NAME STAFF_MEMBER,
                    ST.STATUS_CODE,
                    SL.COMMENTS
                FROM
                    FSM_SMM_STATUS_LOG SL,
                    FSM_STATUSES ST,
                    FSM_USERS US,
                    V_FSM_ALL_EXT_STAFF AES
                WHERE
                    SL.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />
                    AND SL.STATUS_ID = ST.ID
                    AND SL.IS_CURRENT = 'Y'
                    AND SL.CREATED_BY = US.ID
                    AND ST.STATUS_CODE IN ('SMM_HQ_VERIFICATION_PENDING', 'SMM_HQ_VALIDATION_PENDING')
                    AND AES.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
            ) T2     
			WHERE
            	T1.USER_ID != T2.USER_ID <!---Cannot self-validate--->                           
            UNION  
            SELECT
                'SMM_ANY_EDITOR' ROLE_CODE, 
                SL.OFFICE_ID,
                SL.ID WORKFLOW_ID,
                TO_CHAR(SL.CREATED_ON, 'DD/MM/YYYY') SINCE,
                SL.STAFF_MEMBER_ID,
                US.LNAME || ' ' || US.FNAME INITIATOR,
                AES.LAST_NAME || ' ' || AES.FIRST_NAME STAFF_MEMBER,
                ST.STATUS_CODE,
                SL.COMMENTS
            FROM
                FSM_SMM_STATUS_LOG SL,
                FSM_STATUSES ST,
                V_FSM_ALL_EXT_STAFF AES,
                FSM_USERS US
            WHERE
                SL.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />
                AND SL.STATUS_ID = ST.ID
                AND ST.STATUS_CODE IN ('SMM_EDIT_PENDING')  
                AND SL.IS_CURRENT = 'Y'  
                AND AES.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
                AND SL.CREATED_BY = US.ID
                AND SL.ASSIGNEE_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />                       
		</cfquery>               
        
		<cfreturn ls.qry>        
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllWorkflowsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getAllWorkflowsQry" access="public" returntype="query">
    
        <cfset var ls = {}>	         
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">          
            SELECT
                SL.ID,
                SL.CREATED_BY,
                SL.WORKFLOW_ID,
                SL.STAFF_MEMBER_ID,
                SL.OFFICE_ID,
                ST.STATUS_CODE,
                CASE 
                    WHEN ST.STATUS_CODE = 'SMM_FIELD_VALIDATION_PENDING' THEN 'SMM_FIELD_VALIDATOR'
                    WHEN ST.STATUS_CODE = 'SMM_FIELD_VERIFICATION_PENDING' THEN 'SMM_FIELD_VERIFIER'
                    WHEN ST.STATUS_CODE = 'SMM_HQ_VALIDATION_PENDING' THEN 'SMM_HQ_VALIDATOR'
                    WHEN ST.STATUS_CODE = 'SMM_HQ_VERIFICATION_PENDING' THEN 'SMM_HQ_VERIFIER'
			        WHEN ST.STATUS_CODE = 'SMM_EDIT_PENDING' THEN 'SMM_ANY_EDITOR'
			        ELSE 'UNKNOWN'                    
                END ROLE_CODE,
                US.FNAME || ' ' || US.LNAME INITIATOR,
                AES.FIRST_NAME || ' ' || AES.LAST_NAME STAFF_MEMBER
            FROM
                FSM_SMM_STATUS_LOG SL,
                FSM_STATUSES ST,
                FSM_USERS US,
                V_FSM_ALL_EXT_STAFF AES
            WHERE
                SL.IS_CURRENT = 'Y'
                AND ST.ID = SL.STATUS_ID
                AND ST.STATUS_CODE != 'SMM_EDIT_IN_PROGRESS'
                AND SL.CREATED_BY = US.ID
                AND AES.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
            ORDER BY
                SL.OFFICE_ID,
                SL.STAFF_MEMBER_ID   
        </cfquery>  
        
        <cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllWorkflowActorsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getAllWorkflowActorsQry" access="public" returntype="query">
    
        <cfset var ls = {}>	  
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
         SELECT
                T1.ID STATUS_LOG_ID,
                T1.CREATED_BY,
                T1.INITIATED_ON,
                T1.WORKFLOW_ID,
                T1.STAFF_MEMBER_ID,
                T1.OFFICE_ID,
                T1.STATUS_CODE,
                T1.ROLE_CODE,
                T1.INITIATOR,
                T1.EMAIL,
                T1.STAFF_MEMBER,
                T2.ASSIGNEE_ID,
                T2.ASSIGNEE,
                DECODE(T1.CREATED_BY, T2.USER_ID, 'N', 'Y') ACCEPT
            FROM
            (
                SELECT
                    SL.ID,
                    SL.CREATED_BY,
                    TO_CHAR(SL.CREATED_ON,'DD/MM/YYYY') INITIATED_ON,
                    SL.WORKFLOW_ID,
                    SL.STAFF_MEMBER_ID,
                    SL.OFFICE_ID,
                    ST.STATUS_CODE,
                    CASE 
                      WHEN ST.STATUS_CODE = 'SMM_FIELD_VALIDATION_PENDING' THEN 'SMM_FIELD_VALIDATOR'
                      WHEN ST.STATUS_CODE = 'SMM_FIELD_VERIFICATION_PENDING' THEN 'SMM_FIELD_VERIFIER'
                    END ROLE_CODE,
                    US.FNAME || ' ' || US.LNAME INITIATOR,
                    US.EMAIL,                    
                    AES.FIRST_NAME || ' ' || AES.LAST_NAME STAFF_MEMBER
                FROM
                    FSM_SMM_STATUS_LOG SL,
                    FSM_STATUSES ST,
                    FSM_USERS US,
                    V_FSM_ALL_EXT_STAFF AES
                WHERE
                    SL.IS_CURRENT = 'Y'
                    AND ST.ID = SL.STATUS_ID
                    AND ST.STATUS_CODE IN ('SMM_FIELD_VALIDATION_PENDING','SMM_FIELD_VERIFICATION_PENDING')
                    AND SL.CREATED_BY = US.ID
                    AND AES.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
                    AND US.EMAIL IS NOT NULL
            ) T1,
            (
                SELECT
                    RBU.OFFICE_ID,
                    RBU.ROLE_CODE,
                    RBU.USER_ID,
                    US.ID ASSIGNEE_ID,
                    US.FNAME || ' ' || US.LNAME ASSIGNEE
                FROM
                    V_FSM_ROLES_BY_USER RBU,
                    FSM_USERS US
                WHERE
                    RBU.ROLE_CODE IN ( 'SMM_FIELD_VALIDATOR', 'SMM_FIELD_VERIFIER')
                    AND RBU.USER_ID = US.ID
            ) T2
            WHERE
                T1.ROLE_CODE = T2.ROLE_CODE
                AND T1.OFFICE_ID = T2.OFFICE_ID                
            UNION            
            SELECT
                T1.ID STATUS_LOG_ID,
                T1.CREATED_BY,
                T1.INITIATED_ON,
                T1.WORKFLOW_ID,
                T1.STAFF_MEMBER_ID,
                T1.OFFICE_ID,
                T1.STATUS_CODE,
                T1.ROLE_CODE,
                T1.INITIATOR,
                T1.EMAIL,
                T1.STAFF_MEMBER,
                T2.ASSIGNEE_ID,
                T2.ASSIGNEE,
                DECODE(T1.CREATED_BY, T2.USER_ID, 'N', 'Y') ACCEPT
            FROM
            (
                SELECT
                    SL.ID,
                    SL.CREATED_BY,
                    TO_CHAR(SL.CREATED_ON,'DD/MM/YYYY') INITIATED_ON,
                    SL.WORKFLOW_ID,
                    SL.STAFF_MEMBER_ID,
                    SL.OFFICE_ID,
                    ST.STATUS_CODE,
                    CASE 
                      WHEN ST.STATUS_CODE = 'SMM_HQ_VALIDATION_PENDING' THEN 'SMM_HQ_VALIDATOR'
                      WHEN ST.STATUS_CODE = 'SMM_HQ_VERIFICATION_PENDING' THEN 'SMM_HQ_VERIFIER'
                    END ROLE_CODE,
                    US.FNAME || ' ' || US.LNAME INITIATOR,
                    US.EMAIL,
                    AES.FIRST_NAME || ' ' || AES.LAST_NAME STAFF_MEMBER
                FROM
                    FSM_SMM_STATUS_LOG SL,
                    FSM_STATUSES ST,
                    FSM_USERS US,
                    V_FSM_ALL_EXT_STAFF AES
                WHERE
                    SL.IS_CURRENT = 'Y'
                    AND ST.ID = SL.STATUS_ID
                    AND ST.STATUS_CODE IN ('SMM_HQ_VALIDATION_PENDING','SMM_HQ_VERIFICATION_PENDING')
                    AND SL.CREATED_BY = US.ID
                    AND AES.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
                    AND US.EMAIL IS NOT NULL
            ) T1,
            (
                SELECT 
                    RBU.ROLE_CODE,
                    RBU.USER_ID,
                    US.ID ASSIGNEE_ID,
                    US.FNAME || ' ' || US.LNAME ASSIGNEE
                FROM
                    V_FSM_ROLES_BY_USER RBU,
                    FSM_USERS US
                WHERE
                	RBU.OFFICE_ID = 0 
                    AND RBU.ROLE_CODE IN ('SMM_HQ_VALIDATOR', 'SMM_HQ_VERIFIER')
                    AND RBU.USER_ID = US.ID
            ) T2
            WHERE
	            T1.ROLE_CODE = T2.ROLE_CODE                
            UNION            
            SELECT
                SL.ID,
                SL.CREATED_BY,
                TO_CHAR(SL.CREATED_ON,'DD/MM/YYYY') INITIATED_ON,
                SL.WORKFLOW_ID,
                SL.STAFF_MEMBER_ID,
                SL.OFFICE_ID,
                ST.STATUS_CODE,
                'SMM_ANY_EDITOR' ROLE_CODE,
                US.FNAME || ' ' || US.LNAME INITIATOR,
                US.EMAIL,
                AES.FIRST_NAME || ' ' || AES.LAST_NAME STAFF_MEMBER,
                SL.ASSIGNEE_ID,
                US2.FNAME || ' ' || US2.LNAME ASSIGNEE,
                'Y' ACCEPT
            FROM
                FSM_SMM_STATUS_LOG SL,
                FSM_STATUSES ST,
                FSM_USERS US,
                FSM_USERS US2,
                V_FSM_ALL_EXT_STAFF AES
            WHERE
                SL.IS_CURRENT = 'Y'
                AND ST.ID = SL.STATUS_ID
                AND ST.STATUS_CODE = 'SMM_EDIT_PENDING'
                AND SL.CREATED_BY = US.ID
                AND SL.ASSIGNEE_ID = US2.ID
                AND AES.STAFF_MEMBER_ID = SL.STAFF_MEMBER_ID
                AND US.EMAIL IS NOT NULL
          ORDER BY
                ASSIGNEE_ID               
        </cfquery>  
        
        <cfreturn ls.qry>
	</cffunction>            
    
    
</cfcomponent>    