Component accessors="true" {  
   
	property nsmDao;
    property coDao;
    property coAltDao;   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public string function checkUserPriv(required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
           case("view_co"):            		
            	ls.chk = Variables.nsmDao.chkViewNsm(user_id, office_id, staff_member_id);   
                break;    
           case("view_alt_co"):            		
            	ls.chk = Variables.coDao.chkViewAltCo(user_id, office_id, staff_member_id);   
                break;                 
            case("edit_co"): 
            	ls.chk = Variables.coDao.chkEditCo(user_id, office_id, staff_member_id);   
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
// Function getCO
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getCO(required numeric user_id, required numeric office_id, required numeric staff_member_id, required boolean view_alt){    
    	var ls = {};         
        
        if(view_alt == false)
        	ls.retval = getContractsData( user_id, office_id, staff_member_id );         
        
        if(view_alt == true) 
        	ls.retval = getCollatedContractsData( user_id, office_id, staff_member_id );                
            
		ls.retval["view_alt"] = view_alt;             
            
        return ls.retval;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getContractsData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  

	public struct function getContractsData(required numeric user_id, required numeric office_id, required numeric staff_member_id){  
    	var ls = {};	
        ls.retval = {};        

        ls.contractsQry = variables.coDao.getContractsQry(staff_member_id);  
        ls.contracts = getContracts(ls.contractsQry);   //this is an array 
        
        ls.contractDocsQry = variables.coDao.getContractDocsQry(staff_member_id); 
        ls.contractDocs = getContractDocs(ls.contractDocsQry);   
        
        ls.retval["contracts"] = ls.contracts;  
        ls.retval["contractDocs"] = ls.contractDocs;          
        
        return ls.retval;
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCollatedContractsData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  

	public struct function getCollatedContractsData(required numeric user_id, required numeric office_id, required numeric staff_member_id){  
    	var ls = {};	
        ls.retval = {};        

        ls.contractsQry = variables.coDao.getContractsQry(staff_member_id);  
        ls.contracts = getContracts(ls.contractsQry);   //this is an array    
        
        ls.contractDocsQry = variables.coDao.getContractDocsQry(staff_member_id); 
        ls.contractDocs = getContractDocs(ls.contractDocsQry);   
        
        ls.altContractDocsQry = variables.coAltDao.getContractDocsQry(staff_member_id); 
        ls.altContractDocs = getContractDocs(ls.altContractDocsQry); 
        
        //writeDump(ls.altContractDocs);
       
        
		ls._contractDocs = getCollatedStructs(ls.contractDocs, ls.altContractDocs);
        ls.retval["contractDocs"] = ls._contractDocs.main; 
        ls.retval["alt"]["contractDocs"] = ls._contractDocs.alt;   
        
        //writeDump(ls._contractDocs);               
        
        ls.retval["contracts"] = ls.contracts;  
        //ls.retval["contractDocs"] = ls.contractDocs;    
        
        //writeDump(ls.retval);
        //abort;
        
        return ls.retval;
	}   
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCollatedStructs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getCollatedStructs(required struct items, required struct altItems) {  //these are structs of arrays 
	    var ls = {};
        ls.retval = {};
     
        ls.items = Duplicate(items);
        ls.altItems = Duplicate(altItems);
        
        ls.retval.main = ls.items;
        ls.retval.alt = {};   
        
       if( StructIsEmpty(ls.altItems) ){        	
            return ls.retval;
        }  	              
        
//////////////////////////////////////////////////////////////////////////////////
// look for updated or deleted items
// Only new items are possible for docs (however, type code might be editable in the future)
//////////////////////////////////////////////////////////////////////////////////

		for (ls.key in ls.items){ // These keys are IDs (ie, the contract id)
        
        	if( !structKeyExists(ls.altItems, ls.key) )
            	continue; 
        
        	ls.elements = ls.items[ls.key];  //array of contract files
            ls.altElements = ls.altItems[ls.key];   
            
            for(ls.element in ls.elements) { //this is one contract file
	            ls.elementId = ls.element.id;  
                
                //let's try to find an alt version
                ls.found = false;
                for(ls.altElement in ls.altElements){        
                
                    if(ls.altElement.id == ls.elementId){
                        ls.found = true;
                        break;
                    }                        
                }     
                
                if( ls.found == true ){   
                    //ls.altElement set above  
                    if(ls.altElement.deleted == "Y"){
                        //ls.element = ls.altElement; 
                        ls.element["deleted"] = "Y";
                        ls.element["status"] = "deleted";
                        continue;
                    }                   
                                                         
                    for(ls.field in ls.element){   
                        if( ls.element[ls.field] != ls.altElement[ls.field] ){     
                            if( ls.element[ls.field] == "")
                                ls.element[ls.field] = "[...]";   
                            ls.swap = ls.altElement[ls.field];                               
                            ls.retval.alt[ls.elementId][ls.field] = ls.element[ls.field];
                            ls.element[ls.field] = ls.swap;                            
                        }  
                    } 
                    ls.element["status"] = "updated";                             
                }  
            }     
            
            //add new docs to contract
            
            //writeDump(ls.elements);
            //writeDump(ls.altElements);            
            
            for(ls.altElement in ls.altElements){              
                ls.altElementId = ls.altElement.id;
                
                ls.found = false;
                for(ls.element in ls.elements){
                    if(ls.element.id == ls.altElementId){
                        ls.found = true;                        
                    }                        
                }
                if(ls.found == false){	               
                    ls.altElement["status"] = "new";  
                    ArrayAppend(ls.elements, ls.altElement);           
                }
			}  
            
            //writeDump(ls.elements);
		}      

		//add new items to main struct      
		for (ls.altKey in ls.altItems){            

            ls.found = false;
            for(ls.key in ls.items) {
				if(ls.altKey == ls.key){
                	ls.found = true;
                }            
            }
            
            if(ls.found == false) {
            	ls.altElements = ls.altItems[ls.altKey];                
            	for(ls.altElement in ls.altElements) {
                	ls.altElement["status"] = "new";
                }
	            ls.items[ls.altKey] = ls.altElements;  
            }   
        }
        
        ls.retval.main[ls.key] = ls.elements;
        
        return ls.retval;
	}  
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getContracts
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public array function getContracts(required query contractsQry) {    
       
    	var ls = {};
        ls.contracts = [];  
       
		for(ls.row in contractsQry){
        
        	ls.contract = {};   
            
            ls.contract["version_id"] = ls.row.version_id; //This one is unique
            ls.contract["contract_id"] = ls.row.contract_id;  //This one is not
            
            ls.contract["staff_member_id"] = ls.row.staff_member_id;              
            
            ls.contract["position_role_id"] = ls.row.position_role_id;
            ls.contract["position_role_code"] = ls.row.position_role_code;
            ls.contract["position_role"] = ls.row.position_role;
            
            ls.contract["contract_role_id"] = ls.row.contract_role_id; 
            ls.contract["contract_role_code"] = ls.row.contract_role_code; 
            ls.contract["contract_role"] = ls.row.contract_role; 
               
            ls.contract["start_date"] = ls.row.start_date;
            ls.contract["end_date"] = ls.row.end_date;  
            
            ls.contract["unit"] = ls.row.unit;     
            ls.contract["office_id"] = ls.row.office_id; 
            ls.contract["office"] = ls.row.office; 
            ls.contract["country_code"] = ls.row.country_code;  
               
            ls.contract["function_group"] = ls.row.function_group; 
            ls.contract["ingroup"] = ls.row.ingroup; 
            ls.contract["step"] = ls.row.step;     
                
            ls.contract["contract_version"] = ls.row.contract_version;     
            ls.contract["max_contract_version"] = ls.row.max_contract_version; 
                   
			ls.contract["file_name"] = ls.row.file_name;  
			ls.contract["comments"] = ls.row.comments;  
			ls.contract["apd_reference"] = ls.row.apd_reference;       
			ls.contract["status"] = ls.row.status;  
            ls.contract["deleted"] = ls.row.deleted; 
              
            ArrayAppend(ls.contracts, ls.contract);                                                                                                 
        }         
        
        return ls.contracts;  
	}    
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getContractDocs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getContractDocs(required query docsQry) {    
       
    	var ls = {};
        ls.docs = {};         
       
		for(ls.row in docsQry){
        
	       	if( StructKeyExists(ls.docs, ls.row.version_id) == "No" ){            	
                ls.docs[ls.row.version_id] = [];
			}  	        
            
        	ls.doc = {};              
            ls.doc["id"] = ls.row.id; 
            ls.doc["version_id"] = ls.row.version_id;  
            ls.doc["staff_member_id"] = ls.row.staff_member_id;     
			ls.doc["type"] = ls.row.type;                              
            ls.doc["file_name"] = ls.row.upld_name;  
            ls.doc["hash"] = ls.row.upld_hash; 
            ls.doc["type_code"] = ls.row.type_code; 
            ls.doc["deleted"] = ls.row.deleted; 
              
            ArrayAppend( ls.docs[ls.row.version_id], ls.doc );             
        }         
        
        return ls.docs;  
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getContractDoc (for download)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
    
	public struct function getContractDoc( required numeric user_id, required numeric office_id, required numeric staff_member_id, required struct rc ) {     
	    var ls = {}; 
        ls.data = {};    
        ls.version_id = rc.versionID;    
        ls.hash = rc.hash; 
        
        ls.qry = Variables.coAltDao.getContractDocQry(ls.version_id, ls.hash);                 

		//single-row result expected
        ls.data["fileName"] = ls.qry.file_name;  
        ls.data["fileData"] = ls.qry.file_data;
        ls.data["mimeType"] = ls.qry.mime_type;                   
        
 		ls.retval["data"] = ls.data;
        
        return ls.retval;  
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveCO
// Right now (07/2018) we only save contract docs, not contracts themselves
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function saveCO( required numeric user_id, required del_user_id, required numeric office_id, required numeric staff_member_id, required string username, required struct rc ){
    	var ls = {};     
        ls.retval = {"result":"OK"}; 
        ls.stack = [];	       
        
        ls["contractDocs"] = {};    
        
        ls.args = {};
        ls.args.username = username; 
        ls.args.staff_member_id = staff_member_id;  
        
        //This loop will only catch the contract docs
        for(ls.item in rc) {        
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
			if( NOT StructKeyExists(ls.contractDocs, ls.id) ){
            	ls.contractDocs[ls.id] = {};
                ls.contractDocs[ls.id].id = ls.id;                                                 
			}                   
			
            ls.fieldName = ListDeleteAt( ls.item, ListLen(ls.item, "_"), "_"); 
			ls.contractDocs[ls.id][ls.fieldName] = rc[ls.item];                        
        }    
        
        //writeDump(ls.contractDocs);
        //abort;
        
        //return ls.retval;
        
        ls.calls = processItems(ls.args, ls.contractDocs);
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

		ls.retval = Variables.coAltDao.transactQry(ls.stack);   
        
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
			ls.hasMainItem = false; //hasMainItem(ls.id);
    	    ls.hasAltItem = false; //hasAltItem(ls.id);  
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
	            ls.doc_id = Variables.coAltDao.getNewContractDocId(); 
                ls.args["doc_id"] = ls.doc_id;
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
        
        ls.retval = Variables.coDao.hasContractDoc(item_id);       	
        
		return ls.retval;          
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAltItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function hasAltItem(required numeric item_id) {
    	var ls = {};    
        ls.retval = "";
        
        ls.retval = Variables.coAltDao.hasContractDoc(item_id);    	
        
		return ls.retval;          
    }  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function isItemFlaggedForDelete
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function isItemFlaggedForDelete(required struct item){
    	var ls = {}; 		     
        
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
        ls.call.func = "deleteContractDoc";     
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
            ls.call.func = "deleteContractDoc"; 
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	 	        
            
        } else {    
        
            ls.call = {}; 
            ls.call.func = "deleteContractDoc";   
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	        
                
            ls.call = {}; 
            ls.call.func = "copyContractDoc";
            ls.call.args = {id:item_id};
            ArrayAppend(ls.calls, ls.call);	     
            
            ls.call = {};  
            ls.call.func = "removeContractDoc";         
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
            ls.call.func = "deleteContractDoc"; 
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
        
        ls.retval =  Variables.coAltDao.isContractDocRemoved(item_id);   	   
        
        return ls.retval;
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function createAndUpdateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function createAndUpdateItem(required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = [];    
        
        //Remember: the item_id is the contract version id, not the contractDoc id!
        
        //writeDump(args);
        //abort;   
       
        ls.type_id = getTypeId(args.item.type_code);             
        
        ls.call = {};        
        ls.call.func = "createAndUpdateContractDoc";
        ls.call.args = {username: args.username, id:args.doc_id, version_id:item_id, staff_member_id:args.staff_member_id, type_id:ls.type_id, rc: args.item};
        ArrayAppend(ls.calls, ls.call);	    
        
        //writeDump(ls.calls);
        //abort;    
                
        return ls.calls;	    
    } 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getTypeId
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public numeric function getTypeId(required stringTypeCode){
    
    	 return Variables.coAltDao.getTypeId(stringTypeCode); 
    
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function copyAndUpdateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function copyAndUpdateItem(required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = []; 
       	ls.call = {}; 
        
        ls.call.func = "copyAndUpdateContractDoc"; 
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
		ls.call.func = "updateContractDoc"; 
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
        
        ls.retval = getContractDoc(datasource, item_id);   
            
  		return ls.retval;
	}                                               
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

	public boolean function hasFile(required numeric item_id, required struct args){
	    var ls = {}; 
        ls.retval = false;
        ls.item = args.item;
        
        if( ls.item.contract_file != "" ) 
	        ls.retval = true ; 
                
		return ls.retval;      
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function uploadFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public any function uploadFile(required numeric item_id, required struct args) {
		ls.calls = []; 
                
        ls.call = {};           
        ls.call.func = "updateContractDocFile"; 
        ls.filefield = "CONTRACT_FILE_#item_id#";
        ls.call.args = {username:args.username, id:args.doc_id, filefield:ls.filefield, rc:args.item};        
        
        ArrayAppend(ls.calls, ls.call);	        
         
        //writeDump(ls.calls);     
        //abort;
        
        return ls.calls; 
    }                  
              
    
}    