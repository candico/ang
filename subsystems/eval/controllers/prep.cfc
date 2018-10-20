component accessors="true" {    
   
    property evalService;
    property prepService;
    property prepDao;
    property commonDao;
    
	public any function setFramework( fw ) { variables.fw = fw; return this; }
    
	public any function before() {}

	public any function onMissingMethod() {
		local.res = invoke(variables.prepService, arguments.missingMethodName, arguments.missingMethodArguments.rc);
		if (structKeyExists(local, 'res')) variables.fw.renderData("json", local.res);
	}

	public any function after() {}


    public function deleteDocument( rc ) {

        if (arguments.RC.VIEWEDIT eq 'new'){

            lock scope="Session" type="Readonly" Timeout="3" {
                var fileUploadArr = structKeyExists(Session, 'fileUploadArr') ? Duplicate(Session.fileUploadArr) : arrayNew(1);
            }
            
            ArrayDeleteAt(fileUploadArr, arguments.RC.id);

            lock scope="Session" type="Exclusive" Timeout="3" {
                Session.fileUploadArr = duplicate(fileUploadArr);
            }

            var res = arrayNew(1);

            for (i=1;i<=arrayLen(fileUploadArr);i++) {
                var lc = structNew();
                lc.DOC_ID = i;
                lc.EVAL_ID = 'new';
                lc.USER_ID = request.session.user.user_id;
                lc.FILENAME = fileUploadArr[i].uploadRes.CLIENTFILE;
                res[i] = lc;
            }
            variables.fw.renderData("json", res);            
            
        } else {
            var res = variables.prepDao.deleteDocument(argumentcollection = arguments.rc);
            variables.fw.renderData("json", getCommonDao().QueryToArray(res));            
        }
    }

    public function uploadDocument( rc ) {
        var fileUploadStruct = structNew();
        fileUploadStruct.uploadRes = fileUpload(getTempDirectory(), 'file', "", "makeUnique", false);
        fileUploadStruct.binaryFile = FileReadBinary(fileUploadStruct.uploadRes.serverdirectory & "/" & fileUploadStruct.uploadRes.serverFile);
        fileDelete(fileUploadStruct.uploadRes.serverdirectory & "/" & fileUploadStruct.uploadRes.serverFile);

        if (arguments.RC.VIEWEDIT eq 'new'){

            lock scope="Session" type="Readonly" Timeout="3" {
                var fileUploadArr = structKeyExists(Session, 'fileUploadArr') ? Duplicate(Session.fileUploadArr) : arrayNew(1);
            }
            
            arrayAppend(fileUploadArr, fileUploadStruct);

            lock scope="Session" type="Exclusive" Timeout="3" {
                Session.fileUploadArr = duplicate(fileUploadArr);
            }

            var res = arrayNew(1);

            for (i=1;i<=arrayLen(fileUploadArr);i++) {
                var lc = structNew();
                lc.DOC_ID = i;
                lc.EVAL_ID = 'new';
                lc.USER_ID = request.session.user.user_id;
                lc.FILENAME = fileUploadArr[i].uploadRes.CLIENTFILE;
                res[i] = lc;
            }
            variables.fw.renderData("json", res);
        } else {
            var res = variables.prepDao.uploadDocument(uploadRes=fileUploadStruct.uploadRes, binaryFile=fileUploadStruct.binaryFile, rc=arguments.rc);
            variables.fw.renderData("json", getCommonDao().QueryToArray(res));
        }
        
        
    }
    
    public function getPrepData( rc ) {
        var res = variables.prepDao.getPrepData( argumentcollection = arguments.rc );
        variables.fw.renderData("json", res);
    }


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    public function checkUserPriv(required string priv, required numeric user_id, required numeric office_id, numeric eval_id){    
    	var ls = {};
	    ls.chk = "N";         
        
        if( StructKeyExists(Arguments, "eval_id") )
	    	ls.chk = variables.evalService.checkUserPriv(priv, user_id, office_id, eval_id);   
		else  
	        ls.chk = variables.evalService.checkUserPriv(priv, user_id, office_id);            
    
	    return ls.chk;
    }   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// CRUD functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function set
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function set( rc ) {     
	    var ls = {};     
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "prep/setPrep" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}         
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewPrep
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewPrep( rc ) {     
	    var ls = {};  
       
		ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id ); 
       
        rc.chkViewEvaluation = checkUserPriv("viewEvaluation", ls.user_id, ls.office_id, ls.eval_id);
        if(rc.chkViewEvaluation == "N"){
        	throw("illegalViewAccessException");
		} 
        
        rc.chkRequestAuthorization = checkUserPriv("requestAuthorization", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkDeleteEvaluation = checkUserPriv("deleteEvaluation", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkAuthorizePreparation = checkUserPriv("authorizePreparation", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkEditPreparation = checkUserPriv("editPreparation", ls.user_id, ls.office_id, ls.eval_id);        
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "prep/viewPrep" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editPrep
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editPrep( rc ) {     
	    var ls = {};  
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "prep/editPrep" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}     
    
  
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deletePrep
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function deletePrep( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
        
        ls.retval = variables.prepService.deletePrep(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);  
        
        variables.fw.renderData("json", ls.retval);        
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function requestVal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function requestVal( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage; 
    	
		ls.retval = variables.prepService.requestVal(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);    
        
        variables.fw.renderData("json", ls.retval);
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function acceptVal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function acceptVal( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
    	
		ls.retval = variables.prepService.acceptVal(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);        
        
        variables.fw.renderData("json", ls.retval);
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function rejectVal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function rejectVal( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
    	
		ls.retval = variables.prepService.rejectVal(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);        
        
        variables.fw.renderData("json", ls.retval);
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// DATA functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getEvalGridData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getEvalGridData( rc ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.user_id = Session.user.user_id;        
        ls.office_id = ( structKeyExists(rc, "id") ? rc.id : rc.office_id );      
        ls.lang_code = Session.user.settings.displayLanguage;           
                
        ls.retval = variables.evalService.getEvalGridData(ls.user_id, ls.office_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUsersByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getUsersByEval( rc ) { 
		var ls = {};         
        
        ls.user_id = Session.user.user_id;
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );                 
                
        ls.retval = variables.evalService.getUsersByEval(ls.user_id, ls.office_id, ls.eval_id);        
        
        variables.fw.renderData("json", ls.retval);
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getEvalData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getEvalTypes( rc ) {
		variables.fw.renderData("json", variables.evalService.getEvalTypes( argumentcollection = arguments.rc ) );
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPhasesByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getPhasesByEval( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;  
        ls.office_id = Session.user.settings.current_field_office_id;      
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage;            
                
        ls.retval = variables.evalService.getPhasesByEval(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDocumentsByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getDocumentsByEval( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;  
        ls.office_id = Session.user.settings.current_field_office_id;       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage;             
                
        ls.retval = variables.evalService.getDocumentsByEval(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPrepComments
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function getPrepComments( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id;        
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );
        
        ls.retval = variables.evalService.getPrepComments(ls.user_id, ls.office_id, ls.eval_id);  
        
        variables.fw.renderData("json", ls.retval);        
	}   
 
}    