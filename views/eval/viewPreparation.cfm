<style type="text/css">

label{    
    padding-right:3;
}

.col-sm-1, {
	padding:3px;
}

.col-sm-8{
	padding:8px;
}

.col-sm-9{
	padding:3px;
}

.col-sm-3{
	padding:8px;	
}

.col-sm-1{
	padding:3px;
}

.well{
	border-color:darkgrey;
	margin-top:6px;
	margin-bottom:6px;	
}

.label-gap{
	padding-left:10px;
}

.label-warning-alt{
	color:black;
	background-color:white;
	border:1px #f0ad4e solid;
}

.label-primary-alt{
	color:black;
	background-color:white;
	border:1px #428bca solid;
}

</style>

<cfoutput>
<form name="setPrepCtrl.viewPreparationForm" id="viewPreparationForm" class="form-horizontal" novalidate>
<input type="hidden" name="evaluation_id" id="evaluation_id" value="{{setPrepCtrl.data.evaluation_id}}" />

<div>
    
    <div class="row" style="padding-left:15px; padding-right:15px">  
        
        <div class="col-sm-4">
        
            <div class="well well-sm">
            
				<fieldset>
                    <legend class="scheduler-border">{{ setPrepCtrl.js.KEY_DATA }}</legend> 
                    
             <!---       <div class="form-group" style="background-color:pink">	
                        <label for="type_id" class="col-sm-3 control-label"><span class="label label-warning-alt">ID</span></label>     
                         <div class="col-sm-9 form-control-div label-gap">                      
						<p class="form-control-static">{{ setPrepCtrl.data.eval_id }}</p>
                        </div>
                    </div>  --->
                   
                    <div class="col-sm-3 text-right"><span class="label label-primary-alt">ID</span> </div>
                    <div class="col-sm-8 label-gap">
                        {{ setPrepCtrl.data.eval_id }}					
                    </div>  
                    
<!---                    <div class="form-group">	
                        <label for="type_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.js.STATUS }}</span></label>                          
                         <div class="col-sm-9 form-control-div label-gap"> 
						<p class="form-control-static">{{ setPrepCtrl.data.status }}</p>
                        </div>
                    </div>  --->
                    
                	<div class="col-sm-3 text-right"  style="background-color:pink"><span class="label label-primary-alt">{{ setPrepCtrl.js.STATUS }}</span> </div>
                    <div class="col-sm-8 label-gap" style="background-color:lightblue">
                        {{ setPrepCtrl.data.status }}					
                    </div>                                     
                    
 <!---                   <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('type_id')}">	
                        <label for="type_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.js.TYPE }} *</span></label>                          
						<div class="col-sm-8 form-control-div label-gap">                  
                            <p class="form-control-static">{{setPrepCtrl.js[setPrepCtrl.evalType.code]}}</p>
                        </div>
                    </div> ---> 
                    
                	<div class="col-sm-3 text-right"><span class="label label-primary-alt">{{ setPrepCtrl.js.TYPE }}</span> </div>
                    <div class="col-sm-8 label-gap">
                        {{setPrepCtrl.js[setPrepCtrl.evalType.code]}}					
                    </div>                      
                    
                    
    <!---              <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVAL_PERIOD }} *</span></label>                         
                        <div class="col-sm-9 form-control-div label-gap"> 
                             <p class="form-control-static">{{setPrepCtrl.data.eval_start_on || 'N/A'}} &gt; {{setPrepCtrl.data.eval_end_on || 'N/A'}}</p>                            
                        </div> 
                    </div>   --->
                    
                	<div class="col-sm-3 text-right"><span class="label label-primary-alt">{{ setPrepCtrl.lib.EVAL_PERIOD }}</span> </div>
                    <div class="col-sm-8 label-gap">
                        {{setPrepCtrl.data.eval_start_on || 'N/A'}} &gt; {{setPrepCtrl.data.eval_end_on || 'N/A'}}					
                    </div>                      
                    
                    
                                    
				</fieldset>   
                
			</div>  
            
			<div class="well well-sm">                                      
            
                <fieldset>                
                    <legend class="scheduler-border">{{ setPrepCtrl.lib.TIMETABLE }}</legend>    
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.PREP_PHASE }} *</span></label>  
                        <div class="col-sm-9 form-control-div label-gap"> 
                             <p class="form-control-static">{{setPrepCtrl.data.prep_phase_start_on || 'N/A'}} &gt; {{setPrepCtrl.data.prep_phase_end_on || 'N/A'}}</p>
                        </div>  
                    </div>                     
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.ASSESS_PHASE }} *</span></label>  
                        <div class="col-sm-9 form-control-div label-gap"> 
                             <p class="form-control-static">{{setPrepCtrl.data.assess_phase_start_on || 'N/A'}} &gt; {{setPrepCtrl.data.assess_phase_end_on || 'N/A'}}</p>
                        </div>  
                    </div>       
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.RATING_PHASE }} *</span></label>                          
                        <div class="col-sm-9 form-control-div label-gap"> 
							<p class="form-control-static">{{setPrepCtrl.data.rating_phase_start_on || 'N/A'}} &gt; {{setPrepCtrl.data.rating_phase_end_on || 'N/A'}}</p>
                        </div> 
                    </div>  
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.CLOSING_PHASE }} *</span></label>  
                        <div class="col-sm-9 form-control-div label-gap"> 
							<p class="form-control-static">{{setPrepCtrl.data.closing_phase_start_on || 'N/A'}} &gt; {{setPrepCtrl.data.closing_phase_end_on || 'N/A'}}</p>
                        </div> 
                    </div>   
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label"><span class="label label-primary-alt">{{ setPrepCtrl.lib.PROBATION_PHASE }}</span></label>  
                        <div class="col-sm-9 form-control-div label-gap"> 
                             <p class="form-control-static">{{setPrepCtrl.data.probation_phase_start_on || 'N/A'}} &gt; {{setPrepCtrl.data.probation_phase_end_on || 'N/A'}}</p>
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
                        <label for="evaluee_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_EVALUEE }} *</span></label>  
                        <div class="col-sm-8 form-control-div label-gap">  
                            <p class="form-control-static">{{setPrepCtrl.evaluee.name}}</p>
                        </div>
                    </div>                                     
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('supervisor_id')}">	                   
                        <label for="supervisor_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_SUPERVISOR }} *</span></label>  
                        <div class="col-sm-8 form-control-div label-gap">                  
                            <p class="form-control-static">{{setPrepCtrl.supervisor.name}}</p>
                        </div>     
                    </div> 
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('contributor_1_id')}">	
                        <label for="contributor_1_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 1 *</span></label>  
						<div class="col-sm-8 form-control-div label-gap">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_1.name}}</p>
                        </div>
                    </div>  
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('contributor_2_id')}">	
                        <label for="contributor_2_id" class="col-sm-3 control-label"><span class="label label-primary-alt">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 2</span></label>  
						<div class="col-sm-8 form-control-div label-gap">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_2.name}}</p>
                        </div>
                    </div>    
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('contributor_3_id')}">	
                        <label for="contributor_3_id" class="col-sm-3 control-label"><span class="label label-primary-alt">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 3</span></label>  
						<div class="col-sm-8 form-control-div label-gap">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_3.name}}</p>
                        </div>
                    </div>  
                                        
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('preparator_id')}">	
                        <label for="preparator_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_PREPARATOR }} *</span></label>  
                        <div class="col-sm-8 form-control-div label-gap">                  
                           <p class="form-control-static">{{setPrepCtrl.preparator.name}}</p>
                        </div>
                    </div>     
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.futureValidityCheck('authorizer_id')}">	
                        <label for="authorizer_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_AUTHORIZER }} *</span></label>  
                        <div class="col-sm-8 form-control-div label-gap">                  
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
            
