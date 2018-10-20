<cfcomponent accessors="Yes">	
    
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
            	1 = 1 
            	<!---VALIDATED IN (1,2)--->
            	AND PP.ID = 
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
                TBL_PERSONALPROFILES PP,
                TBL_PROFILE_MEMBERS PM
            WHERE 
                PM.TYPE = 'FAMI'
                AND PM.PERSONALPROFILEID = PP.ID
                AND PP.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
                AND PM.VERS_NUM =
                (
                    SELECT 
                    	MAX(PM2.VERS_NUM)
                    FROM 
                    	TBL_PROFILE_MEMBERS PM2
                    WHERE 
                    	PM2.ID = PM.ID
                    	AND PM2.VALIDATED < 2 
                        AND PM2.PERSONALPROFILEID = 
                        (
                        	SELECT
                            	MAX(PP2.ID)
							FROM
                            	TBL_PERSONALPROFILES PP2
							WHERE
								PP2.EXTERNID = PP.EXTERNID                        
                        )
                )
                AND PM.VALIDATED < 2
                AND PM.IS_ACTIVE = 'Y'
                AND PM.DELETED IS NULL
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
	            TBL_PROFILE_MEMBERS     
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />     
                AND DELETED IS NULL       
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
		<cfargument name="relative_id" type="numeric" required="true" /> 
        
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
                TBL_PROFILE_MEMBERS PM
            WHERE 
                PM.ID = <cfqueryparam value="#relative_id#" cfsqltype="cf_sql_integer" />
		</cfquery>
        
        <cfreturn ls.qry>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAllowancesQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="getAllowancesQry" access="public" returntype="query">
		<cfargument name="staff_member_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	  
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	EX.ID STAFF_MEMBER_ID,
                EX.EXT_ALLOW_NATURE ALLOWANCES_NATURE,
                EX.EXT_ALLOW_COMMENTS ALLOWANCES_COMMENTS,                
                EX.EXT_ALLOW_AMOUNT ALLOWANCES_AMOUNT  
            FROM
                TBL_EXTERNS EX
            WHERE
	            EX.ID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />                               
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
	            TBL_EXTERNS 
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
        <cfreturn ls.retval>    
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
	            TBL_SCHOOL_ATTEND    
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />  
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
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
				TBL_SCHOOL_ATTEND SA
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
	            TBL_SCHOLARSHIP   
			WHERE     
	            ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />            
		</cfquery> 
        
        <cfif ls.qry.cnt EQ 0>
        	<cfset ls.retval = false>
        </cfif>      
        
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
           		TBL_SCHOLARSHIP SC
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
           		TBL_SCHOLARSHIP SC
            WHERE
            	SC.ID = <cfqueryparam value="#scholarship_id#" cfsqltype="cf_sql_integer" />
		</cfquery>       
        
        <cfreturn ls.qry>   
        
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewAltFd
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewAltFd" access="public" returntype="string">
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
	Function chkEditFd
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditFd" access="public" returntype="string">
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
	The first query gives the latest edit date on TBL_PROFILE_MEMBERS but not on TBL_PERSONALPROFILES
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
                        TBL_PROFILE_MEMBERS T1,
                        TBL_PERSONALPROFILES T2
                    WHERE 
                        T1.PERSONALPROFILEID = T2.ID
                        AND T2.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
						AND T2.ID = 
                        (
                            SELECT
                                MAX(ID)
                            FROM                        
                                TBL_PERSONALPROFILES
                            WHERE
                                EXTERNID = T2.EXTERNID                         
                        )                          
                        AND T1.VERS_NUM =
                        (
                            SELECT 
                                MAX(PM2.VERS_NUM)
                            FROM 
                                TBL_PROFILE_MEMBERS PM2
                            WHERE 
                                PM2.ID = T1.ID
                                AND PM2.VALIDATED < 2 
                                AND PM2.PERSONALPROFILEID = 
                                (
                                    SELECT
                                        MAX(PP2.ID)
                                    FROM
                                        TBL_PERSONALPROFILES PP2
                                    WHERE
                                        PP2.EXTERNID = T2.EXTERNID                        
                                )
                        )  
                        AND T1.IS_ACTIVE = 'Y'
                        AND T1.DELETED IS NULL                         
                    UNION
                    SELECT
                        T2.EXTERNID,
                        NVL(T1.MODON,T1.CRTON) LAST_UPDATED_ON,
                        NVL(T1.MODBY,T1.CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_SCHOOL_ATTEND T1,
                        TBL_PERSONALPROFILES T2
                    WHERE 
                        T1.PERSONALPROFILEID = T2.ID
                        AND T1.DELETED IS NULL
                        AND T2.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
						AND T2.ID = 
                        (
                            SELECT
                                MAX(ID)
                            FROM                        
                                TBL_PERSONALPROFILES
                            WHERE
                                EXTERNID = T2.EXTERNID                         
                        )                          
                    UNION
                    SELECT
                        T2.EXTERNID,
                        NVL(T1.MODON,T1.CRTON) LAST_UPDATED_ON,
                        NVL(T1.MODBY,T1.CRTBY) LAST_UPDATED_BY
                    FROM
                        TBL_SCHOLARSHIP T1,
                        TBL_PERSONALPROFILES T2
                    WHERE 
                        T1.PERSONALPROFILEID = T2.ID
                        AND T1.DELETED IS NULL
                        AND T2.EXTERNID = <cfqueryparam value="#staff_member_id#" cfsqltype="cf_sql_integer" />
                        AND T2.ID = 
                        (
                            SELECT
                                MAX(ID)
                            FROM                        
                                TBL_PERSONALPROFILES
                            WHERE
                                EXTERNID = T2.EXTERNID                         
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