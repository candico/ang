app.cp.register('nsmMainFdController', ['$rootScope', '$scope', '$q', '$http', '$timeout', 'Notification', 'dataService', 'nsmFdService', 'stringsService', 
'countriesService', 'citizenshipsService', 'settingsService', '$templateCache', 'uibDateParser', 'newIdService', 
function ($rootScope, $scope, $q, $http, $timeout, Notification, dataService, nsmFdService, stringsService, 
countriesService, citizenshipsService, settingsService, $templateCache, uibDateParser, newIdService) {	

	console.log("nsmMainFdController", $scope.$id);
	
	var settings;
	
	var staffMemberId;		
	var staffMemberDetails;		
	
	var currentViewFdUrl = "";
	var currentEditFdUrl = "";		
		
	var vm = this; 
	vm.fdTabMode = "";
	vm.tabModes = {};
	vm.tabModes.view = false; //never loaded
	vm.tabModes.edit = false; //never loaded	
	
	vm.displayLanguage;
	vm.staff_member_id;
	vm.strings = {};
	vm.countries = {};	
	vm.citizenships = {};	
	
	vm.ucountries = {};	
	
	vm.fields = {};
	fields = vm.fields;
			
	vm.data = {}; 	
	vm.spouses = {}; //used to store selected options
	vm.data.spouses = []; //data from server
	vm.children = []; //used to store selected options
	vm.data.children = [];
	vm.relatives = []; //used to store selected options
	vm.data.relatives = [];
	vm.relatives = {};
	vm.certificates = {};
	vm.scholarships = {};
	vm.new_family_link = "";
	
	vm.maxFieldLength = 100; 
	vm.currencyCodeLength = 3;
	vm.monetaryAmountLength = 10;
	vm.postalCodeLength = 30;
	vm.phoneNumberLength = 30;
	vm.academicYearLength = 9;
	vm.commentsLength = 500;	
	vm.addressLength = 200;	
	
	vm.hasNewChild = false;	
	vm.hasNewSpouse = false;	
	vm.hasNewOtherRelative = false;	
	vm.hasNewRelative = false;	
	
	vm.all_relatives_count = 0;
	vm.spouses_count = 0;
	vm.children_count = 0;
	vm.relatives_count = 0;	
	
	vm.swaps = {};
	swaps = vm.swaps;
	
	vm.other_relative_type = ""; //used for drop-down
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function initCtrl(tabMode) {	
	
		console.log("nsmMainFdController initCtrl", tabMode);		
		
		staffMemberId = dataService.get("nsm", "staffMemberId");
		staffMemberDetails = dataService.get("nsm", "staffMemberDetails");	
		
		vm.staff_member_id = staffMemberId;
		vm.nsm_details = staffMemberDetails;
		
		var defaultTabMode = "view"; 	
		var selectedTabMode;	
		
		vm.tabModes.view = false;
		vm.tabModes.edit = false;			
			
		settingsService.get("nsmEditFdController").then(function(resp){			
			settings = resp.data;	
					
			vm.displayLanguage = settings.displayLanguage;
			
			var p1 = setStrings(vm.displayLanguage);
			var p2 = setCitizenships(vm.displayLanguage);
			var p3 = setCountries(vm.displayLanguage);	
			var p4 = setFD(staffMemberId);	
							
			$q.all([p1, p2, p3, p4]).then(function(values){ 
				setSelectedOptions();
				
				if(!!tabMode)
					selectedTabMode = tabMode;
				else if(settings.fd && settings.fd.initialTabMode)		
					selectedTabMode = settings.fd.initialTabMode;		
				else
					selectedTabMode = defaultTabMode;					
					
				resetTemplate(selectedTabMode, true);				
			})
		});				
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
	
	function removeTemplate(tab){
		
		if(tab == "view") {	
			$templateCache.remove(currentViewFdUrl);
		}
		
		if(tab == "edit") {	
			$templateCache.remove(currentEditFdUrl);
		}		
	}

	function resetTemplate(tabMode, switchToTabMode) {		
		
		if(tabMode == "view") {		
			var updateTime = Date.now();
			var newViewFdUrl = 'index.cfm?action=nsm:fd.viewFD&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentViewFdUrl);		
			currentViewFdUrl = newViewFdUrl;		
			vm.viewFdUrl = currentViewFdUrl;
			vm.tabModes.view = true;			
		}
		
		if(tabMode == "edit") {			
			var updateTime = Date.now();		
			var newEditFdUrl = 'index.cfm?action=nsm:fd.editFD&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentEditFdUrl);
			currentEditFdUrl = newEditFdUrl;		
			vm.editFdUrl = currentEditFdUrl;	
			vm.tabModes.edit = true;			
		}	
		
		if(switchToTabMode === true)
			setTabMode(tabMode);		
	}

	function setFD(staffMemberId){		
		return nsmFdService.get(staffMemberId).then(function(resp){						
			vm.data = resp.data;		
			vm.data.allowances_nature = resp.data.allowances.allowances_nature;
			vm.data.allowances_amount = resp.data.allowances.allowances_amount;
			vm.data.allowances_comments = resp.data.allowances.allowances_comments;							
			//setAltData();	
			
			return $q.resolve();	
		});			
	}
	
	function getFieldPrefix(str){
		switch(str){
			case "spouses": return "spouse";
			case "children": return "child";				
			case "relatives": return "relative";			
			case "certificates": return "certificate";			
			case "scholarships": return "scholarship";						
		}		
	}	
	
	function getCollName(str){
		switch(str){
			case "spouse": return "spouses";
			case "child": return "children";				
			case "relative": return "relatives";			
			case "certificate": return "certificates";			
			case "scholarship": return "scholarships";	
			case "allowances": return "allowances";						
		}		
	}	
	
	function setAltData(){	
		var coll;
		vm.swaps = {}; //reset to remove stale values			
		
		if( vm.data.hasOwnProperty("alt") ){
			Object.keys(vm.data.alt).forEach(function(itemGroupName){ //itemGroup = "spouses[]", ""certificates{}", ...
				coll = vm.data.alt[itemGroupName];
				if( Array.isArray(coll) ){ //its' an array
					coll.forEach(function(altItem) { 						
						setAltItem(itemGroupName, altItem);
					})	
				}	
				else if(itemGroupName != "allowances") {	//it's a struct							
					Object.keys(coll).forEach(function(relativeId){ //coll is certificates, relativeId is 1209, 1542
						coll[relativeId].forEach(function(altItem) { //expected to be an array of certificates
							setAltItem2(itemGroupName, relativeId, altItem); //("certificates", certificate
						})
					})
				}
			})
		}
	}
	
	function setAltItem(itemGroupName, altItem) {	
		var pos, swap, isUpdated, mainItem;
		
		altItemId = altItem.id;
		pos = vm.data[itemGroupName].findIndex( arrayFindById, {id:altItemId} );
		if(pos == -1){				
			altItem.status = "new";
			vm.data[itemGroupName].push(altItem);	
			return;			
		}	
		
		mainItem = vm.data[itemGroupName][pos];				
		if(altItem.deleted == "Y"){									
			mainItem.status = "deleted";
			mainItem.deleted = "Y";
			return;
		}
		
		isUpdated = false;
		Object.keys(altItem).forEach(function(key) {
			if( altItem[key] != mainItem[key] ){
				isUpdated = true;
				swap = mainItem[key];
				mainItem[key] = altItem[key];
				//example fieldName: child_school_address_1204
				fieldName = getFieldPrefix(itemGroupName).concat("_").concat(key).concat("_").concat(altItemId);
				vm.swaps[fieldName] = swap;					
			}
		})	
		
		if( isUpdated === true) {						
			mainItem.status = "updated";
		}
	}	
	
	function setAltItem2(itemGroupName, relativeId, altItem) {	
		var pos, swap, isUpdated, mainItem;
		context = vm.data[itemGroupName]; //eg, vm.data.certificates			
		
		if( !context.hasOwnProperty(relativeId) ){					
			context[relativeId] = [];
			altItem.status = "new";
			context[relativeId].push(altItem);	
			return;	
		}		
		
		altItemId = altItem.id;
		pos = context[relativeId].findIndex( arrayFindById, {id:altItemId} );		
		
		if(pos == -1){				
			altItem.status = "new";
			context[relativeId].push(altItem);	
			return;			
		}	
		
		mainItem = context[relativeId][pos];			
		if(altItem.deleted == "Y"){									
			mainItem.status = "deleted";
			return;
		}		
		
		isUpdated = false;		
		
		Object.keys(altItem).forEach(function(key) {
			if( altItem[key] != mainItem[key] ){				
				isUpdated = true;
				swap = mainItem[key];
				mainItem[key] = altItem[key];
				//example fieldName: child_school_address_1204
				fieldName = getFieldPrefix(itemGroupName).concat("_").concat(key).concat("_").concat(altItemId);				
				vm.swaps[fieldName] = swap;								
			}
		})	
		
		if( isUpdated === true) {						
			mainItem.status = "updated";
		}
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
	
	function deleteFields(type, id){		
		switch(type){		
			case "spouse":
				delete vm.fields["spouse_birth_country_code_" + id];
				delete vm.fields["spouse_cco_country_code_" + id];
				delete vm.fields["spouse_crc_country_code_" + id];
				delete vm.fields["spouse_citizenship_1_country_code_" + id];
				delete vm.fields["spouse_citizenship_2_country_code_" + id];
				break;
			case "child":
				delete vm.fields["child_school_country_code_" + id];
				delete vm.fields["child_citizenship_1_country_code_" + id];
				delete vm.fields["child_citizenship_2_country_code_" + id];		
				break;
			case "relative":	
				delete vm.fields["relative_citizenship_1_country_code_" + id];
				delete vm.fields["relative_citizenship_2_country_code_" + id];	
				break;	
			case "certificate":		
				delete vm.fields["reception_date_" + id];
				delete vm.fields["validity_from_date_" + id];	
				delete vm.fields["validity_until_date_" + id];	
				break;
		}		
	}
	
	function setSpouse(idx){			
		var relative, dteString, dte, tmp, fieldName;
				
		relative = vm.data.spouses[idx];
		vm.relatives[relative.id] = {};		
		
		//Dates
		
		dteString = relative.birth_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].birth_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		dteString = relative.expatriate_since;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].expatriate_since = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		dteString = relative.dependent_since;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].dependent_since = {};
		tmp.date = dte;
		tmp.popup = {opened: false};			
		
		dteString = relative.death_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].death_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		dteString = relative.occupation_start;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].occupation_start = {};
		tmp.date = dte;
		tmp.popup = {opened: false};		

		//Countries
		
		fieldName = "spouse_birth_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [relative.birth_country_code] ) || {code:"", name:""};			
		
		fieldName = "spouse_cco_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [relative.cco_country_code] ) || {code:"", name:""};		
		
		fieldName = "spouse_crc_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [relative.crc_country_code] ) || {code:"", name:""};
		
		fieldName = "spouse_citizenship_1_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [relative.citizenship_1_country_code] ) || {code:"", name:""};	
		
		fieldName = "spouse_citizenship_2_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [relative.citizenship_2_country_code] ) || {code:"", name:""};
	}
	
	function setChild(idx){		
		var relative, dteString, dte, tmp, fieldName;
		
		relative = vm.data.children[idx];
		vm.relatives[relative.id] = {};		
		
		//Dates		
		
		dteString = relative.birth_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].birth_date = {};
		tmp.date = dte;
		vm.relatives[relative.id].age = getAge(dte);
		tmp.popup = {opened: false};	
		
		dteString = relative.dependent_since;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].dependent_since = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		//Countries		
		
		fieldName = "child_school_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [relative.school_country_code] ) || {code:"", name:""};		
		
		fieldName = "child_citizenship_1_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [relative.citizenship_1_country_code] ) || {code:"", name:""};	
		
		fieldName = "child_citizenship_2_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [relative.citizenship_2_country_code] ) || {code:"", name:""};	
	}
	
	function setOtherRelative(idx){		
		var relative, dteString, dte, tmp, fieldName;
		
		relative = vm.data.relatives[idx];
		vm.relatives[relative.id] = {};		
		
		//Dates	
			
		dteString = relative.birth_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].birth_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};			
		
		dteString = relative.dependent_since;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.relatives[relative.id].dependent_since = {};
		tmp.date = dte;
		tmp.popup = {opened: false};		
		
		//Countries
		
		fieldName = "relative_citizenship_1_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [relative.citizenship_1_country_code] ) || {code:"", name:""};	
		
		fieldName = "relative_citizenship_2_country_" + relative.id;
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [relative.citizenship_2_country_code] ) || {code:"", name:""};	
	}
	
	function setScholarship(childId, idx){	
		var scholarship, fieldName;
		
		scholarship = vm.data.scholarships[childId][idx];	
	}
	
	function setCertificate(childId, idx){
		var certificate, dteString, dte, tmp, fieldName;
		
		certificate = vm.data.certificates[childId][idx];			
		vm.certificates[certificate.id] = {};		
		
		dteString = certificate.reception_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.certificates[certificate.id].reception_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		tmp.field = "reception_date_{{ certificate.id }}";		
		
		dteString = certificate.validity_from;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.certificates[certificate.id].validity_from = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		tmp.field = "validity_from_date_{{ certificate.id }}";	
		
		dteString = certificate.validity_until;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.certificates[certificate.id].validity_until = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		tmp.field = "validity_until_date_{{ certificate.id }}";
	}	
	
	function setSelectedOptions() {	
		var certificate, scholarship; 		
		
		//for debugging
		relatives = vm.relatives;
		certificates = vm.certificates;
		scholarships = vm.scholarships;
		data = vm.data;
		
		for(var idx = 0; idx < vm.data.spouses.length; idx++){	
			setSpouse(idx);
		}			
		
		for(var idx = 0; idx < vm.data.children.length; idx++){			
			setChild(idx);						
		}	
		
		for(var idx = 0; idx < vm.data.relatives.length; idx++){			
			setOtherRelative(idx);
		}	
		
		Object.keys(vm.data.certificates).forEach(function(childId) {
			var childCertificatesArray = vm.data.certificates[childId];			
			for(var idx = 0; idx < childCertificatesArray.length; idx++){	
				setCertificate( childId, idx );
			}
		});	
		
		Object.keys(vm.data.scholarships).forEach(function(childId) {	
			var childScholarshipsArray = vm.data.scholarships[childId];			
			for(var idx = 0; idx < childScholarshipsArray.length; idx++){
				setScholarship( childId, idx );
			}
		});	
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// File download functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function openScholarshipFile(scholarshipId, hash){			
		var path = "index.cfm?action=nsm:fd.openScholarshipFile&staff_member_id=" + staffMemberId + "&scholarship_id=" + scholarshipId + "&hash=" + hash;
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}
	
	function openCertificateFile(certificateId, hash){			
		var path = "index.cfm?action=nsm:fd.openCertificateFile&staff_member_id=" + staffMemberId + "&certificate_id=" + certificateId + "&hash=" + hash;
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}		
		
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
//////////////////////////////////
/// Display	
//////////////////////////////////		

	function expandAll(evt){			
		//var target = evt.target;		
		//var form = $(target).closest("form");
		var form = $(".family-data-form");
		$(form).find( ".collapse-link" ).removeClass('collapsed');
		$(form).find( ".collapse" ).collapse('show');		
	}
	
	function collapseAll(evt){					
		//var target = evt.target;		
		//var form = $(target).closest("form");
		var form = $(".family-data-form");
		$(form).find( ".collapse-link" ).addClass('collapsed');
		$(form).find( ".panel-collapse.in" ).collapse('hide');
	}
	
	function getHeadingClasses(objType, id){				
		var relative, obj, classes;
				
		if(objType == "relative") 
			obj = getRelative(id);	
			
		if(objType == "scholarship") 
			obj = getScholarship(id);	
			
		if(objType == "certificate") 
			obj = getCertificate(id);
			
		//if(objType == "allowances") obj = getCertificate(id);			
			
		if( obj && obj.status){						
			//classes = obj.status;					
			classes = "new";
		}
		
		return classes;		
	}	
	
	function hasAlt(type, id, field){	
		var fieldName, collName, hasAlt;	
		
		if(id != 0) {			
			fieldName = type.concat("_").concat(field).concat("_").concat(id);	
			collName = getCollName(type);
			hasAlt = vm.data.alt && vm.data.alt[collName] && vm.data.alt[collName][id] && vm.data.alt[collName][id].hasOwnProperty(field);	
		}
		else {					
			fieldName = field;
			collName = getCollName(type);
			hasAlt = vm.data.alt && vm.data.alt[collName] && vm.data.alt[collName].hasOwnProperty(field);	
		}			
		
		return hasAlt;
	}	
	
	function getAlt(type, id, field){		
		var fieldName, collName, altVal;		
		
		if(id != 0) {
			//fieldName = field.concat("_").concat(id);	
			collName = getCollName(type);
			altVal = vm.data.alt[collName][id][field] || "[...]";
		}
		else {		
			//fieldName = field;
			collName = getCollName(type);
			altVal = vm.data.alt[collName][field] || "[...]";		
		}				
		
		return altVal;
	}	
	
	function getCtry(countryCode){	
		//console.log("getCtry", countryCode);
		var country = vm.countries["LIB"].find( findByCode, [countryCode] );
		return ( country ? country.name : countryCode );	
	}	
	
	function getCitiz(countryCode){	
		//console.log("getCitiz", countryCode);
		var citizenship = vm.citizenships["LIB"].find( findByCode, [countryCode] );
		return ( citizenship ? citizenship.name : countryCode );	
	}				
	
	$scope.$on('$includeContentLoaded', function (evt, url) {
		sync();
	});	
	
	function sync(){
		waitForEl("#nsmEditFdForm", function() {
			//Panels expanded in View screen will be expanded when accessing the Edit screen
			var expandedPanels = $("#nsmViewFdForm div.panel-collapse.collapse.in");
			
			expandedPanels.each( function(index){	
				panelClass = $( this ).attr("class").split(" ")[1]; //eg, family-details-panel			
				panel = $("#nsmEditFdForm div." + panelClass);				
				panel.collapse('show');	
				lnk = $("#nsmEditFdForm ." + panelClass + "collapse-link");			
				lnk.removeClass('collapsed');						
			});	
		});		
	}	
	
