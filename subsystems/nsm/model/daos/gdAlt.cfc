<cfcomponent accessors="Yes">
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getPersonalDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
	<cffunction name="getPersonalDetailsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	   
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	EX.ID STAFF_MEMBER_ID,
                EX.SURNAME LAST_NAME,
                EX.NAME AS FIRST_NAME,                
                EX.MAIDEN_NAME,
                EX.GENDER,
                TRIM(TRAILING '.' FROM EX.TITLE) CIVILITY,
                TRUNC(MONTHS_BETWEEN(SYSDATE, EX.BIRTHDATE)/12) AGE,
                EX.SS_NBR SOCIAL_SECURITY_NUMBER,
                TO_CHAR(EX.BIRTHDATE,'DD/MM/YYYY') DATE_OF_BIRTH,
                TO_CHAR(EX.DEATH_DATE,'DD/MM/YYYY') DATE_OF_DEATH,                
                EX.BIRTHCOUNTRYID BIRTH_COUNTRY_CODE,                
                INITCAP(CTRY.COUNTRYNAME) BIRTH_COUNTRY,
                EX.NATIONALITYCOUNTRYID CITIZENSHIP_1_COUNTRY_CODE,
                INITCAP(CTRY1.COUNTRYNAME) CITIZENSHIP_1_COUNTRY,
                EX.NATIONALITYCOUNTRYID_2 CITIZENSHIP_2_COUNTRY_CODE,
                INITCAP(CTRY2.COUNTRYNAME) CITIZENSHIP_2_COUNTRY,
                <!---EX.NATIONALITYCOUNTRYID_3 CITIZENSHIP_3_COUNTRY_CODE,--->
                <!---INITCAP(CTRY3.COUNTRYNAME) CITIZENSHIP_3_COUNTRY,--->    
                EX.NATIONALITYCOUNTRYID_3 OTHER_CITIZENSHIPS,            
                EX.LANG_1 LANGUAGE_1_ID,
                LANG1.LABEL LANGUAGE_1,
                EX.LANG_2 LANGUAGE_2_ID,
                LANG2.LABEL LANGUAGE_2,
                EX.LANG_3 LANGUAGE_3,
                PERS_DATA_COMMENTS COMMENTS          
            FROM
                TBL_EXTERNS_ALT EX,
                TBL_COUNTRIESINFO CTRY,
                TBL_COUNTRIESINFO CTRY1,
                TBL_COUNTRIESINFO CTRY2,
                <!---TBL_COUNTRIESINFO CTRY3,--->
                TBL_LANGUAGES LANG1,
                TBL_LANGUAGES LANG2                
            WHERE
                EX.BIRTHCOUNTRYID = CTRY.COUNTRYID(+)
                AND EX.NATIONALITYCOUNTRYID = CTRY1.COUNTRYID(+)
                AND EX.NATIONALITYCOUNTRYID_2 = CTRY2.COUNTRYID(+)
                <!---AND EX.NATIONALITYCOUNTRYID_3 = CTRY3.COUNTRYID(+)--->
                AND EX.LANG_1 = LANG1.ISO_CODE(+)
                AND EX.LANG_2 = LANG2.ISO_CODE(+)                
	            AND EX.ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                               
		</cfquery>                     
        
		<cfreturn ls.qry>
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getFamilyDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getFamilyDetailsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
            SELECT 
                P.ID,
                P.EXTERNID STAFF_MEMBER_ID,
                P.MARIAGESTATUS,                
                TO_CHAR(P.VALIDITYDATE,'DD/MM/YYYY') VALIDITYDATE,  
                TO_CHAR(P.SINCEDATE,'DD/MM/YYYY') SINCEDATE,  
                P.COMMENTS,
                P.COUNTRYID,
                ZT.LIB_EN_ZONE COUNTRY_EN,
                ZT.LIB_FR_ZONE COUNTRY_FR,                
                P.CITY,
                DECODE(P.MARIAGESTATUS,2,1,4,3,6,5,8,7,10,9,P.MARIAGESTATUS) AS DECODED_MARITAL_STATUS_ID,
                CASE 
                	WHEN P.MARIAGESTATUS IN (1,2) THEN 'MAR'
                	WHEN P.MARIAGESTATUS IN (3,4) THEN 'SEP'
                	WHEN P.MARIAGESTATUS IN (5,6) THEN 'DIV'
                	WHEN P.MARIAGESTATUS IN (7,8) THEN 'WID'
                	WHEN P.MARIAGESTATUS IN (9,10) THEN 'SIN'
                	WHEN P.MARIAGESTATUS IN (11,12) THEN 'CIV'
				END MARITAL_STATUS                                                                                                                        
            FROM 
                TBL_PERSONALPROFILES_ALT P,
                APP_TABLES.ZONE_T ZT  
            WHERE 
                P.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />    
                AND P.COUNTRYID = ZT.CODE_ZONE(+)
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRelativesQry	
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      

	<cffunction name="getRelativesQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
		<cfset var ls = {}>	  
    
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">     
            SELECT
                PM.ID,
                PM.FAMILYLINK,
                DECODE(PM.DEPENDENT,'Yes','Y','No','N',PM.DEPENDENT) DEPENDENT,
                NVL(DELETED,'N') DELETED
            FROM
                TBL_PERSONALPROFILES_ALT PP,
                TBL_PROFILE_MEMBERS_ALT PM
            WHERE
                PP.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
                AND PP.ID = PM.PERSONALPROFILEID                 
        </cfquery>
        
		<cfreturn ls.qry>        

	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAddressesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->          
    
	<cffunction name="getAddressesQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">    
            SELECT 
                T1.LIB_EN_ZONE BUSINESS_CTRY_EN,
                T1.LIB_FR_ZONE BUSINESS_CTRY_FR,
                T2.LIB_EN_ZONE PRIVATE_CTRY_EN,
                T2.LIB_FR_ZONE PRIVATE_CTRY_FR,
                TO_CHAR(R.VALIDITYDATE, 'DD/MM/YYYY') VALIDITYDATE,
                DECODE(R.LIFE_3_MONTHS,'0','Y',R.LIFE_3_MONTHS) LIFE_3_MONTHS,
                R.*              
            FROM 
                TBL_RESIDENCES_ALT R,
                APP_TABLES.ZONE_T T1,
                APP_TABLES.ZONE_T T2
            WHERE 
                R.ID = (SELECT MAX(ID) FROM TBL_RESIDENCES_ALT R2 WHERE R2.EXTERNID = R.EXTERNID)
                AND R.COUNTRYID = t1.code_zone(+)
                AND R.PRIVATE_COUNTRYID = t2.code_zone(+)
                AND R.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />   
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getMedicalsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->          
    
	<cffunction name="getMedicalsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
                ID,
                REMARKS,
                VERSION,
                EXTERNID,
                TO_CHAR(VALIDITY_FROM,'DD/MM/YYYY') VALIDITY_FROM,
                TO_CHAR(VALIDITY_TO, 'DD/MM/YYYY') VALIDITY_TO,
                NVL(STATUS,'') STATUS,
                MEDICAL_CENTER,
                NVL(DELETED,'N') DELETED,
                CRTBY,
                MODON,
                MODBY,
                UPLD_NAME,               
                UPLD_MIME,
                Hash_MD5_Blob(UPLD_DATA) UPLD_HASH                
            FROM
	            TBL_MEDIC_CERTIFICATE_ALT
            WHERE 
    	        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                 
			ORDER BY
            	VALIDITY_TO DESC
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getMedicalQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->          
    
	<cffunction name="getMedicalQry" access="public" returntype="query">
		<cfargument name="medical_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
                ID,
                REMARKS,
                VERSION,
                EXTERNID,
                TO_CHAR(VALIDITY_FROM,'DD/MM/YYYY') VALIDITY_FROM,
                TO_CHAR(VALIDITY_TO, 'DD/MM/YYYY') VALIDITY_TO,
                STATUS,
                MEDICAL_CENTER,
                NVL(DELETED,'N') DELETED,
                CRTBY,
                MODON,
                MODBY,
                UPLD_NAME,                
                UPLD_MIME
            FROM
	            TBL_MEDIC_CERTIFICATE_ALT
            WHERE 
    	        ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer" /> 			                  
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDocumentsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    
    
	<cffunction name="getDocumentsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                 
            SELECT
                T1.LIB_EN_ZONE DL_CTRY_EN,
                T1.LIB_FR_ZONE DL_CTRY_FR,
                T2.LIB_EN_ZONE PASS_CTRY_EN,
                T2.LIB_FR_ZONE PASS_CTRY_FR,
                T3.LIB_EN_ZONE PASS2_CTRY_EN,
                T3.LIB_FR_ZONE PASS2_CTRY_FR,
                T4.LIB_EN_ZONE WL_CTRY_EN,
                T4.LIB_FR_ZONE WL_CTRY_FR,
                T5.LIB_EN_ZONE RP_CTRY_EN,
                T5.LIB_FR_ZONE RP_CTRY_FR,
                T6.LIB_EN_ZONE EBDG_CTRY_EN,
                T6.LIB_FR_ZONE EBDG_CTRY_FR,
                T7.LIB_EN_ZONE DBDG_CTRY_EN,
                T7.LIB_FR_ZONE DBDG_CTRY_FR,
                T8.LIB_EN_ZONE LAP_CTRY_EN,
                T8.LIB_FR_ZONE LAP_CTRY_FR,
                T9.LIB_EN_ZONE JUREP_CTRY_EN,
                T9.LIB_FR_ZONE JUREP_CTRY_FR,                   
                TO_CHAR(D.DL_START_DATE,'DD/MM/YYYY') DL_START_DATE,
                TO_CHAR(D.DL_END_DATE,'DD/MM/YYYY') DL_END_DATE,
                TO_CHAR(D.ECHQ_START_DATE,'DD/MM/YYYY') ECHQ_START_DATE,
                TO_CHAR(D.ECHQ_END_DATE,'DD/MM/YYYY') ECHQ_END_DATE,
                TO_CHAR(D.MOFA_START_DATE,'DD/MM/YYYY') MOFA_START_DATE,
                TO_CHAR(D.MOFA_END_DATE,'DD/MM/YYYY') MOFA_END_DATE,
                TO_CHAR(D.EBDG_START_DATE,'DD/MM/YYYY') EBDG_START_DATE,
                TO_CHAR(D.EBDG_END_DATE,'DD/MM/YYYY') EBDG_END_DATE,
                TO_CHAR(D.DBDG_START_DATE,'DD/MM/YYYY') DBDG_START_DATE,
                TO_CHAR(D.DBDG_END_DATE,'DD/MM/YYYY') DBDG_END_DATE,
                TO_CHAR(D.PASS_START_DATE,'DD/MM/YYYY') PASS_START_DATE,
                TO_CHAR(D.PASS_END_DATE,'DD/MM/YYYY') PASS_END_DATE,
                TO_CHAR(D.PASS2_START_DATE,'DD/MM/YYYY') PASS2_START_DATE,
                TO_CHAR(D.PASS2_END_DATE,'DD/MM/YYYY') PASS2_END_DATE,                
                TO_CHAR(D.WL_START_DATE,'DD/MM/YYYY') WL_START_DATE,
                TO_CHAR(D.WL_END_DATE,'DD/MM/YYYY') WL_END_DATE,  
                TO_CHAR(D.LAISS_START_DATE,'DD/MM/YYYY') LAISS_START_DATE,
                TO_CHAR(D.LAISS_END_DATE,'DD/MM/YYYY') LAISS_END_DATE,         
                TO_CHAR(D.RP_START_DATE,'DD/MM/YYYY') RP_START_DATE,
                TO_CHAR(D.RP_END_DATE,'DD/MM/YYYY') RP_END_DATE, 
                'ALT' ENV,
                Hash_MD5_Blob(DL_UPLD_DATA) DL_UPLD_HASH,
                Hash_MD5_Blob(PASS_UPLD_DATA) PASS_UPLD_HASH,
                Hash_MD5_Blob(PASS2_UPLD_DATA) PASS2_UPLD_HASH,                
                Hash_MD5_Blob(WL_UPLD_DATA) WL_UPLD_HASH,      
                Hash_MD5_Blob(RP_UPLD_DATA) RP_UPLD_HASH,  
                Hash_MD5_Blob(EBDG_UPLD_DATA) EBDG_UPLD_HASH,
                Hash_MD5_Blob(D.DBDG_UPLD_DATA) DBDG_UPLD_HASH,
                Hash_MD5_Blob(LAISS_UPLD_DATA) LAISS_UPLD_HASH,  
                Hash_MD5_Blob(LAISS_UPLD_DATA) LAISS_UPLD_HASH,  
                Hash_MD5_Blob(JUREP_UPLD_DATA) JUREP_UPLD_HASH,
                Hash_MD5_Blob(CV_UPLD_DATA) CV_UPLD_HASH,                
                D.*
            FROM 
                TBL_ADM_DOC_ALT D,
                APP_TABLES.ZONE_T T1,
                APP_TABLES.ZONE_T T2,
                APP_TABLES.ZONE_T T3,
                APP_TABLES.ZONE_T T4,
                APP_TABLES.ZONE_T T5,
                APP_TABLES.ZONE_T T6,
                APP_TABLES.ZONE_T T7,
                APP_TABLES.ZONE_T T8,
				APP_TABLES.ZONE_T T9
            WHERE 
                D.DL_CTRY = T1.CODE_ZONE(+)
                AND D.PASS_CTRY = T2.CODE_ZONE(+)
                AND D.PASS2_CTRY = T3.CODE_ZONE(+)
                AND D.WL_CTRY = T4.CODE_ZONE(+)
                AND D.RP_CTRY = T5.CODE_ZONE(+)
                AND D.EBDG_CTRY = T6.CODE_ZONE(+)
                AND D.DBDG_CTRY = T7.CODE_ZONE(+)
                AND D.LAISS_CTRY = T8.CODE_ZONE(+) 
				AND D.JUREP_CTRY = T9.CODE_ZONE(+)                 
                AND D.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasExtern
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasExtern" access="public" returntype="boolean">   
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        
    	<cfset var ls = {}> 
        <cfset ls.retval = true> 
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_EXTERNS_ALT       
			WHERE     
	            ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery>        
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>                
        
        <cfreturn ls.retval>    
    </cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateExtern
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updateExtern" access="public" returntype="string">
	    <cfargument name="username" type="string" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>	
        <cfset ls.result = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
            	TBL_EXTERNS_ALT
            SET 
	            SURNAME = <cfqueryparam value="#rc.last_name#" cfsqltype="cf_sql_varchar" />,
    	        NAME = <cfqueryparam value="#rc.first_name#" cfsqltype="cf_sql_varchar" />,                                
                MAIDEN_NAME = <cfqueryparam value="#rc.maiden_name#" cfsqltype="cf_sql_varchar" />,
                GENDER = <cfqueryparam value="#rc.gender#" cfsqltype="cf_sql_varchar" />, 
                SS_NBR = <cfqueryparam value="#rc.social_security_number#" cfsqltype="cf_sql_varchar" />,
                BIRTHDATE = TO_DATE(<cfqueryparam value="#rc.date_of_birth#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DEATH_DATE = TO_DATE(<cfqueryparam value="#rc.date_of_death#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),            
                BIRTHCOUNTRYID = <cfqueryparam value="#rc.birth_country_code#" cfsqltype="cf_sql_varchar" />,  
                NATIONALITYCOUNTRYID = <cfqueryparam value="#rc.citizenship_1_country_code#" cfsqltype="cf_sql_varchar" />,
                NATIONALITYCOUNTRYID_2 = <cfqueryparam value="#rc.citizenship_2_country_code#" cfsqltype="cf_sql_varchar" />,
<!---                NATIONALITYCOUNTRYID_3 = <cfqueryparam value="#rc.citizenship_3_country_code#" cfsqltype="cf_sql_varchar" />,  --->
                NATIONALITYCOUNTRYID_3 = <cfqueryparam value="#rc.other_citizenships#" cfsqltype="cf_sql_varchar" />,                             
                LANG_1 = <cfqueryparam value="#rc.language_1_id#" cfsqltype="cf_sql_varchar" />,
                LANG_2 = <cfqueryparam value="#rc.language_2_id#" cfsqltype="cf_sql_varchar" />,
                LANG_3 = <cfqueryparam value="#rc.language_3#" cfsqltype="cf_sql_varchar" />,
                PERS_DATA_COMMENTS = <cfqueryparam value="#rc.comments#" cfsqltype="cf_sql_varchar" />,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE                
            WHERE 
                ID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />           
		</cfquery> 
        
        <cfreturn ls.result>
        
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyExtern
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyExtern" access="public" returntype="string"> 
        <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_EXTERNS_ALT
            SELECT
	            *
            FROM
    	        TBL_EXTERNS
            WHERE
        	    ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteExtern
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="deleteExtern" access="public" returntype="string"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	TBL_EXTERNS_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>       
    
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
                CRTBY,
                CRTON
            )
            VALUES
            (		
                <cfqueryparam value="#personal_profile_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery> 

		<cfreturn ls.retval>         
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updatePersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updatePersonalProfile" access="public" returntype="string">   
	    <cfargument name="username" type="string" required="true" />       
        <cfargument name="staff_member_id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_PERSONALPROFILES_ALT
            SET                                 
                MARIAGESTATUS = <cfqueryparam value="#rc.ms_status#" cfsqltype="cf_sql_integer" null="#rc.ms_status EQ 0#"/>,
                COUNTRYID = <cfqueryparam value="#rc.ms_country_code#" cfsqltype="cf_sql_varchar" />, 
                SINCEDATE = TO_DATE(<cfqueryparam value="#rc.ms_effective_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />           
        </cfquery>   

		<cfreturn ls.retval>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyPersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyPersonalProfile" access="public" returntype="string">   	          
        <cfargument name="staff_member_id" type="numeric" required="true" />		
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_PERSONALPROFILES_ALT
            SELECT
	            *
            FROM
    	        TBL_PERSONALPROFILES
            WHERE
        	    ID = 
                (
            		SELECT
			            MAX(ID) ID
		            FROM
            			TBL_PERSONALPROFILES
		            WHERE
        			    EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
           		)                  
        </cfquery>

		<cfreturn ls.retval>        
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deletePersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="deletePersonalProfile" access="public" returntype="string">   	          
        <cfargument name="id" type="numeric" required="true" />		
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	TBL_PERSONALPROFILES_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>

		<cfreturn ls.retval>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasAddress (there can only be one address in Alt)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasAddress" access="public" returntype="numeric">   
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>       
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_RESIDENCES_ALT      
			WHERE     
	            EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery>       
        
        <cfreturn ls.qry.cnt>    
    </cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateAddress
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updateAddress" access="public" returntype="string">   
	    <cfargument name="username" type="string" required="true" />
        <cfargument name="address_id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_RESIDENCES_ALT
            SET                                 
                ADDRESSLINE1 = <cfqueryparam value="#rc.business_address_street#" cfsqltype="cf_sql_varchar" />,
                CITY = <cfqueryparam value="#rc.business_address_city#" cfsqltype="cf_sql_varchar" />,
                POSTALCODE = <cfqueryparam value="#rc.business_address_postal_code#" cfsqltype="cf_sql_varchar" />,
                COUNTRYID = <cfqueryparam value="#rc.business_address_country_code#" cfsqltype="cf_sql_varchar" />,
                VALIDITYDATE = TO_DATE(<cfqueryparam value="#rc.business_address_effective_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                PRIVATE_ADDRESS = <cfqueryparam value="#rc.private_address_street#" cfsqltype="cf_sql_varchar" />,
                PRIVATE_CITY = <cfqueryparam value="#rc.private_address_city#" cfsqltype="cf_sql_varchar" />,
                PRIVATE_POSTALCODE = <cfqueryparam value="#rc.private_address_postal_code#" cfsqltype="cf_sql_varchar" />,
                PRIVATE_COUNTRYID = <cfqueryparam value="#rc.private_address_country_code#" cfsqltype="cf_sql_varchar" />,
                PHONENUMBER = <cfqueryparam value="#rc.private_address_phone_nbr#" cfsqltype="cf_sql_varchar" />,
                MOBILNUMBER = <cfqueryparam value="#rc.private_mobile_nbr_1#" cfsqltype="cf_sql_varchar" />,
                MOBILNUMBER2 = <cfqueryparam value="#rc.private_mobile_nbr_2#" cfsqltype="cf_sql_varchar" />,
                <!---EMAIL = <cfqueryparam value="#rc.private_email#" cfsqltype="cf_sql_varchar" />,--->
                LIFE_3_MONTHS = <cfqueryparam value="#rc.life_3_months#" cfsqltype="cf_sql_varchar" />,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                ID = <cfqueryparam value="#address_id#" cfsqltype="cf_sql_integer" />           
        </cfquery>      

		<cfreturn ls.retval>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyAddress
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyAddress" access="public" returntype="string"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_RESIDENCES_ALT
            SELECT
	            *
            FROM
    	        TBL_RESIDENCES
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewAddressId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewAddressId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_RESIDENCES_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createAddress
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createAddress" access="public" returntype="string"> 
        <cfargument name="id" type="numeric" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />
        <cfargument name="username" type="string" required="true" />        
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO TBL_RESIDENCES_ALT
            (
            	ID,
                EXTERNID,
                VALIDITYDATE,
                CRTBY,
                CRTON,
                VERS_NUM
            )
            VALUES
            (
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                SYSDATE,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE,
                0  
            )
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteAddress
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="deleteAddress" access="public" returntype="string"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM
            	TBL_RESIDENCES_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>        
        
        
        <cfreturn ls.retval>        
	</cffunction>                    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasDocuments (all documents in one record, one record per staff member)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasDocuments" access="public" returntype="numeric">   
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>       
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_ADM_DOC_ALT   
			WHERE     
	            EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery>       
        
        <cfreturn ls.qry.cnt>    
    </cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewDocumentsId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewDocumentsId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_ADM_DOC_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createDocuments
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createDocuments" access="public" returntype="struct">   
        <cfargument name="id" type="numeric" required="true" /> 
        <cfargument name="staff_member_id" type="numeric" required="true" />   
        <cfargument name="username" type="string" required="true" />
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>     
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_ADM_DOC_ALT
            (
                ID,
                EXTERNID,
                CRTBY,
                CRTON                    
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE                                      
            )          
        </cfquery>        

		<cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateDocuments
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updateDocuments" access="public" returntype="string">   
	    <cfargument name="username" type="string" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_ADM_DOC_ALT
            SET        
                DL_CTRY = <cfqueryparam value="#rc.doc_dl_country_code#" cfsqltype="cf_sql_varchar" />,
                DL_DOC_NBR = <cfqueryparam value="#rc.doc_dl_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DL_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dl_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DL_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dl_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DL_DELIV_BY = <cfqueryparam value="#rc.doc_dl_issued_by#" cfsqltype="cf_sql_varchar" />,
                DL_DELIV_AT = <cfqueryparam value="#rc.doc_dl_issued_at#" cfsqltype="cf_sql_varchar" />,
                PASS_CTRY = <cfqueryparam value="#rc.doc_pass_country_code#" cfsqltype="cf_sql_varchar" />,
                PASS_DOC_NBR = <cfqueryparam value="#rc.doc_pass_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                PASS_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                PASS_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                PASS_DELIV_BY = <cfqueryparam value="#rc.doc_pass_issued_by#" cfsqltype="cf_sql_varchar" />,
                PASS_DELIV_AT = <cfqueryparam value="#rc.doc_pass_issued_at#" cfsqltype="cf_sql_varchar" />,
                PASS2_CTRY = <cfqueryparam value="#rc.doc_pass2_country_code#" cfsqltype="cf_sql_varchar" />,
                PASS2_DOC_NBR = <cfqueryparam value="#rc.doc_pass2_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                PASS2_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass2_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                PASS2_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass2_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                PASS2_DELIV_BY = <cfqueryparam value="#rc.doc_pass2_issued_by#" cfsqltype="cf_sql_varchar" />,
                PASS2_DELIV_AT = <cfqueryparam value="#rc.doc_pass2_issued_at#" cfsqltype="cf_sql_varchar" />,    
                WL_CTRY = <cfqueryparam value="#rc.doc_wl_country_code#" cfsqltype="cf_sql_varchar" />,
                WL_DOC_NBR = <cfqueryparam value="#rc.doc_wl_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                WL_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_wl_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                WL_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_wl_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                WL_DELIV_BY = <cfqueryparam value="#rc.doc_wl_issued_by#" cfsqltype="cf_sql_varchar" />,
                WL_DELIV_AT = <cfqueryparam value="#rc.doc_wl_issued_at#" cfsqltype="cf_sql_varchar" />,
                RP_CTRY = <cfqueryparam value="#rc.doc_rp_country_code#" cfsqltype="cf_sql_varchar" />,
                RP_DOC_NBR = <cfqueryparam value="#rc.doc_rp_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                RP_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_rp_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                RP_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_rp_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                RP_DELIV_BY = <cfqueryparam value="#rc.doc_rp_issued_by#" cfsqltype="cf_sql_varchar" />,
                RP_DELIV_AT = <cfqueryparam value="#rc.doc_rp_issued_at#" cfsqltype="cf_sql_varchar" />,
                EBDG_CTRY = <cfqueryparam value="#rc.doc_ebdg_country_code#" cfsqltype="cf_sql_varchar" />,
                EBDG_DOC_NBR = <cfqueryparam value="#rc.doc_ebdg_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                EBDG_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_ebdg_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                EBDG_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_ebdg_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                EBDG_DELIV_BY = <cfqueryparam value="#rc.doc_ebdg_issued_by#" cfsqltype="cf_sql_varchar" />,
                EBDG_DELIV_AT = <cfqueryparam value="#rc.doc_ebdg_issued_at#" cfsqltype="cf_sql_varchar" />,  
                DBDG_CTRY = <cfqueryparam value="#rc.doc_dbdg_country_code#" cfsqltype="cf_sql_varchar" />,
                DBDG_DOC_NBR = <cfqueryparam value="#rc.doc_dbdg_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DBDG_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dbdg_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DBDG_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dbdg_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DBDG_DELIV_BY = <cfqueryparam value="#rc.doc_dbdg_issued_by#" cfsqltype="cf_sql_varchar" />,
                DBDG_DELIV_AT = <cfqueryparam value="#rc.doc_dbdg_issued_at#" cfsqltype="cf_sql_varchar" />,  
                LAISS_CTRY = <cfqueryparam value="#rc.doc_lap_country_code#" cfsqltype="cf_sql_varchar" />,
                LAISS_DOC_NBR = <cfqueryparam value="#rc.doc_lap_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                LAISS_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_lap_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                LAISS_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_lap_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                LAISS_DELIV_BY = <cfqueryparam value="#rc.doc_lap_issued_by#" cfsqltype="cf_sql_varchar" />,
                LAISS_DELIV_AT = <cfqueryparam value="#rc.doc_lap_issued_at#" cfsqltype="cf_sql_varchar" />,
                JUREP_CTRY = <cfqueryparam value="#rc.doc_jurep_country_code#" cfsqltype="cf_sql_varchar" />,
                JUREP_DOC_NBR = <cfqueryparam value="#rc.doc_jurep_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                JUREP_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_jurep_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                JUREP_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_jurep_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                JUREP_DELIV_BY = <cfqueryparam value="#rc.doc_jurep_issued_by#" cfsqltype="cf_sql_varchar" />,
                JUREP_DELIV_AT = <cfqueryparam value="#rc.doc_jurep_issued_at#" cfsqltype="cf_sql_varchar" />,                 
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
			WHERE     
	            EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />             
		</cfquery>      

		<cfreturn ls.retval>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateDocumentFile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="updateDocumentFile" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />  
        <cfargument name="field" type="string" required="true" />  
        <cfargument name="rc" type="struct" required="true" />          
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        <cfset ls.retval.result = "OK">  	
        
        <cfset ls.filefield = "#field#_FILE">	            
            
		<cfset ls.tmp_file_dir = GetTempDirectory()>            

        <cffile 
            action="upload"           
            filefield="#ls.filefield#" 
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
	            TBL_ADM_DOC_ALT
			SET
                #field#_UPLD_DATA = <cfqueryparam value="#ls.file_blob#" cfsqltype="cf_sql_blob">,
                #field#_UPLD_NAME = <cfqueryparam value="#file.clientFile#" cfsqltype="cf_sql_varchar">,
                #field#_UPLD_MIME = <cfqueryparam value="#file.clientFileExt#" cfsqltype="cf_sql_varchar">,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">,
                MODON = SYSDATE 
            WHERE 
            	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">                  
		</cfquery>   
        
       <cffile 
            action="delete" 
            file="#ls.tmp_file_dir##cffile.serverFile#"
        >   
    
        <cfreturn ls.retval>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDocFileQry
	UNION ALL with TBL_ADM_DOC because we do not know wether file is in Main or Alt, 
	so use hash across the two tables
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getDocFileQry" access="public" returntype="query">
        <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />  
        <cfargument name="field" type="string" required="true" /> 
        <cfargument name="hash" type="string" required="true" />  
        
        <cfset var ls = {}>   
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                #field#_UPLD_DATA FILE_DATA,
                #field#_UPLD_NAME FILE_NAME,
                #field#_UPLD_MIME MIME_TYPE,               
                MODBY,
                MODON                
			FROM
				TBL_ADM_DOC
            WHERE 
            	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">   
                AND Hash_MD5_Blob (#field#_UPLD_DATA) = '#hash#'        
			UNION ALL <!---Cannot use UNION with BLOB datatype--->
            SELECT
                #field#_UPLD_DATA FILE_DATA,
                #field#_UPLD_NAME FILE_NAME,
                #field#_UPLD_MIME MIME_TYPE,               
                MODBY,
                MODON                
			FROM
				TBL_ADM_DOC_ALT                
            WHERE 
            	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">   
                AND Hash_MD5_Blob (#field#_UPLD_DATA) = '#hash#'                          
		</cfquery>                    
        
        <cfreturn ls.qry>        
	</cffunction>              
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyDocuments
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    
    
	<cffunction name="copyDocuments" access="public" returntype="string"> 
        <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_ADM_DOC_ALT
            SELECT
	            *
            FROM
    	        TBL_ADM_DOC
            WHERE
        	    EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteDocuments
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    
    
	<cffunction name="deleteDocuments" access="public" returntype="string"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	TBL_ADM_DOC_ALT    	        
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>   
      
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasMedicals
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasMedicals" access="public" returntype="numeric">       
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>       
        
       <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
              COUNT(*) CNT
            FROM
	            TBL_MEDIC_CERTIFICATE_ALT
            WHERE 
    	        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>     
        
        <cfreturn ls.qry.cnt>    
    </cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasMedical
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasMedical" access="public" returntype="numeric">       
	    <cfargument name="medical_id" type="numeric" required="true" />
        
        <cfset var ls = {}>       
        
       <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
              COUNT(*) CNT
            FROM
	            TBL_MEDIC_CERTIFICATE_ALT
            WHERE 
    	        ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>     
        
        <cfreturn ls.qry.cnt>    
    </cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewMedicalId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewMedicalId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                    
            SELECT 
                TBL_MEDIC_CERTIFICATE_SEQ.NEXTVAL AS ID
            FROM 
                DUAL                                
        </cfquery>  
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createMedical
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createMedical" access="public" returntype="struct">   		   
        <cfargument name="username" type="string" required="true" />
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        <cfargument name="id" type="numeric" required="true" />              
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_MEDIC_CERTIFICATE_ALT
            (
                ID,
                EXTERNID,
                VERSION,
                CRTBY,
                CRTON                   
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
               1,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,                    
                SYSDATE
            )          
        </cfquery>     

		<cfreturn ls.retval>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateMedical
	username is the editor's username
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updateMedical" access="public" returntype="string">  
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="medical_id" type="numeric" required="true" />              
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_MEDIC_CERTIFICATE_ALT
            SET 
                VALIDITY_FROM = TO_DATE(<cfqueryparam value="#rc.medical_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                VALIDITY_TO = TO_DATE(<cfqueryparam value="#rc.medical_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                STATUS = <cfqueryparam value="#rc.medical_status#" cfsqltype="cf_sql_varchar" />,
                REMARKS = <cfqueryparam value="#rc.medical_remarks#" cfsqltype="cf_sql_varchar" />,
                MEDICAL_CENTER = <cfqueryparam value="#rc.medical_center#" cfsqltype="cf_sql_varchar" />,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer" />           
        </cfquery>      

		<cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isMedicalRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="isMedicalRemoved" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TTBL_MEDIC_CERTIFICATE_ALT
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
	Function removeMedical
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="removeMedical" access="public" returntype="string">  
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_MEDIC_CERTIFICATE_ALT
            SET  
                DELETED = 'Y',
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />           
        </cfquery>      

		<cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function restoreMEdical
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="restoreMedical" access="public" returntype="string">  
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_MEDIC_CERTIFICATE_ALT
            SET  
                DELETED = NULL,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />           
        </cfquery>      

		<cfreturn ls.retval>        
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateMedicalFile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="updateMedicalFile" access="public" returntype="struct">
        <cfargument name="username" type="string" required="true" />
        <cfargument name="medical_id" type="numeric" required="true" />  
        <cfargument name="filefield" type="string" required="true" />        
        <cfargument name="rc" type="struct" required="true" />          
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        <cfset ls.retval.result = "OK">  		            
            
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
                TBL_MEDIC_CERTIFICATE_ALT
            SET
                UPLD_DATA =  <cfqueryparam value="#ls.file_blob#" cfsqltype="cf_sql_blob">,
                UPLD_NAME = <cfqueryparam value="#file.clientFile#" cfsqltype="cf_sql_varchar">,
                UPLD_MIME = <cfqueryparam value="#file.contentType#/#file.contentSubType#" cfsqltype="cf_sql_varchar">,                           
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">,
                MODON = SYSDATE                                              
            WHERE
            	ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer">    
        </cfquery>        
        
       <cffile 
            action="delete" 
            file="#ls.tmp_file_dir##cffile.serverFile#"
        >   
    
        <cfreturn ls.retval>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getMedFileQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getMedFileQry" access="public" returntype="query">
        <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />        
        <cfargument name="medical_id" type="numeric" required="true" />  
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
				TBL_MEDIC_CERTIFICATE             
            WHERE 
            	ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer">   
                AND Hash_MD5_Blob (UPLD_DATA) = '#hash#' 
			UNION ALL
            SELECT
                UPLD_DATA FILE_DATA,
                UPLD_NAME FILE_NAME,
                UPLD_MIME MIME_TYPE,
                MODBY,
                MODON
			FROM
				TBL_MEDIC_CERTIFICATE_ALT               
            WHERE 
            	ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer">   
                AND Hash_MD5_Blob (UPLD_DATA) = '#hash#'                                  
		</cfquery>                
        
        <cfreturn ls.qry>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyMedical
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    
    
	<cffunction name="copyMedical" access="public" returntype="string"> 
        <cfargument name="medical_id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_MEDIC_CERTIFICATE_ALT
            SELECT
	            *
            FROM
    	        TBL_MEDIC_CERTIFICATE
            WHERE
        	    ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteMedical
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    
    
	<cffunction name="deleteMedical" access="public" returntype="string">      
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM 
            	TBL_MEDIC_CERTIFICATE_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>   
        
        <cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getBankAccountsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->          
    
	<cffunction name="getBankAccountsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
            	ID,
                NVL(DELETED,'N') DELETED,
				BANK_NAME,
            	BANK_ACCOUNT_HOLDER,
            	BANK_ADDRESS, 
                BANK_IBAN,  
                BANK_BIC                       
            FROM
	            TBL_BANK_ACCOUNT_ALT
            WHERE 
    	        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                 
			ORDER BY
            	ID
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getBankAccountQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->          
    
	<cffunction name="getBankAccountQry" access="public" returntype="query">
		<cfargument name="bank_account_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>	
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
            	ID,
                NVL(DELETED,'N') DELETED,
				BANK_NAME,
            	BANK_ACCOUNT_HOLDER,
            	BANK_ADDRESS, 
                BANK_IBAN,  
                BANK_BIC                       
            FROM
	            TBL_BANK_ACCOUNT_ALT
            WHERE  
    	        ID = <cfqueryparam value="#bank_account_id#" cfsqltype="cf_sql_integer" /> 			                  
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasBankAccount
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasBankAccount" access="public" returntype="numeric">       
	    <cfargument name="bank_account_id" type="numeric" required="true" />
        
        <cfset var ls = {}>       
        
       <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT
              COUNT(*) CNT
            FROM
	            TBL_BANK_ACCOUNT_ALT
            WHERE 
    	        ID = <cfqueryparam value="#bank_account_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>     
        
        <cfreturn ls.qry.cnt>    
    </cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateBankAccount
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="updateBankAccount" access="public" returntype="string">  
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="bank_account_id" type="numeric" required="true" />              
		<cfargument name="rc" type="struct" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
            	TBL_BANK_ACCOUNT_ALT
            SET  
				BANK_NAME = <cfqueryparam value="#rc.bank_name#" cfsqltype="cf_sql_varchar" />,
            	BANK_ACCOUNT_HOLDER = <cfqueryparam value="#rc.bank_account_holder#" cfsqltype="cf_sql_varchar" />,
            	BANK_ADDRESS = <cfqueryparam value="#rc.bank_address#" cfsqltype="cf_sql_varchar" />, 
                BANK_IBAN = <cfqueryparam value="#rc.bank_iban#" cfsqltype="cf_sql_varchar" />,  
                BANK_BIC = <cfqueryparam value="#rc.bank_iban#" cfsqltype="cf_sql_varchar" />,  
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                ID = <cfqueryparam value="#bank_account_id#" cfsqltype="cf_sql_integer" />           
        </cfquery>      

		<cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function copyBankAccount
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="copyBankAccount" access="public" returntype="string">   	          
        <cfargument name="bank_account_id" type="numeric" required="true" />		
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">
        	INSERT INTO 
            	TBL_BANK_ACCOUNT_ALT
            SELECT
	            *
            FROM
    	        TBL_BANK_ACCOUNT
            WHERE
        	    ID = <cfqueryparam value="#bank_account_id#" cfsqltype="cf_sql_integer" />
        </cfquery>

		<cfreturn ls.retval>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function deleteBankAccount
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="deleteBankAccount" access="public" returntype="string"> 
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">        
        
        <cfquery datasource="#Application.settings.dsn#">
        	DELETE FROM
            	TBL_BANK_ACCOUNT_ALT
            WHERE
        	    ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
        </cfquery>    
        
        <cfreturn ls.retval>        
	</cffunction>         
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNewBankAccountId
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    

	<cffunction name="getNewBankAccountId" access="public" returntype="numeric"> 
    
		<cfset var ls = {}>     
         
            <cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
                SELECT
                    TBL_BANK_ACCOUNT_SEQ.NEXTVAL AS ID
                FROM
                    DUAL                
            </cfquery> 
        
        <cfset ls.newId = ls.qry.id>    
        
        <cfreturn ls.newId> 
	</cffunction>                  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function createBankAccount
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="createBankAccount" access="public" returntype="struct">   
        <cfargument name="username" type="string" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />
        <cfargument name="id" type="numeric" required="true" />
        
        <cfset var ls = {}>	  
        <cfset ls.retval = {result:"OK"}>
            
        <cfquery datasource="#Application.settings.dsn#">                 
            INSERT INTO TBL_BANK_ACCOUNT_ALT
            (
                ID,
                EXTERNID,
                CRTBY,
                CRTON
            )
            VALUES
            (		
                <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,
                <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                SYSDATE
            )          
        </cfquery> 

		<cfreturn ls.retval>         
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function isBankAccountRemoved
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="isBankAccountRemoved" access="public" returntype="boolean"> 
		<cfargument name="id" type="numeric" required="true" />        
        
        <cfset var ls = {}> 
        <cfset ls.retval = true>      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_BANK_ACCOUNT_ALT
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
	Function removeBankAccount
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="removeBankAccount" access="public" returntype="string">  
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_BANK_ACCOUNT_ALT
            SET  
                DELETED = 'Y',
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
            WHERE 
                ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />           
        </cfquery>      

		<cfreturn ls.retval>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function restoreBankAccount
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="restoreBankAccount" access="public" returntype="string">  
	    <cfargument name="username" type="string" required="true" />  
        <cfargument name="id" type="numeric" required="true" />  
        
        <cfset var ls = {}>
        <cfset ls.retval = "OK">
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_BANK_ACCOUNT_ALT
            SET  
                DELETED = NULL,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                MODON = SYSDATE
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
   	            ID STAFF_MEMBER_ID,
                LAST_UPDATED_ON,
                LAST_UPDATED_BY
            FROM
            (
                SELECT
                    ID,
                    NVL(MODON,CRTON) LAST_UPDATED_ON,
                    NVL(MODBY,CRTBY) LAST_UPDATED_BY
                FROM
                	TBL_EXTERNS_ALT
                WHERE 
                	ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                UNION                    
                SELECT <!---hard join with main, because if no main, we do not consider there is a "change"--->
	                PPA.ID,
    	            NVL(PPA.MODON,PPA.CRTON) LAST_UPDATED_ON,
        	        NVL(PPA.MODBY,PPA.CRTBY) LAST_UPDATED_BY
                FROM
            	    TBL_PERSONALPROFILES_ALT PPA,
                	TBL_PERSONALPROFILES PP
                WHERE 
	                PPA.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
    	            AND PPA.EXTERNID = PP.EXTERNID
                    AND 
                    (
                    	PP.MARIAGESTATUS != PPA.MARIAGESTATUS 
	                    OR
    	                NVL(PP.VALIDITYDATE,SYSDATE) != NVL(PPA.VALIDITYDATE, SYSDATE)
        	            OR
            	        NVL(PP.SINCEDATE,SYSDATE) != NVL(PPA.SINCEDATE, SYSDATE)
                	    OR
                    	NVL(PP.COUNTRYID,0) != NVL(PPA.COUNTRYID,0)
                    ) 
                UNION
                SELECT
                    ID,
                    NVL(MODON,CRTON) LAST_UPDATED_ON,
                    NVL(MODBY,CRTBY) LAST_UPDATED_BY
                FROM
                	TBL_MEDIC_CERTIFICATE_ALT
                WHERE 
                	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                UNION
                SELECT
                    ID,
                    NVL(MODON,CRTON) LAST_UPDATED_ON,
                    NVL(MODBY,CRTBY) LAST_UPDATED_BY
                FROM
                	TBL_ADM_DOC_ALT
                WHERE 
                	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                UNION
                SELECT
                    ID,
                    NVL(MODON,CRTON) LAST_UPDATED_ON,
                    NVL(MODBY,CRTBY) LAST_UPDATED_BY
                FROM
                	TBL_RESIDENCES_ALT
                WHERE 
                	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
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