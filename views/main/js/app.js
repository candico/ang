
var app = angular.module('app', ['ngTouch', 'ui.grid', 'ui.grid.selection', 'ui.grid.cellNav', 'ngMessages', 'ui-notification', 'ui.bootstrap', 'ngAnimate', 'ngSanitize'])
.config(function($controllerProvider, $compileProvider) {
    app.cp = $controllerProvider;
	app.co = $compileProvider;
});

//From https://www.sitepoint.com/url-parameters-jquery/
$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results == null){
       return $.sesUrlParam(name);
    }
    else{
       return results[1] || 0;
    }
}

$.sesUrlParam = function(name){
    var results = new RegExp('/' + name + '/([^/#]*)').exec(window.location.href);
    if (results == null){
       return null;
    }
    else{
       return results[1] || 0;
    }
}	

/*(function () {
    angular.module('ui.grid')
      .service('NsmService', ['$http', NsmService]);

    function NsmService($http) {
        var self = this;
        var baseUrl = 'index.cfm?b=1&action=staff';
        var extraHeaders = {
            'X-Requested-With':'XMLHttpRequest'
        };
        var item = 'getNSMListData';
        self.readAll = function () {
            return $http({
                method: 'GET',
                url: baseUrl + "." + item,
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.readOne = function (id) {
            return $http({
                method: 'GET',
                url: baseUrl + objectName + '/' + id,
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.create = function (data) {
            return $http({
                method: 'POST',
                url: baseUrl + objectName,
                data: data,
                params: {
                    returnObject: true
                },
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.update = function (id, data) {
            return $http({
                method: 'PUT',
                url: baseUrl + objectName + '/' + id,
                data: data,
                headers: extraHeaders
            }).then(function (response) {
                return response.data;
            });
        };
        self.delete = function (id) {
            return $http({
                method: 'DELETE',
                url: baseUrl + objectName + '/' + id,
                headers: extraHeaders
            });
        };
    }
}());*/

