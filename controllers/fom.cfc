component accessors="true" {
    
    property fomService;            
    
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
        //rc.ses = variables.fw.getRoutePath();	
        //Session.user.settings.ses = rc.ses;
        //Variables.fw.redirect("main");
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function default
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function default( rc ) {   
    
	    ls.viewData = variables.fw.view( "fom/tabs" ); 
   		variables.fw.renderData().data( ls.viewData ).type( "html" );      
        
  /*      if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "fom/tabs" ); 
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        } */      
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    public function checkUserPriv( required string priv, required numeric user_id, required numeric office_id ){    	
    	var ls = {};
	    ls.chk = "N";    
      
		ls.chk = variables.fomService.checkUserPriv( priv, user_id, office_id );            
    
	    return ls.chk;
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function view
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function view( rc ) {
	    var ls = {};
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;         
        
		rc.chkView = checkUserPriv( "viewOffice", ls.user_id, ls.office_id );
        if( rc.chkView == "N" ){
        	throw( "illegalViewOfficeException" );
		}            
        rc.chkEdit = checkUserPriv( "editOffice", ls.user_id, ls.office_id );
        rc.chkValidate = checkUserPriv( "validateOffice", ls.user_id, ls.office_id ); 
        rc.chkReject = checkUserPriv( "rejectValidate", ls.user_id, ls.office_id ); 
        rc.chkRequestValidate = checkUserPriv( "requestValidateOffice", ls.user_id, ls.office_id ); 
        rc.chkViewEditStatus = checkUserPriv( "viewEditStatus", ls.user_id, ls.office_id ); 
    
	    param rc.field_office_id = 0; //error
        
        rc.field_office_id = ( structKeyExists( rc, "id")  ? rc.id : rc.field_office_id ); 
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "fom/view" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function edit
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function edit( rc ) {  
	    var ls = {};
        
		ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;          
        
		rc.chkEdit = checkUserPriv( "editOffice", ls.user_id, ls.office_id );
        if( rc.chkEdit == "N" ){
        	throw( "illegalEditOfficeException" );
		}        
    
	    param rc.field_office_id = 0; //create
        
        rc.field_office_id = ( structKeyExists(rc, "id") ? rc.id : rc.field_office_id );         
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "fom/edit" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveEditFieldOffice
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function saveEditFieldOffice( rc ) {  
        var ls = {};
        
		ls.user_id = Session.user.user_id; 
        ls.username = Session.user.username; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        
		rc.chkEdit = checkUserPriv("editOffice", ls.user_id, ls.office_id);
        if( rc.chkEdit == "N" ){
        	throw( "illegalSaveEditFieldOfficeException" );
		}                 
        
        rc.field_office_id = ( structKeyExists(rc, "id") ? rc.id : rc.field_office_id );  
                 
        ls.result = variables.fomService.saveEditFieldOffice( ls.user_id, ls.office_id, ls.username, rc );      
        
        variables.fw.renderData( "json", ls.result ); 
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFieldOfficeDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getFieldOfficeDetails( rc ) {  
	    var ls = {};        
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;         
        
		rc.chkView = checkUserPriv("viewOffice", ls.user_id, ls.office_id);
        if( rc.chkView == "N" ){
        	throw( "illegalGetFieldOfficeDetails" );
		}            
		rc.chkViewNew = checkUserPriv( "viewNewOffice", ls.user_id, ls.office_id );  
    
        rc.field_office_id = ( structKeyExists(rc, "id") ? rc.id : rc.field_office_id ); 
                
        ls.current = variables.fomService.getFieldOfficeDetails(rc); 
        if( rc.chkViewNew == "Y" ){
	        ls.new = variables.fomService.getNewFieldOfficeDetails( rc ); 
        	ls.current["alt"] = variables.fomService.getDiffs( ls.current, ls.new );
            ls.current["alt"]["edited_on"] = ls.new["edited_on"];
            ls.current["alt"]["editor"] = ls.new["editor"];
            ls.current["alt"]["status"] = ls.new["status"];
        }
        
		variables.fw.renderData( "json", ls.current ); 
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getNewFieldOfficeDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getNewFieldOfficeDetails( rc ) {  
	    var ls = {};
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;         
        
		rc.chkView = checkUserPriv("viewOffice", ls.user_id, ls.office_id);
        if( rc.chkView == "N" ){
        	throw( "illegalGetNewFieldOfficeDetails" );
		}            
		rc.chkViewNew = checkUserPriv( "viewNewOffice", ls.user_id, ls.office_id );  
        if( rc.chkViewNew == "N" ){
        	throw( "illegalGetNewFieldOfficeDetails2" );
		}                 
    
        rc.field_office_id = ( structKeyExists(rc, "id") ? rc.id : rc.field_office_id ); 
                
        ls.new = variables.fomService.getNewFieldOfficeDetails(rc);        
        ls.current = variables.fomService.getFieldOfficeDetails( rc ); 
        ls.new["alt"] = variables.fomService.getDiffs( ls.new, ls.current );       
        
		variables.fw.renderData( "json", ls.new ); 
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateEdit
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function validateEdit( rc ) {       
        var ls = {};
        ls.retval = {};
         
        ls.user_id = Session.user.user_id; 
        ls.username = Session.user.username; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        //ls.office_id should be equal to rc.field_office_id     
        
        ls.retval["result"] = variables.fomService.validateEdit( ls.user_id, ls.office_id, ls.username ).result; 
        
        variables.fw.renderData( "json", ls.retval );
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function rejectEdit
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function rejectEdit( rc ) {       
        var ls = {};
        ls.retval = {};
         
        ls.user_id = Session.user.user_id; 
        ls.username = Session.user.username; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        //ls.office_id should be equal to rc.field_office_id     
        
        ls.retval["result"] = variables.fomService.rejectEdit( ls.user_id, ls.office_id, ls.username ).result; 
        
        variables.fw.renderData( "json", ls.retval );
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function requestValidate
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function requestValidate( rc ) {       
        var ls = {};
        ls.retval = {};
         
        ls.user_id = Session.user.user_id; 
        ls.username = Session.user.username; 
        ls.office_id = Session.user.settings.current_field_office_id;
        //ls.office_id should be equal to rc.field_office_id
        
        ls.retval["result"] = variables.fomService.requestValidate( ls.user_id, ls.office_id, ls.username ).result; 
        
        variables.fw.renderData( "json", ls.retval);
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function discardChanges
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function discardChanges( rc ) {       
        var ls = {};
        ls.retval = {};
         
        ls.user_id = Session.user.user_id; 
        ls.username = Session.user.username; 
        ls.office_id = Session.user.settings.current_field_office_id;
        //ls.office_id should be equal to rc.field_office_id
        
        ls.retval["result"] = variables.fomService.discardChanges( ls.user_id, ls.office_id ).result; 
        
        variables.fw.renderData( "json", ls.retval);
	}         
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function charts
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function charts( rc ) {       
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "fom/charts" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function roles
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function roles( rc ) {       
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "fom/roles" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
	}         
                  
    
}    