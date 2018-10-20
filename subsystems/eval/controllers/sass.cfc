component accessors="true" {  
   
    property evalService;
    property sassService;
    
	public any function setFramework( fw ) { variables.fw = fw; return this; }
    
	public any function before() {}

	public any function onMissingMethod() {
		local.res = invoke(variables.sassService, arguments.missingMethodName, arguments.missingMethodArguments.rc);
		if (structKeyExists(local, 'res')) variables.fw.renderData("json", local.res);
	}

	public any function after() {}
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    public function checkUserPriv(required string priv, required string user_id, required string office_id, numeric eval_id){    	
    	var ls = {};
	    ls.chk = "N";         
    
	    return ls.chk;
    }   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function set
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function set( rc ) {     
	    var ls = {};  
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "sass/set" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewNS
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function viewNS( rc ) {
    	var ls = {}; 
        
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "sass/viewNS" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }   
        
		//else matching view is called automatically                  
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewTS
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function viewTS( rc ) {
    	var ls = {};  
        
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "sass/viewTS" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }   
        
		//else matching view is called automatically              
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editNS
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function editNS( rc ) {
    	var ls = {}; 

        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "sass/editNS" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }   
        
		//else matching view is called automatically       
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editTS
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function editTS( rc ) {
    	var ls = {}; 
        
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "sass/editTS" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }   
        
		//else matching view is called automatically  
	}     

}    