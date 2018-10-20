<div ng-controller="ModalInstanceCtrl as $ctrl" class="modal-demo">

<form name="ModalInstanceCtrl.wfRejectForm" id="nsmEditEdForm" class="form-horizontal education-form" error-flagging update-flagging novalidate>

<!---<div class="panel edit-panel">

	<div class="panel-body">
    
		<div class="row">    
    
            <div class="form-group">	
                <label for="comments" class="col-sm-3 control-label"><span class="label label-warning starred">{{ nsmTabsController.str.COMMENTS  }}</span></label>
                 <div class="col-sm-10 form-control-div">  
                    <textarea name="comments}" id="comments" ng-model="vm.success" ng-maxlength="2000" class="form-control form-control" row="3"></textarea>                    
                </div>                                                                                         
            </div>       
        
        </div>
    
    </div>

</div>--->


<div class="modal-header">
    <h3 class="modal-title" id="modal-title">I'm a modal!</h3>
</div>

<div class="modal-body" id="modal-body">
    <ul>
        <li ng-repeat="item in $ctrl.items">
            <a href="#" ng-click="$event.preventDefault(); $ctrl.selected.item = item">{{ item }}</a>
        </li>
    </ul>
    Selected: <b>{{ $ctrl.selected.item }}</b>
</div>

<div class="modal-footer">
    <button class="btn btn-primary" type="button" ng-click="vm.dialogOk()">OK</button>
    <button class="btn btn-warning" type="button" ng-click="vm.dialogCancel()">Cancel</button>
</div>
        

</form>

</div>