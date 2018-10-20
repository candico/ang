<script src="subsystems/eval/views/sass/js/set.js"></script>

<cfoutput>

<div ng-controller="setSassController as setSassCtrl" ng-cloak>	

<ng-switch on="setSassCtrl.viewOrEdit"> 

  	<div ng-switch-when="view"> 
		<div ng-include="setSassCtrl.viewEvalURL"></div>   
    </div>  
    
  	<div ng-switch-when="edit"> 
		<div ng-include="setSassCtrl.editEvalURL"></div>   
    </div>  
    
</ng-switch> 

</div>

</cfoutput>