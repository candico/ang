component accessors="true" {

    property closureDao;
    property commonDao;

	public any function onMissingMethod() {
        local.res = invoke(variables.closureDao, arguments.missingMethodName, arguments.missingMethodArguments);
		return variables.commonDao.QueryToArray( local.res );
	}
}