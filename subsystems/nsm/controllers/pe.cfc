component accessors="true" {
    
    property nsmService; 
    property peService;  
    
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
      
		ls.chk = variables.peService.checkUserPriv( priv, user_id, office_id, staff_member_id );            
    
	    return ls.chk;
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPE
// PE for Professional Experiences
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getPE( rc ) {   	  
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;  
 		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        
        rc.chk_view = checkUserPriv("view_pe", ls.user_id, ls.office_id, ls.staff_member_id);        
        if(rc.chk_view == "N"){
        	throw("PE: getPE: IllegalDataAccessException");
		}   
        
		ls.chk_view_alt = ( checkUserPriv("view_alt_pe", ls.user_id, ls.office_id, ls.staff_member_id) == "Y" ) ? true : false;                
        
        ls.result = variables.peService.getPE(ls.staff_member_id, ls.chk_view_alt); 
                
        variables.fw.renderData("json", ls.result); 	
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function mainPE
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function mainPE( rc ) {     
	    var ls = {};                
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "pe/mainPE" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewPE
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewPE( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input         
        
        rc.chk_view_pe = checkUserPriv("view_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_pe = checkUserPriv("edit_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_start = checkUserPriv("wf_start", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_accept = checkUserPriv("wf_accept", ls.user_id, ls.office_id, ls.staff_member_id);
		rc.chk_wf_reject = checkUserPriv("wf_reject", ls.user_id, ls.office_id, ls.staff_member_id);
        
        if(rc.chk_view_pe == "N"){
        	throw("PE: viewPE: illegalViewAccessException");
		}
        
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "pe/viewPE" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editPE
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editPE( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input 
        
        rc.chk_view_pe = checkUserPriv("view_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_pe = checkUserPriv("edit_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_pe == "N"){
        	throw("PE: editPE: IllegalViewAccessException");
		}  
        if(rc.chk_edit_pe == "N"){
        	throw("PE: editPE: IllegalEditAccessException");
		}          
        
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "pe/editPE" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function savePE
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function savePE( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        ls.username = Session.user.username; 
        
        rc.chk_view_pe = checkUserPriv("view_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_pe = checkUserPriv("edit_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_pe == "N"){
        	throw("PE: savePE: IllegalViewAccessException");
		}  
        if(rc.chk_edit_pe == "N"){
        	throw("PE: savePE: IllegalEditAccessException");
		}          
                  
        ls.result = Variables.peService.savePE( ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id, ls.username, rc );        
        
        Variables.fw.renderData("json", ls.result); 
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addExperience
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addExperience( rc ) {     
	    var ls = {};          
                      
        ls.data = Variables.peService.addExperience().data;         
        
        variables.fw.renderData("json", ls.data); 
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deleteExperience
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function deleteExperience( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        ls.username = Session.user.username;
        
        rc.chk_view_pe = checkUserPriv("view_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_pe = checkUserPriv("edit_pe", ls.user_id, ls.office_id, ls.staff_member_id);
        
        if(rc.chk_view_pe == "N"){
        	throw("PE: deleteExperience : IllegalViewAccessException");
		}  
        
        if(rc.chk_edit_pe == "N"){
        	throw("PE: deleteExperience : IllegalEditAccessException");
		}          
            
        ls.experience_id = ( structKeyExists(rc, "id") ? rc.id : rc.medical_id ); 
                      
        ls.result = Variables.peService.deleteExperience( ls.experience_id );        
        
        variables.fw.renderData("json", ls.result); 
	}                  
    
}    