//////////////////////////////////
/// Set Mode	
//////////////////////////////////	

	function setTabMode(tabMode){			
		vm.fdTabMode = tabMode;  
	}	
	
	function viewFD(){						
		if(vm.tabModes.view === false)
			resetTemplate("view", true);
		if(vm.tabModes.view === true)
			setTabMode("view", true);
	}		
	
	function editFD(){				
		if(vm.tabModes.edit === false)
			resetTemplate("edit", true);
		if(vm.tabModes.edit === true)
			setTabMode("edit", true);
	}	
	
//////////////////////////////////
/// Manage Relatives	
//////////////////////////////////
	
	function getRelative(relativeId){		
		var rel;
		var keys = ["spouses", "children", "relatives"];
		
		keys.forEach(function(key) {	
			vm.data[key].forEach(function(relative){ 				
				if(relative.id == relativeId)
					rel = relative;				
			});
		});	
		
		return rel;		
	}
	
	function getRelativeType(relativeId){		
		var relType;
		var keys = ["spouses", "children", "relatives"];
		
		keys.forEach(function(key) {	
			vm.data[key].forEach(function(relative){ 				
				if(relative.id == relativeId)
					relType = key;				
			});
		});	
		
		return relType;		
	}		
	
	function removeRelative(relativeId, familyLink){	
		var relative, lname, fname, idx, relType;
		
		relative = getRelative(relativeId);		
		
		lname = relative.lname.toUpperCase();
		fname = relative.fname;		
		
		if ( confirm("Are you sure you want to DELETE\n\n" + fname + " " + lname + "\n\nfrom the list of relatives?") ){		
	
			if(relative.status == "added") {
				//Record does not exist, delete immediately. Cannot be td.
				relType = getRelativeType(relativeId);
				idx = vm.data[relType].findIndex( arrayFindById, {id:relativeId} );
				vm.data[relType].splice(idx, 1);
				deleteFields(familyLink, relativeId);
			}
			else {
				//Record exists, flag for later removal.
				relative.deleted = "Y"; 				
			}	
		}
	}	
	
	function restoreRelative(relativeId, familyLink){	
		var relative, lname, fname;	
				
		relative = getRelative(relativeId);
		lname = relative.lname.toUpperCase();
		fname = relative.fname;	
		
		if ( confirm("Are you sure you want to restore\n\n" + fname + " " + lname + "?") ){	
			relative.deleted =  "R"; 
			relative.status = "";
		}	
	}		
	
	function addRelative(familyLink, event){	
		event.preventDefault();		
		switch(familyLink) {
			case "CHIL": addChild(); break;
			case "WIFE": addSpouse("F"); break;
			case "HUSB": addSpouse("M"); break;			
			default: addOtherRelative(familyLink);
		}				
	}		
	
	function addSpouse(gender) {
		nsmFdService.addSpouse(staffMemberId, gender).then(function(resp){			
			var spouse = Object.assign({}, resp.data);
			spouse.status = "added";											
			vm.data.spouses.unshift(spouse);
			setSpouse(0);	
			
			waitForEl(".spouse-" + spouse.id + "-main-panel", function( jqEl ){
				jqEl.collapse('show');
			});				
			
			waitForEl(".spouse-" + spouse.id + "-subpanel-1", function( jqEl ){
				jqEl.collapse('show');
			});		
				
		})
	}		
	
	function addChild() {
		nsmFdService.addChild(staffMemberId).then(function(resp){	
			//var id = newIdService.getId();	
			var child = Object.assign({}, resp.data);
			child.status = "added";			
			vm.data.children.unshift(child);
			setChild(0);
			
			waitForEl(".child-" + child.id + "-main-panel", function( jqEl ){
				jqEl.collapse('show');
			});				
			
			waitForEl(".child-" + child.id + "-subpanel-1", function( jqEl ){
				jqEl.collapse('show');
			});				
	
/*			waitForEl("#edit_child_panel_" + child.id, function( jqEl ){
				jqEl.collapse('show');
			});
			waitForEl("#edit_child_subpanel_1_" + child.id, function( jqEl ){
				jqEl.collapse('show');
			});	*/		
		})
	}
	
	function addOtherRelative(familyLink) {
		nsmFdService.addOtherRelative(staffMemberId, familyLink).then(function(resp){				
			var relative = Object.assign({}, resp.data);
			relative.status = "added";		
			vm.data.relatives.unshift(relative);
			setOtherRelative(0);
	
/*			waitForEl("#edit_relative_panel_" + relative.id, function( jqEl ){
				jqEl.collapse('show');
			});
			waitForEl("#edit_relative_subpanel_1_" + relative.id, function( jqEl ){
				jqEl.collapse('show');
			});	*/
			
			waitForEl(".relative-" + relative.id + "-panel", function( jqEl ){
				jqEl.collapse('show');
			});				
			
			waitForEl(".relative-" + relative.id + "-subpanel-1", function( jqEl ){
				jqEl.collapse('show');
			});						
		})
	}	
	
