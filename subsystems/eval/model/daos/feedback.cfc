<cfcomponent accessors="Yes">

	<cffunction name="getFeedbackQuestions">
      
        <cfquery name="qryQ" datasource="#Application.settings.dsn#">
            SELECT * FROM FSM_EVALUATIONS_FEEDBACK_FORMQ ORDER BY ID
        </cfquery>

        <cfquery name="qryC" datasource="#Application.settings.dsn#">
           SELECT CONTRIBUTORS FROM FSM_EVALUATIONS WHERE ID=<cfqueryparam value="#arguments.Eid#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>

        <cfset local.contributorsArr = listToArray(qryC.CONTRIBUTORS[1],"|")>
        <cfset local.contributorsList = arrayToList(local.contributorsArr, ",")>

        <cfif listFind(local.contributorsList,request.session.user.user_id)>
            <cfset local.contributorsList = request.session.user.user_id>
        </cfif>

        <cfquery name="qryC" datasource="#Application.settings.dsn#">
            SELECT U.* FROM FSM_USERS U WHERE U.ID IN (#local.contributorsList#)
        </cfquery>

        <cfset var ret = structNew()>
        <cfset ret['questions'] = qryQ>
        <cfset ret['contributors'] = qryC>

        <cfloop index="contributor" list="#local.contributorsList#">
            <cfquery name="qryA" datasource="#Application.settings.dsn#">
                SELECT Q.ID Q_ID, A.ANSWER, A.ANSWER_DATE_TIME, A.CONTRIBUTOR_ID, A.EVAL_ID, A.ID A_ID, A.STATUS
                FROM FSM_EVALUATIONS_FEEDBACK_FORMQ Q
                LEFT JOIN FSM_EVALUATIONS_FEEDBACK_FORMA A ON Q.ID = A.QUESTION_ID 
                AND A.EVAL_ID = <cfqueryparam value="#arguments.Eid#" cfsqltype="CF_SQL_DECIMAL">
                AND A.CONTRIBUTOR_ID = #contributor#
                ORDER BY Q.ID
            </cfquery>
            <cfset ret['answers'][contributor] = qryA>
		</cfloop>

        <cfreturn ret>
    </cffunction>

    <cffunction name="getFeedbackAnswers">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT FSM_EVALUATIONS_FEEDBACK_FORMA.*, FSM_USERS.FNAME, FSM_USERS.LNAME FROM FSM_EVALUATIONS_FEEDBACK_FORMA 
            INNER JOIN FSM_USERS ON FSM_EVALUATIONS_FEEDBACK_FORMA.CONTRIBUTOR_ID = FSM_USERS.ID
            WHERE EVAL_ID= <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
		<cfreturn qry>
    </cffunction>

	<cffunction name="insertFeedback">
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT Q.ID Q_ID, Q.QUESTION, A.ANSWER, A.ANSWER_DATE_TIME, A.CONTRIBUTOR_ID, A.EVAL_ID, A.ID A_ID, A.STATUS
            FROM FSM_EVALUATIONS_FEEDBACK_FORMQ Q
            INNER JOIN FSM_EVALUATIONS_FEEDBACK_FORMA A ON Q.ID = A.QUESTION_ID 
            WHERE A.EVAL_ID = <cfqueryparam value="#arguments.Eid#" cfsqltype="CF_SQL_DECIMAL">
            AND A.QUESTION_ID = <cfqueryparam value="#arguments.Qid#" cfsqltype="CF_SQL_DECIMAL">
            AND A.CONTRIBUTOR_ID = <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>

        <cfif qry.RecordCount eq 0>
            <cftransaction>
                <cfquery name="ins" datasource="#Application.settings.dsn#">
                    INSERT INTO FSM_EVALUATIONS_FEEDBACK_FORMA (CONTRIBUTOR_ID, QUESTION_ID, EVAL_ID, ANSWER_DATE_TIME) 
                    SELECT <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL"> AS CONTRIBUTOR_ID,
                    <cfqueryparam value="#arguments.Qid#" cfsqltype="CF_SQL_DECIMAL"> AS QUESTION_ID,
                    <cfqueryparam value="#arguments.Eid#" cfsqltype="CF_SQL_DECIMAL"> AS EVAL_ID,
                    CURRENT_TIMESTAMP AS ANSWER_DATE_TIME 
                    FROM DUAL WHERE ( 
                        SELECT ID FROM FSM_EVALUATIONS_FEEDBACK_FORMA 
                        WHERE EVAL_ID = <cfqueryparam value="#arguments.Eid#" cfsqltype="CF_SQL_DECIMAL">
                        AND QUESTION_ID = <cfqueryparam value="#arguments.Qid#" cfsqltype="CF_SQL_DECIMAL">
                        AND CONTRIBUTOR_ID = <cfqueryparam value="#request.session.user.user_id#" cfsqltype="CF_SQL_DECIMAL">
                    ) IS NULL
                </cfquery>
                <cfquery name="qry" datasource="#Application.settings.dsn#">
                    SELECT Q.ID Q_ID, Q.QUESTION, A.ANSWER, A.ANSWER_DATE_TIME, A.CONTRIBUTOR_ID, A.EVAL_ID, A.ID A_ID, A.STATUS
                    FROM FSM_EVALUATIONS_FEEDBACK_FORMQ Q
                    INNER JOIN FSM_EVALUATIONS_FEEDBACK_FORMA A ON Q.ID = A.QUESTION_ID 
                    WHERE A.ID = (SELECT MAX(ID) FROM FSM_EVALUATIONS_FEEDBACK_FORMA)
                </cfquery>
            </cftransaction>
        </cfif>
		<cfreturn qry>
	</cffunction>


	<cffunction name="deleteFeedback">
        <cfset arguments.ANSWER = JavaCast("null", 0)>
        <cfreturn updateFeedback(argumentcollection = arguments)>
	</cffunction>

	<cffunction name="updateFeedback">
        <cfquery name="upd" datasource="#Application.settings.dsn#">          
            UPDATE FSM_EVALUATIONS_FEEDBACK_FORMA SET 
            ANSWER = <cfif structKeyExists(ARGUMENTS, 'ANSWER')><cfqueryparam value="#arguments.ANSWER#" cfsqltype="CF_SQL_VARCHAR"><cfelse>NULL</cfif>,
            ANSWER_DATE_TIME = CURRENT_TIMESTAMP
            WHERE ID = <cfqueryparam value="#arguments.A_ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>
        <cfquery name="qry" datasource="#Application.settings.dsn#">
            SELECT Q.ID Q_ID, Q.QUESTION, A.ANSWER, A.ANSWER_DATE_TIME, A.CONTRIBUTOR_ID, A.EVAL_ID, A.ID A_ID, A.STATUS
            FROM FSM_EVALUATIONS_FEEDBACK_FORMQ Q
            INNER JOIN FSM_EVALUATIONS_FEEDBACK_FORMA A ON Q.ID = A.QUESTION_ID 
            WHERE A.ID = <cfqueryparam value="#arguments.A_ID#" cfsqltype="CF_SQL_DECIMAL">
        </cfquery>        
		<cfreturn qry>
	</cffunction>

</cfcomponent>