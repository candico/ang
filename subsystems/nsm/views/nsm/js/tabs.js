app.cp.register('nsmTabsController', ['$rootScope', '$scope', '$http', 'Notification', 'dataService', 'settingsService', 
'stringsService', '$q', '$templateCache', 'nsmService', 'ngDialog', '$uibModal', '$log', '$document', 
function ($rootScope, $scope, $http, Notification, dataService, settingsService, 
stringsService, $q, $templateCache, nsmService, ngDialog, $uibModal, $log, $document ) {		

	console.log("nsmTabsController loaded", $scope.$id); 	
	
	var settings;	
	
	var currentFieldOfficeId;			
	var staffMemberId;
	var staffMemberDetails;	

	var vm = this;	
	vm.strings = {};
	
	//saving which tabs have already been loaded	
	vm.tabs = {};
	vm.tabs.gd = false;	
	vm.tabs.fd = false;				
	vm.tabs.ep = false;	
	vm.tabs.ed = false;
	vm.tabs.co = false;		
	
/*	vm.mainFdUrl = 'index.cfm?action=nsm:fd.mainFD&jx&staff_member_id=' + staffMemberId;		
	vm.mainPeUrl = 'index.cfm?action=nsm:pe.mainPE&jx&staff_member_id=' + staffMemberId;	
	vm.mainEdUrl = 'index.cfm?action=nsm:ed.mainED&jx&staff_member_id=' + staffMemberId;	
	vm.mainGdUrl = 'index.cfm?action=nsm:gd.mainGD&jx&staff_member_id=' + staffMemberId;	
	vm.mainCoUrl = 'index.cfm?action=nsm:co.mainCO&jx&staff_member_id=' + staffMemberId;*/
	
	vm.coGroup = true;
	vm.gdGroup = true;
	vm.fdGroup = true;
	vm.edGroup = true;
	vm.peGroup = true;
	
	vm.dialog;
	dialog = vm.dialog;
	vm.success = "OK";
	
	vm.rejectReason = "";
	
	vm.nsm_details = {};		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
		
	function initCtrl(tab, mode) {		
		var nsmTab;
		var nsmTabMode;
		var defaultNsmTab = "gd"; 
		var defaultNsmTabMode = "view"; 
		
		settingsService.get("nsmTabsController").then(function(resp) {	
			settings = resp.data;
			
			currentFieldOfficeId = settings.current_field_office_id;			
			staffMemberId = dataService.get("nsm", "staffMemberId");
			//staffMemberDetails = dataService.get("nsm", "staffMemberDetails");	
			//vm.nsm_details = staffMemberDetails;		
			
			vm.mainFdUrl = 'index.cfm?action=nsm:fd.mainFD&jx&staff_member_id=' + staffMemberId;		
			vm.mainPeUrl = 'index.cfm?action=nsm:pe.mainPE&jx&staff_member_id=' + staffMemberId;	
			vm.mainEdUrl = 'index.cfm?action=nsm:ed.mainED&jx&staff_member_id=' + staffMemberId;	
			vm.mainGdUrl = 'index.cfm?action=nsm:gd.mainGD&jx&staff_member_id=' + staffMemberId;	
			vm.mainCoUrl = 'index.cfm?action=nsm:co.mainCO&jx&staff_member_id=' + staffMemberId;			
			
			vm.displayLanguage = settings.displayLanguage;
			vm.current_field_office_id = settings.current_field_office_id;
			
			var p1 = setStrings(vm.displayLanguage);	
			var p2 = getUpdatedTabs(staffMemberId);	
			var p3 = setStaffMemberDetails(staffMemberId);	
			var p4 = setWorkflowDetails(staffMemberId);	
			
			$q.all([p1, p2, p3, p4]).then(function(resp){				
			
				if(!!tab)
					nsmTab = tab;
				else if(settings.initialNsmTab)		
					nsmTab = settings.initialNsmTab;		
				else
					nsmTab = defaultNsmTab;		
					
				if(!!mode)
					nsmTabMode = mode;
				else if(settings.initialNsmTabMode)		
					nsmTabMode = settings.initialNsmTabMode;		
				else
					nsmTabMode = defaultNsmTabMode;										
												  
				setTab(nsmTab, nsmTabMode);
			});					
			
		});		
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Setup functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function setTab(tab, mode){	
		vm.tabs[tab] = true;
		vm.activeTab = tab;
	}
	
	function getUpdatedTabs(staffMemberId) {
		var p1 = nsmService.getUpdatedTabs(staffMemberId);
		
		return $q.all([p1]).then(function(resp){ 
			var data = resp[0].data;
			vm.updatedTabs = data;		
		});	
	}
	
	function setStaffMemberDetails(staffMemberId){
		var p1 = nsmService.getStaffMemberDetails(staffMemberId);
			
		return $q.all([p1]).then(function(resp){ 
			var data = resp[0].data;
			vm.nsm_details = data;	
		});	
	}
	
	function setWorkflowDetails(staffMemberId){
		var p1 = nsmService.getWorkflowDetails(staffMemberId);
			
		return $q.all([p1]).then(function(resp){ 
			var data = resp[0].data;
			vm.nsm_wf = data;	
		});	
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
	
	function setStrings(langCode) {		
		var p1 = stringsService.get(langCode, "SHARED");
		var p2 = stringsService.get(langCode, "NSM");
		var p3 = stringsService.get(langCode, "FD");
		
		return $q.all([p1, p2, p3]).then(function(values){ 			
			var JS = Object.assign({}, values[0].data.JS, values[1].data.JS, values[2].data.JS);			
			var LIB = Object.assign({}, values[0].data.LIB, values[1].data.LIB, values[2].data.LIB);				
			vm.strings["JS"] = JS;
			 
			vm.strings["LIB"] = LIB;
			vm.str = vm.strings["JS"];	
			$scope.items = vm.str;
			//return $q.resolve();
		});	
	}		
	
	$scope.$on('languageChanged', function(event, args) {
		console.log("Language change event in nsm/tabsGD.js", args);
		if(args.lang != vm.displayLanguage){}
			setLanguage(args.lang);
	});	
	
	$scope.$on('tabSaved', function(event, args) {
		console.log("tabSaved event in nsm/tabs.js", args);	
		
		setWorkflowDetails(staffMemberId).then( function(resp) {
			//refreshGroup(args);								
			refreshAllGroups();
		})
	});	
	
	$scope.$on('workflowEvent', function(event, args) {
		console.log("workflowEvent event in nsm/tabsGD.js", args);		
		refreshAllGroups();
	});		
	
	function setLanguage(lang) {			
		var p1 = setStrings(lang);						
		$q.all([p1]).then(function(values){ 
			vm.displayLanguage = lang;							
		})		
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Workflow Management
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function WF_Start() {	
		if( !confirm(vm.str.ARE_YOU_SURE_START_WORKFLOW) )
			return;
	
		nsmService.WF_Start(staffMemberId).then(function(resp){	
			Notification.info({message: vm.str.WORKFLOW_STARTED, positionY: 'top', positionX: 'right'});
			$rootScope.$broadcast("workflowEvent");			
		}).catch(function (response) {
            Notification.info({message: vm.str.ERROR_STARTING_WORKFLOW, positionY: 'top', positionX: 'right'});	
        });		
	}	
	
	function WF_Accept() {	
		if( !confirm(vm.str.ARE_YOU_SURE_APPROVE_CHANGES) )
			return;	
	
		nsmService.WF_Approve(staffMemberId).then(function(resp){	
			Notification.info({message: vm.str.CHANGES_APPROVED, positionY: 'top', positionX: 'right'});	
			$rootScope.$broadcast("workflowEvent");			
		}).catch(function (response) {
            Notification.info({message: vm.str.ERROR_APPROVING_CHANGES, positionY: 'top', positionX: 'right'});	
        });		
	}
	
	function WF_Reject(size, parentSelector) {	
				
		vm.rejectModalInstance = openRejectModal(size, parentSelector);		
			
		vm.rejectModalInstance.result.then(function (rejectReason) {			
			vm.rejectReason = rejectReason;			
			
			nsmService.WF_Reject(staffMemberId, vm.rejectReason).then(function(resp){	
				Notification.info({message: vm.str.CHANGES_REJECTED, positionY: 'top', positionX: 'right'});			
				$rootScope.$broadcast("workflowEvent");	
			}).catch(function (response) {
				Notification.info({message: vm.str.ERROR_REJECTING_CHANGES, positionY: 'top', positionX: 'right'});	
			});	
			
		}, function () {
			console.log('Modal dismissed at: ' + new Date());
		});	
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Modal functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	function openRejectModal(size, parentSelector) {
		
		var parentElem = parentSelector 
			? angular.element($document[0].querySelector(parentSelector)) 
			: undefined;
		
		var rejectModalInstance = $uibModal.open(	{
			animation: true,
			ariaLabelledBy: 'modal-title',
			ariaDescribedBy: 'modal-body',
			templateUrl:"index.cfm?action=nsm:nsm.viewRejectModal",
			controller: 'rejectModalInstanceCtrl',
			controllerAs: '$ctrl',
			size: size,
			appendTo: parentElem,
			resolve: 
			{			
				str: function () {
					return vm.str;
				},
				rejectReason: function () {
					return vm.rejectReason;
				}				 
			}
		});
		
		return rejectModalInstance;
	};
	
	function openWorkflowModal(size, parentSelector) {
		
		var parentElem = parentSelector 
			? angular.element($document[0].querySelector(parentSelector)) 
			: undefined;
		
		var workflowModalInstance = $uibModal.open(	{
			animation: true,
			ariaLabelledBy: 'modal-title',
			ariaDescribedBy: 'modal-body',
			templateUrl:"index.cfm?action=nsm:nsm.viewWorkflowModal",
			controller: 'workflowModalInstanceCtrl', 
			controllerAs: '$ctrl',
			size: size,
			appendTo: parentElem,
			resolve: 
			{					
				str: function () {
					return vm.str;
				},
				wf: function () {
					return vm.nsm_wf;
				}				 
			}
		});
		
		return workflowModalInstance;
	};	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Misc functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
	
	function loaded(partial){
		console.log("loaded", partial);
	}
	
	function refreshGroup(grp){
		
		console.log("refreshGroup");
		
		switch(grp) {
			case "co": vm.coGroup = !vm.coGroup; break;
			case "gd": vm.gdGroup = !vm.gdGroup; break;
			case "fd": vm.fdGroup = !vm.fdGroup; break;
			case "ed": vm.edGroup = !vm.edGroup; break;
			case "pe": vm.peGroup = !vm.peGroup; break;
		}		
	}
	
	function refreshAllGroups(){		
	
		console.log("refreshAllGroups");
		
		vm.coGroup = !vm.coGroup;
		vm.gdGroup = !vm.gdGroup;
		vm.fdGroup = !vm.fdGroup;
		vm.edGroup = !vm.edGroup;
		vm.peGroup = !vm.peGroup;			
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	vm.setTab = setTab;	
	vm.loaded = loaded;	
	
	vm.WF_Start = WF_Start;
	vm.WF_Accept = WF_Accept;
	vm.WF_Reject = WF_Reject;		
	
	vm.openRejectModal = openRejectModal;
	vm.openWorkflowModal = openWorkflowModal;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			
	
	initCtrl();
	
}]);