//////////////////////////////////
/// Manage Scholarships	
//////////////////////////////////	

	function canAddCertificate(childId){	
		var certCount = 0;
		
		if( vm.data.certificates && vm.data.certificates[childId] )
			 certCount = vm.data.certificates[childId].length;
			
		return certCount <= 6 
		&& vm.relatives[childId].age >= 18 
		&& vm.relatives[childId].age <= 24; 
	}
	
	function getScholarship(scholarshipId){		
		var schol;	
			
		Object.keys(vm.data["scholarships"]).forEach(function(childId){ 		
			vm.data.scholarships[childId].forEach(function(scholarship){
				if(scholarship.id == scholarshipId)
					schol = scholarship;	
			})				
		});
		
		return schol;		
	}	
	
	function addScholarship(childId) {
		nsmFdService.addScholarship(staffMemberId).then(function(resp){	
			//var id = newIdService.getId();		
			var scholarship = Object.assign({}, resp.data);
			scholarship.status = "added";
			//scholarship.id = id;			
			if(!vm.data.scholarships)
				vm.data.scholarships = {};
			if(!vm.data.scholarships[childId])
				vm.data.scholarships[childId] = [];	
			vm.data.scholarships[childId].unshift(scholarship);
			setScholarship(childId, 0);
			waitForEl("#edit_child_subpanel_3_" + childId, function( jqEl ){
				jqEl.collapse('show');
			});	
			waitForEl("#edit_scholarship_panel_" + scholarship.id, function( jqEl ){
				jqEl.collapse('show');
			});	
		})
	}
	
	function removeScholarship(childId, scholarshipId) {	
		var scholarship, idx;
		
		scholarship = getScholarship(scholarshipId);	
		
		if ( confirm("Are you sure you want to DELETE this Scholarship?") ){		
	
			if(scholarship.status == "added") {
				//Record does not exist, delete immediately. 			
				idx = vm.data.scholarships[childId].findIndex( arrayFindById, {id:scholarshipId} );
				vm.data.scholarships[childId].splice(idx, 1);
			}
			else {
				//Record exists, flag for later removal. 
				scholarship.deleted = "Y"; 					
			}	
		}
	}	
	
	function restoreScholarship(childID, scholarshipId){	
		var certificate;	
				
		scholarship = getScholarship(scholarshipId);
		
		if ( confirm("Are you sure you want to RESTORE this Scholarship?") ){	
			scholarship.deleted = "R"; 
			scholarship.status = "";
		}	
	}

