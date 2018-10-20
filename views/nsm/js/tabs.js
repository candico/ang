app.cp.register('nsmTabsController', ['$scope', '$http', 'Notification', 'dataService', 'settingsService', 'stringsService', function ($scope, $http, Notification, dataService, settingsService, stringsService) {		

	console.log("nsmTabsController loaded!");  

	var vm = this;	
	vm.tabs = {};
	
	//var staff_member_id = listCtrl.nsm.staff_member_id;
	var staffMemberId = dataService.get("nsm", "staffMemberId");
	
	vm.editGdUrl = 'index.cfm?action=nsm.editGD&jx&staff_member_id=' + staffMemberId;	
	vm.editFdUrl = 'index.cfm?action=nsm.editFD&jx&staff_member_id=' + staffMemberId;		
	vm.editPeUrl = 'index.cfm?action=nsm.editPE&jx&staff_member_id=' + staffMemberId;	
	vm.editEdUrl = 'index.cfm?action=nsm.editED&jx&staff_member_id=' + staffMemberId;		
		
	function initCtrl() {		
		//saving which tabs have already been loaded			
		vm.tabs.gd = false;
		vm.tabs.fd = false;				
		vm.tabs.ep = false;	
		vm.tabs.ed = false;	
				
		//ask application which tab should be active (this should be a service)
		//otherwise gd is active by default	
		setTab('gd');
	}		
	
	function setTab (tabName){	
		vm.tabs[tabName] = true;
		vm.activeTab = tabName;
	}
	
	//exported functions
	vm.setTab = setTab;		
	
	initCtrl();
	
}]);

app.directive('multi', ['$parse', '$rootScope', function ($parse, $rootScope) {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function (scope, elem, attrs, ngModelCtrl) {
      var validate = $parse(attrs.multi)(scope);
	  var pos = $parse(attrs.pos)(scope);
      ngModelCtrl.$viewChangeListeners.push(function () {
        ngModelCtrl.$setValidity('multi', validate(pos));		
        //$rootScope.$broadcast('multi:valueChanged');
      });

/*      var deregisterListener = scope.$on('multi:valueChanged', function (event) {
        ngModelCtrl.$setValidity('multi', validate());
      });
      scope.$on('$destroy', deregisterListener); // optional, only required for $rootScope.$on*/
    }
  };
}]);

function getFormData() {	
	var myForm = document.getElementById('nsmEditForm');	
	return new FormData(myForm);
}

function makeRequest(opts) {
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
}

app.directive('requiredSelect', function () {
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
});
  






