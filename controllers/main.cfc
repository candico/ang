component accessors="true" {

    property beanFactory;   
    property staffService;    
    property commonService;
    property formatterService;
    property securityService; 
    property userService; 
    property evalService; 
    
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
    	setting showdebugoutput="no";   
        
        var ls = {};
        ls.qstr = ListLast(CGI.HTTP_REFERER, "?");        
        Session.user.settings["ses"] = getSesUrlParams( CGI.HTTP_REFERER ); 
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getSesUrlParams
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public struct function getSesUrlParams( required string http_referrer ){     
    	var ls = {}; 
				
		ls.qstr = ListLast(http_referrer, "?");                	
        ls.qstr = Replace(ls.qstr, "/", "");
               
		ls["ses"] = {};
		ls.ses["qstr"] = ls.qstr;
        ls.ses["referrer"] = http_referrer;                 
		ls.ses["module"] = "";
		ls.ses["section"] = "";
		ls.ses["screen"] = "";
		ls.ses["id"] = "";  
        
        ls.regex = "";
		ls.regs = ["^([A-Za-z]+)$", "^([A-Za-z]+)/(\d+)$", "^([A-Za-z]+)/(g|v|e)/(\d+)$", "^([A-Za-z]+):([A-Za-z]+)$", "^([A-Za-z]+):([A-Za-z]+)/(\d+)$", "^([A-Za-z]+):([A-Za-z]+)/(g|v|e)/(\d+)$"];  
        
        for (ls.idx = 1; ls.idx LTE ArrayLen(ls.regs); ls.idx++) {
            if( REFindNoCase(ls.regs[ls.idx], ls.qstr) ){  
                ls.regex = ls.regs[ls.idx];
                break;
            }
        }   
        
        ls.ses["idx"] = ls.idx;     
        
        switch(ls.idx) {
            case 1:	
                ls.ref = REFindNoCase(ls.regex, ls.qstr, 1, true);
                ls.ses.section = Mid(ls.qstr, ls.ref["POS"][2], ls.ref["LEN"][2]);						 
                break;
            case 2:	
                ls.ref = REFindNoCase(ls.regex, ls.qstr, 1, true);
                ls.ses.section = Mid(ls.qstr, ls.ref["POS"][2], ls.ref["LEN"][2]);
                ls.ses.id = Mid(ls.qstr, ls.ref["POS"][3], ls.ref["LEN"][3]); 
                break;
            case 3:	
                ls.ref = REFindNoCase(ls.regex, ls.qstr, 1, true);
                ls.ses.section = Mid(ls.qstr, ls.ref["POS"][2], ls.ref["LEN"][2]);
                ls.ses.screen = Mid(ls.qstr, ls.ref["POS"][3], ls.ref["LEN"][3]);
                ls.ses.id = Mid(ls.qstr, ls.ref["POS"][4], ls.ref["LEN"][4]); 
                break;
            case 4:	
                ls.ref = REFindNoCase(ls.regex, ls.qstr, 1, true);
                ls.ses.module = Mid(ls.qstr, ls.ref["POS"][2], ls.ref["LEN"][2]);	
                ls.ses.section = Mid(ls.qstr, ls.ref["POS"][3], ls.ref["LEN"][3]);						 
                break;		
            case 5:	
                ls.ref = REFindNoCase(ls.regex, ls.qstr, 1, true);
                ls.ses.module = Mid(ls.qstr, ls.ref["POS"][2], ls.ref["LEN"][2]);	
                ls.ses.section = Mid(ls.qstr, ls.ref["POS"][3], ls.ref["LEN"][3]);
                ls.ses.id = Mid(ls.qstr, ls.ref["POS"][4], ls.ref["LEN"][4]);						 
                break;	
            case 6:	
                ls.ref = REFindNoCase(ls.regex, ls.qstr, 1, true);
                ls.ses.module = Mid(ls.qstr, ls.ref["POS"][2], ls.ref["LEN"][2]);	
                ls.ses.section = Mid(ls.qstr, ls.ref["POS"][3], ls.ref["LEN"][3]);
                ls.ses.screen = Mid(ls.qstr, ls.ref["POS"][4], ls.ref["LEN"][4]);
                ls.ses.id = Mid(ls.qstr, ls.ref["POS"][5], ls.ref["LEN"][5]);						 
                break;																			
        } 
            
        if( ls.ses.screen == "v" && isNumeric(ls.ses.id) )
        	ls.ses.screen = "view";            
		else if( ls.ses.screen == "e" && isNumeric(ls.ses.id) )
        	ls.ses.screen = "edit";
		else if( isNumeric(ls.ses.id) )
        	ls.ses.screen = "view";            
		else    
	        ls.ses.screen = "grid";         
        
        return ls.ses;   
	}    
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function default
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
	
	public void function default( rc ) {
    	var ls = {};         
        
        lock scope="Session" type="Readonly" Timeout="3" {
	        ls.user = duplicate(Session.user);
		}  
        
        ls.user_id = ls.user.user_id; 
   	    ls.office_id = ls.user.settings.current_field_office_id;            
		
        rc.chkViewEvaluations = variables.evalService.checkUserPriv("viewEvaluations", ls.user_id, ls.office_id, 0);
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "main/default" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }      
        
         variables.fw.setLayout("menu");
        //matching template automatically called
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function info
// Display the user-specific information screen
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      	
    
	public void function info( rc ) {
    	var ls = {};       
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "main/info" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
        
        //matching template automatically called
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUserSettings
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      	
    
	public void function getUserSettings( rc ) {
    	var ls = {};  
        
        lock scope="Session" type="Readonly" Timeout="3" {
        	ls.user = Duplicate(Session.user);
        }
        
        ls.user_id = ls.user.user_id; 
   	    ls.office_id = ls.user.settings.current_field_office_id; 
		
        //rc.chkViewEvaluations = variables.evalService.checkUserPriv("viewEvaluations", ls.user_id, ls.office_id, 0);        
       
        ls.result1 = variables.userService.getUserSettings(ls.user); 
        ls.result2 = variables.userService.getUserData(ls.user); 
        StructAppend(ls.result1.data, ls.result2.data);
        
        ls.result1.data["privs"] = getPermissions();
        //ls.result1.data.privs["chk_view_evaluations"] = rc.chkViewEvaluations;
                           
        ls.settings = ls.result1.data;
        
      	variables.fw.renderData("json", ls.settings);
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setOffice
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public void function setOffice( rc ){  
    	var ls = {};
		ls.retval = {};   

        lock scope="Session" type="Readonly" Timeout="3" {
        	ls.user = Duplicate(Session.user);
        }

        ls.res = Variables.userService.setOffice(ls.user, rc.office_id);
        ls.data = ls.res.data;
        ls.result = ls.res.result;

        //Set values in Session
        lock scope="Session" type="Exclusive" Timeout="3" {
	        Session.user.settings["current_field_office_id"] = duplicate(ls.data.current_field_office_id);
    	    Session.user.settings["current_field_office"] = duplicate(ls.data.current_field_office);
		}
        
        /*lock scope="Session" type="Readonly" Timeout="3" {
        	ls.user = Duplicate(Session.user);
        }

        variables.fw.renderData("json", ls.user);  */

        getUserSettings( argumentcollection = arguments );
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setUserSetting
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      	
    
	public void function setUserSetting( rc ) {
    	var ls = {};   
        ls.retval = {};    
        
        lock scope="Session" type="Readonly" Timeout="3" {
        	ls.user = Duplicate(Session.user);			 
        }                 
        
        ls.res = Variables.userService.setUserSetting( ls.user, rc.setting, rc.val );   
        ls.data = ls.res.data;
        ls.result = ls.res.result;        
        
        //Set values in Session
        lock scope="Session" type="Exclusive" Timeout="3" {
	        for(ls.key in ls.data) {
		        Session.user.settings[ls.key] = duplicate(ls.data[ls.key]);
        	}
        }
        
      	variables.fw.renderData("json", ls.result);
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getOffices
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public void function getOffices(){  
    	var ls = {};        
		ls.retval = {};
        
        lock scope="Session" type="Readonly" Timeout="3" {
        	ls.user = Duplicate(Session.user);			 
        }
        
        ls.user_id = ls.user.user_id;
        
        ls.retval.data = Variables.userService.getOfficesByUser(ls.user_id).data;        
                
        variables.fw.renderData("json", ls.retval.data);  
    }  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getTasks
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public void function getTasks(){  
    	var ls = {};
		ls.retval = {};
        ls.retval.data = [];
        
        lock scope="Session" type="Readonly" Timeout="3" {
        	ls.user = Duplicate(Session.user);			 
        }        
        
		ls.user_id = ls.user.user_id; 
        ls.username = ls.user.username; 
        ls.office_id = ls.user.settings.current_field_office_id; 
        
        //We'll add more as needed
        omm_tasks =  Variables.userService.getOMMTasksByUser(ls.user_id, ls.username, ls.office_id).data; 
        smm_tasks = Variables.userService.getSMMTasksByUser(ls.user_id, ls.username, ls.office_id).data;  
        
        ArrayAppend(ls.retval.data, omm_tasks, true);
        ArrayAppend(ls.retval.data, smm_tasks, true);        
        
        //ls.retval.data = Variables.userService.getOMMTasksByUser(ls.user_id, ls.username, ls.office_id).data; 
		//ls.retval.data2 = Variables.userService.getSMMTasksByUser(ls.user_id, ls.username, ls.office_id).data;        
                
        variables.fw.renderData("json", ls.retval.data);  
    }         
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function throw
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      	
    
	public void function throw( rc ) {
    	var ls = {};        
        
        throw(type="InvalidData", message="All values must be greater than 0."); 
	}

    public struct function getPermissions(){
        var ret = {
            "loginAs": {"visible": true},
            "home": {"visible": true},
            "changeOffice": {"visible": false},
            "staff": {"visible": false},
            "evaluations": {
                "visible": true,
                "prepararation": {
                    "EVM_PREPARATOR": { // D4
                        "visible": true,
                        "edit": true
                    },
                    "EVM_EVALUEE": { // Evaluee
                        "visible": true,
                        "edit": false
                    },
                    "EVM_SUPERVISOR": { // Evaluator
                        "visible": true,
                        "edit": false
                    },
                    "EVM_CONTRIBUTOR": { // Contributor
                        "visible": false,
                        "edit": false
                    },
                    "EVM_HEAD": {
                        "visible": true,
                        "edit": false
                    }
                },
                "selfassesment": {
                    "EVM_PREPARATOR": { // D4
                        "visible": true,
                        "edit": false
                    },
                    "EVM_EVALUEE": { // Evaluee
                        "visible": true,
                        "edit": true
                    },
                    "EVM_SUPERVISOR": { // Evaluator
                        "visible": true,
                        "edit": false
                    },
                    "EVM_CONTRIBUTOR": { // Contributor
                        "visible": false,
                        "edit": false
                    },
                    "EVM_HEAD": {
                        "visible": true,
                        "edit": false
                    }
                },
                "feedback": {
                    "EVM_PREPARATOR": { // D4
                        "visible": true,
                        "edit": false
                    },
                    "EVM_EVALUEE": { // Evaluee
                        "visible": true,
                        "edit": false
                    },
                    "EVM_SUPERVISOR": { // Evaluator
                        "visible": true,
                        "edit": false
                    },
                    "EVM_CONTRIBUTOR": { // Contributor
                        "visible": true,
                        "edit": true
                    },
                    "EVM_HEAD": {
                        "visible": true,
                        "edit": false
                    }
                },
                "evaluatorAssesment": {
                    "EVM_PREPARATOR": { // D4
                        "visible": true,
                        "edit": false
                    },
                    "EVM_EVALUEE": { // Evaluee
                        "visible": true,
                        "edit": false
                    },
                    "EVM_SUPERVISOR": { // Evaluator
                        "visible": true,
                        "edit": true
                    },
                    "EVM_CONTRIBUTOR": { // Contributor
                        "visible": false,
                        "edit": false
                    },
                    "EVM_HEAD": {
                        "visible": true,
                        "edit": false
                    }
                },
                "closure": {
                    "EVM_PREPARATOR": { // D4
                        "visible": true,
                        "edit": true
                    },
                    "EVM_EVALUEE": { // Evaluee
                        "visible": true,
                        "edit": true
                    },
                    "EVM_SUPERVISOR": { // Evaluator
                        "visible": true,
                        "edit": true
                    },
                    "EVM_CONTRIBUTOR": { // Contributor
                        "visible": true,
                        "edit": true
                    },
                    "EVM_HEAD": {
                        "visible": true,
                        "edit": false
                    }
                }
            }
        };
       
        if (structKeyExists(request.application.settings, 'Environment') && request.application.settings.Environment eq 'dev' ){
            ret.changeOffice.visible = true;
            ret.staff.visible = true;
        }
        
        if (structKeyExists(request.application.settings, 'Environment') && request.application.settings.Environment eq 'prod' ){
            ret.loginAs.visible = false;
        }


        return ret;
    }

}