//////////////////////////////////
/// Manage Certificates	
//////////////////////////////////	
	
	function getCertificate(certificateId){		
		var cert;	
			
		Object.keys(vm.data["certificates"]).forEach(function(childId){ 		
			vm.data.certificates[childId].forEach(function(certificate){
				if(certificate.id == certificateId)
					cert = certificate;	
			})				
		});
		
		return cert;		
	}	
	
	function addCertificate(childId) {
		nsmFdService.addCertificate(staffMemberId).then(function(resp){	
			//var id = newIdService.getId();		
			var certificate = Object.assign({}, resp.data);
			certificate.status = "added";
			//certificate.id = id;
			if(!vm.data.certificates)
				vm.data.certificates = {};
			if(!vm.data.certificates[childId])
				vm.data.certificates[childId] = [];				
			vm.data.certificates[childId].unshift(certificate);
			setCertificate(childId, 0);
			waitForEl("#edit_child_subpanel_4_" + childId, function( jqEl ){
				jqEl.collapse('show');
			});				
			waitForEl("#edit_certificate_panel_" + certificate.id, function( jqEl ){
				jqEl.collapse('show');
			});	
		})
	}
	
	function removeCertificate(childId, certificateId) {	
		var certificate, idx;
		
		certificate = getCertificate(certificateId);	
		
		if ( confirm("Are you sure you want to DELETE this Certificate?") ){		
	
			if(certificate.status == "added") {				
				//Record does not exist, delete immediately. 			
				idx = vm.data.certificates[childId].findIndex( arrayFindById, {id:certificateId} );				
				vm.data.certificates[childId].splice(idx, 1);
			}
			else {
				//Record exists, flag for later removal. 
				certificate.deleted = "Y"; 				
			}	
		}
	}		
	
	function restoreCertificate(childID, certificateId){	
		var certificate;	
				
		certificate = getCertificate(certificateId);
		
		if ( confirm("Are you sure you want to RESTORE this Certificate?") ){	
			certificate.deleted =  "R"; 
			certificate.status = "";
		}	
	}	
		
	
