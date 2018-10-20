component accessors="true" {

    property beanFactory;   
    property staffService;    
    property commonService;
    
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

	public function checkUserPrivileges( rc ){    	
		//WriteLog(rc.action, "Information", "Yes", "log_#LSDateFormat(Now(), 'ddmmyy')#");
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function listNSM 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function listNSM( rc ) {     
	    var ls = {}; 
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "staff/listNSM" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getNSMListData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getNSMListData( rc ) { 
		var ls = {};  
        ls.response = {};
        
        ls.office_id = ( structKeyExists(rc, "id") ? rc.id : rc.office_id );   
                
        ls.arr = variables.staffService.getNSMListData(ls.office_id);
        ls.response["data"] = ls.arr;
        
        variables.fw.renderData("json", ls.response);
	} 

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editNSM 
// For now, only edit basic information (future tab 1)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editNSM( rc ) {     
	    var ls = {};         
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );         
        
        ls.staffMember = variables.beanFactory.getBean( "staffMember" );        
        variables.fw.populate( ls.staffMember );
        //rc.staffMemberBasicsStruct = ls.staffMember.getUpdatedStaffMemberBasicsStruct( rc );         
        //rc.countriesQuery = variables.commonService.getCountriesQry();          
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "staff/editNSM" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editNSM2
// For now, only edit basic information (future tab 1)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editNSM2( rc ) {     
	    var ls = {};  
        
        //rc.id = 5600;       
       
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );         
        
        ls.staffMember = variables.beanFactory.getBean( "staffMember" );        
        variables.fw.populate( ls.staffMember );
        rc.staffMemberBasicsStruct = ls.staffMember.getStaffMemberBasicsStruct( rc );         
        rc.countriesQuery = variables.commonService.getCountriesQry();          
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "staff/editNSM2" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveEditNSM 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveEditNSM( rc ) {     
	    var ls = {}; 
        
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );          
        
        ls.staffMember = variables.beanFactory.getBean( "staffMember" );        
        ls.authenticatedUser = Session.user.username; 
        //variables.fw.populate( ls.staffMember );                
        ls.result = ls.staffMember.saveStaffMemberBasics( rc, ls.authenticatedUser );  
        
        //variables.fw.renderData("json", ls.result); 
        //deliberately sending an error code
        variables.fw.renderData().data( ls.result ).type( "json" );
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function validateGD( rc ) {     
	    var ls = {}; 
        
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );          
        
        ls.staffMember = variables.beanFactory.getBean( "staffMember" );        
        ls.authenticatedUser = Session.user.username;                        
        ls.result = ls.staffMember.validateGD( rc, ls.authenticatedUser ); 
        
        Sleep(1000);        
    
        variables.fw.renderData().data( ls.result ).type( "json" ).statusCode( 403 );
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveEditFdNSM 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveEditFdNSM( rc ) {     
	    var ls = {}; 
        
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );     
        ls.staff_member_id = rc.staff_member_id;     
        ls.authenticatedUser = Session.user.username; 
        
        ls.familyData = variables.beanFactory.getBean( "nsmFD" );              
        variables.fw.populate(ls.familyData, "staff_member_id, authenticatedUser", false, false, false, {staff_member_id:ls.staff_member_id, authenticatedUser:ls.authenticatedUser} );                
        ls.result = ls.familyData.updateDependents( rc );  
        
        //variables.fw.renderData("json", ls.result); 
        //deliberately sending an error code
        variables.fw.renderData().data( ls.result ).type( "json" );
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function switchLang 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function switchLang( rc ) {     
	    var ls = {}; 
        
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );           
        
        if( Session.user.settings.displayLanguage == 'FR' ) {
	        Session.user.settings.displayLanguage = 'EN';
		} else  {
        	Session.user.settings.displayLanguage = 'FR';
		}          
        
        ls.staffMember = variables.beanFactory.getBean( "staffMember" );        
        variables.fw.populate( ls.staffMember );
        
        rc.staffMemberBasicsStruct = ls.staffMember.getStaffMemberBasicsStruct(rc);         
        rc.countriesQuery = variables.commonService.getCountriesQry();
        
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "staff/editNSM" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }		
       
       	//hard reload
       	variables.fw.setView( "staff.editNSM" );
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function test 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function test( rc ) {     
    
		 //matching view is called automatically
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getStaffMemberBasics 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getStaffMemberBasics( rc ) {   	  
	    var ls = {}; 
        
        rc.staff_member_id = ( structKeyExists(rc, "id") ? rc.id : rc.staff_member_id );  
        ls.staffMember = variables.beanFactory.getBean( "staffMember" ); 
        ls.result = ls.staffMember.getStaffMemberBasicsStruct(rc);      
                
        variables.fw.renderData("json", ls.result); 	
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getStaffMemberBasicsStrings
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getStaffMemberBasicsStrings( rc ) {    
		var ls = {}; 
        
        param rc.lang = Session.user.settings.displayLanguage;
        
        ls.lang = ( ListFind("EN,FR", rc.lang) ? rc.lang : Session.user.settings.displayLanguage ); 
        
        ls.result = Application[ls.lang]["strings"]["FSM"]["GD"];
        
        variables.fw.renderData("json", ls.result); 		
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCountries
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getCountries( rc ) {    
		var ls = {}; 
        
        param rc.lang = Session.user.settings.displayLanguage;
        
        ls.lang = ( ListFind("EN,FR", rc.lang) ? rc.lang : Session.user.settings.displayLanguage );
        
        ls.result = Application[ls.lang]["COUNTRIES"];
        
        variables.fw.renderData("json", ls.result); 		
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function testTabs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function testTabs( rc ) {    
		var ls = {}; 
        
		//matching view is called automatically 
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function testTabs2
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function testTabs2( rc ) {    
		var ls = {}; 
        
		 //matching view is called automatically 	
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function prepareMessages
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function prepareMessages( rc ) {    
		var ls = {}; 
        
		 ls.messages = Variables.staffService.prepareMessages();
         
		 variables.fw.renderData("json", ls.messages);          
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMessages
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function sendMessages( rc ) {    
		var ls = {}; 
        
		 ls.result = Variables.staffService.sendMessages();
         
		 variables.fw.renderData("json", ls.result);          
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMessage
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function sendMessage( rc ) {    
		var ls = {}; 
        
		 ls.result = Variables.staffService.sendMessage();
         
		 variables.fw.renderData("json", ls.result);          
	}      
    
                      
}