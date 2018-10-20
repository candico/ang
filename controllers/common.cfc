component accessors="true" {  

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
	}	
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCountries
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getCountries( rc ) {    
		var ls = {}; 
        
        param rc.lang = Session.user.settings.displayLanguage;
        
        ls.lang = ( ListFind("EN,FR", rc.lang) ? rc.lang : Session.user.settings.displayLanguage );
        
        //lock scope="Application" type="Readonly" timeout="3" { 
	        ls.result = duplicate(Application[ls.lang]["COUNTRIES"]);
		//}            
        
        variables.fw.renderData("json", ls.result); 		
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCitizenships
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getCitizenships( rc ) {    
		var ls = {}; 
        
        param rc.lang = Session.user.settings.displayLanguage;
        
        ls.lang = ( ListFind("EN,FR", rc.lang) ? rc.lang : Session.user.settings.displayLanguage );
        
        //lock scope="Application" type="readOnly" timeout="3" { 
	        ls.result = duplicate(Application[ls.lang]["CITIZENSHIPS"]);
		//}            
        
        variables.fw.renderData("json", ls.result); 		
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getStrings
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function getStrings( rc ) {    
		var ls = {}; 
        ls.res = {};
		arguments.rc.lang = request.session.user.settings.displayLanguage;

        if( StructKeyExists(rc, "lang") && StructKeyExists(rc, "dom") ){
        	if( ListFind("EN,FR", rc.lang) && ListFind("SHARED,PI,FD,EVM,FOM,NSM", UCase(rc.dom)) ){
				//lock scope="Application" type="readOnly" timeout="3" {
					ls.res = duplicate(Application[rc.lang]["STRINGS"]["FSM"][rc.dom]);
				//}
            }
        }
        
        variables.fw.renderData("json", ls.res);      
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function document
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function document( rc ) {    
		var ls = {};     
        
        rc.doc_id = ( structKeyExists(rc, "id") ? rc.id : rc.doc_id );            
         
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function openFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function openFile(fileName, fileData, mimeType){   
	    var ls = {}; 
               
        ls.viewData = variables.fw.view( "common/file" ); 
		variables.fw.renderData().data( ls.viewData ).type( "html" );                 
		
	}          
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMessage
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function sendMessage(recipients, subject, body){   
	    var ls = {}; 
        
     	ls.result = Variables.commonService.sendMailMessage(recipients, subject, body); 
        
         variables.fw.renderData("json", ls.result); 
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMessages
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function sendMessages(){   
	    var ls = {}; 
        
     	ls.result = Variables.commonService.sendMailMessages(); 
        
         variables.fw.renderData("json", ls.result); 
	}             
    
}    