//////////////////////////////////
/// Save	
//////////////////////////////////		
	
	function saveFD(){	
		var myForm = document.getElementById('nsmEditFdForm');	
		var formData = new FormData(myForm);	
		
		Object.keys(vm.fields).forEach(function(key) {				
			formData.append(key, vm.fields[key]); //eg, vm.data[""birth_country_code"]
		});			
		
		Object.keys(vm.ucountries).forEach(function(key) {				
			var fieldName, arr = key.split("_");
			arr.splice(-1, 0, "code");
			fieldName = arr.join("_");					
			formData.append(fieldName, vm.ucountries[key].country.code); 
		});			
		
		//This should be moved to a service
		$http({
			method: 'POST',
			url: 'index.cfm?action=nsm:fd.saveFD',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {
			
			//var anyChanges = response.data.data.changed;			
			var anyChanges = true;						
			
			if(anyChanges == true)				
				Notification.info({message: 'Changes saved', positionY: 'top', positionX: 'right'});
			else				
				Notification.info({message: 'No changes to save', positionY: 'top', positionX: 'right'});
				
			//removeTemplate("edit");
			//resetTemplate("edit", false);
			//initCtrl("view");				
			//initCtrl("view");	
			$rootScope.$broadcast("tabSaved", "fd");
		}, function errorCallback(response) {		
			Notification.warning({message: 'Form NOT correctly submitted', positionY: 'top', positionX: 'right'});
		});			
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
	
//////////////////////////////////
/// Misc	
//////////////////////////////////		
	
	function getRelativeStatus(relativeId){
		return;
	}
	
	function reload(){
		initCtrl();
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
// Validation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function isTouched(id, field){	
		var elemName;
		
		if(id)
			elemName = field + "_" + id;
		else
			elemName = field;						
		
		if( !vm.nsmEditFdForm )
			return;			
			
		if(	!vm.nsmEditFdForm[elemName] ) 
			return;
			
		var elem = vm.nsmEditFdForm[elemName];				
		return elem.$touched;			
	}

	function isTouchedWithErrors(id, field){	
		var elemName;	
		
		if(id)
			elemName = field + "_" + id;
		else
			elemName = field;
		
		if( !vm.nsmEditFdForm )
			return;			
			
		if(	!vm.nsmEditFdForm[elemName] ) 
			return;
			
		var elem = vm.nsmEditFdForm[elemName];	
					
		return elem.$touched && elem.$error;			
	}
	
	function hasErrors(id, field){	//for radio 	
		var elemName = field + "_" + id;	
		
		if(	!vm.nsmEditFdForm ) 
			return
		
		if(	!vm.nsmEditFdForm[elemName] ) 
			return;
			
		var elem = vm.nsmEditFdForm[elemName];		
				
		return elem.$error;			
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
			vm.str = vm.strings["LIB"];
			xstr = vm.str;
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
		console.log("Language change event in mainFD.js", args);
		if(args.lang != vm.displayLanguage)
			changeLanguage(args.lang);
	});		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Supporting functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function arrayFindById(element){
		if(element.id == this.id)
			return true;
		return false;			
	}		

	function findByCode(obj) {				
		if (obj.code === this[0]) {			 
			return obj;
		}
	}
	
	function waitForEl(selector, callback) {
		if ($(selector).length) {
			callback( $(selector) );
		} else {
			setTimeout(function() {
				waitForEl(selector, callback);
			}, 100);
		}
	};	
	
	function setAge(childId){				
		if( $.type(vm.relatives[childId].birth_date.date) !== "date" )
			return;	
		vm.relatives[childId].age = getAge(vm.relatives[childId].birth_date.date);		
	}		
	
	function getAge(birthDate) {
		if( $.type(birthDate) !== "date" )
			return;			
		//Date object augmented in plugins.js				
		return birthDate.getAge();
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	vm.reload = reload;
	vm.changeLanguage = changeLanguage;
	
	vm.viewFD = viewFD;	
	vm.editFD = editFD;		
	vm.saveFD = saveFD;		
	
	vm.expandAll = expandAll;	
	vm.collapseAll = collapseAll;

	vm.isTouched = isTouched;
	vm.isTouchedWithErrors = isTouchedWithErrors;
	vm.hasErrors = hasErrors;
	
	vm.popup = popup;	
	vm.openPopup = openPopup;
	vm.setSelectedOption = setSelectedOption;	
	vm.getCtry = getCtry;
	vm.getCitiz = getCitiz;		
	
	vm.openCertificateFile = openCertificateFile;
	vm.openScholarshipFile = openScholarshipFile;	
	
	vm.addRelative = addRelative;	
	vm.removeRelative = removeRelative;	
	vm.restoreRelative = restoreRelative;	
	
	vm.addScholarship = addScholarship;
	vm.removeScholarship = removeScholarship;
	vm.restoreScholarship = restoreScholarship;
	
	vm.addCertificate = addCertificate;	
	vm.removeCertificate = removeCertificate;	
	vm.restoreCertificate = restoreCertificate;
	
	vm.setAge = setAge;
	
	vm.getHeadingClasses = getHeadingClasses;
	
	vm.hasAlt = hasAlt;
	vm.getAlt = getAlt;	
	vm.canAddCertificate = canAddCertificate;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();		
	
}]);	