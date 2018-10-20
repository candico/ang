<div ng-if = "tabsCtrl.edGroup === true">

<script src="subsystems/nsm/views/ed/js/mainED.js"></script>

<div ng-controller="nsmMainEdController as mainEdCtrl">	

    <div ng-show="mainEdCtrl.edTabMode == 'view'">
	    <div ng-include="mainEdCtrl.viewEdUrl"></div>
    </div>
    
    <div ng-show="mainEdCtrl.edTabMode == 'edit'">             
    	<div ng-include="mainEdCtrl.editEdUrl"></div>                
    </div>  

</div>

</div>

<div ng-if = "tabsCtrl.edGroup === false">

<script src="subsystems/nsm/views/ed/js/mainED.js"></script>

<div ng-controller="nsmMainEdController as mainEdCtrl">	

    <div ng-show="mainEdCtrl.edTabMode == 'view'">
	    <div ng-include="mainEdCtrl.viewEdUrl"></div>
    </div>
    
    <div ng-show="mainEdCtrl.edTabMode == 'edit'">             
    	<div ng-include="mainEdCtrl.editEdUrl"></div>                
    </div>  

</div>

</div>