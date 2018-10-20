component accessors="true" {
    
    property nsmService; 
    property edService;  
    
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
      
		ls.chk = variables.edService.checkUserPriv( priv, user_id, office_id, staff_member_id );            
    
	    return ls.chk;
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getED
// ED for Education(s)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getED( rc ) {   	  
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;  
 		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        
        ls.chk_view = checkUserPriv("view_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        if(ls.chk_view == "N"){
        	throw("ED: getED: IllegalDataAccessException");
		} 
        
        ls.chk_view_alt = ( checkUserPriv("view_alt_ed", ls.user_id, ls.office_id, ls.staff_member_id) == "Y" ) ? true : false;  
        
        ls.result = variables.edService.getED(ls.staff_member_id, ls.chk_view_alt); 
                
        variables.fw.renderData("json", ls.result); 	
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDomains
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getDomains( rc ) {   	  
	    var ls = {};     
        
		param rc.lang_code = "EN"; 
        
        ls.result = variables.edService.getDomains(rc.lang_code); 
                
        variables.fw.renderData("json", ls.result); 	
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function mainED
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function mainED( rc ) {     
	    var ls = {};                
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "ed/mainED" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewED
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewED( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input         
        
        rc.chk_view_ed = checkUserPriv("view_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_ed = checkUserPriv("edit_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_start = checkUserPriv("wf_start", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_accept = checkUserPriv("wf_accept", ls.user_id, ls.office_id, ls.staff_member_id);
		rc.chk_wf_reject = checkUserPriv("wf_reject", ls.user_id, ls.office_id, ls.staff_member_id);
        
        if(rc.chk_view_ed == "N"){
        	throw("ED: viewED: illegalViewAccessException");
		}
        
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "ed/viewED" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editED
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editED( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input 
        
        rc.chk_view_ed = checkUserPriv("view_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_ed = checkUserPriv("edit_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_ed == "N"){
        	throw("ED: editED: IllegalViewAccessException");
		}  
        if(rc.chk_edit_ed == "N"){
        	throw("ED: editED: IllegalEditAccessException");
		}          
        
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "ed/editED" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveED
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveED( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        ls.username = Session.user.username; 
        
        rc.chk_view_ed = checkUserPriv("view_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_ed = checkUserPriv("edit_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_ed == "N"){
        	throw("ED: saveED: IllegalViewAccessException");
		}  
        if(rc.chk_edit_ed == "N"){
        	throw("ED: saveED: IllegalEditAccessException");
		}      
        
        param rc.specialty = ""; 
        param rc.domain_code = "";   
		param rc.less_than_required = "N";             
                  
        ls.result = Variables.edService.saveED( ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id, ls.username, rc );        
        
        Variables.fw.renderData("json", ls.result); 
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addDiploma
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addDiploma( rc ) {     
	    var ls = {};         
        
        ls.levelId = rc.level_id; 
                      
        ls.data = Variables.edService.addDiploma(ls.levelId).data;         
        
        variables.fw.renderData("json", ls.data); 
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deleteDiploma
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function deleteDiploma( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
        ls.username = Session.user.username;
        
        rc.chk_view_ed = checkUserPriv("view_ed", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_ed = checkUserPriv("edit_ed", ls.user_id, ls.office_id, ls.staff_member_id);        
        if(rc.chk_view_ed == "N"){
        	throw("ED: deleteDiploma : IllegalViewAccessException");
		}  
        
        if(rc.chk_edit_ed == "N"){
        	throw("ED: deleteDiploma : IllegalEditAccessException");
		}          
            
        ls.diploma_id = ( structKeyExists(rc, "id") ? rc.id : rc.diploma_id ); 
                      
        ls.result = Variables.edService.deleteDiploma( ls.diploma_id );        
        
        variables.fw.renderData("json", ls.result); 
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function openDiplomaFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function openDiplomaFile( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        //ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );        
        
	/*	rc.chk_view_ed = checkUserPriv("view_ed", ls.user_id, ls.office_id, ls.staff_member_id);  
		if(rc.chk_view_ed == "N"){
        	throw("ED: openDocFile: IllegalViewAccessException");
		} */
        
        //ls.data = Variables.edService.getDiplomaFile( ls.user_id, ls.office_id, ls.staff_member_id, rc ).data;  
        
        rc.fileData = ls.data.fileData;
        rc.mimeType = ls.data.mimeType;        
        rc.fileName = ls.data.fileName;           	
        
        variables.fw.redirect(action=':common.openFile', preserve='all');         
        
        //ls.viewData = variables.fw.view( "ed/file" ); 
		//variables.fw.renderData().data( ls.viewData ).type( "html" );          
	}                          
    
}    