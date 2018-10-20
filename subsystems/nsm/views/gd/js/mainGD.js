app.cp.register('nsmMainGdController', ['$rootScope', '$scope', '$http', 'nsmService', 'Notification', 'dataService', 'stringsService', 
'countriesService', 'citizenshipsService', 'settingsService', '$q', 'nsmFdService', 'nsmGdService', '$templateCache', 'uibDateParser', 
function ($rootScope, $scope, $http, nsmService, Notification, dataService, stringsService, 
countriesService, citizenshipsService, settingsService, $q, nsmFdService, nsmGdService, $templateCache, uibDateParser) {	

	console.log("nsmMainGdController loaded", $scope.$id); 	
	
	var settings;
	
	var staffMemberId;		
	var staffMemberDetails;		
	var gdTabMode;
	
	var currentViewGdUrl = "";
	var currentEditGdUrl = "";		
	
	gdc = this;

	var vm = this; 	
	vm.gdTabMode = "";
	vm.tabModes = {};
	vm.tabModes.view = false; 
	vm.tabModes.edit = false; 
	
	vm.displayLanguage;
	vm.staff_member_id;
	vm.strings = {};
	vm.countries = {};
	vm.citizenships = {};
	vm.medicals = {}; //for datepickers
	
	vm.ucountries = {};	
	
	vm.maxFieldLength = 100; 
	vm.currencyCodeLength = 3;
	vm.annualIncomeLength = 10;
	vm.postalCodeLength = 30;
	
	vm.canEdit = true;
	vm.canStartWorkFlow = true;	
	
	vm.languages = [
	    { code: "ENG", name: "English" },
    	{ code: "FRA", name: "French" },
    	{ code: "SPA", name: "Spanish" },		
    	{ code: "RUS", name: "Russian" },				
    	{ code: "ARA", name: "Arabic" }	
	];
	
	vm.language_1 = vm.languages[0];
	vm.language_2 = vm.languages[1];
	
	vm.documents = {};
	documents = vm.documents;
	
	meds = vm.medicals;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
		
	function initCtrl(tabMode) {	
	
		console.log("nsmMainGdController initCtrl", tabMode);
	
		staffMemberId = dataService.get("nsm", "staffMemberId");
		staffMemberDetails = dataService.get("nsm", "staffMemberDetails");
		gdTabMode = dataService.get("nsm", "gdTabMode");
		
		vm.staff_member_id = staffMemberId;		
		vm.nsm_details = staffMemberDetails;
		
		var defaultTabMode = "view"; 	
		var selectedTabMode;
		
		vm.tabModes.view = false;
		vm.tabModes.edit = false;
		
		settingsService.get("nsmMainGdController").then(function(resp){			
			settings = resp.data;			
			vm.displayLanguage = settings.displayLanguage;			
			
			var p1 = setStrings(vm.displayLanguage);
			var p2 = setCitizenships(vm.displayLanguage);
			var p3 = setCountries(vm.displayLanguage);				
			var p4 = setGD(staffMemberId);					
			
			$q.all([p1, p2, p3, p4]).then(function(values){ 
				setSelectedOptions();				
				
				if(!!tabMode)
					selectedTabMode = tabMode;
				else if(settings.gd && settings.gd.initialTabMode)		
					selectedTabMode = settings.gd.initialTabMode;		
				else if(gdTabMode)		
					selectedTabMode = gdTabMode;				
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
		vm.gdTabMode = tabMode;  
	}	

	function resetTemplate(tabMode, switchToTabMode) {		
		if(tabMode == "view") {		
			var updateTime = Date.now();
			var newViewGdUrl = 'index.cfm?action=nsm:gd.viewGD&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentViewGdUrl);				
			currentViewGdUrl = newViewGdUrl;		
			vm.viewGdUrl = currentViewGdUrl;
			vm.tabModes.view = true;
		}
		
		if(tabMode == "edit") {			
			var updateTime = Date.now();		
			var newEditGdUrl = 'index.cfm?action=nsm:gd.editGD&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentEditGdUrl);			
			currentEditGdUrl = newEditGdUrl;		
			vm.editGdUrl = currentEditGdUrl;	
			vm.tabModes.edit = true;			
		}	
		
		if(switchToTabMode === true)
			setTabMode(tabMode);		
	}

	function setGD(staffMemberId){		
		return nsmGdService.getGD(staffMemberId).then(function(resp){			
			vm.data = resp.data; 			
			
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
	
	function setAge(){		
		if( $.type(vm.birthDate.date) !== "date" )
			return;			
		vm.age = getAge(vm.birthDate.date);		
	}
	
	function setSelectedOptions() {				
		//runs initially and when display language changes	
				
		//Miscellaneous
		var birthDateString = vm.data.date_of_birth;
		var birthDate = uibDateParser.parse(birthDateString, "dd/MM/yyyy");
		vm.birthDate = {};		
		vm.birthDate.date = birthDate;
		vm.birthDate.popup = {opened: false};
		setAge();
		//vm.age = getAge(vm.birthDate.date);
		
		var deathDateString = vm.data.date_of_death;
		var deathDate = uibDateParser.parse(deathDateString, "dd/MM/yyyy");
		vm.deathDate = {};
		vm.deathDate.date = deathDate;	
		vm.deathDate.popup = {opened: false};
		
		var msEffectiveFromString = vm.data.ms_effective_from;
		var msEffectiveFromDate = uibDateParser.parse(msEffectiveFromString, "dd/MM/yyyy");
		vm.msEffectiveFrom = {};
		vm.msEffectiveFrom.date = msEffectiveFromDate;	
		vm.msEffectiveFrom.popup = {opened: false};		
		
		var baEffectiveFromString = vm.data.business_address_effective_from;
		var baEffectiveFromDate = uibDateParser.parse(baEffectiveFromString, "dd/MM/yyyy");
		vm.baEffectiveFrom = {};
		vm.baEffectiveFrom.date = baEffectiveFromDate;	
		vm.baEffectiveFrom.popup = {opened: false};					
		
		/* Documents*/
			
		vm.documents = {};
			
		//Driving Licence				
		var docDlValidFromString = vm.data.doc_dl_valid_from;
		var docDlValidFromDate = uibDateParser.parse(docDlValidFromString, "dd/MM/yyyy");	
		vm.doc_dl_valid_from = {};
		vm.doc_dl_valid_from.date = docDlValidFromDate;
		vm.doc_dl_valid_from.field = "doc_dl_valid_from";
		vm.doc_dl_valid_from.popup = {opened: false};
		
		var docDlValidUntilString = vm.data.doc_dl_valid_until;
		var docDlValidUntilDate = uibDateParser.parse(docDlValidUntilString, "dd/MM/yyyy");	
		vm.doc_dl_valid_until = {};
		vm.doc_dl_valid_until.date = docDlValidUntilDate;
		vm.doc_dl_valid_until.field = "doc_dl_valid_until";
		vm.doc_dl_valid_until.popup = {opened: false};
		
		vm.documents["doc_dl_file"] = {};
		vm.documents["doc_dl_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_dl_filename_deleted"] && vm.data.alt["doc_dl_filename_deleted"] == "Y")
			vm.documents["doc_dl_file"].deleted = "Y";
		else			
			vm.documents["doc_dl_file"].deleted = "N";	
			
		vm.documents["alt_doc_dl_file"] = {};			
		vm.documents["alt_doc_dl_file"].deleted = "N";			
					
		//Passport
		var docPassValidFromString = vm.data.doc_pass_valid_from;
		var docPassValidFromDate = uibDateParser.parse(docPassValidFromString, "dd/MM/yyyy");	
		vm.doc_pass_valid_from = {};
		vm.doc_pass_valid_from.date = docPassValidFromDate;
		vm.doc_pass_valid_from.field = "doc_pass_valid_from";
		vm.doc_pass_valid_from.popup = {opened: false};			
		
		var docPassValidUntilString = vm.data.doc_pass_valid_until;
		var docPassValidUntilDate = uibDateParser.parse(docPassValidUntilString, "dd/MM/yyyy");
		vm.doc_pass_valid_until = {};
		vm.doc_pass_valid_until.date = docPassValidUntilDate;
		vm.doc_pass_valid_until.field = "doc_pass_valid_until";
		vm.doc_pass_valid_until.popup = {opened: false};
		
		vm.documents["doc_pass_file"] = {};
		vm.documents["doc_pass_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_pass_filename_deleted"] && vm.data.alt["doc_pass_filename_deleted"] == "Y")
			vm.documents["doc_pass_file"].deleted = "Y";
		else			
			vm.documents["doc_pass_file"].deleted = "N";			
					
		//Passport 2
		var docPass2ValidFromString = vm.data.doc_pass2_valid_from;
		var docPass2ValidFromDate = uibDateParser.parse(docPass2ValidFromString, "dd/MM/yyyy");	
		vm.doc_pass2_valid_from = {};
		vm.doc_pass2_valid_from.date = docPass2ValidFromDate;
		vm.doc_pass2_valid_from.field = "doc_pass2_valid_from";
		vm.doc_pass2_valid_from.popup = {opened: false};	
		
		vm.documents["doc_pass2_file"] = {};
		vm.documents["doc_pass2_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_pass2_filename_deleted"] && vm.data.alt["doc_pass2_filename_deleted"] == "Y")
			vm.documents["doc_pass2_file"].deleted = "Y";
		else			
			vm.documents["doc_pass2_file"].deleted = "N";				
		
		var docPass2ValidUntilString = vm.data.doc_pass2_valid_until;
		var docPass2ValidUntilDate = uibDateParser.parse(docPass2ValidUntilString, "dd/MM/yyyy");
		vm.doc_pass2_valid_until = {};
		vm.doc_pass2_valid_until.date = docPass2ValidUntilDate;
		vm.doc_pass2_valid_until.field = "doc_pass2_valid_until";
		vm.doc_pass2_valid_until.popup = {opened: false};
				
		//Work Permit
		var docWlValidFromString = vm.data.doc_wl_valid_from;
		var docWlValidFromDate = uibDateParser.parse(docWlValidFromString, "dd/MM/yyyy");
		vm.doc_wl_valid_from = {};
		vm.doc_wl_valid_from.date = docWlValidFromDate;
		vm.doc_wl_valid_from.field = "doc_wl_valid_from";
		vm.doc_wl_valid_from.popup = {opened: false};
		
		var docWlValidUntilString = vm.data.doc_wl_valid_until;
		var docWlValidUntilDate = uibDateParser.parse(docWlValidUntilString, "dd/MM/yyyy");
		vm.doc_wl_valid_until = {};
		vm.doc_wl_valid_until.date = docWlValidUntilDate;
		vm.doc_wl_valid_until.field = "doc_wl_valid_until";
		vm.doc_wl_valid_until.popup = {opened: false};	
		
		vm.documents["doc_wl_file"] = {};
		vm.documents["doc_wl_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_wl_filename_deleted"] && vm.data.alt["doc_wl_filename_deleted"] == "Y")
			vm.documents["doc_wl_file"].deleted = "Y";
		else			
			vm.documents["doc_wl_file"].deleted = "N";			
		
		//Residence Permit
		var docRPValidFromString = vm.data.doc_rp_valid_from;
		var docRPValidFromDate = uibDateParser.parse(docRPValidFromString, "dd/MM/yyyy");
		vm.doc_rp_valid_from = {};
		vm.doc_rp_valid_from.date = docRPValidFromDate;
		vm.doc_rp_valid_from.field = "doc_rp_valid_from";
		vm.doc_rp_valid_from.popup = {opened: false};		
		
		var docRPValidUntilString = vm.data.doc_rp_valid_until;
		var docRPValidUntilDate = uibDateParser.parse(docRPValidUntilString, "dd/MM/yyyy");
		vm.doc_rp_valid_until = {};
		vm.doc_rp_valid_until.date = docRPValidUntilDate;
		vm.doc_rp_valid_until.field = "doc_rp_valid_until";
		vm.doc_rp_valid_until.popup = {opened: false};
		
		vm.documents["doc_rp_file"] = {};
		vm.documents["doc_rp_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_rp_filename_deleted"] && vm.data.alt["doc_rp_filename_deleted"] == "Y")
			vm.documents["doc_rp_file"].deleted = "Y";
		else			
			vm.documents["doc_rp_file"].deleted = "N";		
		
		//Echo Badge		
		var docEbdgValidFromString = vm.data.doc_ebdg_valid_from;
		var docEbdgValidFromDate = uibDateParser.parse(docEbdgValidFromString, "dd/MM/yyyy");
		vm.doc_ebdg_valid_from = {};
		vm.doc_ebdg_valid_from.date = docEbdgValidFromDate;
		vm.doc_ebdg_valid_from.field = "doc_ebdg_valid_from";
		vm.doc_ebdg_valid_from.popup = {opened: false};	
		
		var docEbdgValidUntilString = vm.data.doc_ebdg_valid_until;
		var docEbdgValidUntilDate = uibDateParser.parse(docEbdgValidUntilString, "dd/MM/yyyy");
		vm.doc_ebdg_valid_until = {};
		vm.doc_ebdg_valid_until.date = docEbdgValidUntilDate;
		vm.doc_ebdg_valid_until.field = "doc_ebdg_valid_until";
		vm.doc_ebdg_valid_until.popup = {opened: false};	

		vm.documents["doc_ebdg_file"] = {};
		vm.documents["doc_ebdg_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_ebdg_filename_deleted"] && vm.data.alt["doc_ebdg_filename_deleted"] == "Y")
			vm.documents["doc_ebdg_file"].deleted = "Y";
		else			
			vm.documents["doc_ebdg_file"].deleted = "N";				
		
		//DUE Badge
		var docDbdgValidFromString = vm.data.doc_dbdg_valid_from;
		var docDbdgValidFromDate = uibDateParser.parse(docDbdgValidFromString, "dd/MM/yyyy");
		vm.doc_dbdg_valid_from = {};
		vm.doc_dbdg_valid_from.date = docDbdgValidFromDate;
		vm.doc_dbdg_valid_from.field = "doc_dbdg_valid_from";
		vm.doc_dbdg_valid_from.popup = {opened: false};		
		
		var docDbdgValidUntilString = vm.data.doc_dbdg_valid_until;
		var docDbdgValidUntilDate = uibDateParser.parse(docDbdgValidUntilString, "dd/MM/yyyy");
		vm.doc_dbdg_valid_until = {};
		vm.doc_dbdg_valid_until.date = docDbdgValidUntilDate;
		vm.doc_dbdg_valid_until.field = "doc_dbdg_valid_until";
		vm.doc_dbdg_valid_until.popup = {opened: false};

		vm.documents["doc_dbdg_file"] = {};
		vm.documents["doc_dbdg_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_dbdg_filename_deleted"] && vm.data.alt["doc_dbdg_filename_deleted"] == "Y")
			vm.documents["doc_dbdg_file"].deleted = "Y";
		else			
			vm.documents["doc_dbdg_file"].deleted = "N";			
		
		//Laissez-Passer
		var docLapValidFromString = vm.data.doc_lap_valid_from;
		var docLapValidFromDate = uibDateParser.parse(docLapValidFromString, "dd/MM/yyyy");
		vm.doc_lap_valid_from = {};
		vm.doc_lap_valid_from.date = docLapValidFromDate;
		vm.doc_lap_valid_from.field = "doc_lap_valid_from";
		vm.doc_lap_valid_from.popup = {opened: false};				
		
		var docLapValidUntilString = vm.data.doc_lap_valid_until;
		var docLapValidUntilDate = uibDateParser.parse(docLapValidUntilString, "dd/MM/yyyy");
		vm.doc_lap_valid_until = {};
		vm.doc_lap_valid_until.date = docLapValidUntilDate;
		vm.doc_lap_valid_until.field = "doc_lap_valid_until";
		vm.doc_lap_valid_until.popup = {opened: false};	

		vm.documents["doc_lap_file"] = {};
		vm.documents["doc_lap_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_lap_filename_deleted"] && vm.data.alt["doc_lap_filename_deleted"] == "Y")
			vm.documents["doc_lap_file"].deleted = "Y";
		else			
			vm.documents["doc_lap_file"].deleted = "N";	
		
		//"Juridical Report"
		var docJurepValidFromString = vm.data.doc_jurep_valid_from;
		var docJurepValidFromDate = uibDateParser.parse(docJurepValidFromString, "dd/MM/yyyy");
		vm.doc_jurep_valid_from = {};
		vm.doc_jurep_valid_from.date = docJurepValidFromDate;
		vm.doc_jurep_valid_from.field = "doc_jurep_valid_from";
		vm.doc_jurep_valid_from.popup = {opened: false};				
		
		var docJurepValidUntilString = vm.data.doc_jurep_valid_until;
		var docJurepValidUntilDate = uibDateParser.parse(docJurepValidUntilString, "dd/MM/yyyy");
		vm.doc_jurep_valid_until = {};
		vm.doc_jurep_valid_until.date = docJurepValidUntilDate;
		vm.doc_jurep_valid_until.field = "doc_jurep_valid_until";
		vm.doc_jurep_valid_until.popup = {opened: false};	

		vm.documents["doc_jurep_file"] = {};
		vm.documents["doc_jurep_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] && vm.data.alt["doc_jurep_filename_deleted"] && vm.data.alt["doc_jurep_filename_deleted"] == "Y")
			vm.documents["doc_jurep_file"].deleted = "Y";
		else			
			vm.documents["doc_jurep_file"].deleted = "N";	
			
		vm.documents["doc_cv_file"] = {};
		vm.documents["doc_cv_file"].expDate = docDlValidUntilString;
		if(vm.data["alt"] &&  vm.data.alt["doc_cv_filename_deleted"] && vm.data.alt["doc_cv_filename_deleted"] == "Y")
			vm.documents["doc_cv_file"].deleted = "Y";
		else			
			vm.documents["doc_cv_file"].deleted = "N";		
			
		console.log("vm.documents", vm.documents);
					
	
		//vm.ac = {};	 // .ac for autocomplete
		
		//Countries
		
/*		vm.ac.birth_country = {};		
		vm.ac.birth_country.country = vm.countries["LIB"].find( findByCode, [vm.data.birth_country_code] );	
		vm.ac.birth_country.fld = "birth_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'birth_country_name', vm.ac.birth_country.country);*/			
		
		fieldName = "birth_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.birth_country_code] ) || {code:"", name:""};				
		
/*		vm.ac.citizenship_1 = {};
		vm.ac.citizenship_1.country = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_1_country_code] ) || {code:"", name:""};	
		vm.ac.citizenship_1.fld = "citizenship_1_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'citizenship_1_name', vm.ac.citizenship_1.country)*/;
		
		fieldName = "citizenship_1_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_1_country_code] ) || {code:"", name:""};				
		
/*		vm.ac.citizenship_2 = {};
		vm.ac.citizenship_2.country = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_2_country_code] ) || {code:"", name:""};	
		vm.ac.citizenship_2.fld = "citizenship_2_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'citizenship_2_name', vm.ac.citizenship_2.country);*/
		
		fieldName = "citizenship_2_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_2_country_code] ) || {code:"", name:""};				
		
/*		vm.ac.citizenship_3 = {};
		vm.ac.citizenship_3.country = vm.citizenships["LIB"].find( findByCode, [vm.data.citizenship_3_country_code] ) || {code:"", name:""};	
		vm.ac.citizenship_3.fld = "citizenship_3_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'citizenship_3_name', vm.ac.citizenship_3.country);*/				
				
/*		vm.ac.ms_country = {};		
		vm.ac.ms_country.country = vm.countries["LIB"].find( findByCode, [vm.data.ms_country_code] ) || {code:"", name:""};	
		vm.ac.ms_country.fld = "ms_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'ms_country_name', vm.ac.ms_country.country);	*/	
		
		fieldName = "ms_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.ms_country_code] ) || {code:"", name:""};		
		
/*		vm.ac.business_address_country = {};		
		vm.ac.business_address_country.country = vm.countries["LIB"].find( findByCode, [vm.data.business_address_country_code] ) || {code:"", name:""};	
		vm.ac.business_address_country.fld = "business_address_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'business_address_country_name', vm.ac.business_address_country.country);	*/
		
		fieldName = "business_address_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.business_address_country_code] ) || {code:"", name:""};				
		
/*		vm.ac.private_address_country = {};		
		vm.ac.private_address_country.country = vm.countries["LIB"].find( findByCode, [vm.data.private_address_country_code] ) || {code:"", name:""};	
		vm.ac.private_address_country.fld = "private_address_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'private_address_country_name', vm.ac.private_address_country.country);	*/
		
		fieldName = "private_address_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.private_address_country_code] ) || {code:"", name:""};			
		
/*		vm.ac.doc_dl_country = {};		
		vm.ac.doc_dl_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_dl_country_code] ) || {code:"", name:""};	
		vm.ac.doc_dl_country.fld = "doc_dl_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_dl_country_name', vm.ac.doc_dl_country.country);	*/	
		
		fieldName = "doc_dl_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_dl_country_code] ) || {code:"", name:""};				
		
/*		vm.ac.doc_pass_country = {};		
		vm.ac.doc_pass_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_pass_country_code] ) || {code:"", name:""};	
		vm.ac.doc_pass_country.fld = "doc_pass_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_pass_country_name', vm.ac.doc_pass_country.country);	*/
		
		fieldName = "doc_pass_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_pass_country_code] ) || {code:"", name:""};			
		
/*		vm.ac.doc_pass2_country = {};		
		vm.ac.doc_pass2_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_pass2_country_code] ) || {code:"", name:""};	
		vm.ac.doc_pass2_country.fld = "doc_pass2_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_pass2_country_name', vm.ac.doc_pass2_country.country);*/	
		
		fieldName = "doc_pass2_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_pass2_country_code] ) || {code:"", name:""};		
		
/*		vm.ac.doc_wl_country = {};		
		vm.ac.doc_wl_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_wl_country_code] ) || {code:"", name:""};	
		vm.ac.doc_wl_country.fld = "doc_wl_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_wl_country_name', vm.ac.doc_wl_country.country);	*/
		
		fieldName = "doc_wl_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_wl_country_code] ) || {code:"", name:""};		
		
/*		vm.ac.doc_rp_country = {};		
		vm.ac.doc_rp_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_rp_country_code] ) || {code:"", name:""};	
		vm.ac.doc_rp_country.fld = "doc_rp_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_rp_country_name', vm.ac.doc_rp_country.country);	*/	
		
		fieldName = "doc_rp_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_rp_country_code] ) || {code:"", name:""};				
		
/*		vm.ac.doc_ebdg_country = {};		
		vm.ac.doc_ebdg_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_ebdg_country_code] ) || {code:"", name:""};	
		vm.ac.doc_ebdg_country.fld = "doc_ebdg_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_ebdg_country_name', vm.ac.doc_ebdg_country.country);	*/
		
		fieldName = "doc_ebdg_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_ebdg_country_code] ) || {code:"", name:""};			
		
/*		vm.ac.doc_dbdg_country = {};		
		vm.ac.doc_dbdg_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_dbdg_country_code] ) || {code:"", name:""};	
		vm.ac.doc_dbdg_country.fld = "doc_dbdg_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_dbdg_country_name', vm.ac.doc_dbdg_country.country);	*/	
		
		fieldName = "doc_dbdg_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_dbdg_country_code] ) || {code:"", name:""};			
		
/*		vm.ac.doc_lap_country = {};		
		vm.ac.doc_lap_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_lap_country_code] ) || {code:"", name:""};	
		vm.ac.doc_lap_country.fld = "doc_lap_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_lap_country_name', vm.ac.doc_lap_country.country);	*/
		
		fieldName = "doc_lap_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_lap_country_code] ) || {code:"", name:""};				
		
/*		vm.ac.doc_jurep_country = {};		
		vm.ac.doc_jurep_country.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_jurep_country_code] ) || {code:"", name:""};	
		vm.ac.doc_jurep_country.fld = "doc_jurep_country_code";							
		$scope.$broadcast('angucomplete-alt:changeInput', 'doc_jurep_country_name', vm.ac.doc_jurep_country.country);	*/	
		
		fieldName = "doc_jurep_country";
		tmp = vm.ucountries[fieldName] = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [vm.data.doc_jurep_country_code] ) || {code:"", name:""};				
		
		/* medicals */
		for(var idx = 0; idx < vm.data.medicals.length; idx++){	
			setMedical(idx);
		}			
	}			
		
	function setMedical(idx){		
		var medical = vm.data.medicals[idx];
		vm.medicals[medical.id] = {};			
					
		var validFromString = medical.medical_valid_from;	
		var validFromDate = uibDateParser.parse(validFromString, "dd/MM/yyyy");
		vm.medicals[medical.id].validFromDate = {};
		vm.medicals[medical.id].validFromDate.date = validFromDate;
		vm.medicals[medical.id].validFromDate.popup = {opened: false};
		
		var validUntilString = medical.medical_valid_until;	
		var validUntilDate = uibDateParser.parse(validUntilString, "dd/MM/yyyy");	
		vm.medicals[medical.id].validUntilDate = {};
		vm.medicals[medical.id].validUntilDate.date = validUntilDate;	
		vm.medicals[medical.id].validUntilDate.popup = {opened: false};	
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Watches
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
/*	 $scope.$watchCollection(vm.nsmEditGdForm.$error.autocomplete-required, function(newVal, oldVal) {   
		console.log("newVal, oldVal", newVal, oldVal);			
					
		if(!!oldVal){					
			oldVal.forEach( function(el){
				$( "[name='" + el.$name + "']" ).parentsUntil(".stop-error-flagging").removeClass("panel-danger");
			})	
		}
		
		if(!!newVal){				
			newVal.forEach( function(el){						
				$( "[name='" + el.$name + "']" ).parentsUntil(".stop-error-flagging").addClass("panel-danger");
			})
		}
	});	*/		

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function getHeadingClasses(objType, id){					
		var obj, classes;		
				
		if(objType == "medical") 
			obj = getMedical(id);		
			
		if(objType == "bankAccount") 
			obj = getBankAccount(id);			
			
		if( obj && obj.status){					
			classes = obj.status;					
		}
		
		return classes;		
	}	

	function documentsCollapsed(){		
		return $("#documents").hasClass("in");
	}

	function expandAll(evt){	
		var form = $(".general-data-form");
		$(form).find( ".collapse-link" ).removeClass('collapsed');
		$(form).find( ".collapse" ).collapse('show');		
	}
	
	function collapseAll(evt){	
		var form = $(".general-data-form");
		$(form).find( ".collapse-link" ).addClass('collapsed');
		$(form).find( ".panel-collapse.in" ).collapse('hide');
	}	

	function setSelectedOption(obj, fld){
			
		if( !(obj && obj.originalObject) ){
			vm.data[fld] = "";	
			return;	
		}	
		
		vm.data[fld] = obj.originalObject.code;				
	}
	
	$scope.$on('$includeContentLoaded', function (evt, url) {		
		sync();
	});	
	
/*	$scope.$on('$workflowEvent', function (evt, url) {				
		vm.canEdit = false;
		vm.canStartWorkFlow = false;	
	});*/
	
	function sync(){
		waitForEl("#nsmEditGdForm", function() {
			//Panels expanded in View screen will be expanded when accessing the Edit screen
			var expandedPanels = $("#nsmViewGdForm div.panel-collapse.collapse.in");
			
			expandedPanels.each( function(index){	
				panelClass = $( this ).attr("class").split(" ")[1]; //eg, family-details-panel			
				panel = $("#nsmEditGdForm div." + panelClass);				
				panel.collapse('show');	
				lnk = $("#nsmEditGdForm ." + panelClass + "collapse-link");			
				lnk.removeClass('collapsed');						
			});	
		});		
	}				

	function reload(){		
		initCtrl(vm.gdTabMode);
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Alt-related functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function hasAlt(field){		
		return vm.data.alt && vm.data.alt.hasOwnProperty(field);
	}	
	
	function getAlt(field){			
		return vm.data.alt[field] || "[...]";
	}		
	
	function hasAltMed(id, field){	
		return vm.data.alt 
		&& vm.data.alt.medicals 
		&& vm.data.alt.medicals[id] 
		&& vm.data.alt.medicals[id].hasOwnProperty(field);	
	}
	
	function getAltMed(id, field){		
		//if(field == "medical_hash")	console.log("getAltMed", id, field, vm.data.alt.medicals[id][field]);		
		return vm.data.alt.medicals[id][field] || "[...]";		
	}
	
	function hasAltBankAccount(id, field){	
		return vm.data.alt 
		&& vm.data.alt.bankAccounts 
		&& vm.data.alt.bankAccounts[id] 
		&& vm.data.alt.bankAccounts[id].hasOwnProperty(field);	
	}
	
	function getAltBankAccount(id, field){					
		return vm.data.alt.bankAccounts[id][field] || "[...]";		
	}	
	
	function showError(){
		return true;	
	}		
	
	function error(name) {
		return;		
		var s = $scope.nsmEditGdForm[name];	
		return s.$invalid && s.$dirty ? "has-error has-feedback" : "";
	};	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// View, Save, Edit functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function editGD(){		
		if(vm.tabModes.edit === false)
			resetTemplate("edit", true);
		if(vm.tabModes.edit === true)
			setTabMode("edit", true);
	}
	
	function viewGD(){				
		if(vm.tabModes.view === false)
			resetTemplate("view", true);
		if(vm.tabModes.view === true)
			setTabMode("view", true);
	}	
	
	function saveGD(){	
		var fieldName1, fieldName2, val1, val2;
		var myForm = document.getElementById('nsmEditGdForm');	
		var formData = new FormData(myForm);
		
		Object.keys(vm.documents).forEach(function(key) {
			
			var tmp = vm.documents[key];
		
			fieldName1 = key + "_deleted";	
			val1 = tmp.deleted;
			fieldName2 = key + "_hash";	
			val2 = tmp.hash;
			
			formData.append(fieldName1, val1);
			formData.append(fieldName2, val2); 
		});
		
		Object.keys(vm.ucountries).forEach(function(key) {	
			var fieldName;		
			fieldName = key + "_code";
			formData.append(fieldName, vm.ucountries[key].country.code); 
		});			
		
		$http({
			method: 'POST',
			url: 'index.cfm?action=nsm:gd.saveGD',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {			
			Notification.info({message: vm.str.FORM_SUBMIT_OK, positionY: 'top', positionX: 'right'});
			//initCtrl("view");	
			//!nsmTabsController.gdGroup;
			$rootScope.$broadcast("tabSaved", "gd");	
		}, function errorCallback(response) {	
			Notification.warning({message: vm.str.FORM_SUBMIT_NOK, positionY: 'top', positionX: 'right'});
		});			
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Documents Management functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function removeDocument(docType, hash){
	
		console.log("removeDocument", docType, hash);	
		
		if ( confirm("Are you sure you want to DELETE this file?") ){		
			vm.documents[docType].deleted = "Y";
			vm.documents[docType].hash = hash;
		}	
	}
	
	function restoreDocument(docType, hash){
	
		console.log("restoreDocument", docType, hash);	
		
		if ( confirm("Are you sure you want to RESTORE this file?") ){		
			vm.documents[docType].deleted = "R";
			vm.documents[docType].hash = hash;
		}	
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Medicals Management functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function getMedical(medicalId){		
		var med;		
			
		vm.data.medicals.forEach(function(medical){ 				
			if(medical.id == medicalId)
				med = medical;				
		});		
				
		return med;		
	}	

	function addMedical() {
		nsmGdService.addMedical(staffMemberId).then(function(resp){				
			var newMedical = Object.assign({}, resp.data);			
			newMedical.status = "added";	
			vm.data.medicals.unshift(newMedical);
			setMedical(0);

			$("#nsmEditGdForm").find( ".medicals-panel-collapse-link" ).removeClass('collapsed');
			$("#nsmEditGdForm").find( ".medicals-panel" ).collapse('show');	
			
			var pClass = ".medical-" + newMedical.id;
			var pLink = ".medical-" + newMedical.id + "-collapse-link";
			
			waitForEl(pClass, function() {
				$("#nsmEditGdForm").find( pLink ).removeClass('collapsed');
				$("#nsmEditGdForm").find( pClass ).collapse('show');
			});	
		})
	}	
	
	function removeMedical(medicalId){	
		var medical, idx;
		
		if( !confirm(vm.str.ARE_YOU_SURE_DELETE_EXAM) )
			return;
		
		medical = getMedical(medicalId);	
	
		if(medical.status == "added") {				
			idx = vm.data.medicals.findIndex( arrayFindById, {id:medicalId} );
			vm.data.medicals.splice(idx, 1);
		}
		else {
			medical.medical_deleted = "Y"; 				
		}	
	}		
	
	function restoreMedical(medicalId){	
		var medical;	
				
		medical = getMedical(medicalId);
		
		if ( confirm("Are you sure you want to RESTORE this Medical Exam?") ){	
			medical.medical_deleted =  "R"; 
			medical.status = "";
		}	
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Bank Accounts Management functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function getBankAccount(bankAccountId){		
		var bac;		
			
		vm.data.bankAccounts.forEach(function(bankAccount){ 				
			if(bankAccount.id == bankAccountId)
				bac = bankAccount;				
		});		
				
		return bac;		
	}	

	function addBankAccount() {
		nsmGdService.addBankAccount(staffMemberId).then(function(resp){				
			var newBankAccount = Object.assign({}, resp.data);			
			newBankAccount.status = "added";	
			vm.data.bankAccounts.unshift(newBankAccount);
			//setBankAccount(0);

			$("#nsmEditGdForm").find( ".bank-accounts-panel-collapse-link" ).removeClass('collapsed');
			$("#nsmEditGdForm").find( ".bank-accounts-panel" ).collapse('show');	
			
			var pClass = ".bank-account-" + newBankAccount.id;
			var pLink = ".bank-account" + newBankAccount.id + "-collapse-link";
			
			waitForEl(pClass, function() {
				$("#nsmEditGdForm").find( pLink ).removeClass('collapsed');
				$("#nsmEditGdForm").find( pClass ).collapse('show');
			});	
		})
	}	
	
	function removeBankAccount(bankAccountId){	
		var bankAccount, idx;
		
		if( !confirm("Are you sure you want to DELETE this Bank Account?") )
			return;
		
		bankAccount = getBankAccount(bankAccountId);	
	
		if(bankAccount.status == "added") {				
			idx = vm.data.bankAccounts.findIndex( arrayFindById, {id:bankAccountId} );
			vm.data.bankAccounts.splice(idx, 1);
		}
		else {
			bankAccount.bank_deleted = "Y"; 				
		}	
	}		
	
	function restoreBankAccount(medicalId){	
		var bankAccount;	
				
		bankAccount = getBankAccount(bankAccountId);
		
		if ( confirm("Are you sure you want to RESTORE this Bank Account?") ){	
			bankAccount.bank_deleted =  "R"; 
			bankAccount.status = "";
		}	
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// File download functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function openDocFile(docType, hash){			
		var path = "index.cfm?action=nsm:gd.openDocFile&staff_member_id=" + staffMemberId + "&docType=" + docType + "&hash=" + hash;
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}
	
	function openMedFile(medicalId, hash){		
		console.log("openMedFile", medicalId, hash);
		return;	
		var path = "index.cfm?action=nsm:gd.openMedFile&staff_member_id=" + staffMemberId + "&medical_id=" + medicalId + "&hash=" + hash;
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}		

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Validation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function isTouchedWithErrors(field, id){			
		var elemName;
		
		if(id) 
			elemName = field + "_" + id;
		else
			elemName = field;			
		
		if( !vm.nsmEditGdForm )
			return;				
			
		if(	!vm.nsmEditGdForm[elemName] ) 
			return;
			
		var elem = vm.nsmEditGdForm[elemName];	
					
		return elem.$touched && elem.$error;			
	}	
	
	function hasErrors(id, field){	//for radio 	
		var elemName = field + "_" + id;	
		
		if( !vm.nsmEditGdForm )
			return;			
		
		if(	!vm.nsmEditGdForm[elemName] ) 
			return;
			
		var elem = vm.nsmEditGdForm[elemName];		
				
		return elem.$error;			
	}	
		
	function noCitizDup(pos) {				
		var retVal = true;		
		var citizenships = [];					
			
		citizenships.push(vm.ucountries.citizenship_1_country.country.code || "" ); 
		citizenships.push(vm.ucountries.citizenship_2_country.country.code || "" );				
				
		//reset all to valid
		vm.nsmEditGdForm.citizenship_1_name.$setValidity("multi", true);	
		vm.nsmEditGdForm.citizenship_2_name.$setValidity("multi", true);	
		
		if(citizenships[0] != "" && (citizenships[0] == citizenships[1])){
			vm.nsmEditGdForm.citizenship_1_name.$setTouched();
			vm.nsmEditGdForm.citizenship_2_name.$setTouched();
			vm.nsmEditGdForm.citizenship_1_name.$setValidity("multi", false);	
			vm.nsmEditGdForm.citizenship_2_name.$setValidity("multi", false);
			retVal = false;			
		}

		return retVal;	
	};	
	
	function noLangDup() {			
		var retVal = true;
		var languages = [];
					
		languages.push(vm.data.language_1_id || "");
		languages.push(vm.data.language_2_id || "");	
		
		//reset all to valid	
		vm.nsmEditGdForm.language_1_id.$setValidity("multi", true);	
		vm.nsmEditGdForm.language_2_id.$setValidity("multi", true);			
			
		if( languages[0] != "" && (languages[0] == languages[1]) ) {
			vm.nsmEditGdForm.language_1_id.$setTouched();
			vm.nsmEditGdForm.language_2_id.$setTouched();
			vm.nsmEditGdForm.language_1_id.$setValidity("multi", false);	
			vm.nsmEditGdForm.language_2_id.$setValidity("multi", false)			
			retVal = false;				
		}				
			
		return retVal;	
	};
	
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
		//maxDate: new Date(),
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
	
	function popup(popupName){
		vm[popupName].opened = true;
	}
	
	function popup2(dt){
		dt.popup.opened = true;
	}	
	
	function medPopup(medicalId, when){		
		if(when == "from")
			vm.medicals[medicalId].validFromOpened = true;
		else if(when == "until")
			vm.medicals[medicalId].validUntilOpened = true;
	}	

	setDate = function(year, month, day) {
		vm.dt = new Date(year, month, day);
	};

	vm.formats = ['dd/MM/yyyy'];
	vm.format = vm.formats[0];
	//vm.altInputFormats = ['M!/d!/yyyy'];	
	
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
			return $q.resolve();
		});	
	}		
	
	$scope.$on('languageChanged', function(event, args) {
		console.log("Language change event in mainGD.js", args);
		if(args.lang != vm.displayLanguage)
			setLanguage(args.lang);
	});
	
	function setLanguage(lang) {			
		var p1 = setStrings(lang);	
		var p2 = setCitizenships(lang);
		var p3 = setCountries(lang);					
		$q.all([p1, p2, p3]).then(function(values){ 			
			vm.displayLanguage = lang;				
			setSelectedOptions();	
		})		
	}	
	
	function getCtry(countryCode){	
		var country = vm.countries["LIB"].find( findByCode, [countryCode] );
		return ( country ? country.name : countryCode );	
	}	
	
	function getCitiz(countryCode){			
		var citiz = vm.citizenships["LIB"].find( findByCode, [countryCode] );	
		return ( citiz ? citiz.name : countryCode );		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Supporting functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function findByCode(obj) {				
		if (obj.code === this[0]) {			 
			return obj;
		}
	}	
	
	function arrayFindById(element){
		if(element.id == this.id)
			return true;
		return false;			
	}		
	
	//to Do: add to jQuery
	function waitForEl(selector, callback) {
		if ($(selector).length) {
			callback();
		} else {
			setTimeout(function() {
				waitForEl(selector, callback);
			}, 100);
		}
	};	
	
	function getAge(birthDate) {
		if( $.type(birthDate) !== "date" )
			return;			
		//Date object augmented in plugins.js				
		return birthDate.getAge();
	}	
	
	function dateCompare(o1, o2){		
		var valid1 = (o1.date instanceof Date && !isNaN(o1.date.valueOf()) );
		var valid2 = (o2.date instanceof Date && !isNaN(o2.date.valueOf()) );		
		
		if(!(valid1 === true && valid2 === true))	{
			return;		
		}
		
		if( o1.date.getTime() > o2.date.getTime() ){				
			vm.nsmEditGdForm[o1.field].$setTouched();
			vm.nsmEditGdForm[o2.field].$setTouched();
			vm.nsmEditGdForm[o1.field].$setValidity("datecompare", false);
			vm.nsmEditGdForm[o2.field].$setValidity("datecompare", false);
		}
		else {									
			vm.nsmEditGdForm[o1.field].$setValidity("datecompare", true);
			vm.nsmEditGdForm[o2.field].$setValidity("datecompare", true);			
		}
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	vm.saveGD = saveGD;
	vm.noCitizDup = noCitizDup;
	vm.noLangDup = noLangDup;
	vm.reload = reload;
	vm.error = error;
	vm.expandAll = expandAll;
	vm.collapseAll = collapseAll;	
	vm.showError = showError;
	
	vm.addMedical = addMedical;
	vm.removeMedical = removeMedical;
	vm.restoreMedical = restoreMedical;
	
	vm.addBankAccount = addBankAccount;
	vm.removeBankAccount = removeBankAccount;
	vm.restoreBankAccount = restoreBankAccount;		
	
	vm.openDocFile = openDocFile;
	vm.openMedFile = openMedFile;		
	vm.hasAltMed = hasAltMed;
	vm.getAltMed = getAltMed;
	vm.hasAltBankAccount = hasAltBankAccount;
	vm.getAltBankAccount = getAltBankAccount;	
	vm.viewGD = viewGD;
	vm.editGD = editGD;
	
	vm.setSelectedOption = setSelectedOption;
	vm.getCtry = getCtry;
	vm.getCitiz = getCitiz;
	vm.isTouchedWithErrors = isTouchedWithErrors;	
	vm.hasErrors = hasErrors;	
	
	vm.popup = popup;
	vm.popup2 = popup2;
	vm.dateCompare = dateCompare;
	vm.medPopup = medPopup;
	vm.setDate = setDate;
	vm.disabled = disabled;
	vm.documentsCollapsed = documentsCollapsed;
	vm.setAge = setAge;
	vm.hasAlt = hasAlt;	
	vm.getAlt = getAlt;	
	vm.getHeadingClasses = getHeadingClasses;
	vm.sync = sync;
	vm.removeDocument = removeDocument;
	vm.restoreDocument = restoreDocument;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();	  
	
}]);

