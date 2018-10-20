Component accessors="true" {     
	    
    property fomService; 
    property fomDao; 
    property formatterService;
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFieldOfficeSummary
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      

	public struct function getFieldOfficeSummary(field_office_id){
    	var ls = {};
                
        ls.qry = variables.fomDao.getFieldOfficeSummaryQry(field_office_id); 
        
        ls.fieldOffice = {};         
        ls.fieldOffice['field_office_id'] = ls.qry.id;	  
        ls.fieldOffice['field_office_city'] = ls.qry.city;	      
        
        return ls.fieldOffice;
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getFieldOfficeDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function getFieldOfficeDetails(rc){
    	var ls = {};	
        
        ls.qry = variables.fomDao.getFieldOfficeQry(Arguments.rc.field_office_id);  
        //Should be a single-row result set
        ls.fieldOffice = {}; 
        
        //ls.fieldOffice['field_office_id'] = Arguments.rc.field_office_id;	
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
        ls.fieldOffice['cet'] = ls.qry.CET;	
        ls.fieldOffice['weekend_days'] = ls.qry.WEEKENDDAYS;	        
        
        switch( ls.fieldOffice['email_to_use'] ) {
            case 1: 
            	ls.fieldOffice['emtu_code'] = "OEM";
                ls.fieldOffice['emtu_label'] = "Official Email";
            	break;
            case 2: 
            	ls.fieldOffice['emtu_code'] = "AEM";
                ls.fieldOffice['emtu_label'] = "Administrative Email";
            	break; 
            case 3:
            	ls.fieldOffice['emtu_code'] = "FEM";
                ls.fieldOffice['emtu_label'] = "Favorite Email";
            	break;           
            default:
        		ls.fieldOffice['emtu_code'] = "";
                ls.fieldOffice['emtu_label'] = "";
            	break;
        }      
        
        switch( ls.fieldOffice['weekend_days'] ) {
            case 56: 
            	ls.fieldOffice['wed_code'] = "TF";
                ls.fieldOffice['wed_label'] = "Thursday - Friday";
            	break;
            case 67: 
	           	ls.fieldOffice['wed_code'] = "FS";
                ls.fieldOffice['wed_label'] = "Friday - Saturday";
            	break; 
            case 71:
    	       	ls.fieldOffice['wed_code'] = "SS";
                ls.fieldOffice['wed_label'] = "Saturday - Sunday";
            	break;           
            default:
           		ls.fieldOffice['wed_code'] = "";
                ls.fieldOffice['wed_label'] = "";
            	break;
        }               

        return ls.fieldOffice;        
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getAltFieldOfficeDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function getAltFieldOfficeDetails(rc){
    	var ls = {};	
        
        ls.qry = variables.fomDao.getAltFieldOfficeQry(Arguments.rc.field_office_id);  
        //Should be a single-row result set
        ls.fieldOffice = {}; 
        
        //ls.fieldOffice['field_office_id'] = Arguments.rc.field_office_id;	
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
        ls.fieldOffice['cet'] = ls.qry.CET;	
        ls.fieldOffice['weekend_days'] = ls.qry.WEEKENDDAYS;	        
        
        switch( ls.fieldOffice['email_to_use'] ) {
            case 1: 
            	ls.fieldOffice['emtu_code'] = "OEM";
                ls.fieldOffice['emtu_label'] = "Official Email";
            	break;
            case 2: 
            	ls.fieldOffice['emtu_code'] = "AEM";
                ls.fieldOffice['emtu_label'] = "Administrative Email";
            	break; 
            case 3:
            	ls.fieldOffice['emtu_code'] = "FEM";
                ls.fieldOffice['emtu_label'] = "Favorite Email";
            	break;           
            default:
        		ls.fieldOffice['emtu_code'] = "";
                ls.fieldOffice['emtu_label'] = "";
            	break;
        }      
        
        switch( ls.fieldOffice['weekend_days'] ) {
            case 56: 
            	ls.fieldOffice['wed_code'] = "TF";
                ls.fieldOffice['wed_label'] = "Thursday - Friday";
            	break;
            case 67: 
	           	ls.fieldOffice['wed_code'] = "FS";
                ls.fieldOffice['wed_label'] = "Friday - Saturday";
            	break; 
            case 71:
    	       	ls.fieldOffice['wed_code'] = "SS";
                ls.fieldOffice['wed_label'] = "Saturday - Sunday";
            	break;           
            default:
           		ls.fieldOffice['wed_code'] = "";
                ls.fieldOffice['wed_label'] = "";
            	break;
        }               

        return ls.fieldOffice;        
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveEditfieldOffice
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public struct function saveEditfieldOffice(rc){     
    	var ls = {};             
        
        ls.fieldList = ['field_office_id', 'address_line_1', 'address_line_2', 'postal_code', 'phone_number', 'fax_number', 'mobile_number',
        'satellite_number', 'iridium_number', 'official_email', 'admin_email', 'favorite_email',  
        'office_hours', 'cet'];   
        
        ls.items = {};
        
        for(ls.field in ls.fieldList) {
        	try {
	        	ls.items[ls.field] = rc[ls.field];
            }  catch(Any e) {
                ls.items[ls.field] = "XXX";
            }              
        }   
        
        try{
	        switch( rc['emtu_code'] ) {
                case "OEM": 
                    ls.items['email_to_use'] = 1;                
                    break;
                case "AEM": 
                    ls.items['email_to_use'] = 2;                
                    break; 
                case "FEM":
                    ls.items['email_to_use'] = 3;                
                    break;           
                default:
                    ls.items['email_to_use'] = 0;  //error
        	}     
        } catch(Any e) {        	
        } 
        
        try{
	        switch( rc['wed_code'] ) {
                case "TF": 
                    ls.items['weekend_days'] = 56;                
                    break;
                case "FS": 
                    ls.items['weekend_days'] = 67;                
                    break; 
                case "SS":
                    ls.items['weekend_days'] = 71;                
                    break;           
                default:
                    ls.items['weekend_days'] = 0;  //error
        	}     
        } catch(Any e) {	        
        }            
        
        ls.result = variables.fomDao.updateAltFieldOffice(ls.items);  
        
        ls.retval = {"result": ls.result}; 
        
        return ls.retval;     
    } 
    
    
}    