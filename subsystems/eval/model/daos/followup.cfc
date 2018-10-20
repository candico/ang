<cfcomponent accessors="Yes">

<!--- 
    update FSM_EVALUATIONS tab1 SET FOLLOWUP =  NVL((select sum(REQUEST_FOLLOW_UP) as FOLLOWUP 
    from FSM_EVALUATIONS_STATUS_LOG tab2
    WHERE tab1.ID = tab2.EVAL_ID
    group by tab2.EVAL_ID), 0);
 --->

    <cffunction name="getFollowUpTypes">
        <cfquery name="qry">
            SELECT FSM_EVALUATIONS_FOLLOWUP_TYPES.ID, FSM_STRINGS.STR AS FOLLOWUP_TYPE
            FROM FSM_EVALUATIONS_FOLLOWUP_TYPES
            INNER JOIN FSM_STRINGS ON FSM_EVALUATIONS_FOLLOWUP_TYPES.TYPE_CODE = FSM_STRINGS.STR_CODE 
            AND FSM_STRINGS.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar">
            ORDER BY FSM_EVALUATIONS_FOLLOWUP_TYPES.ID
        </cfquery>
        <cfreturn qry>
    </cffunction>

    <cffunction name="insertFollowUp">
        <cftransaction>
            <cfquery>
                INSERT INTO FSM_EVALUATIONS_FOLLOWUP (EVAL_ID, TYPE_ID, CREATED_BY, CREATED_ON)
                SELECT 
                <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL"> AS EVAL_ID,
                0 AS TYPE_ID,
                <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL"> AS CREATED_BY,
                CURRENT_TIMESTAMP AS CREATED_ON
                FROM DUAL WHERE ( 
                    SELECT ID FROM FSM_EVALUATIONS_FOLLOWUP 
                    WHERE EVAL_ID = <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL">
                    AND TYPE_ID = 0
                    AND CREATED_BY = <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">
                ) IS NULL
            </cfquery>
            <cfquery name="qry">
                SELECT * FROM FSM_EVALUATIONS_FOLLOWUP WHERE ID = (SELECT MAX(ID) FROM FSM_EVALUATIONS_FOLLOWUP)
            </cfquery>
        </cftransaction>
		<cfreturn qry>
	</cffunction>


	<cffunction name="updateFollowUp">
    <!--- <cfdump  var="#arguments#"><cfabort> --->
        <cfquery>          
            UPDATE FSM_EVALUATIONS_FOLLOWUP SET 
            DESCRIPTION = <cfif structKeyExists(ARGUMENTS, 'DESCRIPTION')><cfqueryparam value="#arguments.DESCRIPTION#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            RESOLUTION = <cfif structKeyExists(ARGUMENTS, 'RESOLUTION')><cfqueryparam value="#arguments.RESOLUTION#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            TYPE_ID = <cfif structKeyExists(ARGUMENTS, 'TYPE_ID')><cfqueryparam value="#arguments.TYPE_ID#" cfsqltype="CF_SQL_DECIMAL"><cfelse>0</cfif>,
            UPDATED_ON = CURRENT_TIMESTAMP
            WHERE ID = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfquery name="qry">
            SELECT * FROM FSM_EVALUATIONS_FOLLOWUP WHERE ID = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
		<cfreturn qry>
	</cffunction>
    
    <cffunction name="deleteFollowUp">
        <cfquery>          
            DELETE FROM FSM_EVALUATIONS_FOLLOWUP WHERE ID = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfreturn structNew()>
    </cffunction>

	<cffunction name="getFollowUps">
        <cfquery name="qryEval">
            SELECT * FROM FSM_EVALUATIONS WHERE ID = <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>

        <cfquery name="qryClosure">
            SELECT DISTINCT 
            FSM_USERS.ID AS USER_ID,
            FSM_USERS.FNAME,
            FSM_USERS.LNAME 
            FROM FSM_EVALUATIONS_STATUS_LOG 
            INNER JOIN FSM_USERS ON FSM_EVALUATIONS_STATUS_LOG.CREATED_BY = FSM_USERS.ID
            WHERE FSM_EVALUATIONS_STATUS_LOG.EVAL_ID = <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL">
            AND FSM_EVALUATIONS_STATUS_LOG.REQUEST_FOLLOW_UP = 1
        </cfquery>

        <cfset local.preparatorsArr = listToArray(qryEval.PREPARATORS[1],"|")>
        <cfset local.preparatorsList = arrayToList(local.preparatorsArr, ",")>

        <cfif listFind(local.preparatorsList, request.session.user.user_id)>
            <cfset local.participants = valueList(qryClosure.USER_ID)>
        <cfelseif qryEval.EVALUATORS[1] eq request.session.user.user_id>
            <cfset local.participants = request.session.user.user_id>
        <cfelseif qryEval.EVALUEE_ID[1] eq request.session.user.user_id>
            <cfset local.participants = request.session.user.user_id>
        <cfelse>
            <cfset local.participants = request.session.user.user_id>
            <!--- this should not happen, menas that user is not among aprticipants, but to escape errors --->
        </cfif>

        <!--- 
        <cfdump  var="#request.session.user#">
        <cfdump  var="#local#"><cfabort> 
        --->

        <cfset local.ret = structNew()>

        <!--- <cfset local.participants_follow_up = ValueArray(qryClosure, 'USER_ID')> --->
        <!--- <cfloop array="#local.participants_follow_up#" index="currentItem"> --->
		<cfloop query="qryClosure">
            <cfif listFind(local.participants, qryClosure.USER_ID)>
                <cfquery name="qryFollowUp">
                    SELECT <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL"> AS EVAL_ID,
                    FSM_USERS.ID AS USER_ID,
                    FSM_USERS.FNAME,
                    FSM_USERS.LNAME,
                    NVL(FSM_EVALUATIONS_FOLLOWUP.ID, 0) AS ID,
                    FSM_EVALUATIONS_FOLLOWUP.CREATED_BY,
                    FSM_EVALUATIONS_FOLLOWUP.DESCRIPTION,
                    FSM_EVALUATIONS_FOLLOWUP.RESOLUTION,
                    FSM_EVALUATIONS_FOLLOWUP.CREATED_ON,
                    FSM_EVALUATIONS_FOLLOWUP.UPDATED_ON,
                    FSM_EVALUATIONS_FOLLOWUP_TYPES.ID AS TYPE_ID,
                    FSM_STRINGS.STR AS FOLLOWUP_TYPE
                    FROM FSM_EVALUATIONS_FOLLOWUP_TYPES
                    INNER JOIN FSM_STRINGS ON FSM_EVALUATIONS_FOLLOWUP_TYPES.TYPE_CODE = FSM_STRINGS.STR_CODE 
                    AND FSM_STRINGS.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar">
                    INNER JOIN FSM_USERS ON FSM_USERS.ID = <cfqueryparam value="#qryClosure.USER_ID#" cfsqltype="CF_SQL_DECIMAL">
                    LEFT JOIN FSM_EVALUATIONS_FOLLOWUP ON FSM_EVALUATIONS_FOLLOWUP.TYPE_ID = FSM_EVALUATIONS_FOLLOWUP_TYPES.ID 
                    AND FSM_EVALUATIONS_FOLLOWUP.EVAL_ID = <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL"> 
                    AND FSM_EVALUATIONS_FOLLOWUP.CREATED_BY = <cfqueryparam value="#qryClosure.USER_ID#" cfsqltype="CF_SQL_DECIMAL">
                </cfquery>
                <cfset local.ret[qryClosure.USER_ID] = qryFollowUp>
            </cfif>
		</cfloop>

        <!--- <cfquery name="qry">
            SELECT
            FSM_EVALUATIONS_STATUS_LOG.EVAL_ID, 
            FSM_USERS.ID AS USER_ID,
            FSM_USERS.FNAME,
            FSM_USERS.LNAME,
            NVL(FSM_EVALUATIONS_FOLLOWUP.ID, 0) AS ID,
            FSM_EVALUATIONS_FOLLOWUP.CREATED_BY,
            FSM_EVALUATIONS_FOLLOWUP.TYPE_ID,
            FSM_EVALUATIONS_FOLLOWUP.DESCRIPTION,
            FSM_EVALUATIONS_FOLLOWUP.RESOLUTION,
            FSM_EVALUATIONS_FOLLOWUP.CREATED_ON,
            FSM_EVALUATIONS_FOLLOWUP.UPDATED_ON,
            FSM_STRINGS.STR AS FOLLOWUP_TYPE
            FROM FSM_EVALUATIONS
            INNER JOIN FSM_EVALUATIONS_STATUS_LOG ON FSM_EVALUATIONS.ID = FSM_EVALUATIONS_STATUS_LOG.EVAL_ID AND FSM_EVALUATIONS_STATUS_LOG.REQUEST_FOLLOW_UP = 1
            INNER JOIN FSM_USERS ON FSM_EVALUATIONS_STATUS_LOG.CREATED_BY = FSM_USERS.ID
            LEFT JOIN FSM_EVALUATIONS_FOLLOWUP ON FSM_EVALUATIONS.ID = FSM_EVALUATIONS_FOLLOWUP.EVAL_ID AND FSM_EVALUATIONS_STATUS_LOG.CREATED_BY = FSM_EVALUATIONS_FOLLOWUP.CREATED_BY
            LEFT JOIN FSM_EVALUATIONS_FOLLOWUP_TYPES ON FSM_EVALUATIONS_FOLLOWUP.TYPE_ID = FSM_EVALUATIONS_FOLLOWUP_TYPES.ID 
            LEFT JOIN FSM_STRINGS ON FSM_EVALUATIONS_FOLLOWUP_TYPES.TYPE_CODE = FSM_STRINGS.STR_CODE AND FSM_STRINGS.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar">
            WHERE FSM_EVALUATIONS.ID = <cfqueryparam value="#arguments.evalId#" cfsqltype="CF_SQL_DECIMAL">
            AND FSM_EVALUATIONS_STATUS_LOG.CREATED_BY IN (<cfqueryparam value="#local.participants#" cfsqltype="CF_SQL_DECIMAL" list="yes">)
        </cfquery> --->

        <cfreturn local.ret>
    </cffunction>


</cfcomponent>