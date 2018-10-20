<script src="subsystems/nsm/views/nsm/js/grid.js"></script>

<div ng-controller="nsmGridController as nsmGridCtrl">	

    <div class="container-fluid">      
    
		<div ng-if="nsmGridCtrl.hasGrid === true">    
    
            <div ng-if="nsmGridCtrl.isGridSet === true" ng-show="nsmGridCtrl.toggleGridDetail == 'grid'"> 
            
                <ul class="nav nav-tabs">
                    <li ng-class="{active: true}">
                        <a data-toggle="tab">{{ nsmGridCtrl.str.STAFF_MEMBERS }}</a>
                    </li>                              
                </ul> 
                 
                <div class="tab-content extra-tab"> 
                    <div class="panel">
                        <div class="panel-body"> 
                            <div class="tab-pane" ng-class="{active: true}"> 
                                <div id="nsmGrid" ui-grid="nsmGridCtrl.gridOptions" ui-grid-selection class="grid"></div>    
                            </div>
                        </div>  
                    </div>
                </div> 
                
                <nav class="navbar navbar-inverse navbar-fixed-bottom"> 
                    <div class="container-fluid">  
                    
    <cfif rc.canAddStaffMember EQ "Y">   
                        <button class="btn btn-success navbar-btn" name='add_nsm' value="add_nsm" ng-click="nsmGridCtrl.addStaffMember('LOC')">{{ nsmGridCtrl.str.ADD_NATIONAL_STAFF_MEMBER }}</button>	 
    </cfif>            
                    </div>
                </nav>              
                                
            </div>   
            
            <div ng-show="nsmGridCtrl.toggleGridDetail == 'detail'"> 
                        
                <div ng-include="nsmGridCtrl.nsmTabsURL"></div> 
                
            </div>          
        
		</div>   
        
        <div ng-if="nsmGridCtrl.hasGrid === false">   
        
        	<div ng-include="nsmGridCtrl.nsmTabsURL"></div> 
        
        </div>         
   
   </div>  
    
</div>

