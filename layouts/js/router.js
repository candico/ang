app.config(function ($stateProvider, $urlRouterProvider) {
    $stateProvider
/*        .state('home', {
            url: '/',
            templateUrl: 'index.cfm?action=main.info&jx&id=1414',
            controller: 'tasksGridController'
        }) */       
        .state('changeOffice', {
            url: '/office/:officeId',
            templateUrl: 'views/fom/tabs.html',
            controller: 'fomController',
            resolve: {
                userData: function(masterService, $stateParams, $q, $sessionStorage) {
                    var deferred = $q.defer();
                    masterService.get('main', 'setOffice', {office_id: $stateParams.officeId})
                    .then(
                        function(response) {
                            $sessionStorage.userData = angular.copy(response);
                            deferred.resolve({data: $sessionStorage.userData});
                        }
                    );
                    return deferred.promise;
                }
            }
        })
/*        .state('staff', {
            url: '/staff',
            templateUrl: 'index.cfm?action=nsm:nsm.grid&id=5555&jx',
            controller: 'nsmGridController'
        })*/
        .state('evaluations', {
            url: '/evaluations',
            template: '<ui-view></ui-view>',
            abstract: true,
            resolve: {
                evalTypes: function(masterService){
                    return masterService.get("eval:eval", "getEvalTypes");
                },
                userData: function(masterService){
                    return masterService.get("eval:eval", "getUserData");
                },
                userSettings: function(settingsService){
                    return settingsService.get();
                },              
                /*sharedStrings: function(masterService){
                    return masterService.get("common", "getStrings", {dom: 'SHARED'});
                },*/
                evalStrings: function(masterService){
                    return masterService.get("common", "getStrings", {dom: 'EVM'});
                }
            },
            controller: function($scope, /*sharedStrings,*/ evalStrings) {
                $scope.lib = {};
                //$scope.lib = angular.merge($scope.lib, sharedStrings.LIB);
                $scope.lib = angular.merge($scope.lib, evalStrings.LIB);
             }
        })
        .state('evaluations.list', {
            url: '/list',
            templateUrl: 'subsystems/eval/views/eval/grid.html',
            controller: 'evalGridController'          
        })
        .state('evaluations.details', {
            url: '/:evalId',
            template: '<ui-view></ui-view>',
            controller: 'evalTabsController',
            abstract: true,
            resolve: {
                offices: function(masterService){
                    return masterService.get("eval:prep", "getOffices");
                },
                usersByRole: function(masterService, $stateParams){
                    if ($stateParams.viewEdit == 'new') {
                        return {};
                    } else {
                        return masterService.get("eval:eval", "getUsersByRole", {evalId: $stateParams.evalId});
                    }
                },
                documents: function(masterService, $stateParams){
                    if ($stateParams.viewEdit == 'new') {
                        return {};
                    } else {
                        return masterService.get("eval:eval", "getDocuments", {id: $stateParams.evalId});
                    }
                },
                evaluation: function(masterService, $stateParams){
                    if ($stateParams.viewEdit == 'new') {
                        return {};
                    } else {
                        return masterService.get("eval:prep", "getPrepData", {id: $stateParams.evalId});
                    }
                }
            }
        })
        .state('evaluations.details.preparation', {
            url: '/preparation/:viewEdit',
            templateUrl: 'subsystems/eval/views/eval/tabs.html',
            controller: 'preparationController',
            /*templateUrl: function ($stateParams){
                return ($stateParams.statusId==1) ? 'subsystems/eval/views/eval/tabs.html' : 'subsystems/eval/views/eval/grid.html';
            },*/
            /*controller: function ($stateParams){
                return ($stateParams.statusId==1) ? 'preparationController' : 'evalGridController';
            },*/
            params: { viewEdit: 'view' }
        })
        /*.state('evaluations.new', {
            url: '/:evalType',
            template: '<ui-view></ui-view>',
            abstract: true,
            resolve: {
                evalueeDetails: function(){ return {}; }
            }
        })*/
        /*.state('evaluations.details.newPreparation', {
            url: '/preparation/:viewEdit',
            //templateUrl: 'subsystems/eval/views/preparation/preparation.html',
            templateUrl: 'subsystems/eval/views/eval/tabs.html',
            controller: 'preparationController',
            params: { viewEdit: 'new' }
        })*/
        .state('evaluations.details.selfassessment', {
            url: '/selfassessment/:viewEdit',
            //templateUrl: function ($stateParams){ return 'index.cfm?action=eval:eval.tabs&jx&eval_id=' + $stateParams.evalId;},
            templateUrl: 'subsystems/eval/views/eval/tabs.html',
            controller: 'setSassController',
            params: { viewEdit: 'view' }
        })
        .state('evaluations.details.feedback', {
            url: '/feedback/:viewEdit',
            templateUrl: 'subsystems/eval/views/eval/tabs.html',
            controller: 'feedbackController',
            params: { viewEdit: 'view' }
        })
        .state('evaluations.details.evaluation', {
            url: '/evaluation/:viewEdit',
            templateUrl: 'subsystems/eval/views/eval/tabs.html',
            controller: 'setSassController', // re-use of selfassesment
            params: { viewEdit: 'view' }
        })
        .state('evaluations.details.closure', {
            url: '/closure/:viewEdit',
            templateUrl: 'subsystems/eval/views/eval/tabs.html',
            controller: 'closureController',
            params: { viewEdit: 'view' }
        })
        .state('evaluations.details.followup', {
            url: '/followup/:viewEdit',
            templateUrl: 'subsystems/eval/views/eval/tabs.html',
            controller: 'followupController',
            params: { viewEdit: 'view' },
            resolve: {
                followUps: function(masterService, $stateParams){
                    return masterService.get("eval:followup", "getFollowUps", $stateParams);
                },
                followUpTypes: function(masterService){
                    return masterService.get("eval:followup", "getFollowUpTypes");
                }
            }
        })
        ;

    //$urlRouterProvider.otherwise('/');
});