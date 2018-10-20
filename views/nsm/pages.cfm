<!---<div ng-controller="pagesCtrl">

PAGES.CFM
<br />
name: {{name}}

</div>

<script>

app.cp.register('pagesCtrl',function($scope){	

	console.log("pages controller loaded!");  
    $scope.name = 'Pages Controller';
    
});

</script>--->


<div ng-controller="tabsX2">

    <ul class="nav nav-tabs">
<!---        <li ng-class="{active: main2.active.tab == 'info'}">
            <a ng-click='main2.active.tab = "info"'>INFOX</a>            
        </li>   
        <li ng-class="{active: main2.active.tab == 'cats'}">
            <a ng-click='main2active2.tab = "cats"'>CATSX</a>
        </li> --->   
        <li ng-class="{active: main2.active.tab == 'ideas'}">    
            <a ng-click='main2.active.tab = "ideas"'>IDEASX</a>
        </li>   
    </ul>
    
    <div class="tab-content">
        
<!---           <div ng-show='main2.active.tab == "info"'>            
            	<div ng-include="'index.cfm?action=nsm.info&jx'"></div>
            </div>
            <div ng-show='main2.active.tab == "cats"'>
                <div ng-include="'index.cfm?action=nsm.cats&jx'"></div>
            </div>--->
            <div ng-show='main2.active.tab == "ideas"'>
                <div ng-include="'index.cfm?action=nsm.ideas&jx'"></div>
            </div>          
            
        </div>     
 </div>
 
 <script>

 app.cp.register('tabsX2', function ($scope) {	
	
	$scope.main2 = {};
	$scope.main2.active = {};
    $scope.main2.active.tab = {};
    $scope.main2.active.tab = "ideas";
	
	$scope.name = "Ben";
    
    console.log("loaded2");    
	
 });

</script>



