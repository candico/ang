app.controller('evalTabsController', function ($scope,userData,usersByRole,masterService,Upload,userSettings,documents) {

	$scope.newEvaluationScreenAllowed = userSettings.data.role_code.findIndex(function(element){ return element == 'EVM_PREPARATOR' });
	
	$scope.role = {
		evaluee: false,
		contributor: false,
		supervisor: false,
		preparator: false,
		head: false
	};
	
	// $scope.$state exists just because of inheritance of $rootScope.$state = $state;
	// so there is no need to include $rootscope, $state .... just $scope is enough

	if ($scope.$state.current.name == "evaluations.details.preparation" && $scope.$stateParams.viewEdit == 'new'){
		$scope.role.preparator = true;
	} else {
		$scope.role.evaluee = ($scope.$resolve.evaluation.DETAILS.evaluees == userData.user_id) ? true : false;
		$scope.role.contributor = Object.keys($scope.$resolve.evaluation.DETAILS.contributors).some(function(k) { return $scope.$resolve.evaluation.DETAILS.contributors[k] == userData.user_id; });
		$scope.role.supervisor = ($scope.$resolve.evaluation.DETAILS.supervisors == userData.user_id) ? true : false;
		$scope.role.preparator = Object.keys($scope.$resolve.evaluation.DETAILS.preparators).some(function(k) { return $scope.$resolve.evaluation.DETAILS.preparators[k] == userData.user_id; });
		$scope.role.head = ($scope.$resolve.evaluation.DETAILS.heads == userData.user_id) ? true : false;
	}

	var role = '';

	if ($scope.role.evaluee) role = "EVM_EVALUEE";
	if ($scope.role.contributor) role =  "EVM_CONTRIBUTOR";
	if ($scope.role.supervisor) role =  "EVM_SUPERVISOR";
	if ($scope.role.preparator) role =  "EVM_PREPARATOR";
	if ($scope.role.head) role =  "EVM_HEAD";

	$scope.evalPrepPriv = userSettings.data.privs.evaluations.prepararation[role];
	$scope.evalSassPriv = userSettings.data.privs.evaluations.selfassesment[role];
	$scope.evalFeedbackPriv = userSettings.data.privs.evaluations.feedback[role];
	$scope.evalEassPriv = userSettings.data.privs.evaluations.evaluatorAssesment[role];
	$scope.evalClosurePriv = userSettings.data.privs.evaluations.closure[role];
	$scope.evalFollowUpPriv = {visible: false};
	if ($scope.$resolve.evaluation.FOLLOWUPS > 0) $scope.evalFollowUpPriv.visible = true;
	
	$scope.paticipants = function(arr,id){
		return arr.find(function(element){ return element.user_id == id });
	}

	$scope.summary = {};
	$scope.summary.contributors = [];
	$scope.summary.preparators = [];
	$scope.summary.supervisor = null;
	$scope.summary.evaluee = null;
	$scope.summary.head = null;

	if ( angular.isDefined($scope.$resolve.evaluation.DETAILS) && Object.keys($scope.$resolve.evaluation.DETAILS).length){

		angular.forEach($scope.$resolve.evaluation.DETAILS.dt, function(value, key) {
			$scope.$resolve.evaluation.DETAILS.dt[key] = new Date(value);
		});

		angular.forEach($scope.$resolve.evaluation.DETAILS.contributors, function(value, key) {
			$scope.summary.contributors.push( $scope.paticipants(usersByRole.contributors, value) ); 
		});

		angular.forEach($scope.$resolve.evaluation.DETAILS.preparators, function(value, key) {
			$scope.summary.preparators.push( $scope.paticipants(usersByRole.preparators, value) ); 
		});

		if ( Object.keys($scope.$resolve.evaluation.DETAILS).includes('supervisors')){
			$scope.summary.supervisor = usersByRole.supervisors.find(function(element){ return element.user_id == $scope.$resolve.evaluation.DETAILS.supervisors });
		}

		if ( Object.keys($scope.$resolve.evaluation.DETAILS).includes('evaluees')){
			$scope.summary.evaluee = usersByRole.evaluees.find(function(element){ return element.user_id == $scope.$resolve.evaluation.DETAILS.evaluees });
		}

		if ( Object.keys($scope.$resolve.evaluation.DETAILS).includes('heads')){
			$scope.summary.head = usersByRole.heads.find(function(element){ return element.user_id == $scope.$resolve.evaluation.DETAILS.heads });
		}

	}
	
	$scope.openDocument = function(doc_id){
		return masterService.export("common", "document", angular.merge($scope.$stateParams, {id: doc_id}));
	}

	$scope.deleteDocument = function(doc_id){
		masterService.get("eval:prep", "deleteDocument", angular.merge($scope.$stateParams, {id: doc_id})).then(function(response){ $scope.assignDocPrivileges(response); });
	}	

	$scope.getDocuments = function(){
		masterService.get("eval:eval", "getDocuments", $scope.$stateParams).then(function(response){ $scope.assignDocPrivileges(response); });
	}
		
	$scope.assignDocPrivileges = function(docs){
		$scope.documents = {};
		angular.forEach(docs, function(value, key) {
			if (role=="EVM_PREPARATOR") { 
				value.edit = true;
			} else if (value.USER_ID == userData.user_id){
				value.edit = true;
			} else {
				value.edit = false;
			}
			$scope.documents[key] = value;
		});
	}

	$scope.assignDocPrivileges(documents);

	// upload on file select or drop
	$scope.uploadDocument = function (file) {
			if ( file === null ) return;
			Upload.upload({
					url: 'index.cfm?action=eval:prep.uploadDocument',
					data: angular.merge({file: file}, $scope.$stateParams) 
			}).then(function (resp) {
					console.log('Success ' + resp.config.data.file.name + ' uploaded. Response: ' + resp.statusText);
					$scope.assignDocPrivileges(resp.data);
			}, function (resp) {
					console.log('Error status: ' + resp.status);
			}, function (evt) {
					var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
					console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
			});
	};

	$scope.evalPdf = function(){
		return masterService.export("eval:eval", "evalPDF", angular.merge($scope.$stateParams, {stateName: $scope.$state.$current.name}));
	}

});

