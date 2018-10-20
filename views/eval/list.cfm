<script src="views/eval/js/list.js"></script>

<style type="text/css">

.pointer-cursor{
	cursor:pointer;
}

.ui-grid-cell-contents {
  cursor: pointer;
}

</style>

<div ng-controller="evalListController as evalListCtrl" class="gridContainer">		
   
   	<ng-switch on="evalListCtrl.toggleListDetail">    	
    
    <div ng-switch-when="list">
        <ul class="nav nav-tabs">
            <li ng-class="{active: true}">
                <a data-toggle="tab">Evaluations</a>
            </li>                              
        </ul>  
        <div class="tab-content extra-tab"> 
	        <div class="tab-pane" ng-class="{active: true}"> 
        	    <div id="grid1" ui-grid="evalListCtrl.gridOptions" ui-grid-selection class="grid" style="margin:20px"></div>    
			</div>
		</div>                           
    </div>    
    
  	<div ng-switch-when="detail"> 
		<div ng-include="evalListCtrl.evalEditURL"></div>   
    </div>    
    
    </ng-switch>  
    
    <nav ng-switch-when="list" class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">
            <ul class="nav navbar-nav"> 
                <li><a ng-click="evalListCtrl.changeLanguage()" class="pointer-cursor">Change Language</a></li>        	
            </ul>
            <ul class="nav navbar-nav-right">     
<cfif rc.canAddEvaluation>  
                <li><a ng-click="evalListCtrl.newEval()" class="pointer-cursor">New Evaluation</a></li> 
</cfif>       
            </ul>            
        </div>
    </nav>     
    
</div>

