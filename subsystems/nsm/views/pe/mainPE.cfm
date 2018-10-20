<div ng-if = "tabsCtrl.peGroup === true">

<script src="subsystems/nsm/views/pe/js/mainPE.js"></script>

<div ng-controller="nsmMainPeController as mainPeCtrl">	

    <div ng-show="mainPeCtrl.peTabMode == 'view'">
	    <div ng-include="mainPeCtrl.viewPeUrl"></div>
    </div>
    
    <div ng-show="mainPeCtrl.peTabMode == 'edit'">             
    	<div ng-include="mainPeCtrl.editPeUrl"></div>                
    </div>  

</div>

</div>

<div ng-if = "tabsCtrl.peGroup === false">

<script src="subsystems/nsm/views/pe/js/mainPE.js"></script>

<div ng-controller="nsmMainPeController as mainPeCtrl">	

    <div ng-show="mainPeCtrl.peTabMode == 'view'">
	    <div ng-include="mainPeCtrl.viewPeUrl"></div>
    </div>
    
    <div ng-show="mainPeCtrl.peTabMode == 'edit'">             
    	<div ng-include="mainPeCtrl.editPeUrl"></div>                
    </div>  

</div>

</div>