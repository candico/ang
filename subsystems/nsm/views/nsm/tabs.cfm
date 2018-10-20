<script src="subsystems/nsm/views/nsm/js/tabs.js"></script>



<style>

.nav-tabs > li > a.updated{
    color: blue !important;
	text-decoration: underline !important;
}

.ev { 
	position: fixed;
	width:100%;
	top:auto;
	z-index:1000;
}

</style>

<div ng-controller="nsmTabsController as tabsCtrl">	

	<!---<div class="container-fluid"> ---> 
    
        <ul class="nav nav-tabs">
            <li ng-class="{ active: tabsCtrl.activeTab == 'gd' }">
                <a ng-class="{ 'updated': tabsCtrl.updatedTabs['gd'] }" data-toggle="tab" href="" ng-click='tabsCtrl.setTab("gd")'>{{tabsCtrl.str.PERSONAL_INFO}}</a>
            </li>
            <li ng-class="{ active: tabsCtrl.activeTab == 'fd' }">
                <a ng-class="{ 'updated': tabsCtrl.updatedTabs['fd'] }" data-toggle="tab" href="" ng-click='tabsCtrl.setTab("fd")'>{{tabsCtrl.str.FAMILY_INFO}}</a>
            </li>
            <li ng-class="{ active: tabsCtrl.activeTab == 'pe' }">
                <a ng-class="{ 'updated': tabsCtrl.updatedTabs['pe'] }" data-toggle="tab" href="" ng-click='tabsCtrl.setTab("pe")'>{{tabsCtrl.str.PROFESSIONAL_EXPERIENCE}}</a>
            </li>
            <li ng-class="{ active: tabsCtrl.activeTab == 'ed' }">
                <a ng-class="{ 'updated': tabsCtrl.updatedTabs['ed'] }" data-toggle="tab" href="" ng-click='tabsCtrl.setTab("ed")'>{{tabsCtrl.str.DIPLOMAS}}</a>
            </li>  
            <li ng-class="{ active: tabsCtrl.activeTab == 'co' }">
                <a ng-class="{ 'updated': tabsCtrl.updatedTabs['co'] }" data-toggle="tab" href="" ng-click='tabsCtrl.setTab("co")'>{{tabsCtrl.str.CONTRACTS}}</a>
            </li>                              
        </ul>     
    
        <div class="tab-content extra-tab">
           	<div id="gd" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'gd'}">                           	        
				<div ng-include="tabsCtrl.tabs.gd && tabsCtrl.mainGdUrl"></div>
            </div>
			 <div id="fd" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'fd'}">
                <div ng-include="tabsCtrl.tabs.fd && tabsCtrl.mainFdUrl"></div>
            </div>
			<div id="pe" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'pe'}">
                <div ng-include="tabsCtrl.tabs.pe && tabsCtrl.mainPeUrl"></div>
            </div>  
			<div id="ed" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'ed'}">
                <div ng-include="tabsCtrl.tabs.ed && tabsCtrl.mainEdUrl"></div>
            </div>    
			<div id="ed" class="tab-pane" ng-class="{active: tabsCtrl.activeTab == 'co'}">
                <div ng-include="tabsCtrl.tabs.co && tabsCtrl.mainCoUrl"></div>
            </div>                      
        </div>    
    
    <!---</div>---> 		  
    
</div> 

<div class="reject-reason"></div> 
<div class="workflow"></div>  




