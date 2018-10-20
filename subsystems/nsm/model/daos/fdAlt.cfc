<cfcomponent accessors="Yes">	

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Set Default Params
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  

	<!---common to all relatives--->
	<cfparam name = "rc.lname" default="">
	<cfparam name = "rc.fname" default="">    
	<cfparam name = "rc.gender" default="">    
	<cfparam name = "rc.birth_date" default="">
    <cfparam name = "rc.birth_country_code" default="">
    <cfparam name = "rc.birth_city" default="">    
	<cfparam name = "rc.is_expatriate" default="">    
	<cfparam name = "rc.expatriate_since" default="">   
	<cfparam name = "rc.is_dependent" default="">    
	<cfparam name = "rc.dependent_since" default=""> 
	<cfparam name = "rc.citizenship_1_country_code" default="">         
	<cfparam name = "rc.citizenship_2_country_code" default="">  
	<!---spouse-specific death date--->    
    <cfparam name = "rc.death_date" default=""> 
    <!---spouse-specific occupation--->
	<cfparam name = "rc.occupation" default="">  
	<cfparam name = "rc.employer" default="">                     
	<cfparam name = "rc.annual_income" default="">                         
	<cfparam name = "rc.income_currency" default="">
	<cfparam name = "rc.occupation_start" default="">  
	<!---spouse-specific contact in country of origin--->  
	<cfparam name = "rc.cco_same" default="">  
	<cfparam name = "rc.cco_address" default="">  
	<cfparam name = "rc.cco_city" default="">  
	<cfparam name = "rc.cco_postal_code" default="">                                              
	<cfparam name = "rc.cco_country_code" default="">    
	<cfparam name = "rc.cco_since" default="">    
	<!---spouse-specific contact in country of residence--->  
	<cfparam name = "rc.crc_same" default="">  
	<cfparam name = "rc.crc_address" default="">  
	<cfparam name = "rc.crc_city" default="">  
	<cfparam name = "rc.crc_postal_code" default=""> 
	<cfparam name = "rc.crc_country_code" default="">  
	<cfparam name = "rc.crc_since" default="">    
	<!---spouse-specific private contact--->  
	<cfparam name = "rc.phone_nbr" default="">                                                           
	<cfparam name = "rc.mobile_nbr" default="">                                                           
	<cfparam name = "rc.other_phone_nbr" default="">                                                           
	<cfparam name = "rc.email_1" default="">                                                           
	<cfparam name = "rc.email_2" default="">    
	<!---child-specific school details--->  
	<cfparam name = "rc.school_name" default=""> 
   	<cfparam name = "rc.school_address" default=""> 
	<cfparam name = "rc.school_city" default=""> 
   	<cfparam name = "rc.school_postal_code" default=""> 
	<cfparam name = "rc.school_country_code" default=""> 

	<!---scholarships--->   
<!---    <cfparam name = "rc.academic_year" default=""> 
    <cfparam name = "rc.scholarship_nature" default=""> 
    <cfparam name = "rc.amount" default=""> 
    <cfparam name = "rc.comments" default=""> --->
    
	<!---certificates--->   
