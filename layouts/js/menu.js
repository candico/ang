app.controller('topMenuController', ['$scope', '$state', 'settingsService','stringsService', 'userService', '$q', '$localStorage', '$sessionStorage', 'masterService', 'navService',
 function ($scope, $state, settingsService, stringsService, userService, $q, $localStorage, $sessionStorage, masterService, navService) {

	console.log(" topMenuController called [layouts/js/main.js]");
	
	///$scope.currentFieldOffice = $sessionStorage.userData.current_field_office;
	var settings;
	var officeId;
	var showOfficeDropDown = true; //even if it's actually 0!
	
	var vm = this; 
	vm.strings = {};
	vm.displayLanguage;
	vm.homeURL = "index.cfm?jx";	
	vm.items = {}; //these items are the top-menu choices
	vm.items.home = false;
	vm.items.fom = false; 
	vm.items.nsm = false; 	
	vm.activeItem = "";		
	vm.str = {};
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function initCtrl(item) {
		
		settingsService.get("topMenuCtrl").then(function(resp){
			
			var settings = resp.data;
			vm.displayLanguage = settings.displayLanguage;					
			vm.currentFieldOfficeId = settings.current_field_office_id;
			vm.currentFieldOffice = settings.current_field_office;	
			vm.lname = settings.lname;	
			vm.fname = settings.fname;				
			vm.homeOffice = settings.home_office;		
			vm.profile = settings.profile;
			vm.del_user_id = settings.del_user_id;
			vm.del_user_fname = settings.del_user_fname;
			vm.del_user_lname = settings.del_user_lname;				
			vm.privs = settings.privs;
			
			vm.fomURL = "index.cfm?action=fom&jx&id=" + vm.currentFieldOfficeId;
			vm.nsmURL = "index.cfm?action=nsm:nsm&jx&id=" + vm.currentFieldOfficeId;
			vm.evalURL = "index.cfm?action=eval:eval&jx&id=" + vm.currentFieldOfficeId;
			
			//setPrivs(settings.privs);
			
			var p1 = setStrings(settings.displayLanguage);	
			var p2 = userService.getOffices();	
			
			$q.all([p1,p2]).then(function(values){ 
				vm.fieldOffices = values[1].data;
				if(item)
					setTopMenuItem(item);	
				else
					setTopMenuItem('home');
			});
		});	
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function setPrivs(privs){	
		vm.chk_view_evaluations = false;
		if(privs.chk_view_evaluations == "Y")
			vm.chk_view_evaluations = true;
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function logAs(){
		location.href = "index.cfm?logAs";
	}
	
	function setTopMenuItem(itemName){
		
		if(itemName != "fom") {
			$("body").trigger("click"); //close the dropdown if open
			vm.officesDataToggleAttr = "";
			showOfficeDropDown = false;
		}
		else if(showOfficeDropDown)
			vm.officesDataToggleAttr = "dropdown";	
		else 	
			showOfficeDropDown = true;		 			
					
		vm.items[itemName] = true;
		vm.activeItem = itemName;
	}	
	
	function setFieldOffice(fieldOfficeId){
		masterService.get('main', 'setOffice', {office_id: fieldOfficeId})
		.then(
			function onSuccess(response) {
				$sessionStorage.userData = angular.copy(response);
				vm.fomURL = "index.cfm?action=fom&jx&id=" + fieldOfficeId;
				vm.nsmURL = "index.cfm?action=nsm&jx&id="+ fieldOfficeId;
				vm.evalURL = "index.cfm?action=eval&jx&id="+ fieldOfficeId;
				setTopMenuItem("fom"); //we want to remain on the FOM tab
				initCtrl("fom");
			},
			function onError(response) {
				Notification.error({message:response, positionY: 'top', positionX: 'right'});
			}
		);
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Navigation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	$scope.$on('navAction', function(event, args) {		
		console.log("menu.js: navAction broadcast", event, args);		
		if(args.module)
			setTopMenuItem(args.module);
	});	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function setStrings(lang) {				
		var p1 = stringsService.get(lang, "SHARED");		
		
		return $q.all([p1]).then(function(values){ 			
			var JS = values[0].data.JS;
			var LIB = values[0].data.LIB;			
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;	
			vm.js = vm.strings["JS"];
			vm.lib = vm.strings["LIB"];
			vm.str = vm.strings["LIB"];
			return $q.resolve();
		});	
	}
	
	$scope.$on('languageChanged', function(event, args) {				
		if(args.lang != vm.displayLanguage){					
			var p1 = setStrings(args.lang);
			$q.all([p1]).then(function(values){ 
				vm.displayLanguage = args.lang;	
			});
		}
	});		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	vm.setTopMenuItem = setTopMenuItem;
	vm.setFieldOffice = setFieldOffice;		
	vm.logAs = logAs;	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();
	
}]);	