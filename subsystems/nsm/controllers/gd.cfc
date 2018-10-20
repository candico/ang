component accessors="true" {

    property ncommonService;
    property nsmService; 
    property gdService;  
    
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
      
		ls.chk = variables.gdService.checkUserPriv( priv, user_id, office_id, staff_member_id );            
    
	    return ls.chk;
    }  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getGD
// GD for General Data (personal data, marital status, languages, etc.)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getGD( rc ) {   	  
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  
        
		ls.chk_view = checkUserPriv("view_gd", ls.user_id, ls.office_id, ls.staff_member_id);        
        if(ls.chk_view == "N"){
        	throw("GD: getGD: IllegalDataAccessException");
		}  
        
        ls.chk_view_alt = ( checkUserPriv("view_alt_gd", ls.user_id, ls.office_id, ls.staff_member_id) == "Y" ) ? true : false;    
                
        ls.result = variables.gdService.getGD(ls.user_id, ls.office_id, ls.staff_member_id, ls.chk_view_alt);              
                
        variables.fw.renderData("json", ls.result); 	
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function mainGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function mainGD( rc ) {     
	    var ls = {};
        
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "gd/mainGD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewGD( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  
        
        rc.chk_view_gd = checkUserPriv("view_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_gd = checkUserPriv("edit_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_start = checkUserPriv("wf_start", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_accept = checkUserPriv("wf_accept", ls.user_id, ls.office_id, ls.staff_member_id);
		rc.chk_wf_reject = checkUserPriv("wf_reject", ls.user_id, ls.office_id, ls.staff_member_id);    
        ls.workflowStatus = variables.nsmService.getWorkflowStatus(ls.user_id, ls.office_id, ls.staff_member_id);

       	rc.chk_wf_started = "N";
        if(ls.workflowStatus != "")
	        rc.chk_wf_started = "Y";
            
		rc.chk_wf = "N";
        if( rc.chk_wf_started == "Y" && ( rc.chk_edit_gd == "Y" || rc.chk_wf_accept == "Y" || rc.chk_wf_reject == "Y" ) )
	        rc.chk_wf = "Y";        
        
        if(rc.chk_view_gd == "N"){
        	throw("GD: viewGD: illegalViewAccessException");
		}            
        
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "gd/viewGD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}          
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editGD( rc ) {     
	    var ls = {};  
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
		ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
        
        rc.chk_view_gd = checkUserPriv("view_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_gd = checkUserPriv("edit_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_gd == "N"){
        	throw("GD: editGD: IllegalViewAccessException");
		}  
        if(rc.chk_edit_gd == "N"){
        	throw("GD: editGD: IllegalEditAccessException");
		}   
                
        rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input   
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "gd/editGD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveGD( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  
        ls.username = Session.user.username;         
        
        rc.chk_view_gd = checkUserPriv("view_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_gd = checkUserPriv("edit_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_gd == "N"){
        	throw("GD: saveGD: IllegalViewAccessException");
		}  
        if(rc.chk_edit_gd == "N"){
        	throw("GD: saveGD: IllegalEditAccessException");
		}   
                      
       ls.result = Variables.gdService.saveGD( ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id, ls.username, rc );        
        
		Variables.fw.renderData("json", ls.result); 
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addMedical
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addMedical( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );          
        
        rc.chk_edit_gd = checkUserPriv("edit_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_edit_gd == "N"){
        	throw("GD: addMedical: IllegalEditAccessException");
		}  
                      
        ls.data = Variables.gdService.addMedical( ls.user_id, ls.office_id, ls.staff_member_id, rc ).data;         
        
        variables.fw.renderData("json", ls.data); 
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addBankAccount
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addBankAccount( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );          
        
        rc.chk_edit_gd = checkUserPriv("edit_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_edit_gd == "N"){
        	throw("GD: addBankAccount: IllegalEditAccessException");
		}  
                      
        ls.data = Variables.gdService.addBankAccount( ls.user_id, ls.office_id, ls.staff_member_id, rc ).data;         
        
        variables.fw.renderData("json", ls.data); 
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deleteMedical
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function deleteMedical( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );       
        
        rc.chk_edit_gd = checkUserPriv("edit_gd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_edit_gd == "N"){
        	throw("GD: deleteMedical: IllegalEditAccessException");
		}          
            
        ls.medical_id = rc.medical_id; 
                      
        ls.result = Variables.gdService.deleteMedical( ls.user_id, ls.office_id, ls.medical_id );        
        
        variables.fw.renderData("json", ls.result); 
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function openDocFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function openDocFile( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );        
        
		rc.chk_view_gd = checkUserPriv("view_gd", ls.user_id, ls.office_id, ls.staff_member_id);  
		if(rc.chk_view_gd == "N"){
        	throw("GD: openDocFile: IllegalViewAccessException");
		}          
        
        //appropriate document will be opened according to rc.docType
        ls.data = Variables.gdService.getDocFile( ls.user_id, ls.office_id, ls.staff_member_id, rc ).data; 
        
        rc.fileData = ls.data.fileData;
        rc.mimeType = ls.data.mimeType;        
        rc.fileName = ls.data.fileName;    
        
        variables.fw.redirect(action=':common.openFile', preserve='all');	
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function openMedFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function openMedFile( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );        
        
		rc.chk_view_gd = checkUserPriv("view_gd", ls.user_id, ls.office_id, ls.staff_member_id);  
		if(rc.chk_view_gd == "N"){
        	throw("GD: openMedFile: IllegalViewAccessException");
		} 
        
        ls.medical_id = ( structKeyExists(rc, "id") ? rc.id : rc.medical_id ); 
        ls.data = Variables.gdService.getMedFile( ls.user_id, ls.office_id, ls.medical_id, rc ).data; 
        
        rc.fileData = ls.data.fileData;
        rc.mimeType = ls.data.mimeType;        
        rc.fileName = ls.data.fileName;           

        variables.fw.redirect(action=':common.openFile', preserve='all');
	}                       
    
}    