<!---    <cfparam name = "rc.validity_from" default=""> 
    <cfparam name = "rc.validity_until" default=""> 
    <cfparam name = "rc.reception_date" default=""> 
    <cfparam name = "rc.comments" default=""> --->
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasPersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasPersonalProfile" access="public" returntype="boolean">   
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        
     	<cfset var ls = {}> 
        <cfset ls.retval = true>     
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_PERSONALPROFILES_ALT       
			WHERE     
	            EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>                
        
        <cfreturn ls.retval>    
    </cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getPersonalProfileQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="getPersonalProfileQry" access="public" returntype="query">
        <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT            	
        	    PP.*
            FROM
	            TBL_PERSONALPROFILES_ALT PP
            WHERE
    	        PP.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewPersonalProfileId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewPersonalProfileId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
            <cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
                SELECT
                    TBL_PERSONALPROFILES_SEQ.NEXTVAL AS ID
                FROM
                    DUAL                
            </cfquery> 
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createPersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createPersonalProfile" access="public" returntype="struct">   
        <cfargument name="username" type="string" required="true" />
        <cfargument name="personal_profile_id" type="numeric" required="true" />
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_PERSONALPROFILES_ALT
            (
                ID,
                EXTERNID,
                VALIDATED,
                CRTBY,
                CRTON
            )
            VALUES
            (		
                <cfqueryparam value="#personal_profile_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                1,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery> 

		<cfreturn ls.retval>         
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyPersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyPersonalProfile" access="public" returntype="struct">           
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO 
            	TBL_PERSONALPROFILES_ALT
          	SELECT
            	PP.*
            FROM
	            TBL_PERSONALPROFILES PP
            WHERE
                PP.ID = 
                (
                    SELECT            	
                        MAX(PP2.ID)
                    FROM
                        TBL_PERSONALPROFILES PP2
                    WHERE
                        PP2.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />  
                )     
        </cfquery> 

		<cfreturn ls.retval>         
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updatePersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updatePersonalProfile" access="public" returntype="struct">    
	    <cfargument name="username" type="string" required="true" />       
		<cfargument name="id" type="numeric" required="true" />
        <cfargument name="children_count" type="numeric" required="true" />
        <cfargument name="dependents_count" type="numeric" required="true" />
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>
            
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE 
            	TBL_PERSONALPROFILES_ALT
            SET
            	NBR_CHILDREN = <cfqueryparam value="#children_count#" cfsqltype="cf_sql_integer" />,
				NBR_PERS_CHARGE = <cfqueryparam value="#dependents_count#" cfsqltype="cf_sql_integer" />,    
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,           
            	MODON = SYSDATE            
            WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />    
        </cfquery> 

		<cfreturn ls.retval>         
	</cffunction>          
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllowancseQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="getAllowancesQry" access="public" returntype="query">
		<!---<cfargument name="staff_member_id" type="numeric" required="true" />--->
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>	  
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	EX.ID STAFF_MEMBER_ID,
                EX.EXT_ALLOW_NATURE ALLOWANCES_NATURE,
                EX.EXT_ALLOW_COMMENTS ALLOWANCES_COMMENTS,                
                EX.EXT_ALLOW_AMOUNT ALLOWANCES_AMOUNT  
            FROM
                TBL_EXTERNS_ALT EX
            WHERE
	            EX.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />                               
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasAllowances ( = has extern record)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="hasAllowances" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_EXTERNS_ALT  
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 

<!---        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">        
            SELECT
	            COUNT(*) CNT     
            FROM
    	        TBL_EXTERNS EX1,
        	    TBL_EXTERNS_ALT EX2
            WHERE
            	EX1.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
	            AND EX1.ID = EX2.ID(+)
    	        AND (
        		    EX1.EXT_ALLOW_NATURE != EX2.EXT_ALLOW_NATURE
		            OR EX1.EXT_ALLOW_COMMENTS != EX2.EXT_ALLOW_COMMENTS
        		    OR EX1.EXT_ALLOW_AMOUNT != EX2.EXT_ALLOW_AMOUNT
	            )        
        </cfquery>--->
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
    </cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAllowances ( = copy extern)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="copyAllowances" access="public" returntype="struct">
		<cfargument name="id" type="numeric" required="true" /> 
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>              
        
       <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_EXTERNS_ALT
            SELECT
	            *
            FROM
    	        TBL_EXTERNS
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>       
        
        <cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteAllowances ( = delete extern)
	Temporarily disabled because I do not want to delete a record created or used by the GD functions
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="deleteAllowances" access="public" returntype="struct">
		<cfargument name="id" type="numeric" required="true" /> 
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>              
        
<!---       <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM
            	TBL_EXTERNS_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>    --->   
        
        <cfreturn ls.retval>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAndUpdateAllowances
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="copyAndUpdateAllowances" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = copyAllowances(id).result>
    	    <cfset ls.result2 = updateAllowances(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateAllowances
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="updateAllowances" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>              
        
       <cfquery datasource="#Application.settings.dsn#">
			UPDATE
				TBL_EXTERNS_ALT         
			SET            	
                EXT_ALLOW_NATURE = <cfqueryparam value='#rc.allowances_nature#' cfsqltype='cf_sql_varchar'>,
                EXT_ALLOW_COMMENTS = <cfqueryparam value='#rc.allowances_comments#' cfsqltype='cf_sql_varchar'>,               
                EXT_ALLOW_AMOUNT = <cfqueryparam value='#rc.allowances_amount#' cfsqltype="cf_sql_numeric" null="#rc.allowances_amount EQ ''#"/>,
                MODON = SYSDATE,
                MODBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>                
            WHERE
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />   
        </cfquery>       
        
        <cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRelativesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getRelativesQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                   
            SELECT  
                PP.EXTERNID,
                PM.ID,
                NVL(PM.DELETED, 'N') DELETED,
                '' STATUS,
                PM.TYPE,
                PM.FAMILYLINK FAMILY_LINK,                
   				UPPER(PM.SURNAME) LNAME,
                INITCAP(PM.NAME) FNAME,                
                PM.GENDER,
                TO_CHAR(PM.BIRTHDATE, 'DD/MM/YYYY') BIRTH_DATE,
                TRUNC(MONTHS_BETWEEN(SYSDATE, PM.BIRTHDATE)/12) AGE,                
                PM.BIRTH_CITY,
                PM.BIRTH_COUNTRYID BIRTH_COUNTRY_CODE,
                PM.NATIONALITYCOUNTRYID CITIZENSHIP_1_COUNTRY_CODE,
                PM.NATIONALITYCOUNTRYID_2 CITIZENSHIP_2_COUNTRY_CODE,
                DECODE(PM.EXPATRIATED,'No','N','Yes','Y',NULL,'N',PM.EXPATRIATED) IS_EXPATRIATE,  
                TO_CHAR(PM.EXPATSINCE, 'DD/MM/YYYY') EXPATRIATE_SINCE,                      
                DECODE(PM.DEPENDENT,'No','N','Yes','Y',NULL,'N',PM.DEPENDENT) IS_DEPENDENT,          
                TO_CHAR(PM.SINCE, 'DD/MM/YYYY') DEPENDENT_SINCE, 
                TO_CHAR(PM.DEATHDATE, 'DD/MM/YYYY') DEATH_DATE,
                PM.OCCUPATION,
                TO_CHAR(PM.START_OCCUPATION, 'DD/MM/YYYY') OCCUPATION_START,
                PM.PROF_ORGANISATION EMPLOYER,
                PM.YEARINCOME ANNUAL_INCOME,
                PM.INCOMECURRENCY INCOME_CURRENCY,
                PM.SAME_ORIGIN CCO_SAME,
                PM.ADDRESSLINE1 CCO_ADDRESS,
                PM.CITY CCO_CITY,
                PM.POSTALCODE CCO_POSTAL_CODE,
                PM.COUNTRYID CCO_COUNTRY_CODE,
                TO_CHAR(PM.EFFECTDATE1, 'DD/MM/YYYY') CCO_SINCE,  
                PM.SAME_RESIDENCE CRC_SAME,
                PM.PRIVATE_ADDRESSLINE1 CRC_ADDRESS,
                PM.PRIVATE_CITY CRC_CITY,
                PM.PRIVATE_POSTALCODE CRC_POSTAL_CODE,
                PM.PRIVATE_COUNTRY CRC_COUNTRY_CODE,
                TO_CHAR(PM.EFFECTDATE2, 'DD/MM/YYYY') CRC_SINCE, 
                PM.PHONENUMBER PHONE_NBR,
                PM.MOBILENUMBER MOBILE_NBR,
                PM.OTHERNUMBER OTHER_PHONE_NBR,
                PM.EMAIL EMAIL_1,
                PM.EMAIL2 EMAIL_2,
                PM.SCHOOLNAME SCHOOL_NAME,
                PM.SCHOOLADDRESSLINE1 SCHOOL_ADDRESS,
                PM.SCHOOLCITY SCHOOL_CITY,
                PM.SCHOOLPOSTALCODE SCHOOL_POSTAL_CODE,
                PM.SCHOOLCOUNTRYID SCHOOL_COUNTRY_CODE               
            FROM 
                TBL_PERSONALPROFILES_ALT PP,
                TBL_PROFILE_MEMBERS_ALT PM
            WHERE 
                PM.TYPE = 'FAMI'
                AND PM.PERSONALPROFILEID = PP.ID
                AND PP.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
            ORDER BY 
	            PM.BIRTHDATE DESC
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="hasRelative" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_PROFILE_MEMBERS_ALT     
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
    </cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRelativeQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getRelativeQry" access="public" returntype="query">
		<cfargument name="id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                   
            SELECT                  
                PM.ID,
                NVL(PM.DELETED, 'N') DELETED,
                '' STATUS,
                PM.TYPE,
                PM.FAMILYLINK FAMILY_LINK,                
   				UPPER(PM.SURNAME) LNAME,
                INITCAP(PM.NAME) FNAME,                
                PM.GENDER,
                TO_CHAR(PM.BIRTHDATE, 'DD/MM/YYYY') BIRTH_DATE,
                TRUNC(MONTHS_BETWEEN(SYSDATE, PM.BIRTHDATE)/12) AGE,                
                PM.BIRTH_CITY,
                PM.BIRTH_COUNTRYID BIRTH_COUNTRY_CODE,
                PM.NATIONALITYCOUNTRYID CITIZENSHIP_1_COUNTRY_CODE,
                PM.NATIONALITYCOUNTRYID_2 CITIZENSHIP_2_COUNTRY_CODE,                
                DECODE(PM.EXPATRIATED,'No','N','Yes','Y',NULL,'N',PM.EXPATRIATED) IS_EXPATRIATE,  
                TO_CHAR(PM.EXPATSINCE, 'DD/MM/YYYY') EXPATRIATE_SINCE,  
                DECODE(PM.DEPENDENT,'No','N','Yes','Y',NULL,'N',PM.DEPENDENT) IS_DEPENDENT,  
                TO_CHAR(PM.SINCE, 'DD/MM/YYYY') DEPENDENT_SINCE, 
                TO_CHAR(PM.DEATHDATE, 'DD/MM/YYYY') DEATH_DATE,
                PM.OCCUPATION,
                TO_CHAR(PM.START_OCCUPATION, 'DD/MM/YYYY') OCCUPATION_START,
                PM.PROF_ORGANISATION EMPLOYER,
                PM.YEARINCOME ANNUAL_INCOME,
                PM.INCOMECURRENCY INCOME_CURRENCY,
                PM.SAME_ORIGIN CCO_SAME,
                PM.ADDRESSLINE1 CCO_ADDRESS,
                PM.CITY CCO_CITY,
                PM.POSTALCODE CCO_POSTAL_CODE,
                PM.COUNTRYID CCO_COUNTRY_CODE,
                TO_CHAR(PM.EFFECTDATE1, 'DD/MM/YYYY') CCO_SINCE,  
                PM.SAME_RESIDENCE CRC_SAME,
                PM.PRIVATE_ADDRESSLINE1 CRC_ADDRESS,
                PM.PRIVATE_CITY CRC_CITY,
                PM.PRIVATE_POSTALCODE CRC_POSTAL_CODE,
                PM.PRIVATE_COUNTRY CRC_COUNTRY_CODE,
                TO_CHAR(PM.EFFECTDATE2, 'DD/MM/YYYY') CRC_SINCE, 
                PM.PHONENUMBER PHONE_NBR,
                PM.MOBILENUMBER MOBILE_NBR,
                PM.OTHERNUMBER OTHER_PHONE_NBR,
                PM.EMAIL EMAIL_1,
                PM.EMAIL2 EMAIL_2,
                PM.SCHOOLNAME SCHOOL_NAME,
                PM.SCHOOLADDRESSLINE1 SCHOOL_ADDRESS,
                PM.SCHOOLCITY SCHOOL_CITY,
                PM.SCHOOLPOSTALCODE SCHOOL_POSTAL_CODE,
                PM.SCHOOLCOUNTRYID SCHOOL_COUNTRY_CODE               
            FROM                 
                TBL_PROFILE_MEMBERS_ALT PM
            WHERE 
                PM.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="copyRelative" access="public" returntype="struct">
		<cfargument name="id" type="numeric" required="true" /> 
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>              
        
       <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_PROFILE_MEMBERS_ALT
            SELECT
	            *
            FROM
    	        TBL_PROFILE_MEMBERS
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>       
        
        <cfreturn ls.retval>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAndUpdateRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="copyAndUpdateRelative" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = copyRelative(id).result>
    	    <cfset ls.result2 = updateRelative(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewRelativeId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewRelativeId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_PROFILE_MEMBERS_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>           
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createRelative" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="personal_profile_id" type="numeric" required="true" />  
		<cfargument name="family_link" type="string" required="true" />   
    
	    <cfset var ls = {}> 	      
        <cfset ls.retval = {result:"OK"}>    
            
       <cfquery datasource="#Application.settings.dsn#">
            INSERT INTO TBL_PROFILE_MEMBERS_ALT
            (
                ID,
                PERSONALPROFILEID,
                FAMILYLINK,
                VALIDATED,
                TYPE,
                VERS_NUM, 
                CURRENT_PART,
                IS_ACTIVE,
                HANDICAPPED,
                MARITAL_STATUS,
                CRTBY,
                CRTON         
            )          
            VALUES
            (		  
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />,                 
                <cfqueryparam value="#personal_profile_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value='#family_link#' cfsqltype='cf_sql_varchar'>,
                1, <!---validated - what does it mean?--->
                'FAMI', <!---type--->
                2,  <!---vers_num - avoid auto-increment in on-insert trigger--->     
                'N', <!---current_part--->
                'Y', <!---is_active--->
                'N', <!---handicapped--->
                0, <!---marital status--->
                <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>,
                SYSDATE
            )           
		</cfquery>               
    
	    <cfreturn ls.retval>
    </cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createAndUpdateRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createAndUpdateRelative" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />
        <cfargument name="personal_profile_id" type="numeric" required="true" />  
		<cfargument name="family_link" type="string" required="true" /> 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = createRelative(username, id, personal_profile_id, family_link).result>
    	    <cfset ls.result2 = updateRelative(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>      
        
        <cfreturn ls.retval>
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="updateRelative" access="public" returntype="struct">		 
        <cfargument name="username" type="string" required="true" />   
        <cfargument name="id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />    
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>      
        
       <!--- THIS UPDATE IS DESTRUCTIVE!!! UNPROVIDED VALUES WILL BE CFPARAM-ED!--->
        
        <cfquery datasource="#Application.settings.dsn#">   
            UPDATE  
                TBL_PROFILE_MEMBERS_ALT 
            SET  
                <!---VERS_NUM = VERS_NUM + 1, ---> <!---//Clarify??--->
                SURNAME = TRIM(UPPER(<cfqueryparam value='#rc.LNAME#' cfsqltype='cf_sql_varchar'>)),  
                NAME = TRIM(INITCAP(<cfqueryparam value='#rc.FNAME#' cfsqltype='cf_sql_varchar'>)),                               
                GENDER = <cfqueryparam value='#rc.GENDER#' cfsqltype='cf_sql_varchar'>,                
                BIRTHDATE = TO_DATE(<cfqueryparam value='#rc.BIRTH_DATE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'), 
				BIRTH_CITY = <cfqueryparam value='#rc.BIRTH_CITY#' cfsqltype='cf_sql_varchar'>,           
                BIRTH_COUNTRYID = <cfqueryparam value='#rc.BIRTH_COUNTRY_CODE#' cfsqltype='cf_sql_varchar'>,             
                NATIONALITYCOUNTRYID = <cfqueryparam value='#rc.CITIZENSHIP_1_COUNTRY_CODE#' cfsqltype='cf_sql_varchar'>, 
                NATIONALITYCOUNTRYID_2 = <cfqueryparam value='#rc.CITIZENSHIP_2_COUNTRY_CODE#' cfsqltype='cf_sql_varchar'>,                    
				<!---EXPATRIATED = <cfqueryparam value='#rc.IS_EXPATRIATE#' cfsqltype='cf_sql_varchar'>,  --->
                <!---EXPATSINCE = TO_DATE(<cfqueryparam value='#rc.EXPATRIATE_SINCE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),---> 
				DEPENDENT = <cfqueryparam value='#rc.IS_DEPENDENT#' cfsqltype='cf_sql_varchar'>,             
				SINCE = TO_DATE(<cfqueryparam value='#rc.DEPENDENT_SINCE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),                
                DEATHDATE = TO_DATE(<cfqueryparam value='#rc.DEATH_DATE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'), 
                
                OCCUPATION = TRIM(<cfqueryparam value='#rc.OCCUPATION#' cfsqltype='cf_sql_varchar'>), 
                START_OCCUPATION = TO_DATE(<cfqueryparam value='#rc.OCCUPATION_START#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'), 
                PROF_ORGANISATION = TRIM(<cfqueryparam value='#rc.EMPLOYER#' cfsqltype='cf_sql_varchar'>),
                YEARINCOME = TRIM(<cfqueryparam value='#rc.ANNUAL_INCOME#' cfsqltype='cf_sql_varchar'>), 
                INCOMECURRENCY = TRIM(<cfqueryparam value='#rc.INCOME_CURRENCY#' cfsqltype='cf_sql_varchar'>), 
                 
                SAME_ORIGIN = <cfqueryparam value='#rc.CCO_SAME#' cfsqltype='cf_sql_varchar'>, 
                ADDRESSLINE1 = TRIM(<cfqueryparam value='#rc.CCO_ADDRESS#' cfsqltype='cf_sql_varchar'>), 
                CITY = TRIM(<cfqueryparam value='#rc.CCO_CITY#' cfsqltype='cf_sql_varchar'>), 
                POSTALCODE = TRIM(<cfqueryparam value='#rc.CCO_POSTAL_CODE#' cfsqltype='cf_sql_varchar'>), 
                COUNTRYID = <cfqueryparam value='#rc.CCO_COUNTRY_CODE#' cfsqltype='cf_sql_varchar'>, 
                EFFECTDATE1 = TO_DATE(<cfqueryparam value='#rc.CCO_SINCE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'), 
                
                SAME_RESIDENCE = <cfqueryparam value='#rc.CRC_SAME#' cfsqltype='cf_sql_varchar'>, 
				PRIVATE_ADDRESSLINE1 = TRIM(<cfqueryparam value='#rc.CRC_ADDRESS#' cfsqltype='cf_sql_varchar'>),                  
				PRIVATE_CITY = TRIM(<cfqueryparam value='#rc.CRC_CITY#' cfsqltype='cf_sql_varchar'>),                
                PRIVATE_POSTALCODE = TRIM(<cfqueryparam value='#rc.CRC_POSTAL_CODE#' cfsqltype='cf_sql_varchar'>), 
                PRIVATE_COUNTRY = <cfqueryparam value='#rc.CRC_COUNTRY_CODE#' cfsqltype='cf_sql_varchar'>,  
                EFFECTDATE2 = TO_DATE(<cfqueryparam value='#rc.CRC_SINCE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),                
                
                PHONENUMBER = TRIM(<cfqueryparam value='#rc.PHONE_NBR#' cfsqltype='cf_sql_varchar'>), 
                MOBILENUMBER = TRIM(<cfqueryparam value='#rc.MOBILE_NBR#' cfsqltype='cf_sql_varchar'>),           
                OTHERNUMBER = TRIM(<cfqueryparam value='#rc.OTHER_PHONE_NBR#' cfsqltype='cf_sql_varchar'>), 
                EMAIL = TRIM(<cfqueryparam value='#rc.EMAIL_1#' cfsqltype='cf_sql_varchar'>), 
                EMAIL2 = TRIM(<cfqueryparam value='#rc.EMAIL_2#' cfsqltype='cf_sql_varchar'>),   
               
                SCHOOLNAME = TRIM(<cfqueryparam value='#rc.SCHOOL_NAME#' cfsqltype='cf_sql_varchar'>), 
                SCHOOLADDRESSLINE1 = TRIM(<cfqueryparam value='#rc.SCHOOL_ADDRESS#' cfsqltype='cf_sql_varchar'>), 
                SCHOOLPOSTALCODE = TRIM(<cfqueryparam value='#rc.SCHOOL_POSTAL_CODE#' cfsqltype='cf_sql_varchar'>), 
                SCHOOLCITY = TRIM(<cfqueryparam value='#rc.SCHOOL_CITY#' cfsqltype='cf_sql_varchar'>), 
                SCHOOLCOUNTRYID = <cfqueryparam value='#rc.SCHOOL_COUNTRY_CODE#' cfsqltype='cf_sql_varchar'>, 
                                                                 
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>
            WHERE
                ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />            	                
        </cfquery>                  
        
        <cfreturn ls.retval>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="deleteRelative" access="public" returntype="struct">	    
        <cfargument name="id" type="numeric" required="true" />       
  
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>       

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	DELETE FROM
            	TBL_PROFILE_MEMBERS_ALT
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isRelativeRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="isRelativeRemoved" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_PROFILE_MEMBERS_ALT     
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
	Function RemoveRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="RemoveRelative" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" /> 
	   
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>      

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_PROFILE_MEMBERS_ALT
			SET
            	DELETED = 'Y',
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function restoreRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="restoreRelative" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />       
        
		<cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}>        

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_PROFILE_MEMBERS_ALT
			SET
            	DELETED = NULL,
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getCertificatesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="getCertificatesQry" access="public" returntype="query">
        <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                SA.ID,
                SA.PROFILEMEMBERID RELATIVE_ID,
                TO_CHAR(SA.RECEPTION, 'DD/MM/YYYY') RECEPTION_DATE,
                TO_CHAR(SA.VALIDITY_FROM, 'DD/MM/YYYY') VALIDITY_FROM,
                TO_CHAR(SA.VALIDITY_TO, 'DD/MM/YYYY') VALIDITY_UNTIL,
                SA.COMMENTS,
                NVL(SA.DELETED, 'N') DELETED,
                SA.UPLD_NAME CERTIFICATE_FILENAME,
                SA.UPLD_MIME,
                Hash_MD5_Blob(UPLD_DATA) UPLD_HASH                  
            FROM
				TBL_SCHOOL_ATTEND_ALT SA
            WHERE
            	SA.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
                AND DELETED IS NULL                
            ORDER BY
                SA.PROFILEMEMBERID,
                SA.VALIDITY_TO DESC
		</cfquery>       
        
        <cfreturn ls.qry>           
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="hasCertificate" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_SCHOOL_ATTEND_ALT     
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
    </cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getCertificateQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="getCertificateQry" access="public" returntype="query">
        <cfargument name="certificate_id" type="numeric" required="true" />       
        
        <cfset var ls = {}>

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                SA.ID,
                SA.PROFILEMEMBERID RELATIVE_ID,
                TO_CHAR(SA.RECEPTION, 'DD/MM/YYYY') RECEPTION_DATE,
                TO_CHAR(SA.VALIDITY_FROM, 'DD/MM/YYYY') VALIDITY_FROM,
                TO_CHAR(SA.VALIDITY_TO, 'DD/MM/YYYY') VALIDITY_UNTIL,
                SA.COMMENTS,
                NVL(SA.DELETED, 'N') DELETED,
                SA.UPLD_NAME CERTIFICATE_FILENAME,      
                SA.UPLD_MIME 
            FROM
				TBL_SCHOOL_ATTEND SA
            WHERE
            	SA.ID = <cfqueryparam value="#certificate_id#" cfsqltype="cf_sql_integer" />                               
		</cfquery>       
        
        <cfreturn ls.qry>           
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getCertificateFileQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="getCertificateFileQry" access="public" returntype="query">
        <cfargument name="certificate_id" type="numeric" required="true" />
        <cfargument name="hash" type="string" required="true" />
        
        <cfset var ls = {}>

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT            
                SA.UPLD_NAME,
                SA.UPLD_DATA,
                SA.UPLD_MIME,
                SA.MODBY,
                SA.MODON    
            FROM
				TBL_SCHOOL_ATTEND SA
            WHERE
            	SA.ID = <cfqueryparam value="#certificate_id#" cfsqltype="cf_sql_integer" />
                AND Hash_MD5_Blob (SA.UPLD_DATA) = '#hash#'  
			UNION ALL
            SELECT            
                SA.UPLD_NAME,
                SA.UPLD_DATA,
                SA.UPLD_MIME,
                SA.MODBY,
                SA.MODON    
            FROM
				TBL_SCHOOL_ATTEND_ALT SA
            WHERE
            	SA.ID = <cfqueryparam value="#certificate_id#" cfsqltype="cf_sql_integer" />
                AND Hash_MD5_Blob (SA.UPLD_DATA) = '#hash#'                   
		</cfquery>       
        
        <cfreturn ls.qry>           
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="copyCertificate" access="public" returntype="struct">
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>        
        <cfset ls.retval = {result:"OK"}> 

        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_SCHOOL_ATTEND_ALT
            SELECT
	            *
            FROM
    	        TBL_SCHOOL_ATTEND
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>     
        
        <cfreturn ls.retval>           
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAndUpdateCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="copyAndUpdateCertificate" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = copyCertificate(id).result>
    	    <cfset ls.result2 = updateCertificate(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewCertificateId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewCertificateId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_SCHOOL_ATTEND_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="createCertificate" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />
        <cfargument name="id" type="numeric" required="true" />
        <cfargument name="personal_profile_id" type="numeric" required="true" />
        <cfargument name="relative_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>         
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_SCHOOL_ATTEND_ALT
            (
                ID,
                EXTERNID,
                PERSONALPROFILEID,
                PROFILEMEMBERID,
                CRTBY,
                CRTON
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#personal_profile_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#relative_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery> 
 
        
        <cfreturn ls.retval>           
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createAndUpdateCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createAndUpdateCertificate" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" />  
        <cfargument name="personal_profile_id" type="numeric" required="true" />          
        <cfargument name="relative_id" type="numeric" required="true" /> 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = createCertificate(username, staff_member_id, id, personal_profile_id, relative_id).result>
    	    <cfset ls.result2 = updateCertificate(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="updateCertificate" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />
        <cfargument name="id" type="numeric" required="true" />     
        <cfargument name="rc" type="struct" required="true" />
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>    
            
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE 
            	TBL_SCHOOL_ATTEND_ALT SA
			SET  
                SA.RECEPTION = TO_DATE(<cfqueryparam value="#rc.reception_date#" cfsqltype="cf_sql_varchar" />, 'DD/MM/YYYY'),
                SA.VALIDITY_FROM = TO_DATE(<cfqueryparam value="#rc.validity_from#" cfsqltype="cf_sql_varchar" />, 'DD/MM/YYYY'),
                SA.VALIDITY_TO = TO_DATE(<cfqueryparam value="#rc.validity_until#" cfsqltype="cf_sql_varchar" />, 'DD/MM/YYYY'),
                SA.COMMENTS = <cfqueryparam value="#rc.comments#" cfsqltype="cf_sql_varchar" />,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE  
			WHERE
            	SA.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
        </cfquery>    
        
        <cfreturn ls.retval>           
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="deleteCertificate" access="public" returntype="struct">       
        <cfargument name="id" type="numeric" required="true" />      
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>    
            
        <cfquery datasource="#Application.settings.dsn#">                 
            DELETE FROM 
            	TBL_SCHOOL_ATTEND_ALT SA
			WHERE
            	SA.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />         	
        </cfquery>    
        
        <cfreturn ls.retval>           
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isCertificateRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="isCertificateRemoved" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_SCHOOL_ATTEND_ALT
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
	Function RemoveCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="RemoveCertificate" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />       
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>         

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_SCHOOL_ATTEND_ALT
			SET
            	DELETED = 'Y',
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function restoreCertificate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="restoreCertificate" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />       
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>          

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_SCHOOL_ATTEND_ALT
			SET
            	DELETED = NULL,
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>   
        
	</cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateCertificateFile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="updateCertificateFile" access="public" returntype="struct">
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
                TBL_SCHOOL_ATTEND_ALT
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
	Function getScholarshipsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="getScholarshipsQry" access="public" returntype="query">
        <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                SC.ID,
                SC.PROFILEMEMBERID RELATIVE_ID,
                SC.NATURE,
                SC.MONTHLY_AMOUNT,
                SC.EVENT_YEAR ACADEMIC_YEAR,
                SC.COMMENTS,
                NVL(SC.DELETED, 'N') DELETED,
                SC.UPLD_NAME SCHOLARSHIP_FILENAME,
                SC.UPLD_MIME,
                Hash_MD5_Blob(UPLD_DATA) UPLD_HASH   
            FROM
           		TBL_SCHOLARSHIP_ALT SC
            WHERE
            	SC.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
                AND SC.DELETED IS NULL
            ORDER BY
            	SC.PROFILEMEMBERID,
            	SC.EVENT_YEAR DESC
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="hasScholarship" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_SCHOLARSHIP_ALT    
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
    </cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getScholarshipQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="getScholarshipQry" access="public" returntype="query">
        <cfargument name="scholarship_id" type="numeric" required="true" />       
        
        <cfset var ls = {}>

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                SC.ID,
                SC.PROFILEMEMBERID RELATIVE_ID,
                SC.NATURE,
                SC.MONTHLY_AMOUNT,
                SC.EVENT_YEAR ACADEMIC_YEAR,
                SC.COMMENTS,
                NVL(SC.DELETED, 'N') DELETED,
                SC.UPLD_NAME SCHOLARSHIP_FILENAME,                              
                SC.UPLD_MIME
            FROM
           		TBL_SCHOLARSHIP_ALT SC
            WHERE
            	SC.ID = <cfqueryparam value="#scholarship_id#" cfsqltype="cf_sql_integer" />                                 
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getScholarshipFileQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="getScholarshipFileQry" access="public" returntype="query">
        <cfargument name="scholarship_id" type="numeric" required="true" />
        <cfargument name="hash" type="string" required="true" />
        
        <cfset var ls = {}>

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                SC.UPLD_NAME,
                SC.UPLD_DATA,
                SC.UPLD_MIME,
                SC.MODBY,
                SC.MODON  
            FROM
           		TBL_SCHOLARSHIP SC
            WHERE
            	SC.ID = <cfqueryparam value="#scholarship_id#" cfsqltype="cf_sql_integer" />
                AND Hash_MD5_Blob (SC.UPLD_DATA) = '#hash#'   
			UNION ALL
            SELECT
                SC.UPLD_NAME,
                SC.UPLD_DATA,
                SC.UPLD_MIME,
                SC.MODBY,
                SC.MODON 
            FROM
           		TBL_SCHOLARSHIP_ALT SC
            WHERE
            	SC.ID = <cfqueryparam value="#scholarship_id#" cfsqltype="cf_sql_integer" />
                AND Hash_MD5_Blob (SC.UPLD_DATA) = '#hash#'                 
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="copyScholarship" access="public" returntype="struct">
        <cfargument name="scholarship_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>    

        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_SCHOLARSHIP_ALT
            SELECT
	            *
            FROM
    	        TBL_SCHOLARSHIP
            WHERE
        	    ID = <cfqueryparam value="#relative_id#" cfsqltype="cf_sql_integer" />
        </cfquery>     
        
        <cfreturn ls.retval>          
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAndUpdateScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="copyAndUpdateScholarship" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" />  		 
        <cfargument name="rc" type="struct" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = copyScholarship(id).result>
    	    <cfset ls.result2 = updateScholarship(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewScholarshipId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewScholarshipId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_SCHOLARSHIP_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="createScholarship" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />
        <cfargument name="personal_profile_id" type="numeric" required="true" />
        <cfargument name="relative_id" type="numeric" required="true" />
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>   
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_SCHOLARSHIP_ALT
            (
                ID,
                EXTERNID,
                PERSONALPROFILEID,
                PROFILEMEMBERID,
                MODBY,
                MODON
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#personal_profile_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#relative_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery>          
        
        <cfreturn ls.retval>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createAndUpdateScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="createAndUpdateScholarship" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />		
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" />  
        <cfargument name="personal_profile_id" type="numeric" required="true" />          
        <cfargument name="relative_id" type="numeric" required="true" /> 
        <cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        
        <cftransaction>
        
	        <cfset ls.result1 = createScholarship(username, staff_member_id, personal_profile_id, relative_id, id).result>
    	    <cfset ls.result2 = updateScholarship(username, id, rc).result> 
        
        </cftransaction>
        
        <cfset ls.retval.result1 = ls.result1>
        <cfset ls.retval.result2 = ls.result2>        
        
        <cfreturn ls.retval>
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="updateScholarship" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />
        <cfargument name="id" type="numeric" required="true" />
        <cfargument name="rc" type="struct" required="true" />
        
        <cfset var ls = {}>	
        <cfset ls.retval.result = "OK">   
            
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE 
            	TBL_SCHOLARSHIP_ALT SC
			SET  
                SC.NATURE = <cfqueryparam value="#rc.nature#" cfsqltype="cf_sql_varchar" />,
                SC.MONTHLY_AMOUNT = <cfqueryparam value="#rc.monthly_amount#" cfsqltype="cf_sql_numeric" null="#rc.monthly_amount EQ ''#"/>,
                SC.EVENT_YEAR = <cfqueryparam value="#rc.academic_year#" cfsqltype="cf_sql_varchar" />,
                SC.COMMENTS = <cfqueryparam value="#rc.comments#" cfsqltype="cf_sql_varchar" />,
                SC.CRTBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SC.CRTON = SYSDATE   
			WHERE
            	SC.ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric" />            	                         	
        </cfquery>    
        
        <cfreturn ls.retval>           
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="deleteScholarship" access="public" returntype="struct">       
        <cfargument name="id" type="numeric" required="true" />       
        
        <cfset var ls = {}>	
        <cfset ls.retval.result = "OK">     
            
        <cfquery datasource="#Application.settings.dsn#">                 
            DELETE FROM 
            	TBL_SCHOLARSHIP_ALT 
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric" />            	                         	
        </cfquery>    
        
        <cfreturn ls.retval>           
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isScholarshipRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="isScholarshipRemoved" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_SCHOLARSHIP_ALT
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
	Function updateScholarshipFile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="updateScholarshipFile" access="public" returntype="struct">
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
                TBL_SCHOLARSHIP_ALT
            SET
                UPLD_DATA =  <cfqueryparam value="#ls.file_blob#" cfsqltype="cf_sql_blob">,
                UPLD_NAME = <cfqueryparam value="#file.clientFile#" cfsqltype="cf_sql_varchar">,
<!---                UPLD_MIME = <cfqueryparam value="#file.contentType#/#file.contentSubType#" cfsqltype="cf_sql_varchar">, --->
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
	Function RemoveScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="RemoveScholarship" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />       
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>         

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_SCHOLARSHIP_ALT
			SET
            	DELETED = 'Y',
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function restoreScholarship
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="restoreScholarship" access="public" returntype="struct">
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />       
        
        <cfset var ls = {}>	
        <cfset ls.retval = {result:"OK"}>   >        

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_SCHOLARSHIP_ALT
			SET
            	DELETED = NULL,
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>           
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
                        T2.EXTERNID,
                        NVL(T1.MODON,T1.CRTON) LAST_UPDATED_ON,
                        NVL(T1.MODBY,T1.CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_PROFILE_MEMBERS_ALT T1,
                        TBL_PERSONALPROFILES_ALT T2 
                    WHERE 
                        T1.PERSONALPROFILEID = T2.ID
                        AND T2.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                    UNION
                    SELECT
                        T2.EXTERNID,
                        NVL(T1.MODON,T1.CRTON) LAST_UPDATED_ON,
                        NVL(T1.MODBY,T1.CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_SCHOOL_ATTEND_ALT T1,
                        TBL_PERSONALPROFILES_ALT T2
                    WHERE 
                        T1.PERSONALPROFILEID = T2.ID
                        AND T2.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                    UNION
                    SELECT
                        T2.EXTERNID,
                        NVL(T1.MODON,T1.CRTON) LAST_UPDATED_ON,
                        NVL(T1.MODBY,T1.CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_SCHOLARSHIP_ALT T1,
                        TBL_PERSONALPROFILES_ALT T2
                    WHERE 
                        T1.PERSONALPROFILEID = T2.ID
                        AND T2.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                    ORDER BY 
                        LAST_UPDATED_ON DESC
                )
            WHERE
	            ROWNUM = 1  
		</cfquery>  
        
        <cfreturn ls.qry>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function transactQry()
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="transactQry" access="public" returntype="struct"> 
        <cfargument name="calls" type="array" required="true" />   
        
        <cfset var ls = {}>
        <cfset ls.retval["result"] = "OK">
        <cfset ls.retval["retvals"] = []> 
        <cfset ls.retval["calls"] = calls> 
        <cfset ls.id = "">        
        
        <cftransaction>
			
            <cfloop array="#calls#" index="ls.call"> 
            
<!---                <cfif isNumeric(ls.id)>
                	<cfset ls.call.args.id = ls.id>
                    <cfset ls.id = "">
                </cfif>  --->        
            
                <cfinvoke
                	method="#ls.call.func#"                                   	
	                argumentCollection="#ls.call.args#"
                    returnvariable="ls.returnVariable" 
                >
                
<!---                <cfif isNumeric(ls.returnVariable)>
                	<cfset ls.id = ls.returnVariable>
                </cfif>--->
                
				<cfset ls.tmp = {}>				
                <cfset ls.tmp["func"] = ls.call.func>  
                <cfset ls.tmp["args"] = ls.call.args>  
                <cfset ls.tmp["retval"] = structKeyExists(ls, "returnVariable") ? ls.returnVariable : "N/A"> 
                <cfset ArrayAppend(ls.retval.retvals, ls.tmp)>
            
            </cfloop>
        
        </cftransaction>   
        
        <cfreturn ls.retval>         
           
	</cffunction>                  
    
</cfcomponent>    