<cfif rc.chkRequestAuthorization EQ "Y" OR rc.chkAuthorizePreparation EQ "Y">            
            
            <div class="well well-sm"> 
                <fieldset>
               		<legend class="scheduler-border">Comments <span style="font-size:x-small">(HRFP and HoO only)</span></legend> 
                    <p ng-show="setPrepCtrl.data.comments.length > 0"><span style="font-style:italic">Previous Comments:</span></p>
                    <p ng-repeat="comment in setPrepCtrl.data.comments">{{comment.author}} on {{comment.created_on}} said: <br />{{comment.text}}</p> 
                    <p><span style="font-style:italic">Add Short Comment:</span></p>
                	<div class="form-group" style="margin-left:5px; margin-right:5px">                   
                		<textarea class="form-control" rows="5" id="comments" name="comments"></textarea>
                	</div>        
                </fieldset>  
            </div>	 
            
</cfif>                       
        
        </div>  <!---end third column--->               

    </div> <!---end row--->              
    
    <nav class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">
	        <button class="btn btn-primary navbar-btn" ng-click="setPrepCtrl.backToGrid()">{{ setPrepCtrl.lib.BACK_TO_GRID }}</button>            
<cfif rc.chkEditPreparation EQ "Y">            
            <button class="btn btn-primary navbar-btn" ng-click="setPrepCtrl.toggleViewEdit('edit')">{{ setPrepCtrl.lib.EDIT_PREPARATION }}</button>	
</cfif>            
<cfif rc.chkDeleteEvaluation EQ "Y">          
            <button class="btn btn-warning navbar-btn" ng-click="setPrepCtrl.deletePreparation()">{{ setPrepCtrl.lib.DELETE_PREPARATION }}</button>  
</cfif>     
<cfif rc.chkRequestAuthorization EQ "Y">            
	        <button class="btn btn-success navbar-btn" ng-click="setPrepCtrl.requestAuthorization()">{{ setPrepCtrl.lib.REQUEST_AUTHORIZATION }}</button>	
</cfif>    
<cfif rc.chkAuthorizePreparation EQ "Y">              
        <button class="btn btn-success navbar-btn" ng-click="setPrepCtrl.authorizePreparation()">{{ setPrepCtrl.lib.AUTHORIZE_PREPARATION }}</button>	          
        <button class="btn btn-danger navbar-btn" ng-click="setPrepCtrl.rejectPreparation()">{{ setPrepCtrl.lib.REJECT_PREPARATION }}</button>             
</cfif>  
            
            <ul class="nav navbar-nav navbar-right">  	                                                
                <li><a ng-click="setPrepCtrl.changeLanguage()" class="pointer-cursor">{{ setPrepCtrl.lib.CHANGE_LANGUAGE }}</a></li>        	
            </ul>   
                     
        </div>
    </nav>     

</div> <!---end panel--->

</form>

</cfoutput>