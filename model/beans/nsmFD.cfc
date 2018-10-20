Component accessors="true" {     
	    
    property staffService; 
    property staffDao; 
    property formatterService;
    
    property staff_member_id;
    property authenticatedUser;
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getMyInfo (this function is for development purposes)
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-     
    
    public string function getMyInfo() {
    	return "My Info on #formatterService.longdate( Now() )#";
    } 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDefaultQueryParams
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getDefaultQueryParams(data) {  
        
        param name="data.ID" type="string" default="0"; 
        param name="data.SURNAME" type="string" default=""; 
        param name="data.NAME" type="string" default="";    
        param name="data.FAMILYLINK" type="string" default="";          
         
        param name="data.GENDER" type="string" default="";        
        param name="data.DEPENDENT" type="string" default="N";        
        param name="data.SINCE" type="string" default="";  //add format validation
        param name="data.EXPATRIATED" type="string" default="N";
        param name="data.EXPATSINCE" type="string" default="";        
        param name="data.OCCUPATION" type="string" default="";
        
        param name="data.BIRTHDATE" type="string" default=""; 
        param name="data.BIRTH_CITY" type="string" default="";           
        param name="data.BIRTH_COUNTRYID" type="string" default="";  
        
        //param name="data.BIRTH_NATIONALITY_ID" type="string" default="";   
        
        param name="data.NATIONALITYCOUNTRYID" type="string" default="";     
        param name="data.NATIONALITYCOUNTRYID_2" type="string" default="";     
                
        //Contact in country of origin
        param name="data.SAME_ORIGIN" type="string" default="N"; 
        param name="data.ADDRESSLINE1" type="string" default=""; 
        param name="data.CITY" type="string" default=""; 
        param name="data.POSTALCODE" type="string" default=""; 
        param name="data.COUNTRYID" type="string" default=""; 
        param name="data.EFFECTDATE1" type="string" default=""; 
        
        param name="data.PROF_ORGANISATION" type="string" default="";  
        
        //Contact in residence country
        param name="data.SAME_RESIDENCE" type="string" default="N"; 
        param name="data.PRIVATE_ADDRESSLINE1" type="string" default=""; 
        param name="data.PRIVATE_CITY" type="string" default=""; 
        param name="data.PRIVATE_POSTALCODE" type="string" default=""; 
        param name="data.PRIVATE_COUNTRY" type="string" default=""; 
        param name="data.EFFECTDATE2" type="string" default=""; 
        
        param name="data.YEARINCOME" type="string" default=""; 
        param name="data.INCOMECURRENCY" type="string" default=""; 
        param name="data.DEATHDATE" type="string" default=""; 
        param name="data.PHONENUMBER" type="string" default=""; 
        param name="data.MOBILENUMBER" type="string" default=""; 
        param name="data.OTHERNUMBER" type="string" default=""; 
        param name="data.EMAIL" type="string" default=""; 
        param name="data.EMAIL2" type="string" default=""; 
        
        //Child
        param name="data.SCHOOLNAME" type="string" default=""; 
        param name="data.CHILD_SUPPORT" type="string" default="";  //correct this
        param name="data.LIFE_3_MONTHS" type="string" default="N"; 
        param name="data.SCHOOLADDRESSLINE1" type="string" default=""; 
        param name="data.SCHOOLCITY" type="string" default=""; 
        param name="data.SCHOOLCOUNTRYID" type="string" default=""; 
        param name="data.SCHOOLPOSTALCODE" type="string" default=""; 
        
        param name="data.EXT_ALLOW_NATURE" type="string" default=""; 
        param name="data.EXT_ALLOW_AMOUNT" type="string" default="";
        param name="data.EXT_ALLOW_COMMENTS" type="string" default="";
        
        param name="data.SCHOOLARSHIP_NATURE" type="string" default=""; 
        param name="data.SCHOOLARSHIP_AMOUNT" type="string" default="";
        param name="data.SCHOOLARSHIP_COMMENTS" type="string" default="";        
        
        return data;    
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDependent
// Returns only the user-editable fields"
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function getDependent(member_profile_id) { 
        var ls = {};    
        
        ls.dependent = getDefaultParams();
        ls.qry = variables.staffDao.getDependentQry(member_profile_id);
        
        //single result row expected
        for(ls.item in ls.dependent) {
        	ls.dependent[ls.item] = ls.qry[ls.item];        
        }     
        
        return ls.dependent;
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function mapNames
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public string function mapNames(name) {     
    	switch(name) { 	       
	        case "RELATION": return "FAMILYLINK"; 
        	case "IS_DEPENDENT": return "DEPENDENT"; 
            case "DEPENDENT_SINCE": return "SINCE";  
            case "IS_EXPATRIATE": return "EXPATRIATED";
            case "EXPATRIATE_SINCE": return "EXPATSINCE";   
            case "DOB": return "BIRTHDATE";     
            case "BIRTH_COUNTRY_CODE": return "BIRTH_COUNTRYID";                  
            case "CCO_SAME": return "SAME_ORIGIN";   
            case "CCO_ADDRESS": return "ADDRESSLINE1"; 
            case "CCO_CITY": return "CITY";  
            case "CCO_POSTAL_CODE": return "POSTALCODE";  
            case "CCO_COUNTRY_CODE": return "COUNTRYID";   
            case "CCO_SINCE": return "EFFECTDATE1"; 
            case "EMPLOYER": return "PROF_ORGANISATION"; 
            case "CITIZENSHIP_1_COUNTRY_CODE": return "NATIONALITYCOUNTRYID";
            case "CITIZENSHIP_2_COUNTRY_CODE": return "NATIONALITYCOUNTRYID_2";
            case "CRC_SAME": return "SAME_RESIDENCE";            
            case "CRC_ADDRESS": return "PRIVATE_ADDRESSLINE1";
            case "CRC_CITY": return "PRIVATE_CITY";
            case "CRC_POSTAL_CODE": return "PRIVATE_POSTALCODE";
            case "CRC_COUNTRY_CODE": return "PRIVATE_COUNTRY";
            case "CRC_SINCE": return "EFFECTDATE2";
            case "ANNUAL_INCOME": return "YEARINCOME";
            case "INCOME_CURRENCY": return "INCOMECURRENCY";
            case "DEATH_DATE": return "DEATHDATE";
            case "PHONE_NBR": return "PHONENUMBER";
            case "MOBILE_NBR": return "MOBILENUMBER";            
            case "OTHER_PHONE_NBR": return "OTHERNUMBER";
            case "EMAIL_1": return "EMAIL";
            case "EMAIL_2": return "EMAIL2";    
			case "SCHOOL_NAME": return "SCHOOLNAME";                                                                                   
            case "SUPPORT_OVER_AMOUNT": return "CHILD_SUPPORT";            
            case "ASSIGNMENT_PERIOD": return "LIFE_3_MONTHS";
            case "SCHOOL_ADDRESS": return "SCHOOLADDRESSLINE1";
            case "SCHOOL_CITY": return "SCHOOLCITY";
            case "SCHOOL_COUNTRY_CODE": return "SCHOOLCOUNTRYID";            
            case "SCHOOL_POSTAL_CODE": return "SCHOOLPOSTALCODE"; 
            
            case "SCHOLARSHIP_NATURE": return "SCHOOLARSHIP_NATURE"; 
            case "SCHOLARSHIP_AMOUNT": return "SCHOOLARSHIP_AMOUNT"; 
            case "SCHOLARSHIP_COMMENTS": return "SCHOOLARSHIP_COMMENTS";     
            
            default: return UCase(name);    	
        }    
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function reverseMapNames
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public string function reverseMapNames(name) {     
    	switch(name) {
	        case "FAMILYLINK": return "relation"; 
        	case "DEPENDENT": return "is_dependent"; 
            case "SINCE": return "dependent_since";  
            case "EXPATRIATED": return "is_expatriate";
            case "EXPATSINCE": return "expatriate_since";   
            case "BIRTHDATE": return "dob";     
            case "BIRTH_COUNTRYID": return "birth_country_code";                  
            case "SAME_ORIGIN": return "cco_same";   
            case "ADDRESSLINE1": return "cco_address"; 
            case "CITY": return "cco_city";  
            case "POSTALCODE": return "cco_postal_code";  
            case "COUNTRYID": return "cco_country_code";   
            case "EFFECTDATE1": return "cco_since";             
            case "PROF_ORGANISATION": return "employer"; 
            case "NATIONALITYCOUNTRYID": return "citizenship_1_country_code";
            case "NATIONALITYCOUNTRYID_2": return "citizenship_2_country_code";
            case "SAME_RESIDENCE": return "ccr_same";            
            case "PRIVATE_ADDRESSLINE1": return "crc_address";
            case "PRIVATE_CITY": return "crc_city";
            case "PRIVATE_POSTALCODE": return "crc_postal_code";
            case "PRIVATE_COUNTRY": return "crc_country_code";
            case "EFFECTDATE2": return "crc_since";
            case "YEARINCOME": return "annual_income";
            case "INCOMECURRENCY": return "income_currency";
            case "DEATHDATE": return "death_date";
            case "PHONENUMBER": return "phone_nbr";
            case "MOBILENUMBER": return "mobile_nbr";            
            case "OTHERNUMBER": return "other_phone_nbr";
            case "EMAIL": return "email_1";
            case "EMAIL2": return "email_2";    
			case "SCHOOLNAME": return "school_name";                                                                                   
            case "CHILD_SUPPORT": return "support_over_amount";            
            case "LIFE_3_MONTHS": return "assignment_period";
            case "SCHOOLADDRESSLINE1": return "school_address";
            case "SCHOOLCITY": return "school_city";
            case "SCHOOLCOUNTRYID": return "school_country_code";            
            case "SCHOOLPOSTALCODE": return "school_postal_code";
            
            case "SCHOOLARSHIP_NATURE": return "scholarship_nature";   
            case "SCHOOLARSHIP_AMOUNT": return "scholarship_amount";   
            case "SCHOOLARSHIP_COMMENTS": return "scholarship_comments";                
            
            default: return LCase(name);    	
        }    
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function hasAnyChange
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   

	public struct function hasAnyChange(newData) { 
        var ls.retval = {};      
        ls.retval.status = 1; 
        ls.retval["data"] = {};
        ls.retval.data["id"] = newData.id;
        ls.retval.data["changed"] = false;    
        ls.retval.data["changes"] = [];         
       
        //newData is the new version, ls.query is the current version
        ls.qry = variables.staffDao.getDependentQry(newData.id); 
        
        //single result row expected
        for(ls.item in newData) {	            
        	if( ls.item != "CHILD_SUPPORT" && ls.qry[ls.item][1] != newData[ls.item] ) {
            	ls.changedItem = {};
            	ls.changedItem["item"] = ls.item;
                ls.changedItem["oldval"] = ls.qry[ls.item][1]; 
                ls.changedItem["newval"] = newData[ls.item];               
                ArrayAppend(ls.retval.data.changes, ls.changedItem);                
            	ls.retval.data.changed = true; 
            }    
        }         
        
        return ls.retval;
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function updateDependents
// Does currently not update allowances and scholarships
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function updateDependents(rc){
    	var ls = {};     
        ls.retval = {};      
        ls.retval["status"] = 1;   
        ls.retval["data"] = {};
        ls.retval.data["changed"] = false;
        
        ls["data"] = {}; //preserve lower case
        
        for(ls.item in rc) {
        	ls.type = ListFirst(ls.item, "_");
            if( NOT ListFindNoCase("spouse,child,relative", ls.type) )
            	continue;
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
            if( NOT StructKeyExists(ls.data, ls.id) )
            	ls.data[ls.id] = {}; 
			ls.label = ListDeleteAt( ls.item, 1, "_");               
            ls.label = ListDeleteAt( ls.label, ListLen(ls.label, "_"), "_"); 
			ls.data[ls.id][ mapNames(ls.label) ] = rc[ls.item];  //assign values to db field names                       
        }
                
        for(ls.id in ls.data) {   
        	ls.elem = ls.data[ls.id];
        	ls.elem.id = ls.id;               
            
        	//Verify if anything changed             
            ls.tmp = hasAnyChange( ls["data"][ls.id] );  
            
           if( ls.tmp.data.changed == true ) {
	           ls.retval.data["changed"] = true;
            	ls.retval.data[ls.id] = ls.tmp.data.changes;
                ls.qryParams = getDefaultQueryParams(ls.elem); //add missing query params   
		        Variables.staffDao.saveDependent( ls.qryParams, Variables.authenticatedUser, Variables.staff_member_id ); 
			}
			else
            	ls.retval.data[ls.id] = "No changes";             
		}            		               
        
        return ls.retval;
        
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getSpouses
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getSpouses(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = [];  
        
        ls.qry = variables.staffDao.getNSMFamilyDataQry(Variables.staff_member_id);
        
        for(ls.row in ls.qry) {
        	if( ListFind("WIFE,HUSB,SPOU", ls.row.familylink) ) {
            	ls.item = {};
                
                ls.item["id"] = ls.row.id;
            	ls.item["surname"] = ls.row.lname;
               	ls.item["name"] = ls.row.fname;
                ls.item["relation"] = ls.row.familylink;
               	ls.item["dob"] = ls.row.birth_date;
                ls.item["gender"] = ls.row.gender;
                ls.item["is_dependent"] = ls.row.dependent;     
                ls.item["dependent_since"] = ls.row.dependent_since; 
                ls.item["is_expatriate"] = ls.row.expatriated;   
                ls.item["expatriate_since"] = ls.row.expat_since;  
                ls.item["occupation"] = ls.row.occupation;           
                ls.item["birth_city"] = ls.row.birth_city;
                ls.item["birth_country_code"] = ls.row.birth_countryid;
                
                //contact in country of origin
                ls.item["cco_same"] = ls.row.same_origin;
                ls.item["cco_address"] = ls.row.addressline1;
                ls.item["cco_city"] = ls.row.city;
                ls.item["cco_postal_code"] = ls.row.postalcode;
                ls.item["cco_country_code"] = ls.row.countryid;
                ls.item["cco_since"] = ls.row.effectdate1;
                
                ls.item["employer"] = ls.row.prof_organisation;
                ls.item["citizenship_1_country_code"] = ls.row.nationalitycountryid;  
                ls.item["citizenship_2_country_code"] = ls.row.nationalitycountryid_2;  
                
                //contact in residence country
                ls.item["crc_same"] = ls.row.same_residence;               
                ls.item["crc_address"] = ls.row.private_addressline1;
                ls.item["crc_city"] = ls.row.private_city;
                ls.item["crc_postal_code"] = ls.row.private_postalcode;
                ls.item["crc_country_code"] = ls.row.private_country;
                ls.item["crc_since"] = ls.row.effectdate2;          
                
                ls.item["annual_income"] = ls.row.yearincome;
                ls.item["income_currency"] = ls.row.incomecurrency;
                ls.item["death_date"] = ls.row.deathdate;
                ls.item["phone_nbr"] = ls.row.phonenumber;
                ls.item["mobile_nbr"] = ls.row.mobilenumber;
                ls.item["other_phone_nbr"] = ls.row.othernumber;
                ls.item["email_1"] = ls.row.email;
                ls.item["email_2"] = ls.row.email2;         
                
                //ls.item["ext_allow_nature"] = ls.row.ext_allow_nature;
                //ls.item["ext_allow_amount"] = ls.row.ext_allow_amount;
                //ls.item["ext_allow_comments"] = ls.row.ext_allow_comments;                                     
                
                ArrayAppend(ls.retval.data, ls.item);
            }   
		}      
        
        //writeDump(ls.retval.data);
            //abort;     
            
  		return ls.retval;
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getSpouseFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getSpouseFields(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = [];   
        
        ArrayAppend(ls.retval.data, "ID");
        ArrayAppend(ls.retval.data, "SURNAME");
        ArrayAppend(ls.retval.data, "NAME");
        ArrayAppend(ls.retval.data, "BIRTHDATE");
        ArrayAppend(ls.retval.data, "GENDER");
        ArrayAppend(ls.retval.data, "DEPENDENT");
        ArrayAppend(ls.retval.data, "SINCE");
        ArrayAppend(ls.retval.data, "EXPATRIATED");
        ArrayAppend(ls.retval.data, "EXPATSINCE");
        ArrayAppend(ls.retval.data, "NATIONALITYCOUNTRYID");                                                                        
        ArrayAppend(ls.retval.data, "NATIONALITYCOUNTRYID_2"); 
        ArrayAppend(ls.retval.data, "SAME_ORIGIN"); 
        ArrayAppend(ls.retval.data, "ADDRESSLINE1");
        ArrayAppend(ls.retval.data, "CITY");
        ArrayAppend(ls.retval.data, "POSTALCODE");
        ArrayAppend(ls.retval.data, "COUNTRYID");
		ArrayAppend(ls.retval.data, "EFFECTDATE1");        
        ArrayAppend(ls.retval.data, "PROF_ORGANISATION");
        ArrayAppend(ls.retval.data, "SAME_RESIDENCE");
        ArrayAppend(ls.retval.data, "PRIVATE_ADDRESSLINE1");
        ArrayAppend(ls.retval.data, "PRIVATE_CITY");
        ArrayAppend(ls.retval.data, "PRIVATE_POSTALCODE");        
        ArrayAppend(ls.retval.data, "PRIVATE_COUNTRY");        
        ArrayAppend(ls.retval.data, "EFFECTDATE2");
        ArrayAppend(ls.retval.data, "YEARINCOME");        
        ArrayAppend(ls.retval.data, "INCOMECURRENCY");
		ArrayAppend(ls.retval.data, "DEATHDATE");
        ArrayAppend(ls.retval.data, "PHONENUMBER");        
        ArrayAppend(ls.retval.data, "MOBILENUMBER");
        ArrayAppend(ls.retval.data, "OTHERNUMBER");
        ArrayAppend(ls.retval.data, "EMAIL");
        ArrayAppend(ls.retval.data, "EMAIL2");   
        
        ArrayAppend(ls.retval.data, "EXT_ALLOW_NATURE");  
        ArrayAppend(ls.retval.data, "EXT_ALLOW_AMOUNT");  
        ArrayAppend(ls.retval.data, "EXT_ALLOW_COMMENTS");                  
            
  		return ls.retval;
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addSpouse
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addSpouse(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = {};  
        
        //get spouse-specific fields
        ls.spouseFields = getSpouseFields().data; //array of field names
        
        //retrieve default values
        ls.defaults = getDefaultQueryParams(); //struct of default values
        
        //preserve only useful default values & map field names 
        for(fieldName in ls.spouseFields){
        	ls.retval.data[ reverseMapNames(fieldName) ] = ls.defaults[fieldName];
        }
        
        return ls.retval;          
	}         
        
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getChildren
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getChildren(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = [];        
        
        ls.qry = variables.staffDao.getNSMFamilyDataQry(Variables.staff_member_id);
        
        for(ls.row in ls.qry) {
        	if( ListFind("CHIL", ls.row.familylink) ) {
            	ls.item = {};
                                
                ls.item["id"] = ls.row.id;
            	ls.item["surname"] = ls.row.lname;
               	ls.item["name"] = ls.row.fname;
                ls.item["relation"] = ls.row.familylink;
               	ls.item["dob"] = ls.row.birth_date;
                ls.item["gender"] = ls.row.gender;
                ls.item["is_dependent"] = ls.row.dependent;     
                ls.item["dependent_since"] = ls.row.dependent_since; 
                ls.item["is_expatriate"] = ls.row.expatriated;   
                ls.item["expatriate_since"] = ls.row.expat_since;
                ls.item["citizenship_1_country_code"] = ls.row.nationalitycountryid;                
                ls.item["school_name"] = ls.row.schoolname;
                ls.item["citizenship_2_country_code"] = ls.row.nationalitycountryid_2;
                ls.item["support_over_amount"] = ls.row.child_support;
                ls.item["assignment_period"] = ls.row.life_3_months;
                ls.item["school_address"] = ls.row.schooladdressline1;
                ls.item["school_city"] = ls.row.schoolcity;
                ls.item["school_country_code"] = ls.row.schoolcountryid;
                ls.item["school_postal_code"] = ls.row.schoolpostalcode;
                
                //ls.item["ext_allow_nature"] = ls.row.ext_allow_nature;
                //ls.item["ext_allow_amount"] = ls.row.ext_allow_amount;
                //ls.item["ext_allow_comments"] = ls.row.ext_allow_comments;
                
                ls.item["scholarship_nature"] = ls.row.schoolarship_nature;
                ls.item["scholarship_amount"] = ls.row.schoolarship_amount;
                ls.item["scholarship_comments"] = ls.row.schoolarship_comments;
                
                ArrayAppend(ls.retval.data, ls.item);
            }
		}           
            
  		return ls.retval;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getChildFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getChildFields(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = [];   
        
        ArrayAppend(ls.retval.data, "ID");
        ArrayAppend(ls.retval.data, "SURNAME");
        ArrayAppend(ls.retval.data, "NAME");
        ArrayAppend(ls.retval.data, "BIRTHDATE");
        ArrayAppend(ls.retval.data, "GENDER");
        ArrayAppend(ls.retval.data, "DEPENDENT");
        ArrayAppend(ls.retval.data, "SINCE");
        ArrayAppend(ls.retval.data, "EXPATRIATED");
        ArrayAppend(ls.retval.data, "EXPATSINCE");
        ArrayAppend(ls.retval.data, "NATIONALITYCOUNTRYID");                                                                        
        ArrayAppend(ls.retval.data, "NATIONALITYCOUNTRYID_2"); 
        ArrayAppend(ls.retval.data, "CHILD_SUPPORT");
        ArrayAppend(ls.retval.data, "SCHOOLNAME");
        ArrayAppend(ls.retval.data, "SCHOOLCITY");
        ArrayAppend(ls.retval.data, "SCHOOLADDRESSLINE1");
        ArrayAppend(ls.retval.data, "SCHOOLCOUNTRYID");
        ArrayAppend(ls.retval.data, "LIFE_3_MONTHS");
        ArrayAppend(ls.retval.data, "SCHOOLPOSTALCODE");
        
        ArrayAppend(ls.retval.data, "EXT_ALLOW_NATURE");
        ArrayAppend(ls.retval.data, "EXT_ALLOW_AMOUNT");
        ArrayAppend(ls.retval.data, "EXT_ALLOW_COMMENTS");     
        
        ArrayAppend(ls.retval.data, "SCHOOLARSHIP_NATURE");
        ArrayAppend(ls.retval.data, "SCHOOLARSHIP_AMOUNT");
        ArrayAppend(ls.retval.data, "SCHOOLARSHIP_COMMENTS");               
            
  		return ls.retval;
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addChild
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addChild(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = {};  
        
        //get child-specific fields
        ls.childFields = getChildFields().data; //array of field names
        
        //retrieve default values
        ls.defaults = getDefaultQueryParams(); //struct of default values
        
        //preserve only useful default values & map field names 
        for(fieldName in ls.childFields){
        	ls.retval.data[ reverseMapNames(fieldName) ] = ls.defaults[fieldName];
        }
        
        return ls.retval;          
	}             
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getOtherRelatives
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getOtherRelatives(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval.result = "OK";
        ls.retval.data = [];   
        
        ls.qry = variables.staffDao.getNSMFamilyDataQry(Variables.staff_member_id);
        
        for(ls.row in ls.qry) {
        	if( NOT ListFind("CHIL,HUSB,WIFE,SPOU", ls.row.familylink) ) {
            	ls.item = {};        
                
                ls.item["id"] = ls.row.id; 
                ls.item["type"] = ls.row.familylink;
            	ls.item["surname"] = ls.row.lname;
               	ls.item["name"] = ls.row.fname;
               	ls.item["dob"] = ls.row.birth_date;      
                ls.item["gender"] = ls.row.gender;   
                ls.item["relation"] = ls.row.familylink;       
				ls.item["is_dependent"] = ls.row.dependent;     
                ls.item["dependent_since"] = ls.row.dependent_since;        
                ls.item["is_expatriate"] = ls.row.expatriated;   
                ls.item["expatriate_since"] = ls.row.expat_since;       
                ls.item["citizenship_1_country_code"] = ls.row.nationalitycountryid;
                ls.item["citizenship_2_country_code"] =  ls.row.nationalitycountryid_2;    
        
		        ArrayAppend(ls.retval.data, ls.item);
        	}
		}            
        
        return ls.retval;        
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getOtherRelativesFields
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getOtherRelativesFields(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval.result = "OK";
        ls.retval.data = [];   
        
        ArrayAppend(ls.retval.data, "ID");
        ArrayAppend(ls.retval.data, "SURNAME");
        ArrayAppend(ls.retval.data, "NAME");
        ArrayAppend(ls.retval.data, "BIRTHDATE");
        ArrayAppend(ls.retval.data, "GENDER");
        ArrayAppend(ls.retval.data, "DEPENDENT");
        ArrayAppend(ls.retval.data, "SINCE");
        ArrayAppend(ls.retval.data, "EXPATRIATED");
        ArrayAppend(ls.retval.data, "EXPATSINCE");
        ArrayAppend(ls.retval.data, "NATIONALITYCOUNTRYID");                                                                        
        ArrayAppend(ls.retval.data, "NATIONALITYCOUNTRYID_2");             
            
  		return ls.retval;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addOtherRelative
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function addOtherRelative(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval.result = "OK";
        ls.retval["data"] = {};  
        
        //get other relative-specific fields
        ls.otherRelativesFields = getOtherRelativesFields().data; //array of field names
        
        //retrieve default values
        ls.defaults = getDefaultQueryParams(); //struct of default values
        
        //preserve only useful default values & map field names 
        for(fieldName in ls.otherRelativesFields){
        	ls.retval.data[ reverseMapNames(fieldName) ] = ls.defaults[fieldName];
        }
        
        return ls.retval;          
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function removeRelative
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function removeRelative(authenticatedUser, relative_id){
    	var ls = {};
        
        ls.retval = {};
        ls.retval.result = "OK";
        ls.retval["data"] = {};  
        
	    ls.res = variables.staffDao.removeRelative(Variables.authenticatedUser, relative_id);
        
        return ls.retval;          
	}           
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getAllowances
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getAllowances(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval.result = "OK";
        ls.retval.data = [];   
        
        ls.qry = variables.staffDao.getNSMFamilyDataQry(Variables.staff_member_id);
        
        for(ls.row in ls.qry) {
        	if( ListFind("CHIL", ls.row.familylink) ) {
            	ls.item = {};        
                
                ls.item["id"] = ls.row.id;
                ls.item["type"] = ls.row.ext_allow_nature;
            	ls.item["amount"] = ls.row.ext_allow_amount;
               	ls.item["comments"] = ls.row.ext_allow_comments;
        
		        ArrayAppend(ls.retval.data, ls.item);
        	}
		}            
        
        return ls.retval;        
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getScholarships
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getScholarships(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval.result = "OK";
        ls.retval.data = [];   
        
        ls.qry = variables.staffDao.getNSMFamilyDataQry(Variables.staff_member_id);
        
        for(ls.row in ls.qry) {
        	if( ListFind("CHIL", ls.row.familylink) ) {
            	ls.item = {};        
                
                ls.item["id"] = ls.row.id; 
                ls.item["type"] = ls.row.schoolarship_nature;
            	ls.item["amount"] = ls.row.schoolarship_amount;
               	ls.item["comments"] = ls.row.schoolarship_comments;
        
		        ArrayAppend(ls.retval.data, ls.item);
        	}
		}            
        
        return ls.retval;        
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFamilyData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getFamilyData(){
    	var ls = {};
        
        ls.retval = {};
        ls.retval["status"] = 1;
        ls.retval["data"] = {};   
        
        ls.spouses = getSpouses().data;  
        ls.retval.data["spouses"] = ls.spouses;            
        
        ls.children = getChildren().data;
   		ls.retval.data["children"] = ls.children;            
        
        ls.other_relatives = getOtherRelatives().data;
   		ls.retval.data["other_relatives"] = ls.other_relatives;   	                                           
        
        return ls.retval;        
	}  
    
          
    
}    