/*app.directive('multi', ['$parse', '$rootScope', function ($parse, $rootScope) {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function (scope, elem, attrs, ngModelCtrl) {
      var validate = $parse(attrs.multi)(scope);
	  var pos = $parse(attrs.pos)(scope);
      ngModelCtrl.$viewChangeListeners.push(function () {
        ngModelCtrl.$setValidity('multi', validate(pos));
      });
    }
  };
}]);*/

/*function getFormData() {	
	var myForm = document.getElementById('evalEditForm');	
	return new FormData(myForm);
}*/

/*function makeRequest(opts) {
	//promisifying the xhr object because ngModel.$asyncValidators needs a promise
  return new Promise(function (resolve, reject) {
	var xhr = new XMLHttpRequest();
	xhr.open(opts.method, opts.url);
	
			xhr.onload = function () {	
			var jsonResponse = JSON.parse(this.responseText);
				if (jsonResponse.STATUS_CODE == 1) {
				resolve(xhr.response);
				} else {
				reject({
					status: this.status,
					statusText: xhr.statusText
				});
				}
			};
	
			xhr.onerror = function () {
				reject({
				status: this.status,
				statusText: xhr.statusText
				});
			};
	
		if (opts.headers) {
			Object.keys(opts.headers).forEach(function (key) {
			xhr.setRequestHeader(key, opts.headers[key]);
			});
		} 
	
			var params = opts.params;	
			// We'll need to stringify if we've been given an object
			// If we have a string, this is skipped.
			if (params && typeof params === 'object') {		
				params = Object.keys(params).map(function (key) {
				return encodeURIComponent(key) + '=' + encodeURIComponent(params[key]);
				}).join('&');
			}	
			
	xhr.send(params);		
  });
}*/

/*app.directive('requiredSelect', function () {
	//used for dropdowns, but could be used for other widgets because ctrl.$isEmpty(value) is generic
    return {
      restrict: 'AE',
      require: 'ngModel',
      link: function(scope, elm, attr, ctrl) {	 
        if (!ctrl) return;
          attr.requiredSelect = true; // force truthy in case we are on non input element
		  
          var validator = function(value) {		
            if (attr.requiredSelect && ctrl.$isEmpty(value)) {				
              	ctrl.$setValidity('requiredSelect', false);	
              	return;				
            } else {				
              	ctrl.$setValidity('requiredSelect', true);
              	return value;
            }
          };

          ctrl.$formatters.push(validator);
          ctrl.$parsers.unshift(validator);

          attr.$observe('requiredSelect', function() {
            validator(ctrl.$viewValue);
          });
      }
    };
});*/