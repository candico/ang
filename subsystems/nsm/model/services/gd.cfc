Component accessors="true" {     
	
	property nsmDao;   
    property gdDao;
    property gdAltDao;  
    property nsmAltDao;   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public string function checkUserPriv(required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
           case("view_gd"):            		
            	ls.chk = Variables.nsmDao.chkViewNsm(user_id, office_id, staff_member_id);                 
                break;  
           case("view_alt_gd"):            		
            	ls.chk = Variables.gdDao.chkViewAltGd(user_id, office_id, staff_member_id);                 
                break;                  
            case("edit_gd"): 
            	ls.chk = Variables.gdDao.chkEditGd(user_id, office_id, staff_member_id); 
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
// Function getGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getGD(required numeric user_id, required numeric office_id, required numeric staff_member_id, required boolean view_alt){
    	var ls = {};	
        ls.staffMember = {};            
        
///////////////////////////////////////////////////////        
// Personal Details
///////////////////////////////////////////////////////
        
        ls.personalDetails = {};        
        ls.personalDetailsQry = variables.gdDao.getPersonalDetailsQry(staff_member_id);  
        ls.personalDetails = getPersonalDetails(ls.personalDetailsQry);
        for(ls.item in ls.personalDetails){
	        ls.staffMember[ls.item] = ls.personalDetails[ls.item];
        }       
        
        ls.altPersonalDetails = {};  
        ls.altPersonalDetailsQry = variables.gdAltDao.getPersonalDetailsQry(staff_member_id);  
        if(view_alt && ls.altPersonalDetailsQry.recordcount != 0){			
	        ls.altPersonalDetails = getPersonalDetails(ls.altPersonalDetailsQry);
            for(ls.item in ls.personalDetails){                        
                if( ls.personalDetails[ls.item] != ls.altPersonalDetails[ls.item] ){
	                if( ls.personalDetails[ls.item] == "")
                    	ls.personalDetails[ls.item] = "[...]";
	                ls.staffMember["personal_details_status_id"] = -1; //INVALID status
	                ls.staffMember["alt"][ls.item] = ls.personalDetails[ls.item];
                    ls.staffMember[ls.item] = ls.altPersonalDetails[ls.item];                                        
                }  
            }              
		}     
        
///////////////////////////////////////////////////////        
// Languages
///////////////////////////////////////////////////////
        
        ls.languages = {};        
        //ls.personalDetailsQry = variables.gdDao.getPersonalDetailsQry(staff_member_id);  //already loaded
        ls.languages = getLanguages(ls.personalDetailsQry);
        for(ls.item in ls.languages){
	        ls.staffMember[ls.item] = ls.languages[ls.item];
        }       
        
        ls.altLanguages = {};  
        //ls.altPersonalDetailsQry = variables.gdAltDao.getPersonalDetailsQry(staff_member_id);  //already loaded
        if(view_alt && ls.altPersonalDetailsQry.recordCount != 0){			
	        ls.altLanguages = getLanguages(ls.altPersonalDetailsQry);
            for(ls.item in ls.languages){                        
                if( ls.languages[ls.item] != ls.altLanguages[ls.item] ){
	                if( ls.languages[ls.item] == "")
                    	ls.languages[ls.item] = "[...]";                
	                ls.staffMember["languages_status_id"] = -1; //INVALID status
	                ls.staffMember["alt"][ls.item] = ls.languages[ls.item];
                    ls.staffMember[ls.item] = ls.altLanguages[ls.item];                                        
                }  
            }              
		}   
        
/*                    
        
///////////////////////////////////////////////////////        
// Banking Details
///////////////////////////////////////////////////////
        
        ls.bankingDetails = {};        
        //ls.personalDetailsQry = variables.gdDao.getPersonalDetailsQry(staff_member_id);  //already loaded
        ls.bankingDetails = getBankingDetails(ls.personalDetailsQry);
        for(ls.item in ls.bankingDetails){
	        ls.staffMember[ls.item] = ls.bankingDetails[ls.item];
        }       
        
        ls.altBankingdetails = {};  
        //ls.altPersonalDetailsQry = variables.gdAltDao.getPersonalDetailsQry(staff_member_id);  //already loaded
        if(view_alt && ls.altPersonalDetailsQry.recordCount != 0){			
	        ls.altBankingdetails = getBankingDetails(ls.altPersonalDetailsQry);
            for(ls.item in ls.bankingDetails){                        
                if( ls.bankingDetails[ls.item] != ls.altBankingDetails[ls.item] ){
	                if( ls.bankingDetails[ls.item] == "")
                    	ls.bankingDetails[ls.item] = "[...]";                 
	                ls.staffMember["banking_details_status_id"] = -1; //INVALID status
	                ls.staffMember["alt"][ls.item] = ls.bankingDetails[ls.item];
                    ls.staffMember[ls.item] = ls.altBankingDetails[ls.item];                                        
                }  
            }              
		}  
        
*/         
        
///////////////////////////////////////////////////////        
// Bank Accounts
///////////////////////////////////////////////////////     

        ls.bankAccounts = [];        
        ls.bankAccountsQry = variables.gdDao.getBankAccountsQry(staff_member_id);  
        ls.bankAccounts = getBankAccounts(ls.bankAccountsQry); //this is an array
        ls.staffMember["bankAccounts"] = ls.bankAccounts;       
        
        ls.altBankAccounts = [];  
        ls.altBankAccountsQry = variables.gdAltDao.getBankAccountsQry(staff_member_id);  
        
        if(view_alt && ls.altBankAccountsQry.recordCount != 0){
	        ls.altBankAccounts = getBankAccounts(ls.altBankAccountsQry);  //this is an array       
            //overwrite        
            for(ls.bankAccount in ls.bankAccounts){  
                ls.id = ls.bankAccount.id;                
                
                //let's try to find an alt version
                ls.found = false;
                for(ls.altBankAccount in ls.altBankAccounts){
                	if(ls.altBankAccount.id == ls.id){
	                    ls.found = true;
                        break;
					}                        
                }
                
                ls.bankAccountChanged = false;
                if( ls.found == true ){                                 
                    //ls.altBankAccount set above                          
                    for(ls.item in ls.bankAccount){   
                        if( ls.bankAccount[ls.item] != ls.altBankAccount[ls.item] ){     
                        	ls.bankAccountChanged = true;                      	  
	    		            if( ls.bankAccount[ls.item] == "")
		                    	ls.bankAccount[ls.item] = "[...]";                                            
	                        ls.staffMember["alt"]["bankAccounts"][ls.id][ls.item] = ls.bankAccount[ls.item];
                            ls.bankAccount[ls.item] = ls.altBankAccount[ls.item];                            
                        }  
                    } 

                    if( ls.bankAccountChanged == true )
	                    ls.bankAccount["status"] = "updated"; 
                    
					if(ls.altBankAccount.bank_deleted == "Y"){
                        ls.staffMember["alt"]["bankAccounts"][ls.id].bank_deleted = ls.bankAccount.bank_deleted;
                        ls.bankAccount.bank_deleted = ls.altBankAccount.bank_deleted; 
                        ls.bankAccount["status"] = "deleted";
                    }                       
                } 
            }  
			
            //add new bank accounts             
           for(ls.altBankAccount in ls.altBankAccounts){
	            ls.found = false;
                for(ls.bankAccount in ls.bankAccounts){
                	if(ls.altBankAccount.id == ls.bankAccount.id){
	                    ls.found = true;
					}                        
                }
                if(ls.found == false){	    
	                ls.altBankAccount["status"] = "new";                                
                	ArrayAppend(ls.staffMember["bankAccounts"], ls.altBankAccount);
                }
			 }                          
		}                 
        
///////////////////////////////////////////////////////        
// Family Details
///////////////////////////////////////////////////////
        
        ls.familyDetails = {};        
        ls.familyDetailsQry = variables.gdDao.getFamilyDetailsQry(staff_member_id);  
        ls.familyDetails = getFamilyDetails(ls.familyDetailsQry);
        for(ls.item in ls.familyDetails){
	       ls.staffMember[ls.item] = ls.familyDetails[ls.item];
        }          
        
        ls.altFamilyDetails = {};  
        ls.altFamilyDetailsQry = variables.gdAltDao.getFamilyDetailsQry(staff_member_id);  
        
        if(view_alt && ls.altFamilyDetailsQry.recordcount != 0){
	        ls.staffMember["family_details_status_id"] = -1; //INVALID status
	        ls.altFamilyDetails = getFamilyDetails(ls.altFamilyDetailsQry);
            for(ls.item in ls.familyDetails){     
                if( ls.familyDetails[ls.item] != ls.altFamilyDetails[ls.item] ){
	                if( ls.familyDetails[ls.item] == "")
                    	ls.familyDetails[ls.item] = "[...]";                
	                ls.staffMember["alt"][ls.item] = ls.familyDetails[ls.item];
                    ls.staffMember[ls.item] = ls.altFamilyDetails[ls.item];                    
                }  
            }  
		}  
        
///////////////////////////////////////////////////////        
// Relatives Details
///////////////////////////////////////////////////////
        
        ls.relatives = {};            
        
        ls.staffMember["childrenCount"] = 0;
        ls.staffMember["dependentsCount"] = 0;     
             
        ls.relativesQry = variables.gdDao.getRelativesQry(staff_member_id);         
        if(ls.relativesQry.recordcount != 0){
        
            for(ls.row in ls.relativesQry){
                ls.relatives[ls.row.id]['familylink'] = ls.row.familylink;
                ls.relatives[ls.row.id]['dependent'] = ls.row.dependent;     
                ls.relatives[ls.row.id]['deleted'] = ls.row.deleted;                  
            }  
            
            ls.staffMember["childrenCount"] = countChildren(ls.relatives);
        	ls.staffMember["dependentsCount"] = countDependents(ls.relatives); 
        }
        
        ls.altRelativesQry = variables.gdAltDao.getRelativesQry(staff_member_id);
        if(view_alt && ls.altRelativesQry.recordcount != 0){
        
        	//first copy initial values
	        ls.altRelatives = duplicate(ls.relatives);
             
            //then add or update
            for(ls.row in ls.altRelativesQry){
                ls.altRelatives[ls.row.id]['familylink'] = ls.row.familylink;
                ls.altRelatives[ls.row.id]['dependent'] = ls.row.dependent;     
                ls.altRelatives[ls.row.id]['deleted'] = ls.row.deleted;                  
            }                      
            
            ls.altChildrenCount = countChildren(ls.altRelatives);
            if( ls.altChildrenCount != ls.staffMember["childrenCount"] ) {   
            	//swap
                ls.staffMember["alt"]["childrenCount"] = ls.staffMember["childrenCount"];   
	            ls.staffMember["childrenCount"] = ls.altChildrenCount;  
			}                
            
            ls.altDependentsCount = countDependents(ls.altRelatives); 
            if( ls.altDependentsCount != ls.staffMember["dependentsCount"] ) {
            	//swap
	        	ls.staffMember["alt"]["dependentsCount"] = ls.staffMember["dependentsCount"]; 
                ls.staffMember["dependentsCount"] = ls.altDependentsCount;                                
			}                
		}          
        
///////////////////////////////////////////////////////        
// Business Address
///////////////////////////////////////////////////////
        
        ls.businessAddress = {};        
        ls.addressesQry = variables.gdDao.getAddressesQry(staff_member_id);  
        ls.businessAddress = getBusinessAddress(ls.addressesQry);
        for(ls.item in ls.businessAddress){
	      ls.staffMember[ls.item] = ls.businessAddress[ls.item];
        }                   
        
        ls.altBusinessAddress = {};  
        ls.altAddressesQry = variables.gdAltDao.getAddressesQry(staff_member_id);  
        
        if(view_alt && ls.altAddressesQry.recordcount != 0){
	        ls.staffMember["address_status_id"] = -1; //INVALID status
	        ls.altBusinessAddress = getBusinessAddress(ls.altAddressesQry);
            for(ls.item in ls.businessAddress){ 
                if( ls.businessAddress[ls.item] != ls.altBusinessAddress[ls.item] ){
	                ls.staffMember["business_address_status_id"] = -1; //INVALID status
	                if(ls.businessAddress[ls.item] == "")
                    	ls.businessAddress[ls.item] = "[...]";                
	                ls.staffMember["alt"][ls.item] = ls.businessAddress[ls.item];
                    ls.staffMember[ls.item] = ls.altBusinessAddress[ls.item];                    
                }  
            }      
		}    
        
///////////////////////////////////////////////////////        
// Private Address
///////////////////////////////////////////////////////
        
        ls.privateAddress = {};                
        //ls.addressesQry = variables.gdDao.getAddressesQry(staff_member_id);  //already loaded
        ls.privateAddress = getPrivateAddress(ls.addressesQry);
        for(ls.item in ls.privateAddress){
	      ls.staffMember[ls.item] = ls.privateAddress[ls.item];
        }                   
        
        ls.altPrivateAddress = {};  
        //ls.altPrivateAddressQry = variables.gdAltDao.getAddressesQry(staff_member_id);  //already loaded
        if(view_alt && ls.altAddressesQry.recordcount != 0){	        
	        ls.altPrivateAddress = getPrivateAddress(ls.altAddressesQry);
            for(ls.item in ls.privateAddress){ 
                if( ls.privateAddress[ls.item] != ls.altPrivateAddress[ls.item] ){
	                ls.staffMember["private_address_status_id"] = -1; //INVALID status
	                if(ls.privateAddress[ls.item] == "")
                    	ls.privateAddress[ls.item] = "[...]";                
	                ls.staffMember["alt"][ls.item] = ls.privateAddress[ls.item];
                    ls.staffMember[ls.item] = ls.altPrivateAddress[ls.item];                    
                }  
            }      
		}               
        
///////////////////////////////////////////////////////        
// Medicals
///////////////////////////////////////////////////////     

        ls.medicals = [];        
        ls.medicalsQry = variables.gdDao.getMedicalsQry(staff_member_id);  
        ls.medicals = getMedicals(ls.medicalsQry); //this is an array
        ls.staffMember["medicals"] = ls.medicals;
        //ls.staffMember["medicals_status_id"] = 1; //VALID status
        
        ls.altMedicals = [];  
        ls.altMedicalsQry = variables.gdAltDao.getMedicalsQry(staff_member_id);  
        
        if(view_alt && ls.altMedicalsQry.recordCount != 0){
	        //ls.staffMember["medicals_status_id"] = -1; //INVALID status
	        ls.altMedicals = getMedicals(ls.altMedicalsQry);  //this is an array       
            //overwrite        
            for(ls.medical in ls.medicals){  
                ls.id = ls.medical.id;                
                
                //let's try to find an alt version
                ls.found = false;
                for(ls.altMedical in ls.altMedicals){
                	if(ls.altMedical.id == ls.id){
	                    ls.found = true;
                        break;
					}                        
                }
                
                ls.medicalChanged = false;
                if( ls.found == true ){                                 
                    //ls.staffMember["alt"]["medicals"][ls.id] = {};       
                    //ls.altMedical set above                          
                    for(ls.item in ls.medical){   
                        if( ls.medical[ls.item] != ls.altMedical[ls.item] ){     
                        	ls.medicalChanged = true;                      	  
	    		            if( ls.medical[ls.item] == "")
		                    	ls.medical[ls.item] = "[...]";                                            
	                        ls.staffMember["alt"]["medicals"][ls.id][ls.item] = ls.medical[ls.item];
                            ls.medical[ls.item] = ls.altMedical[ls.item];                            
                        }  
                    } 
                    //ls.medical["status_id"] = -1; //INVALID status  
                    if( ls.medicalChanged == true )
	                    ls.medical["status"] = "updated"; 
                    
					if(ls.altMedical.medical_deleted == "Y"){
                        ls.staffMember["alt"]["medicals"][ls.id].medical_deleted = ls.medical.medical_deleted;
                        ls.medical.medical_deleted = ls.altMedical.medical_deleted; 
                        ls.medical["status"] = "deleted";
                    }                       
                } 
            }  
			
            //add new medicals             
           for(ls.altMedical in ls.altMedicals){
	            ls.found = false;
                for(ls.medical in ls.medicals){
                	if(ls.altMedical.id == ls.medical.id){
	                    ls.found = true;
					}                        
                }
                if(ls.found == false){	    
	                ls.altMedical["status"] = "new";             
                    //ls.altMedical["status_id"] = 0; //INITIAL status 
                	ArrayAppend(ls.staffMember["medicals"], ls.altMedical);
                }
			 }                          
		}              
        
///////////////////////////////////////////////////////        
// Documents
///////////////////////////////////////////////////////          
        
        ls.documents = {};        
        ls.documentsQry = variables.gdDao.getDocumentsQry(staff_member_id);  
        ls.documents = getDocuments(ls.documentsQry);  
        
        for(ls.item in ls.documents){
	     ls.staffMember[ls.item] = ls.documents[ls.item];
        }               
        
        ls.altDocuments = {};  
        ls.altDocumentsQry = variables.gdAltDao.getDocumentsQry(staff_member_id);  
        
        if(view_alt && ls.altDocumentsQry.recordcount != 0){
        
			ls.staffMember["documents_status_id"] = -1; //INVALID status
	        ls.altDocuments = getDocuments(ls.altDocumentsQry);            
            
            for(ls.item in ls.documents){               
            
            	if( FindNoCase("_filename", ls.item) != 0 ){
            
                    if(ls.documents[ls.item] != "" && ls.altDocuments[ls.item] == "") {
                        //document is marked for deletion
                        ls.deletedFlag = ls.item & "_deleted"; 
                        ls.staffMember["alt"][ls.deletedFlag] = "Y";
                    }                
                }
            
                if( ls.altDocuments[ls.item] != "" && (ls.documents[ls.item] != ls.altDocuments[ls.item]) ){
                
	                if( ls.documents[ls.item] == "")
                    	ls.documents[ls.item] = "[...]";
                        
                    ls.staffMember[ls.item] = ls.altDocuments[ls.item];
                    ls.staffMember["alt"][ls.item] = ls.documents[ls.item];
                }  
                
            } 
            
		}                        
        
///////////////////////////////////////////////////////        
// Returning
///////////////////////////////////////////////////////  
        
        return ls.staffMember;   
	}   
    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function countChildren
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public numeric function countChildren(required struct relatives) {   
    	var ls = {};
        ls.count = 0;
        
        for (ls.id in relatives){  
        
        	if( relatives[ls.id].familylink == "CHIL" && relatives[ls.id].deleted == "N" )
            	ls.count++;
        }    
        
        return ls.count;
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function countDependents
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public numeric function countDependents(required struct relatives) {    
    	var ls = {};
        ls.count = 0;
        
        for (ls.id in relatives){
        
        	if( relatives[ls.id].dependent == "Y" && relatives[ls.id].deleted == "N" )
            	ls.count++;
        }    
        
        return ls.count;   
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPersonalDetails
// Includes languages, citizenship, banking details (from TBL_EXTERNS)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getPersonalDetails(personalDetailsQry) { 
    
		var ls = {};
        ls.personalDetails = {};        
             
		ls.personalDetails['staff_member_id'] = personalDetailsQry.staff_member_id;			
        //ls.personalDetails['contract_id'] = personalDetailsQry.contract_id; 
        
        ls.personalDetails['civility'] = personalDetailsQry.civility;	
        ls.personalDetails['last_name'] = personalDetailsQry.last_name;			
        ls.personalDetails['first_name'] = personalDetailsQry.first_name;			      
        ls.personalDetails['maiden_name'] = personalDetailsQry.maiden_name;			              
        ls.personalDetails['gender'] = personalDetailsQry.gender;	
        ls.personalDetails['birth_country_code'] = personalDetailsQry.birth_country_code;	
        ls.personalDetails['birth_country'] = personalDetailsQry.birth_country;  
        ls.personalDetails['date_of_birth'] = personalDetailsQry.date_of_birth;	
        //ls.personalDetails['age'] = personalDetailsQry.age;
        ls.personalDetails['age'] = 0;
        
        ls.personalDetails['citizenship_1_country_code'] = personalDetailsQry.citizenship_1_country_code;	
        ls.personalDetails['citizenship_1_country'] = personalDetailsQry.citizenship_1_country;	    
		ls.personalDetails['citizenship_2_country_code'] = personalDetailsQry.citizenship_2_country_code;	
        ls.personalDetails['citizenship_2_country'] = personalDetailsQry.citizenship_2_country;   
          
		//ls.personalDetails['citizenship_3_country_code'] = personalDetailsQry.citizenship_3_country_code;	
        //ls.personalDetails['citizenship_3_country'] = personalDetailsQry.citizenship_3_country;  
        
        ls.personalDetails['other_citizenships'] = personalDetailsQry.other_citizenships;
        
        ls.personalDetails['comments'] = personalDetailsQry.comments;	      
        
		ls.personalDetails['social_security_number'] = personalDetailsQry.social_security_number;        
        ls.personalDetails['date_of_death'] = personalDetailsQry.date_of_death;                
        
        return ls.personalDetails;        
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getLanguages (from TBL_EXTERNS)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getLanguages(personalDetailsQry) { 
    
		var ls = {};
        ls.languages = {};     
        
      	ls.languages['language_1_id'] = personalDetailsQry.language_1_id;	
        ls.languages['language_1'] = personalDetailsQry.language_1;	    
		ls.languages['language_2_id'] = personalDetailsQry.language_2_id;		
        ls.languages['language_2'] = personalDetailsQry.language_2;    
        ls.languages['language_3'] = personalDetailsQry.language_3;                 
        
        return ls.languages;        
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getBankAccounts (from TBL_BANK_ACCOUNT)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public array function getBankAccounts(bankAccountsQry) {    
       
    	var ls  = {};
        ls.accounts = [];  
       
		for(ls.row in bankAccountsQry) {
        	ls.account = {}; 
            
            ls.account['id'] = ls.row.id;             
            ls.account['bank_name'] = ls.row.bank_name;    
            ls.account['bank_address'] = ls.row.bank_address;            
            ls.account['bank_account_holder'] = ls.row.bank_account_holder;
            ls.account['bank_iban'] = ls.row.bank_iban; 
            ls.account['bank_bic'] = ls.row.bank_bic;
  			ls.account["status_id"] = 1; //VALID status
            ls.account["bank_deleted"] = ls.row.deleted;
                      
            ArrayAppend(ls.accounts, ls.account); 
        }        
        
        return ls.accounts;  
	}    
        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFamilyDetails (from TBL_PERSONALPROFILES)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getFamilyDetails(familyDetailsQry) {  
    
		var ls = {};
        ls.familyDetails = {};               
       
        ls.familyDetails['ms_status'] = familyDetailsQry.marital_status; //ms_status
        ls.familyDetails['ms_effective_from'] = familyDetailsQry.sincedate; //ms_effective_from
        ls.familyDetails['ms_country_code'] = familyDetailsQry.countryid; //ms_country_code
        ls.familyDetails['ms_country'] = familyDetailsQry.country_en;
        
        //Dependents (from XXXX)
        ls.familyDetails['nbr_of_children'] = "3";
        ls.familyDetails['nbr_of_dependents'] = "5";     
        
        return  ls.familyDetails; 
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getBusinessAddress (from TBL_RESIDENCES)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getBusinessAddress(addressesQry) {   
    
		var ls = {};
        ls.businessAddress = {};           
       
        //Business address 
        //Contact in country of origin
		//ls.businessAddress['business_address_id'] = addressesQry.id;
   		ls.businessAddress['address_id'] = addressesQry.id;
        
        ls.businessAddress['business_address_street'] = addressesQry.addressline1;	
        ls.businessAddress['business_address_city'] = addressesQry.city;	
        ls.businessAddress['business_address_postal_code'] = addressesQry.postalcode; 
        ls.businessAddress['business_address_country_code'] = addressesQry.countryid; 
        ls.businessAddress['business_address_country'] = addressesQry.business_ctry_en; 
        ls.businessAddress['business_address_effective_from'] = addressesQry.validitydate; 
        
        return ls.businessAddress;  
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPrivateAddress (from TBL_RESIDENCES)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getPrivateAddress(addressesQry) {   
    
		var ls = {};
        ls.privateAddress = {};   
        
        //Private address 
        //Contact in country of residence
        //ls.privateAddress['private_address_id'] = addressesQry.id;	
        ls.privateAddress['private_address_street'] = addressesQry.private_address;	
        ls.privateAddress['private_address_city'] = addressesQry.private_city;	
        ls.privateAddress['private_address_postal_code'] = addressesQry.private_postalcode; 
        ls.privateAddress['private_address_country'] = addressesQry.private_ctry_en; 
        ls.privateAddress['private_address_country_code'] = addressesQry.private_countryid;  
        ls.privateAddress['private_address_phone_nbr'] = addressesQry.phonenumber;     
        ls.privateAddress['private_mobile_nbr_1'] = addressesQry.mobilnumber;       
        ls.privateAddress['private_mobile_nbr_2'] = addressesQry.mobilnumber2;   
        //ls.privateAddress['private_email'] = addressesQry.email;  
        ls.privateAddress['life_3_months'] = addressesQry.life_3_months;  
        
        return ls.privateAddress;  
	}           
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getMedicals (from TBL_MEDIC_CERTIFICATE)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public array function getMedicals(medicalsQry) {    
       
    	var ls  = {};
        ls.medicals = [];  
       
		for(ls.row in medicalsQry) {
        	ls.medical = {};              
            ls.medical["id"] = ls.row.id;
            ls.medical["medical_remarks"] = ls.row.remarks;
            ls.medical["medical_version"] = ls.row.version;
            ls.medical["medical_externid"] = ls.row.externid;
            ls.medical["medical_valid_from"] = ls.row.validity_from;
            ls.medical["medical_valid_until"] = ls.row.validity_to;
            ls.medical["medical_status"] = ls.row.status;
            ls.medical["medical_center"] = ls.row.medical_center;
            ls.medical["medical_filename"] = ls.row.upld_name;
            ls.medical["medical_mime_type"] = ls.row.upld_mime;
            ls.medical["medical_hash"] = ls.row.upld_hash;
            ls.medical["status_id"] = 1; //VALID status
            ls.medical["medical_deleted"] = ls.row.deleted;
                      
            ArrayAppend(ls.medicals, ls.medical); 
        }        
        
        return ls.medicals;  
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDocuments (from TBL_ADM_DOC)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     

	public struct function getDocuments(documentsQry) {  
    
    	var ls  = {};
        ls.documents = {};     
    
        //Driving Licence
        ls.documents['doc_dl_country'] = documentsQry.dl_ctry_en;	
        ls.documents['doc_dl_country_code'] = documentsQry.dl_ctry;
        ls.documents['doc_dl_doc_nbr'] = documentsQry.dl_doc_nbr;	
        ls.documents['doc_dl_valid_from'] = documentsQry.dl_start_date;	
        ls.documents['doc_dl_valid_until'] = documentsQry.dl_end_date;	
        ls.documents['doc_dl_issued_by'] = documentsQry.dl_deliv_by;	
        ls.documents['doc_dl_issued_at'] = documentsQry.dl_deliv_at;	
        ls.documents['doc_dl_filename'] = documentsQry.dl_upld_name;	
        ls.documents['doc_dl_hash'] = documentsQry.dl_upld_hash;	        
        
        //Passport
        ls.documents['doc_pass_country'] = documentsQry.pass_ctry_en;	
        ls.documents['doc_pass_country_code'] = documentsQry.pass_ctry;	
        ls.documents['doc_pass_doc_nbr'] = documentsQry.pass_doc_nbr;	
        ls.documents['doc_pass_valid_from'] = documentsQry.pass_start_date;	
        ls.documents['doc_pass_valid_until'] = documentsQry.pass_end_date;	
        ls.documents['doc_pass_issued_by'] = documentsQry.pass_deliv_by;	
        ls.documents['doc_pass_issued_at'] = documentsQry.pass_deliv_at;       
        ls.documents['doc_pass_filename'] = documentsQry.pass_upld_name;       
        ls.documents['doc_pass_hash'] = documentsQry.pass_upld_hash;	
        
        //Passport 2
        ls.documents['doc_pass2_country'] = documentsQry.pass2_ctry_en;	
        ls.documents['doc_pass2_country_code'] = documentsQry.pass2_ctry;	
        ls.documents['doc_pass2_doc_nbr'] = documentsQry.pass2_doc_nbr;	
        ls.documents['doc_pass2_valid_from'] = documentsQry.pass2_start_date;	
        ls.documents['doc_pass2_valid_until'] = documentsQry.pass2_end_date;	
        ls.documents['doc_pass2_issued_by'] = documentsQry.pass2_deliv_by;	
        ls.documents['doc_pass2_issued_at'] = documentsQry.pass2_deliv_at;  
        ls.documents['doc_pass2_filename'] = documentsQry.pass2_upld_name;    
		ls.documents['doc_pass2_hash'] = documentsQry.pass2_upld_hash;	            
        
        //Residence Permit 
        ls.documents['doc_rp_country'] = documentsQry.rp_ctry_en;	
        ls.documents['doc_rp_country_code'] = documentsQry.rp_ctry;	
        ls.documents['doc_rp_doc_nbr'] = documentsQry.rp_doc_nbr;	
        ls.documents['doc_rp_valid_from'] = documentsQry.rp_start_date;	
        ls.documents['doc_rp_valid_until'] = documentsQry.rp_end_date;	
        ls.documents['doc_rp_issued_by'] = documentsQry.rp_deliv_by;	
        ls.documents['doc_rp_issued_at'] = documentsQry.rp_deliv_at;   
		ls.documents['doc_rp_filename'] = documentsQry.rp_upld_name;        
		ls.documents['doc_rp_hash'] = documentsQry.rp_upld_hash;	                       
        
        //Work Permit (Work Licence)
        ls.documents['doc_wl_country'] = documentsQry.wl_ctry_en;	
        ls.documents['doc_wl_country_code'] = documentsQry.wl_ctry;	
        ls.documents['doc_wl_doc_nbr'] = documentsQry.wl_doc_nbr;	
        ls.documents['doc_wl_valid_from'] = documentsQry.wl_start_date;	
        ls.documents['doc_wl_valid_until'] = documentsQry.wl_end_date;	
        ls.documents['doc_wl_issued_by'] = documentsQry.wl_deliv_by;	
        ls.documents['doc_wl_issued_at'] = documentsQry.wl_deliv_at;   
		ls.documents['doc_wl_filename'] = documentsQry.wl_upld_name;               
		ls.documents['doc_wl_hash'] = documentsQry.wl_upld_hash;	            
        
        //ECHO field badge
        ls.documents['doc_ebdg_country'] = documentsQry.ebdg_ctry_en;	
        ls.documents['doc_ebdg_country_code'] = documentsQry.ebdg_ctry;	
        ls.documents['doc_ebdg_doc_nbr'] = documentsQry.ebdg_doc_nbr;	
        ls.documents['doc_ebdg_valid_from'] = documentsQry.ebdg_start_date;	
        ls.documents['doc_ebdg_valid_until'] = documentsQry.ebdg_end_date;	
        ls.documents['doc_ebdg_issued_by'] = documentsQry.ebdg_deliv_by;	
        ls.documents['doc_ebdg_issued_at'] = documentsQry.ebdg_deliv_at;    
        ls.documents['doc_ebdg_filename'] = documentsQry.ebdg_upld_name;     
		ls.documents['doc_ebdg_hash'] = documentsQry.ebdg_upld_hash;	            
        
	    //DUE office badge
        ls.documents['doc_dbdg_country'] = documentsQry.dbdg_ctry_en;	
        ls.documents['doc_dbdg_country_code'] = documentsQry.dbdg_ctry;	
        ls.documents['doc_dbdg_doc_nbr'] = documentsQry.dbdg_doc_nbr;	
        ls.documents['doc_dbdg_valid_from'] = documentsQry.dbdg_start_date;	
        ls.documents['doc_dbdg_valid_until'] = documentsQry.dbdg_end_date;	
        ls.documents['doc_dbdg_issued_by'] = documentsQry.dbdg_deliv_by;	
        ls.documents['doc_dbdg_issued_at'] = documentsQry.dbdg_deliv_at; 
        ls.documents['doc_dbdg_filename'] = documentsQry.dbdg_upld_name;   
		ls.documents['doc_dbdg_hash'] = documentsQry.dbdg_upld_hash;	        
        
	    //Laissez-passer
        ls.documents['doc_lap_country'] = documentsQry.lap_ctry_en;	
        ls.documents['doc_lap_country_code'] = documentsQry.laiss_ctry;	
        ls.documents['doc_lap_doc_nbr'] = documentsQry.laiss_doc_nbr;	
        ls.documents['doc_lap_valid_from'] = documentsQry.laiss_start_date;	
        ls.documents['doc_lap_valid_until'] = documentsQry.laiss_end_date;	
        ls.documents['doc_lap_issued_by'] = documentsQry.laiss_deliv_by;	
        ls.documents['doc_lap_issued_at'] = documentsQry.laiss_deliv_at;  
        ls.documents['doc_lap_filename'] = documentsQry.laiss_upld_name;   	
		ls.documents['doc_lap_hash'] = documentsQry.laiss_upld_hash;	    
        
	    //"Juridical Report"
        ls.documents['doc_jurep_country'] = documentsQry.jurep_ctry_en;	
        ls.documents['doc_jurep_country_code'] = documentsQry.jurep_ctry;	
        ls.documents['doc_jurep_doc_nbr'] = documentsQry.jurep_doc_nbr;	
        ls.documents['doc_jurep_valid_from'] = documentsQry.jurep_start_date;	
        ls.documents['doc_jurep_valid_until'] = documentsQry.jurep_end_date;	
        ls.documents['doc_jurep_issued_by'] = documentsQry.jurep_deliv_by;	
        ls.documents['doc_jurep_issued_at'] = documentsQry.jurep_deliv_at;  
        ls.documents['doc_jurep_filename'] = documentsQry.jurep_upld_name;   	
		ls.documents['doc_jurep_hash'] = documentsQry.jurep_upld_hash;	        
        
	    //CV 
        ls.documents['doc_cv_filename'] = documentsQry.cv_upld_name;   	
		ls.documents['doc_cv_hash'] = documentsQry.cv_upld_hash;	            
        
        return ls.documents;  
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInExternData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChangeInExternData(required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        
        ls.retval.data["changed"] = false;    
        ls.retval.data["changes"] = {};  
        ls.fields = getRcToDbForExtern();          
  
		ls.qry = variables.gdAltDao.getPersonalDetailsQry(staff_member_id);
        if(ls.qry.recordCount == 0) {
	        ls.qry = variables.gdDao.getPersonalDetailsQry(staff_member_id);
        }
        
        //single result row expected
        for(ls.field in ls.fields) {	
	        ls.dbField = ls.fields[ls.field];
        	ls.oldval = ls.qry[ls.dbField];
            
			if(!StructKeyExists(rc, ls.field)) //GENDER is a radio that does not always exist
            	rc[ls.field] = "";              
            
            ls.newval = rc[ls.field];        		 
        	if(ls.oldval != ls.newval) {       	
            	ls.changedItem = {};            	
                ls.changedItem["oldval"] = ls.oldval; 
                ls.changedItem["newval"] = ls.newval;  
                ls.retval.data.changes[ls.field] = ls.changedItem;            
            	ls.retval.data.changed = true; 
            }  
        }         
        
        return ls.retval;
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRcToDbForExtern
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getRcToDbForExtern() {  
    	var ls = {};
         
    	ls.rcToDb = {};  
    	       
        ls.rcToDb["LAST_NAME"] = "LAST_NAME"; 
        ls.rcToDb["FIRST_NAME"] = "FIRST_NAME"; 
        ls.rcToDb["MAIDEN_NAME"] = "MAIDEN_NAME";  
        ls.rcToDb["GENDER"] = "GENDER";
        ls.rcToDb["SOCIAL_SECURITY_NUMBER"] = "SOCIAL_SECURITY_NUMBER";   
        ls.rcToDb["DATE_OF_BIRTH"] = "DATE_OF_BIRTH";     
        ls.rcToDb["DATE_OF_DEATH"] = "DATE_OF_DEATH";                  
        ls.rcToDb["BIRTH_COUNTRY_CODE"] = "BIRTH_COUNTRY_CODE";   
        ls.rcToDb["CITIZENSHIP_1_COUNTRY_CODE"] = "CITIZENSHIP_1_COUNTRY_CODE"; 
        ls.rcToDb["CITIZENSHIP_2_COUNTRY_CODE"] = "CITIZENSHIP_2_COUNTRY_CODE"; 
        // ls.rcToDb["CITIZENSHIP_3_COUNTRY_CODE"] = "CITIZENSHIP_3_COUNTRY_CODE";
        ls.rcToDb["OTHER_CITIZENSHIPS"] = "OTHER_CITIZENSHIPS"; 
        ls.rcToDb["COMMENTS"] = "COMMENTS"; 
        ls.rcToDb["LANGUAGE_1_ID"] = "LANGUAGE_1_ID"; 
        ls.rcToDb["LANGUAGE_2_ID"] = "LANGUAGE_2_ID"; 
        ls.rcToDb["LANGUAGE_3"] = "LANGUAGE_3"; 
               	
		return ls.rcToDb;         
    }  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInMaritalStatus
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChangeInMaritalStatus(required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        
        ls.retval.data["changed"] = false;    
        ls.retval.data["changes"] = {};  
        ls.fields = getRcToDbForMaritalStatus();  
              
        ls.qry = variables.gdAltDao.getFamilyDetailsQry(staff_member_id); 
        if(ls.qry.recordcount == 0){
	        ls.qry = variables.gdDao.getFamilyDetailsQry(staff_member_id); 
        }        
        
        //single result row expected
        for(ls.field in ls.fields) {	
        	ls.dbField = ls.fields[ls.field];
        	ls.oldval = ls.qry[ls.dbField];
            ls.newval = rc[ls.field];
        	if(ls.oldval != ls.newval) {                 	
            	ls.changedItem = {};            	
                ls.changedItem["oldval"] = ls.oldval;                 
                ls.changedItem["newval"] = ls.newval;                 
				ls.retval.data.changes[ls.field] = ls.changedItem;                
            	ls.retval.data.changed = true; 
            }  
        }         
        
        return ls.retval;
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRcToDbForMaritalStatus
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getRcToDbForMaritalStatus() {  
    	var ls = {};
         
    	ls.rcToDb = {};  
    	       
        ls.rcToDb["MS_STATUS"] = "MARITAL_STATUS"; 
        ls.rcToDb["MS_EFFECTIVE_FROM"] = "SINCEDATE";
        ls.rcToDb["MS_COUNTRY_CODE"] = "COUNTRYID"; 
               	
		return ls.rcToDb;         
    }  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getMaritalStatusesMap
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getMaritalStatusesMap() {  
    	var ls = {};
         
    	ls.map = {}; 
        
        ls.map[""] = 0; 
        ls.map["MAR"] = 1;
        ls.map["SEP"] = 3;
        ls.map["DIV"] = 5;
        ls.map["WID"] = 7;
        ls.map["SIN"] = 9;
        ls.map["CIV"] = 11;
                       	
		return ls.map;         
    }      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInAddresses
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChangeInAddresses(required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        
        ls.retval.data["changed"] = false;    
        ls.retval.data["changes"] = {};  
        ls.fields = getRcToDbForAddresses();     
        
        if(!StructKeyExists(rc, "LIFE_3_MONTHS")) //LIFE_3_MONTHS is a radio that does not always exist
            rc["LIFE_3_MONTHS"] = "";                 
              
        ls.qry = variables.gdAltDao.getAddressesQry(staff_member_id); 
        if(ls.qry.recordCount == 0){
	        ls.qry = variables.gdDao.getAddressesQry(staff_member_id); 
            if(ls.qry.recordCount == 0){
                //No address 
                ls.retval.data.createAddress = true;     
                for(ls.field in ls.fields) {
                	if( rc[ls.field] != "" ){
	                    ls.retval.data.changed = true;
                        break;
                    }
                }           
                return ls.retval;
            }            
        }
                
        //single result row expected
        for(ls.field in ls.fields) {	
        	ls.dbField = ls.fields[ls.field];
        	ls.oldval = ls.qry[ls.dbField];                    
            ls.newval = rc[ls.field];
        	if(ls.oldval != ls.newval) {       	
            	ls.changedItem = {};            	
                ls.changedItem["oldval"] = ls.oldval; 
                ls.changedItem["newval"] = ls.newval;   
                ls.retval.data.changes[ls.field] = ls.changedItem; 
            	ls.retval.data.changed = true; 
            }  
        }     
        
        return ls.retval;
	}    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRcToDbForAddresses
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getRcToDbForAddresses() {  
    	var ls = {};
         
    	ls.rcToDb = {};  
    	       
        //ls.rcToDb["BUSINESS_ADDRESS_ID"] = "ID"; 
		ls.rcToDb["BUSINESS_ADDRESS_STREET"] = "ADDRESSLINE1"; 
		ls.rcToDb["BUSINESS_ADDRESS_CITY"] = "CITY";         
		ls.rcToDb["BUSINESS_ADDRESS_POSTAL_CODE"] = "POSTALCODE";         
		ls.rcToDb["BUSINESS_ADDRESS_COUNTRY_CODE"] = "COUNTRYID";  
		ls.rcToDb["BUSINESS_ADDRESS_EFFECTIVE_FROM"] = "VALIDITYDATE"; 
        
        //ls.rcToDb["PRIVATE_ADDRESS_ID"] = "ID"; 
		ls.rcToDb["PRIVATE_ADDRESS_STREET"] = "PRIVATE_ADDRESS"; 
		ls.rcToDb["PRIVATE_ADDRESS_CITY"] = "PRIVATE_CITY";         
		ls.rcToDb["PRIVATE_ADDRESS_POSTAL_CODE"] = "PRIVATE_POSTALCODE";         
		ls.rcToDb["PRIVATE_ADDRESS_COUNTRY_CODE"] = "PRIVATE_COUNTRYID";         
		ls.rcToDb["PRIVATE_MOBILE_NBR_1"] = "MOBILNUMBER";         
		ls.rcToDb["PRIVATE_MOBILE_NBR_2"] = "MOBILNUMBER2";
        //ls.rcToDb["PRIVATE_EMAIL"] = "EMAIL"; 
        ls.rcToDb["LIFE_3_MONTHS"] = "LIFE_3_MONTHS"; 
               	
		return ls.rcToDb;         
    } 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInDocuments
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChangeInDocuments(required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
       
        ls.retval.data["changed"] = false;         
        ls.retval.data["changes"] = {};  
        ls.fields = getRcToDbForDocuments();                
        
        ls.qry = variables.gdAltDao.getDocumentsQry(staff_member_id); 
        if(ls.qry.recordCount == 0) {
	        ls.qry = variables.gdDao.getDocumentsQry(staff_member_id);
			if(ls.qry.recordCount == 0){
                //No documents
                ls.retval.data.createDocuments = true;     
                for(ls.field in ls.fields) {
                	if( rc[ls.field] != "" ){
	                    ls.retval.data.changed = true;
                        break;
                    }
                }           
                return ls.retval;
            }               
        }
                
        //single result row expected    
        for(ls.field in ls.fields) {	
        	ls.dbField = ls.fields[ls.field];
        	ls.oldval = ls.qry[ls.dbField];
            ls.newval = rc[ls.field];
        	if(ls.oldval != ls.newval) {       	
            	ls.changedItem = {};            	
                ls.changedItem["oldval"] = ls.oldval; 
                ls.changedItem["newval"] = ls.newval;   
                ls.retval.data.changes[ls.field] = ls.changedItem;            
            	ls.retval.data.changed = true; 
            }  
        }          
        
        return ls.retval;
	}          
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRcToDbForDocuments
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getRcToDbForDocuments() {  
    	var ls = {};
         
    	ls.rcToDb = {};      	       
        
		ls.rcToDb["DOC_DL_COUNTRY_CODE"] = "DL_CTRY";         
		ls.rcToDb["DOC_DL_DOC_NBR"] = "DL_DOC_NBR"; 
        ls.rcToDb["DOC_DL_VALID_FROM"] = "DL_START_DATE"; 
        ls.rcToDb["DOC_DL_VALID_UNTIL"] = "DL_END_DATE"; 
		ls.rcToDb["DOC_DL_ISSUED_BY"] = "DL_DELIV_BY";               
		ls.rcToDb["DOC_DL_ISSUED_AT"] = "DL_DELIV_AT";      
        
		ls.rcToDb["DOC_PASS_COUNTRY_CODE"] = "PASS_CTRY";         
		ls.rcToDb["DOC_PASS_DOC_NBR"] = "PASS_DOC_NBR"; 
        ls.rcToDb["DOC_PASS_VALID_FROM"] = "PASS_START_DATE"; 
        ls.rcToDb["DOC_PASS_VALID_UNTIL"] = "PASS_END_DATE"; 
		ls.rcToDb["DOC_PASS_ISSUED_BY"] = "PASS_DELIV_BY";               
		ls.rcToDb["DOC_PASS_ISSUED_AT"] = "PASS_DELIV_AT";                            
          
		ls.rcToDb["DOC_PASS2_COUNTRY_CODE"] = "PASS2_CTRY";         
		ls.rcToDb["DOC_PASS2_DOC_NBR"] = "PASS2_DOC_NBR"; 
        ls.rcToDb["DOC_PASS2_VALID_FROM"] = "PASS2_START_DATE"; 
        ls.rcToDb["DOC_PASS2_VALID_UNTIL"] = "PASS2_END_DATE"; 
		ls.rcToDb["DOC_PASS2_ISSUED_BY"] = "PASS2_DELIV_BY";               
		ls.rcToDb["DOC_PASS2_ISSUED_AT"] = "PASS2_DELIV_AT";      
        
		ls.rcToDb["DOC_RP_COUNTRY_CODE"] = "RP_CTRY";         
		ls.rcToDb["DOC_RP_DOC_NBR"] = "RP_DOC_NBR"; 
        ls.rcToDb["DOC_RP_VALID_FROM"] = "RP_START_DATE"; 
        ls.rcToDb["DOC_RP_VALID_UNTIL"] = "RP_END_DATE"; 
		ls.rcToDb["DOC_RP_ISSUED_BY"] = "RP_DELIV_BY";               
		ls.rcToDb["DOC_RP_ISSUED_AT"] = "RP_DELIV_AT";    
        
		ls.rcToDb["DOC_WL_COUNTRY_CODE"] = "WL_CTRY";         
		ls.rcToDb["DOC_WL_DOC_NBR"] = "WL_DOC_NBR"; 
        ls.rcToDb["DOC_WL_VALID_FROM"] = "WL_START_DATE"; 
        ls.rcToDb["DOC_WL_VALID_UNTIL"] = "WL_END_DATE"; 
		ls.rcToDb["DOC_WL_ISSUED_BY"] = "WL_DELIV_BY";               
		ls.rcToDb["DOC_WL_ISSUED_AT"] = "WL_DELIV_AT";       
        
		ls.rcToDb["DOC_EBDG_COUNTRY_CODE"] = "EBDG_CTRY";         
		ls.rcToDb["DOC_EBDG_DOC_NBR"] = "EBDG_DOC_NBR"; 
        ls.rcToDb["DOC_EBDG_VALID_FROM"] = "EBDG_START_DATE"; 
        ls.rcToDb["DOC_EBDG_VALID_UNTIL"] = "EBDG_END_DATE"; 
		ls.rcToDb["DOC_EBDG_ISSUED_BY"] = "EBDG_DELIV_BY";               
		ls.rcToDb["DOC_EBDG_ISSUED_AT"] = "EBDG_DELIV_AT";     
        
		ls.rcToDb["DOC_DBDG_COUNTRY_CODE"] = "DBDG_CTRY";         
		ls.rcToDb["DOC_DBDG_DOC_NBR"] = "DBDG_DOC_NBR"; 
        ls.rcToDb["DOC_DBDG_VALID_FROM"] = "DBDG_START_DATE"; 
        ls.rcToDb["DOC_DBDG_VALID_UNTIL"] = "DBDG_END_DATE"; 
		ls.rcToDb["DOC_DBDG_ISSUED_BY"] = "DBDG_DELIV_BY";               
		ls.rcToDb["DOC_DBDG_ISSUED_AT"] = "DBDG_DELIV_AT";     
        
		ls.rcToDb["DOC_LAP_COUNTRY_CODE"] = "LAISS_CTRY";         
		ls.rcToDb["DOC_LAP_DOC_NBR"] = "LAISS_DOC_NBR"; 
        ls.rcToDb["DOC_LAP_VALID_FROM"] = "LAISS_START_DATE"; 
        ls.rcToDb["DOC_LAP_VALID_UNTIL"] = "LAISS_END_DATE"; 
		ls.rcToDb["DOC_LAP_ISSUED_BY"] = "LAISS_DELIV_BY";               
		ls.rcToDb["DOC_LAP_ISSUED_AT"] = "LAISS_DELIV_AT";     
        
		ls.rcToDb["DOC_JUREP_COUNTRY_CODE"] = "JUREP_CTRY";         
		ls.rcToDb["DOC_JUREP_DOC_NBR"] = "JUREP_DOC_NBR"; 
        ls.rcToDb["DOC_JUREP_VALID_FROM"] = "JUREP_START_DATE"; 
        ls.rcToDb["DOC_JUREP_VALID_UNTIL"] = "JUREP_END_DATE"; 
		ls.rcToDb["DOC_JUREP_ISSUED_BY"] = "JUREP_DELIV_BY";               
		ls.rcToDb["DOC_JUREP_ISSUED_AT"] = "JUREP_DELIV_AT";             
               	
		return ls.rcToDb;         
    }   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInDocumentFiles
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function hasAnyChangeInDocumentFiles(required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        ls.retval.data["changed"] = false;         
        ls.retval.data["changed_docs"] = [];         
        
        ls.docs = ["DL", "PASS", "PASS2", "WL", "EBDG", "DBDG", "RP", "LAP", "JUREP", "CV"]; 
        
		for(ls.doc in ls.docs) {	        
			if(rc["#ls.doc#_FILE"] != ""){ 
            	if(ls.doc == "LAP")
                	ls.doc = "LAISS";                                                  
                ArrayAppend(ls.retval.data.changed_docs, ls.doc);
                ls.retval.data.changed = true;                
            }         
        }     
        
		return ls.retval;        
	}          
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInMedicals
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChangeInMedicals(required string username, required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        ls.retval.data["changed"] = false;    
        ls.retval.data["changes"] = [];  //array of the IDs of changed medicals
       
        ls["medicals"] = {};        
        ls.fields = getRcToDbForMedicals();
        ls.regex = "^(medical_\D+)_(\d+)$";             
        
        for(ls.elem in rc){ //extracting medical-related fields and their value
        	if( REFindNoCase(ls.regex, ls.elem) ){            	
            	ls.ref = REFindNoCase(ls.regex, ls.elem, 1, true);
                ls.core = Mid(ls.elem, ls.ref["POS"][2], ls.ref["LEN"][2]);
				ls.id = Mid(ls.elem, ls.ref["POS"][3], ls.ref["LEN"][3]); 
                ls.val = rc[ls.elem];
                ls.medicals[ls.id][ls.core] = ls.val;               
            }        
        }   
        
        for(ls.id in ls.medicals){                   
            ls.medical = ls.medicals[ls.id];
            ls.medical["changed"] = false; 
            ls.medical["changes"] = {};        
        
        	ls.qry = Variables.gdAltDao.getMedicalQry(ls.id); 
            if(ls.qry.recordCount == 0) {
	            //ls.medical.changed = true; 
            	ls.qry = Variables.gdDao.getMedicalQry(ls.id);
            }               
            
            //single record expected
            for(ls.field in ls.fields) {		            
                ls.dbField = ls.fields[ls.field];
                ls.oldval = ls.qry[ls.dbField];
                if(!StructKeyExists(ls.medical, ls.field)) //MEDICAL_STATUS is a radio that does not always exist
                	ls.medical[ls.field] = "";     
                              	
                ls.newval = ls.medical[ls.field];
                
                if(ls.oldval != ls.newval) {       	
                    ls.changedItem = {};
                    ls.changedItem["oldval"] = ls.oldval; 
                    ls.changedItem["newval"] = ls.newval;  
                    ls.medical.changes[ls.dbField] = ls.changedItem;
                    ls.medical.changed = true; 
                    ls.retval.data.changed = true; 
                }              
            }  
            
            if(ls.medical.changed == true)
	            ArrayAppend(ls.retval.data.changes, ls.id);              	
            
            ls.retval.data[ls.id] = ls.medical;
        }      
        
        //writedump(ls.retval);
        //abort;
        
        return ls.retval;
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInBankAccounts
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChangeInBankAccounts(required string username, required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        ls.retval.data["changed"] = false;    
        ls.retval.data["changes"] = [];  //array of the IDs of changed bank accounts
       
        ls["bankAccounts"] = {};        
        ls.fields = getRcToDbForBankAccounts();
        ls.regex = "^(bank_\D+)_(\d+)$";             
        
        for(ls.elem in rc){ //extracting bank-account-related fields and their value
        	if( REFindNoCase(ls.regex, ls.elem) ){            	
            	ls.ref = REFindNoCase(ls.regex, ls.elem, 1, true);
                ls.core = Mid(ls.elem, ls.ref["POS"][2], ls.ref["LEN"][2]);
				ls.id = Mid(ls.elem, ls.ref["POS"][3], ls.ref["LEN"][3]); 
                ls.val = rc[ls.elem];
                ls.bankAccounts[ls.id][ls.core] = ls.val;               
            }        
        }   
        
        for(ls.id in ls.bankAccounts){                   
            ls.bankAccount = ls.bankAccounts[ls.id];
            ls.bankAccount["changed"] = false; 
            ls.bankAccount["changes"] = {};        
        
        	ls.qry = Variables.gdAltDao.getBankAccountQry(ls.id); 
            if(ls.qry.recordCount == 0) {	            
            	ls.qry = Variables.gdDao.getBankAccountQry(ls.id);
            }               
            
            //single record expected
            for(ls.field in ls.fields) {		            
                ls.dbField = ls.fields[ls.field];
                ls.oldval = ls.qry[ls.dbField];         
                              	
                ls.newval = ls.bankAccount[ls.field];
                
                if(ls.oldval != ls.newval) {       	
                    ls.changedItem = {};
                    ls.changedItem["oldval"] = ls.oldval; 
                    ls.changedItem["newval"] = ls.newval;  
                    ls.bankAccount.changes[ls.dbField] = ls.changedItem;
                    ls.bankAccount.changed = true; 
                    ls.retval.data.changed = true; 
                }              
            }  
            
            if(ls.bankAccount.changed == true)
	            ArrayAppend(ls.retval.data.changes, ls.id);              	
            
            ls.retval.data[ls.id] = ls.bankAccount;
        }      
        
        //writedump(ls.retval);
        //abort;
        
        return ls.retval;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChangeInMedicalFiles
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function hasAnyChangeInMedicalFiles(required numeric staff_member_id, required struct rc) { 
    	var ls = {};
        
        ls.retval = {};      
        ls.retval["result"] = "OK"; 
        ls.retval["data"] = {};
        ls.retval.data["changed"] = false;         
        ls.retval.data["changes"] = [];  //array of the uploaded filenames     
        
        ls["medicals"] = {};        
        ls.fields = getRcToDbForMedicals();
        ls.regex = "^(medical_\D+)_(\d+)$";             
        
        for(ls.elem in rc){ //extracting medical-related fields and their value
        	if( REFindNoCase(ls.regex, ls.elem) ){            	
            	ls.ref = REFindNoCase(ls.regex, ls.elem, 1, true);
                ls.core = Mid(ls.elem, ls.ref["POS"][2], ls.ref["LEN"][2]);
				ls.id = Mid(ls.elem, ls.ref["POS"][3], ls.ref["LEN"][3]); 
                ls.val = rc[ls.elem];
                ls.medicals[ls.id][ls.core] = ls.val;               
            }        
        }    
        
		for(ls.id in ls.medicals){        
	        ls.medical = ls.medicals[ls.id];
            
            if(ls.medical["MEDICAL_FILE"] != ""){
            	ArrayAppend(ls.retval.data.changes, ls.id);
                ls.medical.changed = true; 
                ls.retval.data.changed = true; 
            }   
            
            ls.retval.data[ls.id] = ls.medical;                
        }     
        
		return ls.retval;        
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRcToDbForMedicals
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getRcToDbForMedicals() {  
    	var ls = {};
         
    	ls.rcToDb = {};      	       
        
        ls.rcToDb["MEDICAL_DELETED"] = "DELETED";  
		ls.rcToDb["MEDICAL_VALID_FROM"] = "VALIDITY_FROM";         
		ls.rcToDb["MEDICAL_VALID_UNTIL"] = "VALIDITY_TO"; 
        ls.rcToDb["MEDICAL_REMARKS"] = "REMARKS"; 
        ls.rcToDb["MEDICAL_CENTER"] = "MEDICAL_CENTER"; 
		ls.rcToDb["MEDICAL_STATUS"] = "STATUS";   
        
        return ls.rcToDb;      
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRcToDbForBankAccounts
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getRcToDbForBankAccounts() {  
    	var ls = {};
         
    	ls.rcToDb = {};      	       
        
        ls.rcToDb["BANK_DELETED"] = "DELETED";  
		ls.rcToDb["BANK_NAME"] = "BANK_NAME";         
		ls.rcToDb["BANK_ADDRESS"] = "BANK_ADDRESS"; 
        ls.rcToDb["BANK_IBAN"] = "BANK_IBAN"; 
        ls.rcToDb["BANK_BIC"] = "BANK_BIC"; 
		//ls.rcToDb["MEDICAL_STATUS"] = "STATUS";   
        
        return ls.rcToDb;      
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasExtern
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public boolean function hasExtern(staffMemberId) {  
    	var ls = {};
        ls.hasMain = false;
        
        ls.hasMain = Variables.gdDao.hasExtern(staffMemberId);  
        
		return ls.hasMain;
	}                              
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function saveGD( required numeric user_id, required del_user_id, required numeric office_id, required numeric staff_member_id, required string username, required struct rc ){
    	var ls = {};	   
        
        ls.changes = {};    
        ls.changes["changed"] = false;
        ls.changes["changes"] = [];
        ls.calls = [];
        
///////////////////////////////////////////////////////
// any change in extern data (TBL_EXTERNS)?  
///////////////////////////////////////////////////////

		//ls.staffMemberExists = hasExtern(staff_member_id);
        
/*        if(!ls.staffMemberExists) {                       
            // add to TBL_EXTERNS           
            ls.call = {};
            ls.call.func = "createStaffMember";
            ls.call.args = {username:username, staff_member_id:staff_member_id};
            ArrayAppend(ls.calls, ls.call); 
            
        	// add to FSM_USERS                     
			ls.new_fsm_user_id = Variables.gdAltDao.getNewFsmUserId() ;
            ls.call = {};
            ls.call.func = "createFsmUser";
            ls.call.args = {user_id:user_id, del_user_id:del_user_id, id:ls.new_fsm_user_id, staff_member_id:staff_member_id};
            ArrayAppend(ls.calls, ls.call);                      
		}  */          
      
        ls.changes["extern"] = hasAnyChangeInExternData(staff_member_id, rc);  
        
        if(ls.changes.extern.data.changed == true){
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "extern");
            ls.hasAltExtern = Variables.gdAltDao.hasExtern(staff_member_id);
            
            if(ls.hasAltExtern == false){
                ls.call = {};
                ls.call.func = "copyExtern";
                ls.call.args = {staff_member_id:staff_member_id};
                ArrayAppend(ls.calls, ls.call); 
            }       
                 
            ls.call = {};
            ls.call.func = "updateExtern";
            ls.call.args = {username:username, staff_member_id:staff_member_id, rc:rc};
            ArrayAppend(ls.calls, ls.call); 
        }
        
///////////////////////////////////////////////////////
// any change in marital status (TBL_PERSONALPROFILES)?
///////////////////////////////////////////////////////
        
        ls.changes["marital_status"] = hasAnyChangeInMaritalStatus(staff_member_id, rc);
        //NB: if the status has changed, then we should in principle insert a new record? currently we just update all
        
        if(ls.changes.marital_status.data.changed == true){
        	ls.changes.changed = true;
           	ArrayAppend(ls.changes.changes, "marital_status");
            ls.cnt = Variables.gdDao.hasPersonalProfile(staff_member_id);
            ls.altCnt = Variables.gdAltDao.hasPersonalProfile(staff_member_id);
            
            if(ls.cnt == 0 && ls.altCnt == 0){
            	ls.personalProfileId = Variables.gdAltDao.getNewPersonalProfileId();            
                ls.call = {};
                ls.call.func = "createPersonalProfile";
                ls.call.args = {username:username, personal_profile_id:ls.personalProfileId, staff_member_id:staff_member_id};
                ArrayAppend(ls.calls, ls.call); 
            } 
            
            if(ls.cnt == 1 && ls.altCnt == 0){
                ls.call = {};
                ls.call.func = "copyPersonalProfile";
                ls.call.args = {staff_member_id:staff_member_id};
                ArrayAppend(ls.calls, ls.call);
            }  
            
            //eg, convert from "WID" to 7
            rc.ms_status = getMaritalStatusesMap()[rc.ms_status];
                 
            ls.call = {};
            ls.call.func = "updatePersonalProfile";
            ls.call.args = {username:username, staff_member_id:staff_member_id, rc:rc};
            ArrayAppend(ls.calls, ls.call);   
        }
        
///////////////////////////////////////////////////////
// any change in addresses (TBL_RESIDENCES)?
///////////////////////////////////////////////////////
        
        ls.changes["addresses"] = hasAnyChangeInAddresses(staff_member_id, rc);
        
        if( StructKeyExists(ls.changes.addresses.data, "createAddress") && ls.changes.addresses.data.changed == true){
        	//There is no main Addresses record, 
            //so we'll create one in alt, then update it
	        ls.changes.changed = true;            
            ArrayAppend(ls.changes.changes, "addresses");
            
            ls.address_id = Variables.gdAltDao.getNewAddressId();
            ls.call = {};            
            ls.call.func = "createAddress";
            ls.call.args = {id:ls.address_id, staff_member_id:staff_member_id, username:username};
            
            ArrayAppend(ls.calls, ls.call); 
			ls.call = {};
            ls.call.func = "updateAddress";
            ls.call.args = {username:username, address_id:ls.address_id, rc:rc};
            ArrayAppend(ls.calls, ls.call);             
        }        
        else if(ls.changes.addresses.data.changed == true){
	        //There is a main Addresses record and data was provided,
            //so we'll copy it to alt (if it does not already exist), then update it.
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "addresses");
            
            ls.address_id = rc["ADDRESS_ID"]; //user can fiddle this!!
            ls.cnt = Variables.gdAltDao.hasAddress(staff_member_id);
            if(ls.cnt == 0){
                ls.call = {};
                ls.call.func = "copyAddress";
                ls.call.args = {id:ls.address_id};
                ArrayAppend(ls.calls, ls.call); 
            }  
            ls.call = {};
            ls.call.func = "updateAddress";
            ls.call.args = {username:username, address_id:ls.address_id, rc:rc};
            ArrayAppend(ls.calls, ls.call);             
        }    
        
///////////////////////////////////////////////////////
// any change in documents (TBL_ADM_DOC)?
///////////////////////////////////////////////////////
       
        ls.changes["documents"] = hasAnyChangeInDocuments(staff_member_id, rc);
        
		if( StructKeyExists(ls.changes.documents.data, "createDocuments") && ls.changes.documents.data.changed == true){
        	//There is no main documents record, 
            //so we'll create one in alt, then update it       
             
	        ls.changes.changed = true;            
            ArrayAppend(ls.changes.changes, "documents");
            
            ls.documents_id = Variables.gdAltDao.getNewDocumentsId();
            ls.call = {};            
            ls.call.func = "createDocuments";
            ls.call.args = {id:ls.documents_id, staff_member_id:staff_member_id, username:username};
            
            ArrayAppend(ls.calls, ls.call); 
			ls.call = {};
            ls.call.func = "updateDocuments";
            ls.call.args = {username:username, staff_member_id:staff_member_id, rc:rc};
            ArrayAppend(ls.calls, ls.call);             
        }        
        else if(ls.changes.documents.data.changed == true){
	        //There is a main Documents record and data was provided,
            //so we'll copy it to alt (if it does not already exist), then update it.    
                
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "documents");   
            
            ls.cnt = Variables.gdAltDao.hasDocuments(staff_member_id);
            if(ls.cnt == 0){
                ls.call = {};
                ls.call.func = "copyDocuments";
                ls.call.args = {staff_member_id:staff_member_id};
                ArrayAppend(ls.calls, ls.call); 
            }  
            
            ls.call = {};
            ls.call.func = "updateDocuments";
            ls.call.args = {username:username, staff_member_id:staff_member_id, rc:rc};
            ArrayAppend(ls.calls, ls.call);                     
        }       

        
///////////////////////////////////////////////////////
// any change in document files (TBL_ADM_DOC)?
///////////////////////////////////////////////////////
        
        ls.changes["document_files"] = hasAnyChangeInDocumentFiles(staff_member_id, rc);
        
        if(ls.changes.document_files.data.changed == true){
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "document_files");
            ls.cnt = Variables.gdAltDao.hasDocuments(staff_member_id);
            ls.altCnt = Variables.gdAltDao.hasDocuments(staff_member_id);
            
            if(ls.changes.documents.data.changed == false){ 
            	//No need to create or copy documents if already done above.
                //So this can occur only if ONLY files were modified
                if(ls.cnt == 0 && ls.altCnt == 0){
                    ls.documents_id = Variables.gdAltDao.getNewDocumentsId();
                    ls.call = {};            
                    ls.call.func = "createDocuments";
                    ls.call.args = {id:ls.documents_id, staff_member_id:staff_member_id, username:username};
                    ArrayAppend(ls.calls, ls.call); 
                }      
                else if(ls.cnt == 1 && ls.altCnt == 0){
                    ls.call = {};
                    ls.call.func = "copyDocuments";
                    ls.call.args = {staff_member_id:staff_member_id};
                    ArrayAppend(ls.calls, ls.call);             
                }
			}                
                  
            for(ls.doc in ls.changes.document_files.data.changed_docs){	           
                ls.call = {};
                ls.call.func = "updateDocumentFile";
                ls.call.args = {username:username, staff_member_id:staff_member_id, field:ls.doc, rc:rc};
                ArrayAppend(ls.calls, ls.call);
            }              
        }        
        
///////////////////////////////////////////////////////
// Save if any change in bankAccounts (TBL_BANK_ACCOUNT)
///////////////////////////////////////////////////////
          
        ls.changes["bankAccounts"] = hasAnyChangeInBankAccounts(username, staff_member_id, rc);
        
        if(ls.changes.bankAccounts.data.changed == true){    
            
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "bankAccounts");     
                   
            for(ls.id in ls.changes.bankAccounts.data.changes){
                ls.cnt = Variables.gdDao.hasBankAccount(ls.id);
                ls.altCnt = Variables.gdAltDao.hasBankAccount(ls.id);  
                ls.bankAccount = ls.changes.bankAccounts.data[ls.id];
				ls.deleted = ls.bankAccount.bank_deleted; 
                
                //writeDump(ls.bankAccount);
                //abort;                
                             
                if(ls.cnt == 0 && ls.deleted == "Y") {
                    ls.call = {};
                    ls.call.func = "deleteBankAccount";                    
                    ls.call.args = { id:ls.id };
                    ArrayAppend(ls.calls, ls.call);              
                }  
              	else if(ls.altCnt == 1 && ls.deleted == "Y") {
                    ls.call = {};
                    ls.call.func = "removeBankAccount";                    
                    ls.call.args = { username:username, id:ls.id };
                    ArrayAppend(ls.calls, ls.call);              
                }                 
                else if(ls.deleted == "R") {
                    ls.call = {};
                    ls.call.func = "restoreBankAccount";                    
                    ls.call.args = { username:username, id:ls.id };
                    ArrayAppend(ls.calls, ls.call);     
                    
                    ls.bankAccount = ls.changes.bankAccounts.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateBankAccount";
                    ls.call.args = {username:username, bank_account_id:ls.id, rc:ls.bankAccount};               
                    ArrayAppend(ls.calls, ls.call);                                 
                }                              
              	else if(ls.cnt == 0 && ls.altCnt == 0){	                			
                    ls.call = {};
                    ls.call.func = "createBankAccount";                    
                    ls.call.args = {username:username, staff_member_id:staff_member_id, id:ls.id };
                    ArrayAppend(ls.calls, ls.call); 
                    
                    ls.bankAccount = ls.changes.bankAccounts.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateBankAccount";
                    ls.call.args = {username:username, bank_account_id:ls.id, rc:ls.bankAccount};               
                    ArrayAppend(ls.calls, ls.call);                     
                }                                
                else if(ls.cnt == 1 && ls.altCnt == 0){
                    ls.call = {};
                    ls.call.func = "copyBankAccount";
                    ls.call.args = {bank_account_id:ls.id};
                    ArrayAppend(ls.calls, ls.call); 
                    
                    ls.bankAccount = ls.changes.bankAccounts.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateBankAccount";
                    ls.call.args = {username:username, bank_account_id:ls.id, rc:ls.bankAccount};               
                    ArrayAppend(ls.calls, ls.call);                     
                }  
                else if(ls.altCnt == 1){     
                    ls.bankAccount = ls.changes.bankAccounts.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateBankAccount";
                    ls.call.args = {username:username, bank_account_id:ls.id, rc:ls.bankAccount};               
                    ArrayAppend(ls.calls, ls.call);                     
                }                 
            }  
        }     
        
///////////////////////////////////////////////////////
// any change in medicals (TBL_MEDIC_CERTIFICATE)?
///////////////////////////////////////////////////////
          
        ls.changes["medicals"] = hasAnyChangeInMedicals(username, staff_member_id, rc);
        
        if(ls.changes.medicals.data.changed == true){    
            
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "medicals");     
                   
            for(ls.id in ls.changes.medicals.data.changes){
                ls.cnt = Variables.gdDao.hasMedical(ls.id);
                ls.altCnt = Variables.gdAltDao.hasMedical(ls.id);  
                ls.medical = ls.changes.medicals.data[ls.id];
				ls.deleted = ls.medical.medical_deleted; 
                
                //writeDump(ls.medical);
                //abort;                
                             
                if(ls.cnt == 0 && ls.deleted == "Y") {
                    ls.call = {};
                    ls.call.func = "deleteMedical";                    
                    ls.call.args = { id:ls.id };
                    ArrayAppend(ls.calls, ls.call);              
                }  
              	else if(ls.altCnt == 1 && ls.deleted == "Y") {
                    ls.call = {};
                    ls.call.func = "removeMedical";                    
                    ls.call.args = { username:username, id:ls.id };
                    ArrayAppend(ls.calls, ls.call);              
                }                 
                else if(ls.deleted == "R") {
                    ls.call = {};
                    ls.call.func = "restoreMedical";                    
                    ls.call.args = { username:username, id:ls.id };
                    ArrayAppend(ls.calls, ls.call);     
                    
                    ls.medical = ls.changes.medicals.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateMedical";
                    ls.call.args = {username:username, medical_id:ls.id, rc:ls.medical};               
                    ArrayAppend(ls.calls, ls.call);                                 
                }                              
              	else if(ls.cnt == 0 && ls.altCnt == 0){	                			
                    ls.call = {};
                    ls.call.func = "createMedical";                    
                    ls.call.args = {username:username, staff_member_id:staff_member_id, id:ls.id };
                    ArrayAppend(ls.calls, ls.call); 
                    
                    ls.medical = ls.changes.medicals.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateMedical";
                    ls.call.args = {username:username, medical_id:ls.id, rc:ls.medical};               
                    ArrayAppend(ls.calls, ls.call);                     
                }                                
                else if(ls.cnt == 1 && ls.altCnt == 0){
                    ls.call = {};
                    ls.call.func = "copyMedical";
                    ls.call.args = {medical_id:ls.id};
                    ArrayAppend(ls.calls, ls.call); 
                    
                    ls.medical = ls.changes.medicals.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateMedical";
                    ls.call.args = {username:username, medical_id:ls.id, rc:ls.medical};               
                    ArrayAppend(ls.calls, ls.call);                     
                }  
                else if(ls.altCnt == 1){     
                    ls.medical = ls.changes.medicals.data[ls.id];
                    ls.call = {};
                    ls.call.func = "updateMedical";
                    ls.call.args = {username:username, medical_id:ls.id, rc:ls.medical};               
                    ArrayAppend(ls.calls, ls.call);                     
                }                 
            }  
        }       
        
///////////////////////////////////////////////////////
// any change in medical files (TBL_ADM_DOC)?
///////////////////////////////////////////////////////
        
        ls.changes["medical_files"] = hasAnyChangeInMedicalFiles(staff_member_id, rc);
        
        if(ls.changes.medical_files.data.changed == true){
        	ls.changes.changed = true;
            ArrayAppend(ls.changes.changes, "medical_files");  
            
            for(ls.id in ls.changes.medical_files.data.changes){	                
                //medical file  has been created above if necessary
            	ls.filefield = "MEDICAL_FILE_#ls.id#";
                ls.call = {};
                ls.call.func = "updateMedicalFile";
                ls.call.args = {username:username, medical_id:ls.id, filefield:ls.filefield, rc:rc};
                ArrayAppend(ls.calls, ls.call);   
            }                 
        } 
        
///////////////////////////////////////////////////////
// Log ststus
///////////////////////////////////////////////////////    

        ls.call = {}; 
        ls.call.func = "insertStatusLog";
        ls.call.args = {user_id:user_id, del_user_id:del_user_id, office_id:office_id, staff_member_id:staff_member_id, log_status_code:"SMM_EDIT_IN_PROGRESS"};
        ArrayAppend(ls.calls, ls.call, true);              
        
///////////////////////////////////////////////////////
// Execute in single transaction
/////////////////////////////////////////////////////// 

		ls.retval = Variables.gdAltDao.transactQry(ls.calls);           
        
        return ls.retval;   
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateGD
// unused now (February 2018), to be implemented
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function validateGD( required numeric user_id, required numeric office_id, required struct rc ){
    	var ls = {};	
                
        ls.retval = {};
        ls.retval["status"] = false;       
        ls.retval["errors"] = {};
        ls.retval.errors[rc.element_name] = {"errorMessage":"invalid email format"};        
        
		return ls.retval;  
	}                    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addMedical
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function addMedical( required numeric user_id, required numeric office_id, required numeric staff_member_id, required struct rc ) {     
	    var ls = {}; 
        
        ls["medical"] = {};
        
		ls.medical["id"] =  Variables.gdAltDao.getNewMedicalId();
        ls.medical["medical_deleted"] = "N";
		ls.medical["medical_center"] = "";
		ls.medical["medical_created_by"] = "";
		ls.medical["medical_externid"] = staff_member_id;
		ls.medical["medical_filename"] = "";
		ls.medical["medical_mime_type"] = "";
		ls.medical["medical_modified_by"] = "";
        ls.medical["medical_modified_on"] = "";
		ls.medical["medical_remarks"] = "";
		ls.medical["medical_status"] = "N";
		ls.medical["medical_valid_from"] = "";
		ls.medical["medical_valid_until"] = "";
		ls.medical["medical_version"] = 0;           
        
 		ls.retval.data = ls.medical;
        
        return ls.retval;  
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addBankAccount
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function addBankAccount( required numeric user_id, required numeric office_id, required numeric staff_member_id, required struct rc ) {     
	    var ls = {}; 
        
        ls["bankAccount"] = {};
        
		ls.bankAccount["id"] =  Variables.gdAltDao.getNewBankAccountId();
        ls.bankAccount["bank_deleted"] = "N";
		ls.bankAccount["bank_name"] = "";
   		ls.bankAccount["bank_addres"] = "";
		ls.bankAccount["bank_account_holder"] = "";        
		ls.bankAccount["bank_iban"] = "";        
		ls.bankAccount["bank_bic"] = "";           
        
 		ls.retval.data = ls.bankAccount;
        
        return ls.retval;  
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deleteMedical
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function deleteMedical( required numeric user_id, required numeric office_id, required numeric medical_id ) {     
	    var ls = {}; 
        ls.retval = {};        
        
		ls.retval.result = Variables.gdAltDao.deleteMedical(user_id, office_id, medical_id);
        
        return ls.retval;  
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDocFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function getDocFile( required numeric user_id, required numeric office_id, required numeric staff_member_id, required struct rc ) {     
	    var ls = {}; 
        ls.data = {};        
  
  		ls.docType = rc.docType;
        ls.hash = rc.hash;
        
        switch(ls.docType) {
        	case "doc_dl_file" : 
            	ls.field = "DL";
                break;
        	case "doc_pass_file" : 
            	ls.field = "PASS";            
                break;
        	case "doc_pass2_file" : 
            	ls.field = "PASS2";      
                break;
        	case "doc_wl_file" : 
            	ls.field = "WL";       
                break;
        	case "doc_rp_file" : 
            	ls.field = "RP";  
                break;
        	case "doc_ebdg_file" : 
            	ls.field = "EBDG";              
                break;
        	case "doc_dbdg_file" : 
            	ls.field = "DBDG";                          
                break;
        	case "doc_lap_file" : 
            	ls.field = "LAISS";  
                break;
        	case "doc_jurep_file" : 
            	ls.field = "JUREP";  
                break;   
        	case "doc_cv_file" : 
            	ls.field = "CV";  
                break;                              
		}  
        
		ls.qry = Variables.gdAltDao.getDocFileQry(user_id, office_id, staff_member_id, ls.field, ls.hash);            

        ls.data["fileName"] = ls.qry.file_name;  
        ls.data["fileData"] = ls.qry.file_data;
        ls.data["mimeType"] = ls.qry.mime_type;         
        
 		ls.retval["data"] = ls.data;
        
        return ls.retval;  
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getMedFile
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public struct function getMedFile( required numeric user_id, required numeric office_id, required numeric medical_id, required struct rc ) {     
	    var ls = {}; 
        ls.data = {};        
        ls.hash = rc.hash; 
        
        ls.qry = Variables.gdAltDao.getMedFileQry(user_id, office_id, medical_id, hash);                 

        ls.data["fileName"] = ls.qry.file_name;  
        ls.data["fileData"] = ls.qry.file_data;
        ls.data["mimeType"] = ls.qry.mime_type;   
        
 		ls.retval["data"] = ls.data;
        
        return ls.retval;  
	}             
        
    
}    
