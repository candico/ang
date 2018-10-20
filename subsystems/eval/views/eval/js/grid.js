app.controller('evalGridController', ['$scope','NgTableParams','masterService','evalTypes','$state','userSettings',
function ($scope,NgTableParams,masterService,evalTypes,$state,userSettings) {
	
	$scope.newEvaluationButtonAllowed = userSettings.data.role_code.findIndex(function(element){ return element == 'EVM_PREPARATOR' });

	$scope.evalTypes = evalTypes;

	$scope.getEvals = function(){
		masterService.get("eval:eval", "getEvalGridData").then(function(response){
			angular.forEach(response, function(value, key) {
				response[key]['START_ON'] = new Date(value['START_ON']);
				response[key]['END_ON'] = new Date(value['END_ON']);
			});
			$scope.evalTableParams = new NgTableParams({}, {dataset: response });
		});
	}

	$scope.getEvals();

	$scope.viewEval =  function(evalId) {
		var state = ($scope.newEvaluationButtonAllowed>=0) ? 'evaluations.details.preparation' : 'evaluations.details.feedback';
		$state.go(state, {'evalId': evalId, 'viewEdit': 'view'});
	}	
	
	$scope.editEval = function(evalId) {
		$state.go('evaluations.details.preparation', {'evalId': evalId, 'viewEdit': 'edit'});
	}

	$scope.newPreparation = function(evalId, statusId){
		$state.go('evaluations.details.preparation', {'evalId': evalId, 'viewEdit': 'new', 'statusId': statusId});
	}
	
}]);