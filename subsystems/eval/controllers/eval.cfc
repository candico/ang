<cfcomponent accessors="Yes">

	<cfproperty  name="evalService">
	<cfproperty  name="sassDao">
	<cfproperty  name="closureDao">
	<cfproperty  name="prepDao">
	<cfproperty  name="evalDao">
	<cfproperty  name="feedbackDao">

<cfscript>

    
	public any function setFramework( fw ) { variables.fw = fw; return this; }

	public any function before() {}

	public any function onMissingMethod() {
		local.res = invoke(variables.evalService, arguments.missingMethodName, arguments.missingMethodArguments.rc);
		if (structKeyExists(local, 'res')) variables.fw.renderData("json", local.res);
	}

	public any function after() {}	
    
	function getUserData(){
		variables.fw.renderData("json", request.session.user );
	}
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function default
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	public void function default( rc ) {
    	var ls = {};        
       
        variables.fw.redirect( action = 'eval.grid', queryString = 'jx', append="id,field_office_id");
        
        if( StructKeyExists(rc, "jx") ) {
        	ls.viewData = variables.fw.view( "eval/grid" );
        	variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function grid 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function grid( rc ) {     
	    var ls = {};        
        
		ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        
        rc.chkAddEvaluation = checkUserPriv("addEvaluation", ls.user_id, ls.office_id);        
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/grid" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function checkUserPriv
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    public function checkUserPriv(required string priv, required string user_id, required string office_id, numeric eval_id){    	
    	var ls = {};
	    ls.chk = "N";         
        
        if( StructKeyExists(Arguments, "eval_id") )
	    	ls.chk = variables.evalService.checkUserPriv(priv, user_id, office_id, eval_id);   
		else  
	        ls.chk = variables.evalService.checkUserPriv(priv, user_id, office_id);            
    
	    return ls.chk;
    }   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function viewPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function viewPreparation( rc ) {     
	    var ls = {};  
       
		ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id ); 
       
        rc.chkViewEvaluation = checkUserPriv("viewEvaluation", ls.user_id, ls.office_id, ls.eval_id);
        if(rc.chkViewEvaluation == "N"){
        	throw("illegalAccessException2");
		} 
        
        rc.chkRequestAuthorization = checkUserPriv("requestAuthorization", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkDeleteEvaluation = checkUserPriv("deleteEvaluation", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkAuthorizePreparation = checkUserPriv("authorizePreparation", ls.user_id, ls.office_id, ls.eval_id);
        rc.chkEditPreparation = checkUserPriv("editPreparation", ls.user_id, ls.office_id, ls.eval_id);        
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/viewPreparation" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //matching view is called automatically
	}       
   
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getUsersByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getUsersByEval( rc ) {
		variables.fw.renderData("json", variables.evalService.getUsersByEval( argumentcollection = arguments.rc ) );
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function tabs
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function tabs( rc ) {     
	    var ls = {};               
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/tabs" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}        
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function setPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function setPreparation( rc ) {     
	    var ls = {};  
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/setPreparation" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}   
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function editPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function editPreparation( rc ) {     
	    var ls = {};  
       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
    	
        if( StructKeyExists(rc, "jx") ) {
			ls.viewData = variables.fw.view( "eval/editPreparation" );
			variables.fw.renderData().data( ls.viewData ).type( "html" );         
        }
		
        //else matching view is called automatically
	}       
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function saveEditPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function saveEditPreparation( rc ) {     
	    var ls = {};      
        
        //throw (message = "My Message", type = "My Exception Type");
       
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id ); 
        ls.lang_code = Session.user.settings.displayLanguage;   
        
        ls.retval = variables.evalService.saveEditPreparation(ls.user_id, ls.del_user_id, ls.eval_id, ls.office_id, ls.lang_code, rc);             
    	
        variables.fw.renderData("json", ls.retval);
	}
 
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPhasesByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getPhasesByEval( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;  
        ls.office_id = Session.user.settings.current_field_office_id;      
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage;            
                
        ls.retval = variables.evalService.getPhasesByEval(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}    
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getDocumentsByEval
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getDocumentsByEval( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id;  
        ls.office_id = Session.user.settings.current_field_office_id;       
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage;             
                
        ls.retval = variables.evalService.getDocumentsByEval(ls.user_id, ls.office_id, ls.eval_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getEvalTypes
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
    
	public void function getEvalTypes( rc ) { 
		var ls = {};          
        
        ls.user_id = Session.user.user_id; 
        ls.office_id = Session.user.settings.current_field_office_id; 
        ls.lang_code = Session.user.settings.displayLanguage;
                
        ls.retval = variables.evalService.getEvalTypes(ls.user_id, ls.office_id, ls.lang_code);        
        
        variables.fw.renderData("json", ls.retval);
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function requestAuthorization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function requestAuthorization( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );   
        ls.lang_code = Session.user.settings.displayLanguage; 
    	
		ls.retval = variables.evalService.requestAuthorization(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);    
        
        variables.fw.renderData("json", ls.retval);
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function authorizePreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function authorizePreparation( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
    	
		ls.retval = variables.evalService.authorizePreparation(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);        
        
        variables.fw.renderData("json", ls.retval);
	} 
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function rejectPreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function rejectPreparation( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
    	
		ls.retval = variables.evalService.rejectPreparation(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);        
        
        variables.fw.renderData("json", ls.retval);
	}                     
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getPrepComments
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function getPrepComments( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id;        
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );
        
        ls.retval = variables.evalService.getPrepComments(ls.user_id, ls.office_id, ls.eval_id);  
        
        variables.fw.renderData("json", ls.retval);        
	}      
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function deletePreparation
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
	public void function deletePreparation( rc ) {     
	    var ls = {};  
        
		ls.user_id = Session.user.user_id; 
        ls.del_user_id = Session.user.del_user_id; 
        ls.office_id = Session.user.settings.current_field_office_id;        
        ls.eval_id = ( structKeyExists(rc, "id") ? rc.id : rc.eval_id );     
        ls.lang_code = Session.user.settings.displayLanguage;
        
        ls.retval = variables.evalService.deletePreparation(ls.user_id, ls.del_user_id, ls.office_id, ls.eval_id, ls.lang_code, rc);  
        
        variables.fw.renderData("json", ls.retval);        
	}  

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getEvalData
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    

	public void function getEvalData( rc ) {
		variables.fw.renderData("json", variables.evalService.getEvalData( argumentcollection = arguments.rc ) );
	} 

</cfscript>

	<cffunction name="evalPDF">
		<cfset arguments.id = arguments.rc.evalId>

		<cfset local.prepData = variables.prepDao.getPrepDataQry(argumentcollection = arguments)>
		<cfset local.evalDetails = deserializeJSON(local.prepData.details[1])>

		<cfset local.participants.evaluee = listToArray(local.prepData.EVALUEE_ID[1], "|")>
		<cfset local.participants.evaluator = listToArray(local.prepData.EVALUATORS[1], "|")>
		<cfset local.participants.contributors = listToArray(local.prepData.CONTRIBUTORS[1], "|")>
		<cfset local.participants.d4 = listToArray(local.prepData.PREPARATORS[1], "|")>
		
		<cfset local.officeData = variables.evalDao.getOfficeData(argumentcollection = arguments)>

		<!--- <cfset local.users.evaluee = variables.evalDao.getEvalueeData(argumentcollection = arguments)> --->
		<cfset local.users.evaluee = variables.evalDao.getParticipantData(local.participants.evaluee)>
		<cfset local.users.evalueeContract = variables.evalDao.getContractData(local.participants.evaluee[1])>

		<cfset local.users.evaluator = variables.evalDao.getParticipantData(local.participants.evaluator)>
		<cfset local.users.contributors = variables.evalDao.getParticipantData(local.participants.contributors)>
		<cfset local.users.d4 = variables.evalDao.getParticipantData(local.participants.d4)>
		
		<!--- <cfdump  var="#local#"><cfabort> --->
		<!--- <cfdump  var="#officeData#"><cfabort> --->
		
		<cfif structKeyExists(arguments.rc, 'stateName') AND arguments.rc.stateName EQ 'evaluations.details.feedback'>
			<cfset local.contributorReport = true>
		<cfelse>
			<cfset local.contributorReport = false>
		</cfif>


		<cfsavecontent variable="local.evalHeader">
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<th align="right">Evaluee:</th>
					<td align="left"><cfoutput>#local.users.evaluee.LNAME[1]# #local.users.evaluee.FNAME[1]#</cfoutput></td>

					<th align="right">Duty Station:</th>
					<td align="left"><cfoutput>#local.officeData.CITY[1]#</cfoutput></td>

					<th align="right">Current Function:</th>
					<td align="left">
						<cfif local.users.evalueeContract.RecordCount GT 0>
							<cfoutput>#local.users.evalueeContract.POSITION_ROLE[1]#</cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<th align="right">In this post since:</th>
					<td align="left">
						<cfif local.users.evalueeContract.RecordCount GT 0>
							<cfoutput>#DateFormat(local.users.evalueeContract.CONTRACT_START[1], 'dd-mm-yyyy')#</cfoutput>
						</cfif>					
					</td>

					<th align="right">Contract end date:</th>
					<td align="left">
						<cfif local.users.evalueeContract.RecordCount GT 0>
							<cfoutput>#DateFormat(local.users.evalueeContract.CONTRACT_END[1], 'dd-mm-yyyy')#</cfoutput>
						</cfif>					
					</td>

					<th align="right">With ECHO since:</th>
					<td align="left">
						<cfif local.users.evalueeContract.RecordCount GT 0>
							<cfoutput>#DateFormat(local.users.evalueeContract.ECHO_START[1], 'dd-mm-yyyy')#</cfoutput>
						</cfif>
					</td>
				</tr>


				<tr>
					<th align="right">Evaluation period:</th>
					<td align="left">
						<span>
							<b>from:</b>
							<cfoutput>#DateFormat(local.prepData.START_ON[1], "dd-mm-yyyy")#</cfoutput>
						</span>
						&nbsp; &nbsp; 
						<span>
							<b>to:</b> 
							<cfoutput>#DateFormat(local.prepData.END_ON[1], "dd-mm-yyyy")#</cfoutput>
						</span>
					</td>

					<th align="right">Evaluation Type:</th>
					<td align="left"><cfoutput>#local.prepData.TYPE#</cfoutput></td>

					<th align="right">Date of Dialog:</th>
					<td align="left">
						<cfif structKeyExists(local.evalDetails.dt, 'evaluation_dialog_date')>
							<cfoutput>#DateFormat(local.evalDetails.dt.evaluation_dialog_date, "dd-mm-yyyy")#</cfoutput>
						</cfif>
					</td>
				</tr>


				<tr>
					<th align="right">Evaluator:</th>
					<td align="left" colspan="5">
						<cfoutput>#ValueList(local.users.evaluator.FULL_NAME, ", ")#</cfoutput>
					</td>
				</tr>


				<tr>
					<th align="right">Contributor(s):</th>
					<td align="left" colspan="5">
						<cfoutput>#ValueList(local.users.contributors.FULL_NAME, ", ")#</cfoutput>
					</td>
				</tr>
			</table>
		</cfsavecontent>


		<cfset local.sassData = variables.sassDao.getSass(argumentcollection = arguments)>

		<cfsavecontent variable="local.sass">
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<th>Competences</th>
					<th>Objectives for this evaluation period</th>
				</tr>
				<cfloop query="local.sassData">
				<tr>
					<td><cfoutput>#COMPETENCY#</cfoutput></td>
					<td><cfoutput>#OBJECTIVE#</cfoutput></td>
				</tr>			
				</cfloop>
			</table>
			
			<br>

			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<th rowspan="2">Competences set for this evaluation period</th>
					<th rowspan="2">Self-assessment</th>
					<th colspan="5">Evaluator assessment</th>
				</tr>
				<tr>
					<th>Comments</th>
					<th>BE</th>
					<th>MSE</th>
					<th>ME</th>
					<th>EE</th>
				</tr>			
				<cfloop query="local.sassData">
				<tr>
					<td><cfoutput>#COMPETENCY#</cfoutput></td>
					<td><cfoutput>#SELF_ASSESSMENT#</cfoutput></td>
					<td><cfoutput>#EVALUATOR_ASSESSMENT#</cfoutput></td>
					<td><cfif PERFORMANCE_LEVEL eq 'BE'><img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle"></cfif></td>
					<td><cfif PERFORMANCE_LEVEL eq 'MSE'><img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle"></cfif></td>
					<td><cfif PERFORMANCE_LEVEL eq 'ME'><img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle"></cfif></td>
					<td><cfif PERFORMANCE_LEVEL eq 'EE'><img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle"></cfif></td>
				</tr>			
				</cfloop>
			</table>
			<div style="font-size:11px;">BE: Below Expectations – MSE: Meet Some Expectations – ME: Meet Expectations – EE: Exceed expectations</div>
		</cfsavecontent>

		<cfset local.nextYearObjectivesData = variables.sassDao.getNextYearObjectives(argumentcollection = arguments)>

		<cfsavecontent variable="local.nextYearObjectives">
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<th>Competences</th>
					<th>Objectives for next evaluation period</th>
					<th>Potential learning activities</th>
				</tr>
				<cfloop query="local.nextYearObjectivesData">
				<tr>
					<td><cfoutput>#COMPETENCY#</cfoutput></td>
					<td><cfoutput>#OBJECTIVE#</cfoutput></td>
					<td><cfoutput>#LEARNING_ACTIVITY#</cfoutput></td>
				</tr>			
				</cfloop>
			</table>
		</cfsavecontent>		

		<cfset arguments.EVAL_ID = arguments.rc.evalId>
		<cfset local.closureData = variables.closureDao.getClosureComments(argumentcollection = arguments)>
		
		<cfsavecontent variable="local.closure">
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<th colspan="2" align="left">Final comments</th>
				</tr>
				<cfloop query="local.closureData">
				<tr>
					<td width="20%"><cfoutput>#FNAME# #LNAME#</cfoutput></td>
					<td><cfoutput>#COMMENTS#</cfoutput></td>
				</tr>			
				</cfloop>
			</table>
		</cfsavecontent>

		<cfquery name="local.closureD4" dbtype="query">
			SELECT * FROM closureData WHERE CREATED_BY IN (#arrayToList(local.participants.d4)#)
		</cfquery>

		<cfquery name="local.closureEvaluator" dbtype="query">
			SELECT * FROM closureData WHERE CREATED_BY IN (#arrayToList(local.participants.evaluator)#)
		</cfquery>

		<cfquery name="local.closureEvaluee" dbtype="query">
			SELECT * FROM closureData WHERE CREATED_BY IN (#arrayToList(local.participants.evaluee)#)
		</cfquery>				

		<cfsavecontent variable="local.closureSignature">
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<th align="left">Signature Evaluator</th>
					<th align="left">Signature Evaluee</th>
					<th align="left">Signature D4</th>
				</tr>
				<tr>
					<td>
						<cfloop query="local.closureEvaluator">
							<div>Date <cfoutput>#DateFormat(CREATED_ON, 'dd-mm-yyyy')# #TimeFormat(CREATED_ON, 'HH:nn:ss')#</cfoutput></div>
							<!--- <div>Read and acknowledged <input type="checkbox" <cfif READ_ACKNOWLEDGED eq 1>checked</cfif>></div>
							<div>Request for follow-up <input type="checkbox" <cfif REQUEST_FOLLOW_UP eq 1>checked</cfif>></div> --->
							<div>
							Read and acknowledged:
							<cfif READ_ACKNOWLEDGED eq 1>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							<cfelse>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-unavailable-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							</cfif>
							</div>
							<div>
							Request for follow-up:
							<cfif REQUEST_FOLLOW_UP eq 1>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							<cfelse>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-unavailable-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							</cfif>
							</div>
						</cfloop>
					</td>
					<td>
						<cfloop query="local.closureEvaluee">
							<div>Date <cfoutput>#DateFormat(CREATED_ON, 'dd-mm-yyyy')# #TimeFormat(CREATED_ON, 'HH:nn:ss')#</cfoutput></div>
							<!--- <div>Read and acknowledged <input type="checkbox" <cfif READ_ACKNOWLEDGED eq 1>checked</cfif>></div>
							<div>Request for follow-up <input type="checkbox" <cfif REQUEST_FOLLOW_UP eq 1>checked</cfif>></div> --->
							<div>
							Read and acknowledged:
							<cfif READ_ACKNOWLEDGED eq 1>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							<cfelse>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-unavailable-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							</cfif>
							</div>
							<div>
							Request for follow-up:
							<cfif REQUEST_FOLLOW_UP eq 1>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							<cfelse>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-unavailable-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							</cfif>
							</div>
						</cfloop>
					</td>
					<td>
						<cfloop query="local.closureD4">
							<div>Date <cfoutput>#DateFormat(CREATED_ON, 'dd-mm-yyyy')# #TimeFormat(CREATED_ON, 'HH:nn:ss')#</cfoutput></div>
							<!--- <div>Read and acknowledged <input type="checkbox" <cfif READ_ACKNOWLEDGED eq 1>checked</cfif>></div>
							<div>Request for follow-up <input type="checkbox" <cfif REQUEST_FOLLOW_UP eq 1>checked</cfif>></div> --->
							<div>
							Read and acknowledged:
							<cfif READ_ACKNOWLEDGED eq 1>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							<cfelse>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-unavailable-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							</cfif>
							</div>
							<div>
							Request for follow-up:
							<cfif REQUEST_FOLLOW_UP eq 1>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-checked-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							<cfelse>
								<img src="file:///<cfoutput>#ExpandPath('subsystems/eval/views/eval/icons8-unavailable-480.jpg')#</cfoutput>" height="20" width="20" align="middle">
							</cfif>
							</div>
						</cfloop>
					</td>								
				</tr>
			</table>
			<div style="font-size:11px;">
			In case one of the" request for follow-up boxes" is ticked the Team leader Field Experts Management in D4 will take over the file and propose an appropriate follow-up based on the specific needs
			</div>
		</cfsavecontent>

		<cfset arguments.EID = arguments.rc.evalId>
		<cfset local.feedbackData = variables.feedbackDao.getFeedbackQuestions(argumentcollection = arguments)>
		<cfset local.feedbackArr =  arrayNew(1)>

		<cfloop query="#local.feedbackData.contributors#">
			<cfsavecontent variable="local.feedback">
				<cfset local.contributorID = local.feedbackData.contributors.ID[local.feedbackData.contributors.currentrow]>
				<table cellspacing="0" cellpadding="0" border="0" width="100%" style="border-width: 0; margin-bottom: 20px;">
					<tr style="background-color: lightblue;">
						<th width="80%" style="border-width: 0;" align="left">
							<cfoutput>#local.feedbackData.contributors.FNAME[local.feedbackData.contributors.currentrow]#</cfoutput>
							<cfoutput>#local.feedbackData.contributors.LNAME[local.feedbackData.contributors.currentrow]#</cfoutput>
						</th>
						<th width="20%" style="border-width: 0;" align="right">
							<cfoutput>#DateFormat(local.feedbackData.answers[local.contributorID].ANSWER_DATE_TIME[1], 'dd-mm-yyyy')#</cfoutput>
						</th>
					</tr>
				</table>
				<cfloop query="#local.feedbackData.questions#">
					<cfset local.questionID = local.feedbackData.questions.ID[local.feedbackData.questions.currentrow]>
					<div>
						<h4 style="background-color: azure;">
							<cfoutput>#local.feedbackData.questions.currentrow#. #local.feedbackData.questions.QUESTION[local.feedbackData.questions.currentrow]#</cfoutput>
						</h4>
					</div>
					<div style="margin-bottom: 20px;">
					<cfoutput>
						<!--- (
						#DateFormat(local.feedbackData.answers[local.contributorID].ANSWER_DATE_TIME[local.questionID], 'dd-mm-yyyy')#
						#TimeFormat(local.feedbackData.answers[local.contributorID].ANSWER_DATE_TIME[local.questionID], 'HH:nn:ss')#
						) --->
						#local.feedbackData.answers[local.contributorID].ANSWER[local.questionID]#
					</cfoutput>
					</div>
				</cfloop>
			</cfsavecontent>
			<cfset arrayAppend(local.feedbackArr, local.feedback)>
		</cfloop>
		

		<cfsavecontent variable="local.stylesheet">
			<style type="text/css">
				body {
					font-family: Helvetica;
					font-size: 14px;
					background: white;
					margin: 0;
					padding-top: 0;
					padding-bottom: 0;
				}				
				table {
					margin-top: 0;
					margin-bottom: 2px;
					border-top-width: 1px;
					border-right-width: 1px;
					border-bottom-width: 0;
					border-left-width: 0;
				}
				table, th, td {
					border-color: #ddd;
					border-collapse: collapse;
					border-style: solid;
				}
				th { font-size: small; }
				td { font-size: smaller; }
				td, th {
					padding: 5px;
					border-top-width: 0;
					border-right-width: 0;
					border-bottom-width: 1px;
					border-left-width: 1px;
				}
				table>thead>tr>th, table>tbody>tr>td, table, tr, td, th, tbody, thead, tfoot { 
					page-break-inside:avoid!important;
					-ms-word-break: break-all;
					word-break: break-all;

					/* Non standard for WebKit */
					word-break: break-word;

					-webkit-hyphens: auto;
					-moz-hyphens: auto;
					hyphens: auto;
				}
				hr { border:0 none; border-top:1px solid #000; }			
			</style>
		</cfsavecontent>


		<!--- <cfoutput>#prepdfhtml#</cfoutput><cfabort> --->

		<cfdocument format="PDF" name="local.pdffile" orientation="portrait" pageType="A4" unit="cm" 
		margintop="5" marginbottom="2" marginleft="0.5" marginright="0.5" localurl="true" scale="90">
			<cfdocumentItem type="header" attributeCollection="#local#">
			<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
				<cfoutput>#attributes.stylesheet#</cfoutput>
			</head>
			<body>
				<table cellspacing="0" cellpadding="0" border="0" width="100%" style="border-width: 0;">
					<tr>
						<td width="80%" style="border-width: 0;" align="left"><b>Annex 3: Evaluation report form</b></td>
						<td width="20%" style="border-width: 0;" align="right"><cfoutput>#cfdocument.currentpagenumber# / #cfdocument.totalpagecount#</cfoutput></td>
					</tr>
				</table>
				<br>
				<cfoutput>#attributes.evalHeader#</cfoutput>
				<hr>
			</body>
			</html>
			</cfdocumentItem>


			<cfdocumentItem type="footer" attributeCollection="#local#">
			<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
				<cfoutput>#attributes.stylesheet#</cfoutput>
			</head>
			<body>
				<hr>
				<table cellspacing="0" cellpadding="0" border="0" width="100%" style="border-width: 0;">
					<tr>
						
						<td width="90%" style="border-width: 0;" align="left">
						<cfif attributes.contributorReport EQ false>
							This column is filled in on beforehand, based on the previous evaluation exercise. For the first evaluation report, 4 competences will be fixed by default (per type of TA-post) without objectives as they were not yet fixed.
						</cfif>
						</td>
						<td width="10%" style="border-width: 0;" align="right"><cfoutput>#cfdocument.currentpagenumber# / #cfdocument.totalpagecount#</cfoutput></td>
					</tr>
				</table>
				<br>
			</body>
			</html>
			</cfdocumentItem>


			<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
				<cfoutput>#local.stylesheet#</cfoutput>
			</head>
			<body>
				<cfif local.contributorReport EQ true>
					
					<cfloop from="1" to="#ArrayLen(local.feedbackArr)#" index="i">   
						<!--- <cfloop array="#local.feedbackArr#" index="local.currentItem"> --->
						<cfoutput>#local.feedbackArr[i]#</cfoutput>
						<cfif i lt ArrayLen(local.feedbackArr)>						
							<cfdocumentItem type="pagebreak"></cfdocumentItem>
						</cfif>
					</cfloop>					
				
				<cfelse>
					<cfoutput>#local.sass#</cfoutput>
					<br>
					<cfoutput>#local.nextYearObjectives#</cfoutput>
					
					<cfdocumentItem type="pagebreak"></cfdocumentItem>
					
					<cfoutput>#local.closure#</cfoutput>
					<br>
					<cfoutput>#local.closureSignature#</cfoutput>
				</cfif>
			</body>
			</html>
		</cfdocument>

		<cfset request.evalPDF = local.pdffile>
	</cffunction>

</cfcomponent>