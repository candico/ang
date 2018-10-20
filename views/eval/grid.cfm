<script src="views/eval/js/grid.js"></script>

<div ng-controller="evalGridController as evalGridCtrl" class="gridContainer">		
   
   	<ng-switch on="evalGridCtrl.gridOrDetail">    	
    
    <div ng-switch-when="grid">   
        <ul class="nav nav-tabs">
            <li ng-class="{active: true}">
                <a data-toggle="tab">{{ evalGridCtrl.lib.EVALUATIONS }}</a>
            </li>                              
        </ul>  
        
        <div ng-show="evalGridCtrl.rowCount > 0" class="tab-content extra-tab"> 
	        <div class="tab-pane" ng-class="{active: true}"> 
        	    <div id="grid1" ui-grid="evalGridCtrl.gridOptions" ui-grid-selection class="grid" style="margin:20px"></div>    
			</div>
		</div>   
        
        <div ng-show="evalGridCtrl.rowCount == 0" class="tab-content extra-tab"> 
            <div style="padding:50px">
               <h3>There are no results to display.</h3>
            </div>           
		</div>         
                        
    </div>   
    
  	<div ng-switch-when="detail"> 
		<div ng-include="evalGridCtrl.evalURL"></div>   
    </div>       
    
    <nav ng-switch-when="grid" class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">                 
<cfif rc.chkAddEvaluation EQ "Y"> 
			<button class="btn btn-success navbar-btn" ng-click="evalGridCtrl.newEval()">{{ evalGridCtrl.lib.NEW_EVAL }}</button>	
</cfif>  
            <ul class="nav navbar-nav navbar-right">  
                <li><a ng-click="evalGridCtrl.changeLanguage()" class="pointer-cursor">{{ evalGridCtrl.lib.CHANGE_LANGUAGE }}</a></li>        	
            </ul>      
                        
        </div>
    </nav>   
    
    </ng-switch>   
    
</div>

