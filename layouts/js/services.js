/* Main Module */

app.factory('masterService', function($rootScope, $http, $q, $window, $timeout, $httpParamSerializerJQLike, API) {
	var masterService = {};

	masterService.get = function(_component, _method, _params, _cache) {
		var deferred = $q.defer();
		$http({
			url: API.url + _component + "." + _method,
			method: "GET",
			params: _params,
			paramSerializer: '$httpParamSerializerJQLike',
			cache: _cache || false
		}).then(
			function onSuccess(response) {
				deferred.resolve(response.data);	
				console.log('api', response.config.url, 'response:', response);
			},
			function onError(response) {
				deferred.reject('http failure');
				console.error('HTTP failure ',_component, _method, response.status);
			}
		);
		return deferred.promise;
	};

	masterService.post = function(_component, _method, _params, _data, _cache) {
		var httpOptions = {
			url: API.url + _component + "." + _method,
			method: "POST",
			params: _params,
			cache: _cache || false,
			data: _data
			//data: angular.isObject(_data) ? $httpParamSerializerJQLike(_data) : _data,
			//headers: {'Content-Type': 'application/x-www-form-urlencoded'}
		};
		var deferred = $q.defer();
		$http(httpOptions).then(
			function onSuccess(response){
				deferred.resolve(response.data);
				console.log('api', response.config.url, 'response:', response);
			},
			function onError(response) {
				deferred.reject('http failure');
				console.error('HTTP failure ', response.status);
			}
		);
		return deferred.promise;
	};
	
	masterService.export = function(_component, _method, _params, _data, _cache) {
		var deferred = $q.defer();
		$http({
			url: API.url + _component + "." + _method,
			method: "POST",
			params: _params,
			data: _data,
			responseType: 'arraybuffer'
		}).then(
			function onSuccess(response){
				var headers = response.headers();
				var file = new $window.Blob([response.data], {type: headers['content-type']});
				if(headers['content-type'].indexOf('html') != -1){// if content-type is html, it's not a download
					var reader = new FileReader();
					reader.addEventListener("loadend", function(e){ // read the content
						var result = angular.fromJson(e.srcElement.result);
						console.log(result);
						deferred.reject(result.ERRORS);
					});
					reader.readAsText(file);
				} else {
					var fileName = headers['content-disposition'];
					var i = fileName.indexOf("filename=");
					fileName = fileName.substring(i+9);
					var isIE = /*@cc_on!@*/false || !!$window.document.documentMode;  // IE9 and lower
					if (isIE) { 
						window.navigator.msSaveOrOpenBlob(file, fileName);
					} else {
						var fileURL = $window.URL.createObjectURL(file);
						var a = angular.element('<a />').css('display', 'none'); // we need an <a> tag to be able to download right away without popup/new window
						a[0].href = fileURL;
						a[0].download = fileName;
						var event = $window.document.createEvent('MouseEvents');
						event.initMouseEvent('click', true, true, $window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
						a[0].dispatchEvent(event);
					}
					$timeout(function() {$window.URL.revokeObjectURL(fileURL);}, 250);
					deferred.resolve(true);
				}
			},
			function onError(response) {
				deferred.reject('http failure');
				console.error('HTTP failure ', response.status);
			}
		);
		return deferred.promise;
	}
	return masterService;
});

app.factory('evaluationService', function($rootScope, $http) {
    var evaluationService = {};
	
    evaluationService.getEvalData = function(evalId) {
       return $http.get("index.cfm?action=eval:eval.getEvalData&jx&id=" + evalId);
    };	
    
    evaluationService.getUsersByEval = function(evalId) {
       return $http.get("index.cfm?action=eval:eval.getUsersByEval&jx&id=" + evalId);
    };
	
    evaluationService.getUsersByRole = function(evalId) {
       return $http.get("index.cfm?action=eval:prep.getUsersByRole&jx&id=" + evalId);
    };	
	
    evaluationService.getPhasesByEval = function(evalId) {
       return $http.get("index.cfm?action=eval:eval.getPhasesByEval&jx&id=" + evalId);
    };	
	
    evaluationService.getDocumentsByEval = function(evalId) {
       return $http.get("index.cfm?action=eval:eval.getDocumentsByEval&jx&id=" + evalId);
    };	
	
    evaluationService.getPrepComments = function(evalId) {
       return $http.get("index.cfm?action=eval:prep.getPrepComments&jx&id=" + evalId);
    };		
	
    evaluationService.getEvalTypes = function() {
       return $http.get("index.cfm?action=eval:eval.getEvalTypes&jx");
    };	
	
    evaluationService.getEvalueeDetails = function(evalId) {
       return $http.get("index.cfm?action=eval:eval.getEvalueeDetails&jx&id=" + evalId);
    };		
	
	evaluationService.savePrep = function(eval_id){	
		var myForm = document.getElementById('editPrepForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.savePrep' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}		
	
	evaluationService.requestVal = function(eval_id){	
		var myForm = document.getElementById('viewPrepForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.requestVal' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}	
	
	evaluationService.acceptVal = function(eval_id){	
		var myForm = document.getElementById('viewPrepForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.acceptVal' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}	
	
	evaluationService.rejectVal = function(eval_id){	
		var myForm = document.getElementById('viewPrepForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.rejectVal' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}	
	
	evaluationService.deletePrep = function(eval_id){	
		var myForm = document.getElementById('viewPrepForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.deletePrep' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}		

    return evaluationService;
});

app.factory('sassService', function($rootScope, $http) {
    var sassService = {};
	
    sassService.getObjectives = function(evaluee_id, period_id) {
       return $http.get("index.cfm?action=eval:sass.getObjectives&jx&evaluee_id=" + evaluee_id + "&period_id=" + period_id);
    };		
	
    return sassService;
});

app.factory('preparationService', function($rootScope, $http) {
    var evaluationService = {};
	
    preparationService.getEvalData = function(evalId) {
       return $http.get("index.cfm?action=eval:prep.getEvalData&jx&id=" + evalId);
    };	
    
    preparationService.getUsersByEval = function(evalId) {
       return $http.get("index.cfm?action=eval:prep.getUsersByEval&jx&id=" + evalId);
    };
	
    preparationService.getUsersByRole = function(evalId) {
       return $http.get("index.cfm?action=eval:prep.getUsersByRole&jx&id=" + evalId);
    };	
	
    preparationService.getPhasesByEval = function(evalId) {
       return $http.get("index.cfm?action=eval:prep.getPhasesByEval&jx&id=" + evalId);
    };	
	
    preparationService.getPrepComments = function(evalId) {
       return $http.get("index.cfm?action=eval:prep.getPrepComments&jx&id=" + evalId);
    };		
	
    preparationService.getDocumentsByEval = function(evalId) {
       return $http.get("index.cfm?action=eval:eval.getDocumentsByEval&jx&id=" + evalId);
    };	
	
    preparationService.getEvalTypes = function() {
       return $http.get("index.cfm?action=eval:prep.getEvalTypes&jx");
    };	
	
	preparationService.savePreparation = function(eval_id){	
		var myForm = document.getElementById('editPreparationForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.saveEditPreparation' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}		
	
	preparationService.requestAuthorization = function(eval_id){	
		var myForm = document.getElementById('viewPreparationForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.requestAuthorization' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}	
	
	preparationService.authorizePreparation = function(eval_id){	
		var myForm = document.getElementById('viewPreparationForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.authorizePreparation' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}	
	
	preparationService.rejectPreparation = function(eval_id){	
		var myForm = document.getElementById('viewPreparationForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.rejectPreparation' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}	
	
	preparationService.deletePreparation = function(eval_id){	
		var myForm = document.getElementById('viewPreparationForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=eval:prep.deletePreparation' + '&jx&eval_id=' + eval_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}		

    return preparationService;
});

app.factory('nsmService', function($rootScope, $http) {
    var nsmService = {};	 
	
    nsmService.getStaffMemberDetails = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:nsm.getStaffMemberDetails&jx&staff_member_id=" + staffMemberId);
    };	
	
    nsmService.WF_Start = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:nsm.WF_Start&jx&id=" + staffMemberId);
    };	
	
    nsmService.WF_Approve = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:nsm.WF_Approve&jx&id=" + staffMemberId);
    };	
	
    nsmService.WF_Reject = function(staffMemberId, comments) {
       //return $http.get("index.cfm?action=nsm:nsm.WF_Rejectt&jx&id=" + staffMemberId);
	   
	   var formData = new FormData();
	   formData.append("comments", comments);
	   
		return $http({
			method: 'POST',
			url: "index.cfm?action=nsm:nsm.WF_Reject&jx&id=" + staffMemberId,
			headers: {
				'Content-Type':undefined 
			},
			data: formData
		});	   
	   
    };		
	
    nsmService.getUpdatedTabs = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:nsm.getUpdatedTabs&jx&id=" + staffMemberId);
    };	
	
    nsmService.getWorkflowDetails = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:nsm.getWorkflowDetails&jx&id=" + staffMemberId);
    };			

    return nsmService;
});

app.factory('nsmGdService', function($rootScope, $http) {
    var nsmGdService = {};
	
    nsmGdService.getGD = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:gd.getGD&jx&id=" + staffMemberId);
    };	
    
    nsmGdService.addMedical = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:gd.addMedical&jx&id=" + staffMemberId);
    };
	
    nsmGdService.addBankAccount = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:gd.addBankAccount&jx&id=" + staffMemberId);
    };	
	
    nsmGdService.deleteMedical = function(staffMemberId, medicalId) {
       return $http.get("index.cfm?action=nsm:gd.deleteMedical&jx&staff_member_id=" + staffMemberId + "&medical_id=" + medicalId) ;
    };	

    return nsmGdService;
});

app.factory('nsmPeService', function($rootScope, $http) {
    var nsmPeService = {};
	
    nsmPeService.getPE = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:pe.getPE&jx&id=" + staffMemberId);
    };	
    
    nsmPeService.addExperience = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:pe.addExperience&jx&id=" + staffMemberId);
    };
	
    nsmPeService.deleteExperience = function(experienceId) {
       return $http.get("index.cfm?action=nsm:pe.deleteExperience&jx&id=" + experienceId);
    };	

    return nsmPeService;
});

app.factory('nsmEdService', function($rootScope, $http) {
    var nsmEdService = {};
	
    nsmEdService.getED = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:ed.getED&jx&id=" + staffMemberId);
    };	
	
    nsmEdService.getDomains = function(langCode) {
       return $http.get("index.cfm?action=nsm:ed.getDomains&jx&lang_code=" + langCode);
    };		
    
    nsmEdService.addDiploma = function(staffMemberId, levelId) {
       return $http.get("index.cfm?action=nsm:ed.addDiploma&jx&id=" + staffMemberId + "&level_id=" + levelId);
    };
	
    nsmEdService.deleteDiploma = function(diplomaId) {
       return $http.get("index.cfm?action=nsm:ed.deleteDiploma&jx&id=" + diplomaId);
    };	

    return nsmEdService;
});

