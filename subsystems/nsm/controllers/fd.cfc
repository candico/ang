component accessors="true" {     
    
    property nsmService;
	property fdService;   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// UTILITY Functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
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
      
		ls.chk = variables.fdService.checkUserPriv( priv, user_id, office_id, staff_member_id );            
    
	    return ls.chk;
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function getFD( rc ) {     
	    var ls = {}; 
       
        ls.user_id = Session.user.user_id;        
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );         
        
		ls.chk_view = checkUserPriv("view_fd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(ls.chk_view == "N"){
        	throw("FD: getFamilyData: IllegalDataAccessException");
		}          
	    
		ls.chk_view_alt = ( checkUserPriv("view_alt_fd", ls.user_id, ls.office_id, ls.staff_member_id) == "Y" ) ? true : false;                     
 
        ls.data = Variables.fdService.getFD( ls.user_id, ls.office_id, ls.staff_member_id, ls.chk_view_alt ).data;         
        
        variables.fw.renderData("json", ls.data);  	
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function mainFD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function mainFD( rc ) {     
	    var ls = {};
        
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  //stored in hidden form input    
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "fd/mainFD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewFD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewFD( rc ) {     
	    var ls = {};       
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;   
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
        
        rc.chk_view_fd = checkUserPriv("view_fd", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_fd = checkUserPriv("edit_fd", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_start = checkUserPriv("wf_start", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_wf_accept = checkUserPriv("wf_accept", ls.user_id, ls.office_id, ls.staff_member_id);
		rc.chk_wf_reject = checkUserPriv("wf_reject", ls.user_id, ls.office_id, ls.staff_member_id);    
        
        if(rc.chk_view_fd == "N"){
        	throw("FD: viewFD: illegalViewAccessException");
		}   
        
		 rc.staff_member_id = ls.staff_member_id;  //stored in hidden form input               
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "fd/viewFD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editFD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editFD( rc ) {     
	    var ls = {};       
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        //check edit                         
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "fd/editFD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveFD 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveFD( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  
        
        rc.chk_view_fd = checkUserPriv("view_fd", ls.user_id, ls.office_id, ls.staff_member_id);
        rc.chk_edit_fd = checkUserPriv("edit_fd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_view_fd == "N"){
        	throw("FD: editFD: IllegalViewAccessException");
		}  
        if(rc.chk_edit_fd == "N"){
        	throw("FD: editFD: IllegalEditAccessException");
		}  
        
        ls.del_user_id = Session.user.del_user_id;                
        ls.username = Session.user.username;  
        rc.staff_member_id = ls.staff_member_id;        

        ls.result = Variables.fdService.saveFD( ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id, ls.username, rc );  
           
        variables.fw.renderData().data( ls.result ).type( "json" );
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addChild
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addChild( rc ) {     
	    var ls = {};    
                
		ls.data = Variables.fdService.addChild().data;          
		
		variables.fw.renderData("json", ls.data); 
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addSpouse
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addSpouse( rc ) {     
	    var ls = {}; 
        
		ls.data = Variables.fdService.addSpouse(rc.gender).data;  
		
		variables.fw.renderData("json", ls.data); 
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addOtherRelative
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addOtherRelative( rc ) {     
	    var ls = {};            
		  
        ls.data = Variables.fdService.addOtherRelative( rc ).data;  
		
		variables.fw.renderData("json", ls.data); 
	}      
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function removeRelative
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function removeRelative( rc ) {     
	    var ls = {};      
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
        
        rc.chk_edit_fd = checkUserPriv("edit_fd", ls.user_id, ls.office_id, ls.staff_member_id);
        if(rc.chk_edit_fd == "N"){
        	throw("FD: removeRelative: IllegalEditAccessException");
		}     
       
        ls.del_user_id = Session.user.del_user_id; 
        ls.username = Session.user.username;  
        ls.relative_id = rc.relative_id;      
		              
        ls.result = Variables.fdService.removeRelative( ls.user_id, ls.del_user_id, ls.office_id, ls.staff_member_id, ls.relative_id, ls.username );  
		
		variables.fw.renderData("json", ls.result); 
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addCertificate
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addCertificate( rc ) {     
	    var ls = {};            
		  
        ls.data = Variables.fdService.addCertificate( rc ).data;  
		
		variables.fw.renderData("json", ls.data); 
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addScholarship
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addScholarship( rc ) {     
	    var ls = {};            
		  
        ls.data = Variables.fdService.addScholarship( rc ).data;  
		
		variables.fw.renderData("json", ls.data); 
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function openScholarshipFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function openScholarshipFile( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );        
        
		rc.chk_view_fd = checkUserPriv("view_fd", ls.user_id, ls.office_id, ls.staff_member_id);  
		if(rc.chk_view_fd == "N"){
        	throw("FD: openScholarshipFile: IllegalViewAccessException");
		}                 
      
        ls.data = Variables.fdService.getScholarshipFile( ls.user_id, ls.office_id, ls.staff_member_id, rc ).data; 
        
        rc.fileData = ls.data.fileData;
        rc.mimeType = ls.data.mimeType;        
        rc.fileName = ls.data.fileName;           	
        
        variables.fw.redirect(action=':common.openFile', preserve='all');	
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function openCertificateFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function openCertificateFile( rc ) {     
	    var ls = {}; 
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;    
        ls.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );        
        
		rc.chk_view_fd = checkUserPriv("view_fd", ls.user_id, ls.office_id, ls.staff_member_id);  
		if(rc.chk_view_fd == "N"){
        	throw("FD: openCertificateFile: IllegalViewAccessException");
		}                 
      
        ls.data = Variables.fdService.getCertificateFile( ls.user_id, ls.office_id, ls.staff_member_id, rc ).data; 
        
        rc.fileData = ls.data.fileData;
        rc.mimeType = ls.data.mimeType;        
        rc.fileName = ls.data.fileName;           	
        
        variables.fw.redirect(action=':common.openFile', preserve='all');	
	}                          
    
}    