<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });		

</script>
   
<cfoutput>

<form name="mainPeCtrl.nsmEditPeForm" id="nsmEditPeForm" class="form-horizontal professional-experience-form" error-flagging update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel edit-panel professional-experience-panel">

	<div class="panel-body"> 
        
        <staff-banner ng-cloak></staff-banner>   
    
		<div class="row stop-error-flagging">    
        
           <!--- <div class="stop-error-flagging"> ---> 
                
                <div class="panel-heading">  
                                  
                    <h4 class="panel-title">  
                        <span>
                            {{ (mainPeCtrl.data.experiences.length == 0) 
                            ?  mainPeCtrl.str.NO_PROFESSIONAL_EXPERIENCE : (mainPeCtrl.data.experiences.length > 1) 
                            ? mainPeCtrl.str.PROFESSIONAL_EXPERIENCES : mainPeCtrl.str.PROFESSIONAL_EXPERIENCE }} 
                        </span>
                    </h4>   
                                             
                </div>                  

                <div ng-repeat="experience in mainPeCtrl.data.experiences track by experience.id" class="col-sm-12">   
                <input type="hidden" name="deleted_{{ experience.id }}" value="{{ experience.deleted }}" />
                
                    <div class="panel panel-default fieldset-panel">
        
                        <div class="panel-heading" ng-class="mainPeCtrl.getHeadingClasses(experience.id, 'top')"> 
                        
                                <h4 class="panel-title">   
                                
									<i ng-if="experience.deleted == 'N' || experience.deleted == 'R'" 
                                    ng-click="mainPeCtrl.removeExperience(experience.id)" 
                                    class="pointer-cursor glyphicon glyphicon-remove" 
                                    style="font-size:medium; vertical-align:middle">
                                    </i> 
                                    
                                    <i ng-if="experience.deleted == 'Y'" 
                                    ng-click="mainPeCtrl.restoreExperience(experience.id)" 
                                    class="pointer-cursor glyphicon glyphicon-ok" 
                                    style="font-size:medium; 
                                    vertical-align:middle">
                                    </i>                                                                   
                                                    
                                    <a data-toggle="collapse" 
                                    class="collapse-link collapsed" 
                                    title="Click to expand or collapse panel (experience id: {{ experience.id }})" 
                                    data-target=".experience-{{experience.id}}-panel">
                                        <span class="label label-primary">
                                            Experience {{ mainPeCtrl.data.experiences.length - $index}}
                                            /
                                            {{ mainPeCtrl.data.experiences.length }} 
                                        </span>                                     
                                    
