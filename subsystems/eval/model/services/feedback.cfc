component accessors="true" {

    property feedbackDao;
    property commonDao;

	public any function onMissingMethod() {
        local.res = invoke(variables.feedbackDao, arguments.missingMethodName, arguments.missingMethodArguments);
		return variables.commonDao.QueryToArray( local.res );
	}
}