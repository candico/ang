app.controller('logAsGridController',['$scope', '$interval', 'uiGridConstants', 'securityService', 'Notification', 'settingsService', '$localStorage', '$sessionStorage',
function ($scope, $interval, uiGridConstants, securityService, Notification, settingsService, $localStorage, $sessionStorage) {
	
	console.log("logAsGridController loaded!");  
	
	var vm = this; //vm for ViewModel
	
	var settings; 	
		
	vm.gridOptions = {
		enableFiltering: true,
		enableRowSelection: true, 
		enableRowHeaderSelection: false,
		excludeProperties: '__metadata',
		multiSelect: false,	
		modifierKeysToMultiSelect: false,
		noUnselect: true,
		paginationPageSizes: [10, 20],
		paginationPageSize: 10,
		enableHorizontalScrollbar : uiGridConstants.scrollbars.WHEN_NEEDED,
		enableVerticalScrollbar: uiGridConstants.scrollbars.WHEN_NEEDED,
		useExternalPagination: false    
	};
	
	vm.gridOptions.columnDefs = [
		{ field: 'user_id', displayName:"User ID" },
		{ field: 'username', displayName:"Username"},
		{ field: 'lname', displayName:"Last Name"},
		{ field: 'fname', displayName: "First Name"},
		{ field: 'role_id', displayName: "Role ID"},
		{ field: 'role_code', displayName: "Role Code"},
		{ field: 'office_id', displayName: "Office ID"},
		{ field: 'office', displayName: "Office"}		
	];	
		
	vm.gridOptions.onRegisterApi = function( gridApi ) {
		vm.gridApi = gridApi;			
		gridApi.selection.on.rowSelectionChanged($scope, function(row){
			//var msg = 'row selected ' + row.isSelected;				
			$interval( function() { logAs(row.entity.username, row.entity.office_id); }, 100, 1);
			//window.location.href = 'index.cfm?action=staff.editNSM2&id=' + row.entity.staff_member_id;
		});
	};	
	
	function initCtrl() {				
		loadGridData();			
	}	

    function loadGridData() {		
        securityService.getRolesByUser().then(function (response) {
            vm.gridOptions.data = response.data;   
			//attempt to set the correct height for the grid 
			var rowCount =  response.data.length;
			vm.rowCount = rowCount;
			var headerHeight = 32;
			var rowHeight = 30;
			var paddingHeight = 0;
			//var newHeight = headerHeight + paddingHeight + (rowCount * rowHeight);			
			//angular.element(document.getElementsByClassName('grid')[0]).css('height', newHeight + 'px');
        });		
		//to set an interval so the grid can populate before autoselecting the first row (shouldn't there be a widgetReady event?)
		 //$interval( function() {vm.gridApi.selection.selectRow(vm.gridOptions.data[0]);}, 0, 1);
    }
	
	function logAs(username) {

		securityService.validateLogin(username)
		.then(
			function(resp) {			
				var result = resp.data;
				if(result.status >= 1) { window.location = "index.cfm"; }
				else { Notification.info({message: "Validation Result: <br>" + result.error, positionY: 'top', positionX: 'right'}); }
			}
		);
	}
		
	initCtrl();    
	
}]);
