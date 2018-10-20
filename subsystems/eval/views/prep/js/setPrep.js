app.controller('setPrepController', [ 	'$rootScope', 
										'$scope', 
										'$state',
										'$stateParams',
										'$templateCache', 
										'$http', 
										'$q',  
										'$timeout', 
										'uiGridConstants', 
										'evaluationService', 
										'masterService',
										'settingsService', 
										
										'dataService', 
										'Notification',
								function (	$rootScope, 
											$scope, 
											$state,
											$stateParams,
											$templateCache, 
											$http, 
											$q, 
											$timeout, 
											uiGridConstants,
											evaluationService,
											masterService,
											settingsService, 
										
											dataService, 
											Notification) {
	
	
	$scope.activeTabIndex = 0;
	$scope.viewOrEdit = $stateParams.viewEdit;
	$scope.dt = {}; // object (container) for dates that will be propagated to the children controllers

	$scope.getEvalTypes = function(){
		masterService.get("eval:eval", "getEvalTypes").then(function(response){ $scope.evalTypes = response; });
	}
	$scope.getUsersByEval = function(evalId){
		masterService.get("eval:eval", "getUsersByEval", {id:evalId}).then(function(response){ $scope.setParticipants(response); });
	}
	$scope.getEvalData = function(evalId){
		masterService.get("eval:eval", "getEvalData", {id:evalId}).then(function(response){ 
			if (response.length){
				$scope.evalData = response[0];
				$scope.dt.eval_start_on =  new Date($scope.evalData.START_ON);
				$scope.dt.eval_end_on =  new Date($scope.evalData.END_ON);
			}
		});
	}	

	$scope.getEvalTypes();
	$scope.getEvalData($stateParams.evalId);
	$scope.getUsersByEval($stateParams.evalId);

	
	$scope.data = {};
	$scope.strings = {};
	$scope.data = $scope.dt;


	var showErrors = false;
	var vm = this; //vm for ViewModel
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function initCtrl(tabMode) {

		console.log("initCtrl. Mode: ", tabMode);
		settingsService.get("prepController").then(function(resp){
			settings = resp.data;
			$scope.displayLanguage = settings.displayLanguage;
			officeId = settings.current_field_office_id;					

			moduleData = dataService.getModule("eval");
			moduleData.tabMode = $stateParams.viewEdit;
			//evalId = moduleData.evalId;
			evalId = $stateParams.evalId;
			$scope.data.evaluation_id = evalId;

			//resetTemplates(evalId);	
				
			//var p1 = setStrings($scope.displayLanguage);			
			//var p2 = evaluationService.getUsersByEval(evalId);					
			var p3 = evaluationService.getUsersByRole(evalId);	
			var p4 = evaluationService.getPhasesByEval(evalId);	
			//var p5 = evaluationService.getEvalData(evalId);	
			//var p6 = evaluationService.getDocumentsByEval(evalId);	
			//var p7 = evaluationService.getEvalTypes();	
			var p8 = evaluationService.getPrepComments(evalId);	
			
			$q.all([p3,p4,p8]).then(function(values){
				
				//participants = values[1].data;
				//evalData = values[4].data;
				//evalTypes = values[6].data;
				//documents = values[3].data;
				possibleParticipants = values[0].data;
				phases = values[1].data;
				comments = values[2].data;
				
				//setParticipants(participants);
				setPossibleParticipants(possibleParticipants);	
				setPhases(phases);
				//setEvalData(evalData);
				//setDocuments(documents);	
				setComments(comments);
				//setEvalTypes(evalTypes, evalData.type_id);
				
				console.log("moduleData.tabMode", moduleData.tabMode);
			});
		});
		//$scope.initDone = true;
		
		// $state.current.data.initDone = true;
		
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function resetTemplates(evalId){
		$templateCache.remove('index.cfm?action=eval:prep.viewPrep&jx&eval_id=' + evalId);
		$templateCache.remove('index.cfm?action=eval:prep.editPrep&jx&eval_id=' + evalId);	
		$scope.viewPrepURL = "index.cfm?action=eval:prep.viewPrep&jx&eval_id=" + evalId;	
		$scope.editPrepURL = "index.cfm?action=eval:prep.editPrep&jx&eval_id=" + evalId;					
	}
	
	function setEvalData(evalData){	
		if( $.isEmptyObject(evalData) )
			return;	
		
		$scope.data.eval_id = evalData.eval_id;		
		//$scope.data.eval_start_on = new Date(evalData.start_on);
		//$scope.data.eval_end_on = new Date(evalData.end_on);
		$scope.data.eval_type_id = evalData.type_id;
		$scope.data.status_code = evalData.status_code;
		$scope.data.status = $scope.strings["JS"][evalData.status_code];
	}	
	
/*	$scope.$watch(angular.bind(this, function () {
	  return this.displayLanguage;
	}), function (newVal) {	 
	  $scope.data.status = $scope.strings["JS"][$scope.data.status_code];
	});*/
	
	$scope.setParticipants = function(participants){
		if( $.isEmptyObject(participants) )
			return;	
		if(participants.evaluees)		
			$scope.evaluee = participants.evaluees[0];
		if(participants.supervisors)		
			$scope.supervisor = participants.supervisors[0];
		if(participants.contributors){					
			$scope.contributor_1 = participants.contributors.find( function(elem) {return getByPos(elem, 1)} );
			$scope.contributor_2 = participants.contributors.find( function(elem) {return getByPos(elem, 2)} );
			$scope.contributor_3 = participants.contributors.find( function(elem) {return getByPos(elem, 3)} );
		}
		if(participants.preparators)
			$scope.preparator = participants.preparators[0];
		if(participants.authorizers)	
			$scope.authorizer = participants.authorizers[0];	 
	}	
	
	function setEvalTypes(evalTypes, evalTypeId){
		if(!evalTypeId)
			return;
		
		//console.log(evalTypes, "evalTypeId", evalTypeId);
		$scope.data.evalTypes = evalTypes;
		$scope.evalType = evalTypes.find( function(elem) {return getById(elem, evalTypeId)} );	
		evalType = $scope.evalType;
		//console.log("$scope.evalType", $scope.evalType);
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function showError(errObj){		
		return showErrors;
		//return $scope.editPrepForm.$dirty;
	}
	
	function toggleErrors(){
		if(showErrors === true)
			showErrors = false;
		else
			showErrors = true;
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Validation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function noPartsDup(pos, elem) {	
		var elemName = "";
		if(elem)		
			elemName = elem[0].name;
		var retVal = true;
		var participants = [];		
		var dups = [];			
		var roles = ["evaluee","supervisor","contributor_1","contributor_2","contributor_3","preparator","authorizer"];
		var fieldNames = ["evaluee_id","supervisor_id","contributor_1_id","contributor_2_id","contributor_3_id","preparator_id","authorizer_id"];		
		
		for (var idx = 0; idx < roles.length; idx++){	
			if( vm[roles[idx]] && vm[roles[idx]]["user_id"] )
				participants.push( vm[roles[idx]]["user_id"] );	
			else 
				participants.push( "" );
		}
		
		for (var idx = 0; idx < participants.length; idx++){
			if(participants[idx] == "") {
				dups[idx] = true;
				continue;					
			}
			var tmp = participants.indexOf(participants[idx], idx+1);			
			if( tmp != -1){
				dups[idx] = false;
				dups[tmp] = false;	
			}
			else if(dups[idx] !== false)				
				dups[idx] = true;			
		}
		
		for (var idx = 0; idx < dups.length; idx++){
			var fieldName = fieldNames[idx];			
			if(dups[idx] === true)
				$scope.editPrepForm[fieldName].$setValidity("multi", true);
			else  {	
				$scope.editPrepForm[fieldName].$setValidity("multi", false);	
				if(elemName == fieldName || elemName == "")
					retVal = false;	
									
			}								
		}	
			
		if(retVal === true)
			Notification.info({message: 'Participants are OK', positionY: 'top', positionX: 'right'});	
		else
			Notification.warning({message: 'Participants are NOT OK', positionY: 'top', positionX: 'right'});			
		
		return retVal;
	};	

	
	$scope.isValid = function(fieldName){
		//console.log("isValid x", fieldName, $scope.editPrepForm, $scope.editPrepForm[fieldName].$valid);
		//if($scope.editPrepForm[fieldName].$valid === false) console.log("error", fieldName, $scope.editPrepForm[fieldName].$error);
		return angular.isDefined($scope.editPrepForm) ? $scope.editPrepForm[fieldName].$valid : false;
	}
	
	function futureValidityCheck(){
		return true;	
	}	
	
	function getByPos(elem, pos) {		
	  return elem.pos == pos;
	}
	
	function getById(elem, id) {
		return elem.id == id;	
	}
	
	function setPossibleParticipants(possibleParticipants){	
		$scope.data.evaluees = [];
		$scope.data.contributors = [];
		$scope.data.supervisors = [];
		$scope.data.preparators = [];
		$scope.data.authorizers = [];		
		
		if( $.isEmptyObject(possibleParticipants) )
			return;
				
		if(possibleParticipants.evaluees)			
			$scope.data.evaluees = possibleParticipants.evaluees; 
		if(possibleParticipants.contributors)			
			$scope.data.contributors = possibleParticipants.contributors; 	
		if(possibleParticipants.supervisors)			
			$scope.data.supervisors = possibleParticipants.supervisors; 	
		if(possibleParticipants.preparators)
			$scope.data.preparators = possibleParticipants.preparators; 
		if(possibleParticipants.authorizers)		
			$scope.data.authorizers = possibleParticipants.authorizers; 
	}	
	
	function setDocuments(documents){		
		if( $.isEmptyObject(documents) )
			return;	
			
		$scope.documents = documents;
	}	
	
	function setComments(comments){		
		if( $.isEmptyObject(comments) )
			return;	
			
		$scope.data.comments = comments;
	}	
	
	function setPhases(phases){			
		//$scope.data.eval_start_on = "";
		//$scope.data.eval_end_on = "";	
		$scope.data.prep_phase_start_on = "";
		$scope.data.prep_phase_end_on = "";
		$scope.data.assess_phase_start_on = "";
		$scope.data.assess_phase_end_on = "";
		$scope.data.rating_phase_start_on = "";
		$scope.data.rating_phase_end_on = "";
		$scope.data.closing_phase_start_on = "";
		$scope.data.closing_phase_end_on = "";	
		
		if( $.isEmptyObject(phases) )
			return;	

		if(phases.PREP_PHASE){
			$scope.data.prep_phase_start_on = new Date(phases.PREP_PHASE.start_on); //phases.PREP_PHASE.start_on;
			$scope.data.prep_phase_end_on = new Date(phases.PREP_PHASE.end_on); //phases.PREP_PHASE.end_on;
		}
		if(phases.ASSESS_PHASE) {
			$scope.data.assess_phase_start_on = new Date(phases.ASSESS_PHASE.start_on);
			$scope.data.assess_phase_end_on = new Date(phases.ASSESS_PHASE.end_on);
		}
		if(phases.RATING_PHASE) {
			$scope.data.rating_phase_start_on = new Date(phases.RATING_PHASE.start_on);
			$scope.data.rating_phase_end_on = new Date(phases.RATING_PHASE.end_on);
		}
		if(phases.CLOSING_PHASE) {
			$scope.data.closing_phase_start_on = new Date(phases.CLOSING_PHASE.start_on);
			$scope.data.closing_phase_end_on = new Date(phases.CLOSING_PHASE.end_on);					
		}
		if(phases.PROBATION_PHASE) {
			$scope.data.probation_phase_start_on = new Date(phases.PROBATION_PHASE.start_on);
			$scope.data.probation_phase_end_on = new Date(phases.PROBATION_PHASE.end_on);					
		}		
	}
	
	function setSelectedOptions() {		
		Object.keys(getUsersByRole).forEach(function(key) {		
			//console.log("key", key);
			vm[key] = {};			
			$scope.data[key].forEach(function(user){ 
				//console.log("user", user);
				var vmUser = vm[key][user.user_id] = {};
				//console.log("vmUser", vmUser);
				//assignCountryKeys(relative, vmRelative)
			});
		});
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// XXX??? functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	$scope.getEvalType = function (selected) {
		if(!selected)
			return;
						
		//console.log(selected); 
		$scope.evalType = selected.originalObject;
		console.log($scope.editPrepForm);
		console.log($scope.editPrepForm.type_id);
		$scope.editPrepForm.type_id = $scope.evalType.id;
		console.log($scope.editPrepForm.type_id); 
		
		//console.log("type_id value 1", $("#editPrepForm input[name=type_id]").val() );
		$("#editPrepForm input[name=type_id]").val(18);
		//console.log("type_id value 2", $("#editPrepForm input[name=type_id]").val() );
		
		//angular.element("#type_id").val(selected.originalObject.id);
		//return $scope.evalType;
	};	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions: View and Edit mode
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	/*function backToGrid(){		
		resetTemplates(evalId);
		$rootScope.$broadcast("setTabAndMode", {tab:"evalGrid", mode:"grid"});		
	}*/
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions: View mode
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function toggleViewEdit(mode){		
		$scope.viewOrEdit = mode;
	}


	
	function requestVal(){	
		if( !confirm("Are you sure you want to REQUEST validation for the changes?") )		
			return;
			
		evaluationService.requestVal(evalId).then(function(resp){
			var data = resp.data; 			
			var message = "Save Result:" + data.result;
			
			if(data.status && data.status == "error"){
				Notification.error({message:"Invalid Access", positionY: 'top', positionX: 'right'});				
				return;
			}
			
			if(data.result == "OK") {
				message += "<br>Submit sucessful";
				Notification.success({message: message, positionY: 'top', positionX: 'right'});
			}
			else {
				message += "<br>Submit did not succeed";	
				Notification.info({message: message, positionY: 'top', positionX: 'right'});
			}
				
			//backToGrid();							
		});				
	}		
	
	function acceptPrep(){	
		if( !confirm("Are you sure you want to ACCEPT the changes?") )		
			return;
			
		evaluationService.acceptPrep(evalId).then(function(resp){
			var data = resp.data; 			
			var message = "Save Result:" + data.result;
			
			if(data.status && data.status == "error"){
				Notification.error({message:"Invalid Access", positionY: 'top', positionX: 'right'});
				//location.href = "index.cfm";
				return;
			}
			
			if(data.result == "OK") {
				message += "<br>Submit sucessful";
				Notification.success({message: message, positionY: 'top', positionX: 'right'});
			}
			else {
				message += "<br>Submit did not succeed";	
				Notification.info({message: message, positionY: 'top', positionX: 'right'});
			}				
					
			//backToGrid();							
		});				
	}		
	
	function rejectPrep(){	
		if( !confirm("Are you sure you want to REJECT the changes?") )		
			return;
			
		evaluationService.rejectPrep(evalId).then(function(resp){
			var data = resp.data; 			
			var message = "Save Result:" + data.result;
			
			if(data.status && data.status == "error"){
				Notification.error({message:"Invalid Access", positionY: 'top', positionX: 'right'});
				//location.href = "index.cfm";
				return;
			}
			
			if(data.result == "OK") {
				message += "<br>Submit sucessful";
				Notification.success({message: message, positionY: 'top', positionX: 'right'});
			}
			else {
				message += "<br>Submit did not succeed";	
				Notification.info({message: message, positionY: 'top', positionX: 'right'});
			}
					
			//backToGrid();
			//initCtrl();				
		});				
	}		

	function deletePrep(){	
		if( !confirm("Are you sure you want to DELETE the preparation?") )		
			return;
			
		evaluationService.deletePrep(evalId).then(function(resp){
			var data = resp.data; 			
			var message = "Save Result:" + data.result;
			
			if(data.status && data.status == "error"){
				Notification.error({message:"Invalid Access", positionY: 'top', positionX: 'right'});
				//location.href = "index.cfm";
				return;
			}
			
			if(data.result == "OK") {
				message += "<br>Submit sucessful";
				Notification.success({message: message, positionY: 'top', positionX: 'right'});
			}
			else {
				message += "<br>Submit did not succeed";	
				Notification.info({message: message, positionY: 'top', positionX: 'right'});
			}
					
			//backToGrid();
			//initCtrl();				
		});				
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions: Edit mode
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function reload(){
		// reset all errors
		//console.log( "$('.ng-invalid'", $('.ng-invalid') );
		var form = $scope.editPrepForm;
		console.log("form.$error", form.$error);
		for (var att in form.$error) {
			//console.log("att", att, form.$error.hasOwnProperty(att));
			if (form.$error.hasOwnProperty(att)) {
				form.$setValidity(att, true);
				form["evaluee_id"].$setValidity(att, true);
			}
		}

		// reset validation's state
		//$scope.userForm.$setPristine(true);
		form.$setUntouched(); //set form to untouched 
		form.$setPristine(); //remove all validation error 
		//clear the upload field (in case of manual reload)	
		var fileElement = angular.element('#xfile');
		fileElement.val(null);
		//initCtrl();
	}

	$scope.savePrep = function(){
		var formData = jQuery('form').serialize();
		//var formData = jQuery('form').serializeArray(); // to produce an error
		masterService.post('eval:prep', 'savePrep', {EVAL_ID: $stateParams.evalId}, formData)
		.then(
			function onSuccess(response) {
				console.log('Success: ', response);
				if (response.retvals.result=='OK'){
					Notification.success({message: 'Saved', positionY: 'top', positionX: 'right'});
					$state.go('evaluations.details.preparation', {'evalId': $stateParams.evalId, 'viewEdit': 'view'});
				}
			},
			function onError(response) {
				Notification.error({message:response, positionY: 'top', positionX: 'right'});
				console.log('error: ', response);
			}
		);
		/*evaluationService.savePrep(evalId).then(function(resp){
			debugger;
			var data = resp.data; 			
			var message = "Save Result:" + data.result;
			
			if(data.status && data.status == "error"){
				Notification.error({message:"Invalid Access", positionY: 'top', positionX: 'right'});
				location.href = "index.cfm";
				return;
			}
			
			if(data.status_code == "VALID") {
				message += "<br>Preparation READY for validation";
				Notification.success({message: message, positionY: 'top', positionX: 'right'});
			}
			else {
				message += "<br>Preparation not yet ready for validation";	
				Notification.info({message: message, positionY: 'top', positionX: 'right'});
			}
				
			//store the new evaluation ID			
			dataService.set("eval", "evalId", data.evaluation_id);							
			initCtrl("view");	
		});*/
	}	
	



// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	/*function setStrings(lang) {				
		var p1 = stringsService.get(lang, "SHARED");
		var p2 = stringsService.get(lang, "EVM");
		
		return $q.all([p1,p2]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS);
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB);			
			$scope.strings["JS"] = JS;
			$scope.strings["LIB"] = LIB;	
			$scope.js = $scope.strings["JS"];
			$scope.lib = $scope.strings["LIB"];
			$scope.str = $scope.strings["LIB"];
			return $q.resolve();
		});	
	}*/

	$scope.$on('languageChanged', function(event, args) {		
		if(args.lang != $scope.displayLanguage){					
			var p1 = setStrings(args.lang);
			$q.all([p1]).then(function(values){ 
				$scope.displayLanguage = args.lang;	
			});
		}
	});		
	
/*	function changeLanguage() {				
		var displayLanguage;
		
		if($scope.displayLanguage == "EN")
			displayLanguage = "FR";
		else 	
			displayLanguage = "EN";	
			
		settingsService.set("displayLanguage", displayLanguage).then(function(){
			var p1 = setStrings(displayLanguage);						
			$q.all([p1]).then(function(values){ 
				$scope.displayLanguage = displayLanguage;
				$rootScope.$broadcast('languageChanged', {lang:$scope.displayLanguage});				
			})		
		})		
	}*/
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Validation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	/*$scope.toggleViewEdit = $stateParams.viewEdit;
	//$scope.backToGrid = backToGrid;
	$scope.savePrep = savePrep;
	$scope.openDocument = openDocument;
	//$scope.changeLanguage = changeLanguage;
	$scope.noPartsDup = noPartsDup;
	$scope.reload = reload;
	$scope.showError = showError;
	$scope.toggleErrors = toggleErrors;
	$scope.isValid = isValid;
	$scope.requestVal = requestVal;
	$scope.acceptPrep = acceptPrep;
	$scope.rejectPrep = rejectPrep;
	$scope.deletePrep = deletePrep;	*/
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	//if($state.current.data.initDone==false || $scope.viewOrEdit!=$stateParams.viewEdit) 
	initCtrl($stateParams.viewEdit);
	
}]);



