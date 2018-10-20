app.cp.register('nsmGridController', ['$scope', '$http', '$interval', 'uiGridConstants', 'nsmGridService', 'dataService', 'settingsService', 'stringsService', '$q', 'navService',
function ($scope, $http, $interval, uiGridConstants, nsmGridService, dataService, settingsService, stringsService, $q, navService) {
	
	console.log("nsmGridController loaded!", $scope.$id);  
	
	var settings; 
	var gridData;	 
	
	var vm = this; 
	vm.displayLanguage;
	vm.strings = {}; 
	vm.isGridSet = false;		
	vm.hasGrid;	
	vm.toggleGridDetail;	
	
	ds = dataService;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialization
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	function initCtrl(param) {				
		settingsService.get("nsmGridController").then(function(resp){	
			console.log("nsmGridController called");
			
			var settings = resp.data;		
			vm.displayLanguage = settings.displayLanguage;
			officeId = settings.current_field_office_id;
			
			vm.currentFieldOfficeId = settings.current_field_office_id;
			vm.currentFieldOfficeCity = settings.current_field_office_city;	
			
			var p1 = setStrings(vm.displayLanguage);
			var p2 = dataService.get("nav", "navAction");	
			
			$q.all([p1, p2]).then(function(values){ 
				var staff_member_id;			
				var navObj = values[1];
				if(navObj && navObj.module == "nsm" && navObj.id)
					staff_member_id =  navObj.id;
						
				nsmGridService.readAll(vm.currentFieldOfficeId).then(function(resp) {
					gridData = resp.data;						
					if(gridData.length == 1){
						vm.hasGrid = false;		
						dataService.set("nsm","hasGrid", false);				
						viewStaffMember(gridData[0].staff_member_id);						
					} else if(staff_member_id) {	
						console.log("if");	
						vm.hasGrid = true;	
						dataService.set("nsm","hasGrid", true);	
						viewStaffMember(staff_member_id);		
					} else {
						console.log("else");
						vm.hasGrid = true;
						dataService.set("nsm","hasGrid", true);	
						setGrid();
						showGrid();	
					}
				})
			})	
		});				
	}	

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Grid functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	
	function setGrid(){		
		
		vm.gridOptions = {
			enableFiltering: true,
			enableRowSelection: true, 
			enableRowHeaderSelection: false,
			excludeProperties: '__metadata',
			multiSelect: false,	
			modifierKeysToMultiSelect: false,
			enableHorizontalScrollbar : uiGridConstants.scrollbars.WHEN_NEEDED,
			enableVerticalScrollbar: uiGridConstants.scrollbars.WHEN_NEEDED,
			noUnselect: true
		};
		
		vm.gridOptions.columnDefs = [
			{ field: 'staff_member_id', displayName:vm.js.STAFF_MEMBER_ID },
			{ field: 'contract_id', displayName:vm.js.CONTRACT_ID},
			{ field: 'start_date', displayName:vm.js.START_DATE},
			{ field: 'end_date', displayName:vm.js.END_DATE},
			{ field: 'last_name', displayName:vm.js.LNAME},
			{ field: 'first_name', displayName: vm.js.FNAME},	
			{ field: 'staff_type', displayName: vm.js.TYPE},
			{ field: 'fg', displayName: "FG"},
			{ field: 'office', displayName: vm.js.OFFICE}		
		];		
		
		vm.gridOptions.onRegisterApi = function( gridApi ) {
			vm.gridApi = gridApi;				
			gridApi.selection.on.rowSelectionChanged($scope, function(row){
				//$interval( function() { viewStaffMember(row.entity.staff_member_id); row.setSelected(false);}, 100, 1);
				$interval( function() { viewStaffMember(row.entity.staff_member_id); row.setSelected(false);}, 100, 1);
			});
		};
	
		vm.gridOptions.data = gridData;   
		var cappedRowCount = Math.min(gridData.length, 10);			
		var headerHeight = 32;
		var rowHeight = 30;
		var paddingHeight = 0;
		var newHeight = headerHeight + paddingHeight + (cappedRowCount * rowHeight);			
		$("#nsmGrid").css('height',  newHeight + 'px');					
		
		vm.isGridSet = true;
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Interface functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	function switchGridDetail() {
		if(vm.toggleGridDetail == "grid")
			showDetail();
		else
			showGrid();				
	}
	
	function showGrid(){
		if(vm.isGridSet)
			vm.toggleGridDetail = "grid";	
		else {			
			setGrid();
			vm.toggleGridDetail = "grid";
		}
	}
	
	function showDetail(){
		vm.toggleGridDetail = "detail";	
	}		
	
	function viewStaffMember(staffMemberId) {
		
			dataService.set("nsm", "staffMemberId", staffMemberId);	
			dataService.set("nsm", "gdTabMode", "view");	
			vm.nsmTabsURL = "index.cfm?action=nsm:nsm.tabs&jx=true&staff_member_id=" + staffMemberId;					
			showDetail();		
		
		
/*		NsmService.getStaffMemberDetails(staffMemberId).then( function(res){	
			//dataService.set("nsm", "staffMemberDetails", res);
			//dataService.set("nsm", "workflowDetails", res);	
			dataService.set("nsm", "staffMemberId", res.staff_member_id);	
			dataService.set("nsm", "gdTabMode", "view");	
			vm.nsmTabsURL = "index.cfm?action=nsm:nsm.tabs&jx=true&staff_member_id=" + res.staff_member_id;					
			showDetail();	
		});*/
		
	}
	
	function editStaffMember(staffMemberId) {
/*		NsmService.getStaffMemberDetails(staffMemberId).then( function(res){	
			dataService.set("nsm", "staffMemberDetails", res);	
			dataService.set("nsm", "staffMemberId", res.staff_member_id);	
			dataService.set("nsm", "gdTabMode", "edit");	
			vm.nsmTabsURL = "index.cfm?action=nsm:nsm.tabs&jx=true&staff_member_id=" + res.staff_member_id;					
			showDetail();	
		});*/
		
			dataService.set("nsm", "staffMemberId", staffMemberId);	
			dataService.set("nsm", "gdTabMode", "edit");	
			vm.nsmTabsURL = "index.cfm?action=nsm:nsm.tabs&jx=true&staff_member_id=" + staffMemberId;					
			showDetail();			
	}	
	
	function addStaffMember(type){		
		nsmGridService.addStaffMember(type).then( function(res){
			var newStaffMemberId = res.newStaffMemberId;	
			editStaffMember(newStaffMemberId);
		});			
	}
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Navigation functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	$scope.$on('navAction', function(event, args) {		
		console.log("grid.js: navAction broadcast", event, args);		
		if(args.module == "nsm")
			initCtrl();
	});	
	
	function openTab(staff_member_id) {
		console.log("openTab", staff_member_id);
		navObject = {};
		navObject.module = "nsm";
		navObject.staff_member_id = staff_member_id;			
		navService.open(navObject);		
		//console.log("dataService", dataService.get("nav", "navAction") );
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Language functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

	$scope.$on('languageChanged', function(event, args) {	
		console.log("Language change event in nsm/js/grid.js", args);	
				
		if(args.lang != vm.displayLanguage){
		
			vm.displayLanguage = args.lang;
			setStrings(args.lang).then(function(res) {	
				setGrid();					
			});			  		
		}
	});			
	
	function setStrings(langCode) {		
		var p1 = stringsService.get(langCode, "SHARED");		
		
		return $q.all([p1]).then(function(values){ 			
			var JS = values[0].data.JS;
			var LIB = values[0].data.LIB;			
			vm.strings["JS"] = JS;
			vm.strings["LIB"] = LIB;	
			vm.js = vm.strings["JS"];
			vm.lib = vm.strings["LIB"];
			vm.str = vm.strings["LIB"];						
		});	
	}		
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Exported functions
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	

	vm.switchGridDetail = switchGridDetail;
	vm.addStaffMember = addStaffMember;
	
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Initialize Controller
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		
	
	initCtrl();    
	
}]);

