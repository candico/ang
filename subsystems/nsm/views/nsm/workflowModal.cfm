<div class="modal-header">
    <h3 class="modal-title" id="modal-title">Workflow Details</h3>
</div>

<!---<div class="modal-body" id="modal-body">
    <ul>
        <li ng-repeat="step in $ctrl.wf">
            {{ step.initiator }}
        </li>
    </ul>   
</div>
--->

<div class="panel panel-default" ng-repeat="step in $ctrl.wf">
    <div class="panel-heading">
	    Status: <span style="font-weight:bold">{{ step.status_code }}</span>
        Initiated by <span style="font-weight:bold">{{ step.initiator }}</span>
        on <span style="font-weight:bold">{{ step.created_on }}</span>
    </div>
    <div ng-if="step.comments" class="panel-body">
    	{{ step.comments }}    
    </div>
</div>

<div class="modal-footer">
    <button class="btn btn-primary" type="button" ng-click="$ctrl.ok()">OK</button>
   <!--- <button class="btn btn-warning" type="button" ng-click="$ctrl.cancel()">Cancel</button>--->
</div>


