
app.controller('NSMEditCtrl', ['$scope', '$http', '$timeout', 'Notification', function ($scope, $http, $timeout, Notification) {	
	
	$scope.nsm = {}; //nsm: national staff member
	$scope.strings = {}; // localized language strings
	
	$scope.civilities = {
		opts: [
		  {code: 'Mr', name: 'Mr'},
		  {code: 'Mrs', name: 'Miss'},
		  {code: 'Ms', name: 'Ms'}
		]
    };	
	
	//for debugging
	//window.edit_nsm_scope = $scope;	
		
	function setCivility() {		
	 	$scope.civilities.selOpt = $scope.civilities.opts.find( findByCode, [$scope.nsm.civility] );
	}	
	
	function findByCode(obj) {				
		if (obj.code === this[0]) {			 
			return obj;
		}
	}	
	
	setGender = function() {	
		return;		
		$scope.nsm.gender = "F";
	}
	
	//we need to set the dropddown value using a function. Using ng-init does not work.
	$scope.set = function(variable, value) {
        $scope.nsm[variable] = value;		
		if(variable == "civility")
			setCivility();
		if(variable == "gender")
			$timeout(setGender, 2000);		
    }
	
	$scope.nsmEditSwitchLang = function(){				
		var myForm = document.getElementById('nsmEditForm');	
		var formData = new FormData(myForm);	
			
		myForm.method = "POST";
		myForm.action = "http://127.0.0.1:8500/NSM/index.cfm?action=staff.switchLang";
		myForm.submit();
		
	}	
	
	$scope.nsmEditSubmit = function(){	
		var myForm = document.getElementById('nsmEditForm');	
		var formData = new FormData(myForm);
			
		req = new XMLHttpRequest();
		req.open("POST", "http://127.0.0.1:8500/NSM/index.cfm?action=staff.saveEditNSM")
		req.send(formData);
	}
		
	$scope.noCitizDup = function (pos) {			
		var retVal = true;
		var citizenships = [];		
					
		citizenships.push($scope.nsm.citizenship_1_country_code);
		citizenships.push($scope.nsm.citizenship_2_country_code);
		citizenships.push($scope.nsm.citizenship_3_country_code);
		
		if(pos == 1 && (citizenships[0] == citizenships[1] || citizenships[0] == citizenships[2])) 
			retVal = false;	
		if(pos == 2 && (citizenships[1] == citizenships[0] || citizenships[1] == citizenships[2])) 
			retVal = false;	
		if(pos == 3 && (citizenships[2] == citizenships[0] || citizenships[2] == citizenships[3])) 
			retVal = false;		
		
		//side-effects: remove error on other fields as appropriate
		if( citizenships[0] != citizenships[1] && citizenships[0] != citizenships[2] )
			$scope.nsmEditForm.citizenship_1_country_code.$setValidity("multi", true);			
		if( citizenships[1] != citizenships[0] && citizenships[1] != citizenships[2] )
			$scope.nsmEditForm.citizenship_2_country_code.$setValidity("multi", true);	
		if( citizenships[2] != citizenships[0] && citizenships[2] != citizenships[1] )
			$scope.nsmEditForm.citizenship_3_country_code.$setValidity("multi", true);	
			
		if(retVal === true)
			Notification.info({message: 'Citizenships are OK', positionY: 'top', positionX: 'right'});	
		else
			Notification.warning({message: 'Citizenships are NOT OK', positionY: 'top', positionX: 'right'});								
			
		return retVal;	
	};	
	
	$scope.noLangDup = function (pos) {			
		var retVal = true;
		var languages = [];		
					
		languages.push($scope.nsm.language_1_id);
		languages.push($scope.nsm.language_2_id);
		languages.push($scope.nsm.language_3_id);
		
		if(pos == 1 && (languages[0] == languages[1] || languages[0] == languages[2])) 
			retVal = false;	
		if(pos == 2 && (languages[1] == languages[0] || languages[1] == languages[2])) 
			retVal = false;	
		if(pos == 3 && (languages[2] == languages[0] || languages[2] == languages[3])) 
			retVal = false;		
		
		//side-effects: remove error on other fields as appropriate
		if( languages[0] != languages[1] && languages[0] != languages[2] )
			$scope.nsmEditForm.language_1_id.$setValidity("multi", true);			
		if( languages[1] != languages[0] && languages[1] != languages[2] )
			$scope.nsmEditForm.language_2_id.$setValidity("multi", true);	
		if( languages[2] != languages[0] && languages[2] != languages[1] )
			$scope.nsmEditForm.language_3_id.$setValidity("multi", true);			
			
		return retVal;	
	};		  
	
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

app.directive("ssv", function($q, $timeout) {  	
//ssv for: server-side validation
    return {
      restrict: "A",
      require: "ngModel",
      link: function(scope, element, attributes, ngModel) {		  
        ngModel.$asyncValidators.ssv = function(modelValue) {	
			var req = makeRequest({
			  method: 'POST',
			  headers: {"Content-type": "application/x-www-form-urlencoded"},
			  url: 'index.cfm?action=staff.saveEditNSM',
			  params: {element_name:element[0].name, element_value: modelValue, staff_member_id: 12345}
			});			
			return req;	
        }
      }
   };
});

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
	//used for dropdowns, but could be used for other widgets
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
  