<!---                                    	{{ mainPeCtrl.experiences[experience.id].start_date.date | date:'dd/MM/yyyy' }} &gt; {{ mainPeCtrl.experiences[experience.id].end_date.date | date:'dd/MM/yyyy' }}--->
                                    </a>                                                                                                                                               
                                </h4>                          
                            
                        </div>  <!---end panel heading --->   
                        
                        <div class="panel-body"> 
                        
                            <div class="row">
                                                         
                                <div class="col-sm-2">
                                    <span>{{ mainPeCtrl.str.JOB }}</span>: {{ experience.job | cut:true:20 }}
                                </div>  
                                 
                                <div class="col-sm-2">
                                     <span>{{ mainPeCtrl.str.FOR }}</span>: {{ experience.org | cut:true:20 }}
                                </div> 
                                
                                <div class="col-sm-2">
                                     <span>{{ mainPeCtrl.str.IN_LOCATION }}</span>: {{ experience.city }}, {{ mainPeCtrl.getExpCtry(experience.id) }} 
                                </div>  
                                                                                
                                <div class="col-sm-2">
                                    <span>{{ mainPeCtrl.str.TIME_FROM }}</span>: {{ mainPeCtrl.experiences[experience.id].start_date.date | date:'dd/MM/yyyy' }} 
                                </div>  
                                
                                <div class="col-sm-2">
                                     <span>{{ mainPeCtrl.str.TIME_UNTIL }}</span>: {{ mainPeCtrl.experiences[experience.id].end_date.date | date:'dd/MM/yyyy' }} 
                                </div> 
                                
                                <div class="col-sm-2">
                                    <span>Day count: {{ mainPeCtrl.expDayCount(experience.id) }}</span>
                                </div> 
                                
                            </div> <!---end row --->                         
                            
                        </div>  <!---end panel body --->                         
                        
                        <div class="panel-collapse collapse experience-{{experience.id}}-panel"> 
                        
                        	<div class="panel panel-default">	                                                    
                            
                            <div class="panel-body">   
                            
                            <div class="col-sm-6" style="border-right:1px solid grey">                                
                            
                                 <div class="form-group">	            
                                    <label for="country_name_{{ experience.id }}" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainPeCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="country_name_{{ experience.id }}"
                                            input-name="country_name_{{ experience.id }}"                                    
                                            placeholder="{{ mainPeCtrl.str.PLEASE_SELECT }}"
                                            pause="100"
                                            selected-object="mainPeCtrl.setSelectedOption"
                                            selected-object-data="country_code_{{ experience.id }}" 
                                            initial-value="mainPeCtrl.experiences[experience.id].experience_country.country"
                                            local-data="mainPeCtrl.countries['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"
                                            field-required="true" 
                                        /> 
                                        <div ng-if="mainPeCtrl.hasAltExp(experience.id, 'country_code')" class="help-block alt-data">
                                        	{{ mainPeCtrl.getAltExpCtry(experience.id, 'country_code') }}
                                        </div>
                                         <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'country_name')" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainPeCtrl.str.COUNTRY_REQUIRED }}</span>                                                   
                                        </div>                                      
                                                            
                                    </div>
                                </div>   
                                                                
                                <div class="form-group">	            
                                    <label for="city_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainPeCtrl.str.CITY }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="experience.city" type="text" class="form-control" name="city_{{ experience.id }}" id="city_{{ experience.id }}" required></input>
                                        <div ng-if="mainPeCtrl.hasAltExp(experience.id, 'city')" class="help-block alt-data">
                                        	{{ mainPeCtrl.getAltExp(experience.id, 'city') }}
                                        </div>
                                       	<div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'city')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.CITY_REQUIRED }}</span>  
                                        </div>                                             
                                    </div>
                                </div>    
                                
                                <div class="form-group">	            
                                    <label for="org_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label label-warning starred">{{ mainPeCtrl.str.ORGANISATION }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="experience.org" type="text" class="form-control" name="org_{{ experience.id }}" id="org_{{ experience.id }}" required></input>
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'org')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'org') }}</p>
                                       <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'org')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.ORGANISATION_REQUIRED }}</span>  
                                        </div>                                             
                                    </div>
                                </div>    
                                
                                <div class="form-group">	            
                                    <label for="job_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label label-warning starred">{{ mainPeCtrl.str.POSITION_JOB_DESC }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="experience.job" type="text" class="form-control" name="job_{{ experience.id }}" id="job_{{ experience.id }}" required></input>
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'job')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'job') }}</p>
                                       <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'job')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.POSITION_JOB_DESC_REQUIRED }}</span>  
                                        </div>                                             
                                    </div>
                                </div>    
                                
