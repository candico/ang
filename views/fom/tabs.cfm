<script src="views/fom/js/tabs.js"></script>

<cfoutput>

<div ng-controller="fomController as fomCtrl" ng-cloak>	

	<div class="container-fluid">  
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: fomCtrl.activeTab == 'info'}">
                <a data-toggle="tab" href="##info" ng-click='fomCtrl.setFomTab("info")'>{{ fomCtrl.lib.GENERAL_DATA }}</a>
            </li>                                 
        </ul>     
    
        <div class="tab-content extra-tab">
         
           	<div id="info" class="tab-pane" ng-class="{active: fomCtrl.activeTab == 'info'}">    
<ng-switch on="fomCtrl.infoTabMode"> 
			<div ng-switch-when="view" >
				<div ng-include="fomCtrl.viewUrl"></div>
			</div>
            <div ng-switch-when="edit" >               
				<div ng-include="fomCtrl.editUrl"></div>                
			</div>                
</ng-switch>                
            </div>
        </div>    
    
    </div> 
    
</div>  

</cfoutput>