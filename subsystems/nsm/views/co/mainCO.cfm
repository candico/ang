<script src="subsystems/nsm/views/co/js/mainCO.js"></script>

<!---<div ng-controller="nsmMainCoController as mainCoCtrl">	

<ng-switch on="mainCoCtrl.coTabMode">  

    <div ng-switch-when="view">
	    <div ng-include="mainCoCtrl.viewCoUrl"></div>
    </div>
    
    <div ng-switch-when="edit">               
    	<div ng-include="mainCoCtrl.editCoUrl"></div>                
    </div> 
                   
</ng-switch>  

</div>--->



<div ng-if = "tabsCtrl.coGroup === true">

<!---<script src="subsystems/nsm/views/co/js/mainCO.js"></script>--->

<div ng-controller="nsmMainCoController as mainCoCtrl">	

   <div ng-show="mainCoCtrl.coTabMode == 'view'">
	    <div ng-include="mainCoCtrl.viewCoUrl"></div>
    </div>
    
    <div ng-show="mainCoCtrl.coTabMode == 'edit'">             
    	<div ng-include="mainCoCtrl.editCoUrl"></div>                
    </div>  

</div>

</div>

<div ng-if = "tabsCtrl.coGroup === false">

<!---<script src="subsystems/nsm/views/co/js/mainCO.js"></script>--->

<div ng-controller="nsmMainCoController as mainCoCtrl">	

   <div ng-show="mainCoCtrl.coTabMode == 'view'">
	    <div ng-include="mainCoCtrl.viewCoUrl"></div>
    </div>
    
    <div ng-show="mainCoCtrl.coTabMode == 'edit'">             
    	<div ng-include="mainCoCtrl.editCoUrl"></div>                
    </div>  

</div>

</div>