<script src="views/eval/js/tabs.js"></script>

<cfoutput>

<div ng-controller="evalTabsController as evalTabsCtrl" ng-cloak>	

	<div class="container-fluid" style="margin-top:20px">  
    
        <ul class="nav nav-tabs">
            <li ng-class="{active: evalTabsCtrl.activeTab == 'preparation'}">
                <a data-toggle="tab" href="##preparation" ng-click='evalTabsCtrl.setTab("preparation")'>Preparation</a>
            </li>
            <li ng-class="{active: evalTabsCtrl.activeTab == 'assessment'}">
                <a data-toggle="tab" href="##assessment" ng-click='evalTabsCtrl.setTab("assessment")'>Self-Assessment</a>
            </li>        
            <li ng-class="{active: evalTabsCtrl.activeTab == 'dialog'}">
                <a data-toggle="tab" href="##dialog" ng-click='evalTabsCtrl.setTab("dialog")'>Formal Dialog</a>
            </li>
            <li ng-class="{active: evalTabsCtrl.activeTab == 'feedback'}">
                <a data-toggle="tab" href="##feedback" ng-click='evalTabsCtrl.setTab("feedback")'>Feedback</a>
            </li>   
            <li ng-class="{active: evalTabsCtrl.activeTab == 'evaluation'}">
                <a data-toggle="tab" href="##evaluation" ng-click='evalTabsCtrl.setTab("evaluation")'>Evaluation</a>
            </li>  
        <li ng-class="{active: evalTabsCtrl.activeTab == 'closure'}">
                <a data-toggle="tab" href="##closure" ng-click='evalTabsCtrl.setTab("closure")'>Closure</a>
            </li>                                         
        </ul>     
    
        <div class="tab-content extra-tab" style="padding:10px;">
           	<div id="preparation" class="tab-pane" ng-class="{active: evalTabsCtrl.activeTab == 'preparation'}">               	        
                 <div ng-include="evalTabsCtrl.tabs.preparation && evalTabsCtrl.preparationUrl"></div>
            </div>
			 <div id="assessment" class="tab-pane" ng-class="{active: evalTabsCtrl.activeTab == 'assessment'}">
                <div ng-include="evalTabsCtrl.tabs.assessment && evalTabsCtrl.assessmentUrl"></div>
            </div>         
			<div id="dialog" class="tab-pane" ng-class="{active: evalTabsCtrl.activeTab == 'dialog'}">
                <div ng-include="evalTabsCtrl.tabs.dialog && evalTabsCtrl.dialogUrl"></div>
            </div>  
			<div id="feedback" class="tab-pane" ng-class="{active: evalTabsCtrl.activeTab == 'feedback'}">
                <div ng-include="evalTabsCtrl.tabs.feedback && evalTabsCtrl.feedbackUrl"></div>
            </div>   
			<div id="evaluation" class="tab-pane" ng-class="{active: evalTabsCtrl.activeTab == 'evaluation'}">
                <div ng-include="evalTabsCtrl.tabs.evaluation && evalTabsCtrl.evaluationUrl"></div>
            </div> 
			<div id="closure" class="tab-pane" ng-class="{active: evalTabsCtrl.activeTab == 'closure'}">
                <div ng-include="evalTabsCtrl.tabs.closure && evalTabsCtrl.closureUrl"></div>
            </div>                                   
        </div>    
    
    </div> 
    
</div> 

</cfoutput>





