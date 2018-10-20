app.controller('followupController', 
function ($scope,masterService,followUps,userData,ngDialog,Notification,followUpTypes) {
		
	$scope.activeTabIndex = $scope.$state.current.name;
	$scope.formData = {};
	$scope.followUps = followUps;
	$scope.followUpTypes = followUpTypes;
	$scope.navBarEditButton = Object.keys(followUps).some(function(item) { return item == userData.user_id; }) || false;
	
	//$scope.role;

	$scope.getFollowUps = function() {
		masterService.get("eval:followup", "getFollowUps", {eval_id: $scope.$stateParams.evalId}).then(function(response){
			$scope.followUps = response;
        });
	}

	$scope.insertFollowUp = function(who, row){
		masterService.post("eval:followup", "insertFollowUp", $scope.$stateParams).then(function(response){
            $scope.followUps[who][row].ID = response[0].ID;
			$scope.openDialog(who, row);
		});
	}

	$scope.openDialog = function(who, row){
		$scope.dataToPassToDialog = angular.copy($scope.followUps[who][row]);
		var dialog = ngDialog.open({
			template: 'followUpDialogTemplate',
			className: 'ngdialog-theme-default custom-width-90percent',
			scope: $scope
		});
	
		if($scope.$stateParams.viewEdit=='edit'){
			dialog.closePromise.then(function(dialogOptionArg){
				if ( [1,2].indexOf(dialogOptionArg.value) >= 0 ){
					if (dialogOptionArg.value==1) {var methodname = 'updateFollowUp'; var msg = 'Saved';}
					if (dialogOptionArg.value==2) {var methodname = 'deleteFollowUp'; var msg = 'Deleted';}
					masterService.post("eval:followup", methodname, $scope.$stateParams, $scope.dataToPassToDialog)
					.then(
						function(response){
							if (dialogOptionArg.value==2) {
								$scope.dataToPassToDialog.ID = 0;
								$scope.dataToPassToDialog.DESCRIPTION = '';
								$scope.dataToPassToDialog.RESOLUTION = '';
							}
							$scope.followUps[who][row] = angular.copy($scope.dataToPassToDialog);
							Notification.success({message: msg, positionY: 'top', positionX: 'right'});
						},
						function(response){Notification.error({message: response, positionY: 'top', positionX: 'right'});}
					);
				}
			});
		}
	}	

});