app.factory('nsmFdService', function($rootScope, $http) {
    var nsmFdService = {};
    
    nsmFdService.get = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:fd.getFD&jx&id=" + staffMemberId);
    };
	
    nsmFdService.addChild = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:fd.addChild&jx&id=" + staffMemberId);
    };	
	
	nsmFdService.addSpouse = function(staffMemberId, gender) {
       return $http.get("index.cfm?action=nsm:fd.addSpouse&jx&id=" + staffMemberId + "&gender=" + gender);
    };
	
	nsmFdService.addOtherRelative = function(staffMemberId, familyLink) {
       return $http.get("index.cfm?action=nsm:fd.addOtherRelative&jx&id=" + staffMemberId + "&family_link=" + familyLink);
    };
	
	nsmFdService.removeRelative = function(staffMemberId, relativeId) {
       return $http.get("index.cfm?action=nsm:fd.removeRelative&jx&id=" + staffMemberId + "&relative_id=" + relativeId);
    };	
	
	nsmFdService.addScholarship = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:fd.addScholarship&jx&id=" + staffMemberId);
    };	
	
	nsmFdService.addCertificate = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:fd.addCertificate&jx&id=" + staffMemberId);
    };	

    return nsmFdService;
});

app.factory('nsmCoService', function($rootScope, $http) {
    var nsmCoService = {};
    
    nsmCoService.getCO = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:co.getCO&jx&id=" + staffMemberId);
    };
	
    nsmCoService.addContract = function(staffMemberId) {
       return $http.get("index.cfm?action=nsm:co.addContract&jx&id=" + staffMemberId);
    };	
	
	nsmCoService.removeContract = function(staffMemberId, contractId) {
       return $http.get("index.cfm?action=nsm:co.removeContract&jx&id=" + staffMemberId + "&contract_id=" + contractId);
    };	
	
    nsmCoService.getRoles = function(langCode) {
       return $http.get("index.cfm?action=nsm:co.getRoles&jx&lang_code=" + langCode);
    };			

    return nsmCoService;
});

