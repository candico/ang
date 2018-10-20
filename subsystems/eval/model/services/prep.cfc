component accessors="true" {

    property evalDao; 
    property prepDao; 
    property commonDao;

	public any function onMissingMethod() {
        local.res = invoke(variables.prepDao, arguments.missingMethodName, arguments.missingMethodArguments);
		return variables.commonDao.QueryToArray( local.res );
	}
    


    public function savePrep(){

        var res = variables.prepDao.savePrep(argumentcollection = arguments);
        
        if (arguments.viewEdit eq 'new'){

            lock scope="Session" type="Readonly" Timeout="3" {
                var fileUploadArr = structKeyExists(Session, 'fileUploadArr') ? Duplicate(Session.fileUploadArr) : arrayNew(1);
            }
            
            ArrayEach(fileUploadArr,function(file){
                variables.prepDao.uploadDocument(uploadRes=file.uploadRes, binaryFile=structKeyExists(file, 'binaryFile') ? file.binaryFile : JavaCast("null", 0), rc={EVALID: res.ID[1]});
            });

            lock scope="Session" type="Exclusive" Timeout="3" {
               if (structKeyExists(Session, 'fileUploadArr')) {
                   structDelete(Session, 'fileUploadArr');
               }
            }

        }

        if (isStruct(res)) return res;
        else return getCommonDao().QueryToArray( res );
    }

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function validate
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

    public struct function validate(required numeric user_id, required any del_user_id, required numeric eval_id, required numeric office_id, required string lang_code, required struct rc){
	    var ls = {}; 
        
        ls.user_id = user_id;
        ls.del_user_id = del_user_id;
		ls.eval_id = eval_id;   
        ls.office_id = office_id;        
        ls.lang_code = lang_code;
        ls.rc = rc;   
        
        ls.retval = {};   
        ls.errors = [];       
        ls.aborts = [];
        ls.empties = [];    
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Mandatory Participants
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
        
        ls.mandatoryParticipantsFieldNames = ["evaluee_id", "supervisor_id", "contributor_1_id", "preparator_id", "authorizer_id"];               
        
		for(ls.fieldName in ls.mandatoryParticipantsFieldNames){   
            if(!StructKeyExists(rc, ls.fieldName)) {
                ArrayAppend(ls.errors, {"fieldName":ls.fieldName, "value":"[missing]"});
            }
            else if(rc[ls.fieldName] == ""){
                ArrayAppend(ls.empties, {"fieldName":ls.fieldName, "value":""});
            } 
           /* else if( !isValid("regex", rc[ls.fieldName], "\d{2}/\d{2}/\d{4}") ){
                ArrayAppend(ls.aborts, {"fieldName":ls.fieldName, "value":rc[ls.fieldName]});
            } */
        }
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Optional Participants
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
        
        ls.optionalParticipantsFieldNames = ["contributor_2_id", "contributor_3_id"]; 
        
		for(ls.fieldName in ls.optionalParticipantsFieldNames){  
           /* if( !isValid("regex", rc[ls.fieldName], "\d{2}/\d{2}/\d{4}") ){
                ArrayAppend(ls.aborts, {"fieldName":ls.fieldName, "value":rc[ls.fieldName]});
            } */
        } 
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Evaluation Type
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
        
    	if( !StructKeyExists(rc, "type_id") ) {
        	ArrayAppend(ls.errors, {"fieldName":"type_id", "value":"[missing]"});
        }
        else if(rc.type_id == ""){
			ArrayAppend(ls.empties, {"fieldName":"type_id", "value":""});
        }        
        else if( !isValid("integer", rc.type_id) ){
        	ArrayAppend(ls.aborts, {"fieldName":"type_id", "value":rc.type_id});
        }  
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Periods (two-field definition)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
        
        ls.dateFieldNames = ["eval_start_on", "eval_end_on", "prep_phase_start_on", "prep_phase_end_on", "assess_phase_start_on", "assess_phase_end_on", "rating_phase_start_on", "rating_phase_end_on","closing_phase_start_on", "closing_phase_end_on", "probation_phase_start_on", "probation_phase_end_on"];        
        
        for(ls.fieldName in ls.dateFieldNames){   
            if(!StructKeyExists(rc, ls.fieldName)) {
                ArrayAppend(ls.errors, {"fieldName":ls.fieldName, "value":"[missing]"});
            }
            else if(rc[ls.fieldName] == ""){
                ArrayAppend(ls.empties, {"fieldName":ls.fieldName, "value":"[empty]"});
            } 
            else if( !isValid("regex", rc[ls.fieldName], "\d{2}/\d{2}/\d{4}") ){
                ArrayAppend(ls.aborts, {"fieldName":ls.fieldName, "value":rc[ls.fieldName]});
            } 
        }  
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Periods (one-field definition)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

        ls.periodFieldNames = ["eval_period", "prep_period", "assess_period", "rating_period","closing_period", "probation_period"];  
        
        for(ls.fieldName in ls.periodFieldNames){ 
        	if( StructKeyExists(rc, ls.fieldName)) { 
                if( !isValid("regex", rc[ls.fieldName], "^\d{2}/\d{2}/\d{4} \d{2}/\d{2}/\d{4}$") ){
                    ArrayAppend(ls.errors, {"fieldName":ls.fieldName, "value":rc[ls.fieldName]});
                } 
            }
       	}  
               
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Global result of validation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
                   
		if(ArrayLen(ls.errors) == 0 && ArrayLen(ls.aborts) == 0 && ArrayLen(ls.empties) == 0){
        	ls.status_code = "VALID";
         	ls.retval.status_code = ls.status_code;          
        } else {
	        ls.status_code = "INVALID";
        	ls.retval.status_code = ls.status_code;    
            if(ArrayLen(ls.errors) != 0)       
	            ls.retval.errors = ls.errors;
            if(ArrayLen(ls.aborts) != 0)  
	            ls.retval.aborts = ls.aborts;
			if(ArrayLen(ls.empties) != 0)  
	            ls.retval.empties = ls.empties;                
        }	
        
        //update status
        Variables.prepDao.updEvalStatus(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.status_code); 
        	
		return ls.retval;  
    }   

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function savePrep
// type of del_user_id set to any to simplify arguments passing (is numeric but when non-existent passed as an empty string)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
/*	public struct function savePrep(required numeric user_id, required any del_user_id, required numeric eval_id, required numeric office_id, required string lang_code, required struct rc){
    	var ls = {};       
        
        ls.user_id = user_id;
        ls.del_user_id = del_user_id;
		ls.eval_id = eval_id;   
        ls.office_id = office_id;        
        ls.lang_code = lang_code;
        ls.rc = Duplicate(rc);       
        ls.calls = [];   
        
        ls.currentRoles = {};
        ls.currentPhases = {};
        
        ls.isNewEvaluation = false;
        ls.evaluationUpdated = false;
        ls.rolesUpdated = false;
        ls.phasesUpdated = false;
        ls.fileUpload = false;

        ls.uploadFieldName = "XFILE";
                
        ls.actions = {}; 
        ls.actions["rolesToCreate"] = [];
        ls.actions["rolesToUpdate"] = [];  
        ls.actions["rolesToDelete"] = [];      
        ls.actions["phasesToCreate"] = [];
        ls.actions["phasesToUpdate"] = [];  
        ls.actions["phasesToDelete"] = [];    
        ls.actions["evalDataToUpdate"] = [];   
        
// =-=-=-=-=-=-=-=-=-=-=
// Validation
// =-=-=-=-=-=-=-=-=-=-=          
        
         ls.isValid = validate(ls.user_id, ls.del_user_id, ls.eval_id, ls.office_id, ls.lang_code, ls.rc);
         ls.status_code = ls.isValid.status_code;
         
// =-=-=-=-=-=-=-=-=-=-=
// Switch 2-field <> 1-field periods
// =-=-=-=-=-=-=-=-=-=-=      

   		if(StructKeyExists(ls.rc, "eval_period") ){ 
        	if( REFind("^(\d{2}/\d{2}/\d{4}) (\d{2}/\d{2}/\d{4})$", ls.rc["eval_period"] ) ){
				ls.ref = REFind("^(\d{2}/\d{2}/\d{4}) (\d{2}/\d{2}/\d{4})$", ls.rc["eval_period"], 1, true );
    	        //ls.rc["EVAL_START_ON"] = ls.ref["MATCH"][2];
                ls.rc["EVAL_START_ON"] = Mid(ls.rc["eval_period"], ls.ref.pos[2], ls.ref.len[2]);
        	    //ls.rc["EVAL_END_ON"] = ls.ref["MATCH"][3]; 
                ls.rc["EVAL_END_ON"] = Mid(ls.rc["eval_period"], ls.ref.pos[3], ls.ref.len[3]);
			}                
            //WriteDump(ls.rc);
            //throw("no good");
            //abort;
        }
        
// =-=-=-=-=-=-=-=-=-=-=
// Evaluation
// =-=-=-=-=-=-=-=-=-=-=   
        
        ls.current_evaluation = Variables.evalDao.getEvalDataQry(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code); 
        
        if( ls.eval_id == 0){ 
	        ls.eval_id = Variables.prepDao.insEvalQry(ls.user_id, ls.del_user_id, ls.office_id, 'INVALID');
            ls.log_id = Variables.prepDao.insLoggedEvalStatusQry(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, 'INVALID', '');
            ls.current_eval_start_on = "";
	        ls.current_eval_end_on = "";
            ls.current_type_id = "";
            ls.isNewEvaluation = true;
            ArrayAppend(ls.actions.evalDataToUpdate, {eval_id:ls.eval_id, field:"eval_id", old_val:"", new_val:ls.eval_id} ); 
        } else {         	
	        ls.current_eval_start_on = ls.current_evaluation.start_on;
    	    ls.current_eval_end_on = ls.current_evaluation.end_on;
            ls.current_type_id = ls.current_evaluation.type_id;
		}           
        
        if(ls.isNewEvaluation || ls.rc["EVAL_START_ON"] != ls.current_eval_start_on || ls.rc["EVAL_END_ON"] != ls.current_eval_end_on || ls.rc["TYPE_ID"] != ls.current_type_id){
	        ls.evaluationUpdated = true;
            ls.eval_start_on = ls.rc["EVAL_START_ON"];
            ls.eval_end_on = ls.rc["EVAL_END_ON"];
            ls.type_id = ls.rc["TYPE_ID"];
            
            ArrayAppend(ls.actions.evalDataToUpdate,
            {eval_id:ls.eval_id, old_start_on:ls.current_eval_start_on, 
            new_start_on:ls.rc["EVAL_START_ON"], old_end_on:ls.current_eval_end_on, new_end_on:ls.rc["EVAL_END_ON"], 
            old_type_id:ls.current_type_id, new_type_id:ls.type_id});           
        }      
        
        if(ls.evaluationUpdated == true && !StructKeyExists(ls.isValid,"aborts") ) {        	
            ls.call = {};
            ls.call.func = "updEval";
            ls.call.args = {user_id:ls.user_id, del_user_id:ls.del_user_id, office_id:ls.office_id, eval_id:ls.eval_id, start_on:ls.eval_start_on, end_on: ls.eval_end_on, type_id:ls.type_id};
            ArrayAppend(ls.calls, ls.call);          
        }
        
// =-=-=-=-=-=-=-=-=-=-=
// Roles
// If we do not receive an explicit PREPARATOR_ID, assign current user
// =-=-=-=-=-=-=-=-=-=-=      
        
        ls.roles = ["EVALUEE_ID", "CONTRIBUTOR_1_ID", "CONTRIBUTOR_2_ID", "CONTRIBUTOR_3_ID", "SUPERVISOR_ID", "PREPARATOR_ID", "AUTHORIZER_ID"]; //!!!hardcoded        
        
        //get the current roles
        ls.currentRolesQry = Variables.evalDao.getUsersByEvalQry(ls.user_id, ls.office_id, ls.eval_id);
        for(ls.row in ls.currentRolesQry){
        	ls.currentRoles[ls.row.role_pos_id] = ls.row.user_id; 
        }        
        
        for (ls.role in ls.roles){        
            if( StructKeyExists(ls.currentRoles, ls.role) ){            
                if( rc[ls.role] != "" && rc[ls.role] != ls.currentRoles[ls.role] ){ //update
                	ls.new_participant_id = rc[ls.role];
                    if(ls.new_participant_id == "")
                    	ls.new_participant_id = 0;                    	
                    ArrayAppend( ls.actions.rolesToUpdate, {role:ls.role, old_participant_id:ls.currentRoles[ls.role], new_participant_id:ls.new_participant_id} ); 
                } else if( rc[ls.role] == "" && rc[ls.role] != ls.currentRoles[ls.role] ) { //delete
                    ls.new_participant_id = rc[ls.role];
                    if(ls.new_participant_id == "")
                    	ls.new_participant_id = 0;                    	
                    ArrayAppend( ls.actions.rolesToDelete, {role:ls.role, old_participant_id:ls.currentRoles[ls.role], new_participant_id:ls.new_participant_id} );                    
                }                 
            }
            else if( rc[ls.role] != "" ){
	            ls.new_participant_id = rc[ls.role];
                ArrayAppend(ls.actions.rolesToCreate, {role:ls.role, new_participant_id:ls.new_participant_id} );
            }              
        }       
        
        if( rc["preparator_id"] == "") {
			ArrayAppend(ls.actions.rolesToCreate, {role:"preparator_id", new_participant_id:user_id} ); //preparator always required
        }                          
        
        if( ArrayLen(ls.actions.rolesToCreate) > 0 || ArrayLen(ls.actions.rolesToUpdate) || ArrayLen(ls.actions.rolesToDelete) ){
        	ls.rolesUpdated = true;
        }  
        
	    if( ls.rolesUpdated && !StructKeyExists(ls.isValid,"aborts") ) {
        
            for(ls.item in ls.actions.rolesToDelete) {	            
                ls.rcp = getRoleCodesAndPos(ls.item.role);
                ls.item.role_code = ls.rcp.role_code;
                ls.item.pos = ls.rcp.pos;  
                ls.call = {};
				ls.call.func = "delRoleQry";
	            ls.call.args = {user_id:ls.user_id, del_user_id:ls.del_user_id, office_id:ls.office_id, eval_id:ls.eval_id, role_code:ls.item.role_code, pos:ls.item.pos, participant_id:ls.item.new_participant_id};
    	        ArrayAppend(ls.calls, ls.call);  
            }  
                   
            for(ls.item in ls.actions.rolesToUpdate) {	            
                ls.rcp = getRoleCodesAndPos(ls.item.role);
                ls.item.role_code = ls.rcp.role_code;
                ls.item.pos = ls.rcp.pos;  
                ls.call = {};
				ls.call.func = "updRoleQry";
	            ls.call.args = {user_id:ls.user_id, del_user_id:ls.del_user_id, office_id:ls.office_id, eval_id:ls.eval_id, role_code:ls.item.role_code, pos:ls.item.pos, participant_id:ls.item.new_participant_id};
    	        ArrayAppend(ls.calls, ls.call);                
            }  
            
			for(ls.item in ls.actions.rolesToCreate) {	            
                ls.rcp = getRoleCodesAndPos(ls.item.role);
                ls.item.role_code = ls.rcp.role_code;
                ls.item.pos = ls.rcp.pos;  
                ls.call = {};
				ls.call.func = "insRoleQry";
	            ls.call.args = {user_id:ls.user_id, del_user_id:ls.del_user_id, office_id:ls.office_id, eval_id:ls.eval_id, role_code:ls.item.role_code, pos:ls.item.pos, participant_id:ls.item.new_participant_id, status_code:'VALID'};
    	        ArrayAppend(ls.calls, ls.call);                 
            }                          	
        }          
        
// =-=-=-=-=-=-=-=-=-=-=
// Phases
// =-=-=-=-=-=-=-=-=-=-= 
                
        ls.phase_codes = ["PREP_PHASE","ASSESS_PHASE","RATING_PHASE","CLOSING_PHASE","PROBATION_PHASE"]; //!!!hardcoded        
        
        ls.currentPhasesQry = Variables.evalDao.getPhasesByEvalQry(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);
        for(ls.row in ls.currentPhasesQry){
        	ls.currentPhases[ls.row.phase_code]["START_ON"] = ls.row.start_on; 
            ls.currentPhases[ls.row.phase_code]["END_ON"] = ls.row.end_on; 
        }    
        
        for (ls.phase_code in ls.phase_codes){        
            if( StructKeyExists(ls.currentPhases, ls.phase_code) ){
                if( rc["#ls.phase_code#_START_ON"] != ls.currentPhases[ls.phase_code]["START_ON"] || rc["#ls.phase_code#_END_ON"] != ls.currentPhases[ls.phase_code]["END_ON"]){
                    ArrayAppend( ls.actions.phasesToUpdate, 
                    {
                    	phase_code:ls.phase_code, 
                        old_start_on:ls.currentPhases[ls.phase_code]["START_ON"], 
                        new_start_on:rc["#ls.phase_code#_START_ON"],
                        old_end_on:ls.currentPhases[ls.phase_code]["END_ON"], 
                        new_end_on:rc["#ls.phase_code#_END_ON"]
                    } ); 
                }
            }
            else if( rc["#ls.phase_code#_START_ON"] != "" || rc["#ls.phase_code#_END_ON"] != ""){  
                ArrayAppend( ls.actions.phasesToCreate, {phase_code:ls.phase_code, start_on:rc["#ls.phase_code#_START_ON"], end_on:rc["#ls.phase_code#_END_ON"]} );   
            }   
        }                             
        
        if( ArrayLen(ls.actions.phasesToCreate) > 0 || ArrayLen(ls.actions.phasesToUpdate) ){
        	ls.phasesUpdated = true;
        }         
        
	    if( ls.phasesUpdated && !StructKeyExists(ls.isValid,"aborts") ) {    
            
			for(ls.item in ls.actions.phasesToUpdate) {
				ls.call = {};
				ls.call.func = "updPhaseQry";
	            ls.call.args = {user_id:ls.user_id, del_user_id:ls.del_user_id, office_id:ls.office_id, eval_id:ls.eval_id, phase_code:ls.item.phase_code, start_on:ls.item.new_start_on, end_on:ls.item.new_end_on};
    	        ArrayAppend(ls.calls, ls.call);                
            }              
            
			for(ls.item in ls.actions.phasesToCreate) {
				ls.call = {};                
                ls.call.func = "insPhaseQry";
	            ls.call.args = {user_id:ls.user_id, del_user_id:ls.del_user_id, office_id:ls.office_id, eval_id:ls.eval_id, phase_code:ls.item.phase_code, start_on:ls.item.start_on, end_on:ls.item.end_on, status_code:"VALID"};
    	        ArrayAppend(ls.calls, ls.call);                
            }              	
        }      
        
// =-=-=-=-=-=-=-=-=-=-=
// File upload
// =-=-=-=-=-=-=-=-=-=-=         

        if( StructKeyExists(rc, "xfile") && rc.xfile NEQ "" && !StructKeyExists(ls.isValid,"aborts") ) {       
	        ls.fileUpload = true;
            ls.actions["fileToUpload"] = ""; 
			ls.call = {};            
            ls.call.func = "insFile";   
			ls.call.args = {user_id:ls.user_id, del_user_id:ls.del_user_id, eval_id:ls.eval_id, rc:rc};
			ArrayAppend(ls.calls, ls.call); 
        } 
        
// =-=-=-=-=-=-=-=-=-=-=
// Ececute in single transaction
// =-=-=-=-=-=-=-=-=-=-=   		
        
		ls.retvals = Variables.prepDao.transactQry(ls.calls);

// =-=-=-=-=-=-=-=-=-=-=
// Set return value
// =-=-=-=-=-=-=-=-=-=-= 
            
		ls.retval["actions"] = ls.actions;   
        ls.retval["result"] = "";   
        ls.retval["status_code"] = ls.status_code;
        ls.retval["evaluation_id"] = ls.eval_id;
        ls.retval["retvals"] = ls.retvals;
        
        if(ls.status_code == "INVALID" && StructKeyExists(ls.isValid,"errors"))
        	ls.retval["errors"] = ls.isValid.errors;
		if(ls.status_code == "INVALID" && StructKeyExists(ls.isValid,"aborts"))
        	ls.retval["aborts"] = ls.isValid.aborts;   
		if(ls.status_code == "INVALID" && StructKeyExists(ls.isValid,"empties"))
        	ls.retval["empties"] = ls.isValid.empties;  
        
        if( StructKeyExists(ls.isValid,"aborts") ){
	        ls.retval["result"] &= "<br>All updates aborted";
        } else {
            if(ls.evaluationUpdated)
                ls.retval["result"] &= "<br>Evaluation updated";
            if(ls.rolesUpdated)
                ls.retval["result"] &= "<br>Participants updated";   
            if(ls.phasesUpdated)
                ls.retval["result"] &= "<br>Phases updated";     
            if(ls.fileUpload)
                ls.retval["result"] &= "<br>File uploaded";          
            
            if(!ls.evaluationUpdated && !ls.rolesUpdated && !ls.phasesUpdated && !ls.fileUpload)
                ls.retval["result"] = "<br>Nothing to save";
		}          
        
		return ls.retval;
	} 
*/
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function getRoleCodeAndPos
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
    public struct function getRoleCodesAndPos(role)  {
    
        var ls = {};
        ls.retval = {};
        ls.retval.pos = 1;
        
        switch(role){
            case("EVALUEE_ID"):
                ls.retval.role_code = "EVM_EVALUEE";
                break;
            case("SUPERVISOR_ID"):
                ls.retval.role_code = "EVM_SUPERVISOR";    
                break;
            case("PREPARATOR_ID"):
                ls.retval.role_code = "EVM_PREPARATOR";   
                break;
            case("AUTHORIZER_ID"):
                ls.retval.role_code = "EVM_AUTHORIZER";
                break;
            case("CONTRIBUTOR_1_ID"):
                ls.retval.role_code = "EVM_CONTRIBUTOR";
                break;
            case("CONTRIBUTOR_2_ID"):
                ls.retval.role_code = "EVM_CONTRIBUTOR";  
                ls.retval.pos = 2;   
                break;
            case("CONTRIBUTOR_3_ID"):
                ls.retval.role_code = "EVM_CONTRIBUTOR";  
                ls.retval.pos = 3;  
                break;
        }
        
        return ls.retval;  
	}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function requestVal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
    public struct function requestVal(required numeric user_id, required any del_user_id, required numeric office_id, required numeric eval_id, required string lang_code, required struct rc)  {
    
	    var ls = {};       
        
        //add priv check        
        ls.status_code = 'PREP_AUTH_PENDING';    
		ls.action = Variables.prepDao.logStatus(user_id, del_user_id, office_id, eval_id, ls.status_code, rc.comments);       
        
        if(ls.action.result == "OK")
    		ls.retval["result"] = "OK";  
		else
			ls.retval["result"] = "NOK";           
            
		return ls.retval;            
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function acceptVal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
    public struct function acceptVal(required numeric user_id, required any del_user_id, required numeric office_id, required numeric eval_id, required string lang_code, required struct rc)  {
    
	    var ls = {};       
        
        //add priv check        
        ls.status_code = 'PREP_AUTH_ACCEPTED';    
		ls.action1 = Variables.prepDao.logStatus(user_id, del_user_id, office_id, eval_id, ls.status_code, rc.comments); 
        ls.status_code = 'ACTIVE';    
		ls.action2 = Variables.prepDao.logStatus(user_id, del_user_id, office_id, eval_id, ls.status_code, ''); 
        
        if(ls.action1.result == "OK" && ls.action2.result == "OK")
	        ls.retval["result"] = "OK";
		else        
	        ls.retval["result"] = "NOK";    
        
        return ls.retval;  
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function rejectVal
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
    public struct function rejectVal(required numeric user_id, required any del_user_id, required numeric office_id, required numeric eval_id, required string lang_code, required struct rc)  {
    
	    var ls = {};       
        
        //add priv check        
        ls.status_code = 'PREP_AUTH_REJECTED';    
		ls.action1 = Variables.prepDao.logStatus(user_id, del_user_id, office_id, eval_id, ls.status_code, rc.comments); 
		ls.status_code = 'VALID';    
		ls.action2 = Variables.prepDao.logStatus(user_id, del_user_id, office_id, eval_id, ls.status_code, '');         
        
        if(ls.action1.result == "OK" && ls.action2.result == "OK")
	        ls.retval["result"] = "OK";
		else        
	        ls.retval["result"] = "NOK";  
        
        return ls.retval;  
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function deletePrep
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public struct function deletePrep(required numeric user_id, required any del_user_id, required numeric office_id, required numeric eval_id, required string lang_code, rc){
    	var ls = {};	
        
		ls.status_code = 'DELETED';    
		ls.comments = ( structKeyExists(rc, "comments") ? rc.comments : "" ); 
		ls.retval = Variables.prepDao.logStatus(user_id, del_user_id, office_id, eval_id, ls.status_code, ls.comments); 
        
		return ls.retval;
	}           
    
}    