<!---                                <div class="form-group">	            
                                    <label for="city" class="col-sm-3 control-label"><span class="label label-warning">{{ mainPeCtrl.str.START_DATE }} *</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="experience.start_date" type="text" class="form-control" name="start_date_{{ experience.id }}" id="start_date_{{ experience.id }}" required></input>
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'start_date')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'start_date') }}</p>
                                       <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'start_date')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.START_DATE_REQUIRED }}</span>  
                                        </div>                                             
                                    </div>
                                </div>--->   
                                
                                
                                <div class="form-group">	            
                                    <label for="start_date_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainPeCtrl.str.START_DATE }}</span></label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <div class="input-group">
                                            <input 
                                                type="text" 
                                                name="start_date_{{ experience.id }}"
                                                id="start_date_{{ experience.id }}"
                                                class="form-control"                                             
                                                uib-datepicker-popup="{{mainPeCtrl.format}}" 
                                                ng-model="mainPeCtrl.experiences[experience.id].start_date.date" 
                                                ng-model-options="{ updateOn: 'blur' }"
                                                is-open="mainPeCtrl.experiences[experience.id].start_date.popup.opened" 
                                                datepicker-options="mainPeCtrl.dateOptions"  
                                                datepicker-append-to-body="true"                                           
                                                close-text="Close"
                                                required                   
                                            />
                                            <span class="input-group-btn">
                                            <button type="button" class="btn btn-default" ng-click="mainPeCtrl.popup(mainPeCtrl.experiences[experience.id].start_date)"><i class="glyphicon glyphicon-calendar"></i></button>
                                            </span>
                                        </div> 
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'start_date')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'start_date') }}</p>
                                       <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'start_date')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.START_DATE_REQUIRED }}</span>  
                                        </div>  
                                    </div>   
                                </div>                                  
                                
