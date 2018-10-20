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
	Function getExperiencesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getExperiencesQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT            	
            	T1.ID EXP_ID,
                T1.VERS_NUM,
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
                    XP.VERS_NUM,
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
	                TBL_EXPERIENCES XP
                WHERE
    	            XP.DELETED IS NULL
            ) T1,
            (
                SELECT 
	                XP.ID,
    	            MAX(XP.VERS_NUM) VERS_NUM
                FROM 
        	        TBL_EXPERIENCES XP
                WHERE
            	    XP.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />   
                GROUP BY 
                	XP.ID
            ) T2
            WHERE
	            T1.ID = T2.ID 
                AND T1.VERS_NUM = T2.VERS_NUM   
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
                NVL(DELETED,'N')
            FROM
	            TBL_EXPERIENCES
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
	            TBL_EXPERIENCES
            WHERE 
    	        ID = <cfqueryparam value="#experience_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>  
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>            
        
        <cfreturn ls.retval>    
    </cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewAltPe
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewAltPe" access="public" returntype="string">
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
	Function chkEditPe
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditPe" access="public" returntype="string">
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
                        TBL_EXPERIENCES
                    WHERE 
                        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                )
            WHERE
	            ROWNUM = 1  
		</cfquery>  
        
        <cfreturn ls.qry>
	</cffunction>                   
    
</cfcomponent>    