<div class="modal-header">
    <h3 class="modal-title" id="modal-title">{{ $ctrl.str.COMMENTS }}</h3>
</div>
<div class="modal-body" id="modal-body">
    <div class="col-sm-8 form-control-div">                  
        <textarea ng-model="$ctrl.rejectReason" 
        class="form-control" 
        name="comments" 
        id="comments" 
        rows="5" 
        maxlength="2000">
        </textarea>  
    </div>
</div>     
<div class="modal-footer">
    <button class="btn btn-primary" type="button" ng-click="$ctrl.ok()">OK</button>
    <button class="btn btn-warning" type="button" ng-click="$ctrl.cancel()">Cancel</button>
</div>



