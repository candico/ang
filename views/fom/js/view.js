app.cp.register('fieldOfficeViewController', ['$rootScope', '$scope', '$http', '$q', 'Notification', 'fomService', 'stringsService', 'settingsService', function ($rootScope, $scope, $http, $q, Notification, fomService, stringsService, settingsService) {	

	console.log("fieldOfficeViewController called [views/fom/js/view.js]");
	
	var settings;	
	var currentFieldOfficeId;
	var fieldOfficeId;	
	//and now for some coupling!
	var fomController = $scope.$parent;	

	var vm = this;
	vm.displayLanguage;
	vm.strings = {};	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function initCtrl() {
		
		settingsService.get("fieldOfficeViewController").then(function(resp){				
			settings = resp.data;
			currentFieldOfficeId = settings.current_field_office_id;
			
			vm.displayLanguage = settings.displayLanguage;	
			
			//fomController.resetTemplates();			
			
			fieldOfficeId = settings.current_field_office_id;
						
			var p1 = fomService.get(fieldOfficeId);			
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
		
	function editFieldOffice(){		
		fomController.resetInfoTabMode("edit");
	}	
	
	function validateEdit(){			
		if( !confirm(vm.js["ARE_YOU_SURE_VALIDATE"]) )		
			return;			

		fomService.validateEdit(fieldOfficeId).then(function(resp){
			var data = resp.data; 			
			Notification.info({message: "Submit Result: " + data.result, positionY: 'top', positionX: 'right'});	
			$rootScope.$broadcast('fomAction', {action:"validateEdit"});				
			fomController.resetInfoTabMode("view");
		});				
	}
	
	function rejectEdit(){				
		if( !confirm(vm.js["ARE_YOU_SURE_REJECT"]) )		
			return;			

		fomService.rejectEdit(fieldOfficeId).then(function(resp){
			var data = resp.data; 			
			Notification.info({message: "Submit Result: " + data.result, positionY: 'top', positionX: 'right'});
			$rootScope.$broadcast('fomAction', {action:"rejectEdit"});				
			fomController.resetInfoTabMode("view");
		});				
	}
	
	function requestValidate(){				
		if( !confirm(vm.js["ARE_YOU_SURE_REQUEST_VALIDATE"]) )		
			return;				
					
		fomService.requestValidate(fieldOfficeId).then(function(resp){
			var data = resp.data; 			
			Notification.info({message: "Submit Result: " + data.result, positionY: 'top', positionX: 'right'});		
			$rootScope.$broadcast('fomAction', {action:"requestValidate"});			
			fomController.resetInfoTabMode("view");
		});				
	}	
	
	function discardChanges(){				
		if( !confirm(vm.js["ARE_YOU_SURE_DISCARD_ALL_CHANGES"]) )		
			return;				
					
		fomService.discardChanges(fieldOfficeId).then(function(resp){
			var data = resp.data; 			
			Notification.info({message: "Submit Result: " + data.result, positionY: 'top', positionX: 'right'});	
			$rootScope.$broadcast('fomAction', {action:"discardChanges"});			
			fomController.resetInfoTabMode("view");
		});				
	}		
	
	function reloadTemplates(){		
		fomController.refreshTemplate('index.cfm?action=fom.view&jx&id=' + currentFieldOfficeId);		
	}	
	
	
	
	
	function getSchedule(dayId){
		var idx, day;
		console.log("dayId", dayId);		
		idx = vm.data.businessHours.findIndex( arrayFindById, {id:id} );
		console.log("idx", idx);
		day = vm.data.businessHours[idx];
		
		
		

		
		
		
		
		
		var times = [];
	
		while(day.length){
			var timeComponents = day.splice(0,2);
			var h = timeComponents[0];
			var m = timeComponents[1];
		
			formattedTime = setTime(h, m);
		
			times.push(formattedTime); 
		}
	
	   return formatSchedule(times);   
	}	
	
	
	
	
	
	
	
	
	
	function formatSchedule(version, id, period){ //// "main", 3446, "AM"
		var day, schedule = "", openingTime = "", closingTime = "";
		
		console.log("formatSchedule 1", version, id, period);
		
		if(version == "main") {
			pos = vm.data.businessHours.findIndex( arrayFindById, {id:id} );
			day = vm.data.businessHours[pos];
		}
			
		if(version == "alt"){
			day = vm.data.alt.businessHours[id];
			console.log("altDay", day);
		}		
		
		if(period == "AM"){
			openingTime = "AM: "; 
			if(day.am_opening_hour && day.am_opening_hour != ""){
				openingTime += "from " + day.am_opening_hour + "h";
				if(day.am_opening_minute == "0")
					openingTime += "00";
				else					
					openingTime += day.am_opening_minute;										
			}				
			
			if(day.am_closing_hour && day.am_closing_hour != "") {
				closingTime = " until " + day.am_closing_hour + "h";
				if(day.am_closing_minute == "0")
					closingTime += "00";
				else					
					closingTime += day.am_closing_minute;				
			}	
		}			
		
		if(period == "PM"){
			openingTime = "PM: "
			if(day.pm_opening_hour && day.pm_opening_hour != ""){
				openingTime += "from: " + day.pm_opening_hour + "h";
				if(day.pm_opening_minute == "0")
					openingTime += "00";
				else					
					openingTime += day.pm_opening_minute;										
			}				
			
			if(day.pm_closing_hour && day.pm_closing_hour != "") {
				closingTime = " until  " + day.pm_closing_hour + "h";
				if(day.pm_closing_minute == "0")
					closingTime += "00";
				else					
					closingTime += day.pm_closing_minute;				
			}	
		}	
		
		return openingTime + closingTime;		
	}
	
	
	
	
	
	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Alt functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function hasAltSchedule(id, period){	
		var hasAltSchedule;
	
		if(period == "AM") {		
			hasAltSchedule = vm.data.alt 
			&& vm.data.alt["businessHours"] 
			&& vm.data.alt.businessHours[id] 
			&& 
			( vm.data.alt.businessHours[id].hasOwnProperty("am_opening_hour") 
			|| vm.data.alt.businessHours[id].hasOwnProperty("am_opening_minute") 
			|| vm.data.alt.businessHours[id].hasOwnProperty("am_closing_hour") 
			|| vm.data.alt.businessHours[id].hasOwnProperty("am_closing_minute") 
			);	
		}
			
		if(period == "PM") {
			hasAltSchedule = vm.data.alt 
			&& vm.data.alt["businessHours"] 
			&& vm.data.alt.businessHours[id] 
			&& 
			( vm.data.alt.businessHours[id].hasOwnProperty("pm_opening_hour") 
			|| vm.data.alt.businessHours[id].hasOwnProperty("pm_opening_minute") 
			|| vm.data.alt.businessHours[id].hasOwnProperty("pm_closing_hour") 
			|| vm.data.alt.businessHours[id].hasOwnProperty("pm_closing_minute") 
			);	
		}
		
		console.log("hasAltSchedule", id, period, hasAltSchedule);
		
		return hasAltSchedule;
	}
	
	function getAltSchedule(id, period){
		console.log("getAltSchedule", id, period);
		
		return formatSchedule("alt", id, period);		
	}

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
// Supporting functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function arrayFindById(element){
		if(element.id == this.id)
			return true;
		return false;			
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	$scope.$on('languageChanged', function(event, args) {	
		console.log('languageChanged in fom view', args.lang, vm.displayLanguage);	
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

	vm.editFieldOffice = editFieldOffice;
	vm.requestValidate = requestValidate;
	vm.validateEdit = validateEdit;
	vm.rejectEdit = rejectEdit;
	vm.discardChanges = discardChanges;
	vm.reloadTemplates = reloadTemplates;
	vm.formatSchedule = formatSchedule;
	vm.hasAltHour = hasAltHour;
	vm.getAltHour = getAltHour;	
	
	vm.hasAltSchedule = hasAltSchedule;
	vm.getAltSchedule = getAltSchedule;	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();
		
}]);