app.controller('MainCtrl', ['$scope', '$http', '$interval', 'uiGridConstants', 'ProductsService', function ($scope, $http, $interval, uiGridConstants, ProductsService) {
	
  $scope.gridOptions = { enableRowSelection: true, enableRowHeaderSelection: false };	
		
    $scope.gridOptions = {
        excludeProperties: '__metadata'		
    };
	
	$scope.gridOptions.columnDefs = [
		{ name: 'staff_member_id' },
		{ name: 'contract_id'},
		{ name: 'last_name'},
		{ name: 'last_name'},
		{ name: 'first_name'}	
	];
	
	$scope.viewable = "viewable";
	
	  $scope.gridOptions.multiSelect = false;
  $scope.gridOptions.modifierKeysToMultiSelect = false;
  $scope.gridOptions.noUnselect = true;
	
	  $scope.gridOptions.onRegisterApi = function( gridApi ) {
		$scope.gridApi = gridApi;			
		   gridApi.selection.on.rowSelectionChanged($scope, function(row){
			var msg = 'row selected ' + row.isSelected;			
			window.location.href = 'index.cfm?action=staff.editNSM2&id=' + row.entity.staff_member_id;
		  });
	  };	

    $scope.load = function () {		
        ProductsService.readAll().then(function (response) {
            $scope.gridOptions.data = response.data;  
			vm.rowCount = response.data.length;        
        });
		
		//to set an interval so the grid can populate before autoselecting the first row (shouldn't there be a widgetReady event?)
		 //$interval( function() {$scope.gridApi.selection.selectRow($scope.gridOptions.data[0]);}, 0, 1);
    }
	
  $scope.toggleRowSelection = function() {
    $scope.gridApi.selection.clearSelectedRows();
    $scope.gridOptions.enableRowSelection = !$scope.gridOptions.enableRowSelection;
    $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.OPTIONS);
  };	

    $scope.load();
	
}]);

(function () {
    angular.module('ui.grid')
      .service('ProductsService', ['$http', ProductsService]);

    function ProductsService($http) {
        var self = this;
        var baseUrl = 'http://127.0.0.1:8500/NSM/index.cfm?action=staff';
        var extraHeaders = {
            'X-Requested-With':'XMLHttpRequest'
        };
        var item = 'getNSMListData';
        self.readAll = function () {
            return $http({
                method: 'GET',
                url: baseUrl + "." + item,
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.readOne = function (id) {
            return $http({
                method: 'GET',
                url: baseUrl + objectName + '/' + id,
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.create = function (data) {
            return $http({
                method: 'POST',
                url: baseUrl + objectName,
                data: data,
                params: {
                    returnObject: true
                },
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.update = function (id, data) {
            return $http({
                method: 'PUT',
                url: baseUrl + objectName + '/' + id,
                data: data,
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.delete = function (id) {
            return $http({
                method: 'DELETE',
                url: baseUrl + objectName + '/' + id,
                headers: extraHeaders
            });
        };
    }
}());