component accessors="true" {

    property fomDao;     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function init
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function init( fw ) {
		Variables.fw = fw;
		return this;
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Built-in Function before
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public any function before( rc ) {
    	setting showdebugoutput = "No";    	
	}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
	
	public string function checkUserPriv( required string priv, required numeric user_id, required numeric office_id ){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
	        case("viewOffice"): 
            	ls.chk = Variables.fomDao.chkViewOffice(user_id, office_id); 
                break;
	        case("viewNewOffice"): 
            	ls.chk = Variables.fomDao.chkViewNewOffice(user_id, office_id); 
                break;                
	        case("editOffice"): 
            	ls.chk = Variables.fomDao.chkEditOffice(user_id, office_id); 
                break;    
	        case("validateOffice"): 
            	ls.chk = Variables.fomDao.chkValidateOffice(user_id, office_id); 
                break;    
	        case("rejectValidate"): 
            	ls.chk = Variables.fomDao.chkRejectValidate(user_id, office_id); 
                break;                    
        	case("requestValidateOffice"): 
            	ls.chk = Variables.fomDao.chkRequestValidateOffice(user_id, office_id); 
                break;   
        	case("viewEditStatus"): 
            	ls.chk = Variables.fomDao.chkViewEditStatus(user_id, office_id); 
                break;                                                               
            default: 
            	ls.chk = "N";
        } 
        
		return ls.chk;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFieldOfficeSummary
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      

	public struct function getFieldOfficeSummary( field_office_id ){
    	var ls = {};
                
        ls.qry = variables.fomDao.getFieldOfficeSummaryQry( field_office_id ); 
        
        ls.fieldOffice = {};         
        ls.fieldOffice['field_office_id'] = ls.qry.id;	  
        ls.fieldOffice['field_office_city'] = ls.qry.city;	      
        
        return ls.fieldOffice;
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFieldOfficeDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function getFieldOfficeDetails( rc ){
    	var ls = {};	
        
        ls.qry = variables.fomDao.getFieldOfficeQry( rc.field_office_id );  
        
        //Should be a single-row result set
        ls.fieldOffice = {};         
       	
        ls.fieldOffice['address_line_1'] = ls.qry.ADDRESSLINE1;	
        ls.fieldOffice['address_line_2'] = ls.qry.ADDRESSLINE2;	
        ls.fieldOffice['postal_code'] = ls.qry.POSTALCODE;	
        
        ls.fieldOffice['phone_number'] = ls.qry.PHONENUMBER;	
        ls.fieldOffice['fax_number'] = ls.qry.FAXNUMBER;	
        ls.fieldOffice['mobile_number'] = ls.qry.MOBILENUMBER;	
        ls.fieldOffice['satellite_number'] = ls.qry.SATELLITENUMBER;	
        ls.fieldOffice['iridium_number'] = ls.qry.IRIDIUMNUMBER;	
        
        ls.fieldOffice['official_email'] = ls.qry.OFFICIALEMAIL;	
        ls.fieldOffice['admin_email'] = ls.qry.ADMINEMAIL;	
        ls.fieldOffice['favorite_email'] = ls.qry.FAVORITEEMAIL;	
        ls.fieldOffice['email_to_use'] = ls.qry.EMAILTOUSE;         
        
        
        
/*        ls.fieldOffice['office_hours'] = ls.qry.OFFICEHOURS;	
 		ls.fieldOffice['office_hours_mo'] = ls.qry.OFFICEHOURS_MO;
        ls.fieldOffice['office_hours_tu'] = ls.qry.OFFICEHOURS_TU;
        ls.fieldOffice['office_hours_we'] = ls.qry.OFFICEHOURS_WE;
        ls.fieldOffice['office_hours_th'] = ls.qry.OFFICEHOURS_TH;
        ls.fieldOffice['office_hours_fr'] = ls.qry.OFFICEHOURS_FR;
        ls.fieldOffice['office_hours_sa'] = ls.qry.OFFICEHOURS_SA;
        ls.fieldOffice['office_hours_su'] = ls.qry.OFFICEHOURS_SU;*/        
        
        
        
        ls.fieldOffice['cet'] = ls.qry.CET;	
        ls.fieldOffice['weekend_days'] = ls.qry.WEEKENDDAYS;	
        
        ls.fieldOffice["editor"] = ls.qry.EDITOR_FNAME & " " & ls.qry.EDITOR_LNAME;
        ls.fieldOffice["edited_on"] = ls.qry.MODIFIED_ON;
        ls.fieldOffice["status"] = ls.qry.STATUS;
        
        switch( ls.fieldOffice['email_to_use'] ) {
            case 1: 
            	ls.fieldOffice['emtu_code'] = "OFFICIAL_EMAIL";
                ls.fieldOffice['emtu_label'] = "Official Email";
            	break;
            case 2: 
            	ls.fieldOffice['emtu_code'] = "ADMIN_EMAIL";
                ls.fieldOffice['emtu_label'] = "Administrative Email";
            	break; 
            case 3:
            	ls.fieldOffice['emtu_code'] = "FAVORITE_EMAIL";
                ls.fieldOffice['emtu_label'] = "favorite Email";
            	break;           
            default:
        		ls.fieldOffice['emtu_code'] = "";
                ls.fieldOffice['emtu_label'] = "";
            	break;
        }      
        
        switch( ls.fieldOffice['weekend_days'] ) {
            case 56: 
            	ls.fieldOffice['wed_code'] = "THU_FRI";
                ls.fieldOffice['wed_label'] = "Thursday - Friday";
            	break;
            case 67: 
	           	ls.fieldOffice['wed_code'] = "FRI_SAT";
                ls.fieldOffice['wed_label'] = "Friday - Saturday";
            	break; 
            case 71:
    	       	ls.fieldOffice['wed_code'] = "SAT_SUN";
                ls.fieldOffice['wed_label'] = "Saturday - Sunday";
            	break;           
            default:
           		ls.fieldOffice['wed_code'] = "";
                ls.fieldOffice['wed_label'] = "";
            	break;
        }    
        
		ls.businessHoursQry = variables.fomDao.getFieldOfficeHours( rc.field_office_id );   

        ls.fieldOffice["businessHours"] = [];
        
        for(ls.row in ls.businessHoursQry){
	        ls.day = {};
            ls.day["id"] = ls.row.id;
        	ls.day["day"] = ls.row.day;
            ls.day["am_opening_hour"] = ls.row.am_opening_hour;
            ls.day["am_opening_minute"] = ls.row.am_opening_minute;
            ls.day["am_closing_hour"] = ls.row.am_closing_hour;
            ls.day["am_closing_minute"] = ls.row.am_closing_minute;  
            ls.day["pm_opening_hour"] = ls.row.pm_opening_hour;
            ls.day["pm_opening_minute"] = ls.row.pm_opening_minute;
            ls.day["pm_closing_hour"] = ls.row.pm_closing_hour;
            ls.day["pm_closing_minute"] = ls.row.pm_closing_minute;                 
            
        	ArrayAppend(ls.fieldOffice.businessHours, ls.day);
        }                               

        return ls.fieldOffice;        
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getNewFieldOfficeDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function getNewFieldOfficeDetails( rc ){
    	var ls = {};	
        
        ls.qry = variables.fomDao.getAltFieldOfficeQry( rc.field_office_id );  
        //Should be a single-row result set
        ls.fieldOffice = {};         
       	
        ls.fieldOffice['address_line_1'] = ls.qry.ADDRESSLINE1;	
        ls.fieldOffice['address_line_2'] = ls.qry.ADDRESSLINE2;	
        ls.fieldOffice['postal_code'] = ls.qry.POSTALCODE;	
        
        ls.fieldOffice['phone_number'] = ls.qry.PHONENUMBER;	
        ls.fieldOffice['fax_number'] = ls.qry.FAXNUMBER;	
        ls.fieldOffice['mobile_number'] = ls.qry.MOBILENUMBER;	
        ls.fieldOffice['satellite_number'] = ls.qry.SATELLITENUMBER;	
        ls.fieldOffice['iridium_number'] = ls.qry.IRIDIUMNUMBER;	
        
        ls.fieldOffice['official_email'] = ls.qry.OFFICIALEMAIL;	
        ls.fieldOffice['admin_email'] = ls.qry.ADMINEMAIL;	
        ls.fieldOffice['favorite_email'] = ls.qry.FAVORITEEMAIL;	
        ls.fieldOffice['email_to_use'] = ls.qry.EMAILTOUSE;  
        
        ls.fieldOffice['office_hours'] = ls.qry.OFFICEHOURS;
        ls.fieldOffice['office_hours_mo'] = ls.qry.OFFICEHOURS_MO;
        ls.fieldOffice['office_hours_tu'] = ls.qry.OFFICEHOURS_TU;
        ls.fieldOffice['office_hours_we'] = ls.qry.OFFICEHOURS_WE;
        ls.fieldOffice['office_hours_th'] = ls.qry.OFFICEHOURS_TH;
        ls.fieldOffice['office_hours_fr'] = ls.qry.OFFICEHOURS_FR;
        ls.fieldOffice['office_hours_sa'] = ls.qry.OFFICEHOURS_SA;
        ls.fieldOffice['office_hours_su'] = ls.qry.OFFICEHOURS_SU;
        	
        ls.fieldOffice['cet'] = ls.qry.CET;	
        ls.fieldOffice['weekend_days'] = ls.qry.WEEKENDDAYS;	
        
		ls.fieldOffice["editor"] = ls.qry.EDITOR_FNAME & " " & ls.qry.EDITOR_LNAME;
        ls.fieldOffice["edited_on"] = ls.qry.MODIFIED_ON;
        ls.fieldOffice["status"] = ls.qry.STATUS;                
        
        switch( ls.fieldOffice['email_to_use'] ) {
            case 1: 
            	ls.fieldOffice['emtu_code'] = "OFFICIAL_EMAIL";
                ls.fieldOffice['emtu_label'] = "Official Email";
            	break;
            case 2: 
            	ls.fieldOffice['emtu_code'] = "ADMIN_EMAIL";
                ls.fieldOffice['emtu_label'] = "Administrative Email";
            	break; 
            case 3:
            	ls.fieldOffice['emtu_code'] = "FAVORITE_EMAIL";
                ls.fieldOffice['emtu_label'] = "favorite Email";
            	break;           
            default:
        		ls.fieldOffice['emtu_code'] = "";
                ls.fieldOffice['emtu_label'] = "";
            	break;
        }      
        
        switch( ls.fieldOffice['weekend_days'] ) {
            case 56: 
            	ls.fieldOffice['wed_code'] = "THU_FRI";
                ls.fieldOffice['wed_label'] = "Thursday - Friday";
            	break;
            case 67: 
	           	ls.fieldOffice['wed_code'] = "FRI_SAT";
                ls.fieldOffice['wed_label'] = "Friday - Saturday";
            	break; 
            case 71:
    	       	ls.fieldOffice['wed_code'] = "SAT_SUN";
                ls.fieldOffice['wed_label'] = "Saturday - Sunday";
            	break;           
            default:
           		ls.fieldOffice['wed_code'] = "";
                ls.fieldOffice['wed_label'] = "";
            	break;
        }      
        
		ls.businessHoursQry = variables.fomDao.getAltFieldOfficeHours( rc.field_office_id );   

        ls.fieldOffice["businessHours"] = [];
        
        for(ls.row in ls.businessHoursQry){
	        ls.day = {};
            ls.day["id"] = ls.row.id;
        	ls.day["day"] = ls.row.day;
            ls.day["am_opening_hour"] = ls.row.am_opening_hour;
            ls.day["am_opening_minute"] = ls.row.am_opening_minute;
            ls.day["am_closing_hour"] = ls.row.am_closing_hour;
            ls.day["am_closing_minute"] = ls.row.am_closing_minute;  
            ls.day["pm_opening_hour"] = ls.row.pm_opening_hour;
            ls.day["pm_opening_minute"] = ls.row.pm_opening_minute;
            ls.day["pm_closing_hour"] = ls.row.pm_closing_hour;
            ls.day["pm_closing_minute"] = ls.row.pm_closing_minute;                 
            
        	ArrayAppend(ls.fieldOffice.businessHours, ls.day);
        }                            

        return ls.fieldOffice;        
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getRolesByUser
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public array function getRolesByUser( required numeric user_id, required numeric office_id ){
    	var ls = {};
        ls.role_codes = [];
        
        ls.qry = variables.fomDao.getRolesByUserQry( user_id, office_id );
        
        for( ls.row in ls.qry ){
        	ArrayAppend(ls.role_codes, ls.row.role_code);
        }      	
        
        return ls.role_codes; 
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDiffs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function getDiffs( required struct off1, required struct off2 ){
    	var ls = {};
        ls.diffs = {};
    
      	for(ls.key in off1) {
        	if( ls.key == "businessHours" ) {
                ls.businessHours = off1.businessHours;
                ls.altBusinessHours = off2.businessHours;
               	for (ls.idx = 1; ls.idx <= ArrayLen(ls.businessHours); ls.idx++) { //ls.businessHours is an array                	
                	ls.day = ls.businessHours[ls.idx]; 
                    ls.altDay = ls.altBusinessHours[ls.idx]; 
                    ls.id = ls.day.id;
                	for ( ls.el in ls.day ) { 
                    	if ( ls.day[ls.el] != ls.altDay[ls.el] ) {
	                        ls.diffs["businessHours"][ls.id][ls.el] = ls.altDay[ls.el]; //note idx-1
                        }
                    }                
                }      
            } 
        	else if( StructKeyExists(off2, ls.key) ) {
            	if( isSimpleValue(off1[ls.key]) && isSimpleValue(off2[ls.key]) && off2[ls.key] != off1[ls.key] ) {
	            	ls.diffs[ls.key] = off2[ls.key];
                }
			}                
        }
        
        
        return ls.diffs;    
    }
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveEditFieldOffice
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function saveEditFieldOffice( required numeric user_id, required numeric office_id, required string username, required struct rc ){     
    	var ls = {};  
          
        ls.username = username;     
        ls.user_id = user_id;
        ls.office_id = office_id;    
        ls.items = {};         
        
        ls.fieldList = ['field_office_id', 'address_line_1', 'address_line_2', 'postal_code', 'phone_number', 'fax_number', 'mobile_number',
        'satellite_number', 'iridium_number', 'official_email', 'admin_email', 'favorite_email',  
        'office_hours', 'office_hours_mo', 'office_hours_tu', 'office_hours_we', 'office_hours_th', 'office_hours_fr', 'office_hours_sa', 'office_hours_su', 'cet'];    
              
        for(ls.field in ls.fieldList) {
        	try {
	        	ls.items[ls.field] = rc[ls.field];
            }  catch(Any e) {
                ls.items[ls.field] = "XXX";
            }              
        }   
        
        try{
	        switch( rc['emtu_code'] ) {
                case "OFFICIAL_EMAIL": 
                    ls.items['email_to_use'] = 1;                
                    break;
                case "ADMIN_EMAIL": 
                    ls.items['email_to_use'] = 2;                
                    break; 
                case "FAVORITE_EMAIL":
                    ls.items['email_to_use'] = 3;                
                    break;           
                default:
                    ls.items['email_to_use'] = 0;  //error
        	}     
        } catch(Any e) {        	
        } 
        
        try{
	        switch( rc['wed_code'] ) {
                case "THU_FRI": 
                    ls.items['weekend_days'] = 56;                
                    break;
                case "FRI_SAT": 
                    ls.items['weekend_days'] = 67;                
                    break; 
                case "SAT_SUN":
                    ls.items['weekend_days'] = 71;                
                    break;           
                default:
                    ls.items['weekend_days'] = 0;  //error
        	}     
        } 
        catch(Any e) {	        
        }      
        
       //Get business hours fields 
       
       	ls.days = {};
		for(ls.item in rc) {
        	ls.type = ListFirst(ls.item, "_");
            if( NOT ListFindNoCase("am,pm", ls.type) )
            	continue;
            ls.id = ListLast(ls.item, "_");
            if( NOT IsNumeric(ls.id) )
            	continue;
            if( NOT StructKeyExists(ls.days, ls.id) ){
            	ls.days[ls.id] = {};
                ls.days[ls.id].id = ls.id;                 
			}                
			//ls.label = ListDeleteAt( ls.item, 1, "_");               
            //ls.label = ListDeleteAt( ls.label, ListLen(ls.label, "_"), "_"); 
            ls.label = ListDeleteAt( ls.item, ListLen(ls.item, "_"), "_"); 
			ls.days[ls.id][ls.label] = rc[ls.item];                      
        }         
       
		//writeDump(ls.days);
	      //abort;           
        
        //To do: Main update, business hours updates and statuses update should all be in a transaction
        
        //Main update
        ls.result = variables.fomDao.updateAltFieldOffice( ls.username,  ls.items ); 
        
        //Business hours update
        for(ls.id in ls.days){       
        	ls.day = ls.days[ls.id];
            
            //writeDump(ls.day);
            
       		ls.result2 = variables.fomDao.updateAltFieldOfficeHours
            (             
                id: ls.day.id,
                username:ls.username,  
                
                am_opening_hour: ls.day.am_opening_hour,
                am_opening_minute: ls.day.am_opening_minute,        
                am_closing_hour: ls.day.am_closing_hour,
                am_closing_minute: ls.day.am_closing_minute,   
                
                pm_opening_hour: ls.day.pm_opening_hour,
                pm_opening_minute: ls.day.pm_opening_minute,        
                pm_closing_hour: ls.day.pm_closing_hour,
                pm_closing_minute: ls.day.pm_closing_minute 
            );       
        }         
        
        //Statuses update
        ls.isValidator = false;
        ls.user_roles = getRolesByUser( user_id, office_id);
        for (role_code in ls.user_roles) {
        	if( role_code == 'OMM_VALIDATOR') {
	            isValidator = true;
                break;
            }
        }    
        
        if(ls.isValidator == true){
        	variables.fomDao.updateAltFieldOfficeStatus(ls.username, ls.office_id, "OMM_VALIDATION_PENDING");
            variables.fomDao.insertStatusLog(ls.user_id, ls.office_id, "OMM_VALIDATION_PENDING");
        }
        else{
	        variables.fomDao.updateAltFieldOfficeStatus(ls.username, ls.office_id, "Edit in progress");
        }   
        
        ls.retval = {"result": ls.result}; 
        
        return ls.retval;     
    }        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function validateEdit
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function validateEdit( required numeric user_id, required numeric office_id, required string username ){
    	var ls = {};
        ls.retval = {};
        ls.alt_status = "In Activity";
        ls.log_status_code = "OMM_EXTERNAL_STATUS";	
        
	    ls.retval.result = variables.fomDao.validateEdit( user_id, office_id, username, ls.alt_status, ls.log_status_code );
        
        return ls.retval;      
    }    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function rejectEdit
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function rejectEdit( required numeric user_id, required numeric office_id, required string username ){
    	var ls = {};
        ls.retval = {};
        ls.alt_status = "Edit in progress";
		ls.log_status_code = "OMM_CORRECTION_PENDING";                 
        
	    ls.retval.result = variables.fomDao.rejectEdit( user_id, office_id, username, ls.alt_status, ls.log_status_code );
        
        return ls.retval;      
    }     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function requestValidate
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function requestValidate( required numeric user_id, required numeric office_id, required string username ){
    	var ls = {};
        ls.retval = {};    
        ls.alt_status = "OMM_VALIDATION_PENDING";
        ls.log_status_code = "OMM_VALIDATION_PENDING";        
    
	    ls.retval.result = variables.fomDao.requestValidate( user_id, office_id, username, ls.alt_status, ls.log_status_code );
        
        return ls.retval;       
    }  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function discardChanges
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function discardChanges( required numeric user_id, required numeric office_id ){
    	var ls = {};
        ls.retval = {};
        ls.log_status_code = "OMM_EXTERNAL_STATUS";		
        
	    ls.retval.result = variables.fomDao.discardChanges( user_id, office_id, ls.log_status_code );
        
        return ls.retval;      
    }        
}    