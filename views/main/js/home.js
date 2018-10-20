app.cp.register('homeController', ['$scope', 'settingsService', '$q', function ($scope, settingsService, $q) {	

	console.log("homeController called");

	var vm = this;	
	
	//exported functions
	vm.setHomeTab = setHomeTab;	
	
	vm.user = {};
	vm.user.user_id = 1414; 				
	vm.homeUrl = 'index.cfm?action=main.info&jx&id=' + vm.user.user_id;
	
	vm.tabs = {};
	vm.tabs.info = false;
		
	function initHomeCtrl(){	
	
		var $p1 = settingsService.get(); 		
		
		$q.all([$p1]).then(function(resp) {
			vm.displayLanguage = resp[0].data.displayLanguage;
			vm.initialHomeTab = resp[0].data.initialHomeTab;	
			setHomeTab(vm.initialHomeTab);		
		});				
	}	
	
	function setHomeTab(tabName){					
		vm.tabs[tabName] = true;
		vm.activeTab = tabName;
	}	
	
	initHomeCtrl();
	
}]);