<div ng-if = "tabsCtrl.gdGroup === true">

<script src="subsystems/nsm/views/gd/js/mainGD.js"></script>

<div ng-controller="nsmMainGdController as mainGdCtrl">	

   <div ng-show="mainGdCtrl.gdTabMode == 'view'">
	    <div ng-include="mainGdCtrl.viewGdUrl"></div>
    </div>
    
    <div ng-show="mainGdCtrl.gdTabMode == 'edit'">             
    	<div ng-include="mainGdCtrl.editGdUrl"></div>                
    </div>  

</div>

</div>

<div ng-if = "tabsCtrl.gdGroup === false">

<script src="subsystems/nsm/views/gd/js/mainGD.js"></script>

<div ng-controller="nsmMainGdController as mainGdCtrl">	

   <div ng-show="mainGdCtrl.gdTabMode == 'view'">
	    <div ng-include="mainGdCtrl.viewGdUrl"></div>
    </div>
    
    <div ng-show="mainGdCtrl.gdTabMode == 'edit'">             
    	<div ng-include="mainGdCtrl.editGdUrl"></div>                
    </div>  

</div>

</div>