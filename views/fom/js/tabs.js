
app.controller('fomController', ['$rootScope', '$scope', 'settingsService', '$q', '$templateCache', 'stringsService', "$cacheFactory", "$templateRequest", '$sessionStorage',
function ($rootScope, $scope, settingsService, $q, $templateCache, stringsService, $cacheFactory, $templateRequest, $sessionStorage) {	

	$scope.$parent.topMenuCtrl.currentFieldOffice = $sessionStorage.userData.current_field_office; // $scope.$parent <==> topMenuController

	console.log("fomController called [views/fom/js/tabs.js]");
	
	var settings;	
	var currentFieldOfficeId;
	var currentInfoTabAction;
	var currentViewUrl = "";
	var currentEditUrl = "";
	
	var vm = this;		
	vm.strings = {}; 
	
	vm.tabs = {};			
	vm.tabs.view = false; 
	vm.tabs.edit = false; 	
	vm.tabs.charts = false;		
	vm.tabs.roles = false;	
	
	function initCtrl(tab, action){	
		var fomTab;
		var fomAction;
		var updateTime = Date.now();
		
		settingsService.get("fomCtrl").then(function(resp) {	
			settings = resp.data;
			
			vm.displayLanguage = settings.displayLanguage;
			vm.current_field_office_id = settings.current_field_office_id;
			vm.initialFomTab = settings.initialFomTab; 
			vm.initialFomTabMode = settings.initialFomTabAction; 
			
			currentFieldOfficeId = settings.current_field_office_id;			
			
			var p1 = setStrings(vm.displayLanguage);			
			$q.all([p1]).then(function(values){	
				if(!!tab)
					fomTab = tab;
				else if(settings.initialFomTab)		
					fomTab = settings.initialFomTab;		
				else
					fomTab = "info";		
					
				if(!!action)
					fomAction = action;
				else if(settings.initialFomTabAction)		
					fomAction = settings.initialFomTabAction;		
				else
					fomAction = "view";		
					
				resetTemplate(fomAction);					
												  
				setFomTab(fomTab, fomAction);
			});					
		});				
	}
	
	function resetTemplate(mode) {
		if(mode == "view") {
			console.log("resetViewTemplate");
			var updateTime = Date.now();
			var newViewUrl = 'index.cfm?action=fom.view&jx&id=' + currentFieldOfficeId + '?updated=' + updateTime;
			$templateCache.remove(currentViewUrl);		
			currentViewUrl = newViewUrl;		
			vm.viewUrl = newViewUrl;
		}
		if(mode == "edit") {
			console.log("resetEditTemplate");
			var updateTime = Date.now();		
			var newEditUrl = 'index.cfm?action=fom.edit&jx&id=' + currentFieldOfficeId + '?updated=' + updateTime;
			$templateCache.remove(currentEditUrl);
			currentEditUrl = newEditUrl;		
			vm.editUrl = newEditUrl;	
		}		
	}
		
	function setFomTab(tabName, tabAction){		
		console.log("setFomTab", tabName, tabAction)
		vm.activeTab = tabName;	
		
	/*	if(tabName == "info" && tabAction === undefined) {
			vm.tabs[tabAction] = true;				
		}*/
		//if(tabName == "info" && tabAction !== undefined) {			
					
		if(tabName == "info") {
			vm.tabs[tabAction] = true;
			//may we should reload and always move to view when clicking here	
			setInfoTabMode(tabAction);	
		}		
		if(tabName == "charts" || tabName == "roles") 
			vm.tabs[tabName] = true;							
	}
	
	function setInfoTabMode(mode){
		if(!!mode)
			vm.infoTabMode = mode;
		else 		
			vm.infoTabMode = "view";	
	}
	
	function resetInfoTabMode(mode){		
		initCtrl("info", mode);
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
			$scope.lib = vm.lib;
			$scope.js = vm.js;
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
	
	function refreshTemplate(templateName){
		var tpl = templateName;
		$cacheFactory.get('templates').remove(tpl);
		$templateRequest(tpl).then(function ok(){
			console.log("Template " + tpl + " loaded.");
		});
	}
	
	//exported functions
	vm.setFomTab = setFomTab;	
	//$scope.toggleViewEdit = toggleViewEdit;	
	$scope.setInfoTabMode = setInfoTabMode;
	$scope.resetInfoTabMode = resetInfoTabMode;		
	$scope.resetTemplate = resetTemplate;
	$scope.setStrings = setStrings;
	$scope.refreshTemplate = refreshTemplate;	
		
	initCtrl();
}]);