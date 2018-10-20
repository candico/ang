<style type="text/css">

.padding-3-0{    
    padding-left:3;
	padding-right:0;
}

.padding-3-3{    
    padding-left:0;
	padding-right:0;
}

.padding-0-3{    
    padding-left:0;
	padding-right:3;
}

label{    
    padding-right:3;
}

.form-control-div-padding{    
    padding-left:3;
}

.col-sm-4{
	padding:3px;
}

.col-sm-8{
	padding:3px;
}

.col-sm-3{
	padding:3px;
}

.col-sm-1{
	padding:3px;
}

.well{
	border-color:darkgrey;
	margin-top: 6px;
	margin-bottom: 6px;	
}

</style>


<cfoutput>



<form name="setPrepCtrl.viewPreparationForm" id="viewPreparationForm" class="form-horizontal" novalidate>
<input type="hidden" name="evaluation_id" id="evaluation_id" value="{{setPrepCtrl.data.evaluation_id}}" />

<div class="panelx panelx-default">
    
    <div class="row" style="padding-left:15px; padding-right:15px">  
        
        <div class="col-sm-4">
        
            <div class="well well-sm">
            
				<fieldset>
                    <legend class="scheduler-border">{{ setPrepCtrl.lib.EVAL_TYPE }} auth: #rc.chkRequestAuthorization#</legend>  
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('type_id')}">	
                        <label for="type_id" class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.js.TYPE }}</span></label>                          
						<div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.js[setPrepCtrl.evalType.code]}}</p>
                        </div>
                    </div>  
				</fieldset>   
                
			</div>  
            
			<div class="well well-sm">                                      
            
                <fieldset>                
                    <legend class="scheduler-border">{{ setPrepCtrl.lib.TIMETABLE }}</legend>

                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.EVAL_PERIOD }}</span></label>  
                       <!--- <label class="col-sm-1" style="font-weight:normal; font-style:italic;"><p class="form-control-static">{{ setPrepCtrl.lib.TIME_FROM }}</p></label>--->
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('eval_start_on')}"> 
                             <p class="form-control-static">{{ setPrepCtrl.lib.TIME_FROM }} {{setPrepCtrl.data.eval_start_on || 'N/A'}}</p>                            
                        </div> 
  						<div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('eval_end_on')}">                              
                             <p class="form-control-static">{{ setPrepCtrl.lib.TIME_UNTIL }} {{setPrepCtrl.data.eval_end_on || 'N/A'}}</p>
                        </div> 
           <!---             <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>                             
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('eval_start_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.eval_end_on || 'N/A'}}</p>
                        </div>--->
                    </div>  
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.ASSESS_PHASE }}</span></label>  
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }} </label>
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('assess_phase_start_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.assess_phase_start_on || 'N/A'}}</p>
                        </div> 
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>                             
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('assess_phase_end_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.assess_phase_end_on || 'N/A'}}</p>
                        </div>
                    </div>       
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.RATING_PHASE }}</span></label>  
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }} </label>
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('rating_phase_start_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.rating_phase_start_on || 'N/A'}}</p>
                        </div> 
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>                             
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('rating_phase_end_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.rating_phase_end_on || 'N/A'}}</p>
                        </div>
                    </div>  
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.CLOSING_PHASE }}</span></label>  
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }} </label>
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('closing_phase_start_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.closing_phase_start_on || 'N/A'}}</p>
                        </div> 
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>                             
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('closing_phase_end_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.closing_phase_end_on || 'N/A'}}</p>
                        </div>
                    </div>   
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.EVM_PROBATION_PHASE }}</span></label>  
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }} </label>
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('probation_phase_start_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.probation_phase_start_on || 'N/A'}}</p>
                        </div> 
                        <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>                             
                        <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('probation_phase_end_on')}"> 
                             <p class="form-control-static">{{setPrepCtrl.data.probation_phase_end_on || 'N/A'}}</p>
                        </div>
                    </div>                                                                                                         
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end first column--->          
        
        <div class="col-sm-4">
        
            <div class="well well-sm">                                    
            
                <fieldset>
                    <legend class="scheduler-border">{{ setPrepCtrl.lib.PARTICIPANTS }}</legend>                     
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('evaluee_id')}">	
                        <label for="evaluee_id" class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.EVM_EVALUEE }}</span></label>  
                        <div class="col-sm-8 form-control-div">  
                            <p class="form-control-static">{{setPrepCtrl.evaluee.name}}</p>
                        </div>
                    </div>                                     
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('supervisor_id')}">	                   
                        <label for="supervisor_id" class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.EVM_SUPERVISOR }} *</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.supervisor.name}}</p>
                        </div>     
                    </div> 
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('contributor_1_id')}">	
                        <label for="contributor_1_id" class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 1</span></label>  
						<div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_1.name}}</p>
                        </div>
                    </div>  
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('contributor_2_id')}">	
                        <label for="contributor_2_id" class="col-sm-3 control-label"><span class="label label-primary">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 2</span></label>  
						<div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_2.name}}</p>
                        </div>
                    </div>    
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('contributor_3_id')}">	
                        <label for="contributor_3_id" class="col-sm-3 control-label"><span class="label label-primary">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 3</span></label>  
						<div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_3.name}}</p>
                        </div>
                    </div>  
                                        
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('preparator_id')}">	
                        <label for="preparator_id" class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.EVM_PREPARATOR }}</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                           <p class="form-control-static">{{setPrepCtrl.preparator.name}}</p>
                        </div>
                    </div>     
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('authorizer_id')}">	
                        <label for="authorizer_id" class="col-sm-3 control-label"><span class="label label-warning">{{ setPrepCtrl.lib.EVM_AUTHORIZER }}</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.authorizer.name}}</p>
                        </div>                      
                    </div>                                                                       
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end second column--->          
        
        <div class="col-sm-4">
        
            <div class="well well-sm">
            
                <fieldset>
                    <legend class="scheduler-border">{{ setPrepCtrl.lib.DOCUMENTS_LIBRARY }}</legend>  
                    
                    <ul class="list-group">
                      <li ng-repeat="document in setPrepCtrl.documents" class="list-group-item">   
                      <span ng-click="setPrepCtrl.openDocument(document.doc_id)" style="color:blue;cursor: pointer;">{{document.filename}}</span>    
                      </li>               
                    </ul>                                                                                 
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end third column--->               

    </div> <!---end row--->
    
    <div class="row" style="padding-left:15px; padding-right:15px; padding-top:5px">          
        
        <div class="well well-sm">    
            <fieldset xstyle="margin-left:10px; margin-right:10px">
                <legend class="scheduler-border">Comments for Authorization</legend> 
                <div class="form-group" style="margin-left:5px; margin-right:5px">                   
                    <textarea ng-model="setPrepCtrl.data.comments" class="form-control" rows="5" id="comments" name="comments"></textarea>
                </div>        
            </fieldset>  
        </div>		
        
	</div>                
    
    <nav class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">
	        <button class="btn btn-primary navbar-btn" ng-click="setPrepCtrl.backToGrid()">{{ setPrepCtrl.lib.BACK_TO_GRID }}</button>            
