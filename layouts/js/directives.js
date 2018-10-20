
app.directive('multi', ['$parse', '$rootScope', function ($parse, $rootScope) {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function (scope, elem, attrs, ngModelCtrl) {
      //var validator = $parse(attrs.multi)(scope);	  
	  //var pos = $parse(attrs.pos)(scope);
	  
/*      ngModelCtrl.$viewChangeListeners.push(function () {
		var validator = $parse(attrs.multi)(scope);	  
		var pos = $parse(attrs.pos)(scope);
		ngModelCtrl.$setValidity('multi', validator(pos, elem));				
		console.log("multi check", pos, elem);
		//$rootScope.$broadcast('multi:valueChanged');
      }); */ 
	  
/*      ngModelCtrl.$validators.push(function () {
        ngModelCtrl.$setValidity('multi', validator(pos, elem));		
		console.log("multi check 2", pos, elem);
        //$rootScope.$broadcast('multi:valueChanged');
      }); */
	  
		ngModelCtrl.$validators.multi = function(modelValue){			
      		var validator = $parse(attrs.multi)(scope);
			var pos = $parse(attrs.pos)(scope); 
			console.log("multi check 3", pos);		
			if (validator) return validator(pos, elem);	 
		}  	  
		
		ngModelCtrl.$viewChangeListeners.push(ngModelCtrl.$validators.multi);
    }
  };
}]);

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

app.directive('debug', function() {
  return {
    restrict: 'E',
    scope: {
      expression: '=val'
    },
    template: '<pre>{{debug(expression)}}</pre>',
    link: function(scope) {
      // pretty-prints
      scope.debug = function(exp) {
        return angular.toJson(exp, true);
      };
    }
  }
});

app.directive('euroDate', function () {
	return {
		require: 'ngModel',
		link: function (scope, element, attributes, control) {			
			control.$validators.euroDate = function (value) {					
				var euroDateFormat = "\\d{2}/\\d{2}/\\d{4}";				
				if (control.$isEmpty(value))
					return true;				
				if(value.match(euroDateFormat))
					return true;				
				return false; 				
			};
		}
	};
});

app.filter('cut', function () {
	return function (value, wordwise, max, tail) {
		if (!value) return '';

		max = parseInt(max, 10);
		if (!max) return value;
		if (value.length <= max) return value;

		value = value.substr(0, max);
		if (wordwise) {
			var lastspace = value.lastIndexOf(' ');
			if (lastspace !== -1) {
			  //Also remove . and , so its gives a cleaner result.
			  if (value.charAt(lastspace-1) === '.' || value.charAt(lastspace-1) === ',') {
				lastspace = lastspace - 1;
			  }
			  value = value.substr(0, lastspace);
			}
		}

		return value + (tail || ' …');
	};
});

app.directive('errorFlagging', function() { 
	return function(scope, el, attrs) {		
	
        scope.$watchCollection(attrs.name + '.$error.required', function(newVal, oldVal) {    
			if(!!oldVal){					
				oldVal.forEach( function(el){	
					$( "[name='" + el.$name + "']" ).parentsUntil(".stop-error-flagging").removeClass("panel-danger");
				})	
			}
			if(!!newVal){				
				newVal.forEach( function(el){	
					$( "[name='" + el.$name + "']" ).parentsUntil(".stop-error-flagging").addClass("panel-danger");
				})
			}
        });		    
	}
});

app.directive('updateFlagging', ['$timeout', function ($timeout) {
	return function(scope, el, attrs) {	
	
		//tiemout to make sure directive is called after DOM is ready
		$timeout( function(){			
			$(".alt-data").parents(".panel").children(".panel-heading").addClass("updated");	
        }, 0 );									   
	}
}]);

app.directive("staffBanner", function() {
	
    return {
        templateUrl:"index.cfm?action=nsm:nsm.viewStaffBanner&jx"
    };
	
});		
	
app.directive('convertToNumber', function() {
  return {
    require: 'ngModel',
    link: function(scope, element, attrs, ngModel) {
      ngModel.$parsers.push(function(val) {		  
        return val != null ? parseInt(val, 10) : null;
      });
      ngModel.$formatters.push(function(val) {		  
        return val != null ? '' + val : null;
      });
    }
  };
});	
	
	
