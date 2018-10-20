app.cp.register('fieldOfficeEditController', ['$rootScope', '$scope', '$http', '$q', 'Notification', 'fomService', 'stringsService', 'settingsService', '$templateCache', 'dataService', function ($rootScope, $scope, $http, $q, Notification, fomService, stringsService,  settingsService, $templateCache, dataService) {	

	console.log("fieldOfficeViewController called [views/fom/js/view.js]");		
	
	var settings;	
	var fieldOfficeId;
	//and now for some coupling!
	var fomController = $scope.$parent;
	
	var showErrors = true;	

	var vm = this;
	vm.strings = {};
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function initCtrl() {
		
		settingsService.get("fieldOfficeEditController").then(function(resp){				
			settings = resp.data;				 
			fieldOfficeId = settings.current_field_office_id;
			vm.displayLanguage = settings.displayLanguage;
			
			//fomController.resetTemplates();							
						
			var p1 = fomService.getNew(fieldOfficeId);
			
			$q.all([p1]).then(function(values){ 
				vm.data = values[0].data;	
				//Strings
				vm.lib = fomController.lib;	
				vm.str = fomController.lib;		
				vm.js = fomController.js;			
			})				
		});		
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function showError(errObj){		
		return showErrors;
		//return vm.editPreparationForm.$dirty;
	}
	
	function saveEditFieldOffice(){					
		//must reload to display correct buttons			
		fomService.save(fieldOfficeId).then(function(resp){
			var data = resp.data; 			
			Notification.info({message: "Submit Result: " + data.result, positionY: 'top', positionX: 'right'});	
			$rootScope.$broadcast('fomAction', {action:"saveEditFieldOffice"});			
			fomController.resetInfoTabMode("view");
		});				
	}
	
	function cancelEditFieldOffice(){				
		Notification.info({message: 'Edit cancelled', positionY: 'top', positionX: 'right'});		
		fomController.setInfoTabMode("view");
	}
	
	function reload(){				
		initCtrl();
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Alt functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function hasAltHour(field, id){	
		return vm.data.alt 
		&& vm.data.alt["businessHours"] 
		&& vm.data.alt.businessHours[id] 
		&& vm.data.alt.businessHours[id].hasOwnProperty(field);
	}
	
	function getAltHour(field, id){		
		return vm.data.alt.businessHours[id][field];
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	$scope.$on('languageChanged', function(event, args) {	
		console.log('languageChanged in fom edit', args.lang, vm.displayLanguage);	
		if(args.lang != vm.displayLanguage){			
			var p1 = fomController.setStrings(args.lang);						
				$q.all([p1]).then(function(values){ 
					vm.displayLanguage = args.lang;
					vm.lib = fomController.lib;					
					vm.js = fomController.js;				
				})				
			}
	});	

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	vm.saveEditFieldOffice = saveEditFieldOffice;
	vm.cancelEditFieldOffice = cancelEditFieldOffice;
	vm.showError = showError;	
	vm.reload = reload;
	vm.hasAltHour = hasAltHour;
	vm.getAltHour = getAltHour;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	initCtrl();	

}]);