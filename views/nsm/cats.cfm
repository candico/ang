<div ng-controller="catsCtrl">

CATS.CFM
<br />
name: {{name}}
<br />

</div>

<script>

app.cp.register('catsCtrl',function($scope){	

	console.log("cats controller loaded!");  
    //$scope.name = 'Cats Controller';	
    
});

</script>