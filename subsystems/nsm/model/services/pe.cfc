Component accessors="true" {  
   
	property nsmDao;
    property edDao;
    property edAltDao;      
    property peDao;
    property peAltDao;   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public string function checkUserPriv(required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
           case("view_pe"):            		
            	ls.chk = Variables.nsmDao.chkViewNsm(user_id, office_id, staff_member_id);   
                break;    
           case("view_alt_pe"):            		
            	ls.chk = Variables.peDao.chkViewAltPe(user_id, office_id, staff_member_id);   
                break;                 
            case("edit_pe"): 
            	ls.chk = Variables.peDao.chkEditPe(user_id, office_id, staff_member_id);                 
                break;                   
            case("wf_start"): 
            	ls.chk = Variables.nsmDao.chkWfStart(user_id, office_id, staff_member_id);  
                break;     
            case("wf_accept"): 
            	ls.chk = Variables.nsmDao.chkWfAccept(user_id, office_id, staff_member_id);   
                break;     
            case("wf_reject"): 
            	ls.chk = Variables.nsmDao.chkWfReject(user_id, office_id, staff_member_id);   
                break;                                          
            default: 
            	ls.chk = "N";
        } 
        
		return ls.chk;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPE
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getPE(required numeric staff_member_id, required boolean view_alt){
    	var ls = {}; 
     
        if(view_alt == true) 
        	ls.retval = getCollatedExperienceData(staff_member_id);  
        else 
	        ls.retval = getExperienceData(staff_member_id); 
                  
            
        return ls.retval;
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getExperienceData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getExperienceData(required numeric staff_member_id){
    	var ls = {};	
        ls.retval = {};         
        
        ls.staffMemberQry = variables.peDao.getStaffMemberQry(staff_member_id); 
        ls.experiencesQry = variables.peDao.getExperiencesQry(staff_member_id); 
        ls.experiences = getExperiences(ls.experiencesQry); 
        
        ls.retval["fg"] = ls.staffMemberQry.FG;
		ls.retval["yearsAsExp"] = getYearsAsExp("main", staff_member_id);         
        ls.retval["experiences"] = ls.experiences;         
        
        return ls.retval;    
	}           
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCollatedExperienceData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getCollatedExperienceData(required numeric staff_member_id){
    	var ls = {};	
        ls.retval = {};            

		ls.staffMemberQry = variables.peDao.getStaffMemberQry(staff_member_id); 
        ls.experiencesQry = variables.peDao.getExperiencesQry(staff_member_id);          
        ls.experiences = getExperiences(ls.experiencesQry); 
        ls.retval["fg"] = ls.staffMemberQry.FG;
        ls.retval["yearsAsExp"] = getYearsAsExp("main", staff_member_id);
        ls.retval["yearsAsExp"] += getYearsAsExp("alt", staff_member_id);          

        ls.altExperiencesQry = variables.peAltDao.getExperiencesQry(staff_member_id); 
        
        if(ls.altExperiencesQry.recordCount != 0){	                 
	        ls.altExperiences = getExperiences(ls.altExperiencesQry);  //this is an array   
                
            //overwrite    
            mainIdx = 0;    
            for(ls.experience in ls.experiences){  
	            mainIdx++;
                ls.id = ls.experience.id;                
                
                //let's try to find an alt version
                ls.found = false;
                for(ls.altExperience in ls.altExperiences){
                	if(ls.altExperience.id == ls.id){
	                    ls.found = true;
                        break;
					}                        
                }
                
                if( ls.found == true ){  
	                 //ls.altExperience set above  
                     
	                if(ls.altExperience.deleted == "Y"){ 
                        ls.experiences[mainIdx] = ls.altExperience;
                        ls.experiences[mainIdx]["status"] = "deleted";                                            
                        continue;
                    }                  
                                        
                    for(ls.item in ls.experience){   
                        if( ls.experience[ls.item] != ls.altExperience[ls.item] ){     
	    		            if( ls.experience[ls.item] == "")
		                    	ls.experience[ls.item] = "[...]";                                            
	                        ls.retval["alt"]["experiences"][ls.id][ls.item] = ls.experience[ls.item];
                            ls.experience[ls.item] = ls.altExperience[ls.item];                            
                        }  
                    } 
                    ls.experience["status"] = "updated";
                } 
            }  
            
			//add new experiences             
           for(ls.altExperience in ls.altExperiences){
	            ls.found = false;
                for(ls.experience in ls.experiences){
                	if(ls.altExperience.id == ls.experience.id){
	                    ls.found = true;
					}                        
                }
                if(ls.found == false){	               
	                ls.altExperience["status"] = "new"; 
                	ArrayAppend(ls.experiences, ls.altExperience);                   
                }
			 }  
		} 
        
        ls.retval["experiences"] = ls.experiences;  
        
        return ls.retval;
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function processChangedItems
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public void function processChangedItems(staffMember, item, altItem, itemsCollectionName) {  
	    var ls = {};
        
        if(altItem.deleted == "Y"){
            staffMember["alt"][itemsCollectionName][ls.id].deleted = ls.item.deleted;
            item.deleted = ls.altItem.deleted; 
            item["status"] = "deleted";
            continue;
        }                   
                                             
        for(ls.field in ls.item){   
            if( item[ls.field] != ls.altItem[ls.field] ){     
                if( ls.item[ls.field] == "")
                    ls.item[ls.field] = "[...]";                                            
                ls.staffMember["alt"][itemsCollectionName][ls.id][ls.field] = ls.item[ls.field];
                ls.item[ls.field] = ls.altItem[ls.field];                            
            }  
        } 
        ls.item["status"] = "updated";            
        
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function processNewItems
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public void function processNewItems(staffMember, items, altItems, itemsCollectionName) {  
	    var ls = {};
        
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getYearsAsExp
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  

	public numeric function getYearsAsExp(required string datasource, required numeric staff_member_id) {        
    	var ls = {};
        
        if(datasource == "main")
	        ls.yearsAsExp = Variables.edDao.getYearsAsExp(staff_member_id);
		else if(datasource == "alt")
            ls.yearsAsExp = Variables.edAltDao.getYearsAsExp(staff_member_id); 
        
        return ls.yearsAsExp;        
	}         
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getExperiences 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public array function getExperiences(required query experiencesQry) {    
       
    	var ls = {};
        ls.experiences = [];  
       
		for(ls.row in experiencesQry){
        	ls.experience = {};
            ls.experience["id"] = ls.row.exp_id;
            ls.experience["country_code"] = ls.row.country_code;
            ls.experience["city"] = ls.row.city;
            ls.experience["org"] = ls.row.org;
            ls.experience["job"] = ls.row.job;
            ls.experience["start_date"] = ls.row.start_date;
            ls.experience["end_date"] = ls.row.end_date;
            ls.experience["exp_is_accepted"] = ls.row.exp_is_accepted;
            ls.experience["working_time_pct"] = ls.row.working_time_pct;
            ls.experience["cert_was_received"] = ls.row.cert_was_received;    
            ls.experience["cert_is_declaration"] = ls.row.cert_is_declaration;
            ls.experience["relevance_pct"] = ls.row.relevance_pct; 
            ls.experience["deleted"] = ls.row.deleted; 
            ls.experience["status"] = "";  
              
            ArrayAppend(ls.experiences, ls.experience);                                                                                                 
        }         
        
        return ls.experiences;  
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getExperience
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getExperience(required string datasource, required numeric experience_id) {        
    	var ls = {};
        ls.experience = {};
        
        if(datasource == "main")
	        ls.qry = Variables.peDao.getExperienceQry(experience_id);
		else if(datasource == "alt")
            ls.qry = Variables.peAltDao.getExperienceQry(experience_id); 
       
		for(ls.row in ls.qry){  //single record expected  
            ls.experience["country_code"] = ls.row.country_code;
            ls.experience["city"] = ls.row.city;
            ls.experience["org"] = ls.row.org;
            ls.experience["job"] = ls.row.job;
            ls.experience["start_date"] = ls.row.start_date;
            ls.experience["end_date"] = ls.row.end_date;
            ls.experience["exp_is_accepted"] = ls.row.exp_is_accepted;
            ls.experience["working_time_pct"] = ls.row.working_time_pct;
            ls.experience["cert_was_received"] = ls.row.cert_was_received;    
            ls.experience["cert_is_declaration"] = ls.row.cert_is_declaration;
            ls.experience["relevance_pct"] = ls.row.relevance_pct;                                                                            
        }  
        
        ls.retval = ls.experience;            
            
  		return ls.retval; 
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addExperience
// This function just returns an empty Experience struct + the new ID
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function addExperience() {     
	    var ls = {}; 
        
		ls.id = Variables.peAltDao.getNewExperienceId(); 
        
        ls["experience"] = {};
        
        ls.experience["id"] = ls.id;
        ls.experience["country_code"] = "";
        ls.experience["city"] = "";
        ls.experience["org"] = "";
        ls.experience["start_date"] = "";
        ls.experience["end_date"] = "";
        ls.experience["exp_is_accepted"] = "Y";
        ls.experience["working_time_pct"] = "100";
        ls.experience["cert_was_received"] = "Y";    
        ls.experience["cert_is_declaration"] = "N";
        ls.experience["relevance_pct"] = "100";   
        ls.experience["deleted"] = "N"; 
        ls.experience["status"] = "";               
        
 		ls.retval.data = ls.experience;
        
        return ls.retval;  
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deleteExperience
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public string function deleteExperience(required numeric experience_id) {     
	    var ls = {};         
        
        ls.result = variables.peDao.deleteExperience(experience_id);  
        
        return ls.result;  
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function savePE
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function savePE( required numeric user_id, required del_user_id, required numeric office_id, required numeric staff_member_id, required string username, required struct rc ){
    	var ls = {};     
        ls.retval = {}; 
        ls.stack = [];	   
        
        ls["experiences"] = {};    
        
        ls.args = {};
        ls.args.username = username; 
        ls.args.staff_member_id = staff_member_id;  
        
        for(ls.item in rc) {        
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
			if( NOT StructKeyExists(ls.experiences, ls.id) ){
            	ls.experiences[ls.id] = {};
                ls.experiences[ls.id].id = ls.id;  
                //These are radio so might not be defined
                ls.experiences[ls.id]["exp_is_accepted"] = "";
                ls.experiences[ls.id]["cert_was_received"] = "";
                ls.experiences[ls.id]["cert_is_declaration"] = "";                               
			}                   
			//ls.label = ListDeleteAt( ls.item, 1, "_");               
            //ls.label = ListDeleteAt( ls.label, ListLen(ls.label, "_"), "_"); 
            ls.label = ListDeleteAt( ls.item, ListLen(ls.item, "_"), "_"); 
			ls.experiences[ls.id][ls.label] = rc[ls.item];  //assign values to db field names                       
        }     
        
        //writeDump(ls.experiences);
        //abort;
        
        ls.calls = processItems(ls.args, ls.experiences);
        ArrayAppend(ls.stack, ls.calls, true);   
        
///////////////////////////////////////////////////////
// Log ststus
///////////////////////////////////////////////////////    

		ls.call = {}; 
        ls.call.func = "insertStatusLog";
        ls.call.args = {user_id:user_id, del_user_id:del_user_id, office_id:office_id, staff_member_id:staff_member_id, log_status_code:"SMM_EDIT_IN_PROGRESS"};
        ArrayAppend(ls.stack, ls.call, true);     
        
///////////////////////////////////////////////////////
// Execute in single transaction
/////////////////////////////////////////////////////// 

		ls.retval = Variables.peAltDao.transactQry(ls.stack);   
        
        return ls.retval;   
	}         
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function oldsavePE
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function oldsavePE( required numeric user_id, required del_user_id, required numeric office_id, required numeric staff_member_id, required string username, required struct rc ){
    	var ls = {};	   
        
        ls.changes = {};    
        ls.changes["changed"] = false;
        ls.changes["changes"] = [];
        ls.calls = [];
        
///////////////////////////////////////////////////////
// any change in experiences?
///////////////////////////////////////////////////////
          
        ls.changes["experiences"] = hasAnyChangeInExperiences(username, staff_member_id, rc);
        
        if(ls.changes.experiences.data.changed == true){ //Is there anything to save?
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "experiences");   
                     
			//Add or update experience in Alt                     
            for(ls.id in ls.changes.experiences.data.changes){
                ls.cnt = Variables.peAltDao.hasExperience(ls.id);
                if(ls.cnt == 0){
                    ls.call = {};
                    ls.call.func = "copyExperience";
                    ls.call.args = {experience_id:ls.id};
                    ArrayAppend(ls.calls, ls.call); 
                }  
            	ls.experience = ls.changes.experiences.data[ls.id];
                ls.call = {};
                ls.call.func = "updateExperience";
                ls.call.args = {username:username, experience_id:ls.id, rc:ls.experience};               
                ArrayAppend(ls.calls, ls.call); 
            }                        
        }   
        
///////////////////////////////////////////////////////
// Execute in single transaction
/////////////////////////////////////////////////////// 

		ls.retval = Variables.peAltDao.transactQry(ls.calls);        
        
        //ls.retval = ls.changes["experiences"];
        
///////////////////////////////////////////////////////
// return
///////////////////////////////////////////////////////         
        
        return ls.retval;         
	}  
            
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInExperiences
// Is there anything to save?
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChangeInExperiences(required string username, required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        ls.retval.data["changed"] = false;    
        ls.retval.data["changes"] = [];  //array of the IDs of changed experiences       
       
        ls["experiences"] = {};  
        ls.fields = {};
        //Those three are radio, so not guaranteed to be present in the submitted fields
        ls.fields["exp_is_accepted"] = true;
        ls.fields["cert_was_received"] = true;
        ls.fields["cert_is_declaration"] = true;                
        ls.regex = "^(\D+)_(\d+)$";  
        
        for(ls.elem in rc){ //extracting experience-related fields (those with a _d+ suffix) and their value
        	if( REFindNoCase(ls.regex, ls.elem) ){  
				ls.ref = REFindNoCase(ls.regex, ls.elem, 1, true);
                ls.field = Mid(ls.elem, ls.ref["POS"][2], ls.ref["LEN"][2]);                
				ls.id = Mid(ls.elem, ls.ref["POS"][3], ls.ref["LEN"][3]); 
                ls.val = rc[ls.elem];
                ls.fields[ls.field] = true;
                ls.experiences[ls.id][LCase(ls.field)] = ls.val; 
            }  	
		}            
        
        for(ls.id in ls.experiences){                   
            ls.experience = ls.experiences[ls.id];
            ls.experience["changed"] = false; 
            ls.experience["changes"] = {};         
        
        	if(ls.id == 0){ //id = 0: new Experience
                ls.retval.data.changed = true; 
                ls.id = Variables.peAltDao.createExperience(username, staff_member_id, 1); 
                ArrayAppend(ls.retval.data.changes, ls.id); 
            }
        
        	ls.qry = Variables.peAltDao.getExperienceQry(ls.id); 
            if(ls.qry.recordCount == 0) {
            	ls.qry = Variables.peDao.getExperienceQry(ls.id);
            }               
            
            //single record expected
            for(ls.field in ls.fields) {	               
                ls.oldval = ls.qry[ls.field];
                if(!StructKeyExists(ls.experience, ls.field)) //For the radio fields
                	ls.experience[ls.field] = "";  
                ls.newval = ls.experience[ls.field];
                
                if(ls.oldval != ls.newval) {       	
                    ls.changedItem = {};
                    ls.changedItem["oldval"] = ls.oldval; 
                    ls.changedItem["newval"] = ls.newval;  
                    ls.experience.changes[LCase(ls.field)] = ls.changedItem;
                    ls.experience.changed = true; 
                    ls.retval.data.changed = true; 
                }              
            }  
            
            if(ls.experience.changed == true)
	            ArrayAppend(ls.retval.data.changes, ls.id); 
            
            ls.retval.data[ls.id] = ls.experience;
        }      
        
        return ls.retval;
	}        
    
///////////////////////////////////////////////////////
// Process items 
///////////////////////////////////////////////////////       

	public array function processItems(required struct args, required struct items) {    
    	var ls = {};
        ls.args = args;
        ls.stack = []; 
        
        for(ls.id in items) {
        	ls.item = items[ls.id];
            ls.args.item = ls.item;   

            ls.isFlaggedForDelete = isItemFlaggedForDelete(ls.item);
            ls.isFlaggedForRestore = isItemFlaggedForRestore(ls.item);	
			ls.hasMainItem = hasMainItem(ls.id);
    	    ls.hasAltItem = hasAltItem(ls.id);             	 
            
			if( ls.isFlaggedForDelete == true){
            	ls.calls = discardItem(ls.id, ls.args, ls.hasMainItem, ls.hasAltItem);	
                ArrayAppend(ls.stack, ls.calls, true);
                continue;
			}               
            
			if( ls.isFlaggedForRestore == true ){
            	ls.calls = restoreItem(ls.id, ls.args, ls.hasMainItem, ls.hasAltItem);	
                if(!ArrayIsEmpty(ls.calls)) { 
	                ArrayAppend(ls.stack, ls.calls, true);  
                    continue; 
				}                    
			}   
            
			if( ls.hasAltItem == false && ls.hasMainItem == false ){ //new item
            	ls.calls = createAndUpdateItem(ls.id, ls.args);	
                ArrayAppend(ls.stack, ls.calls, true);                   
                continue;                     
			}                         
            
			if( ls.hasAltItem == false ){ //create alt if rc different from main
            	ls.s1 = ls.item;
                ls.s2 = getItem("main", ls.id);
        		ls.structsAreDifferent = structsAreDifferent(ls.s1, ls.s2);
                if( ls.structsAreDifferent == true ) {
                    ls.calls = copyAndUpdateItem(ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);
				} 
                continue;            
			}            		              
			          
			if( ls.hasAltItem == true ){
            	ls.s1 = ls.item;
                
             	//delete alt if new alt same as main record 
                ls.s2 = getItem("main", ls.id);        		
                if( !structsAreDifferent(ls.s1, ls.s2) ) {
                    ls.calls = deleteItem(ls.id);   
                    ArrayAppend(ls.stack, ls.calls, true);  
                    continue;                            
				}                 
                
                //update alt if new alt different from current alt
                ls.s2 = getItem("alt", ls.id);
                if( structsAreDifferent(ls.s1, ls.s2) ) {  
                    ls.calls = updateItem(ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);                   
				}           
			}             
        }  
        
        //writeDump(ls.stack);
        return ls.stack;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasMainItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function hasMainItem(required numeric item_id) {
    	var ls = {};    
        ls.retval = "";
        
        ls.retval = Variables.peDao.hasExperience(item_id);       	
        
		return ls.retval;          
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAltItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function hasAltItem(required numeric item_id) {
    	var ls = {};    
        ls.retval = "";
        
        ls.retval = Variables.peAltDao.hasExperience(item_id);    	
        
		return ls.retval;          
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function structsAreDifferent
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function structsAreDifferent(required struct s1, required struct s2){   
    	var ls = {}; 
        
        //writeDump(s1);
        //writeDump(s2);
    
    	if( StructIsEmpty(s1) && StructIsEmpty(s2) )
        	return false;
            
    	if( StructIsEmpty(s1) || StructIsEmpty(s2) )
        	return true;            
    
    	for(ls.item in s2){
        	if( StructKeyExists(s1, ls.item) ){
            	if( s1[ls.item] != s2[ls.item] ) 
					return true;  			                   
            }
        }
        
        return false;	    
    } 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function isItemFlaggedForDelete
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function isItemFlaggedForDelete(required struct item){
    	var ls = {};   
        
		//writeDump(item);      
        
        if( item.deleted == "Y" )
        	return true;  
        
        return false;	    	    
    } 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function isItemFlaggedForRestore
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function isItemFlaggedForRestore(required struct item){
    	var ls = {};         
        
        if( item.deleted == "R" )
        	return true;  
        
        return false;	    	    
    } 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deleteItem
// This is a physical delete
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function deleteItem(required numeric item_id){   	
      	var ls = {}; 
        ls.calls = []; 
                
        ls.call = {};  
        ls.call.func = "deleteExperience";     
        ls.call.args = {id:item_id};
        ArrayAppend(ls.calls, ls.call);	 
        
		return ls.calls;                       
	}               
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function discardItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function discardItem(required numeric item_id, required struct args, required boolean hasMainItem, required boolean hasAltItem){   	
      	var ls = {}; 
        ls.calls = [];           
        
        if(hasMainItem == false){
        
            ls.call = {};   
            ls.call.func = "deleteExperience"; 
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	 	        
            
        } else {    
        
            ls.call = {}; 
            ls.call.func = "deleteExperience";   
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	        
                
            ls.call = {}; 
            ls.call.func = "copyExperience";
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	     
            
            ls.call = {};  
            ls.call.func = "removeExperience";         
            ls.call.args = {username:args.username, id:item_id};
            ArrayAppend(ls.calls, ls.call);	        
        }      
        
        return ls.calls;	    
    }       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function restoreItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function restoreItem(required numeric item_id, required struct args, required boolean hasMainItem, required boolean hasAltItem){   	
      	var ls = {}; 
        ls.calls = [];    
		        
		if( hasAltItem == true && isAltItemRemoved(item_id) == true){              
            //since alt is a copy of main, let's just delete it
            ls.call = {};    
            ls.call.func = "deleteExperience"; 
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	             
		}     
        
        return ls.calls;
	}          
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function isAltItemRemoved
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function isAltItemRemoved(required numeric item_id){  
    	var ls = {};
        
        ls.retval =  Variables.peAltDao.isExperienceRemoved(item_id);   	   
  
	  return ls.retval;
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function createAndUpdateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function createAndUpdateItem(required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = [];                        
        
        ls.call = {};        
        ls.call.func = "createAndUpdateExperience";
        ls.call.args = {username: args.username, id:item_id, staff_member_id:args.staff_member_id, rc: args.item};
        ArrayAppend(ls.calls, ls.call);	        
                
        return ls.calls;	    
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function copyAndUpdateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function copyAndUpdateItem(required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = []; 
       	ls.call = {}; 
        
        ls.call.func = "copyAndUpdateExperience"; 
        ls.call.args = {username: args.username, id:item_id, rc:args.item};        
        
        ArrayAppend(ls.calls, ls.call);	
                
        return ls.calls;	    
    }          
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function updateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function updateItem(required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = [];      
       
       	ls.call = {};        
		ls.call.func = "updateExperience"; 
		ls.call.args = {username: args.username, id:item_id, rc:args.item};           
        ArrayAppend(ls.calls, ls.call);	
                
        return ls.calls;	    
    }        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getItem(required string datasource, required numeric item_id){
    	var ls = {};                
        ls.retval = {};  
        
        ls.retval = getExperience(datasource, item_id);   
            
  		return ls.retval;
	}      
      
}            
