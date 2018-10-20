app.cp.register('nsmMainEdController', ['$rootScope', '$scope', '$http', 'nsmService', 'Notification', 'dataService', 
'stringsService', 'countriesService', 'settingsService', '$q', 'nsmEdService', '$templateCache', 'uibDateParser', 
function ($rootScope, $scope, $http, nsmService, Notification, dataService, 
stringsService, countriesService, settingsService, $q, nsmEdService, $templateCache, uibDateParser) {	

	console.log("nsmMainEdController", $scope.$id); 	
	
	var settings;
	
	var staffMemberId;			
	var staffMemberDetails;		
	
	var currentViewEdUrl = "";
	var currentEditEdUrl = "";	

	var vm = this; 
	
	vm.data = {};
	vm.tabModes = {};
	vm.tabModes.view = false; //never loaded
	vm.tabModes.edit = false; //never loaded
	
	vm.displayLanguage;
	vm.staff_member_id;
	
	vm.diplomaCountries = {};
	vm.strings = {};
	vm.countries = {};	
	vm.diplomas = {};	
	vm.domains = {};	
	vm.fields = {};
	
	vm.ucountries = {};
	vm.udomains = {};	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
		
	function initCtrl(tabMode) {	
	
		console.log("nsmMainEdController initCtrl", tabMode);
		
		staffMemberId = dataService.get("nsm", "staffMemberId");
		staffMemberDetails = dataService.get("nsm", "staffMemberDetails");
		
		vm.staff_member_id = staffMemberId;
		vm.nsm_details = staffMemberDetails;	
		
		var defaultTabMode = "view"; 	
		var selectedTabMode;
		
		vm.tabModes.view = false;
		vm.tabModes.edit = false;
		
		settingsService.get("nsmMainEdController").then(function(resp){			
			settings = resp.data;	
					
			vm.displayLanguage = settings.displayLanguage;			
			
			var p1 = setStrings(vm.displayLanguage);	
			var p2 = setCountries(vm.displayLanguage);	
			var p3 = setDomains(vm.displayLanguage);
			var p4 = setDiplomas(staffMemberId);
			
			$q.all([p1, p2, p3, p4]).then(function(values){ 				
				setSelectedOptions(vm.data.length);				
				
				if(!!tabMode)
					selectedTabMode = tabMode;
				else if(settings.ed && settings.ed.initialTabMode)		
					selectedTabMode = settings.ed.initialTabMode;		
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
		vm.edTabMode = tabMode;
	}	

	function resetTemplate(tabMode, switchToTabMode) {		
		
		if(tabMode == "view") {		
			var updateTime = Date.now();
			var newViewEdUrl = 'index.cfm?action=nsm:ed.viewED&jx&staff_member_id=' + staffMemberId;
			$templateCache.remove(currentViewEdUrl);		
			currentViewEdUrl = newViewEdUrl;		
			vm.viewEdUrl = currentViewEdUrl;
			vm.tabModes.view = true;
		}
		
		if(tabMode == "edit") {			
			var updateTime = Date.now();		
			var newEditEdUrl = 'index.cfm?action=nsm:ed.editED&jx&staff_member_id=' + staffMemberId;
			$templateCache.remove(currentEditEdUrl);
			currentEditEdUrl = newEditEdUrl;		
			vm.editEdUrl = currentEditEdUrl;	
			vm.tabModes.edit = true;			
		}	
		
		if(switchToTabMode === true)
			setTabMode(tabMode);		
	}

	function setDiplomas(staffMemberId){		
		return nsmEdService.getED(staffMemberId).then(function(resp){			
			vm.data = resp.data; 					
			return $q.resolve();
		});			
	}	
	
	function setCountries(langCode) {		
		return countriesService.get(langCode).then(function(resp){
			vm.countries = resp.data;	
			return $q.resolve();			
		});		
	}	
	
	function setDomains(langCode) {		
		return nsmEdService.getDomains(langCode).then(function(resp){
			vm.domains = resp.data;	
			return $q.resolve();			
		});		
	}		

	function setSelectedOptions() {			
		for(var idx = 0; idx < vm.data.diplomas.length; idx++){			
			setDiploma(idx);						
		}		
	}	
	
	
	function setDiploma(idx){		
		var diploma, dteString, domain, dte, tmp, fieldName;
		
		diploma = vm.data.diplomas[idx];
		vm.diplomas[diploma.id] = {};
				
		dteString = diploma.graduation_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.diplomas[diploma.id].graduation_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		//Country		
		
/*		tmp = vm.diplomas[diploma.id].diploma_country = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [diploma.country_code] ) || {code:"", name:""};		
		fieldName = "country_code_" + diploma.id;
		vm.fields[fieldName] = tmp.country.code;	*/		
		
		fieldName = "country_" + diploma.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [diploma.country_code] ) || {code:"", name:""};	
		
		//Domain
		
/*		tmp = vm.diplomas[diploma.id].diploma_domain = {};
		tmp.domain = vm.domains.find( findByCode, [diploma.domain_code] ) || {code:"", name:""};		
		fieldName = "domain_code_" + diploma.id;
		vm.fields[fieldName] = tmp.domain.code;	*/	
		
		fieldName = "domain_" + diploma.id;
		tmp = vm.udomains[fieldName] = {};
		tmp.domain = vm.domains.find( findByCode, [diploma.domain_code] ) || {code:"", name:""};				
				
	}	
	
	
	
	
	function deleteFields(type, id){		
		switch(type){		
			case "diploma":
				delete vm.fields["country_code_" + id];
				delete vm.fields["omain_code_" + id];
				break;
		}		
	}	
	
	function reload(){
		initCtrl();
	}	
	
//////////////////////////////////
/// Angucomplete	
//////////////////////////////////			

	function setSelectedOption(obj, fld){		
		if( !(obj && obj.originalObject) ){
			vm.fields[fld] = "";
			return;	
		}
				
		vm.fields[fld] = obj.originalObject.code;				
	}				

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Display functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function expandAll(evt){			
		//var target = evt.currentTarget;		
		//var form = $(target).closest("form");	
		var form = $(".education-form");
		$(form).find( ".collapse-link" ).removeClass('collapsed');
		$(form).find( ".collapse" ).collapse('show');			
	}
	
	function collapseAll(evt){					
		//var target = evt.currentTarget;		
		//var form = $(target).closest("form");	
		var form = $(".education-form");
		$(form).find( ".collapse-link" ).addClass('collapsed');
		$(form).find( ".panel-collapse.in" ).collapse('hide');		
	}	
	
	function getHeadingClasses(id, headingType){	
		var classes, diploma = getDiploma(id);			
			
		if( diploma && diploma.status)					
			classes = diploma.status;	
		
		return classes;		
	}	
	
	function hasAltDip(id, field){				
		 return vm.data.alt 
		 && vm.data.alt.diplomas 
		 && vm.data.alt.diplomas[id] 
		 && vm.data.alt.diplomas[id].hasOwnProperty(field);
	}
	
	function getAltDip(id, field){		
		return vm.data.alt.diplomas[id][field] || "[...]";
	}
	
	function getCtry(countryCode){		
		var country = vm.countries["LIB"].find( findByCode, [countryCode] );	
			
		return ( country ? country.name : countryCode );
	}	
	
	function getDomain(domainCode){
		var domain = vm.domains.find( findByCode, [domainCode] );	
				
		return ( domain ? domain.name : domainCode );
	}	
	
	$scope.$on('$includeContentLoaded', function (evt, url) {		
		sync();
	});	
	
	function sync(){
		waitForEl("#nsmEditEdForm", function() {
			//Panels expanded in View screen will be expanded when accessing the Edit screen
			var expandedPanels = $("#nsmViewEdForm div.panel-collapse.collapse.in");
			
			expandedPanels.each( function(index){	
				panelClass = $( this ).attr("class").split(" ")[1]; //eg, family-details-panel			
				panel = $("#nsmEditEdForm div." + panelClass);				
				panel.collapse('show');	
				lnk = $("#nsmEditEdForm ." + panelClass + "collapse-link");			
				lnk.removeClass('collapsed');						
			});	
		});		
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Diploma Management functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function getDiploma(diplomaId){		
		var dip;		
			
		vm.data.diplomas.forEach(function(diploma){ 				
			if(diploma.id == diplomaId)
				dip = diploma;				
		});		
				
		return dip;		
	}

	function addDiploma(levelId) {
		nsmEdService.addDiploma(staffMemberId, levelId).then(function(res){	
			var diploma = res.data;		
			diploma.status = "added";
			vm.data.diplomas.unshift(diploma);	
			setDiploma(0);		
		})
	}
	
	function removeDiploma(diplomaId){	
		var idx, diploma = getDiploma(diplomaId);			
		
		if ( confirm("Are you sure you want to DELETE this Diploma?") ){		
	
			if(diploma.status == "added") {
				//Record does not exist, delete immediately. Cannot be td.				
				idx = vm.data.diplomas.findIndex( arrayFindById, {id:diplomaId} );
				vm.data.diplomas.splice(idx, 1);
				deleteFields("diploma", diplomaId);
			}
			else {
				//Record exists, flag for later removal. 
				diploma.deleted = "Y"; 				
			}	
		}
	}	
	
	function restoreDiploma(diplomaId){	
		var diploma = getDiploma(diplomaId);	
		
		if ( confirm("Are you sure you want to RESTORE this Diploma?") ){	
			diploma.deleted =  "R"; 
			diploma.status = "";
		}	
	}		
		
	function deleteDiploma(diplomaId) {		
		nsmEdService.deleteDiploma(diplomaId).then(function(resp){	
			Notification.info({message: 'Diploma is deleted', positionY: 'top', positionX: 'right'});			
		}).catch(function (response) {
            Notification.info({message: 'Error deleting diploma', positionY: 'top', positionX: 'right'});	
        });		
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Edit, View, Save functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function editED(){		
		if(vm.tabModes.edit === false)
			resetTemplate("edit", true);
		if(vm.tabModes.edit === true)
			setTabMode("edit", true);
	}
	
	function viewED(){				
		if(vm.tabModes.view === false)
			resetTemplate("view", true);
		if(vm.tabModes.view === true)
			setTabMode("view", true);
	}	
	
	function saveED(){	
		var myForm = document.getElementById('nsmEditEdForm');	
		var formData = new FormData(myForm);
		
/*		Object.keys(vm.fields).forEach(function(key) {				
			formData.append(key, vm.fields[key]); 
		});	*/		
		
		Object.keys(vm.ucountries).forEach(function(key) {				
			var fieldName, arr = key.split("_");
			arr.splice(-1, 0, "code");
			fieldName = arr.join("_");					
			formData.append(fieldName, vm.ucountries[key].country.code); 
		});
		
		Object.keys(vm.udomains).forEach(function(key) {				
			var fieldName, arr = key.split("_");
			arr.splice(-1, 0, "code");
			fieldName = arr.join("_");					
			formData.append(fieldName, vm.udomains[key].domain.code); 
		});										
		
		$http({
			method: 'POST',
			url: 'index.cfm?action=nsm:ed.saveED',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {			
			Notification.info({message: vm.str.FORM_SUBMIT_OK, positionY: 'top', positionX: 'right'});			
			//initCtrl("view");		
			$rootScope.$broadcast("tabSaved", "ed");	
		}, function errorCallback(response) {	
			Notification.warning({message: vm.str.FORM_SUBMIT_NOK, positionY: 'top', positionX: 'right'});
		});			
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// File Download Function
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

/*	function openDocFile(diplomaId, version){				
		var path = "index.cfm?action=nsm:ed.openDocFile&staff_member_id=" + staffMemberId + "&diplomaId=" + diplomaId + "&version=" + version;		
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}	*/
	
	function _openDiplomaFile(diplomaId, hash){				
		//var path = "index.cfm?action=nsm:ed.openDiplomaFile&staff_member_id=" + staffMemberId + "&diplomaId=" + diplomaId + "&hash=" + hash;
			$http.get( "index.cfm?action=nsm:ed.openDiplomaFile", { responseType: 'arraybuffer' })
				.then(function (response) {
					var blob = new Blob([response], { type: 'application/pdf' });
	
					if (window.navigator && window.navigator.msSaveOrOpenBlob) {
						window.navigator.msSaveOrOpenBlob(blob); // for IE
					}
					else {
						var fileURL = URL.createObjectURL(blob);
						var newWin = window.open(fileURL);
						newWin.focus();
						newWin.reload();
					}
			});			
	}		
	
	function openDiplomaFile(diplomaId, hash){					
		var path = "index.cfm?action=nsm:ed.openDiplomaFile&staff_member_id=" + staffMemberId + "&diplomaId=" + diplomaId + "&hash=" + hash;		
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}	

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Validation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function isTouchedWithErrors(id, field){			
		var elemName = field + "_" + id;	
		
		//return;
		
		if(	!vm.nsmEditEdForm[elemName] ) 
			return;
			
		var elem = vm.nsmEditEdForm[elemName];	
					
		return elem.$touched && elem.$error;			
	}	
		
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
	
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
			return $q.resolve();
		});	
	}		
	
	$scope.$on('languageChanged', function(event, args) {
		console.log("Language change event in mainED.js", args);
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
	
	function createDate(str) {
		
		var euroDateFormat = "(\\d{2})/(\\d{2})/(\\d{4})";			
				
		if( str.match(euroDateFormat) ){
			var res = str.match(euroDateFormat);	
			var year = parseInt(res[3]);
			var month = parseInt(res[2]);
			var day = parseInt(res[1]);
			var newDate = new Date(year, month-1, day);			
			return newDate;			
		}			
		else			
			return false;		
	}
	
	function isHigherEducation(eduLevelId){		
		return ( [3,4].indexOf(eduLevelId) != -1 );					
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
	vm.viewED = viewED;
	vm.editED = editED;
	vm.saveED = saveED;	
	vm.expandAll = expandAll;
	vm.collapseAll = collapseAll;	
	vm.isTouchedWithErrors = isTouchedWithErrors;
	vm.hasAltDip = hasAltDip;
	vm.getAltDip = getAltDip;	
	vm.getHeadingClasses = getHeadingClasses;
	vm.popup = popup;	
	//vm.getDipCtry = getDipCtry;
	vm.getCtry = getCtry;
	vm.isHigherEducation = isHigherEducation;
	vm.openDiplomaFile = openDiplomaFile;
	vm.setSelectedOption = setSelectedOption;
	vm.addDiploma = addDiploma;
	vm.removeDiploma = removeDiploma;
	vm.restoreDiploma = restoreDiploma;
	vm.getDomain = getDomain;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();	  
	
}]);


