app.cp.register('setPreparationController', [ '$rootScope', '$scope', '$templateCache', '$http', '$q',  '$timeout', 'uiGridConstants', 'evaluationService', 'settingsService', 'stringsService', 'dataService', 'Notification', function ($rootScope, $scope, $templateCache, $http, $q, $timeout, uiGridConstants, evaluationService, settingsService, stringsService, dataService, Notification) {
	
	console.log("setPreparationController loaded!");  
	
	var vm = this; //vm for ViewModel	
	vm.strings = {};	
	
	vm.data = {}; //main container of data displayed in the template; use underscore_case for variables
	vm.selectedType;
	
	var settings;
	var moduleData;	 	
	var evalId;
		
	var possibleParticipants;	
	var participants;	
	var phases
	var evalData;	
	var documents;
	var participants;
	var evalTypes;
	var comments;
	var showErrors = false;			
	
	//vm.altFields = [{name:"name1",value:"value1"},{name:"name2",value:"value2"}];
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function initCtrl(tabMode) {	
		
		settingsService.get("preparationController").then(function(resp){			
			settings = resp.data;			
			vm.displayLanguage = settings.displayLanguage;
			officeId = settings.current_field_office_id;					
						
			moduleData.tabMode = dataService.getModule("eval");
			evalId = moduleData.evalId;
			vm.data.evaluation_id = evalId;
			
			resetTemplates();	
			 			
			var p1 = setStrings(vm.displayLanguage);			
			var p2 = evaluationService.getUsersByEval(evalId);					
			var p3 = evaluationService.getUsersByRole(evalId);	
			var p4 = evaluationService.getPhasesByEval(evalId);	
			var p5 = evaluationService.getEvalData(evalId);	
			var p6 = evaluationService.getDocumentsByEval(evalId);	
			var p7 = evaluationService.getEvalTypes();	
			var p8 = evaluationService.getPrepComments(evalId);	
			
			$q.all([p1,p2,p3,p4,p5,p6,p7,p8]).then(function(values){ 		
					
				participants = values[1].data;				
				possibleParticipants = values[2].data;
				phases = values[3].data;				
				evalData = values[4].data;
				documents = values[5].data;	
				evalTypes = values[6].data;				
				comments = values[7].data;						
				
				setParticipants(participants);
				setPossibleParticipants(possibleParticipants);	
				setPhases(phases);
				setEvalData(evalData);
				setDocuments(documents);	
				setComments(comments);
				setEvalTypes(evalTypes, evalData.type_id);
				
				//setSelectedOptions();
				if(tabMode)
					toggleViewEdit(tabMode);	
				else					
					toggleViewEdit(moduleData.tabMode);
			})
		});		
	}
	
	function resetTemplates(){
		vm.viewEvalURL = "index.cfm?action=eval.viewPreparation&jx&eval_id=" + evalId;	
		vm.editEvalURL = "index.cfm?action=eval.editPreparation&jx&eval_id=" + evalId;
		$templateCache.remove('index.cfm?action=eval.viewPreparation&jx&eval_id=' + evalId);
		$templateCache.remove('index.cfm?action=eval.editPreparation&jx&eval_id=' + evalId);				
	}
	
	function setEvalData(evalData){	
		if( $.isEmptyObject(evalData) )
			return;	
		
		vm.data.eval_id = evalData.eval_id;		
		vm.data.eval_start_on = evalData.start_on;
		vm.data.eval_end_on = evalData.end_on;
		vm.data.eval_type_id = evalData.type_id;
		vm.data.status_code = evalData.status_code;
		vm.data.status = vm.strings["JS"][evalData.status_code];
	}	
	
	$scope.$watch(angular.bind(this, function () {
	  return this.displayLanguage;
	}), function (newVal) {
	  //console.log('Name changed to ' + newVal);
	  vm.data.status = vm.strings["JS"][vm.data.status_code];
	});
	
	function setEvalTypes(evalTypes, evalTypeId){
		if(!evalTypeId)
			return;
		
		//console.log(evalTypes, "evalTypeId", evalTypeId);
		vm.data.evalTypes = evalTypes;
		vm.evalType = evalTypes.find( function(elem) {return getById(elem, evalTypeId)} );	
		evalType = vm.evalType;
		//console.log("vm.evalType", vm.evalType);
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
				vm.editPreparationForm[fieldName].$setValidity("multi", true);
			else  {	
				vm.editPreparationForm[fieldName].$setValidity("multi", false);	
				if(elemName == fieldName || elemName == "")
					retVal = false;	
									
			}								
		}	
			
		if(retVal === true)
			Notification.info({message: 'Participants are OK', positionY: 'top', positionX: 'right'});	
		else
			Notification.warning({message: 'Participants are NOT OK', positionY: 'top', positionX: 'right'});	
			
		//console.log("participants", participants);
		//console.log("dups", dups);		
		
		return retVal;
	};	
	
	function showError(errObj){		
		return showErrors;
		//return vm.editPreparationForm.$dirty;
	}
	
	function toggleErrors(){
		if(showErrors === true)
			showErrors = false;
		else
			showErrors = true;
	}
	
	function isValid(fieldName){
		//console.log("isValid x", fieldName, vm.editPreparationForm, vm.editPreparationForm[fieldName].$valid);
		//if(vm.editPreparationForm[fieldName].$valid === false) console.log("error", fieldName, vm.editPreparationForm[fieldName].$error);
		return vm.editPreparationForm[fieldName].$valid;
	}
	
	function futureValidityCheck(){
		return true;	
	}
	
	function setStrings(lang) {		
		console.log("setStrings in setPreparation.js");
		var p1 = stringsService.get(lang, "SHARED");
		var p2 = stringsService.get(lang, "EVM");
		
		return $q.all([p1,p2]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS);
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB);			
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;	
			vm.js = vm.strings["JS"];
			vm.lib = vm.strings["LIB"];
			console.log("vm.lib in setPreparation.js", vm.lib);
			return $q.resolve();
		});	
	}	
	
	function setParticipants(participants){	
		if( $.isEmptyObject(participants) )
			return;	
		if(participants.evaluees)		
			vm.evaluee = participants.evaluees[0];
		if(participants.supervisors)		
			vm.supervisor = participants.supervisors[0];
		if(participants.contributors){					
			vm.contributor_1 = participants.contributors.find( function(elem) {return getByPos(elem, 1)} );
			vm.contributor_2 = participants.contributors.find( function(elem) {return getByPos(elem, 2)} );
			vm.contributor_3 = participants.contributors.find( function(elem) {return getByPos(elem, 3)} );
		}
		if(participants.preparators)
			vm.preparator = participants.preparators[0];
		if(participants.authorizers)	
			vm.authorizer = participants.authorizers[0];	 
	}
	
	function getByPos(elem, pos) {		
	  return elem.pos == pos;
	}
	
	function getById(elem, id) {
		return elem.id == id;	
	}
	
	function setPossibleParticipants(possibleParticipants){	
	
		vm.data.evaluees = [];
		vm.data.contributors = [];
		vm.data.supervisors = [];
		vm.data.preparators = [];
		vm.data.authorizers = [];		
		
		if( $.isEmptyObject(possibleParticipants) )
			return;
				
		if(possibleParticipants.evaluees)			
			vm.data.evaluees = possibleParticipants.evaluees; 
		if(possibleParticipants.contributors)			
			vm.data.contributors = possibleParticipants.contributors; 	
		if(possibleParticipants.supervisors)			
			vm.data.supervisors = possibleParticipants.supervisors; 	
		if(possibleParticipants.preparators)
			vm.data.preparators = possibleParticipants.preparators; 
		if(possibleParticipants.authorizers)		
			vm.data.authorizers = possibleParticipants.authorizers; 
	}	
	
	function setDocuments(documents){		
		if( $.isEmptyObject(documents) )
			return;	
			
		vm.documents = documents;
	}	
	
	function setComments(comments){		
		if( $.isEmptyObject(comments) )
			return;	
			
		vm.data.comments = comments;
	}	
	
	function setPhases(phases){		
	
		vm.data.eval_start_on = "";
		vm.data.eval_end_on = "";	
		vm.data.prep_phase_start_on = "";
		vm.data.prep_phase_end_on = "";
		vm.data.assess_phase_start_on = "";
		vm.data.assess_phase_end_on = "";
		vm.data.rating_phase_start_on = "";
		vm.data.rating_phase_end_on = "";
		vm.data.closing_phase_start_on = "";
		vm.data.closing_phase_end_on = "";	
		
		if( $.isEmptyObject(phases) )
			return;	
			
		if(phases.PREP_PHASE){
			vm.data.prep_phase_start_on = phases.PREP_PHASE.start_on;
			vm.data.prep_phase_end_on = phases.PREP_PHASE.end_on;
		}
		if(phases.ASSESS_PHASE) {
			vm.data.assess_phase_start_on = phases.ASSESS_PHASE.start_on;
			vm.data.assess_phase_end_on = phases.ASSESS_PHASE.end_on;
		}
		if(phases.RATING_PHASE) {
			vm.data.rating_phase_start_on = phases.RATING_PHASE.start_on;
			vm.data.rating_phase_end_on = phases.RATING_PHASE.end_on;
		}
		if(phases.CLOSING_PHASE) {
			vm.data.closing_phase_start_on = phases.CLOSING_PHASE.start_on;
			vm.data.closing_phase_end_on = phases.CLOSING_PHASE.end_on;					
		}
		if(phases.PROBATION_PHASE) {
			vm.data.probation_phase_start_on = phases.PROBATION_PHASE.start_on;
			vm.data.probation_phase_end_on = phases.PROBATION_PHASE.end_on;					
		}		
	}
	
	function setSelectedOptions() {		
		Object.keys(getUsersByRole).forEach(function(key) {		
			//console.log("key", key);
			vm[key] = {};			
			vm.data[key].forEach(function(user){ 
				//console.log("user", user);
				var vmUser = vm[key][user.user_id] = {};
				//console.log("vmUser", vmUser);
				//assignCountryKeys(relative, vmRelative)
			});
		});
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-				
	
	function toggleViewEdit(mode){		
		vm.viewOrEdit = mode;
	}
	
	/*function backToGrid(){
		console.log("backToGrid!");
		$rootScope.$broadcast("setTabAndMode", {tab:"evalGrid", mode:"grid"});		
	}*/
	
	function reload(){			
		// reset all errors
		//console.log( "$('.ng-invalid'", $('.ng-invalid') );
		var form = vm.editPreparationForm;
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
		vm.editPreparationForm.$setUntouched(); //set form to untouched 
		vm.editPreparationForm.$setPristine(); //remove all validation error 
		//clear the upload field (in case of manual reload)	
		var fileElement = angular.element('#xfile');
		fileElement.val(null);
		//initCtrl();
	}	
	
	function saveEditPreparation(){	
		evaluationService.savePreparation(evalId).then(function(resp){
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
		});				
	}		
	
	function requestAuthorization(){	
		if( !confirm("Are you sure you want to REQUEST the authorization?") )		
			return;
			
		evaluationService.requestAuthorization(evalId).then(function(resp){
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
				
			//backToGrid()
			
		});				
	}	
	
	function authorizePreparation(){	
		if( !confirm("Are you sure you want to AUTHORIZE the preparation?") )		
			return;
			
		evaluationService.authorizePreparation(evalId).then(function(resp){
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
	
	function rejectPreparation(){	
		if( !confirm("Are you sure you want to REJECT the preparation?") )		
			return;
			
		evaluationService.rejectPreparation(evalId).then(function(resp){
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
	
	function deletePreparation(){	
		if( !confirm("Are you sure you want to DELETE the preparation?") )		
			return;
			
		evaluationService.deletePreparation(evalId).then(function(resp){
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
	
	function openDocument(doc_id){				
		var path = "index.cfm?action=common.document&id=" + doc_id;
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}	
	
	$scope.$on('languageChanged', function(event, args) {				
		if(args.lang != vm.displayLanguage){
			vm.displayLanguage = args.lang;			
			setStrings(vm.displayLanguage);
		}
	});		
	
	function changeLanguage() {				
		var displayLanguage;
		
		if(vm.displayLanguage == "EN")
			displayLanguage = "FR";
		else 	
			displayLanguage = "EN";	
			
		settingsService.set("displayLanguage", displayLanguage).then(function(){
			var p1 = setStrings(displayLanguage);						
			$q.all([p1]).then(function(values){ 
				vm.displayLanguage = displayLanguage;
				$rootScope.$broadcast('languageChanged', {lang:vm.displayLanguage});				
			})		
		})		
	}	
	
	function viewStrings() {		
		console.log("vm.lib", vm.lib);
	}
	
	vm.getEvalType = function (selected) {
		if(!selected)
			return;
						
		//console.log(selected); 
		vm.evalType = selected.originalObject;
		console.log(vm.editPreparationForm);
		console.log(vm.editPreparationForm.type_id);
		vm.editPreparationForm.type_id = vm.evalType.id;
		console.log(vm.editPreparationForm.type_id); 
		
		//console.log("type_id value 1", $("#editPreparationForm input[name=type_id]").val() );
		$("#editPreparationForm input[name=type_id]").val(18);
		//console.log("type_id value 2", $("#editPreparationForm input[name=type_id]").val() );
		
		//angular.element("#type_id").val(selected.originalObject.id);
		//return vm.evalType;
	};	
	
	//exported functions
	vm.toggleViewEdit = toggleViewEdit;
	vm.backToGrid = backToGrid;
	vm.saveEditPreparation = saveEditPreparation;
	vm.openDocument = openDocument;
	vm.changeLanguage = changeLanguage;
	vm.noPartsDup = noPartsDup;
	vm.reload = reload;
	vm.showError = showError;
	vm.toggleErrors = toggleErrors;
	vm.isValid = isValid;
	vm.requestAuthorization = requestAuthorization;
	vm.authorizePreparation = authorizePreparation;
	vm.rejectPreparation = rejectPreparation;
	vm.deletePreparation = deletePreparation;
	vm.viewStrings = viewStrings;
	
	// initialize controller
	initCtrl();	
	
}]);



