<cfcomponent accessors="Yes">	

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNSMListDataQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getNSMListDataQry" access="public" returntype="query">
		<cfargument name="office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
			SELECT
            	STAFF_MEMBER_ID,
            	CONTRACT_ID,
                LAST_NAME,
                FIRST_NAME,
                '' JOB 
			FROM
            	V_FSM_CURRENT_LOCAL_STAFF
			WHERE
            	OFFICE_ID = <cfqueryparam value="#Arguments.office_id#" cfsqltype="cf_sql_integer" />                               
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNSMPersonalDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="getNSMPersonalDetailsQry" access="public" returntype="query">
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
                EX.SS_NBR,
                TO_CHAR(EX.BIRTHDATE,'DD/MM/YYYY') DATE_OF_BIRTH,
                TO_CHAR(EX.DEATH_DATE,'DD/MM/YYYY') DATE_OF_DEATH,                
                EX.BIRTHCOUNTRYID BIRTH_COUNTRY_CODE,                
                INITCAP(CTRY.COUNTRYNAME) BIRTH_COUNTRY,
                EX.NATIONALITYCOUNTRYID CITIZENSHIP_1_COUNTRY_CODE,
                INITCAP(CTRY1.COUNTRYNAME) CITIZENSHIP_1_COUNTRY,
                EX.NATIONALITYCOUNTRYID_2 CITIZENSHIP_2_COUNTRY_CODE,
                INITCAP(CTRY2.COUNTRYNAME) CITIZENSHIP_2_COUNTRY,
                EX.NATIONALITYCOUNTRYID_3 CITIZENSHIP_3_COUNTRY_CODE,
                INITCAP(CTRY3.COUNTRYNAME) CITIZENSHIP_3_COUNTRY,                
                EX.LANG_1 LANGUAGE_1_ID,
                LANG1.LABEL LANGUAGE_1,
                EX.LANG_2 LANGUAGE_2_ID,
                LANG2.LABEL LANGUAGE_2,
                EX.LANG_3 LANGUAGE_3_ID,
                LANG3.LABEL LANGUAGE_3,
                '' MEDICVISIT_ORG,
                '' MEDICVISIT_REM,
                '' MEDICVISIT_FROM,
                '' MEDICVISIT_TO,
                '' MEDICVISIT
            FROM
                TBL_EXTERNS EX,
                TBL_COUNTRIESINFO CTRY,
                TBL_COUNTRIESINFO CTRY1,
                TBL_COUNTRIESINFO CTRY2,
                TBL_COUNTRIESINFO CTRY3,
                TBL_LANGUAGES LANG1,
                TBL_LANGUAGES LANG2,
                TBL_LANGUAGES LANG3
            WHERE
                EX.BIRTHCOUNTRYID = CTRY.COUNTRYID(+)
                AND EX.NATIONALITYCOUNTRYID = CTRY1.COUNTRYID(+)
                AND EX.NATIONALITYCOUNTRYID_2 = CTRY2.COUNTRYID(+)
                AND EX.NATIONALITYCOUNTRYID_3 = CTRY3.COUNTRYID(+)
                AND EX.LANG_1 = LANG1.ISO_CODE(+)
                AND EX.LANG_2 = LANG2.ISO_CODE(+)
                AND EX.LANG_3 = LANG3.ISO_CODE(+)
	            AND EX.ID = <cfqueryparam value="#Arguments.staff_member_id#" cfsqltype="cf_sql_integer" />                               
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNSMFamilyDataQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getNSMFamilyDataQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">                   
            SELECT  
                PP.EXTERNID,
                PM.ID,
                PM.TYPE,
                PM.FAMILYLINK,
                TO_CHAR(PM.BIRTHDATE, 'DD/MM/YYYY') BIRTH_DATE,      
                TO_CHAR(PM.DEATHDATE, 'DD/MM/YYYY') DEATH_DATE, 
                TO_CHAR(PM.SINCE, 'DD/MM/YYYY') SINCE_WHAT,  
                TO_CHAR(PM.EXPATSINCE, 'DD/MM/YYYY') EXPAT_SINCE, 
                TO_CHAR(PM.EFFECTDATE1, 'DD/MM/YYYY')	EFFECT_DATE_1, 
                TO_CHAR(PM.EFFECTDATE2, 'DD/MM/YYYY')	EFFECT_DATE_2, 
                TO_CHAR(PM.SINCE, 'DD/MM/YYYY')	DEPENDENT_SINCE,
                TRUNC(MONTHS_BETWEEN(SYSDATE, PM.BIRTHDATE)/12) AGE,
                (PM.SCHOOLADDRESSLINE1 || ' ' || PM.SCHOOLADDRESSLINE2 || ' ' || PM.SCHOOLPOSTALCODE || ' ' || PM.SCHOOLCITY || ' ' || PM.SCHOOLCOUNTRYID) SCHOOLADDRESS, 
                PM.CHILD_SUPPORT,   
                UPPER(PM.SURNAME) LNAME,
                INITCAP(PM.NAME) FNAME,       
                PM.*,
                NVL(PM.EXPATRIATED,'N') EXPATRIATED,
                NVL(PM.DEPENDENT,'N') DEPENDENT,
                NVL(PM.SAME_ORIGIN,'N') SAME_ORIGIN,
                NVL(PM.SAME_RESIDENCE,'N') SAME_RESIDENCE,
                NVL(PM.LIFE_3_MONTHS,'N') LIFE_3_MONTHS                
            FROM 
                TBL_PERSONALPROFILES PP,
                TBL_PROFILE_MEMBERS PM
            WHERE 
                1 = 1
                AND PM.TYPE = 'FAMI'
                AND PM.PERSONALPROFILEID = PP.ID
                AND PP.EXTERNID = <cfqueryparam value="#Arguments.staff_member_id#" cfsqltype="cf_sql_integer" />
                AND PM.VERS_NUM =
                (
                    SELECT 
                    	MAX(VERS_NUM)
                    FROM 
                    	TBL_PROFILE_MEMBERS
                    WHERE 
                    	ID = PM.ID
                    	AND VALIDATED < 2 
                )
                AND PM.VALIDATED < 2
                AND PM.IS_ACTIVE = 'Y'
            ORDER BY 
	            PM.BIRTHDATE DESC
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getNSMFamilyDetailsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="getNSMFamilyDetailsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
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
                TBL_PERSONALPROFILES P,
                APP_TABLES.ZONE_T ZT  
            WHERE 
                P.EXTERNID = <cfqueryparam value="#Arguments.staff_member_id#" cfsqltype="cf_sql_integer" />    
                AND P.COUNTRYID = ZT.CODE_ZONE(+)
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAddressesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->          
    
	<cffunction name="getAddressesQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">    
            SELECT 
                T1.LIB_EN_ZONE BUSINESS_CTRY_EN,
                T1.LIB_FR_ZONE BUSINESS_CTRY_FR,
                T2.LIB_EN_ZONE PRIVATE_CTRY_EN,
                T2.LIB_FR_ZONE PRIVATE_CTRY_FR,
                R.*              
            FROM 
                TBL_RESIDENCES R,
                APP_TABLES.ZONE_T T1,
                APP_TABLES.ZONE_T T2
            WHERE 
                R.ID = (SELECT MAX(ID) FROM TBL_RESIDENCES R2 WHERE R2.EXTERNID = R.EXTERNID)
                AND R.COUNTRYID = t1.code_zone(+)
                AND R.PRIVATE_COUNTRYID = t2.code_zone(+)
                AND R.EXTERNID = <cfqueryparam value="#Arguments.staff_member_id#" cfsqltype="cf_sql_integer" />   
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDocumentsQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->    
    
	<cffunction name="getDocumentsQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" /> 
        
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
                D.*
            FROM 
                TBL_ADM_DOC D,
                APP_TABLES.ZONE_T T1,
                APP_TABLES.ZONE_T T2,
                APP_TABLES.ZONE_T T3,
                APP_TABLES.ZONE_T T4,
                APP_TABLES.ZONE_T T5,
                APP_TABLES.ZONE_T T6,
                APP_TABLES.ZONE_T T7,
                APP_TABLES.ZONE_T T8
            WHERE 
                D.EXTERNID = <cfqueryparam value="#Arguments.staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND D.DL_CTRY = T1.CODE_ZONE(+)
                AND D.PASS_CTRY = T2.CODE_ZONE(+)
                AND D.PASS2_CTRY = T3.CODE_ZONE(+)
                AND D.WL_CTRY = T4.CODE_ZONE(+)
                AND D.RP_CTRY = T5.CODE_ZONE(+)
                AND D.EBDG_CTRY = T6.CODE_ZONE(+)
                AND D.DBDG_CTRY = T7.CODE_ZONE(+)
                AND D.LAISS_CTRY = T8.CODE_ZONE(+) 
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function saveStaffMemberBasics
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="saveStaffMemberBasics" access="public" returntype="struct">
		<cfargument name="rc" type="struct" required="true" /> 
        <cfargument name="authenticatedUser" type="string" required="true" />
        
        <cfset var ls = {}>
        <cfset ls.retval = {}>
        <cfset ls.retval.result = "OK">
        
        <cftransaction>
        
        <!---add marital status--->
        <cfquery name="ls.ex_qry" datasource="#Application.settings.dsn#">                 
            UPDATE
            	TBL_EXTERNS EX
            SET                                 
                EX.MAIDEN_NAME = <cfqueryparam value="#rc.maiden_name#" cfsqltype="cf_sql_varchar" /> ,
                EX.GENDER = <cfqueryparam value="#rc.gender#" cfsqltype="cf_sql_varchar" />, 
                EX.SS_NBR = <cfqueryparam value="#rc.social_security_number#" cfsqltype="cf_sql_varchar" />,
                EX.BIRTHDATE = TO_DATE(<cfqueryparam value="#rc.date_of_birth#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                EX.DEATH_DATE = TO_DATE(<cfqueryparam value="#rc.date_of_death#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),            
                EX.BIRTHCOUNTRYID = <cfqueryparam value="#rc.birth_country_code#" cfsqltype="cf_sql_varchar" />,  
                EX.NATIONALITYCOUNTRYID = <cfqueryparam value="#rc.citizenship_1_country_code#" cfsqltype="cf_sql_varchar" />,
                EX.NATIONALITYCOUNTRYID_2 = <cfqueryparam value="#rc.citizenship_2_country_code#" cfsqltype="cf_sql_varchar" />,
                EX.NATIONALITYCOUNTRYID_3 = <cfqueryparam value="#rc.citizenship_3_country_code#" cfsqltype="cf_sql_varchar" />,                             
                EX.LANG_1 = <cfqueryparam value="#rc.language_1_id#" cfsqltype="cf_sql_varchar" />,
                EX.LANG_2 = <cfqueryparam value="#rc.language_2_id#" cfsqltype="cf_sql_varchar" />,
                EX.LANG_3 = <cfqueryparam value="#rc.language_3_id#" cfsqltype="cf_sql_varchar" />            
                <!---EX.MEDICVISIT_ORG = <cfqueryparam value="#rc.medical_exam_institution#" cfsqltype="cf_sql_varchar" />,
                EX.MEDICVISIT_REM = <cfqueryparam value="#rc.medical_remarks#" cfsqltype="cf_sql_varchar" />,
                EX.MEDICVISIT_FROM = TO_DATE(<cfqueryparam value="#rc.medical_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                EX.MEDICVISIT_TO = TO_DATE(<cfqueryparam value="#rc.medical_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                EX.MEDICVISIT = <cfqueryparam value="#rc.medical_exam_result#" cfsqltype="cf_sql_numeric"  />--->
            WHERE 
                EX.ID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />           
		</cfquery>
        
         <cfquery name="ls.perCntQry" datasource="#Application.settings.dsn#">
         	SELECT
            	1
			FROM     
	            TBL_PERSONALPROFILES       
			WHERE     
	            EXTERNID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery>     
        
        <cfif ls.perCntQry.recordCount EQ 0>
        
            <cfquery datasource="#Application.settings.dsn#">                 
                INSERT INTO TBL_PERSONALPROFILES
                (
                    EXTERNID
                )
                VALUES
                (		
                    <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />  
               	)          
            </cfquery>  
        
        </cfif>
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_PERSONALPROFILES PP
            SET                                 
                PP.MARIAGESTATUS = <cfqueryparam value="#rc.mariagestatus#" cfsqltype="cf_sql_integer" null="#rc.mariagestatus EQ 0#"/>,
                PP.COUNTRYID = <cfqueryparam value="#rc.ms_country_code#" cfsqltype="cf_sql_varchar" />, 
                PP.SINCEDATE = TO_DATE(<cfqueryparam value="#rc.ms_effective_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY')
            WHERE 
                PP.EXTERNID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />           
        </cfquery>         
        
         <cfquery name="ls.resCntQry" datasource="#Application.settings.dsn#">
         	SELECT
            	1
			FROM     
	            TBL_RESIDENCES       
			WHERE     
	            EXTERNID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery>   
        
     	<cfif ls.resCntQry.recordCount EQ 0>
        
            <cfquery datasource="#Application.settings.dsn#">                 
                INSERT INTO TBL_RESIDENCES
                (
                    EXTERNID                    
                )
                VALUES
                (		
                    <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />                                     
               	)          
            </cfquery>  
        
         </cfif> 
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_RESIDENCES RE
            SET                                 
                RE.ADDRESSLINE1 = <cfqueryparam value="#rc.business_address_street#" cfsqltype="cf_sql_varchar" />,
                RE.CITY = <cfqueryparam value="#rc.business_address_city#" cfsqltype="cf_sql_varchar" />,
                RE.POSTALCODE = <cfqueryparam value="#rc.business_address_postal_code#" cfsqltype="cf_sql_varchar" />,
                RE.COUNTRYID = <cfqueryparam value="#rc.business_address_country_code#" cfsqltype="cf_sql_varchar" />,
                RE.VALIDITYDATE = TO_DATE(<cfqueryparam value="#rc.business_address_effective_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                RE.PRIVATE_ADDRESS = <cfqueryparam value="#rc.private_address_street#" cfsqltype="cf_sql_varchar" />,
                RE.PRIVATE_CITY = <cfqueryparam value="#rc.private_address_city#" cfsqltype="cf_sql_varchar" />,
                RE.PRIVATE_POSTALCODE = <cfqueryparam value="#rc.private_address_postal_code#" cfsqltype="cf_sql_varchar" />,
                RE.PRIVATE_COUNTRYID = <cfqueryparam value="#rc.private_address_country_code#" cfsqltype="cf_sql_varchar" />,
                RE.PHONENUMBER = <cfqueryparam value="#rc.private_address_phone_nbr#" cfsqltype="cf_sql_varchar" />,
                RE.MOBILNUMBER = <cfqueryparam value="#rc.private_mobile_nbr_1#" cfsqltype="cf_sql_varchar" />,
                RE.MOBILNUMBER2 = <cfqueryparam value="#rc.private_mobile_nbr_2#" cfsqltype="cf_sql_varchar" />,
                RE.EMAIL = <cfqueryparam value="#rc.private_email#" cfsqltype="cf_sql_varchar" /> 
            WHERE 
                RE.EXTERNID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />           
        </cfquery>            
        
         <cfquery name="ls.docCntQry" datasource="#Application.settings.dsn#">
         	SELECT
            	1
			FROM     
	            TBL_ADM_DOC       
			WHERE     
	            EXTERNID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery>                       
        
        <cfif ls.docCntQry.recordCount EQ 0>
        
    		<cfquery datasource="#Application.settings.dsn#">                 
                INSERT INTO TBL_ADM_DOC
                (
                    EXTERNID                    
                )
                VALUES
                (		
                    <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />                                     
               	)          
            </cfquery>          
        
        </cfif>
        
        <cfquery datasource="#Application.settings.dsn#">                 
            UPDATE
                TBL_ADM_DOC DOC
            SET        
                DOC.DL_CTRY = <cfqueryparam value="#rc.doc_dl_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.DL_DOC_NBR = <cfqueryparam value="#rc.doc_dl_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.DL_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dl_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.DL_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dl_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.DL_DELIV_BY = <cfqueryparam value="#rc.doc_dl_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.DL_DELIV_AT = <cfqueryparam value="#rc.doc_dl_issued_at#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS_CTRY = <cfqueryparam value="#rc.doc_pass_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS_DOC_NBR = <cfqueryparam value="#rc.doc_pass_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.PASS_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.PASS_DELIV_BY = <cfqueryparam value="#rc.doc_pass_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS_DELIV_AT = <cfqueryparam value="#rc.doc_pass_issued_at#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS2_CTRY = <cfqueryparam value="#rc.doc_pass2_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS2_DOC_NBR = <cfqueryparam value="#rc.doc_pass2_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS2_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass2_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.PASS2_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_pass2_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.PASS2_DELIV_BY = <cfqueryparam value="#rc.doc_pass2_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.PASS2_DELIV_AT = <cfqueryparam value="#rc.doc_pass2_issued_at#" cfsqltype="cf_sql_varchar" />,    
                DOC.WL_CTRY = <cfqueryparam value="#rc.doc_wl_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.WL_DOC_NBR = <cfqueryparam value="#rc.doc_wl_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.WL_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_wl_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.WL_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_wl_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.WL_DELIV_BY = <cfqueryparam value="#rc.doc_wl_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.WL_DELIV_AT = <cfqueryparam value="#rc.doc_wl_issued_at#" cfsqltype="cf_sql_varchar" />,
                DOC.RP_CTRY = <cfqueryparam value="#rc.doc_rp_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.RP_DOC_NBR = <cfqueryparam value="#rc.doc_rp_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.RP_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_rp_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.RP_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_rp_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.RP_DELIV_BY = <cfqueryparam value="#rc.doc_rp_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.RP_DELIV_AT = <cfqueryparam value="#rc.doc_rp_issued_at#" cfsqltype="cf_sql_varchar" />,
                DOC.EBDG_CTRY = <cfqueryparam value="#rc.doc_ebdg_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.EBDG_DOC_NBR = <cfqueryparam value="#rc.doc_ebdg_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.EBDG_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_ebdg_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.EBDG_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_ebdg_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.EBDG_DELIV_BY = <cfqueryparam value="#rc.doc_ebdg_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.EBDG_DELIV_AT = <cfqueryparam value="#rc.doc_ebdg_issued_at#" cfsqltype="cf_sql_varchar" />,  
                DOC.DBDG_CTRY = <cfqueryparam value="#rc.doc_dbdg_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.DBDG_DOC_NBR = <cfqueryparam value="#rc.doc_dbdg_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.DBDG_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dbdg_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.DBDG_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_dbdg_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.DBDG_DELIV_BY = <cfqueryparam value="#rc.doc_dbdg_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.DBDG_DELIV_AT = <cfqueryparam value="#rc.doc_dbdg_issued_at#" cfsqltype="cf_sql_varchar" />,   
                DOC.LAISS_CTRY = <cfqueryparam value="#rc.doc_lap_country_code#" cfsqltype="cf_sql_varchar" />,
                DOC.LAISS_DOC_NBR = <cfqueryparam value="#rc.doc_lap_doc_nbr#" cfsqltype="cf_sql_varchar" />,
                DOC.LAISS_START_DATE = TO_DATE(<cfqueryparam value="#rc.doc_lap_valid_from#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.LAISS_END_DATE = TO_DATE(<cfqueryparam value="#rc.doc_lap_valid_until#" cfsqltype="cf_sql_varchar" />,'DD/MM/YYYY'),
                DOC.LAISS_DELIV_BY = <cfqueryparam value="#rc.doc_lap_issued_by#" cfsqltype="cf_sql_varchar" />,
                DOC.LAISS_DELIV_AT = <cfqueryparam value="#rc.doc_lap_issued_at#" cfsqltype="cf_sql_varchar" />
			WHERE     
	            EXTERNID = <cfqueryparam value="#rc.staff_member_id#" cfsqltype="cf_sql_integer" />             
		</cfquery>                
        
        </cftransaction>  
        
        <cfreturn ls.retval>
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function saveDependent
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="saveDependent" access="public" returntype="struct">
		<cfargument name="rc" type="struct" required="true" />  
        <cfargument name="authenticatedUser" type="string" required="true" />  
        <cfargument name="staff_member_id" type="numeric" required="true" />        
        
        <cfset var ls = {}>        
        <cfset ls.retval = {result:"SAVED"}>
        
        <!--- rc.id is the id of the dependent person--->
        <cfset ls.member_profile_id = rc.id>   
        
        <cftransaction>  
        
        	<!---personal profile--->
        
            <cfquery name="ls.getPersonalProfilesIdQry" datasource="#Application.settings.dsn#">
                SELECT
                    ID 
                FROM     
                    TBL_PERSONALPROFILES       
                WHERE     
                    EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
            </cfquery>   
            
            <cfif ls.getPersonalProfilesIdQry.recordCount EQ 0>			    
            
            	<!---create personal profile record if missing--->
                <cfquery datasource="#Application.settings.dsn#">                 
                    INSERT INTO TBL_PERSONALPROFILES
                    (     
                        EXTERNID,                        
                        CRTBY,
                        CRTON
                    )
                    VALUES
                    (		  
                        <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />,                                    
                        <cfqueryparam value='#authenticatedUser#' cfsqltype='cf_sql_varchar'>,
                        SYSDATE
                    )          
                </cfquery>   
                
                <cfquery name="ls.getPersonalProfilesIdQry" datasource="#Application.settings.dsn#">
                    SELECT
                        ID 
                    FROM     
                        TBL_PERSONALPROFILES       
                    WHERE     
                        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
                </cfquery>             
                       
            </cfif>
            
            <cfset ls.personalProfileId = ls.getPersonalProfilesIdQry.id>  
            
            <!---profile_member--->                     
        
            <cfquery name="ls.dependentIdQry" datasource="#Application.settings.dsn#">
                SELECT
                    ID
                FROM     
                    TBL_PROFILE_MEMBERS       
                WHERE     
                    ID = <cfqueryparam value="#ls.member_profile_id#" cfsqltype="cf_sql_integer" />            
            </cfquery> 
            
           <cfif ls.dependentIdQry.recordCount EQ 0>             		
                
                <!---create profile member record if missing--->
                <cfquery name="ls.getNewProfileMemberIdQry" datasource="#Application.settings.dsn#">                    
                    SELECT 
                        TBL_PROFILE_MEMBERS_SEQ.NEXTVAL ID
                    FROM 
                        DUAL                                
                </cfquery>  
                
                <cfquery datasource="#Application.settings.dsn#">                 
                    INSERT INTO TBL_PROFILE_MEMBERS
                    (     
                        ID,              
                        PERSONALPROFILEID,
                        FAMILYLINK,
                        VALIDATED,
                        TYPE,
                        VERS_NUM,                        
                        CRTBY,
                        CRTON
                    )
                    VALUES
                    (		  
                        <cfqueryparam value="#ls.getNewProfileMemberIdQry.id#" cfsqltype="cf_sql_integer" />,                 
                        <cfqueryparam value="#ls.getPersonalProfilesIdQry.id#" cfsqltype="cf_sql_integer" />,
                        <cfqueryparam value='#rc.FAMILYLINK#' cfsqltype='cf_sql_varchar'>,
                        1, <!---what does it mean?--->
                        'FAMI',
                        0,                                       
                        <cfqueryparam value='#authenticatedUser#' cfsqltype='cf_sql_varchar'>,
                        SYSDATE
                    )          
                </cfquery>    				                   
                
                <cfset ls.member_profile_id = ls.getNewProfileMemberIdQry.id>
                
                <cfset ls.retval = {result:"ADDED"}>
                
			</cfif>     
            
            <cfquery datasource="#Application.settings.dsn#">   
                UPDATE  
                    TBL_PROFILE_MEMBERS  
                SET  
                    VERS_NUM = VERS_NUM + 1,                
                    SURNAME = UPPER(<cfqueryparam value='#rc.SURNAME#' cfsqltype='cf_sql_varchar'>),   
                    NAME = INITCAP(<cfqueryparam value='#rc.NAME#' cfsqltype='cf_sql_varchar'>),                   
                    GENDER = <cfqueryparam value='#rc.GENDER#' cfsqltype='cf_sql_varchar'>,
                    PHONENUMBER = <cfqueryparam value='#rc.PHONENUMBER#' cfsqltype='cf_sql_varchar'>,
                    BIRTHDATE = TO_DATE(<cfqueryparam value='#rc.BIRTHDATE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),                
                    ADDRESSLINE1 = <cfqueryparam value='#rc.ADDRESSLINE1#' cfsqltype='cf_sql_varchar'>,
                    POSTALCODE = <cfqueryparam value='#rc.POSTALCODE#' cfsqltype='cf_sql_varchar'>,
                    CITY = <cfqueryparam value='#rc.CITY#' cfsqltype='cf_sql_varchar'>,
                    OCCUPATION = <cfqueryparam value='#rc.OCCUPATION#' cfsqltype='cf_sql_varchar'>,
                    SCHOOLNAME = <cfqueryparam value='#rc.SCHOOLNAME#' cfsqltype='cf_sql_varchar'>,                
                    SCHOOLADDRESSLINE1 = <cfqueryparam value='#rc.SCHOOLADDRESSLINE1#' cfsqltype='cf_sql_varchar'>,
                    SCHOOLPOSTALCODE = <cfqueryparam value='#rc.SCHOOLPOSTALCODE#' cfsqltype='cf_sql_varchar'>,
                    SCHOOLCITY = <cfqueryparam value='#rc.SCHOOLCITY#' cfsqltype='cf_sql_varchar'>,
                    SCHOOLCOUNTRYID = <cfqueryparam value='#rc.SCHOOLCOUNTRYID#' cfsqltype='cf_sql_varchar'>,                
                    DEPENDENT = <cfqueryparam value='#rc.DEPENDENT#' cfsqltype='cf_sql_varchar'>,
                    EXPATRIATED = <cfqueryparam value='#rc.EXPATRIATED#' cfsqltype='cf_sql_varchar'>,
                    YEARINCOME = <cfqueryparam value='#rc.YEARINCOME#' cfsqltype='cf_sql_varchar'>,
                    MOBILENUMBER = <cfqueryparam value='#rc.MOBILENUMBER#' cfsqltype='cf_sql_varchar'>,                
                    OTHERNUMBER = <cfqueryparam value='#rc.OTHERNUMBER#' cfsqltype='cf_sql_varchar'>,               
                    BIRTH_COUNTRYID = <cfqueryparam value='#rc.BIRTH_COUNTRYID#' cfsqltype='cf_sql_varchar'>,
                    BIRTH_CITY = <cfqueryparam value='#rc.BIRTH_CITY#' cfsqltype='cf_sql_varchar'>,                             
                    INCOMECURRENCY = <cfqueryparam value='#rc.INCOMECURRENCY#' cfsqltype='cf_sql_varchar'>, 
                    EXPATSINCE = TO_DATE(<cfqueryparam value='#rc.EXPATSINCE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),                
                    DEATHDATE = TO_DATE(<cfqueryparam value='#rc.DEATHDATE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),
                    <!---CHILD_SUPPORT = <cfqueryparam value='#rc.CHILD_SUPPORT#' cfsqltype='cf_sql_number'>,--->
                    LIFE_3_MONTHS = <cfqueryparam value='#rc.LIFE_3_MONTHS#' cfsqltype='cf_sql_varchar'>,                
                    EMAIL = <cfqueryparam value='#rc.EMAIL#' cfsqltype='cf_sql_varchar'>,   
                    PRIVATE_ADDRESSLINE1 = <cfqueryparam value='#rc.PRIVATE_ADDRESSLINE1#' cfsqltype='cf_sql_varchar'>,
                    PRIVATE_CITY = <cfqueryparam value='#rc.PRIVATE_CITY#' cfsqltype='cf_sql_varchar'>,
                    PRIVATE_POSTALCODE = <cfqueryparam value='#rc.PRIVATE_POSTALCODE#' cfsqltype='cf_sql_varchar'>,
                    PRIVATE_COUNTRY = <cfqueryparam value='#rc.PRIVATE_COUNTRY#' cfsqltype='cf_sql_varchar'>,
                    EFFECTDATE1 = TO_DATE(<cfqueryparam value='#rc.EFFECTDATE1#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),
                    EFFECTDATE2 = TO_DATE(<cfqueryparam value='#rc.EFFECTDATE2#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),
                    PROF_ORGANISATION = <cfqueryparam value='#rc.PROF_ORGANISATION#' cfsqltype='cf_sql_varchar'>,
                    SINCE = TO_DATE(<cfqueryparam value='#rc.SINCE#' cfsqltype='cf_sql_varchar'>, 'DD/MM/YYYY'),
                    NATIONALITYCOUNTRYID = <cfqueryparam value='#rc.NATIONALITYCOUNTRYID#' cfsqltype='cf_sql_varchar'>,
                    NATIONALITYCOUNTRYID_2 = <cfqueryparam value='#rc.NATIONALITYCOUNTRYID_2#' cfsqltype='cf_sql_varchar'>,
                    SAME_RESIDENCE = <cfqueryparam value='#rc.SAME_RESIDENCE#' cfsqltype='cf_sql_varchar'>,
                    SAME_ORIGIN = <cfqueryparam value='#rc.SAME_ORIGIN#' cfsqltype='cf_sql_varchar'>,
                    EXT_ALLOW_NATURE = <cfqueryparam value='#rc.EXT_ALLOW_NATURE#' cfsqltype='cf_sql_varchar'>,
                    EXT_ALLOW_AMOUNT = <cfqueryparam value='#rc.EXT_ALLOW_AMOUNT#' cfsqltype='cf_sql_number'>,
                    EXT_ALLOW_COMMENTS = <cfqueryparam value='#rc.EXT_ALLOW_COMMENTS#' cfsqltype='cf_sql_varchar'>,
                    SCHOOLARSHIP_NATURE = <cfqueryparam value='#rc.SCHOOLARSHIP_NATURE#' cfsqltype='cf_sql_varchar'>,
                    SCHOOLARSHIP_AMOUNT = <cfqueryparam value='#rc.SCHOOLARSHIP_AMOUNT#' cfsqltype='cf_sql_number'>,
                    SCHOOLARSHIP_COMMENTS = <cfqueryparam value='#rc.SCHOOLARSHIP_COMMENTS#' cfsqltype='cf_sql_varchar'>,                    
                    UPDON = SYSDATE,
                    UPDBY = <cfqueryparam value='#authenticatedUser#' cfsqltype='cf_sql_varchar'>
                WHERE
                    ID = <cfqueryparam value="#ls.member_profile_id#" cfsqltype="cf_sql_integer" />            	                
            </cfquery>  
            
		</cftransaction>                   
        
        <cfreturn ls.retval>       
        
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function RemoveRelative
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="RemoveRelative" access="public" returntype="struct">
	    <cfargument name="authenticatedUser" type="string" required="true" />  
        <cfargument name="profile_member_id" type="numeric" required="true" />
        
	    <cfset var ls = {}>
        <cfset ls.retval = {}>
        <cfset ls.retval.result = "OK">        

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	UPDATE
            	TBL_PROFILE_MEMBERS
			SET
            	IS_ACTIVE = 'N',
                UPDON = SYSDATE,
                UPDBY = <cfqueryparam value='#authenticatedUser#' cfsqltype='cf_sql_varchar'>    
			WHERE
            	ID = <cfqueryparam value="#profile_member_id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.retval>   
        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getPersonalProfile
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="getPersonalProfile" access="public" returntype="query">
        <cfargument name="staff_member_id" type="numeric" required="true" />

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	<!---PP.*--->
        	    PP.ID,
            	PP.EXTERNID
            FROM
	            TBL_PERSONALPROFILES PP
            WHERE
    	        PP.EXTERNID = <cfqueryparam value="#Arguments.staff_member_id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDependentQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->         
    
	<cffunction name="getDependentQry" access="public" returntype="query">
        <cfargument name="profile_member_id" type="numeric" required="true" />

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	TO_CHAR(PM.EXPATSINCE, 'DD/MM/YYYY') EXPATSINCE,
                TO_CHAR(PM.SINCE, 'DD/MM/YYYY') SINCE,
                TO_CHAR(PM.DEATHDATE, 'DD/MM/YYYY') DEATHDATE,
                TO_CHAR(PM.EFFECTDATE1, 'DD/MM/YYYY') EFFECTIVEDATE1,
                TO_CHAR(PM.EFFECTDATE2, 'DD/MM/YYYY') EFFECTIVEDATE2,
                TO_CHAR(PM.BIRTHDATE, 'DD/MM/YYYY') BIRTHDATE,
				PM.*        	  
            FROM
	            TBL_PROFILE_MEMBERS PM
            WHERE
    	        PM.ID = <cfqueryparam value="#Arguments.profile_member_id#" cfsqltype="cf_sql_integer" />  
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction>           
    
</cfcomponent>    