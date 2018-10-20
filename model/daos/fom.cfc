<cfcomponent accessors="Yes">	

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getRolesByUserQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getRolesByUserQry" access="public" returntype="query">
    	<cfargument name="user_id" type="numeric" required="true" />
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
            SELECT
	            RO.ROLE_CODE
            FROM
    	        FSM_ROLES_BY_USER RBU,
        	    FSM_ROLES RO
            WHERE
            	RBU.USER_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />
	            AND RBU.OFFICE_ID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" />
    	        AND RBU.USER_ID = RBU.USER_ID  
        	    AND RBU.ROLE_ID = RO.ID
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getLogStatusQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getLogStatusQry" access="public" returntype="query">    	
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">   
            SELECT
                LG.OFFICE_ID,
                ST.STATUS_CODE,
                LG.CREATED_BY,
                TO_CHAR(LG.CREATED_ON, 'DD/MM/YYYY HH24:MI:SS') CREATED_ON,
                US.LNAME || ' ' || US.FNAME INITIATOR
            FROM
                FSM_OFFICES_STATUS_LOG LG,
                FSM_STATUSES ST,
                FSM_USERS US
            WHERE
                LG.OFFICE_ID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" />
                AND LG.IS_CURRENT = 'Y'
                AND LG.STATUS_ID = ST.ID
                AND LG.CREATED_BY = US.ID
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>    

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getFieldOfficeQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getFieldOfficeQry" access="public" returntype="query">
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">                       
            SELECT  
                TO_CHAR(MODON, 'DD/MM/YYYY HH24:MI:SS') MODIFIED_ON,               
                US.LNAME EDITOR_LNAME,
                US.FNAME EDITOR_FNAME,
                US.USERNAME EDITOR_USERNAME,                           
                INITCAP(TOF.CITY) CITY1,  
                DECODE(TOF.EMAILTOUSE,1,'OEM',2,'AEM',3,'FEM','') EMTU, <!---email to use--->
                INITCAP(ZT.LIB_EN_ZONE) COUNTRYNAME,
                TR.NAME REGIONNAME,
                TOF.*
            FROM 
                TBL_REGIONS TR,
                TBL_OFFICES TOF,
                ZONE_T ZT,
				FSM_USERS US                
            WHERE 
                TOF.ID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" /> 
                AND ZT.FLAG_EV = 'Y'
                AND TOF.COUNTRYID = ZT.CODE_ZONE
                AND TOF.REGIONID  = TR.ID    
				AND US.USERNAME(+) = TOF.MODBY
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAltFieldOfficeQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=----> 

	<cffunction name="getAltFieldOfficeQry" access="public" returntype="query">
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">                   
            SELECT      
	            TO_CHAR(MODON, 'DD/MM/YYYY HH24:MI:SS') MODIFIED_ON,                
                US.LNAME EDITOR_LNAME,
                US.FNAME EDITOR_FNAME,
                US.USERNAME EDITOR_USERNAME, 
                INITCAP(TOF.CITY) CITY1,  
                DECODE(TOF.EMAILTOUSE,1,'OEM',2,'AEM',3,'FEM','') EMTU, 
                INITCAP(ZT.LIB_EN_ZONE) COUNTRYNAME,
                TR.NAME REGIONNAME,
				TOF.*
            FROM 
                TBL_REGIONS TR,
                TBL_OFFICES_ALT TOF,
                ZONE_T ZT,
                FSM_USERS US
            WHERE 
                TOF.ID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" />  
                AND ZT.FLAG_EV = 'Y'
                AND TOF.COUNTRYID = ZT.CODE_ZONE
                AND TOF.REGIONID  = TR.ID
                AND TOF.MODBY = US.USERNAME(+)                
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getFieldOfficeSummaryQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
    
	<cffunction name="getFieldOfficeSummaryQry" access="public" returntype="query">
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">                       
            SELECT     
            	TOF.ID,
	            TOF.CITY,        
                INITCAP(TOF.CITY) CITY1,
                TOF.MODBY MODIFIED_BY,
                TO_CHAR(MODON, 'DD/MM/YYYY HH24:MI:SS') MODIFIED_ON
            FROM                 
                TBL_OFFICES TOF
            WHERE 
                TOF.ID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" />                  
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>  
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAltFieldOfficeSummaryQry
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
    
	<cffunction name="getAltFieldOfficeSummaryQry" access="public" returntype="query">
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">                       
            SELECT     
            	TOF.ID,
	            TOF.CITY,        
                INITCAP(TOF.CITY) CITY1,
                TOF.MODBY MODIFIED_BY,
                TO_CHAR(MODON, 'DD/MM/YYYY HH24:MI:SS') MODIFIED_ON
            FROM                 
                TBL_OFFICES_ALT TOF
            WHERE 
                TOF.ID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" />                  
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getFieldOfficeHours
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
    
	<cffunction name="getFieldOfficeHours" access="public" returntype="query">
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">                       
            SELECT     
            	ID,                
                DAY,
                AM_OPENING_HOUR,
				AM_OPENING_MINUTE,
              	AM_CLOSING_HOUR,
				AM_CLOSING_MINUTE,
                PM_OPENING_HOUR,
				PM_OPENING_MINUTE,
              	PM_CLOSING_HOUR,
				PM_CLOSING_MINUTE
            FROM                 
                TBL_OFFICES_HOURS
            WHERE 
                OFFICEID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" />    
			ORDER BY
            	SORT                              
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction> 
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getAltFieldOfficeHours
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
    
	<cffunction name="getAltFieldOfficeHours" access="public" returntype="query">
		<cfargument name="field_office_id" type="numeric" required="true" />
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">                       
            SELECT     
            	ID,                
                DAY,
                AM_OPENING_HOUR,
				AM_OPENING_MINUTE,
              	AM_CLOSING_HOUR,
				AM_CLOSING_MINUTE,
                PM_OPENING_HOUR,
				PM_OPENING_MINUTE,
              	PM_CLOSING_HOUR,
				PM_CLOSING_MINUTE
            FROM                 
                TBL_OFFICES_HOURS_ALT
            WHERE 
                OFFICEID = <cfqueryparam value="#field_office_id#" cfsqltype="cf_sql_integer" /> 
			ORDER BY
            	SORT                                   
		</cfquery>          
        
		<cfreturn ls.qry>
	</cffunction>       
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateFieldOffice
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="updateFieldOffice" access="public" returntype="string">
		<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfquery datasource="#Application.settings.dsn#">          
            UPDATE
	            TBL_OFFICES TOF
            SET
            (
                TOF.ADDRESSLINE1,
                TOF.ADDRESSLINE2,
                TOF.POSTALCODE,
                TOF.PHONENUMBER,
                TOF.FAXNUMBER,
                TOF.MOBILENUMBER,
                TOF.SATELLITENUMBER,
                TOF.IRIDIUMNUMBER,
                TOF.OFFICIALEMAIL,
                TOF.ADMINEMAIL,
                TOF.FAVORITEEMAIL,
                TOF.EMAILTOUSE,
                TOF.OFFICEHOURS,
                TOF.OFFICEHOURS_MO,
                TOF.OFFICEHOURS_TU,
                TOF.OFFICEHOURS_WE,
                TOF.OFFICEHOURS_TH,
                TOF.OFFICEHOURS_FR,
                TOF.OFFICEHOURS_SA,
                TOF.OFFICEHOURS_SU,                
                TOF.CET,
                TOF.WEEKENDDAYS,
                TOF.STATUS,
                TOF.MODBY,
                TOF.MODON
            ) = 
            (
                SELECT
                    TOFA.ADDRESSLINE1,
                    TOFA.ADDRESSLINE2,
                    TOFA.POSTALCODE,
                    TOFA.PHONENUMBER,
                    TOFA.FAXNUMBER,
                    TOFA.MOBILENUMBER,
                    TOFA.SATELLITENUMBER,
                    TOFA.IRIDIUMNUMBER,
                    TOFA.OFFICIALEMAIL,
                    TOFA.ADMINEMAIL,
                    TOFA.FAVORITEEMAIL,
                    TOFA.EMAILTOUSE,
                    TOFA.OFFICEHOURS,
                    TOFA.OFFICEHOURS_MO,
					TOFA.OFFICEHOURS_TU,
                    TOFA.OFFICEHOURS_WE,
                    TOFA.OFFICEHOURS_TH,
                    TOFA.OFFICEHOURS_FR,
                    TOFA.OFFICEHOURS_SA,
                    TOFA.OFFICEHOURS_SU,                     
                    TOFA.CET,
                    TOFA.WEEKENDDAYS,
                    TOFA.STATUS,
                    TOFA.MODBY,
                    TOFA.MODON
                FROM
	                TBL_OFFICES_ALT TOFA
                WHERE
    	            TOFA.ID = TOF.ID
            )
            WHERE 
        	    TOF.ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> 
        </cfquery>
        
        <cfreturn "OK">		
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateAltFieldOfficeHours
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
    
	<cffunction name="updateAltFieldOfficeHours" access="public" returntype="string">
		<cfargument name="id" type="numeric" required="true" />
        <cfargument name="username" type="string" required="true" />
        
        <cfargument name="am_opening_hour" type="any" required="true" />
        <cfargument name="am_opening_minute" type="any" required="true" />     
        <cfargument name="am_closing_hour" type="any" required="true" />
        <cfargument name="am_closing_minute" type="any" required="true" />    
        
        <cfargument name="pm_opening_hour" type="any" required="true" />
        <cfargument name="pm_opening_minute" type="any" required="true" />     
        <cfargument name="pm_closing_hour" type="any" required="true" />
        <cfargument name="pm_closing_minute" type="any" required="true" />                 
        
        <cfset var ls = {}>	        	
        
		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">     
        	UPDATE
                 TBL_OFFICES_HOURS_ALT   
			SET
                AM_OPENING_HOUR = <cfqueryparam value="#am_opening_hour#" cfsqltype="cf_sql_integer" null="#am_opening_hour EQ ''#" />,
				AM_OPENING_MINUTE = <cfqueryparam value="#am_opening_minute#" cfsqltype="cf_sql_integer" null="#am_opening_minute EQ ''#" />,
              	AM_CLOSING_HOUR = <cfqueryparam value="#am_closing_hour#" cfsqltype="cf_sql_integer" null="#am_closing_hour EQ ''#" />,
				AM_CLOSING_MINUTE = <cfqueryparam value="#am_closing_minute#" cfsqltype="cf_sql_integer" null="#am_closing_minute EQ ''#" />,
                PM_OPENING_HOUR = <cfqueryparam value="#pm_opening_hour#" cfsqltype="cf_sql_integer" null="#pm_opening_hour EQ ''#" />,
				PM_OPENING_MINUTE = <cfqueryparam value="#pm_opening_minute#" cfsqltype="cf_sql_integer" null="#pm_opening_minute EQ ''#" />,
              	PM_CLOSING_HOUR = <cfqueryparam value="#pm_closing_hour#" cfsqltype="cf_sql_integer" null="#pm_closing_hour EQ ''#" />,
				PM_CLOSING_MINUTE = <cfqueryparam value="#pm_closing_minute#" cfsqltype="cf_sql_integer" null="#pm_closing_minute EQ ''#" />,
                MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_string" />,
                MODON = SYSDATE   
            WHERE 
                ID = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" /> 
		</cfquery>          
        
		<cfreturn "OK">
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateFieldOfficeHours
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->  
    
	<cffunction name="updateFieldOfficeHours" access="public" returntype="string">
		<cfargument name="office_id" type="numeric" required="true" />               
        
        <cfset var ls = {}>	 
        
            <cfquery name="ls.query" datasource="#Application.settings.dsn#">  
            	SEELECT
                	ID
				FROM
					TBL_OFFICES_HOURS    
				WHERE
                	OFFICEID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                                                  
            </cfquery>
            
            <cfloop query="ls.query">
            
	            <cfquery datasource="#Application.settings.dsn#"> 
                    UPDATE
                        TBL_OFFICES_HOURS
                    SET
                    (
                        AM_OPENING_HOUR, 
                        AM_OPENING_MINUTE,
                        AM_CLOSING_HOUR,
                        AM_CLOSING_MINUTE,
                        PM_OPENING_HOUR,
                        PM_OPENING_MINUTE,
                        PM_CLOSING_HOUR,
                        PM_CLOSING_MINUTE,
                        MODBY,
                        MODON
                    )  =
                    SELECT
                    (
                        AM_OPENING_HOUR, 
                        AM_OPENING_MINUTE,
                        AM_CLOSING_HOUR,
                        AM_CLOSING_MINUTE,
                        PM_OPENING_HOUR,
                        PM_OPENING_MINUTE,
                        PM_CLOSING_HOUR,
                        PM_CLOSING_MINUTE,
                        MODBY,
                        MODON  
                    )
                    FROM
	                    TBL_OFFICES_HOURS_ALT
                    WHERE
                    	ID = <cfqueryparam value="#ls.query.id#" cfsqltype="cf_sql_integer" />  
                </cfquery>
                
            </cfloop> 
        
		<cfreturn "OK">	
	</cffunction>     
        
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateAltFieldOffice
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="updateAltFieldOffice" access="public" returntype="string">
	    <cfargument name="username" type="string" required="true" />       
		<cfargument name="items" type="struct" required="true" />
                
		<cfquery datasource="#Application.settings.dsn#">       
        	UPDATE      
	            TBL_OFFICES_ALT TOF
			SET
                TOF.ADDRESSLINE1 = <cfqueryparam value="#items.address_line_1#" cfsqltype="cf_sql_varchar" />,
                TOF.ADDRESSLINE2 = <cfqueryparam value="#items.address_line_2#" cfsqltype="cf_sql_varchar" />,
                TOF.POSTALCODE = <cfqueryparam value="#items.postal_code#" cfsqltype="cf_sql_varchar" />,
                TOF.PHONENUMBER = <cfqueryparam value="#items.phone_number#" cfsqltype="cf_sql_varchar" />,
                TOF.FAXNUMBER = <cfqueryparam value="#items.fax_number#" cfsqltype="cf_sql_varchar" />,
				TOF.MOBILENUMBER = <cfqueryparam value="#items.mobile_number#" cfsqltype="cf_sql_varchar" />,
                TOF.SATELLITENUMBER = <cfqueryparam value="#items.satellite_number#" cfsqltype="cf_sql_varchar" />,
                TOF.IRIDIUMNUMBER = <cfqueryparam value="#items.iridium_number#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICIALEMAIL = <cfqueryparam value="#items.official_email#" cfsqltype="cf_sql_varchar" />,
                TOF.ADMINEMAIL = <cfqueryparam value="#items.admin_email#" cfsqltype="cf_sql_varchar" />,
                TOF.FAVORITEEMAIL = <cfqueryparam value="#items.favorite_email#" cfsqltype="cf_sql_varchar" />,
                TOF.EMAILTOUSE = <cfqueryparam value="#items.email_to_use#" cfsqltype="cf_sql_integer" />,
                TOF.OFFICEHOURS = <cfqueryparam value="#items.office_hours#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICEHOURS_MO = <cfqueryparam value="#items.office_hours_mo#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICEHOURS_TU = <cfqueryparam value="#items.office_hours_tu#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICEHOURS_WE = <cfqueryparam value="#items.office_hours_we#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICEHOURS_TH = <cfqueryparam value="#items.office_hours_th#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICEHOURS_FR = <cfqueryparam value="#items.office_hours_fr#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICEHOURS_SA = <cfqueryparam value="#items.office_hours_sa#" cfsqltype="cf_sql_varchar" />,
                TOF.OFFICEHOURS_SU = <cfqueryparam value="#items.office_hours_su#" cfsqltype="cf_sql_varchar" />,
                TOF.CET = <cfqueryparam value="#items.cet#" cfsqltype="cf_sql_varchar" />,
                TOF.WEEKENDDAYS = <cfqueryparam value="#items.weekend_days#" cfsqltype="cf_sql_integer" />,		
                TOF.MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />,
                TOF.MODON = SYSDATE
			WHERE
				TOF.ID = <cfqueryparam value="#items.field_office_id#" cfsqltype="cf_sql_integer" />     
		</cfquery> 
        
        <cfreturn "OK">		
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function discardChanges
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="discardChanges" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />  
        <!---<cfargument name="del_user_id" type="numeric" required="true" />--->  
		<cfargument name="office_id" type="numeric" required="true" />  
        <cfargument name="log_status_code" type="string" required="true" />  
        
        <cftransaction>
        
            <cfquery datasource="#Application.settings.dsn#">          
                UPDATE
                    TBL_OFFICES_ALT TOFA
                SET
                (
                    TOFA.ADDRESSLINE1,
                    TOFA.ADDRESSLINE2,
                    TOFA.POSTALCODE,
                    TOFA.PHONENUMBER,
                    TOFA.FAXNUMBER,
                    TOFA.MOBILENUMBER,
                    TOFA.SATELLITENUMBER,
                    TOFA.IRIDIUMNUMBER,
                    TOFA.OFFICIALEMAIL,
                    TOFA.ADMINEMAIL,
                    TOFA.FAVORITEEMAIL,
                    TOFA.EMAILTOUSE,
                    TOFA.OFFICEHOURS,
                    TOFA.OFFICEHOURS_MO,
                    TOFA.OFFICEHOURS_TU,
                    TOFA.OFFICEHOURS_WE,
                    TOFA.OFFICEHOURS_TH,
                    TOFA.OFFICEHOURS_FR,
                    TOFA.OFFICEHOURS_SA,
                    TOFA.OFFICEHOURS_SU,                
                    TOFA.CET,
                    TOFA.WEEKENDDAYS,
                    TOFA.STATUS,
                    TOFA.MODBY,
                    TOFA.MODON
                ) = 
                (
                    SELECT
                        TOF.ADDRESSLINE1,
                        TOF.ADDRESSLINE2,
                        TOF.POSTALCODE,
                        TOF.PHONENUMBER,
                        TOF.FAXNUMBER,
                        TOF.MOBILENUMBER,
                        TOF.SATELLITENUMBER,
                        TOF.IRIDIUMNUMBER,
                        TOF.OFFICIALEMAIL,
                        TOF.ADMINEMAIL,
                        TOF.FAVORITEEMAIL,
                        TOF.EMAILTOUSE,
                        TOF.OFFICEHOURS,
                        TOF.OFFICEHOURS_MO,
                        TOF.OFFICEHOURS_TU,
                        TOF.OFFICEHOURS_WE,
                        TOF.OFFICEHOURS_TH,
                        TOF.OFFICEHOURS_FR,
                        TOF.OFFICEHOURS_SA,
                        TOF.OFFICEHOURS_SU,                     
                        TOF.CET,
                        TOF.WEEKENDDAYS,
                        TOF.STATUS,
                        TOF.MODBY,
                        TOF.MODON
                    FROM
                        TBL_OFFICES TOF
                    WHERE
                        TOF.ID = TOFA.ID
                )
                WHERE 
                    TOFA.ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" /> 
            </cfquery>
            
            <cfquery name="ls.query" datasource="#Application.settings.dsn#">  
            	SEELECT
                	ID
				FROM
					TBL_OFFICES_HOURS    
				WHERE
                	OFFICEID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                                                  
            </cfquery>
            
            <cfloop query="ls.query">
            
	            <cfquery datasource="#Application.settings.dsn#"> 
                    UPDATE
                        TBL_OFFICES_HOURS_ALT
                    SET
                    (
                        AM_OPENING_HOUR, 
                        AM_OPENING_MINUTE,
                        AM_CLOSING_HOUR,
                        AM_CLOSING_MINUTE,
                        PM_OPENING_HOUR,
                        PM_OPENING_MINUTE,
                        PM_CLOSING_HOUR,
                        PM_CLOSING_MINUTE,
                        MODBY,
                        MODON
                    )  =
                    SELECT
                    (
                        AM_OPENING_HOUR, 
                        AM_OPENING_MINUTE,
                        AM_CLOSING_HOUR,
                        AM_CLOSING_MINUTE,
                        PM_OPENING_HOUR,
                        PM_OPENING_MINUTE,
                        PM_CLOSING_HOUR,
                        PM_CLOSING_MINUTE,
                        MODBY,
                        MODON  
                    )
                    FROM
	                    TBL_OFFICES_HOURS
                    WHERE
                    	ID = ls.query.id
                </cfquery>
                
            </cfloop>
            
            <!---status would be OMM_EXTERNAL_STATUS--->
            <cfset insertStatusLog(user_id, office_id, log_status_code)>
        
        </cftransaction>
        
        <cfreturn "OK">		
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function updateAltFieldOfficeStatus
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->      
    
	<cffunction name="updateAltFieldOfficeStatus" access="public" returntype="string">
	    <cfargument name="username" type="string" required="true" />
        <cfargument name="office_id" type="numeric" required="true">
        <cfargument name="status" type="string" required="true" />		
        
        <!---useername cannot be overwritten by a statu-schanging user, or else the ditor is no longer recognized--->
                
		<cfquery datasource="#Application.settings.dsn#">       
        	UPDATE      
	            TBL_OFFICES_ALT TOFA
			SET    
            	TOFA.STATUS = <cfqueryparam value="#status#" cfsqltype="cf_sql_varchar" />
