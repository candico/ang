app.cp.register('evalListController', ['$scope', '$http', '$interval', 'uiGridConstants', 'evalService', 'settingsService', function ($scope, $http, $interval, uiGridConstants, evalService, settingsService) {
	
	console.log("evalListController loaded!");  
	
	var vm = this; //vm for ViewModel
	
	var settings;
	
	evalListCtrl = {}; //bad: defined on global scope
	evalListCtrl.eval = {}; //container for all evaluation details. 	
	
	vm.toggleListDetail = "list";	
		
	vm.gridOptions = {
		enableRowSelection: true, 
		enableRowHeaderSelection: false,
		excludeProperties: '__metadata',
		multiSelect: false,	
		modifierKeysToMultiSelect: false,
		noUnselect: true
	};
	
	vm.gridOptions.columnDefs = [
		{ field: 'eval_id', displayName:"Evaluation ID" },
		{ field: 'staff_member_id', displayName:"Evaluee ID" },
		{ field: 'evaluee_name', displayName:"Evaluee Name"},
		{ field: 'user_role', displayName:"My Role"},		
		{ field: 'curr_phase', displayName:"Current Phase"},
		{ field: 'phase_start', displayName:"Phase Start"},
		{ field: 'phase_end', displayName:"Phase End"},
	];	
	
	function switchListDetail() {
		console.log("switching in evalListController");
		if(vm.toggleListDetail == "list")
			vm.toggleListDetail = "detail";
		else
			vm.toggleListDetail = "list";					
	}
		
	vm.gridOptions.onRegisterApi = function( gridApi ) {
		vm.gridApi = gridApi;			
		gridApi.selection.on.rowSelectionChanged($scope, function(row){
			//var msg = 'row selected ' + row.isSelected;				
			$interval( function() { editEval(row.entity.eval_id); }, 100, 1);
			//window.location.href = 'index.cfm?action=staff.editEval2&id=' + row.entity.staff_member_id;
		});
	};	
	
	function initCtrl() {				
		settingsService.get("evalListController").then(function(resp){
			settings = resp.data;				
			vm.currentFieldOfficeId = settings.current_field_office_id;
			vm.currentFieldOfficeCity = settings.current_field_office_city;	
			
			loadGridData(vm.currentFieldOfficeId);	
		});				
	}	

    function loadGridData(fieldOfficeId) {		
        evalService.readAll(fieldOfficeId).then(function(resp) {			
			var data = resp.data;
            vm.gridOptions.data = data;   
			
			//attempt to set the correct height for the grid 			
			var rowCount = data.length;
			var headerHeight = 32;
			var rowHeight = 30;
			var paddingHeight = 0;
			var newHeight = headerHeight + paddingHeight + (rowCount * rowHeight);			
			angular.element(document.getElementsByClassName('grid')[0]).css('height', newHeight + 'px');
        });		
		//to set an interval so the grid can populate before autoselecting the first row (shouldn't there be a widgetReady event?)
		 //$interval( function() {vm.gridApi.selection.selectRow(vm.gridOptions.data[0]);}, 0, 1);
    }
	
	function editEval(eval_id) {
		evalListCtrl.eval.eval_id = eval_id;
		vm.evalEditURL = "index.cfm?action=eval.tabs&jx&eval_id=" + eval_id;		
		vm.toggleListDetail = "detail";		
	}
	
	//exported functions
	vm.switchListDetail = switchListDetail;
	
	initCtrl();    
	
}]);