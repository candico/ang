component accessors=true {

	property commonDao;
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCountriesQry
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public query function getCountriesQry( ){
    	var ls = {};
		
		ls.qry = variables.commonDao.getCountriesQry();  
        
		return ls.qry;
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getStrings
// get strings for a specific language and domain
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public query function getStrings(lang_code, dom_code){
    	var ls = {};		
        
		return Application[lang_code][dom_code];
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setAllStrings
// Inject all strings in the Application scope
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function setAllStrings(){    	
		
		variables.commonDao.setAllStrings();          
		
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setAllCountries
// Inject all countries in the Application scope
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function setAllCountries(){    	
		
		variables.commonDao.setAllFSMCountries();          
		
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setAllCitizenships
// Inject all citizenships in the Application scope
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function setAllCitizenships(){    	
		
		variables.commonDao.setAllFSMCitizenships();          
		
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMailMessages
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function sendMailMessages(){   
	    var ls = {};         
        
     	ls.qry = Variables.commonDao.getUnsentMailMessagesQry(); 
        for(ls.row in ls.qry){
        	sendMailMessage(ls.row.id, ls.row.sender, ls.row.recipients, ls.row.subject, ls.row.body);
        }
        
        return ls.retval;
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMailMessage
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function sendMailMessage(id, sender, recipients, subject, body){   
	    var ls = {}; 
        ls["retval"] = {};
        
     	ls.retval.result = Variables.commonDao.sendMailMessage(id, sender, recipients, subject, body); 
        
        return ls.retval;
	}           
}    
