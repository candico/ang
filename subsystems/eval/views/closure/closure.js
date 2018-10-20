


app.controller('datePickerCtrl', function($scope) {
	$scope.dateOptions = {
	  formatYear: 'yyyy',
	  format: 'dd/MM/yyyy',
	  //maxDate: new Date(2020, 5, 22),
	  //minDate: new Date(),
	  //ngModelOptions : {timezone: 'utc'},
	  startingDay: 1,
	  showWeeks: false,
	  openCloseStatus: false
	};
	
	$scope.openCloseDP = function() {
		$scope.dateOptions.openCloseStatus = !$scope.dateOptions.openCloseStatus;
	};
});

app.controller('closureController', ['$scope','$state','$stateParams','ngDialog','masterService','Notification','userData',
function ($scope,$state,$stateParams,ngDialog,masterService,Notification,userData) {

	$scope.allowInsert = -1;
	$scope.state = $state.current;
    $scope.viewOrEdit = $stateParams.viewEdit;
	$scope.activeTabIndex = $scope.$state.current.name;
	$scope.userData = userData;
	$scope.formData = {};

	$scope.navBarEditButton = $scope.evalClosurePriv.edit;

    $scope.getClosureComments = function() {
		masterService.get("eval:closure", "getClosureComments", {eval_id: $stateParams.evalId}).then(function(response){
			$scope.closureComments = $scope.transformDates(response);
        });
	}
	
	$scope.getClosureComments();
	
	$scope.transformDates = function(obj) {
		angular.forEach(obj, function(value, key) {
			obj[key].SUBMIT_DATE = new Date(value.SUBMIT_DATE);
		});
		return obj;
	}

	$scope.$watch('closureComments', function(newValue, oldValue) {
		if (newValue !== oldValue) {
			$scope.allowInsert = $scope.closureComments.findIndex(function(element){ return element.CREATED_BY === userData.user_id});
			$scope.formData = $scope.closureComments[$scope.allowInsert];
		}
	}, true);
  
	$scope.saveForm = function(){
		if (angular.isDefined($scope.formData)){
			masterService.post("eval:closure", "updateClosure", {}, $scope.formData).then(
				function onSuccess(response) {
					$scope.evalFollowUpPriv.visible = (response.FOLLOWUPS > 0) ? true : false;
					$scope.closureComments = $scope.transformDates(response.DETAILS);
					Notification.success({message: 'Saved', positionY: 'top', positionX: 'right'});
				},
				function onError(response) {
					Notification.error({message:response, positionY: 'top', positionX: 'right'});
				}
			);
		} 
		$state.go($state.current.name, {viewEdit: 'view'});
	}

	$scope.insertClosure = function(index){
		masterService.post("eval:closure", "insertClosure", $stateParams).then(function(response){
            $scope.closureComments.push( response[0] );
			$scope.openDialog($scope.closureComments.length-1);
		});
	}

	$scope.openDialog = function(index){
		$scope.dataToPassToDialog = angular.copy($scope.closureComments[index]);
		var dialog = ngDialog.open({
			template: 'closureDialogTemplate',
			className: 'ngdialog-theme-default custom-width-90percent',
			scope: $scope
		});
	
		if($scope.viewOrEdit=='edit'){
			dialog.closePromise.then(function(dialogOptionArg){
				if ( [1,2].indexOf(dialogOptionArg.value) >= 0 ){
					if (dialogOptionArg.value==1) {var methodname = 'updateClosure'; var msg = 'Saved';}
					if (dialogOptionArg.value==2) {var methodname = 'deleteClosure'; var msg = 'Deleted';}
					masterService.post("eval:closure", methodname, {}, $scope.dataToPassToDialog)
					.then(
						function(response){
							$scope.evalFollowUpPriv.visible = (response.FOLLOWUPS > 0) ? true : false;
							$scope.closureComments = $scope.transformDates(response.DETAILS);
							Notification.success({message: msg, positionY: 'top', positionX: 'right'});
						},
						function(response){Notification.error({message: response, positionY: 'top', positionX: 'right'});}
					);
				}
			});
		}
	}

}]);