
      app.config(['$routeProvider', '$locationProvider',
      function($routeProvider, $locationProvider) {
          $routeProvider.when('/', {
              controller: 'MainCtrl'
          }).when('/room/:id', {
              controller: 'RoomCtrl',
          }).when('/dashboard', {
              controller: 'DashboardCtrl'            
          }).otherwise({
              redirectTo: '/'
          });
          $locationProvider.html5Mode(false);
      }]);    
  
      app.controller('TabCtrl',['$scope', function($scope) {
		  
        $scope.tabs = [{
          slug: 'dashboard',
          title: "Dashboard",
          content: "<div>Your Dashboard! controllerName: {{controllerName}}</div>"
        }, {
          slug: 'room-1',
          title: "Room 1",
          content: "Dynamic content 1 - controllerName: {{controllerName}}"
        }, {
          slug: 'room-2',
          title: "Room 2",
          content: "Dynamic content 2 - controllerName: {{controllerName}}"
        }];
		
		 $scope.controllerName = "TabCtrl";
		
      }]);
	  
	  app.controller('RoomCtrl',['$scope', '$location', function($scope, $location) {
        	$scope.controllerName = "RoomCtrl";
      }]);
      
      app.controller('DashboardCtrl',['$scope', '$location', function($scope, $location) {
	        $scope.controllerName = "DashboardCtrl";
      }]); 	
  
      app.controller('MainCtrl', ['$scope', '$location', function($scope, $location) {
		  
		  $scope.controllerName = "MainCtrl";
		  
		  $scope.tabDynamicContent = "<strong>This is some html fetched via ajax</strong>";
        
        $scope.onTabSelected = function(tab) {
			console.log("tab", tab);
          var route;
          if (typeof tab === 'string') {
            switch (tab) {
              case 'dashboard':
                route = tab;
                break;
              default:
                route = 'rooms/' + tab;
                break;
            }
          }
          $location.path('/' + route);
        };
        
      }]);