<cfcomponent accessors="Yes">

	<cfproperty name="evalDao">
    <cfproperty name="followupDao">
    <cfproperty name="commonDao">

    <cffunction name="deleteDocument">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT EVAL_ID FROM FSM_DOCUMENTS_BY_EVAL WHERE DOC_ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfset var eval_id = qry.EVAL_ID[1]>
        <cfquery name="del" datasource="#Application.settings.dsn#">
            DELETE FROM FSM_DOCUMENTS_BY_EVAL WHERE DOC_ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfquery name="del" datasource="#Application.settings.dsn#">
            DELETE FROM FSM_DOCUMENTS WHERE ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfset qry = variables.evalDao.getDocuments(id = local.eval_id)>
		<cfreturn qry>
	</cffunction>

    <cffunction name="uploadDocument">
        <!--- <cfdump  var="#local#"><cfabort> --->
        <cftransaction> 
            <cfquery name="newIdQry" datasource="#Application.settings.dsn#">
                SELECT FSM_DOCUMENTS_SEQ.NEXTVAL doc_id FROM DUAL
            </cfquery>

            <cfset var doc_id = newIdQry.doc_id>

            <cfquery datasource="#Application.settings.dsn#">
                INSERT INTO FSM_DOCUMENTS (ID,DATA,FILENAME,MIME,CREATED_BY,CREATED_ON)
                VALUES
                (
                    <cfqueryparam value="#local.doc_id#" cfsqltype="cf_sql_integer" />,
                    <cfif structKeyExists(ARGUMENTS, 'binaryFile') AND LEN(ARGUMENTS.binaryFile)><cfqueryparam value="#arguments.binaryFile#" cfsqltype="cf_sql_blob"><cfelse>NULL</cfif>,
                    <cfqueryparam value="#arguments.UPLOADRES.CLIENTFILE#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.UPLOADRES.CONTENTTYPE#/#arguments.UPLOADRES.CONTENTSUBTYPE#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#request.session.user.user_id#" cfsqltype="cf_sql_integer" />,                       
                    CURRENT_TIMESTAMP                     
                )
            </cfquery>
                
            <cfquery datasource="#Application.settings.dsn#">
                INSERT INTO FSM_DOCUMENTS_BY_EVAL (EVAL_ID,DOC_ID,CREATED_BY,CREATED_ON) VALUES
                (
                    <cfqueryparam value="#arguments.RC.EVALID#" cfsqltype="cf_sql_integer" />,
                    <cfqueryparam value="#local.doc_id#" cfsqltype="cf_sql_integer" />,
                    <cfqueryparam value="#request.session.user.user_id#" cfsqltype="cf_sql_integer" />,
                    CURRENT_TIMESTAMP 
                )
            </cfquery>
        </cftransaction>
        <cfset qry = variables.evalDao.getDocuments(id = arguments.rc.EVALID)>
		<cfreturn qry>
	</cffunction>

    <cffunction name="getOffices">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT DISTINCT TBL_OFFICES.ID AS OFFICE_ID , TBL_OFFICES.CITY FROM TBL_OFFICES
            INNER JOIN FSM_ROLES_BY_USER ON FSM_ROLES_BY_USER.OFFICE_ID = TBL_OFFICES.ID
            WHERE FSM_ROLES_BY_USER.USER_ID = <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">
            ORDER BY TBL_OFFICES.CITY
        </cfquery>
        <cfreturn qry>
    </cffunction>

    <cffunction name="savePrep">
        <cftransaction>
        
            <cfif arguments.viewEdit eq 'new'>
                <cfquery name="newIdQry" datasource="#Application.settings.dsn#">
                    SELECT FSM_EVALUATIONS_SEQ.NEXTVAL next_id FROM DUAL
                </cfquery>
                <cfset var eval_id = newIdQry.next_id>
                <cfquery datasource="#Application.settings.dsn#">
                    INSERT INTO FSM_EVALUATIONS (ID,CREATED_BY,CREATED_ON,OFFICE_ID,START_ON,END_ON,TYPE_ID,MODIFIED_BY) VALUES
                    (
                        <cfqueryparam value="#local.eval_id#" cfsqltype="CF_SQL_DECIMAL">,
                        <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">,
                        CURRENT_TIMESTAMP,
                        <cfqueryparam value="#request.session.user.settings.current_field_office_id#" cfsqltype="CF_SQL_DECIMAL">,
                        <cfif structKeyExists(ARGUMENTS.dt, 'evaluation_period_start') AND LEN(ARGUMENTS.dt.evaluation_period_start)><cfqueryparam value="#arguments.dt.evaluation_period_start#" cfsqltype="CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
                        <cfif structKeyExists(ARGUMENTS.dt, 'evaluation_period_end') AND LEN(ARGUMENTS.dt.evaluation_period_end)><cfqueryparam value="#arguments.dt.evaluation_period_end#" cfsqltype="CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
                        <cfqueryparam value="#arguments.evalType#" cfsqltype="CF_SQL_DECIMAL">,
                        <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">
                    )
                </cfquery>
            <cfelse>
                <cfset var eval_id = arguments.evalId>
            </cfif>

            <cfset var commonObj =  getCommonDao()>
            <cfset var evaluees = structKeyExists(FORM, 'evaluees') ? FORM.evaluees : ''> <!--- EVALUATED --->
            <cfset var supervisors = structKeyExists(FORM, 'supervisors') ? FORM.supervisors : ''> <!--- EVALUATOR --->
            <cfset var contributors = structKeyExists(FORM, 'contributors') ? commonObj.CollectionToList(FORM.contributors, "|") : ''> <!--- CONTRIBUTORS --->
            <cfset var preparators = structKeyExists(FORM, 'preparators') ? commonObj.CollectionToList(FORM.preparators, "|") : request.session.user.user_id> <!--- D4 --->
            <cfset var heads = structKeyExists(FORM, 'heads') ? FORM.heads : ''> <!--- HEAD OF UNIT --->
            
            <cfset var participants = "">
            <cfset var participants = ListAppend(participants, evaluees, "|")>
            <cfset var participants = ListAppend(participants, supervisors, "|")>
            <cfset var participants = ListAppend(participants, contributors, "|")>
            <cfset var participants = ListAppend(participants, preparators, "|")>
            <cfset var participants = ListAppend(participants, heads, "|")>
            <cfset var participants = "|" &  participants & "|">

            <cfset var offices = structKeyExists(FORM, 'offices') ? FORM.offices : request.session.user.settings.current_field_office_id>      

            <cfquery datasource="#Application.settings.dsn#">
                UPDATE FSM_EVALUATIONS SET
                EVALUEE_ID = <cfif structKeyExists(FORM, 'evaluees')><cfqueryparam value="#LOCAL.evaluees#" cfsqltype="CF_SQL_DECIMAL"><cfelse>NULL</cfif>,
                PARTICIPANTS = <cfqueryparam value="#LOCAL.participants#" cfsqltype="CF_SQL_VARCHAR">,
                EVALUATORS = <cfif structKeyExists(FORM, 'supervisors')><cfqueryparam value="#LOCAL.supervisors#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
                CONTRIBUTORS = <cfif structKeyExists(FORM, 'contributors')><cfqueryparam value="#LOCAL.contributors#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
                PREPARATORS = <cfif structKeyExists(FORM, 'preparators')><cfqueryparam value="#LOCAL.preparators#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
                HEADS = <cfif structKeyExists(FORM, 'heads')><cfqueryparam value="#LOCAL.heads#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
                DETAILS = <cfqueryparam value="#serializeJSON(FORM)#" cfsqltype="CF_SQL_VARCHAR">,
                MODIFIED_BY = <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">,
                START_ON = <cfif structKeyExists(ARGUMENTS.dt, 'evaluation_period_start') AND LEN(ARGUMENTS.dt.evaluation_period_start)><cfqueryparam value="#arguments.dt.evaluation_period_start#" cfsqltype="CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
                END_ON = <cfif structKeyExists(ARGUMENTS.dt, 'evaluation_period_end') AND LEN(ARGUMENTS.dt.evaluation_period_end)><cfqueryparam value="#arguments.dt.evaluation_period_end#" cfsqltype="CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
                OFFICE_ID = <cfqueryparam value="#LOCAL.offices#" cfsqltype="CF_SQL_DECIMAL">,
                MODIFIED_ON = CURRENT_TIMESTAMP
                WHERE ID = <cfqueryparam value="#LOCAL.eval_id#" cfsqltype="CF_SQL_DECIMAL">
            </cfquery>
            
            <!--- <cfquery datasource="#Application.settings.dsn#">
                 DELETE FROM FSM_EVALUATIONS_DETAILS WHERE EVAL_ID = <cfqueryparam value="#local.eval_id#" cfsqltype="CF_SQL_DECIMAL">
            </cfquery>
            <cfloop collection="#FORM#" item="eval"> 
                <cfset var val = serializeJSON(FORM[eval])>
                <cfquery datasource="#Application.settings.dsn#">
                    INSERT INTO FSM_EVALUATIONS_DETAILS (EVAL_ID,PROPERTY,VALUE) VALUES
                    (
                        <cfqueryparam value="#local.eval_id#" cfsqltype="CF_SQL_DECIMAL">,
                        <cfqueryparam value="#eval#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#local.val#" cfsqltype="CF_SQL_VARCHAR">
                    )
                </cfquery>
            </cfloop>  --->
            <cfquery name="qry" datasource="#Application.settings.dsn#">
                SELECT ID,
                START_ON,
                END_ON,
                STATUS_ID,
                TYPE_ID,
                CREATED_BY,
                DEL_CREATED_BY,
                CREATED_ON,
                MODIFIED_BY,
                DEL_MODIFIED_BY,
                MODIFIED_ON,
                COMMENTS_1,
                COMMENTS_2,
                OFFICE_ID,
                EVALUEE_ID,
                PARTICIPANTS,
                EVALUATORS,
                CONTRIBUTORS,
                PREPARATORS,
                HEADS
                FROM FSM_EVALUATIONS WHERE ID = <cfqueryparam value="#local.eval_id#" cfsqltype="CF_SQL_DECIMAL">
            </cfquery>
        </cftransaction>

        <cfreturn qry>
    </cffunction>

    <cffunction name="getPrepData">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT * FROM FSM_EVALUATIONS WHERE ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfset local.ret = structNew()>
        <cfset local.followups = variables.followupDao.getFollowUps(evalId = arguments.id)>
        <cfset local.ret['DETAILS'] = deserializeJSON(qry.DETAILS[1])>
        <cfset local.ret['FOLLOWUPS'] = StructCount(local.followups)>
        <cfreturn local.ret>
    </cffunction>

    <cffunction name="getPrepDataQry">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT FSM_EVALUATIONS.*,  FSM_STRINGS.STR AS TYPE FROM FSM_EVALUATIONS 
            INNER JOIN FSM_USERS ON FSM_EVALUATIONS.EVALUEE_ID = FSM_USERS.ID
            INNER JOIN FSM_EVAL_TYPES ON FSM_EVALUATIONS.TYPE_ID = FSM_EVAL_TYPES.ID
            INNER JOIN FSM_STRINGS ON FSM_EVAL_TYPES.TYPE_CODE = FSM_STRINGS.STR_CODE AND FSM_STRINGS.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar">
            WHERE FSM_EVALUATIONS.ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfreturn qry>
    </cffunction>    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function logStatus
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="logStatus" access="public" returntype="struct">        
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
            <cfset updEvalStatus(user_id, del_user_id, office_id, eval_id, status_code)>    
        
        </cftransaction>      
        
        <cfreturn ls.retval>        
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
	Function updEval
	!!! Add F_CHK_EDIT_PREP()
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   
    
	<cffunction name="updEval" access="public" returntype="struct"> 
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
	Function updEvalStatus
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="updEvalStatus" access="public" returntype="struct">
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
        
		<cfset ls.getFbeQry = evalDao.getFbeQry(user_id, office_id, eval_id, phase_code)>                  
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
	Function getFbeQry
	Fbe: phases by evaluation
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 
<!---
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
	</cffunction> --->     
    
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
    
    <cffunction name="maintenanceEvalStruct2Arr">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT * FROM FSM_EVALUATIONS
        </cfquery>

        <cfloop query="qry">
            <cfset var tmpStruc =  deserializeJSON(DETAILS)>

            <cfif structKeyExists(tmpStruc, 'contributors') AND isStruct(tmpStruc.contributors)>
                <cfset tmpStruc.contributors = variables.commonDao.StructureToArray(tmpStruc.contributors)>
            </cfif>

            <cfif structKeyExists(tmpStruc, 'preparators') AND isStruct(tmpStruc.preparators)>
                <cfset tmpStruc.preparators = variables.commonDao.StructureToArray(tmpStruc.preparators)>
            </cfif>                

            <cfset qry.DETAILS[qry.CurrentRow] = serializeJSON(tmpStruc)>

            <cfquery datasource="#Application.settings.dsn#">
                UPDATE FSM_EVALUATIONS SET
                DETAILS = <cfqueryparam value="#serializeJSON(tmpStruc)#" cfsqltype="CF_SQL_VARCHAR">
                WHERE ID = <cfqueryparam value="#qry.ID[qry.CurrentRow]#" cfsqltype="CF_SQL_DECIMAL">
            </cfquery>

            <cfdump var="#tmpStruc#">
        </cfloop> 

        <cfdump var="#qry#">

        <cfabort>
    </cffunction>
</cfcomponent>    