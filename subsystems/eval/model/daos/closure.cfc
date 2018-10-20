<cfcomponent accessors="Yes">

    <cfproperty name="followupDao">

	<cffunction name="getClosureComments">
        <cfquery name="qry">
            SELECT FSM_USERS.FNAME, FSM_USERS.LNAME, FSM_EVALUATIONS_STATUS_LOG.*
            FROM FSM_EVALUATIONS_STATUS_LOG INNER JOIN FSM_USERS ON FSM_EVALUATIONS_STATUS_LOG.CREATED_BY = FSM_USERS.ID
            WHERE FSM_EVALUATIONS_STATUS_LOG.EVAL_ID = <cfqueryparam value="#arguments.EVAL_ID#" cfsqltype="CF_SQL_DECIMAL">
            ORDER BY FSM_EVALUATIONS_STATUS_LOG.ID
        </cfquery>
        <cfreturn qry>
    </cffunction>

	<cffunction name="insertClosure">
        <cftransaction>
            <cfquery>
                INSERT INTO FSM_EVALUATIONS_STATUS_LOG (CREATED_BY, EVAL_ID, CREATED_ON)
                SELECT <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL"> AS CREATED_BY,
                <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL"> AS EVAL_ID,
                CURRENT_TIMESTAMP AS CREATED_ON 
                FROM DUAL WHERE ( 
                    SELECT ID FROM FSM_EVALUATIONS_STATUS_LOG 
                    WHERE EVAL_ID = <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL">
                    AND CREATED_BY = <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">
                ) IS NULL
            </cfquery>
            <cfquery name="qry">
                SELECT FSM_USERS.FNAME, FSM_USERS.LNAME, FSM_EVALUATIONS_STATUS_LOG.*
                FROM FSM_EVALUATIONS_STATUS_LOG INNER JOIN FSM_USERS ON FSM_EVALUATIONS_STATUS_LOG.CREATED_BY = FSM_USERS.ID
                WHERE FSM_EVALUATIONS_STATUS_LOG.ID = (SELECT MAX(ID) FROM FSM_EVALUATIONS_STATUS_LOG)
            </cfquery>
        </cftransaction>
		<cfreturn qry>
	</cffunction>

	<cffunction name="updateClosure">
        <cfquery>
            UPDATE FSM_EVALUATIONS_STATUS_LOG SET 
            COMMENTS = <cfif structKeyExists(ARGUMENTS, 'COMMENTS')><cfqueryparam value="#arguments.COMMENTS#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            REQUEST_FOLLOW_UP = <cfif structKeyExists(ARGUMENTS, 'REQUEST_FOLLOW_UP')><cfqueryparam value="#arguments.REQUEST_FOLLOW_UP#" cfsqltype="CF_SQL_DECIMAL"><cfelse>NULL</cfif>,
            EVALUATION_PERFORMED = <cfif structKeyExists(ARGUMENTS, 'EVALUATION_PERFORMED')><cfqueryparam value="#arguments.EVALUATION_PERFORMED#" cfsqltype="CF_SQL_DECIMAL"><cfelse>NULL</cfif>,
            READ_ACKNOWLEDGED = <cfif structKeyExists(ARGUMENTS, 'READ_ACKNOWLEDGED')><cfqueryparam value="#arguments.READ_ACKNOWLEDGED#" cfsqltype="CF_SQL_DECIMAL"><cfelse>NULL</cfif>,
            SUBMIT_DATE = <cfif structKeyExists(ARGUMENTS, 'SUBMIT_DATE') AND LEN(ARGUMENTS.SUBMIT_DATE)><cfqueryparam value="#arguments.SUBMIT_DATE#" cfsqltype="CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
            UPDATED_ON = CURRENT_TIMESTAMP
            WHERE ID = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfset local.ret = structNew()>
        <cfset local.followups = variables.followupDao.getFollowUps(evalId = arguments.EVAL_ID)>
        <cfset local.ret['DETAILS'] = getClosureComments(argumentcollection = arguments)>
        <cfset local.ret['FOLLOWUPS'] = StructCount(local.followups)>
		<cfreturn local.ret>
	</cffunction>

	<cffunction name="getClosure">
        <cfquery name="qry">
            SELECT FSM_USERS.FNAME, FSM_USERS.LNAME, FSM_EVALUATIONS_STATUS_LOG.*
            FROM FSM_EVALUATIONS_STATUS_LOG INNER JOIN FSM_USERS ON FSM_EVALUATIONS_STATUS_LOG.CREATED_BY = FSM_USERS.ID
            WHERE FSM_EVALUATIONS_STATUS_LOG.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfreturn qry>
    </cffunction>

    <cffunction name="deleteClosure">
        <cfquery name="del">
            DELETE FROM FSM_EVALUATIONS_STATUS_LOG WHERE ID = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfset local.ret = structNew()>
        <cfset local.followups = variables.followupDao.getFollowUps(evalId = arguments.EVAL_ID)>
        <cfset local.ret['DETAILS'] = getClosureComments(argumentcollection = arguments)>
        <cfset local.ret['FOLLOWUPS'] = StructCount(local.followups)>
		<cfreturn local.ret>
	</cffunction>
</cfcomponent>