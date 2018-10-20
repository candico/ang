component extends="framework.one" accessors="true" {	
	
    property commonService;
    property loginService;
    
	this.name = "FSM";
    this.version = "0.1";    
    this.sessionManagement = true;  
    this.loginstorage = "Session";
    this.applicationTimeout = createTimeSpan(1,0,0,0);
    this.sessionTimeout = CreateTimespan(0,8,0,0);
    this.datasource = "app_dispo";
    
    variables.framework = structNew();
    variables.framework.reloadApplicationOnEveryRequest = false;

    //This is necessary because the CF Administrator may map the root to another folder
    switch( getEnvironment() ){
    	//case("local"): This.mappings[ "/" ] = "C:\Users\croesev\dev\cfusion\wwwroot";  break;
        case("local.croesev"): 
            This.mappings[ "/" ] = "C:\Users\croesev\dev\cfusion\wwwroot\echo_dispositif\dispo-extranet\FSM\";
            variables.Environment = "dev";
            break;
        case("local.curcilj"): 
            This.mappings[ "/dispo-extranet/FSM/ANG/" ] = getDirectoryFromPath( getCurrentTemplatePath() );
            variables.Environment = "dev";
            break;
        //case("dev"): This.mappings[ "/" ] = "/ec/dev/app/cf_by_apps/ECHO/dispositifs";  //intragate
        case("dev"): 
            //This.mappings["/dispo-extranet/"] = ExpandPath("../");
            This.mappings[ "/dispo-extranet/FSM/ANG/" ] = getDirectoryFromPath( getCurrentTemplatePath() );
            variables.domain = "webgate.development.ec.europa.eu";
            variables.Environment = "dev";
            break; //webgate
        case("acc"):
            This.mappings[ "/dispo-extranet/FSM/ANG/" ] = getDirectoryFromPath( getCurrentTemplatePath() );
            //This.mappings["/dispo-extranet/"] = ExpandPath("../");
            variables.domain = "webgate.acceptance.ec.europa.eu";
            variables.Environment = "acc";
            break;
        case("prod"): 
            This.mappings[ "/dispo-extranet/FSM/ANG/" ] = getDirectoryFromPath( getCurrentTemplatePath() );
            variables.domain = "webgate.ec.europa.eu";
            variables.Environment = "prod";
            break;
		case("local.ec-home"): 
			This.mappings[ "/" ] = "C:\ColdFusion10\cfusion\wwwroot\";  
            variables.Environment = "dev";
			break;
    }
    
    //This.mappings[ "/" ] = "C:\Users\croesev\dev\cfusion\wwwroot";  
    //This.mappings[ "/" ] = "/ec/dev/app/cf_by_apps/ECHO/dispositifs";    
    
    variables.framework.error = "security.error";
    variables.framework.unhandledPaths = '/NSM/tmp';
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// CF or FW1-defined functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    function before () {
        setting showdebugoutput = false;
        var requestStruct = getHttpRequestData();
        if ( requestStruct.method eq 'POST' AND len( requestStruct.content ) AND isJSON( requestStruct.content ) ) { 
            structAppend( FORM , deserializeJSON( requestStruct.content ) );
            structAppend(ARGUMENTS.RC, FORM);
        }
	}

    function setupApplication() {
        
        //lock scope="Application" type="Exclusive" Timeout="3" { // => might not needed since OnApplicationStart lock itself
            //Application.generaldatasource = "app_dispo";
            Application.settings = {};
            Application.settings.dsn = "app_dispo";
            Application.settings.defaultDisplayLanguage = "EN";
            Application.settings.now = Now();
            Application.settings.Environment = variables.Environment;
            
            //will be used to dynamically reset This.mappings[ "/" ] which might already be defined at server level
            Application.rootPath = getDirectoryFromPath( getCurrentTemplatePath() );
        //}

        //NB: simple call to Variables.commonService.getStrings() does not work!
        getBeanFactory().injectProperties("commonService",{}).setAllStrings();  //inject all strings in the Application scope
        getBeanFactory().injectProperties("commonService",{}).setAllCountries(); //inject all countries in the Application scope
        getBeanFactory().injectProperties("commonService",{}).setAllCitizenships(); //inject all citizenships in the Application scope
    }
    
   function setupSession() {
        //lock scope="Application" type="Readonly" Timeout="3" {
        	defaultDisplayLanguage = Duplicate(Application.settings.defaultDisplayLanguage);			 
        //}

	    lock scope="Session" type="Exclusive" timeout="3" { 
        	Session.user.settings["displayLanguage"] = Duplicate(defaultDisplayLanguage);
        }
        
        if(!findNoCase("local", getEnvironment())) {
	        setEcas();          
		}
    }   
            	
	function setupRequest() {
    	//to do: add environment-dependent password
    	//rc is not available, but Request.context is available... why?
        var ls = {};   
        
        //for dev
        URL.pw = "shazam";        
        ls.pw = "shazam";        
        
        rc.startTime = getTickCount();  

        if(!findNoCase("local", getEnvironment())) {
	        Session.ecasuser.authenticate();
		}  
        
        if( isDefined("URL.logout") ) {
        	Variables.loginService.logout(); 
            redirect(action = 'security.login');
		}  
        
        if( isDefined("URL.logAs") ) {
        	Variables.loginService.logout(); 
            redirect(action = 'security.login');
		}          

        if( isDefined("Request.context.reload") && isDefined("URL.pw") && URL.pw == ls.pw) {
            lock scope="Session" type="Exclusive" timeout="3" { structClear(session); }
        	setupApplication();
			setupSession();
		}
        
        authenticateUser();

        if( isDefined("URL.strings") && isDefined("URL.pw") && URL.pw == ls.pw) {
        	Variables.commonService.setAllStrings();                        
		}  
        
        if( isDefined("URL.countries") && isDefined("URL.pw") && URL.pw == ls.pw) {
        	Variables.commonService.setAllCountries();                          
		}   
        
        if( isDefined("URL.citiz") && isDefined("URL.pw") && URL.pw == ls.pw ) {
        	Variables.commonService.setAllCitizenships();                          
        }
        
        lock scope="session" type="readOnly" timeout="10" throwontimeout="yes" {
            request.session = duplicate(session);
        }

        //lock scope="Application" type="readOnly" timeout="10" throwontimeout="yes" {
            request.Application.settings = duplicate(Application.settings);
        //}

	}
        
    public function getEnvironment() {
        //if ( find( "8500", CGI.SERVER_PORT ) || findNoCase( "localhost", CGI.SERVER_NAME ) ) return "local";  
        if ( findNoCase("C:\Users\croesev\", CGI.PATH_TRANSLATED) ) return "local.croesev";  
        if ( findNoCase("C:\PGM\www\ECHO", CGI.PATH_TRANSLATED) ) return "local.curcilj";
		if ( findNoCase("C:\ColdFusion10\cfusion\wwwroot", CGI.PATH_TRANSLATED) ) return "local.ec-home";
        if ( findNoCase( "cf11d0315.cc.cec.eu.int", CGI.SERVER_NAME ) ) return "dev";	          
        if ( findNoCase( "cf11a0313.cc.cec.eu.int", CGI.SERVER_NAME ) ) return "acc";
        if ( findNoCase( "cf11t0315.cc.cec.eu.int", CGI.SERVER_NAME ) ) return "test";
        else return "prod";
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Custom functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   
    
    function authenticateUser(){
    	var ls = {};
        
        ls.fullyQualifiedAction = getFullyQualifiedAction(); //ex: security.login
        //WriteLog(ls.fullyQualifiedAction, "Information", "Yes", "log_#LSDateFormat(Now(), 'ddmmyy')#");
       
        if( ListFind("security.default,security.login,security.validatelogin,security.grid,security.getrolesbyuser", ls.fullyQualifiedAction) ){	       
        	return; //login/Log As in progress
		}  
		
        if( StructKeyExists(Session, "ecasuser") && (!StructKeyExists(Session, "user") || !StructKeyExists(Session.user, "username") || Session.user.username == "") )
        	redirect(action = 'security.default');         
        
        if( !StructKeyExists(Session, "user") || !StructKeyExists(Session.user, "username") || Session.user.username == "")
        	redirect(action = 'security.login');
    }
    
    function setEcas(){		
        if( !isDefined("Session.ecasuser") || isDefined("Request.context.resetSession") ) {                   
            ls.serviceUrl = "https://#variables.domain#/dispo-extranet/";
            ls.obj = createObject("component","components/ecasClient");                                           
            ls.args = {};
            ls.args.serviceUrl = ls.serviceUrl;
            ls.args.requestedGroups = "I*";
            ls.args.userDetails = "true";
            ls.args.debug = "true";
            ls.args.assuranceLevel = "LOW";
            ls.args.ecasBaseUrl = "https://webgate.ec.europa.eu";
            ls.args.ecasLoginUrl = "https://webgate.ec.europa.eu/cas/login";            
            Session.ecasuser = ls.obj;            
            invoke(Session.ecasuser, "init", ls.args);
        }
    }    
    
     
}
