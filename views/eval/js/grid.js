app.cp.register('evalGridController', ['$rootScope', '$scope', '$http', '$q', '$interval', 'uiGridConstants', 'evalService', 'settingsService', 'dataService', 'stringsService', function ($rootScope, $scope, $http, $q, $interval, uiGridConstants, evalService, settingsService, dataService, stringsService) {
	
	console.log("evalGridController loaded!");  
	
	var vm = this; //vm for ViewModel	
	vm.strings = {}; 		
	
	var settings;	
	
	vm.rowCount = -1;
	
	function setGrid() {	
		
		vm.gridOptions = {
			enableRowSelection: true, 
			enableRowHeaderSelection: false,
			excludeProperties: '__metadata',
			multiSelect: false,	
			modifierKeysToMultiSelect: false,
			noUnselect: true
		};
		
		vm.gridOptions.columnDefs = [
			{ field: 'eval_id', displayName:vm.js.EVAL_ID, width:"10%" },
			{ field: 'staff_member_id', displayName:vm.js.EVALUEE_ID, width:"10%" },
			{ field: 'evaluee_name', displayName:vm.js.EVALUEE_NAME, width:"20%"},
			{ field: 'user_role', displayName:vm.js.MY_ROLE, width:"20%"},		
			{ field: 'curr_phase', displayName:vm.js.CURRENT_PHASE$}		
		];	
		
		vm.gridOptions.onRegisterApi = function( gridApi ) {
			vm.gridApi = gridApi;			
			gridApi.selection.on.rowSelectionChanged($scope, function(row){
				//var msg = 'row selected ' + row.isSelected;				
				$interval( function() { viewEval(row.entity.eval_id); }, 100, 1);
				//window.location.href = 'index.cfm?action=staff.editEval2&id=' + row.entity.staff_member_id;
			});
		};
	}
	
	function initCtrl(mode) {				
		settingsService.get("evalGridController").then(function(resp){
			settings = resp.data;			
			vm.displayLanguage = settings.displayLanguage;
			officeId = settings.current_field_office_id;
			vm.currentFieldOfficeId = officeId;
			vm.currentFieldOfficeCity = settings.current_field_office_city;	
			var p1 = setStrings(vm.displayLanguage);					
			
			$q.all([p1]).then(function(values){ 
				loadGridData(officeId);	
				setGrid();
				( mode ? setMode(mode) : setMode("grid") ); //get default from settings
			})
		});				
	}	
	
	function setStrings(langCode) {		
		var p1 = stringsService.get(langCode, "SHARED");
		var p2 = stringsService.get(langCode, "EVM");
		
		return $q.all([p1,p2]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS);
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB);			
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;	
			vm.js = vm.strings["JS"];
			vm.lib = vm.strings["LIB"];
			return $q.resolve("Strings loaded");
		});	
	}	
	
	/*$scope.$on('setTabAndMode', function(event, args) {
		console.log("setTabAndMode change event in grid.js", args);
		if(args.tab == "evalGrid") {
			if(args.mode != vm.gridOrDetail) 
				initCtrl(args.mode);
		}
	});*/
	
	function setMode(mode) {
		console.log("setMode in evalGridController:", mode);
		vm.gridOrDetail = mode;					
	}	

    function loadGridData(fieldOfficeId) {		
        evalService.readAll(fieldOfficeId).then(function(resp) {			
			var data = resp.data;
            vm.gridOptions.data = data;   
			
			//attempt to set the correct height for the grid 			
			var rowCount = data.length;
			vm.rowCount = data.length;
			var headerHeight = 32;
			var rowHeight = 30;
			var paddingHeight = 0;
			var newHeight = headerHeight + paddingHeight + (rowCount * rowHeight);			
			angular.element(document.getElementsByClassName('grid')[0]).css('height', newHeight + 'px');
        });		
		//to set an interval so the grid can populate before autoselecting the first row (shouldn't there be a widgetReady event?)
		 //$interval( function() {vm.gridApi.selection.selectRow(vm.gridOptions.data[0]);}, 0, 1);
    }
	
	function viewEval(evalId) {		
		dataService.set("eval", "evalId", evalId);	
		dataService.set("eval", "evalTab", "prep");
		dataService.set("eval", "tabMode", "view");		
		vm.evalURL = "index.cfm?action=eval.tabs&jx&eval_id=" + evalId;		
		setMode("detail");	
	}	
	
	function editEval(evalId) {		
		dataService.set("eval", "evalId", evalId);	
		dataService.set("eval", "evalTab", "prep");
		dataService.set("eval", "tabMode", "edit");
		vm.evalURL = "index.cfm?action=eval.tabs&jx&eval_id=" + evalId;		
		setMode("detail");	
	}
	
	function changeLanguage() {		
		if(vm.displayLanguage == "EN")
			vm.displayLanguage = "FR";
		else 	
			vm.displayLanguage = "EN";	
			
		settingsService.set("displayLanguage", vm.displayLanguage).then(function(){
			var p1 = setStrings(vm.displayLanguage);						
			$q.all([p1]).then(function(values){ 
				$rootScope.$broadcast('languageChanged', {lang:vm.displayLanguage});
				console.log("New language selected: ", vm.displayLanguage);
				initCtrl();
			})		
		})		
	}	
	
	function newEval() {		
		editEval(0);
	}		
	
	//exported functions
	vm.setMode = setMode;
	vm.newEval = newEval;
	vm.changeLanguage = changeLanguage;
	
	initCtrl();    
	
}]);