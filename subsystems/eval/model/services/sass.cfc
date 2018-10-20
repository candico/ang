component accessors="true" {

    property evalDao; 
    property sassDao; 
    property commonDao;
    
	public function onMissingMethod() {
		local.res = invoke(variables.sassDao, arguments.missingMethodName, arguments.missingMethodArguments);
		return variables.commonDao.QueryToArray( local.res );
	}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public string function checkUserPriv(required string priv, required numeric user_id, required numeric office_id, numeric eval_id){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
            case("viewSass"): 
            	ls.chk = Variables.evalDao.chkViewEvaluation(user_id, office_id, eval_id); 
                break;  
            default: 
            	ls.chk = "N";
        } 
        
		return ls.chk;
	}   

}