<!---                TOFA.MODBY = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar" />, 
                TOFA.MODON = SYSDATE--->
			WHERE
				TOFA.ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />  
		</cfquery>
        
        <cfreturn "OK">        
        
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function requestValidate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="requestValidate" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />       
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="username" type="string" required="true" /> 
        <cfargument name="alt_status" type="string" required="true" /> 
        <cfargument name="log_status_code" type="string" required="true" />         
        
        <cftransaction>     
                      
            <!---alt_status would be 'OMM_VALIDATION_PENDING'--->
			<cfset updateAltFieldOfficeStatus(username, office_id, alt_status)>
                        
	     	<!---log_status would be 'OMM_VALIDATION_PENDING'--->
	        <cfset insertStatusLog(user_id, office_id, log_status_code)>            
        
        </cftransaction>               
        
		<cfreturn "OK">
	       
	</cffunction>                             
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function validateEdit
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="validateEdit" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />       
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="username" type="string" required="true" /> 
        <cfargument name="alt_status" type="string" required="true" /> 
        <cfargument name="log_status_code" type="string" required="true" />  
        
        <!--- Validating basically means copying data from alt table to update regular table --->
        
        <cftransaction>
            
           <!---alt_status would be 'In Activity'--->
			<cfset updateAltFieldOfficeStatus(username, office_id, alt_status)> 
            
        	<!---log_status_code would be 'OMM_EXTERNAL_STATUS'--->
	        <cfset insertStatusLog(user_id, office_id, log_status_code)>              
            
           	<!---copy all data from Alt to Main--->
            <cfset updateFieldOffice(office_id)>
        
        </cftransaction>               
        
		<cfreturn "OK">
	       
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function rejectEdit
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="rejectEdit" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />       
    	<cfargument name="office_id" type="numeric" required="true" /> 
        <cfargument name="username" type="string" required="true" /> 
        <cfargument name="alt_status" type="string" required="true" /> 
        <cfargument name="log_status_code" type="string" required="true" />   
        
        <cftransaction>
                
	        <!---alt_status would be 'Edit in progress'--->
			<cfset updateAltFieldOfficeStatus(username, office_id, alt_status)>  
            
	        <!---log_status_code would be 'OMM_CORRECTION_PENDING'--->
	        <cfset insertStatusLog(user_id, office_id, log_status_code)>            
        
        </cftransaction>
        
		<cfreturn "OK">
	       
	</cffunction>      
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function insertStatusLog
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="insertStatusLog" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
        <!---<cfargument name="del_user_id" type="numeric" required="true" />--->       
    	<cfargument name="office_id" type="numeric" required="true" />        
        <cfargument name="log_status_code" type="string" required="true" />          
        
        <cfset var ls = {}>
        
        <cftransaction> 
        
        	<cfquery name="ls.qry" datasource="#Application.settings.dsn#"> 
                SELECT
               		ST.STATUS_CODE
                FROM
	                FSM_OFFICES_STATUS_LOG LG,
    	            FSM_STATUSES ST
                WHERE
        	        LG.OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />
            	    AND LG.IS_CURRENT = 'Y'
                	AND LG.STATUS_ID = ST.ID   
            </cfquery>
            
            <cfif ls.qry.status_code NEQ log_status_code>
            	<!---no point in duplicating the current status--->
        
                <cfquery datasource="#Application.settings.dsn#">       
                    UPDATE FSM_OFFICES_STATUS_LOG TOFA
                    SET    
                        IS_CURRENT = 'N'
                    WHERE
                        OFFICE_ID = <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />  
                </cfquery>          
                
                <cfquery datasource="#Application.settings.dsn#">       
                    INSERT INTO FSM_OFFICES_STATUS_LOG 
                    (
                        OFFICE_ID,
                        STATUS_ID,
                        IS_CURRENT,
                        CREATED_BY,
                        CREATED_ON
                    )  
                    SELECT
                        <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />,
                        ST.ID,
                        'Y',
                        <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />,
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
	Function chkViewOffice
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewOffice" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_FOM.F_CHK_VIEW(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewNewOffice
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewNewOffice" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_FOM.F_CHK_VIEW_ALT(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>    
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkEditOffice
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkEditOffice" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_FOM.F_CHK_EDIT(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />               
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkValidateOffice
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkValidateOffice" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_FOM.F_CHK_VALIDATE(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>   
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkRejectValidate
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkRejectValidate" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_FOM.F_CHK_REJECT(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>        
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkRequestValidateOffice
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkRequestValidateOffice" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_FOM.F_CHK_REQUEST_VALIDATE(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>     
    
<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function chkViewEditStatus
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->

	<cffunction name="chkViewEditStatus" access="public" returntype="string">
	    <cfargument name="user_id" type="numeric" required="true" />
    	<cfargument name="office_id" type="numeric" required="true" /> 
        
        <cfset var ls = {}>   

		<cfquery name="ls.qry" datasource="#Application.settings.dsn#">
            SELECT
            	PKG_FSM_FOM.F_CHK_VIEW_EDIT_STATUS(
   				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />, 
                <cfqueryparam value="#office_id#" cfsqltype="cf_sql_integer" />                
                ) CHK
			FROM 
            	DUAL                	                
        </cfquery>
        
        <cfreturn ls.qry.CHK>        
	</cffunction>      

</cfcomponent>
