component accessors="true" {

    property followupService;

	public any function setFramework( fw ) { variables.fw = fw; return this; }

	public any function before() {}

	public any function onMissingMethod() {
		local.res = invoke(variables.followupService, arguments.missingMethodName, arguments.missingMethodArguments.rc);
		if (structKeyExists(local, 'res')) variables.fw.renderData("json", local.res);
	}

	public any function after() {}

}