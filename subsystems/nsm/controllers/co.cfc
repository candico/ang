component accessors="true" {
    
    property nsmService; 
    property coService;  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function init
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}	
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Built-in Function before
// Called before execution of any other function in this controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function before( rc ) {
	    setting showdebugoutput = "No";     	  	
	}	    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    public function checkUserPriv( required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id ){    	
    	var ls = {};
	    ls.chk = "N";    
      
		ls.chk = variables.coService.checkUserPriv( priv, user_id, office_id, staff_member_id );            
    
	    return ls.chk;
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCO
// CO for Contracts
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getCO( rc ) {   	  
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;  
 		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        
        rc.chk_view_co = checkUserPriv("view_co", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_co == "N"){
        	throw("CO: getCO: IllegalDataAccessException");
		}   
        
        ls.view_alt = ( checkUserPriv("view_alt_co", ls.user_id, ls.office_id, ls.staff_member_id) == "Y" ) ? true : false;    
        
        ls.result = variables.coService.getCO(ls.user_id, ls.office_id, ls.staff_member_id, ls.view_alt); 
                
        variables.fw.renderData("json", ls.result); 	
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function mainCO
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function mainCO( rc ) {     
	    var ls = {};                
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "co/mainCO" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewCO
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewCO( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input         
        
        rc.chk_view_co = checkUserPriv("view_co", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_co = checkUserPriv("edit_co", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_start = checkUserPriv("wf_start", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_accept = checkUserPriv("wf_accept", ls.user_id, ls.office_id, ls.staff_member_id);
		rc.chk_wf_reject = checkUserPriv("wf_reject", ls.user_id, ls.office_id, ls.staff_member_id);
        
        if(rc.chk_view_co == "N"){
        	throw("CO: viewCO: illegalViewAccessException");
		}
        
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "co/viewCO" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editCO
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editCO( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input         
        
        rc.chk_view_co = checkUserPriv("view_co", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_co = checkUserPriv("edit_co", ls.user_id, ls.office_id, ls.staff_member_id);
        
        if(rc.chk_edit_co == "N"){
        	throw("CO: editCO: illegalViewAccessException");
		}
        
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "co/editCO" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveCO
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveCO( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );          

        rc.chk_edit_co = checkUserPriv("edit_co", ls.user_id, ls.office_id, ls.staff_member_id);             
        if(rc.chk_edit_co == "N"){
        	throw("CO: saveCO: IllegalEditAccessException");
		}  
        
        ls.del_user_id = Session.user.del_user_id;                
        ls.username = Session.user.username;  
        rc.staff_member_id = ls.staff_member_id;        

        ls.result = Variables.coService.saveCO( ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id, ls.username, rc );  
           
        variables.fw.renderData().data( ls.result ).type( "json" );
	}                
    
}    