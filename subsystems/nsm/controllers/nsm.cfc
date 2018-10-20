component accessors="true" {
     
    property nsmService;  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function init
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}	
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Built-in Function before
// Called before execution of any other function in this bean
// Ideal place for security checks or URL parsing
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function before( rc ) {
	    setting showdebugoutput="no";     	  	
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    public function checkUserPriv( required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id ){    	
    	var ls = {};
	    ls.chk = "N";    
      
		ls.chk = variables.nsmService.checkUserPriv( priv, user_id, office_id, staff_member_id );            
    
	    return ls.chk;
    }      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function default
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function default( rc ) {
    	var ls = {};                
       
        variables.fw.redirect( action = 'nsm.grid', queryString = 'jx', append="id,field_office_id");       
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function grid 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function grid( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;
        
        //Need appropriate privilege and must be in an office other than HQ
        rc.canAddStaffMember = checkUserPriv( "add_nsm", ls.user_id, ls.office_id, 0 );
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/grid" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }                 
		
        //else matching view is called automatically
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function tabs
// Displays the 4 tabs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function tabs( rc ) {     
	    var ls = {};    
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;              
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/tabs" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getNSMGridData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getNSMGridData( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;             
                
        ls.arr = variables.nsmService.getNSMGridData(ls.user_id, ls.office_id);
        ls.retval["data"] = ls.arr;
        
        variables.fw.renderData("json", ls.retval);
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getStaffMemberDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getStaffMemberDetails( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;     
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        
		rc.chk_view_nsm = checkUserPriv("view_nsm", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_nsm == "N"){
        	throw("NSM: getStaffMemberDetails: IllegalDataAccessException");
		}                 
                
        ls.staffMemberDetails = variables.nsmService.getStaffMemberDetails(ls.user_id, ls.office_id, ls.staff_member_id);
        ls.retval = ls.staffMemberDetails;
        
        variables.fw.renderData("json", ls.retval);
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getWorklowDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getWorkflowDetails( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;     
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        
		rc.chk_view_nsm = checkUserPriv("view_nsm", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_nsm == "N"){
        	throw("NSM: getStaffMemberDetails: IllegalDataAccessException");
		}                 
                
        ls.workflowDetails = variables.nsmService.getWorkflowDetails(ls.user_id, ls.office_id, ls.staff_member_id);
        ls.retval = ls.workflowDetails;
        
        variables.fw.renderData("json", ls.retval);
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addStaffMember
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function addStaffMember( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;   
        ls.username = Session.user.username;                        
        
		rc.chk_edit_nsm = checkUserPriv("add_nsm", ls.user_id, ls.office_id, 0);
        if(rc.chk_edit_nsm == "N"){
        	throw("NSM: addStaffMember: IllegalEditAccessException");
		}                 
                
        ls.staffMemberDetails = variables.nsmService.addStaffMember(ls.user_id, ls.del_user_id, ls.office_id, ls.username);
        ls.retval = ls.staffMemberDetails;
        
        variables.fw.renderData("json", ls.retval);
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function WF_Start
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function WF_Start( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
		if( !IsNumeric(ls.del_user_id) )
        	ls.del_user_id = 0;
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );             
                
        ls.retval["result"] = variables.nsmService.WF_Start(ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id).result;       
        
        variables.fw.renderData("json", ls.retval);
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function WF_Accept
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function WF_Approve( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
		if( !IsNumeric(ls.del_user_id) )
        	ls.del_user_id = 0; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );         
                
        ls.retval["result"] = variables.nsmService.WF_Accept(ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id).result;       
        
        variables.fw.renderData("json", ls.retval);
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function WF_Reject
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function WF_Reject( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
		if( !IsNumeric(ls.del_user_id) )
        	ls.del_user_id = 0;
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        ls.comments = rc.comments;             
                
        ls.retval["result"] = variables.nsmService.WF_Reject(ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id, ls.comments).result;     
        
        variables.fw.renderData("json", ls.retval);
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUpdatedTabs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getUpdatedTabs( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id;         
        ls.del_user_id = Session.user.del_user_id; 
		if( !IsNumeric(ls.del_user_id) )
        	ls.del_user_id = 0;
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );          
                
        ls.retval = variables.nsmService.getUpdatedTabs(ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id);     
        
        variables.fw.renderData("json", ls.retval);
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewStaffBanner
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function viewStaffBanner( rc ) { 
		var ls = {};  
        ls.retval = {};
        
		if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/staffBanner" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }    
        
        //else matching view is called automatically
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewRejectModal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function viewRejectModal( rc ) { 
		var ls = {};  
        ls.retval = {};
        
		ls.viewData = variables.fw.view( "nsm/rejectModal" );
		variables.fw.renderData().data( ls.viewData ).type( "html" );	
        
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewWorkflowModal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function viewWorkflowModal( rc ) { 
		var ls = {};  
        ls.retval = {};
        
		ls.viewData = variables.fw.view( "nsm/workflowModal" );
		variables.fw.renderData().data( ls.viewData ).type( "html" );	
        
	}                	                        
    
}    