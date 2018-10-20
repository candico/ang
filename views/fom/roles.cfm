<cfoutput>

<script src="views/fom/js/roles.js"></script>

<div ng-controller="rolesController as rolesCtrl" ng-cloak>	

	<div class="container-fluid" style="margin-top:60px">  
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: rolesCtrl.activeTab == 'my_roles'}">
                <a data-toggle="tab" href="##my_roles" ng-click='rolesCtrl.setFomTab("my_roles")'>My Roles</a>
            </li>  
            <li ng-class="{active: rolesCtrl.activeTab == 'roles_from'}">
                <a data-toggle="tab" href="##roles_from" ng-click='rolesCtrl.setFomTab("roles_from")'>Roles from</a>
            </li>    
            <li ng-class="{active: rolesCtrl.activeTab == 'roles_to'}">
                <a data-toggle="tab" href="##roles_to" ng-click='rolesCtrl.setFomTab("roles_to")'>Roles to</a>
            </li>                                                   
        </ul>     
    
        <div class="tab-content extra-tab">         
           	<div id="my_roles" class="tab-pane" ng-class="{active: rolesCtrl.activeTab == 'my_roles'}">            
                 <div ng-include="rolesCtrl.tabs.my_roles && rolesCtrl.myRolesUrl"></div>
            </div> 
           	<div id="charts" class="tab-pane" ng-class="{active: rolesCtrl.activeTab == 'charts'}">            
                 <div ng-include="rolesCtrl.tabs.roles_from && rolesCtrl.rolesFromUrl"></div>
            </div>  
           	<div id="roles" class="tab-pane" ng-class="{active: rolesCtrl.activeTab == 'roles'}">            
                 <div ng-include="rolesCtrl.tabs.roles_to && rolesCtrl.rolesToUrl"></div>
            </div>                      
        </div>    
    
    </div> 
    
</div> <!---end nsmEdit controller---> 
    


</cfoutput>