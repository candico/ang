
app.cp.register('nsmEditGdController', ['$rootScope', '$scope', '$http', '$timeout', 'Notification', 'dataService', 'nsmService', '$location', 'stringsService', 'countriesService', 'citizenshipsService', 'settingsService', '$q', 'nsmFdService', function ($rootScope, $scope, $http, $timeout, Notification, dataService, nsmService, $location, stringsService, countriesService, citizenshipsService, settingsService, $q, nsmFdService) {	

	console.log("nsmEditGdController loaded!"); 

	var vm = this; //vm for ViewModel
	vm.strings = {};
	vm.countries = {};
	vm.citizenships = {};
	
	var settings;
	var staffMemberId;
	var relatives;	
	
	function error(name) {
		//console.log("$scope.nsmGdEditForm", $scope.nsmGdEditForm)
		var s = $scope.nsmGdEditForm[name];
		//console.log("s.$invalid && s.$dirty", s.$invalid && s.$dirty);
		return s.$invalid && s.$dirty ? "has-error has-feedback" : "";
	};
		
	function initCtrl() {		
		
		//var staffMemberId = listCtrl.nsm.staff_member_id;
		staffMemberId = dataService.get("nsm", "staffMemberId");
		vm.staff_member_id = staffMemberId;			
		
		settingsService.get("nsmEditGdController").then(function(resp){			
			settings = resp.data;			
			vm.displayLanguage = settings.displayLanguage;
			var p1 = setStrings(vm.displayLanguage);
			var p2 = setCitizenships(vm.displayLanguage);
			var p3 = setCountries(vm.displayLanguage);	
			var p4 = setGeneralData(staffMemberId);
			$q.all([p1, p2, p3, p4]).then(function(values){ 
				setSelectedOptions();
			})
		});	
		
		nsmFdService.get(staffMemberId).then(function(resp){
			relatives = resp.data;
			
			if(relatives.spouses)
				vm.spouses_count = relatives.spouses.length;
			else				
				vm.spouses_count = 0;
				
			if(relatives.children)
				vm.children_count = relatives.children.length;
			else				
				vm.children_count = 0;
				
			if(relatives.other_relatives)				
				vm.other_relatives_count = relatives.other_relatives.length;
			else
				vm.other_relatives_count = 0;
		});
	}	
	
	function setGeneralData(staffMemberId){		
		return nsmService.get(staffMemberId).then(function(resp){			
			vm.data = resp.data; 
			return $q.resolve();
		});			
	}
	
	function setStrings(langCode) {		
		var p1 = stringsService.get(langCode, "SHARED");
		var p2 = stringsService.get(langCode, "PI");
		var p3 = stringsService.get(langCode, "FD");
		
		return $q.all([p1, p2, p3]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS, values[2].data.JS);			
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB, values[2].data.LIB);				
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;
			vm.str = vm.strings["JS"];	
			return $q.resolve();
		});	
	}	
	
	function setCitizenships(langCode) {		
		return citizenshipsService.get(langCode).then(function(resp){
			vm.citizenships = resp.data;			
			return $q.resolve();
		});		
	}	
	
	function setCountries(langCode) {		
		return countriesService.get(langCode).then(function(resp){
			vm.countries = resp.data;				
			return $q.resolve();			
		});		
	}	
	
	function changeLanguage() {		
		if(vm.displayLanguage == "EN")
			vm.displayLanguage = "FR";
		else 	
			vm.displayLanguage = "EN";	
			
		settingsService.set("displayLanguage", vm.displayLanguage).then(function(){
			var p1 = setStrings(vm.displayLanguage);
			var p2 = setCitizenships(vm.displayLanguage);
			var p3 = setCountries(vm.displayLanguage);			
			$q.all([p1, p2, p3]).then(function(values){ 
				$rootScope.$broadcast('languageChanged', {lang:vm.displayLanguage});
			})		
		})		
	}	
	
	$scope.$on('languageChanged', function(event, args) {
		console.log("Language change event in editGD.js", args);
		if(args.lang != vm.displayLanguage)
			changeLanguage(args.lang);
	});
	
	function setSelectedOptions() {		
		vm.birth_country = vm.countries["LIB"].find( findByCode, [vm.data.birth_country_code] );		
		vm.citizenship_1 = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_1_country_code] );	
		vm.citizenship_2 = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_2_country_code] );
		vm.citizenship_3 = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_3_country_code] );
		vm.ms_country = vm.countries["LIB"].find( findByCode, [vm.data.ms_country_code] );
		vm.business_address_country = vm.countries["LIB"].find( findByCode, [vm.data.business_address_country_code] );
		vm.private_address_country = vm.countries["LIB"].find( findByCode, [vm.data.private_address_country_code] );
		
		vm.doc_dl_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_dl_country_code] );
		vm.doc_pass_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_pass_country_code] );
		vm.doc_pass2_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_pass2_country_code] );
		vm.doc_wl_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_wl_country_code] );
		vm.doc_rp_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_rp_country_code] );
		vm.doc_ebdg_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_ebdg_country_code] );
		vm.doc_dbdg_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_dbdg_country_code] );
		vm.doc_lap_country = vm.countries["LIB"].find( findByCode, [vm.data.doc_lap_country_code] );
	}			
	
	function findByCode(obj) {				
		if (obj.code === this[0]) {			 
			return obj;
		}
	}
	
	function nsmEditSubmit(){	
		var myForm = document.getElementById('nsmGdEditForm');	
		var formData = new FormData(myForm);		
		
		$http({
			method: 'POST',
			url: 'index.cfm?action=staff.saveEditNSM',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {			
			Notification.info({message: 'Form correctly submitted', positionY: 'top', positionX: 'right'});
		}, function errorCallback(response) {	
			Notification.warning({message: 'Form NOT correctly submitted', positionY: 'top', positionX: 'right'});
		});			
	}
		
	function noCitizDup(pos) {			
		var retVal = true;
		var citizenships = [];	
				
		if (vm.citizenship_1 && vm.citizenship_1.code)
			citizenships.push( vm.citizenship_1.code );
		else		
			citizenships.push( "" );
			
		if (vm.citizenship_2 && vm.citizenship_2.code)
			citizenships.push( vm.citizenship_2.code );
		else		
			citizenships.push( "" );	
			
		if (vm.citizenship_3 && vm.citizenship_3.code)
			citizenships.push( vm.citizenship_3.code );
		else		
			citizenships.push( "" );			
		
		if(pos == 1 && (citizenships[0] == citizenships[1] || citizenships[0] == citizenships[2])) 
			retVal = false;	
		if(pos == 2 && (citizenships[1] == citizenships[0] || citizenships[1] == citizenships[2])) 
			retVal = false;	
		if(pos == 3 && (citizenships[2] == citizenships[0] || citizenships[2] == citizenships[1])) 
			retVal = false;		
		
		//side-effects: remove error on other fields as appropriate
		if( citizenships[0] != citizenships[1] && citizenships[0] != citizenships[2] )
			$scope.nsmGdEditForm.citizenship_1_country_code.$setValidity("multi", true);			
		if( citizenships[1] != citizenships[0] && citizenships[1] != citizenships[2] )
			$scope.nsmGdEditForm.citizenship_2_country_code.$setValidity("multi", true);	
		if( citizenships[2] != citizenships[0] && citizenships[2] != citizenships[1] )
			$scope.nsmGdEditForm.citizenship_3_country_code.$setValidity("multi", true);	
			
		if(retVal === true)
			Notification.info({message: 'Citizenships are OK', positionY: 'top', positionX: 'right'});	
		else
			Notification.warning({message: 'Citizenships are NOT OK', positionY: 'top', positionX: 'right'});								
			
		return retVal;	
	};
	
	function reload(){
		initCtrl();
	}
	
	function noLangDup(pos) {			
		var retVal = true;
		var languages = [];		
					
		languages.push(vm.data.language_1_id);
		languages.push(vm.data.language_2_id);
		languages.push(vm.data.language_3_id);
		
		if(pos == 1 && (languages[0] == languages[1] || languages[0] == languages[2])) 
			retVal = false;	
		if(pos == 2 && (languages[1] == languages[0] || languages[1] == languages[2])) 
			retVal = false;	
		if(pos == 3 && (languages[2] == languages[0] || languages[2] == languages[3])) 
			retVal = false;		
		
		//side-effects: remove error on other fields as appropriate
		if( languages[0] != languages[1] && languages[0] != languages[2] )
			$scope.nsmGdEditForm.language_1_id.$setValidity("multi", true);			
		if( languages[1] != languages[0] && languages[1] != languages[2] )
			$scope.nsmGdEditForm.language_2_id.$setValidity("multi", true);	
		if( languages[2] != languages[0] && languages[2] != languages[1] )
			$scope.nsmGdEditForm.language_3_id.$setValidity("multi", true);	
			
		if(retVal === true)
			Notification.info({message: 'Languages are OK', positionY: 'top', positionX: 'right'});	
		else
			Notification.warning({message: 'Languages are NOT OK', positionY: 'top', positionX: 'right'});						
			
		return retVal;	
	};	
	
	//exported functions
	vm.changeLanguage = changeLanguage;	
	vm.nsmEditSubmit = nsmEditSubmit;
	vm.noCitizDup = noCitizDup;
	vm.noLangDup = noLangDup;
	vm.reload = reload;
	vm.error = error;
		
	initCtrl();	  
	
}]);

