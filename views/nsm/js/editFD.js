app.cp.register('nsmEditFdController', ['$rootScope', '$scope', '$q', '$http', '$timeout', 'Notification', 'dataService', 'nsmFdService', 'stringsService', 'countriesService', 'citizenshipsService', 'settingsService', function ($rootScope, $scope, $q, $http, $timeout, Notification, dataService, nsmFdService, stringsService, countriesService, citizenshipsService, settingsService) {	

	console.log("nsmEditFdController loaded!");
	
	var vm = this; 
	vm.strings = {};
	vm.countries = {};
	vm.citizenships = {};		
	
	vm.data = {}; //main container for data displayed in the template
	
	vm.spouses = {}; //used to store selected options
	vm.data.spouses = []; //data from server
	
	vm.children = [];
	vm.data.children = [];
	
	vm.other_relatives = [];
	vm.data.other_relatives = [];
	
	vm.hasNewChild = false;	
	vm.hasNewSpouse = false;	
	vm.hasNewOtherRelative = false;	
	
	vm.all_relatives_count = 0;
	vm.spouses_count = 0;
	vm.children_count = 0;
	vm.other_relatives_count = 0;	
	
	vm.other_relative_type = ""; //used for drop-down
	
	var settings;
	var staffMemberId;
	
	function initCtrl() {	
	
		//staffMemberId = listCtrl.nsm.staff_member_id;
		staffMemberId = dataService.get("nsm", "staffMemberId");
		//vm.staff_member_id = staffMemberId;	
			
		settingsService.get("nsmEditFdController").then(function(resp){			
			settings = resp.data;			
			vm.displayLanguage = settings.displayLanguage;
			var p1 = setStrings(vm.displayLanguage);
			var p2 = setCitizenships(vm.displayLanguage);
			var p3 = setCountries(vm.displayLanguage);					
			$q.all([p1, p2, p3]).then(function(values){ 
				setSelectedOptions();
			})
		});				
		
		nsmFdService.get(staffMemberId).then(function(resp){
			var relatives = resp.data;		
			
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
					
			vm.all_relatives_count = vm.spouses_count + vm.children_count + vm.other_relatives_count;	
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
			xstr = vm.str;
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
		console.log("Language change event in editFD.js", args);
		if(args.lang != vm.displayLanguage)
			changeLanguage(args.lang);
	});	
	
	function setSelectedOptions() {		
		Object.keys(vm.data).forEach(function(key) {			
			vm[key] = {};			
			vm.data[key].forEach(function(relative){ 	
				var vmRelative = vm[key][relative.id] = {};
				assignCountryKeys(relative, vmRelative)
			});
		});
		
		function assignCountryKeys(sourceObj, targetObj){			
			Object.keys(sourceObj).forEach(function(key){
				if( key.endsWith("_country_code") ) {									
					var pos = key.lastIndexOf("_code");
					var label = key.slice(0, pos);
					targetObj[label] = vm.countries["LIB"].find( findByCode, [sourceObj[key]] );						
				}
			});
		}	
	}
		
	function findByCode(obj) {				
		if (obj.code === this[0]) {			 
			return obj;
		}
	}	
	
	function removeRelative(relativeId){		
		var relative = getRelative(relativeId);
		var lname = relative.surname.toUpperCase();
		var fname = relative.name.toUpperCase();
		
		if (confirm("Are you sure you want to remove\n\n" + fname + " " + lname + "\n\nfrom the list of relatives?")) {
		//do your process of delete using angular js.
			nsmFdService.removeRelative(staffMemberId, relativeId).then(function(resp){
				Notification.info({message: fname + " " + lname + ' <br>is removed from the list of relatives' , positionY: 'top', positionX: 'right'});	
				reload();			
			});
		}
	}	
	
	function getRelative(relativeId){		
		var rel;
		Object.keys(vm.data).forEach(function(key) {	
			vm.data[key].forEach(function(relative){ 				
				if(relative.id == relativeId)
					rel = relative;				
			});
		});	
		
		return rel;		
	}
	
	function addChild() {
		nsmFdService.addChild(staffMemberId).then(function(childDefaultData){			
			vm.data.children.unshift(childDefaultData.data.data);
			vm.data.children[0].relation = "CHIL";
			vm.hasNewChild = true;	
			vm.children_count++;
			vm.all_relatives_count++;
		})
	}
	
	function addSpouse() {
		nsmFdService.addSpouse(staffMemberId).then(function(spouseDefaultData){				
			vm.data.spouses.unshift(spouseDefaultData.data.data);
			vm.data.spouses[0].relation = "SPOU";
			vm.hasNewSpouse = true;
			vm.spouses_count++;
			vm.all_relatives_count++;
		})
	}	
	
	function addOtherRelative(relation) {
		nsmFdService.addOtherRelative(staffMemberId).then(function(otherRelativeDefaultData){			
			vm.data.other_relatives.unshift(otherRelativeDefaultData.data.data);
			vm.data.other_relatives[0].relation = relation;
			vm.hasNewOtherRealtive = true;
			vm.other_relatives_count++;
			vm.all_relatives_count++;
		})
	}
	
	function addRelative(relation, event){	
		event.preventDefault();		
		switch(relation) {
			case "CHIL": addChild(); break;
			case "SPOU": addSpouse(); break;
			default: addOtherRelative(relation);
		}				
	}
	
	function nsmFdEditSubmit(){	
		var myForm = document.getElementById('nsmFdEditForm');	
		var formData = new FormData(myForm);		
		
		//This should be moved to a service
		$http({
			method: 'POST',
			url: 'index.cfm?action=staff.saveEditFdNSM',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {
			var anyChanges = response.data.data.changed;
			if(anyChanges == true)				
				Notification.info({message: 'Changes saved', positionY: 'top', positionX: 'right'});
			else				
				Notification.info({message: 'No changes to save', positionY: 'top', positionX: 'right'});
		}, function errorCallback(response) {		
			Notification.warning({message: 'Form NOT correctly submitted', positionY: 'top', positionX: 'right'});
		});			
	}	
	
	function reload(){
		initCtrl();
	}		
	
	initCtrl();
	
	//exported functions
	vm.reload = reload;
	vm.changeLanguage = changeLanguage;
	vm.nsmFdEditSubmit = nsmFdEditSubmit;
	vm.removeRelative = removeRelative;		
	vm.addRelative = addRelative;		
	
}]);	