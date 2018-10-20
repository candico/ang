component accessors=true {

	property securityDao;
    property beanFactory;
    property fomDao;
    property formatterService;  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateLogin
// and return user info + role info to populate Session in Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function validateLogin(required string username, numeric officeId){
    	var ls = {};
        ls.retval = {};
        ls.retval["status"] = -1;
        ls.retval["data"] = {};          
        
        ls.res = getUserData(username);
        
        if(ls.res.status == 1) { 
        
        	//set user                	    	
            ls.user = ls.res.user;   
            
            //set delegated user   
            ls.user["del_user_id"] = ""; 
            ls.user["del_user_fname"] = ""; 
            ls.user["del_user_lname"] = "";  
            
            //set user settings
            ls.user["settings"] = {}; 
            
            //set current office settings
            if( StructKeyExists(Arguments, officeId) ){
				ls.user.settings["current_field_office_id"] = Arguments.officeId;
	            ls.user.settings["current_field_office"] = "Current";            
            } else {
	            ls.user.settings["current_field_office_id"] = ls.res.user.home_office_id;
    	        ls.user.settings["current_field_office"] = ls.res.user.home_office;
			}                
            
            //set additional hard-coded settings (could come from stored user preferences later)
            ls.user.settings["displayLanguage"] = "EN";       
            ls.user.settings["initialHomeTab"] = "info";  
            ls.user.settings["initialFomTab"] = "info";  
            ls.user.settings["initialFomTabAction"] = "view";   
            
            ls.retval.user = ls.user;  
			ls.retval.status = 1;                      
        } else if(ls.user.status == -1){
        	ls.retval["error"] = "Username not found in FSM users";       
        }         
        
		return ls.retval;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateUsername
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-       

	public struct function validateUsername(required string username){
    
	   	var ls = {};
        ls.retval = {};       
    
	    ls.chk_username = Variables.securityDao.validateUsername(username); 
		if(ls.chk_username == "Y")
        	ls.retval.status = "OK";
		else
        	ls.retval.status = "NOK";
        
        return ls.retval;
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUserData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getUserData(required string username){  
    
		var ls = {};
        ls.retval = {}; 
		
		//is in principle always valid                   
		ls.qry = Variables.securityDao.getUserDataQry(username);  
        ls.rolesIdQry = Variables.securityDao.getRolesListQry(ls.qry.user_id, ls.qry.office_id);  
        ls.rolesCodesQry = Variables.securityDao.getRolesCodesQry(ls.qry.user_id, ls.qry.office_id);  
      
        ls.user["username"] = ls.qry.username; 
        ls.user["user_id"] = ls.qry.user_id;            
        ls.user["profile"] = ls.qry.profile; 
        ls.user["profile_id"] = ls.qry.profile_id;
        ls.user["lname"] = ls.qry.lname; 
        ls.user["fname"] = ls.qry.fname; 
        ls.user["home_office_id"] = ls.qry.office_id; 
        ls.user["home_office"] = ls.qry.office;
        ls.user["role_code"] = ListToArray( ValueList(ls.rolesCodesQry.ROLE_CODE) );
        ls.user["role_id"] = ValueList(ls.rolesIdQry.ROLE_ID_LIST);
        
        //define user settings
        ls.user["settings"] = {}; 
        
        //set current office settings
        ls.user.settings["current_field_office_id"] = ls.user["home_office_id"];
        ls.user.settings["current_field_office"] = ls.user["home_office"];
        
        //set additional hard-coded settings (could come from stored user preferences later)
        ls.user.settings["displayLanguage"] = "EN";       
        ls.user.settings["initialHomeTab"] = "info";  
        ls.user.settings["initialFomTab"] = "info";  
        ls.user.settings["initialFomTabAction"] = "view";          
        
        ls.retval.user = ls.user;          
        
        return ls.retval;  
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRolesByUser
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public array function getRolesByUser(){     
		var ls = {};         
        ls.users = [];
		           
        ls.qry = Variables.securityDao.getRolesByUserQry();         
        
        for(row in ls.qry) {
        	ls.user = {};
            ls.user["user_id"] = row.user_id;
            ls.user["username"] = row.username;
            ls.user["lname"] = row.lname;
            ls.user["fname"] = row.fname;
            ls.user["role_id"] = row.role_id;
            ls.user["role_code"] = row.role_code;
            ls.user["office_id"] = row.office_id; 
			ls.user["office"] = row.office; 
            ArrayAppend(ls.users, ls.user); 
        }
        
        return ls.users;  
    }    
      
}   