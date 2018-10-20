Component accessors="true" {     
	    
	property nsmDao;         
    property fdDao; 
    property fdAltDao;     
    //property formatterService;
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function init
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function init( fw ) {
		Variables.fw = fw;
        
        Variables.spouseFields = setRelativeFields("SPOU");
        Variables.childFields = setRelativeFields("CHIL");
        Variables.otherRelativeFields = setRelativeFields("OTH");
        Variables.certificateFields = setCertificateFields();
        Variables.scholarshipFields = setScholarshipFields();
        
        //c = Variables.formatterService.longdate( Now() );
        
		return this;
	}	    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public string function checkUserPriv(required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
           case("view_fd"):            		
            	ls.chk = Variables.nsmDao.chkViewNsm(user_id, office_id, staff_member_id);   
                break;    
           case("view_alt_fd"):            		
            	ls.chk = Variables.fdDao.chkViewAltFd(user_id, office_id, staff_member_id);   
                break;                 
            case("edit_fd"): 
            	ls.chk = Variables.fdDao.chkEditFd(user_id, office_id, staff_member_id);   
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
// Function getFD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getFD(required numeric user_id, required numeric office_id, required numeric staff_member_id, required boolean view_alt){    
    	var ls = {};         
        
        if(view_alt == false)
        	ls.retval = getFamilyData(user_id, office_id, staff_member_id);         
        
        if(view_alt == true)
        	ls.retval = getCollatedFamilyData(user_id, office_id, staff_member_id);
            
        return ls.retval;
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setRelativeFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function setRelativeFields(familyLink){
    
    	var ls = {};
        ls.retval = [];
    
    	ls.anyRelative = ["status", "id", "deleted", "lname", "fname", "birth_date", "gender", "family_link", "citizenship_1_country_code", "citizenship_2_country_code", "is_dependent", "dependent_since"];
        ls.spousePersonalDetails = ["birth_country_code", "birth_city", "death_date", "is_expatriate", "expatriate_since"];
        ls.spouseOccupation = ["occupation", "occupation_start", "employer", "annual_income", "income_currency"];
        ls.spouseCco = ["cco_same", "cco_address", "cco_city", "cco_postal_code", "cco_country_code", "cco_since"];
        ls.spouseCrc = ["crc_same", "crc_address", "crc_city", "crc_postal_code", "crc_country_code", "crc_since"];
        ls.spousePrivateContact = ["phone_nbr", "mobile_nbr", "other_phone_nbr", "email_1", "email_2"];        
        ls.childSchool = ["school_name", "school_address", "school_city", "school_postal_code", "school_country_code"];
        
        switch(familyLink) {
        	case "SPOU": 
            	ArrayAppend(ls.retval, ls.anyRelative, true);
            	ArrayAppend(ls.retval, ls.spousePersonalDetails, true); 
            	ArrayAppend(ls.retval, ls.spouseOccupation, true);  
            	ArrayAppend(ls.retval, ls.spouseCco, true); 
            	ArrayAppend(ls.retval, ls.spouseCrc, true); 
            	ArrayAppend(ls.retval, ls.spousePrivateContact, true);    
                break;
			case "CHIL":    
	            ArrayAppend(ls.retval, ls.anyRelative, true);  
				ArrayAppend(ls.retval, ls.childSchool, true); 
                break;
			default:   
	            ArrayAppend(ls.retval, ls.anyRelative, true);                           
		}
            
 		return ls.retval; 
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRelativeFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function getRelativeFields(familyLink){    
        var ls = {}; 
        ls.retval = [];      
        
        switch(familyLink) {        	
        	case "WIFE": 
            	ls.retval = Variables.spouseFields;   
                break;     
        	case "HUSB": 
            	ls.retval = Variables.spouseFields;   
                break;                            
			case "CHIL":    
            	ls.retval = Variables.childFields;   
                break;
			default:   
	            ls.retval = Variables.otherRelativeFields;                              
		}    
        
        return ls.retval;        
    }   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setCertificateFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function setCertificateFields(){
    
    	var ls = {};
        ls.retval = [];      
    
    	ls.certificate = ["id", "relative_id", "deleted", "reception_date", "validity_from", "validity_until", "comments", "certificate_filename"];    
		ArrayAppend(ls.retval, ls.certificate, true);
        
        return ls.retval;     
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCertificateFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function getCertificateFields(){    
        var ls = {}; 
        ls.retval = [];   
        
        ls.retval = Variables.certificateFields;          
        
        return ls.retval;        
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setScholarshipFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function setScholarshipFields(){
    
    	var ls = {};
        ls.retval = [];                
    
    	ls.scholarship = ["id", "relative_id", "deleted", "nature", "monthly_amount", "academic_year", "comments", "scholarship_filename"];    
		ArrayAppend(ls.retval, ls.scholarship, true);
        
        return ls.retval;     
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getScholarshipFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function getScholarshipFields(){    
        var ls = {}; 
        ls.retval = [];   
        
        ls.retval = Variables.scholarshipFields;          
        
        return ls.retval;        
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFamilyData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getFamilyData(required numeric user_id, required numeric office_id, required numeric staff_member_id){    
    	var ls = {}; 
        ls.retval = {};
        ls.retval["data"] = {};
        
        ls.externExists = Variables.nsmDao.externExists(staff_member_id);
        ls.retval.data["externExists"] = ls.externExists;      
        
        ls.relatives = getRelatives("main", staff_member_id);    
        ls.retval.data["certificates"] = getCertificates("main", staff_member_id).data;         
        ls.retval.data["scholarships"] = getScholarships("main", staff_member_id).data;         
		ls.retval.data["allowances"] = getAllowances("main", staff_member_id); 
         
        ls.retval.data["spouses"] = ls.relatives.spouses;          
        ls.retval.data["children"] = ls.relatives.children;            
        ls.retval.data["relatives"] = ls.relatives.otherRelatives;            
        
        return ls.retval;        
	}                  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCollatedFamilyData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getCollatedFamilyData(required numeric user_id, required numeric office_id, required numeric staff_member_id){    
    	var ls = {};  
        ls.retval = {};
        ls.retval.data = {};
        
        ls.externExists = Variables.nsmDao.externExists(staff_member_id);
        ls.retval.data["externExists"] = ls.externExists;  
        
        ls.relatives = getRelatives("main", staff_member_id);  
        ls.altRelatives = getRelatives("alt", staff_member_id);    
        
        //writeDump(ls.altRelatives);
        //abort;
        
        ls.certificates = getCertificates("main", staff_member_id).data;  
        ls.altCertificates = getCertificates("alt", staff_member_id).data;  
        
        ls.scholarships = getScholarships("main", staff_member_id).data;  
        ls.altScholarships = getScholarships("alt", staff_member_id).data;    
        
		ls.allowances = getAllowances("main", staff_member_id);        
		ls.altAllowances = getAllowances("alt", staff_member_id);        
        
        ls.spouses = ls.relatives.spouses;   
        ls.altSpouses = ls.altRelatives.spouses; 
        ls._spouses = getCollatedArrays(ls.spouses, ls.altSpouses);
        ls.retval.data["spouses"] = ls._spouses.main;
        ls.retval.data["alt"]["spouses"] = ls._spouses.alt;    
        
        ls.children = ls.relatives.children;   
        ls.altChildren = ls.altRelatives.children; 
        ls._children = getCollatedArrays(ls.children, ls.altChildren);
        ls.retval.data["children"] = ls._children.main; //This is an array of children
        ls.retval.data["alt"]["children"] = ls._children.alt; //This is an object with each alt child as a property 
           
        ls.otherRelatives = ls.relatives.otherRelatives;   
        ls.altOtherRelatives = ls.altRelatives.otherRelatives; 
        ls._otherRelatives = getCollatedArrays(ls.otherRelatives, ls.altOtherRelatives);
        ls.retval.data["relatives"] = ls._otherRelatives.main; 
        ls.retval.data["alt"]["relatives"] = ls._otherRelatives.alt;  
 
      	ls._certificates = getCollatedStructs(ls.certificates, ls.altCertificates);
        ls.retval.data["certificates"] = ls._certificates.main; 
        ls.retval.data["alt"]["certificates"] = ls._certificates.alt; 
        
       	ls._scholarships = getCollatedStructs(ls.scholarships, ls.altScholarships);
        ls.retval.data["scholarships"] = ls._scholarships.main; 
        ls.retval.data["alt"]["scholarships"] = ls._scholarships.alt;    
        
       	ls._allowances = getCollatedFields(ls.allowances, ls.altAllowances);
        ls.retval.data["allowances"] = ls._allowances.main; 
        ls.retval.data["alt"]["allowances"] = ls._allowances.alt;         
                
        return ls.retval;        
	} 
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCollatedFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getCollatedFields(required struct items, required struct altItems) {  //these are structs containing simple values
	    var ls = {};
        ls.retval = {};
        
        ls.items = Duplicate(items);
        ls.altItems = Duplicate(altItems);
        
        ls.retval.main = ls.items;
        ls.retval.alt = {};   
        
       if( StructIsEmpty(ls.altItems) ){        	
            return ls.retval;
        }    
        
        for (ls.key in ls.items){
        	if( ls.items[ls.key] != ls.altItems[ls.key] ){
	            if( ls.items[ls.key] == "")
   					ls.items[ls.key] = "[...]";  
                ls.swap = ls.altItems[ls.key];    
                ls.retval.alt[ls.key] = ls.items[ls.key];
                ls.items[ls.key] = ls.swap; 
            }
		}  
        
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
        
/////////////////////////////////////////
// look for updated or deleted items
/////////////////////////////////////////

		for (ls.key in ls.items){ // These keys are IDs (ie, the child id)
        
        	if( !structKeyExists(ls.altItems, ls.key) )
            	continue; 
        
        	ls.elements = ls.items[ls.key];  //this is for instance an array of certificates
            ls.altElements = ls.altItems[ls.key];   
            
            for(ls.element in ls.elements) { //this is one certificate
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
            
            //add new certificate for a child
            for(ls.altElement in ls.altElements){  //this is one certificate            
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
		}      

		//add the certificates of a new child          
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
        
        return ls.retval;
	}      
    
 // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCollatedArrays
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getCollatedArrays(required array items, required array altItems) {  
	    var ls = {};
        ls.retval = {};       
     
        ls.items = Duplicate(items);
        ls.altItems = Duplicate(altItems);            
        
        ls.retval.main = ls.items;
        ls.retval.alt = {};
        
        if( ArrayIsEmpty(ls.altItems) ){        	
            return ls.retval;
        }    	          
        
/////////////////////////////////////////
// look for updated or deleted items
/////////////////////////////////////////
        
        for(ls.item in ls.retval.main){  
            ls.itemId = ls.item.id;                
            
            //let's try to find an alt version
            ls.found = false;
            for(ls.altItem in ls.altItems){    
            
                if(ls.altItem.id == ls.itemId){
                    ls.found = true;
                    break;
                }                        
            }
            
            if( ls.found == true ){   
                //ls.altItem set above  
				if(ls.altItem.deleted == "Y"){  
                	//ls.item = ls.altItem;            
                    ls.item["status"] = "deleted";   
                    ls.item["deleted"] = "Y"; 
                    continue;
                }   
                                                     
                for(ls.field in ls.item){   
                    if( ls.item[ls.field] != ls.altItem[ls.field] ){    
                     
                        if( ls.item[ls.field] == "")
                            ls.item[ls.field] = "[...]";   
                            
						ls.main = ls.item[ls.field];       
                        ls.alt = ls.altItem[ls.field];
						
                        //we swap values here:
                        ls.item[ls.field] = ls.alt;  //this writes to ls.retval.main
                        ls.retval.alt[ls.itemId][ls.field] = ls.main;  //this writes to ls.retval.alt
                        
                    }  
                } 
                ls.item["status"] = "updated";                             
            } 
        }  
        
/////////////////////////////////////////
// look for new items
/////////////////////////////////////////
         
       	for(ls.altItem in ls.altItems){	       
            
	        ls.altItemId = ls.altItem.id; 
            
            ls.found = false;
            for(ls.item in ls.items){
                if(ls.altItemId == ls.item.id){
                    ls.found = true;
                }                        
            }
            if(ls.found == false){	               
                ls.altItem["status"] = "new";  
                ArrayAppend(ls.retval.main, ls.altItem); 
            }
         }   
         
         //ls.retval.main = ls.items;
         //ls.retval.alt = ls.altItems;         
         
         return ls.retval;      
	}            
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRelatives
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getRelatives(type, required numeric staff_member_id){    
    	var ls = {};    
        
        ls.retval = {};    
        ls.spouses = [];
        ls.children = [];
        ls.otherRelatives = [];
        
        if(type == "main")
	        ls.qry = Variables.fdDao.getRelativesQry(staff_member_id);
		else if(type == "alt")
            ls.qry = Variables.fdAltDao.getRelativesQry(staff_member_id);     
        
        for(ls.row in ls.qry) {        	
            ls.relative = {};
            //ls.relative["id"] = ls.row.id;
            ls.familyLink = ls.row.family_link;           
            
            ls.fields = getRelativeFields(ls.familyLink);
            
            for(ls.field in ls.fields){
                ls.relative[ls.field] = ls.row[ls.field];
            }
            
            if( ListFind("WIFE,HUSB,SPOU", ls.familyLink) ) {                
                ArrayAppend(ls.spouses, ls.relative);
            }            
            else if( ListFind("CHIL", ls.familyLink) ) {                
                ArrayAppend(ls.children, ls.relative);
            }   
            else {
	            ArrayAppend(ls.otherRelatives, ls.relative);
            }         
		}   
        
        ls.retval.spouses = ls.spouses;
        ls.retval.children = ls.children;
        ls.retval.otherRelatives = ls.otherRelatives;  
	           
  		return ls.retval;
	} 
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRelative
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getRelative(required string datasource, required numeric relative_id){
    	var ls = {};   
             
        ls.retval = {};          
        ls.relative = {};          
        
        if(datasource == "main")
	        ls.qry = Variables.fdDao.getRelativeQry(relative_id);
		else if(datasource == "alt")
            ls.qry = Variables.fdAltDao.getRelativeQry(relative_id);         
        
        for(ls.row in ls.qry) {  
            //ls.relative["id"] = ls.row.id;
            ls.familyLink = ls.row.family_link;           
            
            ls.fields = getRelativeFields(ls.familyLink);
            
            for(ls.field in ls.fields){
                ls.relative[ls.field] = ls.row[ls.field];
            }               
		}   
        
        ls.retval = ls.relative;            
            
  		return ls.retval;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getItem(required string type, required string datasource, required numeric item_id){
    	var ls = {};                
        ls.retval = {};  
        
        switch(type){
        	case "relative": 
            	ls.retval = getRelative(datasource, item_id); 
                break;
        	case "certificate": 
            	ls.retval = getCertificate(datasource, item_id); 
                break;
        	case "scholarship": 
            	ls.retval = getScholarship(datasource, item_id); 
                break; 
        	case "allowances": 
            	ls.retval = getAllowances(datasource, item_id); 
                break;                
        }   
            
  		return ls.retval;
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getAllowances
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getAllowances(required string type, required numeric staff_member_id){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};   
            
        if(type == "main")
	        ls.qry = Variables.fdDao.getAllowancesQry(staff_member_id);
		else if(type == "alt")
            ls.qry = Variables.fdAltDao.getAllowancesQry(staff_member_id);                       	

		//Single result row expected
        ls.data["allowances_nature"] = ls.qry.allowances_nature;
        ls.data["allowances_amount"] = ls.qry.allowances_amount;
        ls.data["allowances_comments"] = ls.qry.allowances_comments;   
        
        ls.retval = ls.data;             
        
        return ls.retval;        
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCertificates
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getCertificates(required string datasource, required numeric staff_member_id){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};   
        
        ls.relative_id = 0;
        ls.certificates = {};    
        
        if(datasource == "main")
	        ls.qry = Variables.fdDao.getCertificatesQry(staff_member_id);
		else if(datasource == "alt")
            ls.qry = Variables.fdAltDao.getCertificatesQry(staff_member_id);            
		
        for (ls.row in ls.qry) {
                
        	if(ls.row.relative_id != ls.relative_id){
            	ls.relative_id = ls.row.relative_id;
                ls.certificates[ls.relative_id] = [];
			}   
            
        	ls.certificate = {};        
            ls.certificate["id"] = ls.row.id;
	        ls.certificate["reception_date"] = ls.row.reception_date;
	        ls.certificate["validity_from"] = ls.row.validity_from;
	        ls.certificate["validity_until"] = ls.row.validity_until;
            ls.certificate["relative_id"] = ls.row.relative_id;
            ls.certificate["deleted"] = ls.row.deleted;
	        ls.certificate["comments"] = ls.row.comments;
	        ls.certificate["certificate_filename"] = ls.row.certificate_filename; 
            ls.certificate["upld_hash"] = ls.row.upld_hash;             
			 
            ArrayAppend(ls.certificates[ls.relative_id], ls.certificate);
		}            
        
        ls.retval.data = ls.certificates;
        
        return ls.retval;   
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCertificate
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getCertificate(required string datasource, required numeric certificate_id){
    	var ls = {};  
        ls.retval = {};          
        ls.certificate = {};          
        
        if(datasource == "main")
	        ls.qry = Variables.fdDao.getCertificateQry(certificate_id);
		else if(datasource == "alt")
            ls.qry = Variables.fdAltDao.getCertificateQry(certificate_id);         
        
        for(ls.row in ls.qry) {   
            ls.fields = getCertificateFields();
            
            for(ls.field in ls.fields){
                ls.certificate[ls.field] = ls.row[ls.field];
            }               
		}   
        
        ls.retval = ls.certificate;            
            
  		return ls.retval;
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getScholarships
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	Public struct function getScholarships(required string datasource, required numeric staff_member_id){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};   
        
        ls.relative_id = 0;
        ls.scholarships = {};        
        
        if(datasource == "main")
	        ls.qry = Variables.fdDao.getScholarshipsQry(staff_member_id);
		else if(datasource == "alt")
            ls.qry = Variables.fdAltDao.getScholarshipsQry(staff_member_id);  
		
        for (ls.row in ls.qry) {
        
        	if(ls.row.relative_id != ls.relative_id){
            	ls.relative_id = ls.row.relative_id;
                ls.scholarships[ls.relative_id] = [];
			} 
              
        	ls.scholarship = {};        
            ls.scholarship["id"] = ls.row.id;            
	        ls.scholarship["nature"] = ls.row.nature;
	        ls.scholarship["monthly_amount"] = ls.row.monthly_amount;
	        ls.scholarship["academic_year"] = ls.row.academic_year;
            ls.scholarship["relative_id"] = ls.row.relative_id;
	        ls.scholarship["comments"] = ls.row.comments;
            ls.scholarship["deleted"] = ls.row.deleted;
	        ls.scholarship["scholarship_filename"] = ls.row.scholarship_filename; 
            ls.scholarship["upld_hash"] = ls.row.upld_hash;             
			
            ArrayAppend(ls.scholarships[ls.relative_id], ls.scholarship);
		}            
        
        ls.retval.data = ls.scholarships;
        
        return ls.retval;   
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getScholarship
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getScholarship(required string datasource, required numeric scholarship_id){
    	var ls = {};  
        ls.retval = {};          
        ls.scholarship = {};          
        
        if(datasource == "main")
	        ls.qry = Variables.fdDao.getScholarshipQry(scholarship_id);
		else if(datasource == "alt")
            ls.qry = Variables.fdAltDao.getScholarshipQry(scholarship_id);         
        
        for(ls.row in ls.qry) {   
            ls.fields = getScholarshipFields();
            
            for(ls.field in ls.fields){
                ls.scholarship[ls.field] = ls.row[ls.field];
            }               
		}   
        
        ls.retval = ls.scholarship;            
            
  		return ls.retval;
	}         
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addSpouse
// This function simply returns a template for a spouse + the new ID
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addSpouse(required string gender){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};  
        
        //get spouse-specific fields
        ls.fieldNames = getRelativeFields("SPOU"); //array of field names
        
        //set global default value
        for(ls.fieldName in ls.fieldNames){
        	ls.retval.data[ls.fieldName] = "";
        }
        
        if(gender == "F")        	
            ls.family_link = "WIFE";
		else            
            ls.family_link = "HUSB";
        
        ls.id = Variables.fdAltDao.getNewRelativeId(); 
        
        //set specific default values
        ls.retval.data.id = ls.id;
        ls.retval.data.status = "new"; 
        ls.retval.data.gender = gender; 
        ls.retval.data.family_link = ls.family_link;
        ls.retval.data.deleted = "N";
		ls.retval.data.lname = "Spouse";
        
        return ls.retval;          
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addChild
// This function simply returns the template for a child.
// Could be moved to an AngularJS service. 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addChild(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};  
        
        //get child-specific fields
        ls.fieldNames = getRelativeFields("CHIL"); //array of field names
        
        //set global default value
        for(ls.fieldName in ls.fieldNames){
        	ls.retval.data[ls.fieldName] = "";
        }
       
        ls.id = Variables.fdAltDao.getNewRelativeId(); 
        
        //set specific default values
        ls.retval.data.id = ls.id;
        ls.retval.data.status = "new"; 
        ls.retval.data.family_link = "CHIL";
        ls.retval.data.deleted = "N";
		ls.retval.data.lname = "Unnamed Child";
        
        return ls.retval;          
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addOtherRelative
// This function simply returns a template for a relative.
// Could be moved to an AngularJS service. 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addOtherRelative( rc ){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};  
        
        //get other relative-specific fields
        ls.fieldNames = getRelativeFields("OTHER"); //array of field names
        
        //set global default value
        for(ls.fieldName in ls.fieldNames){
        	ls.retval.data[ls.fieldName] = "";
        }
        
        ls.id = Variables.fdAltDao.getNewRelativeId(); 
        
        //set specific default values
        ls.retval.data.id = ls.id;
        ls.retval.data.status = "new"; 
        ls.retval.data.deleted = "N";
        
        if( StructKeyExists(rc, "family_link") ){
                
        	switch(rc.family_link){
            	 case("FATH"):
                 	ls.retval.data.family_link = "FATH";
                    ls.retval.data.lname = "Father";
                    ls.retval.data.gender = "M";
                    break;            
            	 case("MOTH"):
                 	ls.retval.data.family_link = "MOTH";
                    ls.retval.data.lname = "Mother";
                    ls.retval.data.gender = "F";                    
                    break;  
            	 case("BROT"):
                 	ls.retval.data.family_link = "BROT";
                    ls.retval.data.lname = "Brother";
                    ls.retval.data.gender = "M";                    
                    break;                    
            	 case("SIST"):
                 	ls.retval.data.family_link = "SIST";
                    ls.retval.data.lname = "Sister";
                    ls.retval.data.gender = "F";                                        
                    break;   
            	 case("FATL"):
                 	ls.retval.data.family_link = "FATL";
                    ls.retval.data.lname = "Father-in-law";
                    ls.retval.data.gender = "M";                    
                    break;                     
            	 case("MOTL"):
                 	ls.retval.data.family_link = "MOTL";
                    ls.retval.data.lname = "Mother-in-law";
                    ls.retval.data.gender = "F";                                        
                    break;           
			}  
        } 
        
        return ls.retval;          
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveFD
// Does currently not update allowancess
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public any function saveFD(required numeric user_id, required del_user_id, required numeric office_id, required numeric staff_member_id, required string username, required rc){
    	var ls = {};     
        ls.retval = {}; 
        ls.stack = [];
        
        ls["relatives"] = {};
        ls["scholarships"] = {};
        ls["certificates"] = {};
        ls["allowances"] = {};
        
        ls["info"] = {};   
        
        ls.args = {};
        ls.args.username = username; 
        ls.args.staff_member_id = staff_member_id;
        ls.args.personal_profile_id = getPersonalProfileId(ls.args); //will create if does not exist
        ls.args.rc = rc;  
        
///////////////////////////////////////////////////////
// Relatives 
/////////////////////////////////////////////////////// 
        
        for(ls.item in rc) {
        	ls.type = ListFirst(ls.item, "_");
            if( NOT ListFindNoCase("spouse,child,relative", ls.type) )
            	continue;
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
            if( NOT StructKeyExists(ls.relatives, ls.id) ){
            	ls.relatives[ls.id] = {};
                ls.relatives[ls.id].id = ls.id;                 
			}                
			ls.label = ListDeleteAt( ls.item, 1, "_");               
            ls.label = ListDeleteAt( ls.label, ListLen(ls.label, "_"), "_"); 
			ls.relatives[ls.id][ls.label] = rc[ls.item];  //assign values to db field names                       
        }  
        
        ls.calls = processItems("relative", ls.args, ls.relatives);
        ArrayAppend(ls.stack, ls.calls, true);
        
///////////////////////////////////////////////////////
// Certificates 
/////////////////////////////////////////////////////// 
        
        for(ls.item in rc) {
        	ls.type = ListFirst(ls.item, "_");
            if( NOT ListFindNoCase("certificate", ls.type) )
            	continue;
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
            if( NOT StructKeyExists(ls.certificates, ls.id) ){
            	ls.certificates[ls.id] = {};
                ls.certificates[ls.id].id = ls.id;                 
			}                
			ls.label = ListDeleteAt( ls.item, 1, "_");               
            ls.label = ListDeleteAt( ls.label, ListLen(ls.label, "_"), "_"); 
			ls.certificates[ls.id][ls.label] = rc[ls.item];                        
        }  
        
        ls.calls = processItems("certificate", ls.args, ls.certificates);
        ArrayAppend(ls.stack, ls.calls, true);
        
///////////////////////////////////////////////////////
// Scholarships 
/////////////////////////////////////////////////////// 
        
        for(ls.item in rc) {
        	ls.type = ListFirst(ls.item, "_");
            if( NOT ListFindNoCase("scholarship", ls.type) )
            	continue;
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
            if( NOT StructKeyExists(ls.scholarships, ls.id) ){
            	ls.scholarships[ls.id] = {};
                ls.scholarships[ls.id].id = ls.id;                 
			}                
			ls.label = ListDeleteAt( ls.item, 1, "_");               
            ls.label = ListDeleteAt( ls.label, ListLen(ls.label, "_"), "_"); 
			ls.scholarships[ls.id][ls.label] = rc[ls.item];                      
        }  
        
        ls.calls = processItems("scholarship", ls.args, ls.scholarships);
        ArrayAppend(ls.stack, ls.calls, true);
        
///////////////////////////////////////////////////////
// Allowances
///////////////////////////////////////////////////////         

        for(ls.item in rc) {
        	ls.type = ListFirst(ls.item, "_");
            if( NOT ListFindNoCase("allowances", ls.type) )
            	continue;
            ls.id = staff_member_id;      
            if( NOT StructKeyExists(ls.allowances, ls.id) ){
            	ls.allowances[ls.id] = {};
                ls.allowances[ls.id].id = ls.id;                 
			}                
			ls.label = ls.item;   
			ls.allowances[ls.id][ls.label] = rc[ls.item];  
        } 	
     
	    ls.calls = processItems("allowances", ls.args, ls.allowances);
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

		ls.retval = Variables.fdAltDao.transactQry(ls.stack);   
        
        return ls.retval;        
	}                   
        
///////////////////////////////////////////////////////
// Process items 
///////////////////////////////////////////////////////       

	public array function processItems(required string type, required struct args, required struct items) {    
    	var ls = {};
        ls.args = args;
        ls.stack = []; 
        
        for(ls.id in items) {
        	ls.item = items[ls.id];
            ls.args.item = ls.item;    
            
            if(type == "relative"){
	            if( !StructKeyExists(ls.item, "family_link") ) {
	                writeDump("No family link");
                	writeDump(ls.item);
                    abort;
                }
	            ls.args.family_link = ls.item.family_link;
	            ls.hasMainItem = hasMainItem("relative", ls.id);
    	        ls.hasAltItem = hasAltItem("relative", ls.id); 
                ls.hasFile = false;                               
	            ls.isFlaggedForDelete = isItemFlaggedForDelete(ls.item);
    	        ls.isFlaggedForRestore = isItemFlaggedForRestore(ls.item);	                
			}   
            
            if(type == "certificate"){            	
	            ls.args.relative_id = ls.item.child_id;
	            ls.hasMainItem = hasMainItem("certificate", ls.id);
    	        ls.hasAltItem = hasAltItem("certificate", ls.id);    
                ls.hasFile = hasFile("certificate", ls.id, ls.args);  
	            ls.isFlaggedForDelete = isItemFlaggedForDelete(ls.item);
    	        ls.isFlaggedForRestore = isItemFlaggedForRestore(ls.item);	                                          
			}    
            
            if(type == "scholarship"){	   
	            ls.args.relative_id = ls.item.child_id;        
	            ls.hasMainItem = hasMainItem("scholarship", ls.id);
    	        ls.hasAltItem = hasAltItem("scholarship", ls.id);      
                ls.hasFile = hasFile("scholarship", ls.id, ls.args);           
	            ls.isFlaggedForDelete = isItemFlaggedForDelete(ls.item);
    	        ls.isFlaggedForRestore = isItemFlaggedForRestore(ls.item);	                
			}  
            
            if(type == "allowances"){	   
	            //ls.args.relative_id = ls.item.child_id;        
	            ls.hasMainItem = hasMainItem("allowances", ls.id);;
    	        ls.hasAltItem = hasAltItem("allowances", ls.id);      
                ls.hasFile = false; 
	            ls.isFlaggedForDelete = false;
    	        ls.isFlaggedForRestore = false;	                 
			}               	 
            
			if( ls.isFlaggedForDelete == true){
            	ls.calls = discardItem(type, ls.id, ls.args, ls.hasMainItem, ls.hasAltItem);	
                ArrayAppend(ls.stack, ls.calls, true);
                continue;
			}               
            
			if( ls.isFlaggedForRestore == true ){
            	ls.calls = restoreItem(type, ls.id, ls.args, ls.hasMainItem, ls.hasAltItem);	
                if(!ArrayIsEmpty(ls.calls)) { 
	                ArrayAppend(ls.stack, ls.calls, true);  
                    continue; 
				}                    
			}   
            
			if( ls.hasAltItem == false && ls.hasMainItem == false ){ //new item
            	ls.calls = createAndUpdateItem(type, ls.id, ls.args);	
                ArrayAppend(ls.stack, ls.calls, true);  
                
                if(ls.hasFile == true){
                    ls.calls = uploadFile(type, ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);
                } 
                                 
                continue;                     
			}                         
            
			if( ls.hasAltItem == false ){ //create alt if rc different from main
            	ls.s1 = ls.item;
                ls.s2 = getItem(type, "main", ls.id);
        		ls.structsAreDifferent = structsAreDifferent(ls.s1, ls.s2);
                if( ls.structsAreDifferent == true || ls.hasFile == true ) {
                    ls.calls = copyAndUpdateItem(type, ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);
				}  
                
                if(ls.hasFile == true){
                    ls.calls = uploadFile(type, ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);
                }      
                continue;            
			}            		              
			          
			if( ls.hasAltItem == true ){
            
	            //writeDump({"hasAltItem":true});
            	ls.s1 = ls.item;
                
             	//delete alt if new alt same as main record and no file was uploaded
                //NB: allowances are stored in TBL_EXTERNS_ALT, which cannot be deleted just because allowances are identical!
                if( type != "allowances" && ls.hasMainItem == true ) { 
                    ls.s2 = getItem(type, "main", ls.id);        		
                    if( !structsAreDifferent(ls.s1, ls.s2) && !ls.hasFile) {
                         //writeDump({"structsAreDifferent":1});
                        ls.calls = deleteItem(type, ls.id);   
                        ArrayAppend(ls.stack, ls.calls, true);  
                        continue;                            
                    }  
				}                                   
                
                //writeDump({fl:ls.args.family_link});
                //update alt if new alt different from current alt
                ls.s2 = getItem(type, "alt", ls.id);
                 //writeDump(ls.s2);
                if( structsAreDifferent(ls.s1, ls.s2) ) {  
                	
	                //writeDump({"structsAreDifferent":2});
                    ls.calls = updateItem(type, ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);                   
				} 
			    if( ls.hasFile ) {  
                    ls.calls = uploadFile(type, ls.id, ls.args);                    
                    ArrayAppend(ls.stack, ls.calls, true);                   
				}                
			}             
        }  
      
        return ls.stack;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

	public boolean function hasFile(required string type, required numeric item_id, required struct args){
	    var ls = {}; 
        ls.retval = false;
        ls.item = args.item;
        
        if( ls.item.file != "" ) 
	        ls.retval = true ; 		                      
                
		return ls.retval;      
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function uploadFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public any function uploadFile(required string type, required numeric item_id, required struct args) {
		ls.calls = []; 
        
        if(type == "certificate") {                
            ls.call = {};  
            ls.call.func = "updateCertificateFile"; 
            ls.filefield = "CERTIFICATE_FILE_#item_id#";
            ls.call.args = {username:args.username, id:item_id, filefield:ls.filefield, rc:args.item};        
        }
        else if (type == "scholarship"){
            ls.call = {};  
            ls.call.func = "updateScholarshipFile"; 
            ls.filefield = "SCHOLARSHIP_FILE_#item_id#";
            ls.call.args = {username:args.username, id:item_id, filefield:ls.filefield, rc:args.item};         
        }
        
        ArrayAppend(ls.calls, ls.call);	 
                
        return ls.calls; 
    }
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function structsAreDifferent
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function structsAreDifferent(required struct s1, required struct s2){   
    	var ls = {};     
    
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

	public array function deleteItem(required string type, required numeric item_id){   	
      	var ls = {}; 
        ls.calls = []; 
                
        ls.call = {};               
        switch(type){
        	case "relative":  ls.call.func = "deleteRelative"; break;
        	case "certificate":  ls.call.func = "deleteCertificate"; break;
            case "scholarship":  ls.call.func = "deleteScholarship"; break;            
        }          
        ls.call.args = {id:item_id};
        ls.call.info = "deleteItem type:#type#";  
        
        ArrayAppend(ls.calls, ls.call);	 
        
		return ls.calls;                       
	}               
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function discardItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function discardItem(required string type, required numeric item_id, required struct args, required boolean hasMainItem, required boolean hasAltItem){   	
      	var ls = {}; 
        ls.calls = [];           
        
        if(hasMainItem == false){
        
            ls.call = {};            
            switch(type){
                case "relative":  ls.call.func = "deleteRelative"; break;
                case "certificate":  ls.call.func = "deleteCertificate"; break;
                case "scholarship":  ls.call.func = "deleteScholarship"; break; 
                case "allowances":  ls.call.func = "deleteAllowances"; break;            
            }   
            ls.call.args = {id:item_id};
            ls.call.info = "discardItem 1"; 
            ArrayAppend(ls.calls, ls.call);	 	        
            
        } else {    
        
            ls.call = {};  
            switch(type){  // Physically delete any updated version
                case "relative":  ls.call.func = "deleteRelative"; break;
                case "certificate":  ls.call.func = "deleteCertificate"; break;
                case "scholarship":  ls.call.func = "deleteScholarship"; break;  
            }    
            ls.call.args = {id:item_id};
            ls.call.info = "discardItem 2"; 
            ArrayAppend(ls.calls, ls.call);	        
                
            ls.call = {};            
            switch(type){  // Copy Main record to Alt
                case "relative":  ls.call.func = "copyRelative"; break;
                case "certificate":  ls.call.func = "copyCertificate"; break;
                case "scholarship":  ls.call.func = "copyScholarship"; break;  
            }  
            ls.call.args = {id:item_id};
            ls.call.info = "discardItem 3"; 
            ArrayAppend(ls.calls, ls.call);	     
            
            ls.call = {};            
            switch(type){  // Set Alt record for logical deletion
                case "relative":  ls.call.func = "removeRelative"; break;
                case "certificate":  ls.call.func = "removeCertificate"; break;
                case "scholarship":  ls.call.func = "removeScholarship"; break;                            
            }             
            ls.call.args = {username:args.username, id:item_id};
            ls.call.info = "discardItem 4"; 
            ArrayAppend(ls.calls, ls.call);	        
        }      
        
        return ls.calls;	    
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function restoreItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function restoreItem(required string type, required numeric item_id, required struct args, required boolean hasMainItem, required boolean hasAltItem){   	
      	var ls = {}; 
        ls.calls = [];    
		        
		if( hasAltItem == true && isAltItemRemoved(type, item_id) == true){              
            //since alt is a copy of main, let's just delete it
            ls.call = {};
            switch(type){
                case "relative":  ls.call.func = "deleteRelative"; break;
                case "certificate":  ls.call.func = "deleteCertificate"; break;
                case "scholarship":  ls.call.func = "deleteScholarship"; break;            
            }  
            ls.call.args = {id:item_id};
            ls.call.info = "restoreItem"; 
            ArrayAppend(ls.calls, ls.call);	             
		}     
        
        return ls.calls;
	}          
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function isAltItemRemoved
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function isAltItemRemoved(required string type, required numeric item_id){       	   
    
        switch(type){
            case "relative":  return Variables.fdAltDao.isRelativeRemoved(item_id); 
            case "certificate":  return Variables.fdAltDao.isCertificateRemoved(item_id); 
            case "scholarship":  return Variables.fdAltDao.isScholarshipRemoved(item_id);            
        }    
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function createAndUpdateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function createAndUpdateItem(required string type, required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = [];                        
        
        ls.call = {};
        switch(type){
            case "relative":  
            	ls.call.func = "createAndUpdateRelative"; 
		        ls.call.args = {username: args.username, id:item_id, personal_profile_id: args.personal_profile_id, family_link: args.family_link, rc: args.item};    
                ls.call.info = "createAndUpdateItem relative";          
                break;
            case "certificate":  
            	ls.call.func = "createAndUpdateCertificate"; 
                ls.call.args = {username: args.username, id:item_id, staff_member_id:args.staff_member_id, personal_profile_id:args.personal_profile_id, relative_id:args.relative_id, rc:args.item}; 
                ls.call.info = "createAndUpdateItem certificate";
                break; 
            case "scholarship":  
            	ls.call.func = "createAndUpdateScholarship"; 
                ls.call.args = {username: args.username, id:item_id, staff_member_id:args.staff_member_id, personal_profile_id:args.personal_profile_id, relative_id:args.relative_id, rc:args.item}; 
                ls.call.info = "createAndUpdateItem scholarship";
                break;  
        }     
        
        ArrayAppend(ls.calls, ls.call);	        
                
        return ls.calls;	    
    }   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function copyAndUpdateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function copyAndUpdateItem(required string type, required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = []; 
       	ls.call = {};
        
        switch(type){
            case "relative":  
            	ls.call.func = "copyAndUpdateRelative"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "copyAndUpdateItem relative";
                break;
            case "certificate":  
                ls.call.func = "copyAndUpdateCertificate"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "copyAndUpdateItem certificate";
                break; 
            case "scholarship":  
                ls.call.func = "copyAndUpdateScholarship"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "copyAndUpdateItem scholarship";
                break;     
            case "allowances":  
                ls.call.func = "copyAndUpdateAllowances"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "copyAndUpdateItem allowances";
                break;                       
        }  
        
        ArrayAppend(ls.calls, ls.call);	
                
        return ls.calls;	    
    }      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function updateItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public array function updateItem(required string type, required numeric item_id, required struct args){
    	var ls = {}; 
        ls.calls = [];      
       
       	ls.call = {};
        switch(type){
            case "relative":  
            	ls.call.func = "updateRelative"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "updateItem relative";
                break;
            case "certificate":  
                ls.call.func = "updateCertificate"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "updateItem certificate";
                break; 
            case "scholarship":  
                ls.call.func = "updateScholarship"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "updateItem scholarship";
                break;   
            case "allowances":  
                ls.call.func = "updateAllowances"; 
                ls.call.args = {username: args.username, id:item_id, rc:args.item};
                ls.call.info = "updateItem allowances";
                break;                          
        }       
        ArrayAppend(ls.calls, ls.call);	
                
        return ls.calls;	    
    }       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPersonalProfileId
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public numeric function getPersonalProfileId(args) {
    	var ls = {};    
        
        ls.hasPersonalProfile = Variables.fdDao.hasPersonalProfile(args.staff_member_id);
        ls.hasAltPersonalProfile = Variables.fdAltDao.hasPersonalProfile(args.staff_member_id);
        
        //This runs in own transaction    
        if(ls.hasPersonalProfile == false && ls.hasAltPersonalProfile == false){
        	ls.personal_profile_id = Variables.fdAltDao.getNewPersonalProfileId();
            Variables.fdAltDao.createPersonalProfile(args.username, ls.personal_profile_id, args.staff_member_id); 
        }
        else if(ls.hasPersonalProfile == true && ls.hasAltPersonalProfile == false){
        	ls.personal_profile_id = Variables.fdDao.getPersonalProfileQry(args.staff_member_id).id;
            Variables.fdAltDao.copyPersonalProfile(args.staff_member_id);         
        }
        else if(ls.hasAltPersonalProfile == true){
	        ls.personal_profile_id = Variables.fdAltDao.getPersonalProfileQry(args.staff_member_id).id;
        } 
        
/*        if( Variables.fdDao.hasPersonalProfile(args.staff_member_id) == true )
        	ls.personal_profile_id = Variables.fdDao.getPersonalProfileQry(args.staff_member_id).id;
		else {    
        	ls.personal_profile_id = Variables.fdAltDao.getNewPersonalProfileId();	               
		}   
        
        if( Variables.fdAltDao.hasPersonalProfile(args.staff_member_id) == false) {
	        ls.res = Variables.fdAltDao.createPersonalProfile(args.username, ls.personal_profile_id, args.staff_member_id); 
        } */   

        return ls.personal_profile_id;  
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasMainItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function hasMainItem(required string type, required numeric item_id) {
    	var ls = {};    
        
        switch(type){
            case "relative":  return Variables.fdDao.hasRelative(item_id); 
            case "certificate":  return Variables.fdDao.hasCertificate(item_id); 
            case "scholarship":  return Variables.fdDao.hasScholarship(item_id); 
            case "allowances":  return Variables.fdDao.hasAllowances(item_id);             
        }        
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAltItem
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function hasAltItem(required string type, required numeric item_id) {
    	var ls = {};    
        
        switch(type){
            case "relative":  return Variables.fdAltDao.hasRelative(item_id); 
            case "certificate":  return Variables.fdAltDao.hasCertificate(item_id); 
            case "scholarship":  return Variables.fdAltDao.hasScholarship(item_id); 
            case "allowances":  return Variables.fdAltDao.hasAllowances(item_id);            
        }        
    }        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addScholarship
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addScholarship(required struct rc){
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};    
        
        ls.id = Variables.fdAltDao.getNewScholarshipId();     
        
        ls.scholarship = {};        
        ls.scholarship["id"] = ls.id;            
        ls.scholarship["nature"] = "";
        ls.scholarship["monthly_amount"] = "";
        ls.scholarship["academic_year"] = Year( Now() );
        ls.scholarship["deleted"] = "N";
        ls.scholarship["comments"] = "";
        ls.scholarship["scholarship_filename"] = "";  
        
 		ls.retval.data = ls.scholarship;
        
        return ls.retval;         
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addCertificate
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addCertificate(required struct rc){
        ls.retval = {};
        ls.retval["result"] = "OK";
        ls.retval["data"] = {};  
        
        ls.id = Variables.fdAltDao.getNewCertificateId(); 
        
        ls["certificate"] = {};        
            ls.certificate["id"] = ls.id;
	        ls.certificate["reception_date"] = "";
	        ls.certificate["validity_from"] = DateFormat(Now(), "DD/MM/YYYY");
	        ls.certificate["validity_until"] = DateFormat(Now(), "DD/MM/YYYY");
            ls.certificate["deleted"] = "N";
	        ls.certificate["comments"] = "";
	        ls.certificate["certificate_filename"] = "";  
        
 		ls.retval.data = ls.certificate;
        
        return ls.retval;         
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getScholarshipFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function getScholarshipFile( required numeric user_id, required numeric office_id, required numeric staff_member_id, required struct rc ) {     
	    var ls = {}; 
        ls.data = {};    
        ls.scholarship_id = rc.scholarship_id;    
        ls.hash = rc.hash; 
        
        ls.qry = Variables.fdAltDao.getScholarshipFileQry(ls.scholarship_id, ls.hash);                 

		//single-row result expected
        ls.data["fileName"] = ls.qry.upld_name;  
        ls.data["fileData"] = ls.qry.upld_data;
        ls.data["mimeType"] = ls.qry.upld_mime;   
        
 		ls.retval["data"] = ls.data;
        
        return ls.retval;  
	}              
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCertificateFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function getCertificateFile( required numeric user_id, required numeric office_id, required numeric staff_member_id, required struct rc ) {     
	    var ls = {}; 
        ls.data = {};        
        ls.certificate_id = rc.certificate_id; 
        ls.hash = rc.hash;         
        
        ls.qry = Variables.fdAltDao.getCertificateFileQry(ls.certificate_id, ls.hash);                 

		//single-row result expected
        ls.data["fileName"] = ls.qry.upld_name;  
        ls.data["fileData"] = ls.qry.upld_data;
        ls.data["mimeType"] = ls.qry.upld_mime;   
        
 		ls.retval["data"] = ls.data;
        
        return ls.retval;  
	}     
    
    
    
}      