app.factory('fomService', function($rootScope, $http) {
	//fom: Field Office Management
    var fomService = {};
    
    fomService.get = function(field_office_id) {
       return $http.get("index.cfm?action=fom.getFieldOfficeDetails&jx&field_office_id=" + field_office_id);
    };	
	
    fomService.getNew = function(field_office_id) {
       return $http.get("index.cfm?action=fom.getNewFieldOfficeDetails&jx&field_office_id=" + field_office_id);
    };	
	
    fomService.validateEdit = function(field_office_id) {
       return $http.get("index.cfm?action=fom.validateEdit&jx&field_office_id=" + field_office_id);
    };	
	
	fomService.rejectEdit = function(field_office_id) {
       return $http.get("index.cfm?action=fom.rejectEdit&jx&field_office_id=" + field_office_id);
    };	
	
    fomService.requestValidate = function(field_office_id) {
       return $http.get("index.cfm?action=fom.requestValidate&jx&field_office_id=" + field_office_id);
    };		
	
    fomService.discardChanges = function(field_office_id) {
       return $http.get("index.cfm?action=fom.discardChanges&jx&field_office_id=" + field_office_id);
    };	
	
	fomService.save = function(field_office_id){	
		var myForm = document.getElementById('fieldOfficeEditForm');	
		var formData = new FormData(myForm);		
		
		return $http({
			method: 'POST',
			url: 'index.cfm?action=fom.saveEditFieldOffice' + '&jx&field_office_id=' + field_office_id,
			headers: {
				'Content-Type':undefined //strange, isn't it?
			},
			data: formData
		});
	}	

    return fomService;
});

