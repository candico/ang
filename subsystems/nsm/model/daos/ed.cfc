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
	Function getDiplomasQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getDiplomasQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                   
            SELECT            	
              T1.ID,
              T1.CITY,
              T1.COMMENTS,
              T1.COUNTRY_CODE,
              T1.DIPLOMA,
              T1.DOMAIN_ID,
              T1.DOMAIN_CODE,
              T1.START_DATE,
              T1.END_DATE,
              T1.ESTABLISHMENT,                             
              T1.LESS_THAN_REQUIRED,
              T1.EDU_LEVEL_ID,
              T1.GRADUATED,
              T1.GRADUATION_DATE,
              T1.SPECIALTY,              
              T1.STUDY_FIELD,
              T1.NBR_YEARS,
              T1.YEARS_AS_EXP,              
              T1.UPLD_NAME,
              T1.UPLD_MIME,
              T1.UPLD_HASH,
              T1.DELETED                          
            FROM
            (
                SELECT
                    ED.ID,
                    ED.CITY,
                    ED.COMMENTS,
                    ED.COUNTRYID COUNTRY_CODE,
                    ED.DIPLOMA,                    
                    ED.DIPLOMA_DOMAIN DOMAIN_ID,
                    DM.DOMAIN_CODE, 
                    TO_CHAR(ED.STARTDATE, 'DD/MM/YYYY') START_DATE,
                    TO_CHAR(ED.ENDDATE, 'DD/MM/YYYY') END_DATE,
                    ED.ESTABLISHMENT,                             
                    NVL(ED.LESS_REQUIRED, 'N') LESS_THAN_REQUIRED,
                    ED.LEVELID EDU_LEVEL_ID,
                    ED.OBTAINED GRADUATED,
                    TO_CHAR(ED.OBTENTION_DATE, 'DD/MM/YYYY') GRADUATION_DATE,
                    ED.SPECIALITY SPECIALTY,                    
                    ED.STUDY_FIELD,
                    ED.NBR_YEARS,
                    ED.YEARS_AS_EXP,
                    ED.UPLD_NAME,
                    ED.UPLD_MIME,
                    Hash_MD5_Blob(ED.UPLD_DATA) UPLD_HASH,
                    NVL(DELETED,'N') DELETED                         
                FROM
                    TBL_EXTERN_EDUCATIONS ED,
                    FSM_EDUCATION_DOMAINS DM
                WHERE
                    ED.DELETED IS NULL
                    AND ED.DIPLOMA_DOMAIN = DM.ID(+)
            ) T1,
            (
                SELECT 
	                ED.ID,
    	            MAX(ED.VERS_NUM)
                FROM 
        	        TBL_EXTERN_EDUCATIONS ED                  
                WHERE
            	    ED.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />      
                    AND ED.VERS_NUM IN(1,2) <!---They are all in 1 or 2 anyway--->       
                    AND ED.DELETED IS NULL        
                GROUP BY 
                	ED.ID
            ) T2
            WHERE
	            T1.ID = T2.ID    
			ORDER BY
            	T1.ID DESC                                     
        </cfquery>  
        
		<cfreturn ls.qry>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDiplomaQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getDiplomaQry" access="public" returntype="query">
		<cfargument name="diploma_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                  
            SELECT
                ED.ID,
                ED.CITY,
                ED.COMMENTS,
                ED.COUNTRYID COUNTRY_CODE,
                ED.DIPLOMA,
                ED.DIPLOMA_DOMAIN DOMAIN_ID,
                DM.DOMAIN_CODE,                
                ED.ESTABLISHMENT,                             
                NVL(ED.LESS_REQUIRED, 'N') LESS_THAN_REQUIRED,
                ED.LEVELID EDU_LEVEL_ID,
                ED.OBTAINED GRADUATED,
                TO_CHAR(ED.OBTENTION_DATE, 'DD/MM/YYYY') GRADUATION_DATE,
                ED.SPECIALITY SPECIALTY,
                TO_CHAR(ED.STARTDATE,'DD/MM/YYYY') START_DATE,
                TO_CHAR(ED.ENDDATE, 'DD/MM/YYYY') END_DATE,
                ED.STUDY_FIELD,
                ED.NBR_YEARS,
                ED.YEARS_AS_EXP,
                NVL(ED.DELETED, 'N') DELETED   
            FROM
	            TBL_EXTERN_EDUCATIONS ED,
                FSM_EDUCATION_DOMAINS DM
            WHERE
    	        ED.ID = <cfqueryparam value="#diploma_id#" cfsqltype="cf_sql_integer" /> 
                AND ED.DIPLOMA_DOMAIN = DM.ID(+)
        </cfquery>   
        
		<cfreturn ls.qry>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasDiploma" access="public" returntype="boolean">       
	    <cfargument name="diploma_id" type="numeric" required="true" />
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>        
        
       <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
				COUNT(*) CNT
            FROM
	            TBL_EXTERN_EDUCATIONS
            WHERE 
    	        ID = <cfqueryparam value="#diploma_id#" cfsqltype="cf_sql_integer" /> 	                 
                AND DELETED IS NULL
		</cfquery>  
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>            
        
        <cfreturn ls.retval>    
    </cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getYearsAsExp
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getYearsAsExp" access="public" returntype="numeric">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT
            	NVL(SUM(YEARS_AS_EXP),0) YearsAsExp
            FROM
	            TBL_EXTERN_EDUCATIONS
            WHERE
        	    EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND DELETED IS NULL
        </cfquery>  
        
		<cfreturn ls.qry.yearsAsExp>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDomainsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getDomainsQry" access="public" returntype="query">
		<cfargument name="lang_code" type="string" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT
                ED.ID,
                ED.DOMAIN_CODE CODE,
                ST.STR NAME
            FROM
                FSM_EDUCATION_DOMAINS ED,
                FSM_STRINGS ST
            WHERE
                ED.DOMAIN_CODE = ST.STR_CODE
                AND ST.LANG_CODE = <cfqueryparam value="#lang_code#" cfsqltype="cf_sql_varchar" />
            ORDER BY
	            ST.STR	
        </cfquery>  
        
		<cfreturn ls.qry>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDomains
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getDomains" access="public" returntype="query">		
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                  
            SELECT
		        ID,
                DESCRIPTION
            FROM
				TBL_DIPLOMA_DOMAINS
			ORDER BY 
            	ID                          
        </cfquery>   
        
		<cfreturn ls.qry>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDiplomaFileQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getDiplomaFileQry" access="public" returntype="query">
        <cfargument name="diploma_id" type="string" required="true" />  
        <cfargument name="hash" type="string" required="true" />  
        
        <cfset var ls = {}>      
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                UPLD_DATA FILE_DATA,
                UPLD_NAME FILE_NAME,
                UPLD_MIME MIME_TYPE  
			FROM
				TBL_EXTERN_EDUCATIONS                
            WHERE 
            	ID = <cfqueryparam value="#diploma_id#" cfsqltype="cf_sql_integer">     
                AND Hash_MD5_Blob (SA.UPLD_DATA) = '#hash#' 
			UNION ALL
            SELECT
                UPLD_DATA FILE_DATA,
                UPLD_NAME FILE_NAME,
                UPLD_MIME MIME_TYPE                            
			FROM
				TBL_EXTERN_EDUCATIONS_ALT                
            WHERE 
            	ID = <cfqueryparam value="#diploma_id#" cfsqltype="cf_sql_integer">         
                AND Hash_MD5_Blob (SA.UPLD_DATA) = '#hash#'                       
		</cfquery>                
        
        <cfreturn ls.qry>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewAltEd
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewAltEd" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_VIEW_ALT_GD_FD_ED(
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
	Function chkEditEd
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditEd" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_CHK_EDIT_GD_FD_ED(
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
                        TBL_EXTERN_EDUCATIONS
                    WHERE 
                        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                )
            WHERE
	            ROWNUM = 1  
		</cfquery>  
        
        <cfreturn ls.qry>
	</cffunction>                   
    
</cfcomponent>    