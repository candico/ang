component accessors="true" {

    property beanFactory;       
    property userDao; 
    property securityDao; 
    property fomDao;     
    property staffDao;   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function init
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Built-in Function before
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function before( rc ) {
    	setting showdebugoutput = "No";    	
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getOfficesByUser
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getOfficesByUser(required numeric user_id){  
    	var ls = {};
        
        ls.dedup  = {}; //we have duplicates (with different sort order/rank). We'll keep the highest rank which appears first.
        ls.retval = {};        
        ls.retval["status"] = 1;
        ls.retval["data"] = [];        
        
	    ls.qry = Variables.userDao.getOfficesByUser(user_id); 
        
        for(ls.row in ls.qry){
            if( !StructKeyExists(ls.dedup, ls.row.office_id) ) {
	            ls.item = {};
            	ls.dedup[ls.row.office_id] = true;
            	ls.item["key"] = ls.row.office_id;
            	ls.item["value"] = ls.row.city;
                ls.item["rank"] = ls.row.sort_order;
                ArrayAppend(ls.retval.data, ls.item);
            }  
        }  
                
        return ls.retval;     
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getOMMTasksByUser
//	if status = "OMM_EXTERNAL_STATUS" then no task is pending
//	if status = "OMM_VALIDATION_PENDING" and user has "OMM_VALIDATOR" role then prompt for validation
//	if status = "OMM_CORRECTION_PENDING" and user has "OMM_EDITOR_ROLE" and user is editor then prompt for amend 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getOMMTasksByUser(required numeric user_id, required string username, required numeric office_id){  
    	var ls = {}; 
              
        ls.retval = {};  
        ls.roles = "";
        ls.tasks = []; 
        
        ls.user_id = user_id;
        ls.username = username;
        ls.office_id = office_id;
        
        ls.prompts = {};        
        ls.prompts["OMM_VALIDATION_PENDING"] = "Please Validate Office Data";
		ls.prompts["OMM_CORRECTION_PENDING"] = "Please Amend Office data";
        
		//What is the current status in FSM_OFFICES_STATUS_LOG?
        ls.qry = Variables.fomDao.getLogStatusQry(ls.office_id);
        
        if(ls.qry.status_code == "OMM_EXTERNAL_STATUS"){
        	ls.retval["status"] = "OK";
        	ls.retval["data"] = [];  
            return ls.retval;
		}                    
        
        //What are the user's OMM roles?
        ls.rolesByUserQry = Variables.fomDao.getRolesByUserQry(ls.user_id, ls.office_id);
        for(ls.role in ls.rolesByUserQry){
        	ls.roles = ListAppend(ls.roles, ls.role.role_code);
        }
        
        //Who last modified the TBL_OFFICES_ALT record?
        ls.altFieldOfficeSummaryQry = Variables.fomDao.getAltFieldOfficeSummaryQry(ls.office_id);
        ls.editor = ls.altFieldOfficeSummaryQry.modified_by;                      
		
		if(ls.qry.status_code == "OMM_VALIDATION_PENDING"){
        	if( ListFind(ls.roles, "OMM_VALIDATOR") ){
            	ls.task = {};     
                ls.task["office_id"] = ls.qry.office_id;            
                ls.task["module"] = "omm";                 
                ls.task["id"] = ls.qry.office_id;                
                ls.task["initiator"] = ls.qry.initiator;
                ls.task["since"] = ls.qry.created_on;
                ls.task["prompt"] = ls.prompts["OMM_VALIDATION_PENDING"];
                ArrayAppend(ls.tasks, ls.task);            
            }        
        }
        
		if(ls.qry.status_code == "OMM_CORRECTION_PENDING"){
        	if( ListFind(ls.roles, "OMM_EDITOR") && ls.editor == ls.username){
            	ls.task = {};
                ls.task["office_id"] = ls.qry.office_id; 
                ls.task["module"] = "omm"; 
                ls.task["id"] = ls.qry.office_id;                
                ls.task["initiator"] = ls.qry.initiator;
                ls.task["since"] = ls.qry.created_on;
                ls.task["prompt"] = ls.prompts["OMM_CORRECTION_PENDING"];
                ArrayAppend(ls.tasks, ls.task);            
            }        
        }    
        
        ls.retval["status"] = "OK";
        ls.retval["data"] = ls.tasks;
                        
        return ls.retval;     
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getSMMTasksByUser
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getSMMTasksByUser(required numeric user_id, required string username, required numeric office_id){  
    	var ls = {}; 
              
        ls.retval = {};  
        ls.roles = "";
        ls.tasks = []; 
        
        ls.user_id = user_id;
        ls.username = username;
        ls.office_id = office_id;
        
        ls.prompts = {};        
        ls.prompts["SMM_VALIDATION_PENDING"] = "Please Validate Staff Data";
        ls.prompts["SMM_VERIFICATION_PENDING"] = "Please Verify Staff Data";        
		ls.prompts["SMM_CORRECTION_PENDING"] = "Please Amend Staff Data";
        
        //What are the current SMM workflows for me in this office?
        ls.qry = Variables.staffDao.getCurrentWorkflowsQry(ls.user_id, ls.office_id);       
        
        for (ls.row in ls.qry) {
        
        	if(ls.row.role_code == "SMM_FIELD_VALIDATOR" && ls.row.status_code == "SMM_FIELD_VALIDATION_PENDING") {
            	ls.task = {};
                ls.task["office_id"] = ls.row.office_id;  
                ls.task["module"] = "nsm"; 
                ls.task["id"] = ls.row.staff_member_id;             
                ls.task["initiator"] = ls.row.initiator;
                ls.task["since"] = ls.row.since;
                ls.task["prompt"] = ls.prompts["SMM_VALIDATION_PENDING"] & " for " & ls.row.staff_member;
                ArrayAppend(ls.tasks, ls.task);  
            }
            
        	if(ls.row.role_code == "SMM_FIELD_VERIFIER" && ls.row.status_code == "SMM_FIELD_VERIFICATION_PENDING") {
            	ls.task = {};
                ls.task["office_id"] = ls.row.office_id; 
				ls.task["module"] = "nsm"; 
                ls.task["id"] = ls.row.staff_member_id;                             
                ls.task["initiator"] = ls.row.initiator;
                ls.task["since"] = ls.row.since;
                ls.task["prompt"] = ls.prompts["SMM_VERIFICATION_PENDING"] & " for " & ls.row.staff_member;
                ArrayAppend(ls.tasks, ls.task);   
            }   
            
        	if(ls.row.role_code == "SMM_HQ_VERIFIER" && ls.row.status_code == "SMM_HQ_VERIFICATION_PENDING") {
            	ls.task = {};
                ls.task["office_id"] = ls.row.office_id; 
				ls.task["module"] = "nsm"; 
                ls.task["id"] = ls.row.staff_member_id;                            
                ls.task["initiator"] = ls.row.initiator;
                ls.task["since"] = ls.row.since;
                ls.task["prompt"] = ls.prompts["SMM_VERIFICATION_PENDING"] & " for " & ls.row.staff_member;
                ArrayAppend(ls.tasks, ls.task);        
            }    
            
        	if(ls.row.role_code == "SMM_HQ_VALIDATOR" && ls.row.status_code == "SMM_HQ_VALIDATION_PENDING") {
            	ls.task = {};
                ls.task["office_id"] = ls.row.office_id; 
				ls.task["module"] = "nsm"; 
                ls.task["id"] = ls.row.staff_member_id;                              
                ls.task["initiator"] = ls.row.initiator;
                ls.task["since"] = ls.row.since;
                ls.task["prompt"] = ls.prompts["SMM_VALIDATION_PENDING"] & " for " & ls.row.staff_member;
                ArrayAppend(ls.tasks, ls.task); 
            }    
            
        	if(ls.row.role_code == "SMM_ANY_EDITOR" && ls.row.status_code == "SMM_EDIT_PENDING") {
            	ls.task = {};
                ls.task["office_id"] = ls.row.office_id; 
				ls.task["module"] = "nsm"; 
                ls.task["id"] = ls.row.staff_member_id;                             
                ls.task["initiator"] = ls.row.initiator;
                ls.task["since"] = ls.row.since;
                ls.task["prompt"] = ls.prompts["SMM_CORRECTION_PENDING"] & " for " & ls.row.staff_member;
                ArrayAppend(ls.tasks, ls.task);   
            }                        
        }   
        
        ls.retval["status"] = "OK";
        ls.retval["data"] = ls.tasks;
                        
        return ls.retval;     
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUserSettings
// This function is added just in case in might be useful in the future
// For the moment it echoes its Arguments
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function getUserSettings(required Struct user){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = {};                  
        
      	ls.retval.data = Duplicate(user.settings);  //Always copy session data, do not assign!
        
		return ls.retval;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUserData
// This function is added just in case in might be useful in the future
// For the moment it echoes its Arguments
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function getUserData(required Struct user){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = {};                  

      	ls.retval.data["fname"] = user.fname;           
      	ls.retval.data["lname"] = user.lname;   
        ls.retval.data["profile"] = user.profile;
        ls.retval.data["home_office_id"] = user.home_office_id;
        ls.retval.data["home_office"] = user.home_office;
        ls.retval.data["del_user_id"] = user.del_user_id;
        ls.retval.data["del_user_fname"] = user.del_user_fname;
        ls.retval.data["del_user_lname"] = user.del_user_lname;
        ls.retval.data["role_code"] = user.role_code;
        ls.retval.data["role_id"] = user.role_id;
        
		return ls.retval;
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setOffice
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      

	public struct function setOffice( required struct user, required numeric office_id ) {  
		var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;             
        ls.retval["data"] = {};
        ls.retval["result"] = {};    
		ls.retval.result["changed"] = false;  
        
        ls.oldval = user.settings.current_field_office_id;    
        
        ls.retval.result.changed = true;            
        
        ls.qry1 = Variables.securityDao.getRolesListQry(user.user_id, office_id);   
        ls.role_id_list = ls.qry1.role_id_list;
                
        ls.qry2 = Variables.fomDao.getFieldOfficeSummaryQry(office_id);
        ls.current_field_office = ls.qry2.city;    
        
        ls.retval.data["role_id_list"] = ls.role_id_list;
        ls.retval.data["current_field_office_id"] = office_id;
        ls.retval.data["current_field_office"] = ls.current_field_office;                    

        ls.retval.result["oldval"] = ls.oldval;
        ls.retval.result["newval"] = office_id;
        ls.retval.result["privs"] = ls.role_id_list;
        
        return ls.retval;        
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setUserSetting
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      	
    
	public struct function setUserSetting( required struct user, required string key, required any newval ) {
     	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;  
        ls.retval["result"] = {};    
		ls.retval.result["changed"] = false;        
        ls.oldval = "[none]"; 
       
        if( StructKeyExists(user.settings, key) ){
        	ls.oldval = user.settings[key];                      
        }  
        
		if(ls.oldval != newval) {
            ls.retval.result.changed = true;
            ls.retval.data[key] = newval;       
        } else {	       
            ls.retval.data[key] = ls.oldval; 
        }            
        
        ls.retval.result["oldval"] = ls.oldval;
        ls.retval.result["newval"] = newval;          
        
      	return ls.retval;
	}        
    
}    