<!---                                <div class="form-group">	            
                                    <label for="city" class="col-sm-3 control-label"><span class="label label-warning">{{ mainPeCtrl.str.END_DATE }} *</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="experience.end_date" type="text" class="form-control" name="end_date_{{ experience.id }}" id="end_date_{{ experience.id }}" required></input>
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'end_date')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'end_date') }}</p>
                                       <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'end_date')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.END_DATE_REQUIRED }}</span> 
                                        </div>                                             
                                    </div>
                                </div>  --->     
                                
                                <div class="form-group">	            
                                    <label for="end_date_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainPeCtrl.str.END_DATE }}</span></label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <div class="input-group">
                                            <input 
                                                type="text" 
                                                name="end_date_{{ experience.id }}"
                                                id="end_date_{{ experience.id }}"
                                                class="form-control"                                             
                                                uib-datepicker-popup="{{mainPeCtrl.format}}" 
                                                ng-model="mainPeCtrl.experiences[experience.id].end_date.date" 
                                                ng-model-options="{ updateOn: 'blur' }"
                                                is-open="mainPeCtrl.experiences[experience.id].end_date.popup.opened" 
                                                datepicker-options="mainPeCtrl.dateOptions"  
                                                datepicker-append-to-body="true"                                           
                                                close-text="Close"
                                                required                   
                                            />
                                            <span class="input-group-btn">
                                            <button type="button" class="btn btn-default" ng-click="mainPeCtrl.popup(mainPeCtrl.experiences[experience.id].end_date)"><i class="glyphicon glyphicon-calendar"></i></button>
                                            </span>
                                        </div> 
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'end_date')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'end_date') }}</p>
                                       <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'end_date')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.END_DATE_REQUIRED }}</span>  
                                        </div>  
                                    </div>   
                                </div>                                                      
                            
                            </div>  <!---end col 2--->                               
                            
                            <div class="col-sm-6">                                 
                                
                                <div class="form-group">	            
                                    <label for="exp_is_accepted_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label-primary">{{ mainPeCtrl.str.IS_EXPERIENCE_ACCEPTED }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <label class="radio-inline"><input type="radio" ng-model="experience.exp_is_accepted" value="Y" name="exp_is_accepted_{{ experience.id }}" ng-required>Y</label>
                                        <label class="radio-inline"><input type="radio" ng-model="experience.exp_is_accepted" value="N" name="exp_is_accepted_{{ experience.id }}" ng-required>N</label>  
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'exp_is_accepted')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'exp_is_accepted') }}</p>
                                        <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'exp_is_accepted')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.IS_EXP_ACCEPTED_REQUIRED }}</span>  
                                        </div>                                            
                                    </div>
                                </div>     
                                
                                <div class="form-group">	            
                                    <label for="working_time_pct_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label-primary">{{ mainPeCtrl.str.WT_REGIME }} (%)</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="experience.working_time_pct" type="text" style="width:20%" class="form-control" name="working_time_pct_{{ experience.id }}" id="working_time_pct_{{ experience.id }}" required></input>
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'working_time_pct')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'working_time_pct') }}</p>
                                        <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'working_time_pct')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.WT_REGIME_PCT_REQUIRED }}</span>  
                                        </div>
                                    </div>
                                </div>                                     
                                
                                <div class="form-group">	            
                                    <label for="cert_was_received_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label-primary">{{ mainPeCtrl.str.WAS_CERTIFICATE_RECEIVED }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <label class="radio-inline"><input type="radio" ng-model="experience.cert_was_received" value="Y" name="cert_was_received_{{ experience.id }}" id="cert_was_received_{{ experience.id }}" ng-required>Y</label>
                                        <label class="radio-inline"><input type="radio" ng-model="experience.cert_was_received" value="N" name="cert_was_received_{{ experience.id }}" id="cert_was_received_n_{{ experience.id }}" ng-required>N</label>  
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'cert_was_received')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'cert_was_received') }}</p>
                                        <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'cert_was_received')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.IS_CERT_RECEIVED_REQUIRED }}</span>  
                                        </div>                                            
                                    </div>
                                </div>                                     
                                
                                <div class="form-group">	            
                                    <label for="city" class="col-sm-3 control-label"><span class="label label-primary">{{ mainPeCtrl.str.IS_CERTIFICATE_DOH }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <label class="radio-inline"><input type="radio" ng-model="experience.cert_is_declaration" value="Y" name="cert_is_declaration_{{ experience.id }}" ng-required>Y</label>
                                        <label class="radio-inline"><input type="radio" ng-model="experience.cert_is_declaration" value="N" name="cert_is_declaration_{{ experience.id }}" ng-required>N</label>  
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'cert_is_declaration')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'cert_is_declaration') }}</p>
                                        <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'cert_is_declaration')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.IS_CERT_DOH_REQUIRED }}</span>  
                                        </div>                                             
                                    </div>
                                </div>  
                                
                                <div class="form-group">	            
                                    <label class="col-sm-3 control-label"><span class="label label-primary">{{ mainPeCtrl.str.BASE_DAYS }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <span class="form-control no-border" style="width:20%">
                                        	{{ mainPeCtrl.days360(experience.id) }}
                                        </span>
                                    </div>
                                </div>     
                                
                                <div class="form-group">	            
                                    <label for="relevance_pct_{{ experience.id }}" class="col-sm-3 control-label"><span class="label label-primary">{{ mainPeCtrl.str.RELEVANCE_OF_EXPERIENCE }} (%)</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="experience.relevance_pct" type="text" style="width:20%" class="form-control" name="relevance_pct_{{ experience.id }}" id="relevance_pct_{{ experience.id }}" required></input>
                                        <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'relevance_pct')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'relevance_pct') }}</p>
                                       <div ng-messages="mainPeCtrl.isTouchedWithErrors(experience.id, 'relevance_pct')" class="errors"> 
                                            <span ng-message="required">{{ mainPeCtrl.str.RELEVANCE_PCT_REQUIRED }}</span>  
                                        </div>
                                    </div>
                                </div>    
                                
                                <div class="form-group">	            
                                    <label class="col-sm-3 control-label"><span class="label label-primary">{{ mainPeCtrl.str.DAYS }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <span class="form-control no-border" style="width:20%">{{ mainPeCtrl.expDayCount(experience.id) }}</span>
                                    </div>
                                </div>                                             
                                
                            </div>  <!---end col 1--->       
                            
                            </div>  <!---end panel body--->
                            
                            </div> <!---end panel--->
                        
                        </div> <!---end collapse--->
                        
                    </div>  <!---end panel--->                     
                
                </div> <!---end repeat--->  
                    
			<!---</div>---> <!--- end error flagging--->
            
		</div>  <!---end row--->        
        
        <div class="panel panel-default fieldset-panel">
        
            <div class="panel-heading">                
                
                <h4 class="panel-title">  
                    <span>Global Results</span>
                </h4> 
                            
            </div>
            
            <div class="panel-body">  
            
                <div class="row">
                
                     <div class="col-sm-3">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.TOTAL_DAYS }}: {{ mainPeCtrl.getTotalDayCount() }}</span>
                     </div>
                     
                     <div class="col-sm-3">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.TOTAL_MONTHS }}: {{ mainPeCtrl.getTotalMonthCount() }}</span>
                     </div>
                     
                     <div class="col-sm-3">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.FUNCTION_GROUP }}: {{ mainPeCtrl.data.fg }}</span>
                     </div>
                     
                     <div class="col-sm-3">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.COMPUTED_STEPS }}: {{ mainPeCtrl.getStepCount() }}</span>
                     </div>   
                     
                </div> <!---end row---> 
                          
            </div>              
        
        </div>    
        
        <nav class="navbar navbar-inverse navbar-fixed-bottom"> 
            <div class="container-fluid">
            
                <button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='switch' value="switch" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainPeCtrl.str.BACK_TO_GRID }}</button>     
                <button class="btn btn-info navbar-btn" name='view' value="view" ng-click="mainPeCtrl.viewPE()">{{ mainPeCtrl.str.VIEW }}</button>            
               <!--- <button class="btn btn-success navbar-btn" name='save' value="save" ng-click="mainPeCtrl.savePE()">{{ mainPeCtrl.str.SAVE }}</button>--->
                
				<button ng-class="(mainPeCtrl.nsmEditPeForm.$invalid) ? 'btn navbar-btn btn-warning' : 'btn navbar-btn btn-success'" name='save' value="save" ng-click="mainPeCtrl.savePE()">{{ mainPeCtrl.str.SAVE }}</button>   
                
				<button class="btn btn-info navbar-btn" name='add' value="add" ng-click="mainPeCtrl.addExperience()">[Add Professional Experience]</button>
                
