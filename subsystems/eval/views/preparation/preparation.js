app.controller('preparationController', 
function ($scope,$state,$stateParams,masterService,Notification,evalTypes,usersByRole,offices,userData) {
	
	$(function(){ 
		$('[data-toggle="tooltip"]').tooltip(); 
	});

	$scope.state = $state.current;
	$scope.viewOrEdit = $stateParams.viewEdit;
	$scope.activeTabIndex = $scope.$state.current.name;
	$scope.offices = offices;
	$scope.formData = {};
	$scope.dt = {}; // object (container) for dates that will be propagated to the children controllers
	$scope.participants = usersByRole;
	
	$scope.navBarEditButton = $scope.evalPrepPriv.edit;

	if ($stateParams.viewEdit == 'new'){
		$scope.evalType = evalTypes.find(function(element){ return element.TYPE_ID == $stateParams.evalId });
		$scope.formData.evalType = $stateParams.evalId;
		//$scope.formData.contributors = {0:null};
		//$scope.formData.preparators = {0:userData.user_id};
		$scope.formData.contributors = [null];
		$scope.formData.preparators = [userData.user_id];
	} else {
		$scope.formData = $scope.$resolve.evaluation.DETAILS;
		angular.forEach($scope.$resolve.evaluation.DETAILS.dt, function(value, key) {
			$scope.dt[key] = new Date(value);
		});
		$scope.evalType = evalTypes.find(function(element){ return element.TYPE_ID == $scope.$resolve.evaluation.DETAILS.evalType });
	}


	$scope.getUsersByRole = function(){
		masterService.get("eval:eval", "getUsersByRole", {OfficeId: $scope.formData.offices}).then(function(response){$scope.participants = response;});
	}

	$scope.addParticipant = function(participant) {
		/*** object ***/
		//var size = Object.keys(  $scope.formData[participant]  ).length;
		//$scope.formData[participant][size] = null;

		/*** array ***/
		$scope.formData[participant].push(null);
	}

	$scope.removeParticipant = function(participant, index) {
		/*** object ***/
		//var myEl = angular.element( document.querySelector( 'div#div_' + participant + '_' + index ) );
		//myEl.remove();
		//delete $scope.formData[participant][index];

		/*** array ***/
		$scope.formData[participant].splice(index, 1);
		//$scope.formData[participant].pop();
	}

	$scope.saveForm = function(){
		/*var contributors = [];
		angular.forEach($scope.formData.contributors, function(value, key) { 
			contributors.push(value);
		});
		$scope.formData.contributors = contributors;

		var preparators = [];
		angular.forEach($scope.formData.preparators, function(value, key) { 
			preparators.push(value);
		});
		$scope.formData.preparators = preparators;*/

		//angular.merge($scope.formData, $scope.dt);

		$scope.formData.dt = $scope.dt;
		masterService.post('eval:prep', 'savePrep', $stateParams, $scope.formData)
		.then(
			function onSuccess(response) {
					Notification.success({message: 'Saved', positionY: 'top', positionX: 'right'});
					//$state.go('evaluations.details.preparation', {'evalId': response[0].ID, 'viewEdit': 'view'});
					$state.go('evaluations.list');
					
			},
			function onError(response) {
				Notification.error({message:response, positionY: 'top', positionX: 'right'});
			}
		);
	}

});

app.controller('dateRangePickerCtrl', function($scope) {
	$scope.dateOptions = {
		format: 'dd/MM/yyyy',
		ngModelOptions : {timezone: 'utc'},
		formatYear: 'yyyy',
		startingDay: 1,
		openCloseStatus: {},
		showWeeks: false
	};

	$scope.dateToOptions = $scope.dateOptions; // because we will add different min date dynamically after picking date from

	$scope.$watch('dt[dpFromName]', function(newValue, oldValue) {
	  if (newValue !== oldValue) {
		if ($scope.dt[$scope.dpToName] !== undefined && newValue > $scope.dt[$scope.dpToName]){
		  delete $scope.dt[$scope.dpToName];
		}
		$scope.dateToOptions.minDate = $scope.dt[$scope.dpFromName];
	  }
	});

	$scope.openClose = function(fieldName) {
		$scope.dateOptions.openCloseStatus[fieldName] = !$scope.dateOptions.openCloseStatus[fieldName];
	};
});