app.controller('templateSASSCtrl', function(){ 
	$(function(){ 
		$('[data-toggle="tooltip"]').tooltip(); 
	}); 
});

app.controller('sassDatePickerCtrl', function($scope) {
	$scope.dateOptions = {
	  formatYear: 'yyyy',
	  format: 'dd/MM/yyyy',
	  startingDay: 1,
	  showWeeks: false,
	  openCloseStatus: false
	};
	
	$scope.openCloseDP = function() {
		$scope.dateOptions.openCloseStatus = !$scope.dateOptions.openCloseStatus;
	};
});

app.controller('setSassController', function ( $rootScope,
												$scope,
												NgTableParams,
												$state,
												$stateParams,
												ngDialog,
												$templateCache,
												$http,
												$q,
												$timeout,
												sassService,
												evaluationService,
												settingsService,
												stringsService,
												dataService,
												Notification,
												masterService,
												uiGridConstants ) {
	
	console.log("setSassController loaded!");  
	$scope.state = $state.current;
	$scope.viewOrEdit = $stateParams.viewEdit;

	$scope.formData = {};
	$scope.dt = {}; // object (container) for dates that will be propagated to the children controllers

	$scope.formData = $scope.$resolve.evaluation.DETAILS;
	angular.forEach($scope.$resolve.evaluation.DETAILS.dt, function(value, key) {
		$scope.dt[key] = new Date(value);
	});


	$scope.saveForm = function(){
		$scope.formData.dt = $scope.dt;
		masterService.post('eval:prep', 'savePrep', $stateParams, $scope.formData)
		.then(
			function onSuccess(response) {
				Notification.success({message: 'Saved', positionY: 'top', positionX: 'right'});			
				$state.go($state.current.name, {viewEdit: 'view'});
			},
			function onError(response) {
				Notification.error({message:response, positionY: 'top', positionX: 'right'});
			}
		);
	}	

	$scope.activeTabIndex = $scope.$state.current.name;

	if ($scope.$state.current.name == "evaluations.details.evaluation") {
		$scope.navBarEditButton = $scope.evalEassPriv.edit;
	}

	if ($scope.$state.current.name == "evaluations.details.selfassessment") {
		$scope.navBarEditButton = $scope.evalSassPriv.edit;
	}

	$scope.getSass = function(){
		masterService.get("eval:sass", "getSass", {id: $stateParams.evalId}).then(function(response){
			$scope.sass = response;
			//$scope.saaaTableParams = new NgTableParams({count: response.length}, { counts: [],  dataset: response });
		});
	}

	$scope.getNextYearObjectives = function(){
		masterService.get("eval:sass", "getNextYearObjectives", {id: $stateParams.evalId}).then(function(response){
			$scope.nextYearObjectives = response;
			//$scope.nextYearObjectivesTableParams = new NgTableParams({count: response.length}, { counts: [],  dataset: response });
		});
	}

	$scope.getEvalueeDetails = function(){
		masterService.get("eval:eval", "getEvalueeDetails", {id: $stateParams.evalId}).then(function(response){ $scope.evalueeDetails = response; });
	}	

	$scope.getSass();
	$scope.getNextYearObjectives();
	//$scope.getEvalueeDetails();


	$scope.addNewRow = function(periodID){
		var sassData = [];
		if(periodID == 1){
			sassData = 'sass';
		} else {
			sassData = 'nextYearObjectives';
		}
		var template = 'templateSASS';
		// 1. insert empty record into DB
		// 2. select of that record for ID
		// 3. display dialog with fields
		// 4. update DB with entered data
		// 5. add row to ui-grid
		masterService.post("eval:sass", "insertEval", {id: $stateParams.evalId, period: periodID}).then(function(response){
			$scope[sassData].push( response[0] );
			$scope.openDialog(sassData, $scope[sassData].length-1, template);
		});
	}

	$scope.deleteRow = function(){

		angular.forEach($scope.nextYearObjectivesGridApi.selection.getSelectedRows(), function (data, index) {
			$scope.nextYearObjectivesGridOptions.data.splice($scope.nextYearObjectivesGridOptions.data.lastIndexOf(data), 1);
		});
		
		$scope.nextYearObjectivesGridApi.grid.selection.selectedCount = 0;
		/*debugger;
		var nja = $scope.nextYearObjectivesGridApi.selection.getSelectedRows();
		var bla = $scope.nextYearObjectivesGridApi.selection.getSelectedGridRows();
		$scope.nextYearObjectivesGridApi;*/
	}


	$scope.openDialog = function(scopeData, index){
		$scope.dataToPassToDialog = angular.copy($scope[scopeData][index]);
		var dialog = ngDialog.open({
			template: 'templateSASS',
			className: 'ngdialog-theme-default custom-width-90percent',
			scope: $scope
		});
	
		if($scope.viewOrEdit=='edit'){
			dialog.closePromise.then(function(dialogOptionArg){
				if ( [1,2].indexOf(dialogOptionArg.value) >= 0 ){
					if (dialogOptionArg.value==1) {var methodname = 'updateEval'; var msg = 'Saved';}
					if (dialogOptionArg.value==2) {
						var msg = 'Deleted';
						if (scopeData=='sass' && $state.current.name == "evaluations.details.evaluation") {
							var methodname = 'updateEval';
							$scope.dataToPassToDialog.PERFORMANCE_LEVEL = null;
							$scope.dataToPassToDialog.EVALUATOR_ASSESSMENT = null;
						}
						else {
							var methodname = 'deleteEval';
						}
					}
					masterService.post("eval:sass", methodname, {id:$scope.dataToPassToDialog.id}, $scope.dataToPassToDialog)
					.then(
						function(response){
							$scope[scopeData][index] = angular.copy($scope.dataToPassToDialog);
							$scope.getSass();
							$scope.getNextYearObjectives();
							Notification.success({message: msg, positionY: 'top', positionX: 'right'});
						},
						function(response){Notification.error({message: response, positionY: 'top', positionX: 'right'});}
					);
				}
			});
		}
	}


	var showErrors = false;	
	var period_1_id = 1; //2016-2017
	var period_2_id = 2; //2017-2018

	var vm = this; //vm for ViewModel	
	
	$scope.strings = {};	
	$scope.data = {}; //main container for data used in the template



	$scope.objectivesGrid = {
		//enableFullRowSelection: true,
		enableRowSelection: true,
		enableRowHeaderSelection: false,
		enableSelectAll: false,
		enableColumnMenus: false,
		multiSelect: false,
		enableHorizontalScrollbar : uiGridConstants.scrollbars.WHEN_NEEDED,
		enableVerticalScrollbar: uiGridConstants.scrollbars.WHEN_NEEDED,
		//data: 'objectives',
		onRegisterApi: function(gridApi){
			$scope.objectivesGridApi = gridApi;
			gridApi.core.on.rowsRendered($scope, function() {

				var found = $scope.objectives.findIndex(function(element) {
					return element.OBJECTIVE_ID == $scope.dataToPassToDialog.OBJECTIVE_ID;
				});
				gridApi.selection.selectRow($scope.objectivesGrid.data[found]);
				//gridApi.core.scrollTo($scope.objectivesGrid.data[found], $scope.objectivesGrid.columnDefs[1]);
				//gridApi.cellNav.scrollToFocus(gridApi.grid, $scope, $scope.objectivesGrid.data[found], $scope.objectivesGrid.columnDefs[1]);
				//$timeout(function(){ gridApi.core.scrollToIfNecessary(found, 1); }, 1000);
				//gridApi.core.scrollTo($scope.objectivesGrid.data[found], $scope.objectivesGrid.columnDefs[1]);
			});
		},
		columnDefs: [ 
			{ field: 'OBJECTIVE_ID', displayName: 'id', visible: false },
			{ field: 'OBJECTIVE', displayName: 'Objectives' /*, cellTemplate: '<div style="height: auto;">{{COL_FIELD}}</div>'  */ } 
		]
	};

	$scope.nextYearObjectivesGridOptions = {
		enableSorting: false,
		enableRowSelection: true,
      	enableRowHeaderSelection: true,
		  //enableFullRowSelection: true,
		enableColumnResizing: true,
		enableSelectAll: false,
		enableFiltering: false,
		enableColumnMenus: false,
		enableHorizontalScrollbar : uiGridConstants.scrollbars.NEVER,
		enableVerticalScrollbar: uiGridConstants.scrollbars.WHEN_NEEDED,
		//data: 'nextYearObjectivesData',
		onRegisterApi: function(gridApi){
			$scope.nextYearObjectivesGridApi = gridApi;
			gridApi.selection.on.rowSelectionChanged($scope,function(row){
			  var msg = 'row selected ' + row.isSelected;
			});
			gridApi.selection.on.rowSelectionChangedBatch($scope,function(rows){
			  var msg = 'rows changed ' + rows.length;
			});
		},
		columnDefs: [ 
			{ field: 'ID', displayName: 'id', visible: false},
			{ field: 'COMPETENCY', displayName: 'Competency', width:"30%" },
			{ field: 'COMPETENCY_ID', displayName: 'competency_id', visible: false },
			{ field: 'OBJECTIVE', displayName: 'Objective', width:"30%" },
			{ field: 'OBJECTIVE_ID', displayName: 'objective_id', visible: false },
			{ field: 'LEARNING_ACTIVITY', displayName: 'Potential Learning Activity', width:"30%" },
			{ field: 'action', displayName: 'Action', headerCellClass: 'text-center',  width:"8%",  cellClass: 'text-center', 
			cellTemplate: '<button ng-click="grid.appScope.openDialog(\'nextYearObjectivesGridOptions\', rowRenderIndex, \'templateNextYearObjective\')">'+
			'<span ng-if="grid.appScope.viewOrEdit==\'edit\'">edit</span>'+
			'<span ng-if="grid.appScope.viewOrEdit==\'view\'">view</span></button>'
			}
		]
	  };

	




// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
function initCtrl(tabMode) {	
		
		settingsService.get("setSassController").then(function(resp){			
			var settings = resp.data;			
			$scope.displayLanguage = settings.displayLanguage;
			var officeId = settings.current_field_office_id;					
						
			var moduleData = dataService.getModule("eval");
			//var moduleData = $stateParams.viewEdit;					
			//evalId = moduleData.evalId;
			evalId = $stateParams.evalId;
			$scope.data.evaluation_id = evalId;			

			masterService.get("eval:sass", "getObjectives").then(function(response){
				$scope.objectives = response;
				//$scope.objectivesGrid.data = response;
			});
			masterService.get("eval:sass", "getCompetencies").then(function(response){$scope.competencies = response;});
			




			
			//var p1 = setStrings($scope.displayLanguage);
			//var p2 = evaluationService.getUsersByEval(evalId);					
			//var p3 = evaluationService.getEvalData(evalId);	
			//var p4 = evaluationService.getDocumentsByEval(evalId);	
			//var p5 = evaluationService.getEvalueeDetails(evalId);
			
			//$q.all([p2,p3]).then(function(values){ 					
				
				//participants = values[0].data;									
				//evalData = values[1].data;
				//documents = values[3].data;		
				//evaluee = values[4].data;				
				//evaluee_id = evaluee.evaluee_id;						

				//var p1 = sassService.getObjectives(evaluee_id, period_1_id);
				//var p2 = sassService.getObjectives(evaluee_id, period_1_id);	
				
				//setParticipants(participants);					
				//setEvalData(evalData);
				//setDocuments(documents);
				//setEvaluee(evaluee);

				/*$q.all([p1,p2]).then(function(values){ 
								
					currentObjectives = values[0].data;	
					futureObjectives = values[1].data;					
					
					staffType = evaluee.staff_type;	
					setParticipants(participants);					
					setEvalData(evalData);
					setDocuments(documents);
					setEvaluee(evaluee);
					//setCurrentObjectives(currentObjectives);
					//setFutureObjectives(futureObjectives);
				
				});*/
			//})
		});		
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function resetTemplates(evalId, staffType){		
		if(staffType == "NS") {
			$scope.viewEvalURL = "index.cfm?action=eval:sass.viewNS&jx&eval_id=" + evalId;	
			$scope.editEvalURL = "index.cfm?action=eval:sass.editNS&jx&eval_id=" + evalId;
			$templateCache.remove('index.cfm?action=eval:sass.viewNS&jx&eval_id=' + evalId);
			$templateCache.remove('index.cfm?action=eval:sass.editNS&jx&eval_id=' + evalId);				
		}
		if(staffType == "TS") {
			$scope.viewEvalURL = "index.cfm?action=eval:sass.viewTS&jx&eval_id=" + evalId;	
			$scope.editEvalURL = "index.cfm?action=eval:sass.editTS&jx&eval_id=" + evalId;
			$templateCache.remove('index.cfm?action=eval:sass.viewTS&jx&eval_id=' + evalId);
			$templateCache.remove('index.cfm?action=eval:sass.editTS&jx&eval_id=' + evalId);				
		}		
	}
	


	function setEvaluee(evaluee){
		
		$scope.data.full_name = evaluee.full_name;		
		$scope.data.current_contract_end = evaluee.current_contract_end;
		$scope.data.current_role = evaluee.current_role;
		$scope.data.current_role_id = evaluee.current_role_id;
		$scope.data.current_role_start = evaluee.current_role_start;
		$scope.data.first_echo_contract_start = evaluee.first_echo_contract_start;
		$scope.data.staff_type = evaluee.staff_type;
		$scope.data.home_office_id = evaluee.home_office_id;
		$scope.data.home_office = evaluee.home_office;
	}
	
	function setCurrentObjectives(currentObjectives){
		$scope.data.currentObjectives = currentObjectives;
	}
	
	function setFutureObjectives(futureObjectives){
		$scope.data.futureObjectives = futureObjectives;		
		
	}
	
	function setEvalData(evalData){	
		if( $.isEmptyObject(evalData) )
			return;	
		
		$scope.data.eval_id = evalData.eval_id;		
		$scope.data.eval_start_on = evalData.start_on;
		$scope.data.eval_end_on = evalData.end_on;
		$scope.data.eval_type_id = evalData.type_id;
		$scope.data.status_code = evalData.status_code;
		$scope.data.status = $scope.strings["JS"][evalData.status_code];
	}	
	

	/*$scope.$watch(angular.bind(this, function(){return this.displayLanguage;}), function(newVal, oldVal) {
		if (angular.isDefined(newVal) || newVal !== oldVal) {
		  $scope.totalPages = ctrl.calculateTotalPages();
		  ctrl.updatePage();
		}
	  });*/


	/*$scope.$watch(angular.bind(this, function () {
	  return this.displayLanguage;
	}), function (newVal) {
	  $scope.data.status = $scope.strings["JS"][$scope.data.status_code];
	});*/
	



	function setParticipants(participants){	
		if( $.isEmptyObject(participants) )
			return;	
						
		if(participants.evaluees){			
			var evaluee = participants.evaluees[0];
			evalueeId = evaluee.user_id;
			$scope.evaluee = evaluee;
		}
		else{
			//should throw an error if no evaluee
		}
		
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
	
	function setDocuments(documents){		
		if( $.isEmptyObject(documents) )
			return;	
						
		$scope.documents = documents;
	}	
	
	function getByPos(elem, pos) {		
	  return elem.pos == pos;
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions: View and Edit mode
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-				
	
	function toggleViewEdit(mode){		
		$scope.viewOrEdit = mode;
	}
	
	/*function backToGrid(){
		console.log("backToGrid!");
		$rootScope.$broadcast("setTabAndMode", {tab:"evalGrid", mode:"grid"});		
	}*/
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions: Edit mode
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function reload(){			
		// reset all errors
		//console.log( "$('.ng-invalid'", $('.ng-invalid') );
		var form = $scope.editAssessmentForm;
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
	
	function save(){	
		selfAssessmentService.save(evalId).then(function(resp){
			var data = resp.data; 			
			var message = "Save Result:" + data.result;
			
			if(data.status && data.status == "error"){
				Notification.error({message:"Invalid Access", positionY: 'top', positionX: 'right'});
				location.href = "index.cfm";
				return;
			}
			
			if(data.status_code == "VALID") {
				message += "<br>Self-Assessment READY for validation";
				Notification.success({message: message, positionY: 'top', positionX: 'right'});
			}
			else {
				message += "<br>Self-Assessment not yet ready for validation";	
				Notification.info({message: message, positionY: 'top', positionX: 'right'});
			}
				
			//store the new evaluation ID			
			dataService.set("eval", "evalId", data.evaluation_id);							
			initCtrl("view");	
		});				
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions: View mode
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
	
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
				
			backToGrid()
			//initCtrl();				
		});				
	}	
		
	function openDocument(doc_id){				
		var path = "index.cfm?action=common.document&id=" + doc_id;
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function setStrings(lang) {				
		var p1 = stringsService.get(lang, "SHARED");
		var p2 = stringsService.get(lang, "EVM");
		
		return $q.all([p1,p2]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS);
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB);			
			$scope.strings["JS"] = angular.merge(values[0].data.JS, values[1].data.JS);
			$scope.strings["LIB"] = angular.merge(values[0].data.LIB, values[1].data.LIB);
			$scope.js = $scope.strings["JS"];
			$scope.lib = $scope.strings["LIB"];			
			return $q.resolve();
		});	
	}	
	
	/*$scope.$on('languageChanged', function(event, args) {				
		if(args.lang != $scope.displayLanguage){
			$scope.displayLanguage = args.lang;			
			setStrings($scope.displayLanguage);
		}
	});*/		
	
	$scope.changeLanguage = function(){
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
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	//$scope.toggleViewEdit = $stateParams.viewEdit;
	//$scope.backToGrid = backToGrid;
	//$scope.save = save;
	//$scope.openDocument = openDocument;
	//$scope.changeLanguage = changeLanguage;	
	//$scope.reload = reload;	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();	
	
});