app.factory('stringsService', function($rootScope, $http) {
    var stringsService = {};	
	var cache = {};	
	xcache = cache;	
	cache["EN"] = {};
	cache["FR"] = {};	
	cache["ES"] = {};
	
    stringsService.get = function(lang, dom){			
		if(!cache[lang][dom])
			cache[lang][dom] = {};
			
		if(!cache[lang][dom].data)
			cache[lang][dom].data = $http.get("index.cfm?action=common.getStrings&jx&lang=" + lang + "&dom=" + dom);
		return cache[lang][dom].data;	
    };		

    return stringsService;
});

app.factory('dataService', function($rootScope, $http) {
    var dataService = {};	
	var dataStore = {};	
	
    dataService.get = function(module, key){	
		if( !dataStore.hasOwnProperty(module) || !dataStore[module].hasOwnProperty(key) )
			return '';		
			
		return dataStore[module][key];	
    };		
	
    dataService.set = function(module, key, value){	
		if(!dataStore[module])
			dataStore[module] = {};		
				
		dataStore[module][key] = value;			
    };	
	
   dataService.getModule = function(module){	
		if(!dataStore[module])
			return {};		
			
		return dataStore[module];	
    };		

    return dataService;
});

app.factory('countriesService', function($rootScope, $http) {
    var countriesService = {};
	var cache = {};	
	cache["EN"] = {};
	cache["FR"] = {};	
	cache["ES"] = {};	
	
    countriesService.get = function(lang){		
		if(!cache[lang].data)
			cache[lang].data = $http.get("index.cfm?action=common.getCountries&jx&lang=" + lang);
		return cache[lang].data;	
    };			

    return countriesService;
});

app.factory('citizenshipsService', function($rootScope, $http) {
    var citizenshipsService = {};
	var cache = {};
	cache["EN"] = {};
	cache["FR"] = {};	
	cache["ES"] = {};	
	
    citizenshipsService.get = function(lang){	
		if(!cache[lang].data)
			cache[lang].data = $http.get("index.cfm?action=common.getCitizenships&jx&lang=" + lang);
		return cache[lang].data;	
    };			

    return citizenshipsService;
});

app.factory('securityService', function($rootScope, $http, $sessionStorage) {
    var securityService = {};
    
    securityService.validateLogin = function(username) {
		$sessionStorage.$reset();
    	return $http.get("index.cfm?action=security.validateLogin&jx&username=" + username);
    };
	
    securityService.getRolesByUser = function() {
       return $http.get("index.cfm?action=security.getRolesByUser");
    };	

    return securityService;
});

app.factory('userService', function($rootScope, $http, settingsService, $q) {
    var userService = {};
	var officesCache = {};	
	
    userService.getTasks = function() {				
		return $http.get("index.cfm?action=main.getTasks&jx");		
    };	
	
    userService.getOffices = function() {		
		if(!officesCache.data)
			officesCache.data = $http.get("index.cfm?action=main.getOffices&jx");
		return officesCache.data;
    };	
	
    userService.setOffice = function(office_id) {		
       return $http.get("index.cfm?action=main.setOffice&jx&office_id=" + office_id).then(function(resp){				
			settingsService.reloadCache().then(function(){
				return $q.resolve(resp);
			});				
	   });
    };	

    return userService;
});

