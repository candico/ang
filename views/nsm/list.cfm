<script src="views/nsm/js/list.js"></script>

<style type="text/css">

.pointer-cursor{
	cursor:pointer;
}

.ui-grid-cell-contents {
  cursor: pointer;
}

</style>

<div ng-controller="nsmListController as listCtrl" class="gridContainer">		
   
   	<ng-switch on="listCtrl.toggleListDetail">    	
    
    <div ng-switch-when="list">
        <ul class="nav nav-tabs">
            <li ng-class="{active: true}">
                <a data-toggle="tab">National Staff</a>
            </li>                              
        </ul>  
        <div class="tab-content extra-tab"> 
	        <div class="tab-pane" ng-class="{active: true}"> 
        	    <div id="grid1" ui-grid="listCtrl.gridOptions" ui-grid-selection class="grid" style="margin:20px"></div>    
			</div>
		</div>                           
    </div>    
    
  	<div ng-switch-when="detail"> 
		<div ng-include="listCtrl.nsmEditURL"></div>   
    </div>    
    
    </ng-switch>  
    
</div>

