Component accessors="true" {  
   
	property nsmService;
	property nsmDao;
    property edDao;
    property edAltDao;   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public string function checkUserPriv(required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
           case("view_ed"):            		
            	ls.chk = Variables.nsmDao.chkViewNsm(user_id, office_id, staff_member_id);   
                break;    
           case("view_alt_ed"):            		
            	ls.chk = Variables.edDao.chkViewAltEd(user_id, office_id, staff_member_id);   
                break;                 
            case("edit_ed"): 
            	ls.chk = Variables.edDao.chkEditEd(user_id, office_id, staff_member_id);   
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
// Function getDiplomaData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getDiplomaData(required numeric staff_member_id){
    	var ls = {};	
        ls.retval = {};     
        
		ls.diplomasQry = variables.edDao.getDiplomasQry(staff_member_id);  
        ls.diplomas = getDiplomas(ls.diplomasQry);          
        
        ls.retval["diplomas"] = ls.diplomas;
        return ls.retval;        
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCollatedDiplomaData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getCollatedDiplomaData(required numeric staff_member_id){
    	var ls = {};	
        ls.retval = {};        

		ls.staffMemberQry = variables.edDao.getStaffMemberQry(staff_member_id); 
        ls.diplomasQry = variables.edDao.getDiplomasQry(staff_member_id);  
        ls.diplomas = getDiplomas(ls.diplomasQry);   		                        
        ls.retval["fg"] = ls.staffMemberQry.FG;
        
        ls.altDiplomasQry = variables.edAltDao.getDiplomasQry(staff_member_id); 
        
        if(ls.altDiplomasQry.recordCount != 0){	                  
	        ls.altDiplomas = getDiplomas(ls.altDiplomasQry);  //this is an array   
                
            //overwrite        
            mainIdx = 0;
            for(ls.diploma in ls.diplomas){ 
	            mainIdx++;
                ls.id = ls.diploma.id;                
                
                //let's try to find an alt version
                ls.found = false;
                for(ls.altDiploma in ls.altDiplomas){
                	if(ls.altDiploma.id == ls.id){
	                    ls.found = true;
                        break;
					}                        
                }                
                
                if( ls.found == true ){   
	                //ls.altDiploma set above    
                    
	                if(ls.altDiploma.deleted == "Y"){ 
                        ls.diplomas[mainIdx] = ls.altDiploma;
                        ls.diplomas[mainIdx]["status"] = "deleted";                                            
                        continue;
                    }                                     
                                                             
                    for(ls.item in ls.diploma){   
                        if( ls.diploma[ls.item] != ls.altDiploma[ls.item] ){     
	    		            if( ls.diploma[ls.item] == "")
		                    	ls.diploma[ls.item] = "[...]";                                            
	                        ls.retval["alt"]["diplomas"][ls.id][ls.item] = ls.diploma[ls.item];
                            ls.diploma[ls.item] = ls.altDiploma[ls.item];                            
                        }  
                    } 
                    ls.diploma["status"] = "updated";    
                }                 
            }  
            
			//add new diplomas             
           for(ls.altDiploma in ls.altDiplomas){
	            ls.found = false;
                for(ls.diploma in ls.diplomas){
                	if(ls.altDiploma.id == ls.diploma.id){
	                    ls.found = true;
					}                        
                }
                if(ls.found == false){	          
	                ls.altDiploma["status"] = "new";     
                    ArrayAppend(ls.diplomas, ls.altDiploma);
                }
			 }            
            
		}  
        
        ls.retval["diplomas"] = ls.diplomas;
        return ls.retval;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getED
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getED(required numeric staff_member_id, required boolean view_alt){
    	var ls = {};         
        
        if(view_alt == false)
        	ls.retval = getDiplomaData(staff_member_id);         
        
        if(view_alt == true)
        	ls.retval = getCollatedDiplomaData(staff_member_id);    
            
        return ls.retval;
	}  
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDiplomas
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public array function getDiplomas(required query diplomasQry) {    
       
    	var ls = {};
        ls.diplomas = [];  
       
		for(ls.row in diplomasQry){
        
        	ls.diploma = {};
            ls.diploma["id"] = ls.row.id;
            ls.diploma["city"] = ls.row.city;
            ls.diploma["comments"] = ls.row.comments;            
            ls.diploma["country_code"] = ls.row.country_code;                        
            ls.diploma["diploma"] = ls.row.diploma;                                    
            //ls.diploma["domain_id"] = ls.row.domain_id;   
            ls.diploma["domain_code"] = ls.row.domain_code;               
            //ls.diploma["start_date"] = ls.row.start_date;
            //ls.diploma["end_date"] = ls.row.end_date;
            ls.diploma["establishment"] = ls.row.establishment;
            ls.diploma["less_than_required"] = ls.row.less_than_required;      
            ls.diploma["edu_level_id"] = ls.row.edu_level_id;
            //ls.diploma["edu_level_code"] = ls.row.edu_level_code;
            //ls.diploma["edu_level_name_en"] = ls.row.edu_level_name_en;            
            //ls.diploma["graduated"] = ls.row.graduated;
            ls.diploma["graduation_date"] = ls.row.graduation_date;
            ls.diploma["specialty"] = ls.row.specialty;
            ls.diploma["study_field"] = ls.row.study_field;   
            ls.diploma["nbr_years"] = ls.row.nbr_years;
            ls.diploma["years_as_exp"] = ls.row.years_as_exp;            
            ls.diploma["filename"] = ls.row.upld_name;            
            ls.diploma["mime_type"] = ls.row.upld_mime;
            ls.diploma["upld_hash"] = ls.row.upld_hash; 
            ls.diploma["deleted"] = ls.row.deleted;
              
            ArrayAppend(ls.diplomas, ls.diploma);                                                                                                 
        }         
        
        return ls.diplomas;  
	}               
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDiploma
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getDiploma(required string datasource, required numeric diploma_id) {        
    	var ls = {};
        ls.diploma = {};
        
        if(datasource == "main")
	        ls.qry = Variables.edDao.getDiplomaQry(diploma_id);
		else if(datasource == "alt")
            ls.qry = Variables.edAltDao.getDiplomaQry(diploma_id);   
       
		for(ls.row in ls.qry){  //single record expected          	
            ls.diploma["id"] = ls.row.id;
            ls.diploma["city"] = ls.row.city;
            ls.diploma["comments"] = ls.row.comments;            
            ls.diploma["country_code"] = ls.row.country_code;                        
            ls.diploma["diploma"] = ls.row.diploma;                                    
            ls.diploma["domain_code"] = ls.row.domain_code;              
            //ls.diploma["start_date"] = ls.row.startdate;
            //ls.diploma["end_date"] = ls.row.enddate;
            ls.diploma["establishment"] = ls.row.establishment;
            ls.diploma["less_than_required"] = ls.row.less_than_required;      
            ls.diploma["edu_level_id"] = ls.row.edu_level_id;                   
            //ls.diploma["graduated"] = ls.row.graduated;
            ls.diploma["graduation_date"] = ls.row.graduation_date;
            ls.diploma["specialty"] = ls.row.specialty;
            ls.diploma["study_field"] = ls.row.study_field;   
            ls.diploma["nbr_years"] = ls.row.nbr_years;
            ls.diploma["years_as_exp"] = ls.row.years_as_exp;                       
        }  
        
        ls.retval = ls.diploma;            
            
  		return ls.retval; 
	}          
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addDiploma
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function addDiploma(required numeric levelId) {          
    	var ls = {};
        
        ls.id = Variables.edAltDao.getNewDiplomaId(); 
                
        ls.diploma = {};
        
        ls.diploma["id"] = ls.id;
        ls.diploma["city"] = "";
        ls.diploma["comments"] = "";            
        ls.diploma["country_code"] = "";                        
        ls.diploma["diploma"] = "";                                    
        ls.diploma["domain_code"] = "";  
        ls.diploma["establishment"] = "";
        ls.diploma["less_than_required"] = "N";      
        ls.diploma["edu_level_id"] = levelId; 
        ls.diploma["graduation_date"] = "";
        ls.diploma["specialty"] = "";
        ls.diploma["study_field"] = "";   
        ls.diploma["nbr_years"] = "";
        ls.diploma["years_as_exp"] = "";  
        ls.diploma["deleted"] = "N";          
              
 		ls.retval.data = ls.diploma;
        
        return ls.retval;   
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deleteDiploma
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public string function deleteDiploma(required numeric diploma_id) {     
	    var ls = {};         
        
        ls.result = variables.edDao.deleteDiploma(diploma_id);  
        
        return ls.result;  
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDomains
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public array function getDomains(required string lang_code ) {     
	    var ls = {};          
        ls.domains = [];
              
		ls.qry = variables.edDao.getDomainsQry(lang_code);
        
		for(ls.row in ls.qry){        
        	ls.domain = {};
            ls.domain["id"] = ls.row.id;
            ls.domain["code"] = ls.row.code;
            ls.domain["name"] = ls.row.name;         
         	ArrayAppend(ls.domains, ls.domain);   
		}               
        
        return ls.domains;        
	}            
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function _getDocFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function _getDocFile( required numeric user_id, required numeric office_id, required numeric staff_member_id, required boolean swapMainAlt, required struct rc ) {     
	    var ls = {}; 
        ls.retval = {};        
        ls.retval["status"] = "OK";
        ls.diploma_id = rc.diplomaId;
        
        if(rc.version == "main" && swapMainAlt == false)   
	        ls.qry = Variables.edDao.getDocFileQry(user_id, office_id, staff_member_id, ls.diploma_id);
		if(rc.version == "alt" && swapMainAlt == false) 		
	        ls.qry = Variables.edAltDao.getDocFileQry(user_id, office_id, staff_member_id, ls.diploma_id);
            
        if(rc.version == "main" && swapMainAlt == true)   
	        ls.qry = Variables.edAltDao.getDocFileQry(user_id, office_id, staff_member_id, ls.diploma_id);
		if(rc.version == "alt" && swapMainAlt == true) 		
	        ls.qry = Variables.edDao.getDocFileQry(user_id, office_id, staff_member_id, ls.diploma_id);            
		//else: error     
        
        if(ls.qry.recordCount == 0){
        	ls.retval.status = "NOK";
            return ls.retval;        	
        }       

        ls.data["fileName"] = ls.qry.file_name;  
        ls.data["fileData"] = ls.qry.file_data;
        ls.data["mimeType"] = ls.qry.mime_type;   
        
 		ls.retval["data"] = ls.data;
        
        return ls.retval;  
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDiplomaFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
    
	public struct function getDiplomaFile( required numeric user_id, required numeric office_id, required numeric staff_member_id, required struct rc ) {     
	    var ls = {}; 
        ls.data = {};    
        ls.diploma_id = rc.diplomaId;    
        ls.hash = rc.hash; 
        
        ls.qry = Variables.edAltDao.getDiplomaFileQry(ls.diploma_id, ls.hash);                 

		//single-row result expected
        ls.data["fileName"] = ls.qry.file_name;  
        ls.data["fileData"] = ls.qry.file_data;
        ls.data["mimeType"] = ls.qry.mime_type;                   
        
 		ls.retval["data"] = ls.data;
        
        return ls.retval;  
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveED
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function saveED( required numeric user_id, required del_user_id, required numeric office_id, required numeric staff_member_id, required string username, required struct rc ){
    	var ls = {};     
        ls.retval = {}; 
        ls.stack = [];	            
        
        ls["diplomas"] = {};    
        
        ls.args = {};
        ls.args.username = username; 
        ls.args.staff_member_id = staff_member_id;  
        
        for(ls.item in rc) {        
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
			if( NOT StructKeyExists(ls.diplomas, ls.id) ){
            	ls.diplomas[ls.id] = {};
                ls.diplomas[ls.id].id = ls.id;  
                 //These might not be defined
                ls.diplomas[ls.id]["specialty"] = "";
                ls.diplomas[ls.id]["domain_code"] = "";                
			}                   
			//ls.label = ListDeleteAt( ls.item, 1, "_");               
            //ls.label = ListDeleteAt( ls.label, ListLen(ls.label, "_"), "_"); 
            ls.label = ListDeleteAt( ls.item, ListLen(ls.item, "_"), "_"); 
			ls.diplomas[ls.id][ls.label] = rc[ls.item];  //assign values to db field names                       
        }          
        
        ls.calls = processItems(ls.args, ls.diplomas);
        ArrayAppend(ls.stack, ls.calls, true);   
        
///////////////////////////////////////////////////////
// Log ststus
///////////////////////////////////////////////////////         
        
        ls.call = {}; 
        ls.call.func = "insertStatusLog";
        ls.call.args = {user_id:user_id, del_user_id:del_user_id, office_id:office_id, staff_member_id:staff_member_id, log_status_code:"SMM_EDIT_IN_PROGRESS"};
        
        ls.call = {}; 
        ls.call.func = "deleteStatusLog";
        ls.call.args = {staff_member_id:staff_member_id};        
        
        ArrayAppend(ls.stack, ls.call, true);	        
        
///////////////////////////////////////////////////////
// Execute in single transaction
/////////////////////////////////////////////////////// 	

		ls.retval = Variables.edAltDao.transactQry(ls.stack, staff_member_id);   
        
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
            ls.hasFile = hasFile(ls.id, ls.args);           	 
            
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
                if(ls.hasFile == true){
                    ls.calls = uploadFile(ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);
                }               
                continue;                     
			}                         
            
			if( ls.hasAltItem == false ){ //create alt if rc different from main
            	ls.s1 = ls.item;
                ls.s2 = getItem("main", ls.id);
        		ls.structsAreDifferent = structsAreDifferent(ls.s1, ls.s2);
                if( ls.structsAreDifferent == true || ls.hasFile == true ) {
                    ls.calls = copyAndUpdateItem(ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);
				} 
	            if(ls.hasFile == true){
                    ls.calls = uploadFile(ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);
                }                 
                continue;            
			}            		              
			          
			if( ls.hasAltItem == true ){
            	ls.s1 = ls.item;
                
             	//delete alt if new alt same as main record and no file was uploaded
                ls.s2 = getItem("main", ls.id);        		
                 if( !structsAreDifferent(ls.s1, ls.s2) && !ls.hasFile) {                   
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
				 if( ls.hasFile ) {  
                    ls.calls = uploadFile(ls.id, ls.args);                    
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
        
        ls.retval = Variables.edDao.hasDiploma(item_id);       	
        
		return ls.retval;          
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAltItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function hasAltItem(required numeric item_id) {
    	var ls = {};    
        ls.retval = "";
        
        ls.retval = Variables.edAltDao.hasDiploma(item_id);    	
        
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
        ls.call.func = "deleteDiploma";     
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
            ls.call.func = "deleteDiploma"; 
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	 	        
            
        } else {    
        
            ls.call = {}; 
            ls.call.func = "deleteDiploma";   
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	        
                
            ls.call = {}; 
            ls.call.func = "copyDiploma";
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	     
            
            ls.call = {};  
            ls.call.func = "removeDiploma";         
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
            ls.call.func = "deleteDiploma"; 
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
        
        ls.retval =  Variables.edAltDao.isDiplomaRemoved(item_id);   	   
        
        return ls.retval;
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function createAndUpdateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function createAndUpdateItem(required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = [];                        
        
        ls.call = {};        
        ls.call.func = "createAndUpdateDiploma";
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
        
        ls.call.func = "copyAndUpdateDiploma"; 
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
		ls.call.func = "updateDiploma"; 
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
        
        ls.retval = getDiploma(datasource, item_id);   
            
  		return ls.retval;
	}                                               
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

	public boolean function hasFile(required numeric item_id, required struct args){
	    var ls = {}; 
        ls.retval = false;
        ls.item = args.item;
        
        if( ls.item.diploma_file != "" ) 
	        ls.retval = true ; 
                
		return ls.retval;      
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function uploadFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public any function uploadFile(required numeric item_id, required struct args) {
		ls.calls = []; 
                
        ls.call = {};           
        ls.call.func = "updateDiplomaFile"; 
        ls.filefield = "DIPLOMA_FILE_#item_id#";
        ls.call.args = {username:args.username, id:item_id, filefield:ls.filefield, rc:args.item};        
        
        ArrayAppend(ls.calls, ls.call);	 
       
        //writeDump("ls.calls");  
        //writeDump(ls.calls);     
        
        return ls.calls; 
    }          
    
    
}    