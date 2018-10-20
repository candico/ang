Component accessors="true" {     
	    
    property staffService; 
    property staffDao; 
    property formatterService;
    
    property staff_member_id;
    property test;  
    
    property name="civility" default="";    
    property name="maiden_name" default="";
    property name="gender" default="";
    property name="birth_country_code" default="";
    property name="date_of_birth" default="";
    property name="citizenship_1_country_code" default="";
    
    property name="remarks" default="";
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getMyInfo (this function is for development purposes)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     
    
    public string function getMyInfo() {
    	return "My Info on #formatterService.longdate( Now() )#";
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUpdatedStaffMemberBasicsStruct
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function getUpdatedStaffMemberBasicsStruct(rc){
    	var ls = {};	
        	
		ls.personalDetails = variables.staffDao.getNSMPersonalDetailsQry(Arguments.rc.staff_member_id);   
        ls.familyDetails = variables.staffDao.getNSMFamilyDetailsQry(Arguments.rc.staff_member_id);     
		
        //Should be a single-row result set
        ls.staffMember = {};        
		ls.staffMember['staff_member_id'] = ls.personalDetails.staff_member_id;			
        //ls.staffMember['contract_id'] = ls.personalDetails.contract_id;	        		
        
        ls.staffMember['civility'] = (Variables.civility == "" ? ls.personalDetails.civility : Variables.civility);	
        ls.staffMember['last_name'] = ls.personalDetails.last_name;			
        ls.staffMember['first_name'] = ls.personalDetails.first_name;			      
        ls.staffMember['maiden_name'] = (Variables.maiden_name == "" ? ls.personalDetails.maiden_name : Variables.maiden_name);			              
        ls.staffMember['gender'] = (Variables.gender == "" ? ls.personalDetails.gender : Variables.gender);	
        ls.staffMember['birth_country_code'] = (Variables.birth_country_code == "" ? ls.personalDetails.birth_country_code : Variables.birth_country_code);	
        ls.staffMember['birth_country'] = ls.personalDetails.birth_country;  
        ls.staffMember['date_of_birth'] = (Variables.date_of_birth == "" ? ls.personalDetails.date_of_birth : Variables.date_of_birth);	
        ls.staffMember['age'] = ls.personalDetails.age;
        
        ls.staffMember['citizenship_1_country_code'] = (Variables.citizenship_1_country_code == "" ? ls.personalDetails.citizenship_1_country_code : Variables.citizenship_1_country_code);	
        ls.staffMember['citizenship_1_country'] = ls.personalDetails.citizenship_1_country;	    
		ls.staffMember['citizenship_2_country_code'] = ls.personalDetails.citizenship_2_country_code;	
        ls.staffMember['citizenship_2_country'] = ls.personalDetails.citizenship_2_country;     
		ls.staffMember['citizenship_3_country_code'] = ls.personalDetails.citizenship_3_country_code;	
        ls.staffMember['citizenship_3_country'] = ls.personalDetails.citizenship_3_country;         
        
		ls.staffMember['social_security_number'] = ls.personalDetails.ss_nbr;        
        ls.staffMember['date_of_death'] = ls.personalDetails.date_of_death;  
        
        ls.staffMember['ms_status'] = "WID";
        ls.staffMember['ms_effective_from'] = "01/01/1980";
        ls.staffMember['ms_jurisdiction'] = "POL";
        ls.staffMember['number_of_children'] = "3";
        ls.staffMember['number_of_dependents'] = "5";
        
      	ls.staffMember['language_1_id'] = "SPA";	
        ls.staffMember['language_1'] = "Spanish";	    
		ls.staffMember['language_2_id'] = ls.personalDetails.language_2_id;	
        ls.staffMember['language_2'] = ls.personalDetails.language_2;     
		ls.staffMember['language_3_id'] = ls.personalDetails.language_3_id;	
        ls.staffMember['language_3'] = ls.personalDetails.language_3;         
        
        ls.staffMember['business_address_street'] = "Business Street";	
        ls.staffMember['business_address_city'] = "Business City";	
        ls.staffMember['business_address_postal_code'] = "PC Biz 001"; 
        ls.staffMember['business_address_country_code'] = "POL"; 
        ls.staffMember['business_address_country'] = ""; 
        ls.staffMember['business_address_effective_from'] = "05/08/2015"; 
        
        ls.staffMember['private_address_street'] = "Private Street";	
        ls.staffMember['private_address_city'] = "Private City";	
        ls.staffMember['private_address_postal_code'] = "PC Priv 001"; 
        ls.staffMember['private_address_country'] = "";
        ls.staffMember['private_address_country_code'] = "POL"; 
        ls.staffMember['private_address_phone_nbr'] = "01 123 456 789";   
        ls.staffMember['private_mobile_nbr_1'] = "001 123 456 789";       
        ls.staffMember['private_mobile_nbr_2'] = "002 123 456 789"; 
        ls.staffMember['private_email'] = "person@email.org";       
        
        ls.staffMember['medical_exam_date'] = "01/01/2000";    
        ls.staffMember['medical_exam_institution'] = ls.personalDetails.medical_exam_institution;
        ls.staffMember['medical_exam_result'] = "1"; 
        ls.staffMember['remarks'] = (Variables.remarks == "" ? ls.personalDetails.remarks : Variables.remarks);            
        
		return ls.staffMember;
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getStaffMemberBasicsStruct
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function getStaffMemberBasicsStruct(rc){
    	var ls = {};	
        	
		ls.personalDetails = variables.staffDao.getNSMPersonalDetailsQry(Arguments.rc.staff_member_id);   
        ls.familyDetails = variables.staffDao.getNSMFamilyDetailsQry(Arguments.rc.staff_member_id); 
        ls.documents = variables.staffDao.getDocumentsQry(Arguments.rc.staff_member_id);   
        ls.addresses = variables.staffDao.getAddressesQry(Arguments.rc.staff_member_id);
		
        //Should be a single-row result set
        ls.staffMember = {};        
		ls.staffMember['staff_member_id'] = ls.personalDetails.staff_member_id;			
        //ls.staffMember['contract_id'] = ls.personalDetails.contract_id;	        		
        
        //Personal details (from TBL_EXTERNS)
        ls.staffMember['civility'] = ls.personalDetails.civility;	
        ls.staffMember['last_name'] = ls.personalDetails.last_name;			
        ls.staffMember['first_name'] = ls.personalDetails.first_name;			      
        ls.staffMember['maiden_name'] = ls.personalDetails.maiden_name;			              
        ls.staffMember['gender'] = ls.personalDetails.gender;	
        ls.staffMember['birth_country_code'] = ls.personalDetails.birth_country_code;	
        ls.staffMember['birth_country'] = ls.personalDetails.birth_country;  
        ls.staffMember['date_of_birth'] = ls.personalDetails.date_of_birth;	
        ls.staffMember['age'] = ls.personalDetails.age;
        
        ls.staffMember['citizenship_1_country_code'] = ls.personalDetails.citizenship_1_country_code;	
        ls.staffMember['citizenship_1_country'] = ls.personalDetails.citizenship_1_country;	    
		ls.staffMember['citizenship_2_country_code'] = ls.personalDetails.citizenship_2_country_code;	
        ls.staffMember['citizenship_2_country'] = ls.personalDetails.citizenship_2_country;     
		ls.staffMember['citizenship_3_country_code'] = ls.personalDetails.citizenship_3_country_code;	
        ls.staffMember['citizenship_3_country'] = ls.personalDetails.citizenship_3_country;         
        
		ls.staffMember['social_security_number'] = ls.personalDetails.ss_nbr;        
        ls.staffMember['date_of_death'] = ls.personalDetails.date_of_death;  
        
        //Family details (from TBL_PERSONALPROFILES)
        ls.staffMember['ms_status'] = ls.familyDetails.marital_status; //ms_status
        ls.staffMember['ms_effective_from'] = ls.familyDetails.sincedate; //ms_effective_from
        ls.staffMember['ms_country_code'] = ls.familyDetails.countryid; //ms_country_code
        ls.staffMember['ms_country'] = ls.familyDetails.country_en;
        
        //Dependents (from XXXX)
        ls.staffMember['nbr_of_children'] = "3";
        ls.staffMember['nbr_of_dependents'] = "5";
        
        //Language details (from TBL_EXTERNS)
      	ls.staffMember['language_1_id'] = ls.personalDetails.language_1_id;	
        ls.staffMember['language_1'] = ls.personalDetails.language_1;	    
		ls.staffMember['language_2_id'] = ls.personalDetails.language_2_id;		
        ls.staffMember['language_2'] = ls.personalDetails.language_2;    
		ls.staffMember['language_3_id'] = ls.personalDetails.language_3_id;		
        ls.staffMember['language_3'] = ls.personalDetails.language_3;         
        
        //Business address (from TBL_RESIDENCES)
        ls.staffMember['business_address_street'] = ls.addresses.addressline1;	
        ls.staffMember['business_address_city'] = ls.addresses.city;	
        ls.staffMember['business_address_postal_code'] = ls.addresses.postalcode; 
        ls.staffMember['business_address_country_code'] = ls.addresses.countryid; 
        ls.staffMember['business_address_country'] = ls.addresses.business_ctry_en; 
        ls.staffMember['business_address_effective_from'] = ls.addresses.validitydate; 
        
        //Private address (from TBL_RESIDENCES)
        ls.staffMember['private_address_street'] = ls.addresses.private_address;	
        ls.staffMember['private_address_city'] = ls.addresses.private_city;	
        ls.staffMember['private_address_postal_code'] = ls.addresses.private_postalcode; 
        ls.staffMember['private_address_country'] = ls.addresses.private_ctry_en; 
        ls.staffMember['private_address_country_code'] = ls.addresses.private_countryid;  
        ls.staffMember['private_address_phone_nbr'] = ls.addresses.phonenumber;     
        ls.staffMember['private_mobile_nbr_1'] = ls.addresses.mobilnumber;       
        ls.staffMember['private_mobile_nbr_2'] = ls.addresses.mobilnumber2;   
        ls.staffMember['private_email'] = ls.addresses.email;       
        
        //Medical visit (from TBL_EXTERNS)
        ls.staffMember['medical_valid_from'] = ls.personalDetails.medicvisit_from;    
        ls.staffMember['medical_valid_until'] = ls.personalDetails.medicvisit_to;            
        ls.staffMember['medical_exam_institution'] = ls.personalDetails.medicvisit_org;
        ls.staffMember['medical_exam_result'] = ls.personalDetails.medicvisit; 
        ls.staffMember['medical_remarks'] = ls.personalDetails.medicvisit_rem;     
        
        
        /* Documents */
        
        //Driving Licence
        ls.staffMember['doc_dl_country'] = ls.documents.dl_ctry_en;	
        ls.staffMember['doc_dl_country_code'] = ls.documents.dl_ctry;
        ls.staffMember['doc_dl_doc_nbr'] = ls.documents.dl_doc_nbr;	
        ls.staffMember['doc_dl_valid_from'] = ls.documents.dl_start_date;	
        ls.staffMember['doc_dl_valid_until'] = ls.documents.dl_end_date;	
        ls.staffMember['doc_dl_issued_by'] = ls.documents.dl_deliv_by;	
        ls.staffMember['doc_dl_issued_at'] = ls.documents.dl_deliv_at;	  
        
        //Passport
        ls.staffMember['doc_pass_country'] = ls.documents.pass_ctry_en;	
        ls.staffMember['doc_pass_country_code'] = ls.documents.pass_ctry;	
        ls.staffMember['doc_pass_doc_nbr'] = ls.documents.pass_doc_nbr;	
        ls.staffMember['doc_pass_valid_from'] = ls.documents.pass_start_date;	
        ls.staffMember['doc_pass_valid_until'] = ls.documents.pass_end_date;	
        ls.staffMember['doc_pass_issued_by'] = ls.documents.pass_deliv_by;	
        ls.staffMember['doc_pass_issued_at'] = ls.documents.pass_deliv_at;       
        
        //Passport 2
        ls.staffMember['doc_pass2_country'] = ls.documents.pass2_ctry_en;	
        ls.staffMember['doc_pass2_country_code'] = ls.documents.pass2_ctry;	
        ls.staffMember['doc_pass2_doc_nbr'] = ls.documents.pass2_doc_nbr;	
        ls.staffMember['doc_pass2_valid_from'] = ls.documents.pass2_start_date;	
        ls.staffMember['doc_pass2_valid_until'] = ls.documents.pass2_end_date;	
        ls.staffMember['doc_pass2_issued_by'] = ls.documents.pass2_deliv_by;	
        ls.staffMember['doc_pass2_issued_at'] = ls.documents.pass2_deliv_at;      
        
        //Residence Permit 
        ls.staffMember['doc_rp_country'] = ls.documents.rp_ctry_en;	
        ls.staffMember['doc_rp_country_code'] = ls.documents.rp_ctry;	
        ls.staffMember['doc_rp_doc_nbr'] = ls.documents.rp_doc_nbr;	
        ls.staffMember['doc_rp_valid_from'] = ls.documents.rp_start_date;	
        ls.staffMember['doc_rp_valid_until'] = ls.documents.rp_end_date;	
        ls.staffMember['doc_rp_issued_by'] = ls.documents.rp_deliv_by;	
        ls.staffMember['doc_rp_issued_at'] = ls.documents.rp_deliv_at;           
        
        //Work Permit (Work Licence)
        ls.staffMember['doc_wl_country'] = ls.documents.wl_ctry_en;	
        ls.staffMember['doc_wl_country_code'] = ls.documents.wl_ctry;	
        ls.staffMember['doc_wl_doc_nbr'] = ls.documents.wl_doc_nbr;	
        ls.staffMember['doc_wl_valid_from'] = ls.documents.wl_start_date;	
        ls.staffMember['doc_wl_valid_until'] = ls.documents.wl_end_date;	
        ls.staffMember['doc_wl_issued_by'] = ls.documents.wl_deliv_by;	
        ls.staffMember['doc_wl_issued_at'] = ls.documents.wl_deliv_at;       
        
        //ECHO field badge
        ls.staffMember['doc_ebdg_country'] = ls.documents.ebdg_ctry_en;	
        ls.staffMember['doc_ebdg_country_code'] = ls.documents.ebdg_ctry;	
        ls.staffMember['doc_ebdg_doc_nbr'] = ls.documents.ebdg_doc_nbr;	
        ls.staffMember['doc_ebdg_valid_from'] = ls.documents.ebdg_start_date;	
        ls.staffMember['doc_ebdg_valid_until'] = ls.documents.ebdg_end_date;	
        ls.staffMember['doc_ebdg_issued_by'] = ls.documents.ebdg_deliv_by;	
        ls.staffMember['doc_ebdg_issued_at'] = ls.documents.ebdg_deliv_at;      
        
	    //DUE office badge
        ls.staffMember['doc_dbdg_country'] = ls.documents.dbdg_ctry_en;	
        ls.staffMember['doc_dbdg_country_code'] = ls.documents.dbdg_ctry;	
        ls.staffMember['doc_dbdg_doc_nbr'] = ls.documents.dbdg_doc_nbr;	
        ls.staffMember['doc_dbdg_valid_from'] = ls.documents.dbdg_start_date;	
        ls.staffMember['doc_dbdg_valid_until'] = ls.documents.dbdg_end_date;	
        ls.staffMember['doc_dbdg_issued_by'] = ls.documents.dbdg_deliv_by;	
        ls.staffMember['doc_dbdg_issued_at'] = ls.documents.dbdg_deliv_at;   
        
	    //Laissez-passer
        ls.staffMember['doc_lap_country'] = ls.documents.lap_ctry_en;	
        ls.staffMember['doc_lap_country_code'] = ls.documents.laiss_ctry;	
        ls.staffMember['doc_lap_doc_nbr'] = ls.documents.laiss_doc_nbr;	
        ls.staffMember['doc_lap_valid_from'] = ls.documents.laiss_start_date;	
        ls.staffMember['doc_lap_valid_until'] = ls.documents.laiss_end_date;	
        ls.staffMember['doc_lap_issued_by'] = ls.documents.laiss_deliv_by;	
        ls.staffMember['doc_lap_issued_at'] = ls.documents.laiss_deliv_at;               
        
		return ls.staffMember;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveStaffMemberBasics
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function saveStaffMemberBasics( rc, authenticatedUser ){
    	var ls = {};	
        
        param name="rc.medical_exam_result" default="";  
        
        switch(rc.ms_status) {
        	case "MAR" : rc.mariagestatus = 1; break;
            case "SEP" : rc.mariagestatus = 3; break;
            case "DIV" : rc.mariagestatus = 5; break;
            case "WID" : rc.mariagestatus = 7; break;
            case "SIN" : rc.mariagestatus = 9; break;
            case "CIV" : rc.mariagestatus = 11; break;
            default : rc.mariagestatus = 0;
		};
        
        switch(rc.medical_exam_result) {
        	case "N" : rc.medical_exam_result = -1; break;
            case "Y" : rc.medical_exam_result = 1; break;     
            default : rc.medical_exam_result = 0;
		};        
        
/*        ls.response = {};
        ls.response.operation = "saveStaffMemberBasics";
        ls.response.staff_member_id = Variables.staff_member_id;
        ls.response.status_code = -1; //failure by default
        ls.errors = [];*/
        
        //ls.authenticatedUser = getAuthUser();
        ls.response = variables.staffDao.saveStaffMemberBasics( rc, authenticatedUser );
        
/*        if(Variables.citizenship_1_country_code == "") {
        	ls.error = {};
            
            ls.error.errorField = "citizenship_1_country_code";
            ls.error.errorValue = Variables.citizenship_1_country_code;      
            ls.error.errorMessage = Variables.citizenship_1_country_code;       
        	
            ArrayAppend(ls.errors, ls.error);        	
        }
        
        if( arrayLen(ls.errors) == 0 ) {
        	ls.response.status_code = 1; //success
        } else {
	        ls.response.errors = ls.errors; 
        }*/
        
        return ls.response;   
        
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateGD
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    
	public struct function validateGD( rc, authenticatedUser ){
    	var ls = {};	
        ls.retval = {};
        ls.retval["status"] = false;       
        ls.retval["errors"] = {};
        ls.retval.errors[rc.element_name] = {"errorMessage":"invalid email format"};        
        
		return ls.retval;  
	}                    
}    
