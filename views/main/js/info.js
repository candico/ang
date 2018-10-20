app.cp.register('tasksGridController', ['$scope', '$http', '$interval', 'uiGridConstants', 'userService', 'dataService', 'settingsService', 'mailService', 'navService', 'masterService', '$q', 
function ($scope, $http, $interval, uiGridConstants, userService, dataService, settingsService, mailService, navService, masterService, $q) {	
		
	console.log("tasksGridController loaded!");  
	
	var settings; 	
	
	var vm = this; 	
	vm.rowCount = -1;		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function initCtrl() {				
		settingsService.get("tasksGridController").then(function(resp){				
			var data = resp.data;
			vm.currentFieldOfficeId = data.current_field_office_id;
			vm.currentFieldOfficeCity = data.current_field_office_city;				
			loadGridData(vm.currentFieldOfficeId);	
		});				
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Grid functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
		
	vm.gridOptions = {
		enableRowSelection: true, 
		enableRowHeaderSelection: false,
		excludeProperties: '__metadata',
		multiSelect: false,	
		modifierKeysToMultiSelect: false,
		noUnselect: true
	};
	
	vm.gridOptions.columnDefs = [
		{ field: 'module', displayName:"Module" },
		{ field: 'office_id', displayName:"Office ID" },
		{ field: 'id', displayName:"ID" },
		{ field: 'initiator', displayName:"Initiator"},
		{ field: 'since', displayName:"Since"},
		{ field: 'prompt', displayName: "Action"}	
	];	
			
	vm.gridOptions.onRegisterApi = function( gridApi ) {
		vm.gridApi = gridApi;			
		gridApi.selection.on.rowSelectionChanged($scope, function(row){
			//$interval( function() { editNsm(row.entity.staff_member_id); }, 100, 1);
			$interval( function() { openModule(row.entity.office_id, row.entity.module, row.entity.id); }, 100, 1);
		});
	};	

    function loadGridData(fieldOfficeId) {		
        userService.getTasks().then(function (resp) {
			var data = resp.data;
			vm.gridOptions.data = data;  			
			vm.rowCount = data.length;	
			var cappedRowCount = Math.min(data.length, 10);	
			var headerHeight = 32;
			var rowHeight = 30;
			var paddingHeight = 0;
			var newHeight = headerHeight + paddingHeight + (cappedRowCount * rowHeight);	
			newHeight = newHeight < 100  ? 100 : newHeight ;
			$("#tasksGrid").css('height',  newHeight + 'px');
        });		
		//to set an interval so the grid can populate before autoselecting the first row (shouldn't there be a widgetReady event?)
		 //$interval( function() {vm.gridApi.selection.selectRow(vm.gridOptions.data[0]);}, 0, 1);
    }
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Mail Test functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function prepareMessages(){
		mailService.prepareMessages();
	}
	
	function sendMessages(){
		mailService.sendMessages();
	}	
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Events
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	$scope.$on('fomAction', function(event, args) {		
		console.log("fomAction broadcast", event, args);	
		initCtrl(); 
	});		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Navigation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	$scope.$on('navAction', function(event, args) {		
		console.log("info.js: navAction broadcast", event, args);			
	});			
	
	function openModule(fieldOfficeId, module, id){
		console.log("openModule", module, id);
		p1 = masterService.get('main', 'setOffice', {office_id: fieldOfficeId});				
		//p2 = userService.setOffice(fieldOfficeId);
		
		$q.all([p1]).then(function(values){ 					
			navObject = {};
			navObject.module = module;
			navObject.id = id;			
			navService.open(navObject);		
			//console.log("dataService", dataService.get("nav", "navAction") );				
		});
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	vm.prepareMessages = prepareMessages;
	vm.sendMessages = sendMessages;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	initCtrl();    
	
}]);

