<div ng-controller="ideasCtrl">

IDEAS.CFM
<br />
name: {{name}}
<br />

<input type="text" ng-model="name"> {{name}}
<br />
<button ng-click="switchListDetail()">Switch</button>

</div>

<script>

app.cp.register('ideasCtrl',function($scope){	

	console.log("ideas controller loaded!");  
    $scope.name = 'Ideas Controller';	
    
});

</script>