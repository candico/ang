
app.cp.register('nsmGridController', ['$scope', '$http', '$interval', 'uiGridConstants', 'NsmService', 'dataService', 'settingsService', function ($scope, $http, $interval, uiGridConstants, NsmService, dataService, settingsService) {
	
	console.log("nsmGridController loaded!");  
	
	var vm = this; //vm for ViewModel
	
	var settings; 	
	
	vm.rowCount = -1;
	
	vm.toggleGridDetail = "grid";	
		
	vm.gridOptions = {
		enableRowSelection: true, 
		enableRowHeaderSelection: false,
		excludeProperties: '__metadata',
		multiSelect: false,	
		modifierKeysToMultiSelect: false,
		noUnselect: true
	};
	
	vm.gridOptions.columnDefs = [
		{ field: 'staff_member_id', displayName:"Staff Member ID" },
		{ field: 'contract_id', displayName:"Contract ID"},
		{ field: 'last_name', displayName:"Last Name"},
		{ field: 'first_name', displayName: "First Name"}	
	];	
	
	function switchGridDetail() {		
		if(vm.toggleGridDetail == "grid")
			vm.toggleGridDetail = "detail";
		else
			vm.toggleGridDetail = "grid";					
	}
		
	vm.gridOptions.onRegisterApi = function( gridApi ) {
		vm.gridApi = gridApi;			
		gridApi.selection.on.rowSelectionChanged($scope, function(row){
			//var msg = 'row selected ' + row.isSelected;				
			$interval( function() { editNsm(row.entity.staff_member_id); }, 100, 1);
			//window.location.href = 'index.cfm?action=staff.editNSM2&id=' + row.entity.staff_member_id;
		});
	};	
	
	function initCtrl() {				
		settingsService.get("nsmGridController").then(function(resp){				
			var data = resp.data;
			vm.currentFieldOfficeId = data.current_field_office_id;
			vm.currentFieldOfficeCity = data.current_field_office_city;				
			loadGridData(vm.currentFieldOfficeId);	
		});				
	}	

    function loadGridData(fieldOfficeId) {		
        NsmService.readAll(fieldOfficeId).then(function (response) {
            vm.gridOptions.data = response.data;   
			//attempt to set the correct height for the grid 
			var rowCount =  response.data.length;
			vm.rowCount = rowCount;
			var headerHeight = 32;
			var rowHeight = 30;
			var paddingHeight = 0;
			var newHeight = headerHeight + paddingHeight + (rowCount * rowHeight);			
			angular.element(document.getElementsByClassName('grid')[0]).css('height', newHeight + 'px');
        });		
		//to set an interval so the grid can populate before autoselecting the first row (shouldn't there be a widgetReady event?)
		 //$interval( function() {vm.gridApi.selection.selectRow(vm.gridOptions.data[0]);}, 0, 1);
    }
	
	function editNsm(staffMemberId) {
		dataService.set("nsm", "staffMemberId", staffMemberId);		
		vm.nsmEditURL = "index.cfm?action=nsm.tabs&jx=true&staff_member_id=" + staffMemberId;		
		vm.toggleGridDetail = "detail";		
	}
	
	//exported functions
	vm.switchGridDetail = switchGridDetail;
	
	initCtrl();    
	
}]);

