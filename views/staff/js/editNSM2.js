
app.controller('NSMEditCtrl2', ['$scope', '$http', '$timeout', 'Notification', 'nsmService', '$location', 'stringsService', 'countriesService', '$q', function ($scope, $http, $timeout, Notification, nsmService, $location, stringsService, countriesService, $q) {		
	
	$scope.staffMemberId = $.urlParam('id') //need to use jQuery (in main/js/app.js!)!!! ;	
	$scope.display_language = "EN";
	
	init();
	
	function init() {
		$p1 = nsmService.get($scope.staffMemberId);
		$p2 = countriesService.get("EN");
		$p3 = stringsService.get("EN");
		
		$q.all([$p1, $p2, $p3]).then(function(values) {
			$scope.nsm = values[0].data;
			$scope.countries = values[1].data;		
			$scope.strings = values[2].data;
			setSelectedOptions();	
		});		
	}
	
	$scope.changeLanguage = function() {
		if($scope.display_language == "EN")
			$scope.display_language = "FR";
		else 	
			$scope.display_language = "EN";	
			
		$p1 = countriesService.get($scope.display_language);
		$p2 = stringsService.get($scope.display_language);
		
		$q.all([$p1, $p2]).then(function(values) {			
			$scope.countries = values[0].data;		
			$scope.strings = values[1].data;				
		});			
	}	
	
	function setSelectedOptions() {
		$scope.birth_country = $scope.countries["LIB"].find( findByCode, [$scope.nsm.birth_country_code] );
		$scope.citizenship_1 = $scope.countries["LIB"].find( findByCode, [$scope.nsm.citizenship_1_country_code] );	
		$scope.citizenship_2 = $scope.countries["LIB"].find( findByCode, [$scope.nsm.citizenship_2_country_code] );
		$scope.citizenship_3 = $scope.countries["LIB"].find( findByCode, [$scope.nsm.citizenship_3_country_code] );
		$scope.ms_country = $scope.countries["LIB"].find( findByCode, [$scope.nsm.ms_country_code] );
		$scope.business_address_country = $scope.countries["LIB"].find( findByCode, [$scope.nsm.business_address_country_code] );
		$scope.private_address_country = $scope.countries["LIB"].find( findByCode, [$scope.nsm.private_address_country_code] );
	}
		
	$scope.civilities = {
		opts: [
		  {code: 'Mr', name: 'Mr'},
		  {code: 'Mrs', name: 'Miss'},
		  {code: 'Ms', name: 'Ms'}
		]
    };	
		
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
	$scope.set = function(variable) {
        //$scope.nsm[variable] = value;		
		if(variable == "civility")
			setCivility();
		if(variable == "gender")
			$timeout(setGender, 2000);		
		//if(variable == "birth_country_code")			setCountryOfBirth();				
    }
	
	$scope.nsmEditSwitchLang = function(){		
		$scope.strings = stringsService.queryStrings("FR");	
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
					
	/*	citizenships.push($scope.nsm.citizenship_1_country_code);
		citizenships.push($scope.nsm.citizenship_2_country_code);
		citizenships.push($scope.nsm.citizenship_3_country_code);*/
		
		if ($scope.citizenship_1 && $scope.citizenship_1.code)
			citizenships.push( $scope.citizenship_1.code );
		else		
			citizenships.push( "" );
			
		if ($scope.citizenship_2 && $scope.citizenship_2.code)
			citizenships.push( $scope.citizenship_2.code );
		else		
			citizenships.push( "" );	
			
		if ($scope.citizenship_3 && $scope.citizenship_3.code)
			citizenships.push( $scope.citizenship_3.code );
		else		
			citizenships.push( "" );						
		
/*		citizenships.push( $scope.citizenship_1.code || {code:"", name:""} );
		citizenships.push( $scope.citizenship_2.code || {code:"", name:""} );
		citizenships.push( $scope.citizenship_3.code || {code:"", name:""} );*/			
		
		console.log("citizenships", citizenships);
		
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
		element.on('blur', function (evt) {	 //https://blog.brunoscopelliti.com/form-validation-the-angularjs-way/			  
			ngModel.$asyncValidators.ssv = function(modelValue) {	
				var req = makeRequest({
				  method: 'POST',
				  headers: {"Content-type": "application/x-www-form-urlencoded"},
				  url: 'index.cfm?action=staff.saveEditNSM',
				  params: {element_name:element[0].name, element_value: modelValue, staff_member_id: 12345}
				});			
				return req;	
			}
		})		
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
  






