app.cp.register('editPreparationController', ['$scope', '$http', '$interval', 'uiGridConstants', 'evalService', 'settingsService', 'stringsService', 'dataService', function ($scope, $http, $interval, uiGridConstants, evalService, settingsService, stringsService, dataService) {
	
	console.log("editPreparationController loaded!");  
	
	var vm = this; //vm for ViewModel	
	vm.strings = {};
	
	var settings;
	
	function initCtrl() {			
		settingsService.get("editPreparationController").then(function(resp){			
			settings = resp.data;			
			vm.displayLanguage = settings.displayLanguage;
			var p1 = setStrings(vm.displayLanguage);			
			Promise.all([p1]).then(function(values){ 
				setSelectedOptions();
			})
		});		
	}	
	
	function setStrings(langCode) {		
		var p1 = stringsService.get(langCode, "SHARED");
		
		return Promise.all([p1]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS);
			var LIB = Object.assign({}, values[0].data.LIB);			
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;	
			vm.str = vm.strings["JS"];
			return Promise.resolve();
		});	
	}	
	
	function setSelectedOptions() {		
		return;
	}	
	
	function changeLanguage() {		
		if(vm.displayLanguage == "EN")
			vm.displayLanguage = "FR";
		else 	
			vm.displayLanguage = "EN";	
			
		settingsService.set("displayLanguage", vm.displayLanguage).then(function(){
			var p1 = setStrings(vm.displayLanguage);						
			Promise.all([p1]).then(function(values){ 
				$rootScope.$broadcast('languageChanged', {lang:vm.displayLanguage});
				console.log("New language selected in editPreparation.js: ", vm.displayLanguage);
			})		
		})		
	}		
	
	
	// initialize controller
	initCtrl();	
	
}]);	