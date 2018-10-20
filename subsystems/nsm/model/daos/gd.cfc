<cfcomponent accessors="Yes">

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
	            TBL_EXTERNS     
			WHERE     
	            ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
    </cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getPersonalDetailsQry
	There is a vers_num for tbl_externs, but there is only ever one record
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
                <!---INITCAP(CTRY3.COUNTRYNAME) CITIZENSHIP_3_COUNTRY, --->  
                EX.NATIONALITYCOUNTRYID_3 OTHER_CITIZENSHIPS,             
                EX.LANG_1 LANGUAGE_1_ID,
                LANG1.LABEL LANGUAGE_1,
                EX.LANG_2 LANGUAGE_2_ID,
                LANG2.LABEL LANGUAGE_2,
                EX.LANG_3 LANGUAGE_3,
                PERS_DATA_COMMENTS COMMENTS        
            FROM
                TBL_EXTERNS EX,
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
               <!--- AND EX.NATIONALITYCOUNTRYID_3 = CTRY3.COUNTRYID(+)--->
                AND EX.LANG_1 = LANG1.ISO_CODE(+)
                AND EX.LANG_2 = LANG2.ISO_CODE(+)                
	            AND EX.ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                               
		</cfquery>                     
        
		<cfreturn ls.qry>
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getFamilyDetailsQry
	TBL_PERSONALPROFILES has no vers_num, so select max(id)
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
                TBL_PERSONALPROFILES P,
                APP_TABLES.ZONE_T ZT  
            WHERE 
            	P.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND P.COUNTRYID = ZT.CODE_ZONE(+)
                AND P.ID = 
                (
                	SELECT
                    	MAX(P2.ID)
					FROM                        
		                TBL_PERSONALPROFILES P2
					WHERE
                    	P2.EXTERNID = P.EXTERNID   
                       <!--- AND P2.VALIDATED IN (1,2)  --->               
                )  
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
                'N' DELETED
            FROM
                TBL_PERSONALPROFILES PP,
                TBL_PROFILE_MEMBERS PM
            WHERE
                PP.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
                AND PP.ID = PM.PERSONALPROFILEID
                AND PM.DELETED IS NULL            
                AND PM.TYPE = 'FAMI'
                AND PM.IS_ACTIVE = 'Y'
				AND PP.ID = 
                (
                	SELECT
                    	MAX(PP2.ID)
					FROM                        
		                TBL_PERSONALPROFILES PP2
					WHERE
                    	PP2.EXTERNID = PP.EXTERNID   
                        <!---AND PP2.VALIDATED IN (1,2) --->                
                )                  
        </cfquery>
        
		<cfreturn ls.qry>        

	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAddressesQry
	There can be multiple records for the same EXTERNID, all with vers_num = 1
	Therefore, select max(id) to have the most recent version
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
                TBL_RESIDENCES R,
                APP_TABLES.ZONE_T T1,
                APP_TABLES.ZONE_T T2
            WHERE 
	            R.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND R.ID = 
                (
                	SELECT 
                    	MAX(R2.ID) 
                    FROM 
	                    TBL_RESIDENCES R2 
                    WHERE 
    	                R2.EXTERNID = R.EXTERNID
                        <!---AND R2.VALIDATED IN (1,2)--->
                )
                AND R.COUNTRYID = T1.CODE_ZONE(+)
                AND R.PRIVATE_COUNTRYID = T2.CODE_ZONE(+)                  
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getMedicalsQry
	Get all medicals
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
	            TBL_MEDIC_CERTIFICATE
            WHERE 
    	        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 
                AND DELETED IS NULL
			ORDER BY
            	VALIDITY_TO DESC
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getMedicalQry
	Get a single medical
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
	            TBL_MEDIC_CERTIFICATE
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
                TO_CHAR(D.JUREP_START_DATE,'DD/MM/YYYY') RP_START_DATE,
                TO_CHAR(D.JUREP_END_DATE,'DD/MM/YYYY') RP_END_DATE,                
                'MAIN' ENV,
                Hash_MD5_Blob(DL_UPLD_DATA) DL_UPLD_HASH,
                Hash_MD5_Blob(PASS_UPLD_DATA) PASS_UPLD_HASH,
                Hash_MD5_Blob(PASS2_UPLD_DATA) PASS2_UPLD_HASH,                
                Hash_MD5_Blob(WL_UPLD_DATA) WL_UPLD_HASH,      
                Hash_MD5_Blob(RP_UPLD_DATA) RP_UPLD_HASH,  
                Hash_MD5_Blob(EBDG_UPLD_DATA) EBDG_UPLD_HASH,
                Hash_MD5_Blob(DBDG_UPLD_DATA) DBDG_UPLD_HASH,
                Hash_MD5_Blob(LAISS_UPLD_DATA) LAISS_UPLD_HASH,  
                Hash_MD5_Blob(JUREP_UPLD_DATA) JUREP_UPLD_HASH,
                Hash_MD5_Blob(CV_UPLD_DATA) CV_UPLD_HASH, 
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
	            TBL_PERSONALPROFILES      
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
        	    *
            FROM
	            TBL_PERSONALPROFILES PP
            WHERE
            	ID = 
                (
                	SELECT
                    	MAX(ID)
					FROM                        
		                TBL_PERSONALPROFILES
					WHERE
                    	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                         
                )  
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function hasAddress (there can be multiple addresses, only the latest is valid)
	There is no DELETED field on this table
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->   

	<cffunction name="hasAddress" access="public" returntype="numeric">   
	    <cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>       
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
         	SELECT
            	COUNT(*) CNT
			FROM     
	            TBL_RESIDENCES     
			WHERE     
            	EXTERNID = <cfqueryparam value="#rstaff_member_id#" cfsqltype="cf_sql_integer" /> 
                <!---AND R.VALIDATED IN (1,2)--->
		</cfquery>       
        
        <cfreturn ls.qry.cnt>    
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
	            TBL_ADM_DOC       
			WHERE     
	            EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />            
		</cfquery>       
        
        <cfreturn ls.qry.cnt>    
    </cffunction>   

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getDocFileQry
	There is no DELETED or VERS_NUM field on this table
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getDocFileQry" access="public" returntype="query">
        <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />
        <cfargument name="staff_member_id" type="numeric" required="true" />  
        <cfargument name="field" type="string" required="true" />  
        
        <cfset var ls = {}>   
        
        <cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
                #field#_UPLD_DATA FILE_DATA,
                #field#_UPLD_NAME FILE_NAME,
                #field#_UPLD_MIME MIME_TYPE,               
                Hash_MD5_Blob(#field#_UPLD_DATA)) UPLD_HASH,
                MODBY,
                MODON                
			FROM
				TBL_ADM_DOC               
            WHERE 
            	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">                
		</cfquery>                      
        
        <cfreturn ls.qry>        
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
	            TBL_MEDIC_CERTIFICATE
            WHERE 
    	        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" /> 	   
                AND DELETED IS NULL              
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
	            TBL_MEDIC_CERTIFICATE
            WHERE 
    	        ID = <cfqueryparam value="#medical_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>     
        
        <cfreturn ls.qry.cnt>    
    </cffunction>      

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getMedFileQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="getMedFileQry" access="public" returntype="query">
        <cfargument name="user_id" type="numeric" required="true" />
        <cfargument name="office_id" type="numeric" required="true" />        
        <cfargument name="medical_id" type="numeric" required="true" />  
        
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
                AND DELETED IS NULL              
		</cfquery>                
        
        <cfreturn ls.qry>        
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
	            TBL_BANK_ACCOUNT
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
	            TBL_BANK_ACCOUNT
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
	            TBL_BANK_ACCOUNT 
            WHERE 
    	        ID = <cfqueryparam value="#bank_account_id#" cfsqltype="cf_sql_integer" /> 	                 
		</cfquery>     
        
        <cfreturn ls.qry.cnt>    
    </cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewAltGd
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewAltGd" access="public" returntype="string">
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
	Function chkEditGd
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditGd" access="public" returntype="string">
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
                        TBL_EXTERNS
                    WHERE 
                        ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                    UNION
                    SELECT
                        ID,
                        NVL(MODON,CRTON) LAST_UPDATED_ON,
                        NVL(MODBY,CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_PERSONALPROFILES  
                    WHERE 
                        ID = 
                        (
                        	SELECT
                            	MAX(ID)
							FROM     
	                            TBL_PERSONALPROFILES                           
							WHERE
                            	EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">                                
                        )
                    UNION
                    SELECT
                        ID,
                        NVL(MODON,CRTON) LAST_UPDATED_ON,
                        NVL(MODBY,CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_MEDIC_CERTIFICATE     
                    WHERE 
                        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                    UNION
                    SELECT
                        ID,
                        NVL(MODON,CRTON) LAST_UPDATED_ON,
                        NVL(MODBY,CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_ADM_DOC      
                    WHERE 
                        EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                    UNION
                    SELECT
                        R.ID,
                        NVL(R.MODON,R.CRTON) LAST_UPDATED_ON,
                        NVL(R.MODBY,R.CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_RESIDENCES R
                    WHERE
	                    EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer">
                    	AND R.ID = 
                        (
                            SELECT 
                                MAX(R2.ID) 
                            FROM 
                                TBL_RESIDENCES R2 
                            WHERE 
                                R2.EXTERNID = R.EXTERNID
                        ) 
                    ORDER BY 
                        LAST_UPDATED_ON DESC
                )
            WHERE
            	ROWNUM = 1
        </cfquery>
        
        <cfreturn ls.qry>        
	</cffunction>            
    
</cfcomponent>    