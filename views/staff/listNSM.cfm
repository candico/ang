<script src="views/staff/js/listNSM.js"></script>

<div ng-controller="MainCtrl" class="gridContainer">

	<button type="button" class="btn btn-success" ng-click="toggleRowSelection()">Toggle Row Selection</button>  
    <strong>RowSelection:</strong>
    <span ng-bind="gridApi.grid.options.enableRowSelection"></span>
	<div id="grid1" ui-grid="gridOptions" ui-grid-selection class="grid"></div> 
    
    viewable: {{viewable}}
    
</div>

