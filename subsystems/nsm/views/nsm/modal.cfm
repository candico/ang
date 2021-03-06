<!---<div class="modal-header">
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
    <button class="btn btn-primary" type="button" ng-click="$ctrl.ok()">OK</button>
    <button class="btn btn-warning" type="button" ng-click="$ctrl.cancel()">Cancel</button>
</div>
</script>
<script type="text/ng-template" id="stackedModal.html">
<div class="modal-header">
    <h3 class="modal-title" id="modal-title-{{name}}">The {{name}} modal!</h3>
</div>
<div class="modal-body" id="modal-body-{{name}}">
    Having multiple modals open at once is probably bad UX but it's technically possible.
</div>--->


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



