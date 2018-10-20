app.cp.register('nsmMainCoController', ['$rootScope', '$scope', '$http', 'nsmService', 'Notification', 'dataService', 'stringsService', 'countriesService', 'settingsService', '$q', 'nsmCoService', '$templateCache', 'uibDateParser', function ($rootScope, $scope, $http, nsmService, Notification, dataService, stringsService, countriesService, settingsService, $q, nsmCoService, $templateCache, uibDateParser) {	

	console.log("nsmMainCoController loaded [subsystems/nsm/views/ed/js/mainCO.js]",  $scope.$id); 	
	
	var settings;
	
	var staffMemberId;			
	var staffMemberDetails;		
	
	var currentViewCoUrl = "";
	var currentEditCoUrl = "";	

	var vm = this; 
	
	vm.data = {};
	vm.tabModes = {};
	vm.tabModes.view = false; //never loaded
	vm.tabModes.edit = false; //never loaded
	
	vm.displayLanguage;
	vm.staff_member_id;
	
	//vm.contractCountries = {};
	vm.strings = {};
	vm.countries = {};	
	vm.contracts = {};	
	vm.roles = {};	
	vm.fields = {};
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
		
	function initCtrl(tabMode) {	
	
		console.log("nsmMainCoController initCtrl", tabMode);
		
		staffMemberId = dataService.get("nsm", "staffMemberId");
		staffMemberDetails = dataService.get("nsm", "staffMemberDetails");
		
		vm.staff_member_id = staffMemberId;
		vm.nsm_details = staffMemberDetails;	
		
		var defaultTabMode = "view"; 	
		var selectcoTabMode;
		
		settingsService.get("nsmMainCoController").then(function(resp){			
			settings = resp.data;	
					
			vm.displayLanguage = settings.displayLanguage;			
			
			var p1 = setStrings(vm.displayLanguage);	
			var p2 = setCountries(vm.displayLanguage);	
			var p3 = setContracts(staffMemberId);
			//var p4 = setRoles(vm.displayLanguage);
			
			$q.all([p1, p2, p3]).then(function(values){ 				
				setSelectedOptions(vm.data.length);				
				
				if(!!tabMode)
					selectcoTabMode = tabMode;
				else if(settings.co && settings.co.initialTabMode)		
					selectcoTabMode = settings.co.initialTabMode;		
				else
					selectcoTabMode = defaultTabMode;		
					
				resetTemplate(selectcoTabMode, true);	
			})
		});		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function setTabMode(tabMode){	
		vm.coTabMode = tabMode;
	}	

	function resetTemplate(tabMode, switchToTabMode) {		
		
		if(tabMode == "view") {		
			var updateTime = Date.now();
			var newViewCoUrl = 'index.cfm?action=nsm:co.viewCO&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentViewCoUrl);		
			currentViewCoUrl = newViewCoUrl;		
			vm.viewCoUrl = currentViewCoUrl;
			vm.tabModes.view = true;
		}
		
		if(tabMode == "edit") {			
			var updateTime = Date.now();		
			var newEditCoUrl = 'index.cfm?action=nsm:co.editCO&jx&staff_member_id=' + staffMemberId + '&updated=' + updateTime;
			$templateCache.remove(currentEditCoUrl);
			currentEditCoUrl = newEditCoUrl;		
			vm.editCoUrl = currentEditCoUrl;	
			vm.tabModes.edit = true;			
		}	
		
		if(switchToTabMode === true)
			setTabMode(tabMode);		
	}

	function setContracts(staffMemberId){		
		return nsmCoService.getCO(staffMemberId).then(function(resp){			
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
	
	function setRoles(langCode) {		
		return nsmCoService.getRoles(langCode).then(function(resp){
			vm.roles = resp.data;	
			return $q.resolve();			
		});		
	}	
	
	function setContract(idx){		
		var contract, dteString, role, dte, tmp, fieldName;
		
		contract = vm.data.contracts[idx];
		vm.contracts[contract.id] = {};
				
		dteString = contract.start_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.contracts[contract.id].start_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};	
		
		dteString = contract.end_date;	
		dte = uibDateParser.parse(dteString, "dd/MM/yyyy");
		tmp = vm.contracts[contract.id].end_date = {};
		tmp.date = dte;
		tmp.popup = {opened: false};			
		
/*		tmp = vm.contracts[contract.id].contracts_country = {};
		tmp.country = vm.countries["LIB"].find( findByCode, [contract.country_code] ) || {code:"", name:""};		
		fieldName = "country_code_" + contract_role_code.id;
		vm.fields[fieldName] = tmp.country.code;*/			
		
/*		tmp = vm.contracts[contract.id].contract_role = {};
		tmp.role = vm.roles.find( findByCode, [contract.contract_role_code] ) || {code:"", name:""};		
		fieldName = "contract_role_code_" + contract.id;
		vm.fields[fieldName] = tmp.role.code;*/			
	}	
	
	function setAltData(){	
		var coll;
		vm.swaps = {}; //reset to remove stale values			
		
		if( vm.data.hasOwnProperty("alt") ){
			Object.keys(vm.data.alt).forEach(function(itemGroupName){ 
				coll = vm.data.alt[itemGroupName];											
				Object.keys(coll).forEach(function(contractId){ 
					coll[contractId].forEach(function(altItem) { //expected to be an array of contract docs
						setAltStructItem(itemGroupName, contractId, altItem); 
					})
				})				
			})
		}
	}
	
	function setAltStructItem(itemGroupName, contractId, altItem) {	
		var pos, swap, isUpdated, mainItem;
		context = vm.data[itemGroupName]; //eg, vm.data.certificates			
		
		if( !context.hasOwnProperty(contractId) ){					
			context[contractId] = [];
			altItem.status = "new";
			context[contractId].push(altItem);	
			return;	
		}		
		
		altItemId = altItem.id;
		pos = context[contractId].findIndex( arrayFindById, {id:altItemId} );		
		
		if(pos == -1){				
			altItem.status = "new";
			context[contractId].push(altItem);	
			return;			
		}	
		
		mainItem = context[contractId][pos];			
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
	
	function setSelectedOptions() {	
			
		for(var idx = 0; idx < vm.data.contracts.length; idx++){			
			setContract(idx);						
		}		
	}	
	
	function reload(){
		initCtrl();
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// alt functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			

	function hasAltContractDocField(fieldName, contractDocId) {
		
		return vm.data.alt 
			&& vm.data.alt.contractDocs
			&& vm.data.alt.contractDocs[contractDocId]
			&& vm.data.alt.contractDocs[contractDocId].hasOwnProperty(fieldName);
		
	}
	
	function getAltContractDocField(fieldName, contractDocId) {
		
		return vm.data.alt.contractDocs[contractDocId][fieldName] || "[...]";	
		
	}	
	
	function getAltTypeCode(contractDocId, mainTypeCode){
		var hasAlt;
		var hasAltTypeCode, altTypeCode; 
		var mainHash, hasAltHash, altHash;
		//if no alt doc, return
		//if alt type is different from main type, return alt type
		//else if alt hash is different from main hash, return the main type
		
		hasAlt = vm.data.alt 
			&& vm.data.alt.contractDocs 
			&& vm.data.alt.contractDocs[contractDocId];
			
		if(!hasAlt)
			return;		

		hasAltTypeCode = hasAltContractDocField("type_code", contractDocId);
		if(hasAltTypeCode)
			altTypeCode = getAltContractDocField("type_code", contractDocId);
		if(	altTypeCode != 	mainTypeCode)
			return vm.str[altTypeCode];	
		
		mainHash = vm.data.contractDocs[contractDocId]["hash"];
		hasAltHash = hasAltContractDocField("hash", contractDocId);
		if(hasAltHash)
			altTypeCode = getAltContractDocField("hash", contractDocId);
		if(	hasAltHash != mainHash)
			return vm.str[mainTypeCode];	
			
		return;				
	}
	
	function getAltFileName(contractDocId, mainTypeCode, mainFileName, mainHash){
		var hasAlt;
		var hasAltTypeCode, altTypeCode; 
		var hasAltHash, altHash;
		var hasAltFileName, altFileName;
		//if no alt doc, return
		//if altName is not provided, it is the same as the main name
		//if the names are different return alt name
		//if the hash is different, return alt name
		//else if alt type is different, return alt name
		
		hasAlt = vm.data.alt 
			&& vm.data.alt.contractDocs 
			&& vm.data.alt.contractDocs[contractDocId];
			
		if(!hasAlt)
			return;		

		hasAltFileName = hasAltContractDocField("file_name", contractDocId);
		if(hasAltFileName)
			altFileName = getAltContractDocField("file_name", contractDocId);
			
		if(altFileName != mainFileName)
			return altFileName;		
		else
			altFileName	= mainFileName;						

		hasAltHash = hasAltContractDocField("hash", contractDocId);
		if(hasAltHash)
			return altFileName;			

		hasAltTypeCode = hasAltContractDocField("type_code", contractDocId);
		if(hasAltTypeCode)
			altTypeCode = getAltContractDocField("type_code", contractDocId);
		if(	altTypeCode != 	mainTypeCode)
			return mainFileName;			
			
		return;			
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Display functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function expandAll(evt){	
		var target = evt.currentTarget;		
		var form = $(target).closest("form");	
		$(form).find( ".collapse-link" ).removeClass('collapsed');
		$(form).find( ".collapse" ).collapse('show');			
	}
	
	function collapseAll(evt){					
		var target = evt.currentTarget;		
		var form = $(target).closest("form");	
		$(form).find( ".collapse-link" ).addClass('collapsed');
		$(form).find( ".panel-collapse.in" ).collapse('hide');		
	}	
	
	function getHeadingClasses(objType, id){
		var contract, classes;
		//objType currently always contract
			
		contract = getContract(id);			
			
		if( contract && contract.status )					
			classes = contract.status;	
		
		return classes;		
	}	
	
	function getLabelClasses(objType, versionId, contractDocId){
		var contractDoc, classes;
			
		contractDoc = getContractDoc(versionId, contractDocId);				
			
		if( contractDoc && contractDoc.status && contractDoc.status == "new")					
			classes = "label-success alt-data";	
		else
			classes = "label-primary";
		
		return classes;		
	}		
	
	function getContractDoc(versionId, contractDocId){					
		var pos, contractDoc;			
	
		pos = vm.data.contractDocs[versionId].findIndex( arrayFindById, {id:contractDocId} );	
		contractDoc = vm.data.contractDocs[versionId][pos];		
		
		return contractDoc;
	}	
	
	function hasAltContract(id, field){					
		return vm.data.alt && vm.data.alt.contracts && vm.data.alt.contracts[id] && vm.data.alt.contracts[id].hasOwnProperty(field);			
	}
	
	function getAltContract(id, field){		
		return vm.data.alt.contracts[id][field];
	}			
	
	function getAltContractCtry(id){
		var countryCode, country;
		
		countryCode = vm.data.alt.contracts[id]["country_code"];			
		country = vm.countries["LIB"].find( findByCode, [countryCode] );
		
		return ( country ? country.name : "[...]" );	
	}
	
	function getCtry(countryCode){
		var country;
		
		country = vm.countries["LIB"].find( findByCode, [countryCode] );
		
		return ( country ? country.name : "N/A" );
	}	
	
	function getRole(roleCode){
		var role;
		
		role = vm.roles.find( findByCode, [roleCode] );	
		
		return ( role ? role.name : "N/A" );
	}	
	
	$scope.$on('$includeContentLoaded', function (evt, url) {		
		sync();
	});	
	
	function sync(){
		waitForEl("#nsmEditCoForm", function() {
			//Panels expanded in View screen will be expanded when accessing the Edit screen
			var expandedPanels = $("#nsmViewCoForm div.panel-collapse.collapse.in");
			
			expandedPanels.each( function(index){	
				panelClass = $( this ).attr("class").split(" ")[1]; //eg, family-details-panel			
				panel = $("#nsmEditCoForm div." + panelClass);				
				panel.collapse('show');	
				lnk = $("#nsmEditEdForm ." + panelClass + "collapse-link");			
				lnk.removeClass('collapsed');						
			});	
		});		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// contract Management functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function getContract(contractId){		
		var ct;		
			
		vm.data.contracts.forEach(function(contract){ 				
			if(contract.id == contractId)
				ct = contract;				
		});		
				
		return ct;		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Edit, View, Save functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function viewCO(){				
		if(vm.tabModes.view === false)
			resetTemplate("view", true);
		if(vm.tabModes.view === true)
			setTabMode("view", true);
	}	
	
	function editCO(){		
		if(vm.tabModes.edit === false)
			resetTemplate("edit", true);
		if(vm.tabModes.edit === true)
			setTabMode("edit", true);
	}	
	
	function saveCO(){	
		var myForm = document.getElementById('nsmEditCoForm');	
		var formData = new FormData(myForm);	
		
		$http({
			method: 'POST',
			url: 'index.cfm?action=nsm:co.saveCO',
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		}).then(function successCallback(response) {			
			Notification.info({message: vm.str.FORM_SUBMIT_OK, positionY: 'top', positionX: 'right'});
			$rootScope.$broadcast("tabSaved", "co");	
		}, function errorCallback(response) {	
			Notification.warning({message: vm.str.FORM_SUBMIT_NOK, positionY: 'top', positionX: 'right'});
		});			
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// File Upload Functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function handleFiles(a, b){
		console.log("handleFiles", a, b);
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// File Download Functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function openContractDocFile(docId, hash){				
		var path = "index.cfm?action=nsm:co.openContractFile&staff_member_id=" + staffMemberId + "&docId=" + docId + "&hash=" + hash;		
		window.open(path, "Document", "width=800, height=500, top=0, resizable=yes ,scrollbars=yes"); 		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Workflow Management
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function WF_Start() {	
		if( !confirm(vm.str.ARE_YOU_SURE_START_WORKFLOW) )
			return;
	
		nsmService.WF_Start(staffMemberId).then(function(resp){	
			Notification.info({message: vm.str.WORKFLOW_STARTED, positionY: 'top', positionX: 'right'});			
		}).catch(function (response) {
            Notification.info({message: vm.str.ERROR_STARTING_WORKFLOW, positionY: 'top', positionX: 'right'});	
        });		
	}	
	
	function WF_Accept() {	
		if( !confirm(vm.str.ARE_YOU_SURE_APPROVE_CHANGES) )
			return;	
	
		nsmService.WF_Approve(staffMemberId).then(function(resp){	
			Notification.info({message: vm.str.CHANGES_APPROVED, positionY: 'top', positionX: 'right'});			
		}).catch(function (response) {
            Notification.info({message: vm.str.ERROR_APPROVING_CHANGES, positionY: 'top', positionX: 'right'});	
        });		
	}
	
	function WF_Reject() {	
		if( !confirm(vm.str.ARE_YOU_SURE_REJECT_CHANGES) )
			return;	
				
		nsmService.WF_Reject(staffMemberId).then(function(resp){	
			Notification.info({message: vm.str.CHANGES_REJECTED, positionY: 'top', positionX: 'right'});			
		}).catch(function (response) {
            Notification.info({message: vm.str.ERROR_REJECTING_CHANGES, positionY: 'top', positionX: 'right'});	
        });		
	}		

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Validation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function isTouchedWithErrors(id, field){			
		var elem, elemName;
		
		elemName = field + "_" + id;			
		
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
		console.log("Language change event in mainCO.js", args);
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
	
	function openPopup(contractId, field){
		vm.relatives[contractId][field].popup.opened = true;		
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
	vm.viewCO = viewCO;
	vm.editCO = editCO;

	vm.expandAll = expandAll;
	vm.collapseAll = collapseAll;	
	vm.isTouchedWithErrors = isTouchedWithErrors;
	
	vm.hasAltContract = hasAltContract;
	vm.getAltContract = getAltContract;
	vm.getAltContractCtry = getAltContractCtry;
	
	vm.getHeadingClasses = getHeadingClasses;
	vm.popup = popup;		
	vm.getCtry = getCtry;
	
	vm.WF_Start = WF_Start;
	vm.WF_Accept = WF_Accept;
	vm.WF_Reject = WF_Reject;
	
	vm.openContractDocFile = openContractDocFile;	

	vm.getRole = getRole;
	vm.hasAltContractDocField = hasAltContractDocField;
	vm.getAltContractDocField = getAltContractDocField;
	
	vm.getAltTypeCode = getAltTypeCode;
	vm.getAltFileName = getAltFileName;	
	
	vm.saveCO = saveCO;	
	vm.handleFiles = handleFiles;
	vm.getLabelClasses = getLabelClasses;
	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();	  
				
}]);