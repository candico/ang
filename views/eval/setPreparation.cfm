<script src="views/eval/js/setPreparation.js"></script>

<cfoutput>

<div ng-controller="setPreparationController as setPrepCtrl" ng-cloak>	

<ng-switch on="setPrepCtrl.viewOrEdit"> 

  	<div ng-switch-when="view"> 
		<div ng-include="setPrepCtrl.viewEvalURL"></div>   
    </div>  
    
  	<div ng-switch-when="edit"> 
		<div ng-include="setPrepCtrl.editEvalURL"></div>   
    </div>  
    
</ng-switch> 

</div>

</cfoutput>