<!---                <div class="btn-group dropup" style="display:inline-block">
                    <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">{{ mainPeCtrl.str.ADD_ITEM }}&nbsp;&nbsp;<span class="caret"></span></button>
                    <ul class="dropdown-menu" style="overflow-y:auto">
                        <li><a ng-click="mainPeCtrl.addExperience()" class="pointer-cursor">{{ mainPeCtrl.str.PROFESSIONAL_EXPERIENCE }}</a></li>                    
                    </ul>
                </div>  --->
                
                <ul class="nav navbar-nav navbar-right">   
                	<li><a ng-click="mainPeCtrl.expandAll($event)" class="pointer-cursor">{{ mainPeCtrl.str.EXPAND_ALL }}</a></li> 
                	<li><a ng-click="mainPeCtrl.collapseAll($event)" class="pointer-cursor">{{ mainPeCtrl.str.COLLAPSE_ALL }}</a></li>                           	
                    <li><a ng-click="mainPeCtrl.reload()" class="pointer-cursor">{{ mainPeCtrl.str.RELOAD }}</a></li>
                </ul>
                
            </div>
        </nav>        
        
<ul>
  <li ng-repeat="(key, errors) in mainPeCtrl.nsmEditPeForm.$error track by $index"> <strong>{{ key }}</strong> errors
    <ul>
      <li ng-repeat="e in errors">{{ e.$name }} has an error: <strong>{{ key }}</strong>.</li>
    </ul>
  </li>
</ul>   
        
	</div>  <!---end panel body--->
    
</div> <!---end panel--->  

</form>

</cfoutput>
                        
                 
                   