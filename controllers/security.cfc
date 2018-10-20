component accessors="true" {

    property beanFactory;  
    property commonService;
    property formatterService;
    property securityService;
    
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
	    setting showdebugoutput="no";     	
	}	    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function login
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     
    
	public void function login(err) {    	  
        if( StructKeyExists(Arguments, "err") )
        	rc.err = err;  
            
        variables.fw.setView("security.grid");
		//matching template automatically called by framework            
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateLogin
// called from the local login screen (whether in local or any other environment)
// Sets Session.user
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     
    
	public void function validateLogin( rc ) {
    	var ls = {};   
        ls.retval["status"] = -1;        

		//Session["displayLanguage"] = 'EN';  
        
        setSessionVar("displayLanguage", "EN");
        
        lock scope="Session" type="Readonly" timeout="3" { 
        	ls.session = Duplicate(Session);
        }
        
        if(StructKeyExists(ls.session, "ecasuser")){
        	//user is local login user        	
			ls.chk_user = variables.securityService.validateUsername( rc.username );
            if(ls.chk_user.status == "OK") {
            	ls["user"] = variables.securityService.getUserData( rc.username ).user; 
                //del_user is ecasuser if different from login user
                if( ls.session.ecasuser.domainusername != rc.username) {
	                ls.del_user = variables.securityService.getUserData( ls.session.ecasuser.domainusername ).user;             
    	            ls.user["del_user_id"] = ls.del_user.user_id;
        	        ls.user["del_user_fname"] = ls.del_user.fname;   
            	    ls.user["del_user_lname"] = ls.del_user.lname;  
                    ls.retval.status = 1;  
				} else {
	                ls.user["del_user_id"] = "";
    	    	    ls.user["del_user_fname"] = "";   
    		        ls.user["del_user_lname"] = "";                
                    ls.retval.status = 2;  
                }  
                //Session["user"] = ls.user;   
                setSessionVar("user", ls.user);   
                //ls.retval.status = 1;                           
            }  
            else {
            	ls.retval["error"] = "Ecas session user '#ls.session.ecasuser.domainusername#' exists. Log As user '#rc.username#' was not found";
            } 
        }
        else {
	        //user is local login user; no del_user            
			ls.chk_user = variables.securityService.validateUsername( rc.username );
            if(ls.chk_user.status == "OK") {
            
            	ls["user"] = variables.securityService.getUserData( rc.username ).user; 
                ls.user["del_user_id"] = "";
        	    ls.user["del_user_fname"] = "";   
    	        ls.user["del_user_lname"] = "";  
                
                //Session["user"] = ls.user; 
                setSessionVar("user", ls.user);  
	            ls.retval.status = 4;                   
            } 
            else {
            	ls.retval["error"] = "No Ecas session. Log As user '#rc.username#' not found";
            }                           
        }          
       //writeDump(ls); abort;
        //redirect to Main page done on client-side 
		Variables.fw.renderData("json", ls.retval); 
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setSessionVar
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public void function setSessionVar( string varName, any var ) { 
    
	    lock scope="Session" type="Exclusive" timeout="3" { 
        	Session[varName] = duplicate(arguments.var);
        }
    
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function default
// called after access through ECAS
// Sets Session.user
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     
    
	public void function default( rc ) {
    	var ls = {};          
        ls.retval = {};    
        
        //Session["displayLanguage"]= 'EN';          
        setSessionVar("displayLanguage", "EN");        
        
		ls.chk_user = variables.securityService.validateUsername( session.ecasuser.domainusername ); 
		if(ls.chk_user.status == "OK") {
            ls["user"] = variables.securityService.getUserData( session.ecasuser.domainusername ).user; 
            ls.user["del_user_id"] = "";
            ls.user["del_user_fname"] = "";   
            ls.user["del_user_lname"] = "";  
            
            //Session["user"] = ls.user;    
            setSessionVar("user", ls.user); 
            ls.retval.status = 1;                             
        }  
        else {
            throw("illegalAccessException1");
        }              
		
        variables.fw.redirect(action='main.default');
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRolesByUser
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     
    
	public void function getRolesByUser() {    	  
    	var ls = {};        
    
        ls.retval = variables.securityService.getRolesByUser();   
            
		Variables.fw.renderData("json", ls.retval);           
	}
    
}    