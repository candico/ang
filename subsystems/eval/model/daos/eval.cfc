<cfcomponent accessors="Yes">

	<cffunction name="getEvalGridData">
		<cfquery name="qry" datasource="#Application.settings.dsn#">   
            SELECT FSM_USERS.LNAME || ' ' || FSM_USERS.FNAME AS NAME, FSM_EVALUATIONS.ID, 
            FSM_EVALUATIONS.START_ON, FSM_EVALUATIONS.END_ON, FSM_STRINGS.STR AS TYPE,
            TBL_OFFICES.CITY AS OFFICE
            FROM FSM_EVALUATIONS 
            INNER JOIN FSM_USERS ON FSM_EVALUATIONS.EVALUEE_ID = FSM_USERS.ID
            INNER JOIN FSM_EVAL_TYPES ON FSM_EVALUATIONS.TYPE_ID = FSM_EVAL_TYPES.ID
            INNER JOIN FSM_STRINGS ON FSM_EVAL_TYPES.TYPE_CODE = FSM_STRINGS.STR_CODE
            INNER JOIN TBL_OFFICES ON FSM_EVALUATIONS.OFFICE_ID = TBL_OFFICES.ID
            WHERE FSM_STRINGS.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar">
            AND FSM_EVALUATIONS.PARTICIPANTS LIKE '%|#request.session.user.user_id#|%'
            ORDER BY FSM_EVALUATIONS.ID DESC
		</cfquery>
		<cfreturn qry>
	</cffunction>


    <cffunction name="getOfficeData">
		<cfquery name="qry" datasource="#Application.settings.dsn#">   
            SELECT TBL_OFFICES.* FROM TBL_OFFICES
            INNER JOIN FSM_EVALUATIONS ON FSM_EVALUATIONS.OFFICE_ID = TBL_OFFICES.ID
            WHERE FSM_EVALUATIONS.ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
		</cfquery>
		<cfreturn qry>
	</cffunction>

    <cffunction name="getParticipantData">
        <cfargument name="participants" required="true" type="array" default="#arrayNew(1)#">
		<cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT FSM_USERS.*, FSM_USERS.LNAME || ' ' || FSM_USERS.FNAME FULL_NAME FROM FSM_USERS 
            WHERE FSM_USERS.ID IN (#arrayToList(arguments.participants)#)
		</cfquery>
    	<cfreturn qry>
	</cffunction>

    <cffunction name="getContractData">
        <cfargument name="userId">
		<cfquery name="qry">
            SELECT CV_MAX.STARTDATE AS CONTRACT_START,  
            CV_MAX.ENDDATE AS CONTRACT_END,
            CV_MIN.STARTDATE AS ECHO_START,
            RO1.NAME CONTRACT_ROLE,
            RO2.NAME POSITION_ROLE
            FROM (
            SELECT MIN(TBL_CONTRACTS.ID) CONTRACT_MIN, MAX(TBL_CONTRACTS.ID) CONTRACT_MAX
            FROM TBL_CONTRACTS 
            INNER JOIN FSM_USERS ON FSM_USERS.TMP_EXTERN_ID = TBL_CONTRACTS.EXTERNID 
            AND FSM_USERS.ID = <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_DECIMAL">
            ) CONTRACTS
            INNER JOIN TBL_CONTRACTS_VERSIONS CV_MAX ON CONTRACTS.CONTRACT_MAX = CV_MAX.CONTRACTID
            INNER JOIN TBL_CONTRACTS_VERSIONS CV_MIN ON CONTRACTS.CONTRACT_MIN = CV_MIN.CONTRACTID
            LEFT JOIN TBL_POSITIONS POS ON POS.ASSIGNCONTRACTID = CV_MAX.CONTRACTID
            LEFT JOIN TBL_ROLES RO1 ON CV_MAX.PRIMARYROLEID = RO1.ID
            LEFT JOIN TBL_ROLES RO2 ON POS.ROLEID = RO2.ID
		</cfquery>
            <!--- select
            co.externid,
            co.id,
            cv.version,
            CV.STARTDATE,
            cv.enddate
            from
            tbl_contracts co,
            tbl_contracts_versions cv
            where
            co.externid = 117
            and co.id = cv.contractid
            order by
            co.id,
            cv.id,
            cv.version; --->
    	<cfreturn qry>
	</cffunction>


    <cffunction name="getEvalueeData">
        <cfquery name="qry" datasource="#Application.settings.dsn#">   
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
            TBL_CONTRACTS_VERSIONS CV,
            TBL_CONTRACTS CO,
            TBL_EXTERNS EX,
            TBL_ROLES RO1,
            TBL_ROLES RO2,
            TBL_POSITIONS POS,
            TBL_OFFICES TOF
            WHERE
            CO.ID = CV.CONTRACTID
            AND CV.PRIMARYROLEID = RO1.ID
            AND EX.ID = CO.EXTERNID
            AND TOF.ID = CV.ASSIGNOFFICEID
            AND POS.ASSIGNCONTRACTID(+) = CV.CONTRACTID
            AND POS.ROLEID = RO2.ID(+)
            AND SYSDATE > CV.STARTDATE 
            AND (SYSDATE < CV.ENDDATE OR CV.ENDDATE IS NULL)
            AND EX.ID = (SELECT TMP_EXTERN_ID FROM FSM_USERS 
                        INNER JOIN FSM_EVALUATIONS ON FSM_EVALUATIONS.EVALUEE_ID = FSM_USERS.ID
                        WHERE FSM_EVALUATIONS.ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">)
            AND CV.VERSION = ( SELECT MAX(CV2.VERSION) FROM TBL_CONTRACTS_VERSIONS CV2 WHERE CV2.CONTRACTID = CV.CONTRACTID )
		</cfquery>
		<cfreturn qry>
	</cffunction>

    <cffunction name="getDocuments">
        <cfif structKeyExists(arguments, 'id')>
            <cfquery name="qry" datasource="#Application.settings.dsn#">
                SELECT DBE.DOC_ID, DOCS.FILENAME, DBE.EVAL_ID, DBE.CREATED_BY USER_ID
                FROM FSM_DOCUMENTS DOCS
                INNER JOIN FSM_DOCUMENTS_BY_EVAL DBE ON DOCS.ID = DBE.DOC_ID
                WHERE DBE.EVAL_ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
                ORDER BY DOCS.ID
            </cfquery>
        <cfelse>
            <cfset var qry = queryNew('DOC_ID,FILENAME,EVAL_ID')>
        </cfif>
        <cfreturn qry>
    </cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getEvalGridDataQry
	- Needs a filter on the exercise
	- Needs filters on statuses
	- F_CHECK is on common select, so protects even though we have outer joins
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getEvalGridDataQry">
		<cfquery name="qry" datasource="#Application.settings.dsn#">   
            SELECT
                T3.EVAL_ID,
                T3.CURRENT_PHASES,
                T2.USER_ID STAFF_MEMBER_ID,
                T2.EVALUEE_NAME,
                T1.USER_ROLE
            FROM
          (              
                SELECT
                    EV.ID EVAL_ID,
                    US.LNAME || ' ' || US.FNAME USER_NAME,
                    STR.STR USER_ROLE
                FROM
                    FSM_EVALUATIONS EV,
                    FSM_ROLES_BY_EVAL RBE,
                    FSM_ROLES_BY_USER RBU,
                    FSM_ROLES RO,
                    FSM_STRINGS STR,
                    FSM_USERS US
                WHERE
                    EV.ID = RBE.EVAL_ID
                    AND RBU.ID = RBE.RBU_ID
                    AND RBU.ROLE_ID = RO.ID
                    AND RBU.USER_ID = US.ID
                    AND RBU.OFFICE_ID = <cfqueryparam value="#request.session.user.settings.current_field_office_id#" cfsqltype="cf_sql_integer" />
                    AND US.ID =  <cfqueryparam value="#request.session.user.user_id#" cfsqltype="cf_sql_integer" />
                    AND RO.ROLE_CODE = STR.STR_CODE
                    AND STR.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />  
                    AND PKG_FSM_EVALUATION.F_CHK_VIEW_EVAL(US.ID, RBU.OFFICE_ID, EV.ID) != 'N'
            ) T1,   
            (             
                SELECT
                    EV.ID EVAL_ID,
                    US.ID USER_ID,
                    US.LNAME || ' ' || US.FNAME EVALUEE_NAME
                FROM
                    FSM_EVALUATIONS EV,
                    FSM_ROLES_BY_EVAL RBE,
                    FSM_ROLES_BY_USER RBU,
                    FSM_ROLES RO,
                    FSM_USERS US
                WHERE
                    EV.ID = RBE.EVAL_ID
                    AND RBU.ID = RBE.RBU_ID
                    AND RBU.ROLE_ID = RO.ID
                    AND RBU.USER_ID = US.ID
                    AND RBU.OFFICE_ID = <cfqueryparam value="#request.session.user.settings.current_field_office_id#" cfsqltype="cf_sql_integer" />
                    AND RO.ROLE_CODE  = 'EVM_EVALUEE' 
            ) T2,            
            (
                SELECT
	                FBE.EVAL_ID EVAL_ID,
    	            LISTAGG(STR.STR || ' (> ' || NVL(TO_CHAR(FBE.END_ON,'DD/MM/YYYY'),'N/A') || ')', '<br>') WITHIN GROUP (ORDER BY EF.ID) AS CURRENT_PHASES
                FROM
        	        FSM_EVAL_PHASES EF,
            	    FSM_PHASES_BY_EVAL FBE,
                	FSM_STRINGS STR
                WHERE
	                EF.ID = FBE.PHASE_ID    	            
        	        AND EF.PHASE_CODE = STR.STR_CODE
            	    AND STR.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />               	
                GROUP BY
	                FBE.EVAL_ID
            ) T3 
            WHERE
            	T1.EVAL_ID = T2.EVAL_ID(+)
            AND T1.EVAL_ID = T3.EVAL_ID(+)
			ORDER BY
            	EVAL_ID
		</cfquery>
		<cfreturn qry>
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getUsersByEvalQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getUsersByEvalQry">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
        	SELECT
            	ARGS.EVAL_ID ID,
                PBE.EVAL_ID,
                PBE.RBE_ID,
                PBE.POS,
                PBE.USER_ID,
                PBE.OFFICE_ID,
                PBE.LNAME,
                PBE.FNAME,
                PBE.LNAME || ' ' || PBE.FNAME NAME,
                PBE.ROLE_ID,
                PBE.ROLE_CODE,
                PBE.EXTERN_ID,
                SUBSTR(PBE.ROLE_CODE,5) ROLE,
                CASE
                	WHEN ROLE_CODE = 'EVM_CONTRIBUTOR' THEN SUBSTR(PBE.ROLE_CODE,5) || '_' || PBE.POS || '_ID'
	                ELSE SUBSTR(PBE.ROLE_CODE,5) || '_ID'
                END ROLE_POS_ID
			FROM
                (   
                    SELECT
                    #request.session.user.user_id# AS USER_ID,
                    #request.session.user.settings.current_field_office_id# AS OFFICE_ID,
                    #arguments.id# AS EVAL_ID
                    FROM DUAL 
                ) ARGS LEFT OUTER JOIN V_FSM_PARTICIPANTS_BY_EVAL PBE ON ARGS.EVAL_ID = PBE.EVAL_ID
			--WHERE PKG_FSM_EVALUATION.F_CHK_VIEW_EVAL(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) != 'N'      
			ORDER BY ID
        </cfquery>
        <cfreturn qry>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getUsersByRoleQry
	- Needs a filter on the user?
	- Needs a filter on the exercise
	- Users who are already Evaluees are minus-ed
	- RBE.STATUS_ID = 2 means "Active"
	<!---!!!hard-coded elements--->
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getUsersByRole">

        <cfif structKeyExists(arguments, 'evalId')>
            <cfquery name="qryOfficeId" datasource="#Application.settings.dsn#">
            SELECT OFFICE_ID FROM FSM_EVALUATIONS WHERE ID = <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL">
            </cfquery>
            <cfset local.OfficeId = qryOfficeId.OFFICE_ID[1]>
        <cfelseif structKeyExists(arguments, 'OfficeId')>
            <cfset local.OfficeId = arguments.OfficeId>
        <cfelse>
            <cfset local.OfficeId = request.session.user.settings.current_field_office_id>
        </cfif>

        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT
                RBU.ID RBU_ID,
                RO.ID ROLE_ID,
                US.ID USER_ID,
                US.LNAME,
                US.FNAME,
                US.LNAME || ' ' || US.FNAME NAME,
                RO.ROLE_CODE,
                SUBSTR(RO.ROLE_CODE,5) ROLE,
                RO.ROLE_CODE || '_' || US.ID RID
            FROM
                FSM_ROLES_BY_USER RBU,
                FSM_ROLES RO,
                FSM_USERS US,               
                FSM_MODULES MO
            WHERE
                RBU.USER_ID = US.ID
                AND RBU.ROLE_ID = RO.ID               
                AND RBU.OFFICE_ID = <cfqueryparam value="#local.OfficeId#" cfsqltype="cf_sql_integer" />
                AND RO.MODULE_ID = MO.ID
                AND MO.MODULE_CODE = 'STAFF_EVALUATION_MOD'  
                AND RO.ROLE_CODE != 'EVM_EVALUEE'         
            UNION                
                SELECT
                RBU.ID RBU_ID,
                RO.ID ROLE_ID,
                US.ID USER_ID,
                US.LNAME,
                US.FNAME,
                US.LNAME || ' ' || US.FNAME NAME,
                RO.ROLE_CODE,
                SUBSTR(RO.ROLE_CODE,5) ROLE,
                RO.ROLE_CODE || '_' || US.ID RID
            FROM
                FSM_ROLES_BY_USER RBU,
                FSM_ROLES RO,
                FSM_ROLES_BY_EVAL RBE,
                FSM_USERS US 
            WHERE
                OFFICE_ID = <cfqueryparam value="#local.OfficeId#" cfsqltype="cf_sql_integer" />
                AND  RBU.ROLE_ID = RO.ID
                AND RO.ROLE_CODE = 'EVM_EVALUEE'
                AND RBE.RBU_ID(+) = RBU.ID
                AND RBE.ID IS NULL
                AND RBU.USER_ID = US.ID
            ORDER BY
                LNAME,
                FNAME,                
                ROLE_CODE                                                      
        </cfquery>
        <!--- <cfdump  var="#qry#"><cfabort> --->
        <cfreturn qry>
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getPhasesByEvalQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getPhasesByEvalQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" />
        <cfargument name="eval_id" type="numeric" required="true" />
		<cfargument name="lang_code" type="string" required="true" />  
        
        <cfset var ls = {}>	    
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                 
            SELECT
                ARGS.EVAL_ID,
                FBE.PHASE_ID,
                FBE.PHASE_CODE,
                FBE.PHASE_STATUS_ID,
                FBE.PHASE_STATUS_CODE,
                LOWER(FBE.PHASE_CODE) PHASE,
                --TO_CHAR(FBE.START_ON,'DD/MM/YYYY') START_ON,
                --TO_CHAR(FBE.END_ON,'DD/MM/YYYY') END_ON,
                START_ON,
                END_ON,
                STR.STR DISP_STATUS
            FROM
                V_FSM_PHASES_BY_EVAL FBE,
                FSM_STRINGS STR,
                ( 
                	SELECT 
                    	<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                        <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                        <cfqueryparam value="#lang_code#" cfsqltype="cf_sql_varchar" /> LANG_CODE
                    FROM 
                    	DUAL  
                ) ARGS
            WHERE
                FBE.EVAL_ID = ARGS.EVAL_ID
                AND FBE.PHASE_STATUS_CODE = STR.STR_CODE
                AND STR.LANG_CODE = ARGS.LANG_CODE
                AND PKG_FSM_EVALUATION.F_CHK_VIEW_EVAL(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) != 'N' 
			ORDER BY            	
                FBE.PHASE_ID                
		</cfquery>  
        <!--- <cfdump  var="#ls.qry#"><cfabort> --->
        <cfreturn ls.qry>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updEvalStatusQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="updEvalStatusQry" access="public" returntype="struct">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />  
        <cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="eval_id" type="numeric" required="true" />  
        <cfargument name="status_code" type="string" required="true" /> 
        
		<cfset var ls = {}>
        <cfset ls.retval = {"result":"OK"}>      
    
        <cfquery datasource="#Application.settings.dsn#">
            UPDATE FSM_EVALUATIONS
			SET (STATUS_ID, MODIFIED_BY, DEL_MODIFIED_BY, MODIFIED_ON) =           
            (
                SELECT
                	ST.ID,                                  
                    ARGS.USER_ID,
                    ARGS.DEL_USER_ID,
                    SYSDATE              
                FROM                       
                    (
                        SELECT                            
                            <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" /> DEL_USER_ID,
                            <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                            <cfqueryparam value="#status_code#" cfsqltype="cf_sql_varchar" /> STATUS_CODE                                                       
                        FROM
                            DUAL 
                    ) ARGS,
                    FSM_STATUSES ST
                WHERE
					ARGS.STATUS_CODE = ST.STATUS_CODE       
 			)
            WHERE
	            ID = <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" />		                
        </cfquery>    
        
        <cfreturn ls.retval>     
    
    </cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function insLoggedEvalStatusQry
	This status is copied by a trigger into FSM_EVALUATIONS.status
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="insLoggedEvalStatusQry" access="public" returntype="numeric">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />  
        <cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="eval_id" type="numeric" required="true" />  
        <cfargument name="status_code" type="string" required="true" />    
        <cfargument name="comments" type="string" required="true" />  
        
        <cfset var ls = {}>
        
        <cftransaction>
        
            <cfquery datasource="#Application.settings.dsn#">
                UPDATE 
                	FSM_EVALUATIONS_STATUS_LOG
				SET 
                	IS_CURRENT = 'N'                    
            	WHERE
                	EVAL_ID = <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" />                            
            </cfquery> 
        
            <cfquery name="ls.logIdQry" datasource="#Application.settings.dsn#">
                SELECT
                    FSM_EVALUATIONS_STATUS_LOG_SEQ.NEXTVAL log_id
                FROM
                    DUAL                
            </cfquery> 
            
            <cfset ls.log_id = ls.logIdQry.log_id>
        
            <cfquery datasource="#Application.settings.dsn#">
                INSERT INTO FSM_EVALUATIONS_STATUS_LOG	                
                (
                    ID,
                    EVAL_ID,
                    STATUS_ID,
                    COMMENTS,
                    CREATED_BY,
                    DEL_CREATED_BY,
                    CREATED_ON
                )
                SELECT
                    ARGS.ID, 
                    EVAL_ID,
                    ST.ID,  
                    ARGS.COMMENTS,            
                    ARGS.USER_ID,
                    ARGS.DEL_USER_ID,
                    SYSDATE
                FROM   
                    (
                        SELECT
                            <cfqueryparam value="#ls.log_id#" cfsqltype="cf_sql_integer" /> ID,
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" /> DEL_USER_ID,
                            <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                            <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                            <cfqueryparam value="#comments#" cfsqltype="cf_sql_varchar" /> COMMENTS,
                            <cfqueryparam value="#status_code#" cfsqltype="cf_sql_varchar" /> STATUS_CODE
                        FROM
                            DUAL 
                    ) ARGS,
                    FSM_STATUSES ST
                WHERE
                	ARGS.STATUS_CODE = ST.STATUS_CODE        
                	AND PKG_FSM_EVALUATION.F_CHK_UPDATE_PREP_STATUS(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) = 'Y'
            </cfquery> 
        
        </cftransaction> 
        
        <cfreturn ls.log_id>    
    
    </cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function insEvalQry	
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    
    
	<cffunction name="insEvalQry" access="public" returntype="numeric"> 
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />  
        <cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="status_code" type="string" required="true" /> 
        
        <cfset var ls = {}>	   
        
        <cftransaction>       
        
            <cfquery name="ls.evalIdQry" datasource="#Application.settings.dsn#">
                SELECT
                    FSM_EVALUATIONS_SEQ.NEXTVAL eval_id
                FROM
                    DUAL                
            </cfquery> 
            
            <cfset ls.eval_id = ls.evalIdQry.eval_id>
            
            <cfquery datasource="#Application.settings.dsn#">
                INSERT INTO FSM_EVALUATIONS
                (
                    ID,  
                    OFFICE_ID,
                    STATUS_ID,
                    CREATED_BY,
                    DEL_CREATED_BY,
                    CREATED_ON                
                )
                SELECT
                    ARGS.EVAL_ID,  
                    ARGS.OFFICE_ID,
                    ST.ID,             
                    ARGS.USER_ID,
                    ARGS.DEL_USER_ID,
                    SYSDATE
                FROM   
                    (
                        SELECT
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" /> DEL_USER_ID,
                            <cfqueryparam value="#ls.eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                            <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                            <cfqueryparam value="#status_code#" cfsqltype="cf_sql_varchar" /> STATUS_CODE
                        FROM
                            DUAL 
                    ) ARGS,
                    FSM_STATUSES ST
 				WHERE
					ARGS.STATUS_CODE = ST.STATUS_CODE 
					AND PKG_FSM_EVALUATION.F_CHK_CREATE_PREP(ARGS.USER_ID, ARGS.OFFICE_ID) = 'Y'     
            </cfquery> 
            
            <cfset ls.rbuQry = getRbuQry(user_id, user_id, 'EVM_PREPARATOR', office_id)>        
            <cfset ls.rbu_id = ls.rbuQry.rbu_id>
            <cfset ls.role_id = ls.rbuQry.role_id>
            
           <!--- <cfset insRoleByEvalQry(user_id, del_user_id, office_id, ls.eval_id, ls.rbu_id, ls.role_id, 1, 2)>--->
            
            <cfset insRoleQry(user_id, del_user_id, office_id, ls.eval_id, 'EVM_PREPARATOR', 1, user_id, 'VALID')>
                    
            <cfset insPhaseQry(user_id, del_user_id, office_id, ls.eval_id, 'PREP_PHASE', '', '', 'VALID')> 
        
        </cftransaction>                 
        
        <cfreturn ls.eval_id> 
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function insPhaseQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 
	<cffunction name="insPhaseQry" access="public" return="numeric"> 
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />  
        <cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="eval_id" type="numeric" required="true" />
        <cfargument name="phase_code" type="string" required="true" /> 
        <cfargument name="start_on" type="string" required="false"/>
        <cfargument name="end_on" type="string" required="false" />
        <cfargument name="status_code" type="string" required="true" /> 
        
        <cfset var ls = {}>     
        
        <cftransaction>  
        
            <cfquery name="ls.fbeIdQry" datasource="#Application.settings.dsn#">
                SELECT
                    FSM_PHASES_BY_EVAL_SEQ.NEXTVAL FBE_ID
                FROM
                    DUAL                
            </cfquery>
            
            <cfset ls.fbe_id = ls.fbeIdQry.fbe_id>
            
            <cfquery datasource="#Application.settings.dsn#">
                INSERT INTO FSM_PHASES_BY_EVAL
                (
                    ID,
                    PHASE_ID,
                    EVAL_ID,                 
                    START_ON, 
                    END_ON,   
                    STATUS_ID,    
                    CREATED_BY,
                    DEL_CREATED_BY,
                    CREATED_ON                                 
                )  
                SELECT
                    ARGS.FBE_ID,
                    EF.ID,
                    ARGS.EVAL_ID,   
                    TO_DATE(ARGS.START_ON,'DD/MM/YYYY'),
                    TO_DATE(ARGS.END_ON,'DD/MM/YYYY'),
                    ST.ID,
                    ARGS.USER_ID,
                    ARGS.DEL_USER_ID,
                    SYSDATE              
                FROM  
                    FSM_EVAL_PHASES EF, 
                    (
                        SELECT
                            <cfqueryparam value="#ls.fbe_id#" cfsqltype="cf_sql_integer" /> FBE_ID,
                            <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" /> DEL_USER_ID,
                            <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                            <cfqueryparam value="#phase_code#" cfsqltype="cf_sql_varchar" /> PHASE_CODE,
                            <cfqueryparam value="#start_on#" cfsqltype="cf_sql_varchar" null="#start_on EQ ''#" /> START_ON,
                            <cfqueryparam value="#end_on#" cfsqltype="cf_sql_varchar" null="#end_on EQ ''#" /> END_ON,
                            <cfqueryparam value="#status_code#" cfsqltype="cf_sql_varchar" /> STATUS_CODE
                        FROM
                            DUAL 
                    ) ARGS,
                    FSM_STATUSES ST       
                WHERE
                    EF.PHASE_CODE = ARGS.PHASE_CODE
                    AND ARGS.STATUS_CODE = ST.STATUS_CODE
                    AND PKG_FSM_EVALUATION.F_CHK_CREATE_PREP(ARGS.USER_ID, ARGS.OFFICE_ID) = 'Y'                     
            </cfquery>   
        
        </cftransaction>      

		<cfreturn ls.fbe_id>

	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getFbeQry
	Fbe: phases by evaluation
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getFbeQry" access="public" return="query"> 
	    <cfargument name="user_id" type="numeric" required="true" />         
        <cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="eval_id" type="numeric" required="true" /> 
        <cfargument name="phase_code" type="string" required="true" /> 
        
        <cfset var ls = {}>
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
	            FBE.ID FBE_ID
            FROM
                FSM_PHASES_BY_EVAL FBE,
                FSM_EVAL_PHASES FA,
                (
                    SELECT
                        <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                        <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                        <cfqueryparam value="#phase_code#" cfsqltype="cf_sql_varchar" /> PHASE_CODE
                    FROM
                        DUAL 
                ) ARGS  
            WHERE
                FBE.EVAL_ID = ARGS.EVAL_ID
                AND FBE.PHASE_ID = FA.ID
                AND FA.PHASE_CODE = ARGS.PHASE_CODE  
                AND PKG_FSM_EVALUATION.F_CHK_EDIT_PREP(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) = 'Y'        
        </cfquery>
        
        <cfreturn ls.qry>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updPhaseQry
	!!! Add F_CHK_EDIT_PREP()
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="updPhaseQry" access="public" return="struct"> 
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />  
        <cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="eval_id" type="numeric" required="true" />
        <cfargument name="phase_code" type="string" required="true" /> 
        <cfargument name="start_on" type="string" required="false"/>
        <cfargument name="end_on" type="string" required="false" />  
        
        <cfset var ls = {}>        
        <cfset ls.retval = {action:"updPhaseQry", result:"OK"}>  
        
		<cfset ls.getFbeQry = getFbeQry(user_id, office_id, eval_id, phase_code)>                  
        <cfset ls.fbe_id = ls.getFbeQry.fbe_id>
		
        <cfquery datasource="#Application.settings.dsn#">
        	UPDATE FSM_PHASES_BY_EVAL
            SET (START_ON, END_ON, MODIFIED_BY, DEL_MODIFIED_BY, MODIFIED_ON) =
            (
                SELECT
                    TO_DATE(ARGS.START_ON,'DD/MM/YYYY'),
                    TO_DATE(ARGS.END_ON,'DD/MM/YYYY'),               
                    ARGS.USER_ID,
                    ARGS.DEL_USER_ID,
                    SYSDATE              
                FROM                       
                    (
                        SELECT                            
                            <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" /> DEL_USER_ID,
                            <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,                            
                            <cfqueryparam value="#start_on#" cfsqltype="cf_sql_varchar" null="#start_on EQ ''#" /> START_ON,
                            <cfqueryparam value="#end_on#" cfsqltype="cf_sql_varchar" null="#end_on EQ ''#" /> END_ON                            
                        FROM
                            DUAL 
                    ) ARGS       
                )
			WHERE
            	ID = <cfqueryparam value="#ls.fbe_id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>		

	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updEvalQry
	!!! Add F_CHK_EDIT_PREP()
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   
    
	<cffunction name="updEvalQry" access="public" returntype="struct"> 
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
    	<cfargument name="eval_id" type="numeric" required="true" />
		<cfargument name="start_on" type="string" required="false" />    
        <cfargument name="end_on" type="string" required="false" />    
        <cfargument name="type_id" type="string" required="false" />  
        
        <cfset var ls = {}>	                
        <cfset ls.retval = {"result":"OK"}>  
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                
        	UPDATE FSM_EVALUATIONS
            SET (START_ON, END_ON, TYPE_ID, MODIFIED_BY, DEL_MODIFIED_BY, MODIFIED_ON) =
            (
            	SELECT
                	TO_DATE(ARGS.START_ON,'DD/MM/YYYY'),
                    TO_DATE(ARGS.END_ON,'DD/MM/YYYY'),                   
                    ARGS.TYPE_ID,
                    ARGS.USER_ID,
                    ARGS.DEL_USER_ID,
                    SYSDATE
				FROM
                    (
                        SELECT
                                <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                                <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" /> DEL_USER_ID,
                                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                                <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
                                <cfqueryparam value="#start_on#" cfsqltype="cf_sql_varchar" null="#start_on EQ ''#"/> START_ON,
                                <cfqueryparam value="#end_on#" cfsqltype="cf_sql_varchar" null="#start_on EQ ''#"/> END_ON,                                
                                <cfqueryparam value="#type_id#" cfsqltype="cf_sql_integer" null="#type_id EQ ''#"/> TYPE_ID
                            FROM
                                DUAL  
                    ) ARGS
            )    
            WHERE
            	ID = <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" />                  
        </cfquery>      
        
        <cfreturn ls.retval>        
       
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getEvalDataQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getEvalDataQry">
        <cfquery name="qry" datasource="#Application.settings.dsn#">  
            SELECT 
                EV.ID EVAL_ID,
                EV.START_ON,
                EV.END_ON,
                EV.TYPE_ID,
                EV.STATUS_ID,
                STA.STATUS_CODE                
            FROM
                ( 
                    SELECT 
						<cfqueryparam value="#request.session.user.user_id#" cfsqltype="cf_sql_integer"> USER_ID,
                        <cfqueryparam value="#request.session.user.settings.current_field_office_id#" cfsqltype="cf_sql_integer"> OFFICE_ID,
                        <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer"> EVAL_ID,
                        <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar"> LANG_CODE
                    FROM 
                    	DUAL  
                ) ARGS,
                FSM_EVALUATIONS EV,
                FSM_EVAL_TYPES TY,
                FSM_STATUSES STA
            WHERE
                EV.ID = ARGS.EVAL_ID
                AND TY.ID(+) = EV.TYPE_ID          
                AND STA.ID(+) = EV.STATUS_ID
                AND PKG_FSM_EVALUATION.F_CHK_VIEW_EVAL(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) != 'N'                                          
        </cfquery>
        <cfreturn qry>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getStatusDataQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getStatusDataQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
    	<cfargument name="eval_id" type="numeric" required="true" />
		<cfargument name="lang_code" type="string" required="true" /> 
        
        <cfset var ls = {}>	    
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                  
            SELECT 
                ST.ID,
                ST.STATUS_CODE,
                LG.COMMENTS
            FROM
                FSM_EVALUATIONS_STATUS_LOG LG,
                FSM_STATUSES ST
            WHERE
                LG.EVAL_ID = <cfqueryparam value="#ls.doc_id#" cfsqltype="cf_sql_integer" />               
                AND LG.IS_CURRENT = 'Y'
                AND LG.STATUS_ID = ST.ID;                                    
        </cfquery>
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function saveEditPreparationQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="saveEditPreparationQry" access="public" returntype="struct">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />
    	<cfargument name="eval_id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />   
        
         <cfset var ls = {}>
         
         <cfset ls.retval = {"result":"OK"}>           
         
         <!--- file --->
         <cfif StructKeyExists(rc, "xfile") AND rc.xfile NEQ "">         
         	<cfset ls.retval = saveFile(user_id, del_user_id, eval_id, rc) />                
         </cfif>  
        
        <cfreturn ls.retval>
	</cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function insFile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="insFile" access="public" returntype="struct">
        <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />
        <cfargument name="eval_id" type="numeric" required="true" />
        <cfargument name="rc" type="struct" required="true" />          
        
        <cfset var ls = {}>  
        <cfset ls.retval = {}>   
        
        <cfset ls.retval.doc_id = 0> <!---if no file found--->     
    
		<cfif Trim(rc.xfile) NEQ "">   
        			
           <!---<cftry>--->
            
	            <cfset ls.tmp_file_dir = GetTempDirectory()>            

                <cffile 
                	action="upload"
                    filefield="xfile" 
                    destination="#ls.tmp_file_dir#" 
                    nameconflict="makeunique" 
                    accept="application/pdf, image/jpeg"
				>                    

                <cffile	
                	action = "readbinary" 
                    file = "#ls.tmp_file_dir##cffile.serverFile#" 
                    variable="ls.file_blob"
				>  
                
                <cftransaction> 
                
                    <cfquery name="ls.newIdQry" datasource="#Application.settings.dsn#">
                        SELECT
                            FSM_DOCUMENTS_SEQ.NEXTVAL doc_id
                        FROM
                            DUAL                        
                    </cfquery>
                    
                    <cfset ls.doc_id = ls.newIdQry.doc_id>
                    
                    <cfquery datasource="#Application.settings.dsn#">
                        INSERT INTO FSM_DOCUMENTS
                        (
                            ID,
                            DATA,
                            FILENAME,
                            MIME,
                            STATUS_ID,
                            CREATED_BY,
                            DEL_CREATED_BY,
                            CREATED_ON                    
                        )
                        VALUES
                        (
                            <cfqueryparam value="#ls.doc_id#" cfsqltype="cf_sql_integer" />,
                            <cfqueryparam value="#ls.file_blob#" cfsqltype="cf_sql_blob">,
                            <cfqueryparam value="#file.clientFile#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#file.contentType#/#file.contentSubType#" cfsqltype="cf_sql_varchar">,                           
                            1,
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#"/>,                        
                            SYSDATE                    
                        )                
                    </cfquery>
                
                    <cfquery datasource="#Application.settings.dsn#">
                        INSERT INTO FSM_DOCUMENTS_BY_EVAL
                        (                    	
                            EVAL_ID,
                            DOC_ID,
                            TYPE_CODE,
                            STATUS_ID,
                            CREATED_BY,
                            DEL_CREATED_BY,
                            CREATED_ON                    
                        )
                        VALUES
                        (
                            <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" />,
                            <cfqueryparam value="#ls.doc_id#" cfsqltype="cf_sql_integer" />,
                            'TYPE_CODE',
                            1,
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" />,                        
                            SYSDATE                    
                        )                
                    </cfquery>   
                
					<cfset ls.retval.doc_id = ls.doc_id>    
                    <cfset ls.retval.filename = file.clientFile>                  
                
                </cftransaction>
                
               <cffile 
                    action="delete" 
                    file="#ls.tmp_file_dir##cffile.serverFile#"
                >    
                                     
   <!---            <cfcatch type="any">     
                         
	               <cffile 
                        action="delete" 
                        file="#ls.tmp_file_dir##cffile.serverFile#"
                    >
                                 
					<cfset ls.retval = {"result":"Error when saving."}> 
                    
                </cfcatch>                              
            
            </cftry> --->
            
        </cfif> 
    
        <cfreturn ls.retval>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDocumentsByEvalQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->




	<cffunction name="getDocumentsByEvalQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
    	<cfargument name="eval_id" type="numeric" required="true" />
		<cfargument name="lang_code" type="string" required="true" /> 
        
        <cfset var ls = {}>	    
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
            SELECT
                DOCS.ID DOC_ID,
                DOCS.FILENAME,
                DOCS.MIME,
                DBE.TYPE_CODE,
                TO_CHAR(DOCS.CREATED_ON,'DD/MM/YYYY HH24:MI') CREATED_ON,
                DOCS.CREATED_BY
            FROM
                FSM_DOCUMENTS DOCS,
                FSM_DOCUMENTS_BY_EVAL DBE,
                ( 
                	SELECT
						<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
        	            <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,
            	        <cfqueryparam value="#lang_code#" cfsqltype="cf_sql_varchar" /> LANG_CODE 
                    FROM
	                    DUAL
                ) ARGS
            WHERE
                DOCS.ID = DBE.DOC_ID
                AND DBE.EVAL_ID = ARGS.EVAL_ID
                AND PKG_FSM_EVALUATION.F_CHK_VIEW_EVAL(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) != 'N'
            ORDER BY
	            DOCS.ID
        </cfquery>
        
        <cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRbuQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      

	<cffunction name="getRbuQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="participant_id" type="numeric" required="true" />   
        <cfargument name="role_code" type="string" required="true" />   
        <cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>
        
        <cfquery name="ls.rbuQry" datasource="#Application.settings.dsn#">        
            SELECT
            	RBU.ID RBU_ID,
                RBU.ROLE_ID                
            FROM
            	FSM_ROLES_BY_USER RBU,
            	FSM_ROLES RO,
                (
                	SELECT
                    	<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,   
                        <cfqueryparam value="#participant_id#" cfsqltype="cf_sql_integer" /> PARTICIPANT_ID,
                        <cfqueryparam value="#role_code#" cfsqltype="cf_sql_varchar" /> ROLE_CODE,
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID        	
					FROM
                    	DUAL                        
                ) ARGS                
            WHERE
            	RBU.USER_ID = ARGS.PARTICIPANT_ID
	            AND RBU.ROLE_ID = RO.ID
    	        AND RO.ROLE_CODE = ARGS.ROLE_CODE
        	    AND RBU.OFFICE_ID = ARGS.OFFICE_ID                     
        </cfquery>   
        
        <cfreturn ls.rbuQry>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRbeQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      

	<cffunction name="getRbeQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />
    	<cfargument name="eval_id" type="numeric" required="true" />
		<cfargument name="role_code" type="string" required="true" /> 
        <cfargument name="pos" type="numeric" required="true" /> 
        <cfargument name="participant_id" type="numeric" required="true" />   
        <cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>
        
		<cfquery name="ls.rbeQry" datasource="#Application.settings.dsn#">         
            SELECT
	            RBE.ID RBE_ID
            FROM
    	        FSM_ROLES_BY_EVAL RBE,
        	    FSM_ROLES RO,
                (
                	SELECT
                    	<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,                       
                        <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID,    
                        <cfqueryparam value="#pos#" cfsqltype="cf_sql_integer" /> POS,
                        <cfqueryparam value="#role_code#" cfsqltype="cf_sql_varchar" /> ROLE_CODE,
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID            	
					FROM
                    	DUAL                        
                ) ARGS
            WHERE
            	RBE.EVAL_ID = ARGS.EVAL_ID
	            AND RBE.ROLE_ID = RO.ID
    	        AND RO.ROLE_CODE = ARGS.ROLE_CODE
        	    AND RBE.POS = ARGS.POS  
                AND PKG_FSM_EVALUATION.F_CHK_EDIT_PREP(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) = 'Y'  
        </cfquery>   
        
        <cfreturn ls.rbeQry>        
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function insRoleQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  

	<cffunction name="insRoleQry" access="public" returntype="numeric">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
    	<cfargument name="eval_id" type="numeric" required="true" /> 
        <cfargument name="role_code" type="string" required="true" /> 
        <cfargument name="pos" type="numeric" required="true" /> 
        <cfargument name="participant_id" type="numeric" required="true" />
        <cfargument name="status_code" type="string" required="true" />           
        
        <cfset var ls = {}>        
        
        <cfset ls.rbuQry = getRbuQry(user_id, participant_id, role_code, office_id)>
        <cfset ls.rbu_id = ls.rbuQry.rbu_id>
        <cfset ls.role_id = ls.rbuQry.role_id> 
        
        <cftransaction>
        
            <cfquery name="ls.rbeIdQry" datasource="#Application.settings.dsn#">
                SELECT
                    FSM_ROLES_BY_EVAL_SEQ.NEXTVAL rbe_id
                FROM
                    DUAL                
            </cfquery> 
            
            <cfset ls.rbe_id = ls.rbeIdQry.rbe_id>     
              
            <cfquery datasource="#Application.settings.dsn#">
                INSERT INTO FSM_ROLES_BY_EVAL
                (
                    ID,
                    EVAL_ID,
                    RBU_ID,
                    ROLE_ID,
                    POS,
                    STATUS_ID,
                    CREATED_BY,
                   	DEL_CREATED_BY,
                    CREATED_ON
                )  
                SELECT
                    ARGS.RBE_ID,
                    ARGS.EVAL_ID,
                    ARGS.RBU_ID,
                    ARGS.ROLE_ID,
                    ARGS.POS,
                    ST.ID,
                    ARGS.USER_ID,
                   	ARGS.DEL_USER_ID,
                    SYSDATE
                FROM
                    (
                        SELECT	          
                            <cfqueryparam value="#ls.rbe_id#" cfsqltype="cf_sql_integer" /> RBE_ID,          
                            <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                            <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#"/> DEL_USER_ID,
                            <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                            <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID, 
                            <cfqueryparam value="#ls.rbu_id#" cfsqltype="cf_sql_integer" /> RBU_ID,
                            <cfqueryparam value="#ls.role_id#" cfsqltype="cf_sql_integer" /> ROLE_ID,
                            <cfqueryparam value="#pos#" cfsqltype="cf_sql_integer" /> POS,
                            <cfqueryparam value="#status_code#" cfsqltype="cf_sql_varchar" /> STATUS_CODE 
                        FROM
                            DUAL                        
                                    
                    ) ARGS,
                    FSM_STATUSES ST 
                WHERE
                	ST.STATUS_CODE = ARGS.STATUS_CODE
                    <!---Doesn't work: AND PKG_FSM_EVALUATION.F_CHK_EDIT_PREP(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) = 'Y' --->	                           
            </cfquery> 
        
        </cftransaction>
        
        <cfreturn ls.rbe_id>        
	</cffunction>          
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updRoleQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="updRoleQry" access="public" returntype="void">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />
		<cfargument name="office_id" type="numeric" required="true" />        
        <cfargument name="eval_id" type="numeric" required="true" />    	
		<cfargument name="role_code" type="string" required="true" /> 
        <cfargument name="pos" type="numeric" required="true" /> 
        <cfargument name="participant_id" type="numeric" required="true" />          
        
        <cfset var ls = {}>
        
		<cfset ls.rbeQry = getRbeQry(user_id, del_user_id, eval_id, role_code, pos, participant_id, office_id)> 
        <cfset ls.rbe_id = ls.rbeQry.rbe_id>   
        
        <cfset ls.rbuQry = getRbuQry(user_id, participant_id, role_code, office_id)>
        <cfset ls.rbu_id = ls.rbuQry.rbu_id>        
        
        <cftransaction>
            
            <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
                UPDATE FSM_ROLES_BY_EVAL RBE
                SET (RBE.RBU_ID, RBE.MODIFIED_BY, RBE.DEL_MODIFIED_BY, RBE.MODIFIED_ON) =
                (
                    SELECT
                        ARGS.RBU_ID,
                        ARGS.USER_ID,
                        ARGS.DEL_USER_ID,
                        SYSDATE
                    FROM
                        (
                            SELECT
                                <cfqueryparam value="#ls.rbu_id#" cfsqltype="cf_sql_integer" /> RBU_ID,
                                <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                                <cfqueryparam value="#del_user_id#" cfsqltype="cf_sql_integer" null="#del_user_id EQ ''#" /> DEL_USER_ID                                
                            FROM
                                DUAL                        
                                        
                        ) ARGS   
                    <!---doesn't work: WHERE PKG_FSM_EVALUATION.F_CHK_EDIT_PREP(ARGS.USER_ID, ARGS.OFFICE_ID) = 'Y' --->          
                )
                WHERE
                    RBE.ID = <cfqueryparam value="#ls.rbe_id#" cfsqltype="cf_sql_integer" />                     
            </cfquery>
        
        </cftransaction>       
        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function delRoleQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="delRoleQry" access="public" returntype="void">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />
		<cfargument name="office_id" type="numeric" required="true" />        
    	<cfargument name="eval_id" type="numeric" required="true" />
		<cfargument name="role_code" type="string" required="true" /> 
        <cfargument name="pos" type="numeric" required="true" /> 
        <cfargument name="participant_id" type="numeric" required="true" />   
        
        <cfset var ls = {}>       
        
        <cfset ls.rbeQry = getRbeQry(user_id, del_user_id, eval_id, role_code, pos, participant_id, office_id)>    
        <cfset ls.rbe_id = ls.rbeQry.rbe_id>  
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	FSM_ROLES_BY_EVAL RBE
            WHERE
            	RBE.ID = 
                (
                	SELECT
                    	ARGS.RBE_ID
					FROM
                    	(
                        	SELECT
                            	<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,
                                <cfqueryparam value="#ls.rbe_id#" cfsqltype="cf_sql_integer" /> RBE_ID,
                                <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID
							FROM
                            	DUAL                         
                        ) ARGS                        
                  	<!---Doesn't work: WHERE PKG_FSM_EVALUATION.F_CHK_EDIT_PREP(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) = 'Y' --->	                    
				)                        
        </cfquery>             
        
	</cffunction>                  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getEvalTypesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getEvalTypesQry">
		<cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT
	            TY.ID TYPE_ID,
    	        TY.TYPE_CODE TYPE_CODE,
                TY.STATUS_ID STATUS_ID,
        	    ST.STR TYPE
            FROM
            	FSM_EVAL_TYPES TY,
	            FSM_STRINGS ST
            WHERE
    	        TY.TYPE_CODE = ST.STR_CODE
        	    AND ST.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />
			ORDER BY
            	TY.POS                
        </cfquery>
        <cfreturn qry>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkAddEvaluation (= Create Preparation)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkAddEvaluation" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" />    
        
        <cfset var ls = {}> 

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_EVALUATION.F_CHK_CREATE_PREP(
                <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>        
        
        <cfreturn ls.qry.CHK> 
           
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkRequestAuthorization (= can request authorization from HoO)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkRequestAuthorization" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" />   
        <cfargument name="eval_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_EVALUATION.F_CHK_REQUEST_AUTHORIZATION(
                <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" />                
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkDeleteEvaluation 
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkDeleteEvaluation" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" />   
        <cfargument name="eval_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_EVALUATION.F_CHK_DELETE_EVAL(
				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> 
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkAuthorizePreparation
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkAuthorizePreparation" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" />   
        <cfargument name="eval_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_EVALUATION.F_CHK_AUTHORIZE_PREP(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> 
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkEditPreparation
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditPreparation" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" />   
        <cfargument name="eval_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_EVALUATION.F_CHK_EDIT_PREP(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> 
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewEvaluations
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewEvaluations" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_EVALUATION.F_CHK_VIEW_EVALS(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />               
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewEvaluation
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewEvaluation" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" />   
        <cfargument name="eval_id" type="numeric" required="true" />  
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_EVALUATION.F_CHK_VIEW_EVAL(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> 
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
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
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function logStatusQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="logStatusQry" access="public" returntype="struct">        
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="del_user_id" type="any" required="true" />  
        <cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="eval_id" type="numeric" required="true" />  
        <cfargument name="status_code" type="string" required="true" />    
        <cfargument name="comments" type="string" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {"result":"OK"}>  
        
        <cftransaction>
			
            <cfset insLoggedEvalStatusQry(user_id, del_user_id, office_id, eval_id, status_code, comments)>    
            <cfset updEvalStatusQry(user_id, del_user_id, office_id, eval_id, status_code)>    
        
        </cftransaction>      
        
        <cfreturn ls.retval>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getPrepCommentsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getPrepCommentsQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
		<cfargument name="eval_id" type="numeric" required="true" />       
        
        <cfset var ls = {}>	    
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                LG.ID LOG_ID,
                TO_CHAR(LG.CREATED_ON,'DD/MM/YYYY HH24:MI') CREATED_ON,
                LG.COMMENTS TEXT,
                US.FNAME || ' ' || US.LNAME AUTHOR
            FROM
                FSM_EVALUATIONS_STATUS_LOG LG,
                FSM_USERS US,
                ( 
                    SELECT 
                        <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" /> USER_ID,
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> OFFICE_ID,  
                        <cfqueryparam value="#eval_id#" cfsqltype="cf_sql_integer" /> EVAL_ID                       
                    FROM 
                        DUAL  
                ) ARGS
            WHERE
                LG.EVAL_ID = ARGS.EVAL_ID
                AND LG.CREATED_BY = US.ID
                AND LG.STATUS_ID IN
                (
                    SELECT
                    	ST.ID
                    FROM
	                    FSM_STATUSES ST
                    WHERE
    	                ST.STATUS_CODE IN ('PREP_AUTH_PENDING','PREP_AUTH_ACCEPTED','PREP_AUTH_REJECTED')
                )
                AND LG.COMMENTS IS NOT NULL
            <!---AND PKG_FSM_EVALUATION.F_CHK_VIEW_EVAL(ARGS.USER_ID, ARGS.OFFICE_ID, ARGS.EVAL_ID) != 'N'  --->
            ORDER BY
	            LG.ID 
        </cfquery>         
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getEvalueeDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getEvalueeDetailsQry" access="public" returntype="query">
	    <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
		<cfargument name="extern_id" type="numeric" required="true" /> 
        <cfargument name="lang_code" type="string" required="true" />       
        
        <cfset var ls = {}>	    
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                CO.ID CONTRACT_ID,
                CV.VERSION CONTRACT_VERSION,
                EX.ID STAFF_MEMBER_ID,
                UPPER(EX.SURNAME) LAST_NAME,
                INITCAP(EX.NAME) FIRST_NAME,
				CV.ASSIGNOFFICEID HOME_OFFICE_ID,
				INITCAP(TOF.CITY) HOME_OFFICE,
                NVL(LOWER(EMAILOFFICIAL),LOWER(EMAILPERSONAL)) EMAIL,
                TO_CHAR(CV.STARTDATE,'DD/MM/YYYY') CONTRACT_START,
                TO_CHAR(CV.ENDDATE,'DD/MM/YYYY') CONTRACT_END,
                DECODE(CV.TYPE,'LOC','NS','EXP','TS',CV.TYPE) STAFF_TYPE,
                RO.ID ROLE_ID,
                RO.NAME ROLE
            FROM
                TBL_CONTRACTS_VERSIONS CV,
                TBL_CONTRACTS CO,
                TBL_EXTERNS EX,
                TBL_ROLES RO,
                TBL_OFFICES TOF
            WHERE
                CO.ID = CV.CONTRACTID
                AND CV.PRIMARYROLEID = RO.ID
                AND EX.ID = CO.EXTERNID
                AND CV.ASSIGNOFFICEID = TOF.ID
                AND EX.ID = <cfqueryparam value="#extern_id#" cfsqltype="cf_sql_integer" />
            ORDER BY
                CV.CONTRACTID,
                CV.VERSION
        </cfquery>         
        
        <cfreturn ls.qry>
	</cffunction>      

</cfcomponent>