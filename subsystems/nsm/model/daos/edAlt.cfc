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
	Function getDiplomasQry
	// The max() should not be necessary	
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
                    Hash_MD5_Blob(UPLD_DATA) UPLD_HASH, 
                    NVL(ED.DELETED, 'N') DELETED                 
                FROM
                    TBL_EXTERN_EDUCATIONS_ALT ED,
                    FSM_EDUCATION_DOMAINS DM
                WHERE
                    ED.DIPLOMA_DOMAIN = DM.ID(+)
            ) T1,
            (
                SELECT 
	                ED.ID,
    	            MAX(ED.VERS_NUM)
                FROM 
        	        TBL_EXTERN_EDUCATIONS_ALT ED                  
                WHERE
            	    ED.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                     
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
	            TBL_EXTERN_EDUCATIONS_ALT ED,
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
	            TBL_EXTERN_EDUCATIONS_ALT
            WHERE 
    	        ID = <cfqueryparam value="#diploma_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>  
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>            
        
        <cfreturn ls.retval>    
    </cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyDiploma" access="public" returntype="struct"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval["result"] = "OK">       
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_EXTERN_EDUCATIONS_ALT
            SELECT
	            *
            FROM
    	        TBL_EXTERN_EDUCATIONS
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
                AND VERS_NUM =
                (
                    SELECT
	                    MAX(VERS_NUM)
                    FROM
    	                TBL_EXTERN_EDUCATIONS
                    WHERE
        	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
                )                  
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAndUpdateDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="copyAndUpdateDiploma" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = copyDiploma(id).result>
    	    <cfset ls.result2 = updateDiploma(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="deleteDiploma" access="public" returntype="struct"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = {result:"OK"}>         
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	TBL_EXTERN_EDUCATIONS_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewDiplomaId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewDiplomaId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_EXTERN_EDUCATIONS_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createDiploma" access="public" returntype="struct"> 
        <cfargument name="username" type="string" required="true" />
		<cfargument name="staff_member_id" type="numeric" required="true" />
		<cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="levelid" type="numeric" required="true" />          
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>  
                    
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_EXTERN_EDUCATIONS_ALT
            (
                ID,
                VERS_NUM,
                EXTERNID,
                LEVELID,
                CRTBY,
                CRTON
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />, 
                2, <!---vers_num - avoid auto-increment in on-insert trigger---> 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#levelid#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery>    

		<cfreturn ls.retval>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createAndUpdateDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createAndUpdateDiploma" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" />        
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {result:"OK"}>  
        <cfset ls.edu_level_id = rc.edu_level_id>
        
        <cftransaction>
        
	        <cfset ls.result1 = createDiploma(username, staff_member_id, id, ls.edu_level_id).result>
    	    <cfset ls.result2 = updateDiploma(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updateDiploma" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" /> 
        <cfargument name="id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>   
        
<!---        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
            	TBL_EXTERN_EDUCATIONS_ALT ED
            SET             	
                ED.CITY = <cfqueryparam value="#rc.city#" cfsqltype="cf_sql_varchar" />,
                ED.COMMENTS = <cfqueryparam value="#rc.comments#" cfsqltype="cf_sql_varchar" />,
                ED.COUNTRYID = <cfqueryparam value="#rc.country_code#" cfsqltype="cf_sql_varchar" />,
                <!---ED.DIPLOMA = <cfqueryparam value="#rc.diploma#" cfsqltype="cf_sql_varchar" />,--->
<!---                ED.DIPLOMA_DOMAIN = 
                (
                    SELECT
                    	ID
                    FROM
	                    FSM_EDUCATION_DOMAINS
                    WHERE
    	                DOMAIN_CODE = <cfqueryparam value="#rc.domain_code#" cfsqltype="cf_sql_varchar" />
                ),--->
                <!---ED.STARTDATE = TO_DATE(<cfqueryparam value="#rc.start_date#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),--->
               <!--- ED.ENDDATE = TO_DATE(<cfqueryparam value="#rc.end_date#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),--->
                ED.ESTABLISHMENT = <cfqueryparam value="#rc.establishment#" cfsqltype="cf_sql_varchar" />,                         
               	ED.LESS_REQUIRED = <cfqueryparam value="#rc.less_than_required#" cfsqltype="cf_sql_varchar" />,
                <!---ED.OBTAINED = <cfqueryparam value="#rc.graduated#" cfsqltype="cf_sql_varchar" />,--->
                ED.OBTENTION_DATE = TO_DATE(<cfqueryparam value="#rc.graduation_date#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                ED.SPECIALITY = <cfqueryparam value="#rc.specialty#" cfsqltype="cf_sql_varchar" />,
                <!---ED.STUDY_FIELD = <cfqueryparam value="#rc.study_field#" cfsqltype="cf_sql_varchar" />,--->
                ED.NBR_YEARS = <cfqueryparam value="#rc.nbr_years#" cfsqltype="cf_sql_varchar" />,
                ED.YEARS_AS_EXP = <cfqueryparam value="#rc.years_as_exp#" cfsqltype="cf_sql_varchar" />,
                ED.MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                ED.MODON = SYSDATE
            WHERE 
                ED.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />           
		</cfquery> --->
        
       <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
            	TBL_EXTERN_EDUCATIONS_ALT ED
            SET             	
                ED.CITY = <cfqueryparam value="#rc.city#" cfsqltype="cf_sql_varchar" />,
				ED.COMMENTS = <cfqueryparam value="#rc.comments#" cfsqltype="cf_sql_varchar" />,
                ED.COUNTRYID = <cfqueryparam value="#rc.country_code#" cfsqltype="cf_sql_varchar" />,                
				ED.DIPLOMA_DOMAIN = 
                (
                    SELECT
                    	ID
                    FROM
	                    FSM_EDUCATION_DOMAINS
                    WHERE
    	                DOMAIN_CODE = <cfqueryparam value="#rc.domain_code#" cfsqltype="cf_sql_varchar" />
                ),
                ED.ESTABLISHMENT = <cfqueryparam value="#rc.establishment#" cfsqltype="cf_sql_varchar" />,                         
               	ED.LESS_REQUIRED = <cfqueryparam value="#rc.less_than_required#" cfsqltype="cf_sql_varchar" />,  
				ED.OBTENTION_DATE = TO_DATE(<cfqueryparam value="#rc.graduation_date#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                ED.SPECIALITY = <cfqueryparam value="#rc.specialty#" cfsqltype="cf_sql_varchar" />,          
                ED.NBR_YEARS = <cfqueryparam value="#rc.nbr_years#" cfsqltype="cf_sql_varchar" />,
                ED.YEARS_AS_EXP = <cfqueryparam value="#rc.years_as_exp#" cfsqltype="cf_sql_varchar" />,                                    
                ED.MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                ED.MODON = SYSDATE                
            WHERE 
                ED.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />      
		</cfquery>                                
        
        <cfreturn ls.retval>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isDiplomaRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="isDiplomaRemoved" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_EXTERN_EDUCATIONS_ALT  
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
	Function RemoveDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="RemoveDiploma" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" /> 
	   
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>      

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_EXTERN_EDUCATIONS_ALT  
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
	Function restoreDiploma
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="restoreDiploma" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />       
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>        

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_EXTERN_EDUCATIONS_ALT 
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
	Function getYearsAsExp
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getYearsAsExp" access="public" returntype="numeric">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT
            	NVL(SUM(YEARS_AS_EXP),0) YearsAsExp
            FROM
	            TBL_EXTERN_EDUCATIONS_ALT
            WHERE
    	        DELETED IS NULL
        	    AND EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
        </cfquery>  
        
		<cfreturn ls.qry.yearsAsExp>        
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
                UPLD_MIME MIME_TYPE,
                MODBY,
                MODON                
			FROM
				TBL_EXTERN_EDUCATIONS          
            WHERE 
            	ID = <cfqueryparam value="#diploma_id#" cfsqltype="cf_sql_integer">    
                AND Hash_MD5_Blob (UPLD_DATA) = '#hash#'     
			UNION ALL
            SELECT
                UPLD_DATA FILE_DATA,
                UPLD_NAME FILE_NAME,
                UPLD_MIME MIME_TYPE,
                MODBY,
                MODON                
			FROM
				TBL_EXTERN_EDUCATIONS_ALT           
            WHERE 
            	ID = <cfqueryparam value="#diploma_id#" cfsqltype="cf_sql_integer">      
                AND Hash_MD5_Blob (UPLD_DATA) = '#hash#'                      
		</cfquery>                
        
        <cfreturn ls.qry>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateDiplomaFile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="updateDiplomaFile" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />
        <cfargument name="id" type="numeric" required="true" />  
        <cfargument name="filefield" type="string" required="true" />        
        <cfargument name="rc" type="struct" required="true" />          
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}> 		            
            
		<cfset ls.tmp_file_dir = GetTempDirectory()>            

        <cffile 
            action="upload"           
            filefield="#filefield#" 
            destination="#ls.tmp_file_dir#" 
            nameconflict="makeunique" 
            accept="application/pdf, image/jpg, image/jpeg"
        >                    

        <cffile	
            action = "readbinary" 
            file = "#ls.tmp_file_dir##cffile.serverFile#" 
            variable="ls.file_blob"
        >          
            
        <cfquery datasource="#Application.settings.dsn#">
            UPDATE 
                TBL_EXTERN_EDUCATIONS_ALT  
            SET
                UPLD_DATA =  <cfqueryparam value="#ls.file_blob#" cfsqltype="cf_sql_blob">,
                UPLD_NAME = <cfqueryparam value="#file.clientFile#" cfsqltype="cf_sql_varchar">,
                <!---UPLD_MIME = <cfqueryparam value="#file.contentType#/#file.contentSubType#" cfsqltype="cf_sql_varchar">, ---> 
                UPLD_MIME = <cfqueryparam value="#file.contentSubType#" cfsqltype="cf_sql_varchar">,                           
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">,
                MODON = SYSDATE                                              
            WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">    
        </cfquery>        
        
       <cffile 
            action="delete" 
            file="#ls.tmp_file_dir##cffile.serverFile#"
        >   
    
        <cfreturn ls.retval>
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
            	PKG_FSM_SMM.F_CHK_EDIT_ED(
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
	Function deleteStatusLog
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="deleteStatusLog" access="public" returntype="string">
    	<cfargument name="staff_member_id" type="numeric" required="true" />  
        
        <cfset var ls = {}> 
        <cfset ls["retval"] = "NOOP">        
        
        <cfif hasAnyUpdate(staff_member_id) EQ "N">
        
            <cfquery datasource="#Application.settings.dsn#"> 
                DELETE FROM
                    FSM_STATUSES_LOG SL,
                    FSM_STATUSES ST
                WHERE
                    SL.STAFF_MEMBER_ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
                    AND SL.IS_CURRENT = 'Y'  
                    AND SL.STATUS_ID = ST.ID
                    AND ST.STATUS_CODE = 'SMM_EDIT_IN_PROGRESS'
            </cfquery>   
            
            <cfset ls.retval = "STATUS DELETED">     
        
        </cfif>
        
        <cfreturn ls.retval>
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
                        TBL_EXTERN_EDUCATIONS_ALT
                    WHERE 
                        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                )
            WHERE
	            ROWNUM = 1  
		</cfquery>  
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasAnyUpdate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="hasAnyUpdate" access="public" returntype="string"> 
        <cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_SMM.F_HAS_ANY_UPDATE(   			
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                  
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
    
</cfcomponent>    