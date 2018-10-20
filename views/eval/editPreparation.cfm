<style type="text/css">

label{    
    padding-right:3;
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

.well{
	border-color:darkgrey;
	margin-top: 6px;
	margin-bottom: 6px;	
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

<form name="setPrepCtrl.editPreparationForm" id="editPreparationForm" class="form-horizontal" novalidate>
<input type="hidden" name="evaluation_id" id="evaluation_id" value="{{setPrepCtrl.data.evaluation_id}}" />

<!---<input ng-repeat="altField in setPrepCtrl.altFields" type="hidden" name="{{altField.name}}" id="{{altField.name}}" value="{{altField.value}}" />--->

<!---<div class="panelx panelx-default">--->
    
    <div class="row" style="padding-left:15px; padding-right:15px">  
        
        <div class="col-sm-4">  
            
            <div class="well well-sm">
            
				<fieldset>
                    <legend class="scheduler-border">{{ setPrepCtrl.js.KEY_DATA }}</legend> 
                    <div class="form-group">	
                        <label for="type_id" class="col-sm-3 control-label"><span class="label label-warning-alt">ID</span></label>     
                         <div class="col-sm-9 form-control-div label-gap">                      
						<p class="form-control-static">{{ setPrepCtrl.data.eval_id }}</p>
                        </div>
                    </div>  
                    
                    <div class="form-group">	
                        <label for="type_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.js.STATUS }}</span></label>                          
                         <div class="col-sm-9 form-control-div label-gap"> 
						<p class="form-control-static">{{ setPrepCtrl.data.status }}</p>
                        </div>
                    </div>  
                    
					<div class="form-group">	
                        <label for="type_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.js.TYPE }} *</span></label>  
                        <div class="col-sm-8 form-control-div">   
                                                   
                           <select 
                            	name="type_id" 
                                id="type_id" 
                                ng-options="setPrepCtrl.js[evalType.code] for evalType in setPrepCtrl.data.evalTypes track by evalType.id"
                                ng-model="setPrepCtrl.evalType"
                                class="form-control"
                                required-select
							>
                                <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>               
                            </select>  
                            
 <!---                           <angucomplete-alt 
                                id="type_id"
                                input-name="type_id"
                                alt-input-name="alt_type_id"
                                placeholder="Evaluation Types"
                                pause="100"
                                selected-object="setPrepCtrl.evalType"
                                initial-value="setPrepCtrl.evalType"
                                local-data="setPrepCtrl.data.evalTypes"
                                search-fields="name"
                                title-field="name"
                                value-field="id"
                                minlength="0"
                                input-class="form-control form-control-small"/>--->                               
                                                        
                        	<div ng-messages="setPrepCtrl.editPreparationForm.type_id.$error" class="errors">                  
                                <span ng-if="setPrepCtrl.showError({'type_id':'requiredSelect'})" ng-message="requiredSelect">Evaluation type is required</span>                                 
                            </div>                              
                        </div>
                    </div>   
                    
                    <div class="form-group">	           
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVAL_PERIOD }} *</span></label>  
                          <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }} </label>
                            <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('eval_start_on')}"> 
                                <input ng-model="setPrepCtrl.data.eval_start_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="eval_start_on" id="eval_start_on">            
                            <div ng-messages="setPrepCtrl.editPreparationForm.eval_start_on.$error" class="errors">                  
                            	<span ng-if="setPrepCtrl.showError({'eval_start_on':'required'})" ng-message="required">Start of period is required</span>                                 
                            	<span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                            </div>    
                            </div> 	
                          	<label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>
                             <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('eval_end_on')}"> 
                                 <input ng-model="setPrepCtrl.data.eval_end_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="eval_end_on" id="eval_end_on">
                                <div ng-messages="setPrepCtrl.editPreparationForm.eval_end_on.$error" class="errors">                  
                                    <span ng-if="setPrepCtrl.showError({'eval_end_on':'required'})" ng-message="required">End of period is required</span>    
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>
                            </div> 
                    </div> 
                    
                    <div class="form-group">	           
                        <label class="col-sm-3 control-label"><span class="label label-primary-alt">Eval Period</span></label> 
                        <div class="col-sm-8 form-control-div">                      
                            <input type="text" name="eval_period" value="" class="form-control"/>
                            <div ng-messages="setPrepCtrl.editPreparationForm.eval_period.$error" class="errors"> 
                                <span ng-if="setPrepCtrl.showError({'eval_period':'required'})" ng-message="required">Evaluation Period is required</span>   
                                <span ng-message="euroDate">Please use dd/mm/yyyy format</span> 
                            </div> 
                        </div> 
                    </div>                     
                                                          
				</fieldset>  
			</div>  <!---end well--->  
            
            <div class="well well-sm">
            
                <fieldset>                
                    <legend class="scheduler-border">{{ setPrepCtrl.lib.TIMETABLE }}</legend> 
                    
                    <div class="form-group">	           
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.PREP_PHASE }} *</span></label>  
                          <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }}</label>
                            <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('prep_phase_start_on')}"> 
                                <input ng-model="setPrepCtrl.data.prep_phase_start_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="prep_phase_start_on" id="prep_phase_start_on">    
                                <div ng-messages="setPrepCtrl.editPreparationForm.prep_phase_start_on.$error" class="errors">   
	                                <span ng-if="setPrepCtrl.showError({'prep_phase_start_on':'required'})" ng-message="required">Start of period is required</span> 
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                            
                            </div>   
                          	<label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>
                             <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('prep_phase_end_on')}"> 
                                <input ng-model="setPrepCtrl.data.prep_phase_end_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="prep_phase_end_on" id="prep_phase_end_on">
                              <div ng-messages="setPrepCtrl.editPreparationForm.prep_phase_end_on.$error" class="errors"> 
		                              <span ng-if="setPrepCtrl.showError({'prep_phase_end_on':'required'})" ng-message="required">End of period is required</span>   
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                
                            </div>  
                    </div>  
                    
                    <div class="form-group">	           
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.ASSESS_PHASE }} *</span></label>  
                          <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }}</label>
                            <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('assess_phase_start_on')}"> 
                                <input ng-model="setPrepCtrl.data.assess_phase_start_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="assess_phase_start_on" id="assess_phase_start_on">   
                              <div ng-messages="setPrepCtrl.editPreparationForm.assess_phase_start_on.$error" class="errors">   
	                              <span ng-if="setPrepCtrl.showError({'assess_phase_start_on':'required'})" ng-message="required">Start of period is required</span> 
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                               
                                </div>                                             
                            </div>   
                          	<label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>
                             <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('assess_phase_end_on')}"> 
                                <input ng-model="setPrepCtrl.data.assess_phase_end_on" type="text" class="form-control" required euro-date placeholder="dd/mm/yyyy" name="assess_phase_end_on" id="assess_phase_end_on">
                              <div ng-messages="setPrepCtrl.editPreparationForm.assess_phase_end_on.$error" class="errors">   
	                              <span ng-if="setPrepCtrl.showError({'assess_phase_end_on':'required'})" ng-message="required">End of period is required</span> 
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                 
                            </div>   
                    </div>                      
                    
                    <div class="form-group">	           
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.RATING_PHASE }} *</span></label>  
                          <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }}</label>
                            <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('rating_phase_start_on')}"> 
                                <input ng-model="setPrepCtrl.data.rating_phase_start_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="rating_phase_start_on" id="rating_phase_start_on">   
                              <div ng-messages="setPrepCtrl.editPreparationForm.rating_phase_start_on.$error" class="errors">   
	                              <span ng-if="setPrepCtrl.showError({'rating_phase_start_on':'required'})" ng-message="required">Start of period is required</span> 
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                              
                            </div>  
                          	<label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>
                             <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('rating_phase_end_on')}"> 
                                <input ng-model="setPrepCtrl.data.rating_phase_end_on" type="text" class="form-control" required euro-date placeholder="dd/mm/yyyy" name="rating_phase_end_on" id="rating_phase_end_on">
                              <div ng-messages="setPrepCtrl.editPreparationForm.rating_phase_end_on.$error" class="errors"> 
                              <span ng-if="setPrepCtrl.showError({'rating_phase_end_on':'required'})" ng-message="required">End of period is required</span>   
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                 
                            </div> 
                    </div>   
                    
                    <div class="form-group">	           
                        <label class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.CLOSING_PHASE }} *</span></label>  
                          <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }}</label>
                            <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('closing_phase_start_on')}"> 
                                <input ng-model="setPrepCtrl.data.closing_phase_start_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="closing_phase_start_on" id="closing_phase_start_on"> 
                              <div ng-if="setPrepCtrl.showError({'closing_phase_start_on':'required'})" ng-messages="setPrepCtrl.editPreparationForm.closing_phase_start_on.$error" class="errors">   
                              <span ng-message="required">Start of period is required</span> 
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                                
                            </div> 
                          	<label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>
                             <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('closing_phase_end_on')}"> 
                                <input ng-model="setPrepCtrl.data.closing_phase_end_on" type="text" class="form-control" required euro-date placeholder="dd/mm/yyyy" name="closing_phase_end_on" id="closing_phase_end_on">
                              <div ng-messages="setPrepCtrl.editPreparationForm.closing_phase_end_on.$error" class="errors">   
	                              <span ng-if="setPrepCtrl.showError({'closing_phase_end_on':'required'})" ng-message="required">Start of period is required</span> 
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                 
                            </div>  
                    </div>    
                                                   
                    <div class="form-group">	           
                        <label class="col-sm-3 control-label"><span class="label label-primary-alt">{{ setPrepCtrl.lib.PROBATION_PHASE }}</span></label>  
                         <label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_FROM }}</label>
                            <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('probation_phase_start_on')}"> 
                                <input ng-model="setPrepCtrl.data.probation_phase_start_on" type="text" class="form-control" required euro-date ng-model-options="{ updateOn: 'blur' }" placeholder="dd/mm/yyyy" name="probation_phase_start_on" id="probation_phase_start_on">  
                              <div ng-messages="setPrepCtrl.editPreparationForm.probation_phase_start_on.$error" class="errors">  
                              <span ng-if="setPrepCtrl.showError({'probation_phase_start_on':'required'})" ng-message="required">Start of period is required</span>  
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                               
                            </div>  
                          	<label class="col-sm-1 control-label" style="font-weight:normal; font-style:italic;">{{ setPrepCtrl.lib.TIME_UNTIL }}</label>
                             <div class="col-sm-3 form-control-div" ng-class="{'has-error':!setPrepCtrl.isValid('probation_phase_end_on')}"> 
                                <input ng-model="setPrepCtrl.data.probation_phase_end_on" type="text" class="form-control" required euro-date placeholder="dd/mm/yyyy" name="probation_phase_end_on" id="probation_phase_end_on">
                              <div ng-messages="setPrepCtrl.editPreparationForm.probation_phase_end_on.$error" class="errors"> 
	                              <span ng-if="setPrepCtrl.showError({'probation_phase_end_on':'required'})" ng-message="required">End of period is required</span>   
                                    <span ng-message="euroDate">Please use dd/mm/yyyy format</span>                              
                                </div>                                  
                            </div>  
                    </div>                                                                              
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end first column--->  
        
        <div class="col-sm-4">
        
            <div class="well well-sm">				                                  
            
                <fieldset>
                    <legend class="scheduler-border">{{ setPrepCtrl.lib.PARTICIPANTS }}</legend> 
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.isValid('evaluee_id')}">	
                        <label for="evaluee_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_EVALUEE }}</span></label>  
                        <div class="col-sm-8 form-control-div">                              
                            <select 
                            	name="evaluee_id" 
                                id="evaluee_id" 
                                ng-options="evaluee.name for evaluee in setPrepCtrl.data.evaluees track by evaluee.user_id"
                                ng-model="setPrepCtrl.evaluee"
                                class="form-control"
                                required-select multi="setPrepCtrl.noPartsDup" pos=1
							>
                                 <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>              
                            </select>    
                            <div ng-messages="setPrepCtrl.editPreparationForm.evaluee_id.$error" class="errors">                  
                                <span ng-if="setPrepCtrl.showError({'evaluee_id':'requiredSelect'})" ng-message="requiredSelect">Evaluee is required</span> 
                                <span ng-if="setPrepCtrl.showError({'evaluee_id':'multi'})" ng-message="multi">Please remove duplicates in participants</span> 
                            </div>                            
                        </div>
                    </div>                     
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.isValid('supervisor_id')}">	                   
                        <label for="supervisor_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_SUPERVISOR }} *</span></label>  
                        <div class="col-sm-8 form-control-div">                              
                            <select 
                            	name="supervisor_id" 
                                id="supervisor_id" 
                                ng-options="supervisor.name for supervisor in setPrepCtrl.data.supervisors track by supervisor.user_id"
                                ng-model="setPrepCtrl.supervisor"
                                class="form-control"
                                required-select multi="setPrepCtrl.noPartsDup" pos=2
							>
                                 <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>              
                            </select>   
                            <div ng-messages="setPrepCtrl.editPreparationForm.supervisor_id.$error" class="errors">  
	                            <span ng-if="setPrepCtrl.showError({'supervisor_id':'requiredSelect'})" ng-message="requiredSelect">Supervisor is required</span>  
                                <span ng-if="setPrepCtrl.showError({'supervisor_id':'multi'})" ng-message="multi">Please remove duplicates in participants</span> 
                            </div>                             
                        </div>
                    </div>  
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.isValid('contributor_1_id')}">	
                        <label for="contributor_1_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 1 *</span></label>  
                        <div class="col-sm-8 form-control-div">                              
                            <select 
                            	name="contributor_1_id" 
                                id="contributor_1_id" 
                                ng-options="contributor.name for contributor in setPrepCtrl.data.contributors track by contributor.user_id"
                                ng-model="setPrepCtrl.contributor_1"
                                class="form-control"
                                required-select multi="setPrepCtrl.noPartsDup" pos=3
							>
                                <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>              
                            </select>    
                            <div ng-messages="setPrepCtrl.editPreparationForm.contributor_1_id.$error" class="errors">   
	                            <span ng-if="setPrepCtrl.showError({'contributor_1_id':'requiredSelect'})" ng-message="requiredSelect">At least one contributor is required</span> 
                                <span ng-if="setPrepCtrl.showError({'contributor_1_id':'multi'})" ng-message="multi">Please remove duplicates in participants</span> 
                            </div>                             
                        </div>
                    </div>        
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.isValid('contributor_2_id')}">	
                        <label for="contributor_2_id" class="col-sm-3 control-label"><span class="label label-primary-alt">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 2</span></label>  
                        <div class="col-sm-8 form-control-div">                              
                            <select 
                            	name="contributor_2_id" 
                                id="contributor_2_id" 
                                ng-options="contributor.name for contributor in setPrepCtrl.data.contributors track by contributor.user_id"
                                ng-model="setPrepCtrl.contributor_2"
                                class="form-control"
                                multi="setPrepCtrl.noPartsDup" pos=4
							>
                                 <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>              
                            </select>    
                            <div ng-messages="setPrepCtrl.editPreparationForm.contributor_2_id.$error" class="errors">   
                                <span ng-if="setPrepCtrl.showError({'contributor_2_id':'multi'})" ng-message="multi">Please remove duplicates in participants</span> 
                            </div>                             
                        </div>
                    </div>      
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.isValid('contributor_3_id')}">	
                        <label for="contributor_3_id" class="col-sm-3 control-label"><span class="label label-primary-alt">{{ setPrepCtrl.lib.EVM_CONTRIBUTOR }} 3</span></label>  
                        <div class="col-sm-8 form-control-div">                              
                           <select 
                           		name="contributor_3_id" 
                                id="contributor_3_id" 
                                ng-options="contributor.name for contributor in setPrepCtrl.data.contributors track by contributor.user_id"
                                ng-model="setPrepCtrl.contributor_3"
                                class="form-control"
                                multi="setPrepCtrl.noPartsDup" pos=5
							>
                                <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>              
                            </select>    
                            <div ng-messages="setPrepCtrl.editPreparationForm.contributor_3_id.$error" class="errors">   
                                <span ng-if="setPrepCtrl.showError({'contributor_3_id':'multi'})" ng-message="multi">Please remove duplicates in participants</span> 
                            </div>                             
                        </div>
                    </div>       
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.isValid('preparator_id')}">	
                        <label for="preparator_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_PREPARATOR }}</span></label>  
                        <div class="col-sm-8 form-control-div">                              
                            <select 
                            	name="preparator_id" 
                                id="preparator_id" 
                                ng-options="preparator.name for preparator in setPrepCtrl.data.preparators track by preparator.user_id"
                                ng-model="setPrepCtrl.preparator"
                                class="form-control"
                                required-select multi="setPrepCtrl.noPartsDup" pos=6
							>
                                 <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>              
                            </select>   
                            <div ng-messages="setPrepCtrl.editPreparationForm.preparator_id.$error" class="errors">   
	                            <span ng-if="setPrepCtrl.showError({'preparator_id':'requiredSelect'})" ng-message="requiredSelect">Preparator is required</span> 
                                <span ng-if="setPrepCtrl.showError({'preparator_id':'multi'})" ng-message="multi">Please remove duplicates in participants</span> 
                            </div>                              
                        </div>
                    </div>     
                    
                    <div class="form-group" ng-class="{'has-error':!setPrepCtrl.isValid('authorizer_id')}">	
                        <label for="authorizer_id" class="col-sm-3 control-label"><span class="label label-warning-alt">{{ setPrepCtrl.lib.EVM_AUTHORIZER }}</span></label>  
                        <div class="col-sm-8 form-control-div">                              
                            <select 
                            	name="authorizer_id" 
                                id="authorizer_id" 
                                ng-options="authorizer.name for authorizer in setPrepCtrl.data.authorizers track by authorizer.user_id"
                                ng-model="setPrepCtrl.authorizer"
                                class="form-control"
                                required-select multi="setPrepCtrl.noPartsDup" pos=7
							>
                                <option value=''>{{ setPrepCtrl.js.PLEASE_SELECT }}</option>               
                            </select>    
                            <div ng-messages="setPrepCtrl.editPreparationForm.authorizer_id.$error" class="errors">   
	                            <span ng-if="setPrepCtrl.showError({'authorizer_id':'requiredSelect'})" ng-message="requiredSelect">Head of Office is required</span> 
                                <span ng-if="setPrepCtrl.showError({'authorizer_id':'multi'})" ng-message="multi">Please remove duplicates in participants</span> 
                            </div>                            
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
                    
                    <div class="form-group">	            
                        <label class="col-sm-3 control-label"><span class="label label-primary-alt">{{ setPrepCtrl.lib.FILE_TO_UPLOAD }}</span></label>                	
                        <div class="form-group col-sm-9">    	            
                            <!---<label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">Choose File</label>---> 
                            <div class="col-sm-8 form-control-div"> 
                               <input type="file" class="form-control" id="xfile" ng-model="setPrepCtrl.data.xfile" name="xfile"/>                
                            </div>
                        </div>  
                    </div>                                                                                 
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end thirs column--->              

    </div> <!---end row--->
    
    <nav class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">
	        <button class="btn btn-primary navbar-btn" ng-click="setPrepCtrl.backToGrid()">{{ setPrepCtrl.lib.BACK_TO_GRID }}</button>
            <button class="btn btn-primary navbar-btn" ng-click="setPrepCtrl.toggleViewEdit('view')">{{ setPrepCtrl.lib.CANCEL }}</button>	 
	        <button class="btn btn-success navbar-btn" ng-click="setPrepCtrl.saveEditPreparation()">{{ setPrepCtrl.lib.SAVE }}</button>	 
            
            <ul class="nav navbar-nav navbar-right">        
	            <li><a ng-click="setPrepCtrl.noPartsDup()" class="pointer-cursor">Multi</a></li>	            
	            <li><a ng-click="setPrepCtrl.reload()" class="pointer-cursor">{{ setPrepCtrl.lib.RELOAD }}</a></li>   
                <li><a ng-click="setPrepCtrl.toggleErrors()" class="pointer-cursor">Toggle Errors</a></li>                  
                <li><a ng-click="setPrepCtrl.changeLanguage()" class="pointer-cursor">{{ setPrepCtrl.lib.CHANGE_LANGUAGE }}</a></li>       
                <li><a ng-click="setPrepCtrl.viewStrings()" class="pointer-cursor">View Strings</a></li>  	
            </ul>   
                     
        </div>
    </nav>     

<!---</div>---> <!---end panel--->

</form>

<script>

$('input[name="eval_period"]').daterangepicker({
    "locale": {
        "format": "DD/MM/YYYY",
        "separator": " ",
        "applyLabel": "Apply",
        "cancelLabel": "Cancel",
        "fromLabel": "From",
        "toLabel": "To",
        "customRangeLabel": "Custom",
        "weekLabel": "W",
        "daysOfWeek": [
            "Su",
            "Mo",
            "Tu",
            "We",
            "Th",
            "Fr",
            "Sa"
        ],
        "monthNames": [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ],
        "firstDay": 1
    },
    "startDate": "01/01/2018",
    "endDate": "31/12/2018"
}, function(start, end, label) {
  console.log("New date range selected: ' + start.format('DD/MM/YYYY') + ' to ' + end.format('DD/MM/YYYY') + ' (predefined range: ' + label + ')");
}); 

</script>

</cfoutput>