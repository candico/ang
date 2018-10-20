component accessors="true" {

    property beanFactory;   
    property staffService;    
    property commonService;
    property formatterService;
    
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
    	getSesUrlParams( rc );
		checkUserPrivileges( rc );    	
	}	  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getSesUrlParams
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getSesUrlParams( rc ){     
    	var ls = {};   
        
        if (!(StructKeyExists(CGI,"PATH_INFO") && CGI.PATH_INFO != ""))
        	return;
        
        ls.res = REFind("(id)/(\d+)", CGI.PATH_INFO, 1, true);        
        
        if(ls.res.match[1] != "")
        	rc.id = ls.res.match[3];  
            
		return;  
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPrivileges
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function checkUserPrivileges( rc ){    	
		//WriteLog(rc.action, "Information", "Yes", "log_#LSDateFormat(Now(), 'ddmmyy')#");
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function default
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function default( rc ) {
    	var ls = {};
        var instant = variables.beanFactory.getBean( "instant" );
		rc.today = variables.formatterService.longdate( instant.created() );  
       
        //variables.fw.redirect( action = 'nsm.list', queryString = 'jx', append="id,field_office_id");
        variables.fw.redirect( action = 'nsm.grid', queryString = 'jx', append="id,field_office_id");
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "nsm/default" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function grid 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function grid( rc ) {     
	    var ls = {}; 
    	
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
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/tabs" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editGD
// GD for General Data
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editGD( rc ) {     
	    var ls = {};  
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/editGD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editFD
// FD for Family Data
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editFD( rc ) {     
	    var ls = {};                
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/editFD" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editFD2
// FD for Family Data
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editFD2( rc ) {     
	    var ls = {};                
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/editFD2" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addChild
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addChild( rc ) {     
	    var ls = {};                        
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
        ls.staff_member_id = rc.staff_member_id;
        ls.authenticatedUser = Session.user.username; 
        
		ls.familyData = variables.beanFactory.getBean( "nsmFD" );              
        variables.fw.populate(ls.familyData, "staff_member_id, authenticatedUser", false, false, false, {staff_member_id:ls.staff_member_id, authenticatedUser:ls.authenticatedUser} );                
        ls.result = ls.familyData.addChild( rc );  
		
		variables.fw.renderData("json", ls.result); 
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addSpouse
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addSpouse( rc ) {     
	    var ls = {};                        
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
        ls.staff_member_id = rc.staff_member_id;
        ls.authenticatedUser = Session.user.username; 
        
		ls.familyData = variables.beanFactory.getBean( "nsmFD" );              
        variables.fw.populate(ls.familyData, "staff_member_id, authenticatedUser", false, false, false, {staff_member_id:ls.staff_member_id, authenticatedUser:ls.authenticatedUser} );                
        ls.result = ls.familyData.addSpouse( rc );  
		
		variables.fw.renderData("json", ls.result); 
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addOtherRelative
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function addOtherRelative( rc ) {     
	    var ls = {};                        
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
        ls.staff_member_id = rc.staff_member_id;
        ls.authenticatedUser = Session.user.username; 
        
		ls.familyData = variables.beanFactory.getBean( "nsmFD" );              
        variables.fw.populate(ls.familyData, "staff_member_id, authenticatedUser", false, false, false, {staff_member_id:ls.staff_member_id, authenticatedUser:ls.authenticatedUser} );                
        ls.result = ls.familyData.addOtherRelative( rc );  
		
		variables.fw.renderData("json", ls.result); 
	}           
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editPE
// PE for Professional Experience
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editPE( rc ) {     
	    var ls = {};                
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id ); 
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/editPE" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editED
// ED for Education
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editED( rc ) {     
	    var ls = {};                
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "nsm/editED" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}                    
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function ideas
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public function ideas( rc ){    	
    
        if( StructKeyExists(rc, "jx") ) {
            ls.viewData = variables.fw.view( "nsm/ideas" );
            variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFamilyData
// FD for Family Data
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function getFamilyData( rc ) {     
	    var ls = {};  
        ls.response = {}; 
        ls.response["result"] = "OK";              
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );       
        ls.staff_member_id = rc.staff_member_id; 
        ls.authenticatedUser = Session.user.username; 
        
       	ls.nsmFD = variables.beanFactory.getBean( "nsmFD" ); 
        variables.fw.populate(ls.nsmFD, "staff_member_id, authenticatedUser", false, false, false, {staff_member_id:ls.staff_member_id, authenticatedUser:ls.authenticatedUser} ); 
        ls.familyData = ls.nsmFD.getFamilyData().data;         
        
        variables.fw.renderData("json", ls.familyData);  	
	}  
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function removeRelative
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function removeRelative( rc ) {     
	    var ls = {};                        
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );   
        ls.staff_member_id = rc.staff_member_id;
        ls.authenticatedUser = Session.user.username; 
        
		ls.familyData = variables.beanFactory.getBean( "nsmFD" );              
        variables.fw.populate(ls.familyData, "staff_member_id, authenticatedUser", false, false, false, {staff_member_id:ls.staff_member_id, authenticatedUser:ls.authenticatedUser} );                
        ls.result = ls.familyData.removeRelative(ls.authenticatedUser, rc.relative_id );  
		
		variables.fw.renderData("json", ls.result); 
	}     
                  
    
}    