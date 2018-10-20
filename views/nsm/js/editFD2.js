app.cp.register('nsmEditFd2Controller', ['$scope', '$http', '$timeout', 'Notification', 'nsmFdService', '$location', 'stringsService', 'countriesService', 'settingsService', '$q', function ($scope, $http, $timeout, Notification, nsmFdService, $location, stringsService, countriesService, settingsService, $q) {	

	var vm = this; 
	
	vm.fd = {};		
	
	vm.spouses = {}; //used to store selected options
	vm.fd.spouses = []; //data from server
	
	vm.children = [];
	vm.fd.children = [];
	
	vm.other_relatives = [];
	vm.fd.other_relatives = [];
	
	//vm.fd.allowances = [];
	//vm.fd.scholarships = [];	
	
	vm.hasNewChild = false;	
	vm.hasNewSpouse = false;	
	vm.hasNewOtherRelative = false;	
	
	vm.all_relatives_count = 0;
	vm.spouses_count = 0;
	vm.children_count = 0;
	vm.other_relatives_count = 0;
	
	//vm.allowances_count = 0;
	//vm.scholarships_count = 0;	
	
	vm.other_relative_type = ""; //used for drop-down
	
	function initEditFd2Ctrl() {		
		settingsService.get("editFD2Ctrl").then(function(settings){				
			vm.settings = settings.data;
			nsmFdService.get(listCtrl.nsm.staff_member_id).then(function(familyData){
				var data = familyData.data.data.data;
				
				vm.staff_member_id = listCtrl.nsm.staff_member_id;
				
				vm.fd.spouses = data.spouses;
				vm.spouses_count = data.spouses.length;
				
				vm.fd.children = data.children;
				vm.children_count = data.children.length;
				
				vm.fd.other_relatives = data.other_relatives;
				vm.other_relatives_count = data.other_relatives.length;
				
				vm.all_relatives_count = vm.spouses_count + vm.children_count + vm.other_relatives_count;
				
				//vm.fd.allowances = data.allowances;
				//vm.allowances_count = data.allowances.length;
				
				//vm.fd.scholarships = data.scholarships;		
				//vm.scholarships_count = data.scholarships.length;				
				
				countriesService.get("EN").then( function(countryData) {
					vm.countries = countryData.data;
					setSelectedOptions();	
				});
				
				stringsService.get("EN", "nsm").then( function(stringsData) {
					vm.strings = stringsData.data;
				});					
				
				_children = vm.fd.children;
			});
		});	
	}	
	
	function setSelectedOptions() {
		
		Object.keys(vm.fd).forEach(function(key) {			
			vm[key] = {};			
			vm.fd[key].forEach(function(dep){ //dep for "dependent person" object	
				var vmDep = vm[key][dep.id] = {};
				assignCountryKeys(dep, vmDep)
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
	
	function noop(){
		return;
	}
	
	function addChild() {
		nsmFdService.addChild(listCtrl.nsm.staff_member_id).then(function(childDefaultData){			
			vm.fd.children.unshift(childDefaultData.data.data);
			vm.fd.children[0].relation = "CHIL";
			vm.hasNewChild = true;	
			vm.children_count++;
			vm.all_relatives_count++;
		})
	}
	
	function addSpouse() {
		nsmFdService.addSpouse(listCtrl.nsm.staff_member_id).then(function(spouseDefaultData){			
			vm.fd.spouses.unshift(spouseDefaultData.data.data);
			vm.fd.spouses[0].relation = "SPOU";
			vm.hasNewSpouse = true;
			vm.spouses_count++;
			vm.all_relatives_count++;
		})
	}	
	
	function addOtherRelative(relation) {
		nsmFdService.addOtherRelative(listCtrl.nsm.staff_member_id).then(function(otherRelativeDefaultData){			
			vm.fd.other_relatives.unshift(otherRelativeDefaultData.data.data);
			vm.fd.other_relatives[0].relation = relation;
			vm.hasNewOtherRealtive = true;
			vm.other_relatives_count++;
			vm.all_relatives_count++;
		})
	}
	
	function addRelative(relation, event){	
		event.preventDefault();
		console.log("relation", relation);
		switch(relation) {
			case "CHIL": addChild(); break;
			case "SPOU": addSpouse(); break;
			default: addOtherRelative(relation);
		}				
	}
	
	function nsmFdEditSubmit(){	
		var myForm = document.getElementById('nsmFdEditForm');	
		var formData = new FormData(myForm);		
		
		$http({
			method: 'POST',
			url: 'http://127.0.0.1:8500/NSM/index.cfm?action=staff.saveEditFdNSM',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {
			//console.log(response.data);
			Notification.info({message: 'Form correctly submitted', positionY: 'top', positionX: 'right'});
		}, function errorCallback(response) {		
			console.log("error: " + response.status);
			Notification.warning({message: 'Form NOT correctly submitted', positionY: 'top', positionX: 'right'});
		});			
	}	
	
	function reload(){
		initEditFdCtrl();
	}		
	
	vm.reload = reload;
	vm.nsmFdEditSubmit = nsmFdEditSubmit;
	
	vm.noop = noop;	
	vm.addRelative = addRelative;

	initEditFd2Ctrl();	
	
}]);	