/*app.co.directive('multi', ['$parse', '$rootScope', function ($parse, $rootScope) {
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
    }
  };
}]);*/

app.co.directive("ssv", function($q, $timeout, $http) {  	
//ssv for: server-side validation 	
    return {
      restrict: "A",
      require: "ngModel",
	  link: function(scope, element, attributes, ngModel) {	
		element.on('blur', function (evt) {	 //https://blog.brunoscopelliti.com/form-validation-the-angularjs-way/						  
			ngModel.$asyncValidators.ssv = function(modelValue) {					
				
/*				makeRequest({
				  method: 'POST',
				  headers: {"Content-type": "application/x-www-form-urlencoded"},
				  url: 'index.cfm?action=staff.validateGD',
				  params: {
					  	element_name:element[0].name, element_value: modelValue, 
						staff_member_id: scope.editGdCtrl.staff_member_id
				  }
				}).success(function(data, status, headers, config) {
					ngModel.$setValidity('ssv', data.status);
				});	*/	
				
/*				return $http({
					method: 'POST',
					url: 'index.cfm?action=staff.validateGD',
					params: {
						element_name:element[0].name, element_value: modelValue, 
						staff_member_id: scope.editGdCtrl.staff_member_id
					}
				}).then( function(data, status, headers, config) {
					console.log("data", data);
					ngModel.$setValidity('ssv', false);
				});	*/	
				
				
			return $http({
					method: 'POST',
					url: 'index.cfm?action=staff.validateGD',
					params: {
						element_name:element[0].name, element_value: modelValue, 
						staff_member_id: scope.editGdCtrl.staff_member_id
					}
				}).
			 then(function resolved() {
			   //username exists, this means validation fails
			   return true;
			   //return $q.reject('exists');
			 }, function rejected() {
			   //username does not exist, therefore this validation passes
			   //return true;
			   return $q.reject('exists');
			 });				
															
			}			
		})
	  }  
   };
});

/*function getFormData() {	
	var myForm = document.getElementById('nsmGdEditForm');	
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
});*/
  






