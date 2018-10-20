
app.cp.register('fomController', ['$rootScope', '$scope', 'settingsService', '$q', '$templateCache', 'stringsService', function ($rootScope, $scope, settingsService, $q, $templateCache, stringsService) {	

	console.log("fomController called [views/fom/js/default.js]");
	
	var settings;	
	
	var vm = this;		
	vm.strings = {};
	vm.viewEditToggle = "";	
	vm.tabs = {};			
	vm.tabs.view = false; 
	vm.tabs.edit = false; 	
	vm.tabs.charts = false;		
	vm.tabs.roles = false;	
	//vm.current_field_office_id = 0;
	
	function initCtrl(){	
		//remove current versions of the templates from the cache
		$templateCache.remove('index.cfm?action=fom.view&jx&id=' + vm.current_field_office_id);
		$templateCache.remove('index.cfm?action=fom.edit&jx&id=' + vm.current_field_office_id);
		$templateCache.remove('index.cfm?action=fom.charts&jx&id=' + vm.current_field_office_id);
		$templateCache.remove('index.cfm?action=fom.roles&jx&id=' + vm.current_field_office_id);
		
		settingsService.get("fomCtrl").then(function(resp) {	
			settings = resp.data;		
			vm.displayLanguage = settings.displayLanguage;		
			vm.current_field_office_id = settings.current_field_office_id;
			vm.displayLanguage = settings.displayLanguage;
			vm.initialFomTab = settings.initialFomTab;
			vm.initialFomTabAction = settings.initialFomTabAction;	
			
			var p1 = setStrings(vm.displayLanguage);
			
			$q.all([p1]).then(function(values){});			
					  
			setFomTab(vm.initialFomTab, vm.initialFomTabAction);
			
			vm.viewUrl = 'index.cfm?action=fom.view&jx&id=' + settings.current_field_office_id;
			vm.editUrl = 'index.cfm?action=fom.edit&jx&id=' + settings.current_field_office_id;
			vm.chartsUrl = 'index.cfm?action=fom.charts&jx&id=' + settings.current_field_office_id;	
			vm.rolesUrl = 'index.cfm?action=fom.roles&jx&id=' + settings.current_field_office_id;					
		});				
	}
	
	function setFomTab(tabName, tabAction){		
		vm.activeTab = tabName;	
		
		if(tabName == "info" && tabAction === undefined) {
			vm.tabs[tabAction] = true;				
		}
		if(tabName == "info" && tabAction !== undefined) {
			vm.tabs[tabAction] = true;	
			vm.viewEditToggle = tabAction;	
		}		
		if(tabName == "charts" || tabName == "roles") 
			vm.tabs[tabName] = true;							
	}
	
	function setStrings(lang) {		
		var p1 = stringsService.get(lang, "SHARED");
		var p2 = stringsService.get(lang, "FOM");
		
		return $q.all([p1,p2]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS);
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB);			
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;	
			vm.js = vm.strings["JS"];
			vm.lib = vm.strings["LIB"];
			return $q.resolve();
		});	
	}	
	
	$scope.$on('languageChanged', function(event, args) {		
		if(args.lang != vm.displayLanguage){
			vm.displayLanguage = args.lang;
			setStrings(vm.displayLanguage);
		}
	});		
	
	function changeLanguage() {		
		if(vm.displayLanguage == "EN")
			vm.displayLanguage = "FR";
		else 	
			vm.displayLanguage = "EN";	
			
		settingsService.set("displayLanguage", vm.displayLanguage).then(function(){
			var p1 = setStrings(vm.displayLanguage);						
			$q.all([p1]).then(function(values){ 
				$rootScope.$broadcast('languageChanged', {lang:vm.displayLanguage});				
			})		
		})		
	}	
	
	function toggleViewEdit(){
		if(vm.viewEditToggle == "edit")
			vm.viewEditToggle = "view";
		else
			vm.viewEditToggle = "edit";			
	}	
	
	//exported functions
	vm.setFomTab = setFomTab;	
	$scope.toggleViewEdit = toggleViewEdit;			
	
	initCtrl();
}]);