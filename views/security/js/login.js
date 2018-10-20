app.controller('loginController', ['$scope', 'Notification', 'securityService', '$localStorage', '$sessionStorage',
function ($scope, Notification, securityService, $localStorage, $sessionStorage) {	

	var vm = this;	
	
	function validateLogin(){		
		securityService.validateLogin(vm.username).then(function(resp) {			
			var result = resp.data;	
			$sessionStorage.userData = angular.copy(resp.data);
			//Notification.info({message: "Status: " + result.status, positionY: 'top', positionX: 'right'});				
			if(resp.data.profile_id >= 1) {
				window.location = "index.cfm";		
			}
			else				
				Notification.info({message: "Validation Result: <br>" + result.error, positionY: 'top', positionX: 'right'});
		});			
	}
	
	vm.validateLogin = validateLogin;	
	
}]);	