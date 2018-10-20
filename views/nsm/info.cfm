<div ng-controller="infoCtrl">

INFO.CFM {{name}} 

<br>

<input type="text" ng-model="name"> {{name}}

</div>

<script>

app.cp.register('infoCtrl',function($scope){	

	console.log("info controller loaded!");  
    $scope.name = 'Info Controller';	
    
});

</script>

<cfoutput>

<cfloop from="1" to="5" index="i">

i: #i# <br />

<cfquery name="a#i#" datasource="#Application.settings.dsn#">
select
TRUNC(SYSDATE + DBMS_RANDOM.value(0,366)) as str,
'friend'
from
dual
</cfquery>

<cfset t = evaluate("a#i#")>

<cfdump var="#t#" label="loop #i#">

#t.str# <br />

</cfloop>

</cfoutput>