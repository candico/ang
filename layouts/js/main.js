app.controller('topMenuController', ['$scope', 'settingsService','stringsService', 'userService',
function ($scope, settingsService, stringsService, userService) {
	
	var vm = this; //vm for ViewModel
	
	console.log(" topMenuController called [layouts/js/main.js]");
	
	vm.homeURL = "index.cfm?jx";	
	vm.items = {}; //these items are the top-menu choices
	vm.strings = {};
	
	var showOfficeDropDown = true; //even if it's actually 0!
	
	function getSettings(item) {
		
		settingsService.get("topMenuCtrl").then(function(resp){	
			var data = resp.data;
			vm.currentFieldOfficeId = data.current_field_office_id;
			vm.currentFieldOffice = data.current_field_office;	
			vm.lname = data.lname;	
			vm.fname = data.fname;				
			vm.homeOffice = data.home_office;		
			vm.profile = data.profile;
			vm.del_user_id = data.del_user_id;
			vm.del_user_fname = data.del_user_fname;
			vm.del_user_lname = data.del_user_lname;				
			privs = data.privs;						
			
			vm.fomURL = "index.cfm?action=fom&jx&id=" + vm.currentFieldOfficeId;
			vm.nsmURL = "index.cfm?action=nsm&jx&id="+ vm.currentFieldOfficeId;
			vm.evalURL = "index.cfm?action=eval&jx&id="+ vm.currentFieldOfficeId;
			
			setPrivs(privs);
			
			stringsService.get(data.displayLanguage, "SHARED").then(function(strings){
				vm.strings = strings.data;
			});				
			
			if(item)
				setTopMenuItem(item);	
			else
				setTopMenuItem('home');	
		});				
		
	}
	
	function initCtrl() {
		vm.items.home = false;
		vm.items.fom = false; 
		vm.items.nsm = false; 	
		vm.activeItem = "";		
			
		getSettings();
		
		settingsService.get("topMenuCtrl").then(function(resp){				
			userService.getOffices().then( function(resp) {	
				vm.fieldOffices = resp.data;				
			});		
		});				
	}
	
	function setPrivs(privs){	
		vm.chk_view_evaluations = false;
		if(privs.chk_view_evaluations == "Y")
			vm.chk_view_evaluations = true;
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
		userService.setOffice(fieldOfficeId).then(function(resp) {				
			//now that settings are updated, we can load the urls
			vm.fomURL = "index.cfm?action=fom&jx&id=" + fieldOfficeId; 
			vm.nsmURL = "index.cfm?action=nsm&jx&id="+ fieldOfficeId;
			vm.evalURL = "index.cfm?action=eval&jx&id="+ fieldOfficeId;
			
			setTopMenuItem("fom"); //we want to remain on the FOM tab
			
			getSettings("fom"); 
		});
	}	
	
	function logout(){
		location.href = "index.cfm?logout";
	}
	
	//exported functions
	vm.setTopMenuItem = setTopMenuItem;
	vm.setFieldOffice = setFieldOffice;		
	vm.logout = logout;	
	
	initCtrl();
	
}]);	