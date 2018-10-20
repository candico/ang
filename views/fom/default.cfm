<cfoutput>

<script src="views/fom/js/default.js"></script>

<div ng-controller="fomController as fomCtrl" ng-cloak>	

	<div class="container-fluid" style="margin-top:60px">  
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: fomCtrl.activeTab == 'info'}">
                <a data-toggle="tab" href="##info" ng-click='fomCtrl.setFomTab("info")'>{{ fomCtrl.lib.GENERAL_DATA }}</a>
            </li>  
            <li ng-class="{active: fomCtrl.activeTab == 'charts'}">
                <a data-toggle="tab" href="##charts" ng-click='fomCtrl.setFomTab("charts")'>{{ fomCtrl.lib.CHARTS }}</a>
            </li>    
            <li ng-class="{active: fomCtrl.activeTab == 'roles'}">
                <a data-toggle="tab" href="##roles" ng-click='fomCtrl.setFomTab("roles")'>{{ fomCtrl.lib.ROLES }}</a>
            </li>                                                   
        </ul>     
    
        <div class="tab-content extra-tab">
         
           	<div id="info" class="tab-pane" ng-class="{active: fomCtrl.activeTab == 'info'}">    
<ng-switch on="fomCtrl.viewEditToggle"> 
			<div ng-switch-when="view" style="padding:15px">
				<div ng-include="fomCtrl.viewUrl"></div>
			</div>
            <div ng-switch-when="edit" style="padding:15px">               
				<div ng-include="fomCtrl.editUrl"></div>
			</div>                
</ng-switch>                
            </div>
            
           	<div id="charts" class="tab-pane" ng-class="{active: fomCtrl.activeTab == 'charts'}">            
                 <div ng-include="fomCtrl.tabs.charts && fomCtrl.chartsUrl"></div>
            </div> 
             
           	<div id="roles" class="tab-pane" ng-class="{active: fomCtrl.activeTab == 'roles'}">            
                 <div ng-include="fomCtrl.tabs.roles && fomCtrl.rolesUrl"></div>
            </div>                      
        </div>    
    
    </div> 
    
</div>  

</cfoutput>