<cfif rc.chkEditPreparation EQ "Y">            
            <button class="btn btn-primary navbar-btn" ng-click="setPrepCtrl.toggleViewEdit('edit')">{{ setPrepCtrl.lib.EDIT_PREPARATION }}</button>	
</cfif>            
<cfif rc.chkDeleteEvaluation EQ "Y">          
            <button class="btn btn-warning navbar-btn" ng-click="setPrepCtrl.deletePreparation()">{{ setPrepCtrl.lib.DELETE_EVALUATION }}</button>  
</cfif>     
<cfif rc.chkRequestAuthorization EQ "Y">            
	        <button class="btn btn-success navbar-btn" ng-click="setPrepCtrl.submitForValidation()">{{ setPrepCtrl.lib.REQUEST_AUTHORIZATION }}</button>	
</cfif>    
<cfif rc.chkAuthorizePreparation EQ "Y">              
            <button class="btn btn-success navbar-btn" ng-click="setPrepCtrl.authorizePreparation()">{{ setPrepCtrl.lib.AUTHORIZE_PREPARATION }}</button>	
</cfif>  

<button class="btn btn-success navbar-btn" ng-click="setPrepCtrl.acceptAuth()">Accept Preparation</button>  
<button class="btn btn-danger navbar-btn" ng-click="setPrepCtrl.rejectAuth()">Reject Preparation</button> 
            
            <ul class="nav navbar-nav navbar-right">  
	            <li><a ng-click="setPrepCtrl.reload()" class="pointer-cursor">{{ setPrepCtrl.lib.RELOAD }}</a></li>                                    
                <li><a ng-click="setPrepCtrl.changeLanguage()" class="pointer-cursor">{{ setPrepCtrl.lib.CHANGE_LANGUAGE }}</a></li>        	
            </ul>   
                     
        </div>
    </nav>     

</div> <!---end panel--->

</form>

</cfoutput>