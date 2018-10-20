<script src="views/nsm/js/grid.js"></script>

<style type="text/css">

.pointer-cursor{
	cursor:pointer;
}

.ui-grid-cell-contents {
  cursor: pointer;
}

</style>

<div ng-controller="nsmGridController as gridCtrl" class="gridContainer">		
   
   	<ng-switch on="gridCtrl.toggleGridDetail">    	
    
    <div ng-switch-when="grid">
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: true}">
                <a data-toggle="tab">National Staff</a>
            </li>                              
        </ul>  
        
        <div ng-show="gridCtrl.rowCount > 0" class="tab-content extra-tab"> 
	        <div class="tab-pane" ng-class="{active: true}"> 
        	    <div id="grid1" ui-grid="gridCtrl.gridOptions" ui-grid-selection class="grid" style="margin:20px"></div>    
			</div>
		</div>  
        
        <div ng-show="gridCtrl.rowCount == 0" class="tab-content extra-tab"> 
            <div style="padding:50px">
               <h3>There are no results to display.</h3>
            </div>           
		</div>          
                                 
    </div>    
    
  	<div ng-switch-when="detail"> 
		<div ng-include="gridCtrl.nsmEditURL"></div>   
    </div>    
    
    </ng-switch>  
    
</div>

