component accessors=true {

	property staffDao;
    property commonService;
    
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
// Function getNSMListData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public array function _getNSMListData(required numeric office_id){
    	var ls = {};
		ls.arr = [];
		ls.qry = Variables.staffDao.getNSMListDataQry(office_id);
        
		for( ls.row in ls.qry ){
			ls.staffMember = {};
			ls.staffMember['staff_member_id'] = ls.row.staff_member_id;			
			ls.staffMember['contract_id'] = ls.row.contract_id;			
			ls.staffMember['last_name'] = ls.row.last_name;			
			ls.staffMember['first_name'] = ls.row.first_name;			      
			ls.staffMember['job'] = ls.row.job;	
            		                  
			ArrayAppend(ls.arr, ls.staffMember);
		}
        
		return ls.arr;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function prepareMessages
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function prepareMessages(rc){
    	var ls = {};
		ls.messages = {};
        
		ls.qry = Variables.staffDao.getAllWorkflowActorsQry();
        
		for( ls.row in ls.qry ){
	        ls.messages[ls.row.email][ls.row.staff_member_id] = {};
            ls.messages[ls.row.email][ls.row.staff_member_id]["staff_member_id"] = ls.row.staff_member_id;
            ls.messages[ls.row.email][ls.row.staff_member_id]["staff_member"] = ls.row.staff_member;
			ls.messages[ls.row.email][ls.row.staff_member_id]["assignee"] = ls.row.assignee;
			ls.messages[ls.row.email][ls.row.staff_member_id]["initiator"] = ls.row.initiator;    
            ls.messages[ls.row.email][ls.row.staff_member_id]["initiated_on"] = ls.row.initiated_on;      
            ls.messages[ls.row.email][ls.row.staff_member_id]["status_code"] = ls.row.status_code;  			
		}
        
		return ls.messages;
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMessages
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function sendMessages(rc){
    	var ls = {};
		ls.messages = {};
        

        
		return ls.messages;
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function sendMessage
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function sendMessage(rc){
    	var ls = {};
		ls.messages = {};
        

        
		return ls.messages;
	}        
           
}    


