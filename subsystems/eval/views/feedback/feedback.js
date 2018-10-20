app.controller('feedbackController',
function ($scope,NgTableParams,$state,$stateParams,ngDialog,masterService,Notification,userData) {

	$scope.viewOrEdit = $stateParams.viewEdit;
	$scope.feedbackEditable =  false;
	$scope.activeTabIndex = $scope.$state.current.name;

	$scope.navBarEditButton = $scope.evalFeedbackPriv.edit;

    $scope.getFeedbackQuestions = function(){
		masterService.get("eval:feedback", "getFeedbackQuestions", {Eid: $stateParams.evalId})
		.then(function(response){ 
			$scope.feedbackQuestions = response;
			if (Object.keys(response.contributors).length == 1 && response.contributors[0].ID == userData.user_id) {
				$scope.feedbackEditable = true;
			}
		});
	}
	
    $scope.getFeedbackQuestions();

	$scope.feedbackAnswer = function(index){
		masterService.post("eval:feedback", "insertFeedback", {Qid: $scope.feedbackQuestions.answers[userData.user_id][index].Q_ID, Eid: $stateParams.evalId}).then(function(response){ 
			$scope.dataToPassToDialog = response[0];
			$scope.feedbackQuestions.answers[userData.user_id][index] = response[0];
			$scope.openDialog(index);
		});
	}

	$scope.openDialog = function(index){
		$scope.dataToPassToDialog = angular.copy($scope.feedbackQuestions.answers[userData.user_id][index]);
		var dialog = ngDialog.open({
			template: 'feedbackDialogTemplate',
			className: 'ngdialog-theme-default custom-width-90percent',
			scope: $scope
		});
	
		if($scope.viewOrEdit=='edit'){
			dialog.closePromise.then(function(dialogOptionArg){
				if ( [1,2].indexOf(dialogOptionArg.value) >= 0 ){
					if (dialogOptionArg.value==1) {var methodname = 'updateFeedback'; var msg = 'Saved';}
					if (dialogOptionArg.value==2) {var methodname = 'updateFeedback'; var msg = 'Deleted';  $scope.dataToPassToDialog.ANSWER = null; }
					masterService.post("eval:feedback", methodname, {}, $scope.dataToPassToDialog)
					.then(
						function(response){
							$scope.feedbackQuestions.answers[userData.user_id][index] = angular.copy($scope.dataToPassToDialog);
							Notification.success({message: msg, positionY: 'top', positionX: 'right'});
						},
						function(response){Notification.error({message: response, positionY: 'top', positionX: 'right'});}
					);
				}
			});
		}
	}

});