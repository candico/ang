<cfcomponent accessors="Yes">

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getObjectivesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getObjectives">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT FSM_OBJECTIVES.ID AS OBJECTIVE_ID, FSM_STRINGS.STR AS OBJECTIVE
            FROM FSM_OBJECTIVES 
            INNER JOIN FSM_STRINGS
            ON FSM_OBJECTIVES.OBJECTIVE_DESC_CODE = FSM_STRINGS.STR_CODE
            WHERE LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />
            ORDER BY FSM_OBJECTIVES.ID ASC
        </cfquery>
		<cfreturn qry>
    </cffunction>

	<cffunction name="getCompetencies">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT FSM_COMPETENCIES.ID AS COMPETENCY_ID, FSM_STRINGS.STR AS COMPETENCY
            FROM FSM_COMPETENCIES
            INNER JOIN FSM_STRINGS
            ON FSM_COMPETENCIES.COMPETENCY_DESC_CODE = FSM_STRINGS.STR_CODE 
            WHERE LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />
            ORDER BY FSM_COMPETENCIES.ID ASC
        </cfquery>
		<cfreturn qry>
    </cffunction>

	<cffunction name="getSass">
        <cfquery name="qry" datasource="#Application.settings.dsn#">          
            SELECT FSM_STRINGS_COMP.STR AS COMPETENCY, FSM_STRINGS_OBJ.STR AS OBJECTIVE, FSM_SASS.*
            FROM FSM_SASS
            LEFT JOIN FSM_COMPETENCIES ON FSM_SASS.COMPETENCY_ID = FSM_COMPETENCIES.ID
            LEFT JOIN FSM_OBJECTIVES ON FSM_SASS.OBJECTIVE_ID = FSM_OBJECTIVES.ID
            LEFT JOIN FSM_STRINGS FSM_STRINGS_COMP ON FSM_COMPETENCIES.COMPETENCY_DESC_CODE = FSM_STRINGS_COMP.STR_CODE 
            AND FSM_STRINGS_COMP.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />
            LEFT JOIN FSM_STRINGS FSM_STRINGS_OBJ ON FSM_OBJECTIVES.OBJECTIVE_DESC_CODE = FSM_STRINGS_OBJ.STR_CODE 
            AND FSM_STRINGS_OBJ.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />
            WHERE FSM_SASS.EVAL_ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
            AND FSM_SASS.PERIOD_ID = <cfqueryparam value="1" cfsqltype="CF_SQL_DECIMAL">
            ORDER BY FSM_SASS.ID ASC
        </cfquery>
		<cfreturn qry>
    </cffunction>

	<cffunction name="getNextYearObjectives">
        <cfquery name="qry" datasource="#Application.settings.dsn#">          
            SELECT FSM_STRINGS_COMP.STR AS COMPETENCY, FSM_STRINGS_OBJ.STR AS OBJECTIVE, FSM_SASS.*
            FROM FSM_SASS
            LEFT JOIN FSM_COMPETENCIES ON FSM_SASS.COMPETENCY_ID = FSM_COMPETENCIES.ID
            LEFT JOIN FSM_OBJECTIVES ON FSM_SASS.OBJECTIVE_ID = FSM_OBJECTIVES.ID
            LEFT JOIN FSM_STRINGS FSM_STRINGS_COMP ON FSM_COMPETENCIES.COMPETENCY_DESC_CODE = FSM_STRINGS_COMP.STR_CODE
            AND FSM_STRINGS_COMP.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />
            LEFT JOIN FSM_STRINGS FSM_STRINGS_OBJ ON FSM_OBJECTIVES.OBJECTIVE_DESC_CODE = FSM_STRINGS_OBJ.STR_CODE
            AND FSM_STRINGS_OBJ.LANG_CODE = <cfqueryparam value="#request.session.user.settings.displayLanguage#" cfsqltype="cf_sql_varchar" />
            WHERE FSM_SASS.EVAL_ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
            AND FSM_SASS.PERIOD_ID = <cfqueryparam value="2" cfsqltype="CF_SQL_DECIMAL">
            ORDER BY FSM_SASS.ID ASC
        </cfquery>
		<cfreturn qry>
    </cffunction>

	<cffunction name="updateEval">
        <cfquery name="upd" datasource="#Application.settings.dsn#">          
            UPDATE FSM_SASS SET 
            SELF_ASSESSMENT = <cfif structKeyExists(ARGUMENTS, 'SELF_ASSESSMENT') AND LEN(ARGUMENTS.SELF_ASSESSMENT)><cfqueryparam value="#arguments.SELF_ASSESSMENT#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            LEARNING_ACTIVITY = <cfif structKeyExists(ARGUMENTS, 'LEARNING_ACTIVITY') AND LEN(ARGUMENTS.LEARNING_ACTIVITY)><cfqueryparam value="#arguments.LEARNING_ACTIVITY#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            OBJECTIVE_ID = <cfif structKeyExists(ARGUMENTS, 'OBJECTIVE_ID') AND LEN(ARGUMENTS.OBJECTIVE_ID)><cfqueryparam value="#arguments.OBJECTIVE_ID#" cfsqltype="CF_SQL_DECIMAL"><cfelse>NULL</cfif>,
            COMPETENCY_ID = <cfif structKeyExists(ARGUMENTS, 'COMPETENCY_ID') AND LEN(ARGUMENTS.COMPETENCY_ID)><cfqueryparam value="#arguments.COMPETENCY_ID#" cfsqltype="CF_SQL_DECIMAL"><cfelse>NULL</cfif>,
            USER_ID = <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">,
            EVALUATOR_ASSESSMENT = <cfif structKeyExists(ARGUMENTS, 'EVALUATOR_ASSESSMENT') AND LEN(ARGUMENTS.EVALUATOR_ASSESSMENT)><cfqueryparam value="#arguments.EVALUATOR_ASSESSMENT#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            PERFORMANCE_LEVEL = <cfif structKeyExists(ARGUMENTS, 'PERFORMANCE_LEVEL') AND LEN(ARGUMENTS.PERFORMANCE_LEVEL)><cfqueryparam value="#arguments.PERFORMANCE_LEVEL#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            UPDATED_ON = CURRENT_TIMESTAMP
            WHERE ID = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT * FROM FSM_SASS WHERE ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>         
		<cfreturn qry>
	</cffunction>

    <cffunction name="deleteEval">
        <cfquery name="del" datasource="#Application.settings.dsn#">
            DELETE FROM FSM_SASS WHERE ID = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="insertEval">
    <!--- <cfdump  var="#local#"><cfabort> --->
        <cftransaction>
            <cfquery name="ins" datasource="#Application.settings.dsn#">
                INSERT INTO FSM_SASS (USER_ID, PERIOD_ID, EVAL_ID) VALUES (
                <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">,
                <cfqueryparam value="#arguments.period#" cfsqltype="CF_SQL_DECIMAL">,
                <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
                )
            </cfquery>
            <cfquery name="qry" datasource="#Application.settings.dsn#">
                SELECT * FROM FSM_SASS WHERE ID = (SELECT MAX(ID) FROM FSM_SASS)
            </cfquery>
        </cftransaction>
		<cfreturn qry>
	</cffunction>

</cfcomponent>