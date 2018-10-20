
app.controller('rootController', ['$rootScope', '$scope', 'settingsService', '$q', '$localStorage', '$sessionStorage', 'masterService',
	function ($rootScope, $scope, settingsService, $q, $localStorage, $sessionStorage, masterService) {

		console.log("rootController called [layouts/js/default.js]");

		var vm = this;
		vm.displayLanguage;

		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
		// Initialization
		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

		function initCtrl(mode) {
			settingsService.get("rootController").then(function (resp) {
				settings = resp.data;
				vm.displayLanguage = settings.displayLanguage;
				officeId = settings.current_field_office_id;
				vm.currentFieldOfficeId = officeId;
				vm.currentFieldOfficeCity = settings.current_field_office_city;
				var p1 = setStrings(vm.displayLanguage);

				$q.all([p1]).then(function (values) {
					return;
				})
			});
		}

		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
		// Interface functions
		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

		function setLang(lang) {
			if (lang == vm.displayLanguage)
				return;
			console.log("setLang to: ", lang);
			settingsService.set("displayLanguage", lang).then(function () {
				$rootScope.$broadcast('languageChanged', { lang: lang });
			});
		}

		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
		// Language functions
		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-		

		function setStrings(langCode) {
			var p1 = stringsService.get(langCode, "SHARED");

			return $q.all([p1]).then(function (values) {
				var JS = Object.assign({}, values[0].data.JS, values[1].data.JS);
				var STR = Object.assign({}, values[0].data.LIB, values[1].data.LIB);
				vm.strings["JS"] = JS;
				vm.strings["STR"] = STR;
				vm.js = vm.strings["JS"];
				vm.str = vm.strings["STR"];
				return $q.resolve();
			});
		}

		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
		// Exported functions
		// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-			

		vm.setLang = setLang;

	}]);

app.controller('notificationController', function ($scope, Notification) { });

