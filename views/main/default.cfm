<cfoutput>

<script src="views/main/js/home.js"></script>

<div ng-controller="homeController as homeCtrl">	

	<div class="container-fluid">  
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: homeCtrl.activeTab == 'info'}">
                <a data-toggle="tab" href="##info" ng-click='homeCtrl.setHomeTab("info")'>Info</a>
            </li>                              
        </ul>     
    
        <div class="tab-content extra-tab">
           	<div id="info" class="tab-pane" ng-class="{active: homeCtrl.activeTab == 'info'}">            
                 <div ng-include="homeCtrl.tabs.info && homeCtrl.homeUrl"></div>
            </div>
        </div>    
    
    </div> 
    
</div> 

</cfoutput>