/*app.factory('settingsService', function ($rootScope, $http, $sessionStorage, $q, masterService) {
	var settingsService = {};
	var cache = {};

	settingsService.get = function(callsite){

		var deferred = $q.defer();

		if (angular.isUndefined($sessionStorage.userData)) {
			masterService.get('main', 'getUserSettings', {cs: callsite}).then(
				function(response) {
					$sessionStorage.userData = angular.copy(response);
					deferred.resolve({data: $sessionStorage.userData});
				}
			);
		} else {
            deferred.resolve({data: $sessionStorage.userData});
		}
	
		return deferred.promise;
	};

	settingsService.set = function (setting, val) {
		return $http.get("index.cfm?action=main.setUserSetting&jx&setting=" + setting + "&val=" + val).then(function (resp) {
			delete cache.data;
		});
	};

	settingsService.reloadCache = function () {
		cache.data = $http.get("index.cfm?action=main.getUserSettings&jx&cs=" + "reload");
		return cache.data;
	};

	return settingsService;
});*/

app.factory('settingsService', function($rootScope, $http) {
    var settingsService = {};	
	var cache = {};	
		
    settingsService.get = function(callsite) {		
		if(!cache.data)
			cache.data = $http.get("index.cfm?action=main.getUserSettings&jx&cs=" + callsite);
		return cache.data;	
    };	
	
	settingsService.set = function(setting, val) {
		return $http.get("index.cfm?action=main.setUserSetting&jx&setting=" + setting + "&val=" + val).then(function(resp){
			delete cache.data;			
		});
	};	
	
	settingsService.reloadCache = function(){		
		cache.data = $http.get("index.cfm?action=main.getUserSettings&jx&cs=" + "reload");
		return cache.data;
	};

    return settingsService;
});

app.factory('newIdService', function() {
	var newIdService = {};
    var id = 0;	
	
	newIdService.getId = function(){			
		return --id;			
    };	
	
	return newIdService;
});	

app.factory('mailService', function($rootScope, $http) {
	var mailService = {};    
	
	mailService.prepareMessages = function(){			
		return $http.get("index.cfm?action=staff.prepareMessages&jx");					
    };	
	
	mailService.sendMessages = function(){			
		return $http.get("index.cfm?action=staff.sendMessages&jx");					
    };		
	
	return mailService;
});	

app.factory('navService', function($rootScope, dataService) {
	var navService = {};
    var id = 0;	
	
	navService.open = function (navObj){
		dataService.set("nav", "navAction", navObj);
		$rootScope.$broadcast("navAction", navObj);	
	}		
	
	return navService;
});		

/* UI Grid Module */

angular.module('ui.grid').factory('nsmGridService', ['$http', function($http) {					
	//var baseUrl = 'index.cfm?a=1&action=staff';
	var baseUrl = 'index.cfm?action=nsm:nsm';
	var extraHeaders = {
		'X-Requested-With':'XMLHttpRequest'
	};
	
	return {
		readAll: function (officeId) {
			return $http({
				method: 'GET',
				url: baseUrl + ".getNSMGridData&office_id=" + officeId,
				headers: extraHeaders
			}).then(function (response) {
				return response.data;
			});
		},
		getStaffMemberDetails: function(staffMemberId){
			return $http({
				method: 'GET',
				url: baseUrl + ".getStaffMemberDetails&staff_member_id=" + staffMemberId,
				headers: extraHeaders
			}).then(function (response) {
				return response.data;
			});	
		},
		addStaffMember: function(staffType){
			return $http({
				method: 'GET',
				url: baseUrl + ".addStaffMember&staff_type=" + staffType,
				headers: extraHeaders
			}).then(function (response) {
				return response.data;
			});	
		}		
	}		
}]);

angular.module('ui.grid').factory('evalService', ['$http', function($http) {					
	var baseUrl = 'index.cfm?action=eval:eval';
	var extraHeaders = {
		'X-Requested-With':'XMLHttpRequest'
	};
	var item = 'getEvalGridData';
	
	return {
		readAll: function (officeId) {
			return $http({
				method: 'GET',
				url: baseUrl + "." + item + "&office_id=" + officeId, 
				headers: extraHeaders
			}).then(function (response) {
				return response;
			});
		}
	}		
}]);
