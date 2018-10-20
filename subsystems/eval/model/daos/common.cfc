<cffunction name="QueryToArray" access="public" returntype="any" output="false" hint="This turns a query into an array of structures.">

	<!--- Define arguments. --->
	<cfargument name="Data" required="yes" />

	<cfif IsStruct(ARGUMENTS.Data)>
		<cfset var keysArr = StructKeyArray(ARGUMENTS.Data)>
		<cfset var ret = structNew()>
		<cfloop array="#keysArr#" index="itm">
			<cfif isQuery(ARGUMENTS.Data[itm])>
				<cfset ret[itm] = QueryToArray(ARGUMENTS.Data[itm])>
			<cfelseif IsStruct(ARGUMENTS.Data[itm])>
				<cfset ret[itm] = QueryToArray(ARGUMENTS.Data[itm])>
			<cfelse>
				<cfset ret[itm] = ARGUMENTS.Data[itm]>
			</cfif>
		</cfloop>
		<cfreturn ret>
	</cfif>

	<cfscript>

		// Define the local scope.
		var LOCAL = StructNew();

		// Get the column names as an array.
		LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );

		// Create an array that will hold the query equivalent.
		LOCAL.QueryArray = ArrayNew( 1 );

		// Loop over the query.
		for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

			// Create a row structure.
			LOCAL.Row = StructNew();

			// Loop over the columns in this row.
			for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

				// Get a reference to the query column.
				LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

				// Store the query cell value into the struct by key.
				LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

			}

			// Add the structure to the query array.
			ArrayAppend( LOCAL.QueryArray, LOCAL.Row );

		}
		
		// Return the array equivalent.
		//return( (ArrayLen(LOCAL.QueryArray) eq 1) ? LOCAL.QueryArray[1] : LOCAL.QueryArray );
		return( LOCAL.QueryArray );

	</cfscript>
    
</cffunction>


<cffunction name="CollectionToList" access="public" returntype="any" output="false" hint="This turns a Structure/Arrayy into an strincg as a list of values">
	<cfargument name="Data" required="yes" />
	<cfargument name="delimiter" required="no" default="," />
	<cfset var retList = "">

	<cfif isStruct(arguments.Data)>
		<cfloop item="currentKey" collection="#arguments.Data#">
			<cfif structKeyExists(arguments.Data, currentKey)>
				<cfset retList = listAppend(retList, arguments.Data[currentKey], arguments.delimiter)>
			</cfif>
		</cfloop>
	</cfif>

	<cfif isArray(arguments.Data)>
		<cfloop array="#arguments.Data#" index="currentItem">
			<cfset retList = listAppend(retList, currentItem, arguments.delimiter)>
		</cfloop>
	</cfif>

	<cfreturn retList>
</cffunction>


<cffunction name="StructureToArray" access="public" returntype="any" output="false" hint="This turns a Structure into an Array">
	<cfargument name="Data" required="yes">
	<cfset var retArr = arrayNew(1)>

	<cfloop item="currentKey" collection="#arguments.Data#"> 
		<cfif structKeyExists(arguments.Data, currentKey)>
			<cfset arrayAppend(retArr, arguments.Data[currentKey])>
		</cfif>
	</cfloop>
	
	<cfreturn retArr>
</cffunction>