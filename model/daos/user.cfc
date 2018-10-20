<cfcomponent accessors="Yes">

<!---=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	Function getOfficesByUser
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---->     
    
	<cffunction name="getOfficesByUser" access="public" returntype="query">
		<cfargument name="user_id" type="numeric" required="true" />       
        
        <cfset var ls = {}>	      
        
         <cfquery name="ls.qry" datasource="#Application.settings.dsn#">  
            SELECT                
                TOF.ID OFFICE_ID,
                TOF.CITY,
                T1.SORT_ORDER
            FROM
              TBL_OFFICES TOF,
                (
                    SELECT 
                        1 SORT_ORDER,
                        PR.OFFICE_ID
                    FROM
                        V_FSM_PROFILES PR
                    WHERE
                        USER_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />
                    UNION                  
                    SELECT    
                        2 SORT_ORDER,
                        RBU.OFFICE_ID 
                    FROM            
                        FSM_ROLES_BY_USER RBU
                    WHERE
                        RBU.USER_ID = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer" />              
                    UNION
                    SELECT  
                        3 SORT_ORDER,
                        TOF2.ID OFFICE_ID           
                    FROM
                        TBL_OFFICES TOF2
                    WHERE
                         TOF2.STATUS = 'In Activity' 
                        AND TOF2.ID NOT IN (188,190,171,180) <!--- ///hard-coded!!! Values for DEV !!! --->
                ) T1
            WHERE
              TOF.ID = T1.OFFICE_ID
            ORDER BY
              T1.SORT_ORDER,
              TOF.CITY
         </cfquery>         
        
        <cfreturn ls.qry>		
	</cffunction> 

</cfcomponent> 