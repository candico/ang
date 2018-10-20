<script src="views/main/js/info.js"></script>

<div ng-controller="tasksGridController as tasksGridCtrl">

    <div class="panel" id="info-panel">
    
        <div class="panel-body"> 
        
            <div class="panel panel-default" id="info-panel">
            
                <div class="panel-heading">  
                    <h4>Current Pending Tasks</h4>
                </div> 
                
                <div class="panel-body"> 
                
                    <div> 
                        <div ng-show="tasksGridCtrl.rowCount > 0" class="tab-content">                         
                            <div class="tab-pane" ng-class="{active: true}"> 
                                <div id="tasksGrid" ui-grid="tasksGridCtrl.gridOptions" ui-grid-selection class="grid"></div>    
                            </div>
                        </div> 
                        
                        <div ng-show="tasksGridCtrl.rowCount == 0" class="tab-content"> 
                            <span>You have currently no pending tasks.</span>
                        </div>
                        
                    </div>  <!---end controller--->
                    
                </div> <!---end panel body--->
                
            </div> <!---end panel --->
            
        </div> <!---end panel body--->
        
        
    </div> <!---end panel --->
    
    <nav class="navbar navbar-inverse navbar-fixed-bottom">
    	<div class="container-fluid">
		    <button class="btn btn-default navbar-btn" name='grid' value="grid" ng-click="tasksGridCtrl.prepareMessages()">
		    	Prepare Messages
		    </button> 
		    <button class="btn btn-default navbar-btn" name='grid' value="grid" ng-click="tasksGridCtrl.sendMessages()">
		    	Send Messages
		    </button>             
	    </div>
    </nav>

</div>
