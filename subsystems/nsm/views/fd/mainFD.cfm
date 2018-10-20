<div ng-if = "tabsCtrl.fdGroup === true">

<script src="subsystems/nsm/views/fd/js/mainFD.js"></script>

<div ng-controller="nsmMainFdController as mainFdCtrl">	
    
    <div ng-show="mainFdCtrl.fdTabMode == 'view'">
	    <div ng-include="mainFdCtrl.viewFdUrl"></div>
    </div>
    
    <div ng-show="mainFdCtrl.fdTabMode == 'edit'">             
    	<div ng-include="mainFdCtrl.editFdUrl"></div>                
    </div>      

</div>

</div>

<div ng-if = "tabsCtrl.fdGroup === false">

<script src="subsystems/nsm/views/fd/js/mainFD.js"></script>

<div ng-controller="nsmMainFdController as mainFdCtrl">	
    
    <div ng-show="mainFdCtrl.fdTabMode == 'view'">
	    <div ng-include="mainFdCtrl.viewFdUrl"></div>
    </div>
    
    <div ng-show="mainFdCtrl.fdTabMode == 'edit'">             
    	<div ng-include="mainFdCtrl.editFdUrl"></div>                
    </div>      

</div>

</div>