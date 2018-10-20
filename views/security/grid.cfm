<script src="views/security/js/grid.js"></script>

<style type="text/css">

.pointer-cursor{
	cursor:pointer;
}

.ui-grid-cell-contents {
  cursor: pointer;
}

</style>

<div ng-controller="logAsGridController as gridCtrl" class="gridContainer">	
    
    <div>
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: true}">
                <a data-toggle="tab">Log As</a>
            </li>                              
        </ul>  
        
        <div ng-show="gridCtrl.rowCount > 0" class="tab-content extra-tab"> 
	        <div class="tab-pane" ng-class="{active: true}"> 
        	    <div id="grid1" ui-grid="gridCtrl.gridOptions" ui-grid-selection ui-grid-pagination class="grid" style="margin:20px"></div>  
			</div>
		</div>               
                                 
    </div> 
    
</div>

