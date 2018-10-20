<script src="views/nsm/js/tabs.js"></script>

<cfoutput>

<div ng-controller="nsmTabsController as tabsCtrl" ng-cloak>	

	<div class="container-fluid" style="margin-top:20px">  
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: tabsCtrl.activeTab == 'gd'}">
                <a data-toggle="tab" href="##gd" ng-click='tabsCtrl.setTab("gd")'>Personal Info</a>
            </li>
            <li ng-class="{active: tabsCtrl.activeTab == 'fd'}">
                <a data-toggle="tab" href="##fd" ng-click='tabsCtrl.setTab("fd")'>Family Info</a>
            </li>
            <li ng-class="{active: tabsCtrl.activeTab == 'pe'}">
                <a data-toggle="tab" href="##pe" ng-click='tabsCtrl.setTab("pe")'>Professional Experience</a>
            </li>
            <li ng-class="{active: tabsCtrl.activeTab == 'ed'}">
                <a data-toggle="tab" href="##ed" ng-click='tabsCtrl.setTab("ed")'>Education</a>
            </li>                    
        </ul>     
    
        <div class="tab-content extra-tab" style="padding:10px">
           	<div id="gd" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'gd'}">               	        
                 <div ng-include="tabsCtrl.tabs.gd && tabsCtrl.editGdUrl"></div>
            </div>
			 <div id="fd" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'fd'}">
                <div ng-include="tabsCtrl.tabs.fd && tabsCtrl.editFdUrl"></div>
            </div>
			<div id="pe" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'pe'}">
                <div ng-include="tabsCtrl.tabs.pe && tabsCtrl.editPeUrl"></div>
            </div>  
			<div id="ed" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'ed'}">
                <div ng-include="tabsCtrl.tabs.ed && tabsCtrl.editEdUrl"></div>
            </div>             
        </div>    
    
    </div> 
    
</div> 

</cfoutput>





