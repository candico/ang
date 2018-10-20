component accessors=true {

	property nsmDao;
    property nsmAltDao;
    property gdAltDao;
    property fdAltDao;
    property peAltDao;
    property edAltDao;
    property coAltDao;
    
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
	
	public string function checkUserPriv( required string priv, required numeric user_id, required numeric office_id, required numeric staff_member_id ){
    	var ls = {};
		ls.chk = "N";
        
        switch(priv){
	        case("view_nsm"):             	
                ls.chk = Variables.nsmDao.chkViewNsm(user_id, office_id, staff_member_id); 
                break;   
	        case("edit_nsm"): 
            	ls.chk = Variables.nsmDao.chkEditNsm(user_id, office_id, staff_member_id); 
                break;    
	        case("add_nsm"):             	
				ls.chk = Variables.nsmDao.chkAddNsm(user_id, office_id); 
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
            	ls.chk = "Y";
        } 
        
		return ls.chk;
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getNSMGridData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public array function getNSMGridData(required numeric user_id, required numeric office_id){
    	var ls = {};
		ls.arr = [];
		ls.qry = Variables.nsmDao.getNSMGridDataQry(user_id, office_id);
        
		for( ls.row in ls.qry ){
			ls.staffMember = {};
			ls.staffMember['staff_member_id'] = ls.row.staff_member_id;			
			ls.staffMember['contract_id'] = ls.row.contract_id;	
            ls.staffMember['start_date'] = ls.row.start_date;	
            ls.staffMember['end_date'] = ls.row.end_date;			
			ls.staffMember['last_name'] = ls.row.last_name;			
			ls.staffMember['first_name'] = ls.row.first_name;	
            ls.staffMember['staff_type'] = ls.row.staff_type;	
            ls.staffMember['fg'] = ls.row.fg;	
            ls.staffMember['office'] = ls.row.office;		      
            ls.staffMember['office_id'] = ls.row.office_id;		                  
			ls.staffMember['job'] = ls.row.job;	
            		                  
			ArrayAppend(ls.arr, ls.staffMember);
		}  
        
		return ls.arr;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getStaffMemberDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function getStaffMemberDetails(required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};  
        ls.office_id = office_id; 
        
        ls.qry = Variables.nsmDao.getStaffMemberDetailsQry(staff_member_id);
        
        for( ls.row in ls.qry ){
            ls.staffMember = {};            
            ls.staffMember['staff_member_id'] = ls.row.staff_member_id;	
            ls.staffMember['last_name'] = ls.row.last_name;			
            ls.staffMember['first_name'] = ls.row.first_name;			      
            ls.staffMember['email'] = ls.row.email;	 
            
            ls.staffMember['office_id'] = ls.row.office_id;			      
            ls.staffMember['home_office'] = ls.row.home_office;	                       	
                
            ls.staffMember['contract_id'] = ls.row.contract_id;		
            ls.staffMember['contract_version'] = ls.row.contract_version;	
            ls.staffMember['contract_start'] = ls.row.contract_start;	
            ls.staffMember['contract_end'] = ls.row.contract_end; 
            ls.staffMember['ext_type'] = ls.row.ext_type; 
            ls.staffMember['function_group'] = ls.row.function_group; 
            ls.staffMember['step'] = ls.row.step;             
                          
            ls.staffMember['contract_role'] = ls.row.contract_role;	  
            ls.staffMember['position_role'] = ls.row.position_role;	 
        }       
        
		return ls.staffMember;
	}  
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getWorkflowDetails
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-           
    
	public array function getWorkflowDetails(required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};  
        
        ls.qry = Variables.nsmDao.getWorkflowDetailsQry(staff_member_id);
        ls.workflow = [];
        
        for( ls.row in ls.qry ){
            ls.step = {};       
            ls.step["id"] = ls.row.id;      
            ls.step["initiator"] = ls.row.initiator;	
            ls.step["assignee"] = ls.row.assignee;
            ls.step["status_code"] = ls.row.status_code; 
            ls.step["created_on"] = ls.row.created_on;
            ls.step["comments"] = ls.row.comments;	
            
            ArrayAppend(ls.workflow, ls.step); 
        }       
        
		return ls.workflow;
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getWorkflowStatus
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-           
    
	public string function getWorkflowStatus(required numeric user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};  
        
        ls.result = Variables.nsmDao.getWorkflowStatus(staff_member_id);        
        
		return ls.result;
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function addStaffMember
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function addStaffMember(required numeric user_id, required any del_user_id, required numeric office_id, required string username){
    	var ls = {};                 
		ls.retval = {}; 
        ls.data = {};          	           
        
        //create new extern (in alt)        
        ls.newStaffMemberId = Variables.nsmAltDao.getNewStaffMemberId();
        ls.res1 = Variables.nsmAltDao.createStaffMember(username, ls.newStaffMemberId);
        
        //create new pseudo-contract (in alt)        
        ls.newContractId =  Variables.nsmAltDao.getNewContractId();
        ls.res2 = Variables.nsmAltDao.createContract(ls.newContractId, ls.newStaffMemberId);
        
		//create new pseudo-contract version (in alt)        
        ls.newContractVersionId =  Variables.nsmAltDao.getNewContractVersionId();
        ls.data["type"] = "LOC";
        ls.data["officeId"] = office_id;
        ls.res3 = Variables.nsmAltDao.createContractVersion(username, ls.newContractVersionId, ls.newContractId, ls.data); 
        
        //create new fsmUser        
        ls.new_fsm_user_id = ls.retval["newStaffMemberId"] = ls.newStaffMemberId;    
        Variables.nsmAltDao.createFsmUser(user_id, del_user_id, ls.new_fsm_user_id, ls.newStaffMemberId);   	         
        
		return ls.retval;       
	}     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function WF_Start
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function WF_Start(required numeric user_id, required any del_user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};                 
		ls.retval = {}; 
        
		ls.retval["result"] = Variables.nsmDao.wfStart(user_id, del_user_id, office_id, staff_member_id); 
        
		return ls.retval;       
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function WF_Accept
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function WF_Accept(required numeric user_id, required any del_user_id, required numeric office_id, required numeric staff_member_id){
    	var ls = {};                 
		ls.retval = {}; 
        
		ls.retval["result"] = Variables.nsmDao.wfAccept(user_id, del_user_id, office_id, staff_member_id); 
        
		return ls.retval;       
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function WF_Reject
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
	public struct function WF_Reject(required numeric user_id, required any del_user_id, required numeric office_id, required numeric staff_member_id, required string comments){
    	var ls = {};                 
		ls.retval = {}; 
        
		ls.retval["result"] = Variables.nsmDao.wfReject(user_id, del_user_id, office_id, staff_member_id, comments); 
        
		return ls.retval;       
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUpdatedTabs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public struct function getUpdatedTabs( required numeric user_id, required numeric del_user_id, required numeric office_id, required numeric staff_member_id ) { 
		var ls = {};  
        ls.retval = {};
        
        ls.gdQry =  variables.gdAltDao.getLastUpdateQry(staff_member_id);
        ls.retval["gd"] = ls.gdQry.recordCount;
        
        ls.fdQry =  variables.fdAltDao.getLastUpdateQry(staff_member_id);
        ls.retval["fd"] = ls.fdQry.recordCount;
        
        ls.peQry =  variables.peAltDao.getLastUpdateQry(staff_member_id);
        ls.retval["pe"] = ls.peQry.recordCount;
        
        ls.edQry =  variables.edAltDao.getLastUpdateQry(staff_member_id);      
        ls.retval["ed"] = ls.edQry.recordCount;
        
        ls.coQry =  variables.coAltDao.getLastUpdateQry(staff_member_id);      
        ls.retval["co"] = ls.coQry.recordCount;        
        
   		return ls.retval;  
	}        
           
}    




