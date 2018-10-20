component accessors="true" {

    property followupDao;
    property commonDao;

	public any function onMissingMethod() {
        local.res = invoke(variables.followupDao, arguments.missingMethodName, arguments.missingMethodArguments);
		return variables.commonDao.QueryToArray( local.res );
	}
}