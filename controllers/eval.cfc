component accessors="true" {

    property beanFactory;   
    property staffService;    
    property commonService;
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
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    public function checkUserPriv(required string priv, required string user_id, required string office_id, numeric eval_id){    	
    	var ls = {};
	    ls.chk = "N";         
        
        if( StructKeyExists(Arguments, "eval_id") )
	    	ls.chk = variables.evalService.checkUserPriv(priv, user_id, office_id, eval_id);   
		else  
	        ls.chk = variables.evalService.checkUserPriv(priv, user_id, office_id);            
    
	    return ls.chk;
    }   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewPreparation( rc ) {     
	    var ls = {};  
       
		ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id ); 
       
        rc.chkViewEvaluation = checkUserPriv("viewEvaluation", ls.user_id, ls.office_id, ls.eval_id);
        if(rc.chkViewEvaluation == "N"){
        	throw("illegalAccessException2");
		} 
        
        rc.chkRequestAuthorization = checkUserPriv("requestAuthorization", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkDeleteEvaluation = checkUserPriv("deleteEvaluation", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkAuthorizePreparation = checkUserPriv("authorizePreparation", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkEditPreparation = checkUserPriv("editPreparation", ls.user_id, ls.office_id, ls.eval_id);        
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/viewPreparation" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //matching view is called automatically
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function default
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function default( rc ) {
    	var ls = {};        
       
        variables.fw.redirect( action = 'eval.grid', queryString = 'jx', append="id,field_office_id");
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "eval/grid" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function grid 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function grid( rc ) {     
	    var ls = {};        
        
		ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        
        rc.chkAddEvaluation = checkUserPriv("addEvaluation", ls.user_id, ls.office_id);        
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/grid" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getEvalGridData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getEvalGridData( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id;        
        ls.office_id = ( structKeyExists(rc, "id") ? rc.id : rc.office_id );      
        ls.lang_code = Session.user.settings.displayLanguage;           
                
        ls.retval = variables.evalService.getEvalGridData(ls.user_id, ls.office_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUsersByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getUsersByEval( rc ) { 
		var ls = {};         
        
        ls.user_id = Session.user.user_id;
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );                 
                
        ls.retval = variables.evalService.getUsersByEval(ls.user_id, ls.office_id, ls.eval_id);        
        
        variables.fw.renderData("json", ls.retval);
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUsersByRole
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getUsersByRole( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );                 
                
        ls.retval = variables.evalService.getUsersByRole(ls.user_id, ls.office_id, ls.eval_id);        
        
        variables.fw.renderData("json", ls.retval);
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function tabs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function tabs( rc ) {     
	    var ls = {};               
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/tabs" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function setPreparation( rc ) {     
	    var ls = {};  
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/setPreparation" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editPreparation( rc ) {     
	    var ls = {};  
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/editPreparation" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveEditPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveEditPreparation( rc ) {     
	    var ls = {};      
        
        //throw (message = "My Message", type = "My Exception Type");
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id ); 
        ls.lang_code = Session.user.settings.displayLanguage;   
        
        ls.retval = variables.evalService.saveEditPreparation(ls.user_id, ls.del_user_id, ls.eval_id, ls.office_id, ls.lang_code, rc);             
    	
        variables.fw.renderData("json", ls.retval);
	}   
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getEvalData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getEvalData( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;   
        ls.office_id = Session.user.settings.current_field_office_id;      
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage;             
                
        ls.retval = variables.evalService.getEvalData(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPhasesByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getPhasesByEval( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;  
        ls.office_id = Session.user.settings.current_field_office_id;      
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage;            
                
        ls.retval = variables.evalService.getPhasesByEval(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDocumentsByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getDocumentsByEval( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;  
        ls.office_id = Session.user.settings.current_field_office_id;       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage;             
                
        ls.retval = variables.evalService.getDocumentsByEval(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getEvalTypes
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getEvalTypes( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.lang_code = Session.user.settings.displayLanguage;
                
        ls.retval = variables.evalService.getEvalTypes(ls.user_id, ls.office_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function requestAuthorization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function requestAuthorization( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage; 
    	
		ls.retval = variables.evalService.requestAuthorization(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);    
        
        variables.fw.renderData("json", ls.retval);
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function authorizePreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function authorizePreparation( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
    	
		ls.retval = variables.evalService.authorizePreparation(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);        
        
        variables.fw.renderData("json", ls.retval);
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function rejectPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function rejectPreparation( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
    	
		ls.retval = variables.evalService.rejectPreparation(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);        
        
        variables.fw.renderData("json", ls.retval);
	}                     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPrepComments
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function getPrepComments( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id;        
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );
        
        ls.retval = variables.evalService.getPrepComments(ls.user_id, ls.office_id, ls.eval_id);  
        
        variables.fw.renderData("json", ls.retval);        
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deletePreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function deletePreparation( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
        
        ls.retval = variables.evalService.deletePreparation(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);  
        
        variables.fw.renderData("json", ls.retval);        
	}  
}    