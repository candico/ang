
var app = angular.module('app', ['ngTouch',
                                 'ngTable',
                                 'ngFileUpload',
								 'ui.bootstrap',
                                 'ui.grid',
                                 'ui.grid.selection',
                                 'ui.grid.cellNav',
								 'ui.grid.saveState',
                                 'ngMessages',
                                 'ui-notification',
                                 'ui.bootstrap',
                                 'angular-loading-bar',
                                 'ngDialog',
                                 'ui.router',
                                 'ngStorage',
                                 'ngAnimate',
                                 'ngSanitize',
                                 'angucomplete-alt'])

.config(function($controllerProvider, $compileProvider, $httpProvider) {
    app.cp = $controllerProvider;
	app.co = $compileProvider;

	//force refreshes, needed for IE
	$httpProvider.defaults.cache = false;
    if (!$httpProvider.defaults.headers.get) {
      $httpProvider.defaults.headers.get = {};
    }
	
    // disable IE ajax request caching
    $httpProvider.defaults.headers.get['If-Modified-Since'] = '0';	
})

.config(['cfpLoadingBarProvider', function(cfpLoadingBarProvider) { // Configuration for angular-loading-bar
    cfpLoadingBarProvider.includeSpinner = false; // Turn the spinner on or off
}])

.constant('API', {
    url			: 'index.cfm?action=',
    appVersion	: '0.1'
})

.run(function ($rootScope, $state, $stateParams) {
    $rootScope.$state = $state;
    $rootScope.$stateParams = $stateParams;
})

.controller('rejectModalInstanceCtrl', function ($uibModalInstance, str, rejectReason) {
  var $ctrl = this;  

  $ctrl.str = str;
  $ctrl.rejectReason = rejectReason;

  $ctrl.ok = function () {
	  
	if( !confirm($ctrl.str.ARE_YOU_SURE_REJECT_CHANGES) )
		return;	
	  
    $uibModalInstance.close($ctrl.rejectReason);
  };

  $ctrl.cancel = function () {
    $uibModalInstance.dismiss('cancel');
  };    
})

.controller('workflowModalInstanceCtrl', function ($uibModalInstance, str, wf) { 
  var $ctrl = this;  

  $ctrl.str = str;
  $ctrl.wf = wf;

  $ctrl.ok = function () {
    $uibModalInstance.close();
  };

  $ctrl.cancel = function () {
    $uibModalInstance.dismiss();
  };  
});
;
