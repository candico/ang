app.cp.register('nsmMainPeController', ['$rootScope', '$scope', '$http', 'nsmService', 'Notification', 'dataService', 'stringsService', 'countriesService', 'settingsService', '$q', 'nsmPeService', '$templateCache', 'uibDateParser', function ($rootScope, $scope, $http, nsmService, Notification, dataService, stringsService, countriesService, settingsService, $q, nsmPeService, $templateCache, uibDateParser) {	

	console.log("nsmMainPeController loaded", $scope.$id); 	
	
	var settings;
	
	var staffMemberId;		
	var staffMemberDetails;			
	
	var currentViewPeUrl = "";
	var currentEditPeUrl = "";	

	var vm = this; 
	
	vm.data = {};
	vm.tabModes = {};
	vm.tabModes.view = false; //never loaded
	vm.tabModes.edit = false; //never loaded
	
	vm.experienceCountries = {};
	vm.experiences = {};
	vm.fields = {};
	
	vm.displayLanguage;
	vm.staff_member_id;
	vm.nsm_details = {};
	vm.strings = {};
	vm.countries = {};
	vm.citizenships = {};
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
		
	function initCtrl(tabMode) {	
	
		console.log("nsmMainPeController initCtrl", tabMode);
	
		staffMemberId = dataService.get("nsm", "staffMemberId");
		staffMemberDetails = dataService.get("nsm", "staffMemberDetails");
		
		vm.staff_member_id = staffMemberId;
		vm.nsm_details = staffMemberDetails;	
		
		var defaultTabMode = "view"; 	
		var selectedTabMode;
		
		vm.tabModes.view = false;
		vm.tabModes.edit = false;		
		
		settingsService.get("nsmMainPeController").then(function(resp){		
			
			settings = resp.data;			
			vm.displayLanguage = settings.displayLanguage;			
			
			var p1 = setStrings(vm.displayLanguage);	
			var p2 = setCountries(vm.displayLanguage);	
			var p3 = setExperiences(staffMemberId);
			
			$q.all([p1, p2, p3]).then(function(values){ 				
				setSelectedOptions(vm.data.length);				
				
				if(!!tabMode)
					selectedTabMode = tabMode;
				else if(settings.pe && settings.pe.initialTabMode)		
					selectedTabMode = settings.pe.initialTabMode;		
				else
					selectedTabMode = defaultTabMode;		
					
				resetTemplate(selectedTabMode, true);	
			})
		});		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function setTabMode(tabMode){	
		vm.peTabMode = tabMode;
	}	

	function resetTemplate(tabMode, switchToTabMode) {	
	
		if(tabMode == "view") {		
			var updateTime = Date.now();
			var newViewPeUrl = 'index.cfm?action=nsm:pe.viewPE&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentViewPeUrl);		
			currentViewPeUrl = newViewPeUrl;		
			vm.viewPeUrl = currentViewPeUrl;
			vm.tabModes.view = true;
		}
		
		if(tabMode == "edit") {			
			var updateTime = Date.now();		
			var newEditPeUrl = 'index.cfm?action=nsm:pe.editPE&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentEditPeUrl);
			currentEditPeUrl = newEditPeUrl;		
			vm.editPeUrl = currentEditPeUrl;	
			vm.tabModes.edit = true;			
		}	
		
		if(switchToTabMode === true)
			setTabMode(tabMode);		
	}

	function setExperiences(staffMemberId){		
		return nsmPeService.getPE(staffMemberId).then(function(resp){			
			vm.data = resp.data; 	
			//We need to sort vm.data.experiences
			if(vm.data && vm.data.experiences){
				vm.data.experiences.sort( sortBy('start_date', true, parseDate) );
				//vm.data.experiences.sort( sortBy('id', false, parseInt) );
			}					
									
			return $q.resolve();
		});			
	}		
	
	function setCountries(langCode) {		
		return countriesService.get(langCode).then(function(resp){
			vm.countries = resp.data;	
			return $q.resolve();			
		});		
	}	

	function setSelectedOptions() {				
		for(var idx = 0; idx < vm.data.experiences.length; idx++){			
			setExperience(idx);						
		}			
	}	
	
	function setExperience(idx){		
		var experience, dteString, dte, tmp, fieldName;
		
		experience = vm.data.experiences[idx];
		vm.experiences[experience.id] = {};	
		
		dteString = experience.start_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.experiences[experience.id].start_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		dteString = experience.end_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.experiences[experience.id].end_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		tmp = vm.experiences[experience.id].experience_country = {}; //mainPeCtrl.experiences[experience.id].experience_country.country
		tmp.country = vm.countries["LIB"].find( findByCode, [experience.country_code] ) || {code:"", name:""};		
		fieldName = "country_code_" + experience.id;
		vm.fields[fieldName] = tmp.country.code;			
	}	
	
	function deleteFields(type, id){		
		switch(type){		
			case "experience":
				delete vm.fields["country_code_" + id];				
				break;
		}		
	}	
	
	function reload(){
		initCtrl();
	}		

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Display functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function expandAll(evt){	
		//var target = evt.currentTarget;		
		//var form = $(target).closest("form");	
		var form = $(".professional-experience-form");
		$(form).find( ".collapse-link" ).removeClass('collapsed');
		$(form).find( ".collapse" ).collapse('show');			
	}
	
	function collapseAll(evt){					
		//var target = evt.currentTarget;		
		//var form = $(target).closest("form");
		var form = $(".professional-experience-form");	
		$(form).find( ".collapse-link" ).addClass('collapsed');
		$(form).find( ".panel-collapse.in" ).collapse('hide');		
	}	
	
	function getHeadingClasses(id, headingType){		
		var experience, classes;	
			
		experience = getExperience(id);			
			
		if( experience && experience.status)					
			classes = experience.status;	
		
		return classes;		
	}	
	
	$scope.$on('$includeContentLoaded', function (evt, url) {
		sync();
	});	
	
	function sync(){
		waitForEl("#nsmEditPeForm", function() {
			//Panels expanded in View screen will be expanded when accessing the Edit screen
			var expandedPanels = $("#nsmViewPeForm div.panel-collapse.collapse.in");
			
			expandedPanels.each( function(index){	
				panelClass = $( this ).attr("class").split(" ")[1]; //eg, family-details-panel			
				panel = $("#nsmEditPeForm div." + panelClass);				
				panel.collapse('show');	
				lnk = $("#nsmEditPeForm ." + panelClass + "collapse-link");			
				lnk.removeClass('collapsed');						
			});	
		});		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Select
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function setSelectedOption(obj, fld){		
		if( !(obj && obj.originalObject) ){
			vm.fields[fld] = "";
			return;	
		}
				
		vm.fields[fld] = obj.originalObject.code;				
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Experience Management
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			

	function addExperience() {
		nsmPeService.addExperience(staffMemberId).then(function(res){	
			var experience = res.data;	
			experience.status = "added"	;
			vm.data.experiences.unshift(experience);					
			setExperience(0);			
			
			sel = ".experience-" + experience.id + "-panel";
			console.log("sel", sel);
			
			//waitForEl(".experience-" + experience.id + "-panel", function( jqEl ){	
			waitForEl(sel, function( jqEl ){				
				//$(".experience-58287-panel")				
				jqEl.collapse('show');				
				//console.log("jqEl", experience.id, jqEl);
			});					
		})		
	}	
		
	function getExperience(experienceId){		
		var exp;		
			
		vm.data.experiences.forEach(function(experience){ 				
			if(experience.id == experienceId)
				exp = experience;				
		});		
				
		return exp;		
	}	
	
	function removeExperience(experienceId){	
		var experience, idx;
		
		experience = getExperience(experienceId);		
		
		if ( confirm("Are you sure you want to DELETE this Experience?") ){		
	
			if(experience.status == "added") {
				//Record does not exist, delete immediately. Cannot be td.
				idx = vm.data.experiences.findIndex( arrayFindById, {id:experienceId} );
				vm.data.experiences.splice(idx, 1);
				deleteFields("experience", experienceId);
			}
			else {
				//Record exists, flag for later removal. 
				experience.deleted = "Y"; 				
			}	
		}
	}	
	
	function restoreExperience(experienceId){	
		var experience;	
				
		experience = getExperience(experienceId);	
		
		if ( confirm("Are you sure you want to RESTORE this Experience?") ){	
			experience.deleted =  "R"; 
			experience.status = "";
		}	
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Edit, View, Save Functions Management
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			

	function editPE(){		
		if(vm.tabModes.edit === false)
			resetTemplate("edit", true);
		if(vm.tabModes.edit === true)
			setTabMode("edit", true);
	}
	
	function viewPE(){				
		if(vm.tabModes.view === false)
			resetTemplate("view", true);
		if(vm.tabModes.view === true)
			setTabMode("view", true);
	}	
	
	function savePE(){	
		var myForm = document.getElementById('nsmEditPeForm');	
		var formData = new FormData(myForm);			
		
		Object.keys(vm.fields).forEach(function(key) {				
			formData.append(key, vm.fields[key]); 
		});				
		
		$http({
			method: 'POST',
			url: 'index.cfm?action=nsm:pe.savePE',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {			
			Notification.info({message: vm.str.FORM_SUBMIT_OK, positionY: 'top', positionX: 'right'});
			//resetTemplate("edit", false);
			//initCtrl("view");			
			$rootScope.$broadcast("tabSaved", "pe");
		}, function errorCallback(response) {	
			Notification.warning({message: vm.str.FORM_SUBMIT_NOK, positionY: 'top', positionX: 'right'});
		});			
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Alt-related Function
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function hasAltExp(id, field){			
		return vm.data.alt && vm.data.alt.experiences && vm.data.alt.experiences[id] && vm.data.alt.experiences[id].hasOwnProperty(field);		
	}
	
	function getAltExp(id, field){		
		return vm.data.alt.experiences[id][field] || "[...]";
	}
	
	function getCtry(countryCode){
		var country = vm.countries["LIB"].find( findByCode, [countryCode] );
		
		return ( country ? country.name : countryCode );
	}	
	
	function getAltExpCtry(id){
		var countryCode, country;
		
		countryCode = vm.data.alt.experiences[id]["country_code"];
		country = vm.countries["LIB"].find( findByCode, [countryCode] );
		
		return ( country ? country.name : "[...]" );	
	}	

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Validation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function isTouchedWithErrors(id, field){				
		var elemName = field + "_" + id;	
		
		if( !vm.nsmEditPeForm )
			return;			
			
		if(	!vm.nsmEditPeForm[elemName] ) 
			return;
	
		var elem = vm.nsmEditPeForm[elemName];	
					
		return elem.$touched && elem.$error;			
	}
		
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
	
	function setStrings(langCode) {		
		var p1 = stringsService.get(langCode, "SHARED");
		var p2 = stringsService.get(langCode, "PI");
		var p3 = stringsService.get(langCode, "FD");
		var p4 = stringsService.get(langCode, "NSM");
		
		return $q.all([p1, p2, p3, p4]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS, values[2].data.JS, values[3].data.JS);			
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB, values[2].data.LIB, values[3].data.LIB);				
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;
			vm.str = vm.strings["JS"];	
			return $q.resolve();
		});	
	}		
	
	$scope.$on('languageChanged', function(event, args) {
		console.log("Language change event in mainPE.js", args);
		if(args.lang != vm.displayLanguage)
			setLanguage(args.lang);
	});	
	
	function setLanguage(lang) {			
		var p1 = setStrings(lang);			
		var p2 = setCountries(lang);					
		$q.all([p1, p2]).then(function(values){ 			
			vm.displayLanguage = lang;				
			setSelectedOptions();	
		})		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Supporting functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function findByCode(obj) {				
		if (obj.code === this[0]) {			 
			return obj;
		}
	}	
	
	function waitForEl(selector, callback) {
		if ($(selector).length) {
			callback();
		} else {
			setTimeout(function() {
				waitForEl(selector, callback);
			}, 100);
		}
	};	
	
	function arrayFindById(element){
		if(element.id == this.id)
			return true;
		return false;			
	}	
	
	function parseDate(dteString){
		return uibDateParser.parse(dteString, "dd/MM/yyyy");	
	}
	
	function sortBy(field, reverse, primer){
	   var key = primer ? 
		   function(x) {return primer(x[field])} : 
		   function(x) {return x[field]};
	
	   reverse = !reverse ? 1 : -1;
	
	   return function (a, b) {
		   return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
		} 
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Business Logic functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function days360(experience_id) {
		var days;	
		
		if( !experience_id )
			return;				
		
		var startDate = vm.experiences[experience_id].start_date.date;		
		var endDate = vm.experiences[experience_id].end_date.date;
		
		if( !(startDate && endDate) )
			return;			
		
		var startDay = startDate.getDate();
		var endDay = endDate.getDate();
			
		if (startDay == 31 || lastDayOfFebruary(startDate))		
			startDay = 30;
	
		if (startDay == 30 && endDay == 31)		
			endDay = 30;
			
		days = (endDate.getFullYear() - startDate.getFullYear()) * 360 +
			((endDate.getMonth() + 1) - (startDate.getMonth() + 1)) * 30 + (endDay - startDay);		
	
		return days;
	}

	function lastDayOfFebruary(date) {	
		lastDay = new Date(date.getFullYear(), 2, -1);		
		return date.getDate() == lastDay;
	}	
	
	function expDayCount(experience_id){	
		var dayCount = 0;		
		
		var idx = vm.data.experiences.findIndex( arrayFindById, {id: experience_id} );
		var experience = vm.data.experiences[idx];		
		
		var exp_is_accepted = experience.exp_is_accepted;		
		if(!exp_is_accepted || exp_is_accepted == 'N')
			return 0;
			
		var relevance_pct = parseInt(experience.relevance_pct);			
		if(!relevance_pct)
			return 0;		
	
		var working_time_pct = parseInt(experience.working_time_pct);
		if(!working_time_pct)
			return 0;	
	
/*		var start_date = vm.experiences[experience.id].start_date.date;
		if(!start_date)
			return 0;				
		
		var end_date = vm.experiences[experience.id].end_date.date;
		if(!end_date)
			return 0;									
			
		var basicDays = parseInt( days360(start_date, end_date) );*/
		
		var baseDays = parseInt( days360(experience_id) );		
		
		if(!baseDays || baseDays <= 0)
			return 0;
			
		dayCount = Math.round( baseDays * (relevance_pct/100) * (working_time_pct/100) );		
		
		return dayCount;			
	}
	
	function getStepCount(){
		var steps;	
		var totalDayCount = getTotalDayCount();
		var periodsOf24Months = totalDayCount/(30*24);
		var periodsOf12Months = totalDayCount/(30*12);		
		
		//For FG I + II
		if( [1,2].indexOf(vm.data.fg) != -1) {
			if( periodsOf24Months - Math.floor(periodsOf24Months) < 0.5 ){
				if( periodsOf24Months > 0.99)
					steps = 1 + Math.floor(periodsOf24Months);
				else			
					steps = 1;
			} else {
				if( periodsOf24Months > 0.99)
					steps = 2 + Math.floor(periodsOf24Months);
				else			
					steps = 2;	
			}				
		}
		//For other FGs
		if( [3,4,5,6].indexOf(vm.data.fg) != -1) {
			if( periodsOf12Months - Math.floor(periodsOf12Months) < 0.5 ){
				if( periodsOf24Months > 0.99)
					steps = 1 + Math.floor(periodsOf12Months);
				else			
					steps = 1;
			} else {
				if( periodsOf12Months > 0.99)
					steps = 2 + Math.floor(periodsOf12Months);
				else			
					steps = 2;	
			}			
		}				
		
		return steps;	
	}
	
	function getExperienceDayCount(){
				
		var experienceDayCount = 0;	
		var experiences = getExperiences();			
		
		for(var idx = 0; idx < experiences.length; idx++){
			experienceDayCount += expDayCount(experiences[idx]);						
		}	
		
		return experienceDayCount;	
	}
	
	function getEducationDayCount(){
		
		var yearsAsExp = vm.data.yearsAsExp;
		var daysAsExp = yearsAsExp * 360;
		
		return daysAsExp;	
	}	
	
	function getTotalDayCount(){	
		var totalDayCount = getExperienceDayCount();
		totalDayCount += getEducationDayCount();	
		
		return totalDayCount;
	}
	
	function getTotalMonthCount(){
		var totalMonthCount = Math.floor(getTotalDayCount()/30);	
		
		return totalMonthCount;
	}
	
	function getExperiences(){
		var experiences = [];
		
		for(var idx = 0; idx < vm.data.experiences.length; idx++){
			var exp = vm.data.experiences[idx];
			experiences.push(exp.id);			
		}	
		
		return experiences;
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Date Picker functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	  

	vm.today = function() {
		vm.dt = new Date();
	};
	
  	vm.today();

	vm.clear = function() {
		vm.dt = null;
	};

	vm.inlineOptions = {
		//customClass: getDayClass,
		minDate: new Date(),
		showWeeks: true
	};

	vm.dateOptions = {
		dateDisabled: disabled,
		formatYear: 'yy',
		maxDate: new Date(),
		minDate: new Date(1900, 0, 1),
		startingDay: 1
	};

	// Disable weekend selection
	function disabled(data) {
		var date = data.date,
		mode = data.mode;
		return mode === 'day' && (date.getDay() === 0 || date.getDay() === 6);
	}

	toggleMin = function() {
		vm.inlineOptions.minDate = vm.inlineOptions.minDate ? null : new Date();
		vm.dateOptions.minDate = vm.inlineOptions.minDate;
	};

	toggleMin();
	
	function popupx(popupName){
		vm[popupName].opened = true;
	}
	
	function popup(dt){		
		dt.popup.opened = true;
	}	
	
	function openPopup(relativeId, field){
		vm.relatives[relativeId][field].popup.opened = true;		
	}	

	setDate = function(year, month, day) {
		vm.dt = new Date(year, month, day);
	};

	vm.formats = ['dd/MM/yyyy'];
	vm.format = vm.formats[0];	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	vm.reload = reload;	
			
	vm.viewPE = viewPE;
	vm.editPE = editPE;
	vm.savePE = savePE;	
	
	vm.addExperience = addExperience;	
	vm.removeExperience = removeExperience;	
	vm.restoreExperience = restoreExperience;		
	
	vm.expandAll = expandAll;
	vm.collapseAll = collapseAll;	
	vm.getHeadingClasses = getHeadingClasses;
	vm.popup = popup;
	
	vm.isTouchedWithErrors = isTouchedWithErrors;	
	
	vm.days360 = days360;
	vm.expDayCount = expDayCount;
	vm.hasAltExp = hasAltExp;
	vm.getAltExp = getAltExp;
	vm.getAltExpCtry = getAltExpCtry;	
	vm.getExperienceDayCount = getExperienceDayCount;
	vm.getEducationDayCount = getEducationDayCount;	
	vm.getTotalDayCount = getTotalDayCount;		
	vm.getTotalMonthCount = getTotalMonthCount;	
	vm.getStepCount = getStepCount;		
	vm.getCtry = getCtry;
	
	vm.setSelectedOption = setSelectedOption;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();	  
	
}]);


