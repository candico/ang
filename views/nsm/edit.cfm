<script src="views/nsm/js/edit.js"></script>

<cfoutput>

<div ng-controller="nsmEditController as editCtrl" ng-cloak>	

	<div class="container-fluid" style="margin-top:20px">  
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: editCtrl.activeTab == 'gd'}">
                <a data-toggle="tab" href="##gd" ng-click='editCtrl.setNsmEditTab("gd")'>Personal Info</a>
            </li>
            <li ng-class="{active: editCtrl.activeTab == 'fd'}">
                <a data-toggle="tab" href="##fd" ng-click='editCtrl.setNsmEditTab("fd")'>Family Info</a>
            </li>
<!---            <li ng-class="{active: editCtrl.activeTab == 'fd2'}">
                <a data-toggle="tab" href="##fd" ng-click='editCtrl.setNsmEditTab("fd2")'>Family Info (2)</a>
            </li> --->           
            <li ng-class="{active: editCtrl.activeTab == 'pe'}">
                <a data-toggle="tab" href="##pe" ng-click='editCtrl.setNsmEditTab("pe")'>Professional Experience</a>
            </li>
            <li ng-class="{active: editCtrl.activeTab == 'ed'}">
                <a data-toggle="tab" href="##ed" ng-click='editCtrl.setNsmEditTab("ed")'>Education</a>
            </li>                    
        </ul>     
    
        <div class="tab-content extra-tab" style="padding:10px">
           	<div id="gd" class="tab-pane" ng-class="{active: editCtrl.activeTab == 'gd'}">               	        
                 <div ng-include="editCtrl.tabs.gd && editCtrl.nsmEditGdUrl"></div>
            </div>
			 <div id="fd" class="tab-pane" ng-class="{active: editCtrl.activeTab == 'fd'}">
                <div ng-include="editCtrl.tabs.fd && editCtrl.nsmEditFdUrl"></div>
            </div>
<!---			 <div id="fd2" class="tab-pane" ng-class="{active: editCtrl.activeTab == 'fd2'}">
                <div ng-include="editCtrl.tabs.fd2 && editCtrl.nsmEditFd2Url"></div>
            </div>  --->          
			<div id="pe" class="tab-pane" ng-class="{active: editCtrl.activeTab == 'pe'}">
                <div ng-include="editCtrl.tabs.pe && editCtrl.nsmEditPeUrl"></div>
            </div>  
			<div id="ed" class="tab-pane" ng-class="{active: editCtrl.activeTab == 'ed'}">
                <div ng-include="editCtrl.tabs.ed && editCtrl.nsmEditEdUrl"></div>
            </div>             
        </div>    
    
    </div> 
    
</div> 

</cfoutput>





