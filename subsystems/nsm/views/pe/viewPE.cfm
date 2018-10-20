<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });		

</script>
    
<cfoutput>

<form name="mainPeCtrl.nsmViewPeForm" id="nsmViewPeForm" class="form-horizontal professional-experience-form" update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel view-panel professional-experience-panel">

	<div class="panel-body">  
        
        <staff-banner ng-cloak></staff-banner> 
    
		<div class="row">    
        
           <!--- <div class="stop-error-flagging">  --->
                
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
                
                    <div class="panel panel-default fieldset-panel">
        
						<div class="panel-heading" ng-class="mainPeCtrl.getHeadingClasses(experience.id, 'top')">                         
                                
                            <div class="row">
                            
                                <div class="col-sm-12">
                                
                                    <h4 class="panel-title">                        
                                    <a data-toggle="collapse" 
                                    class="collapse-link collapsed" 
                                    title="Click to expand or collapse panel (experience id: {{ experience.id }})" 
                                    data-target=".experience-{{experience.id}}-panel">
                                    <span class="label label-primary">
                                    Experience {{ mainPeCtrl.data.experiences.length - $index}}
                                    /
                                    {{ mainPeCtrl.data.experiences.length }} 
                                    </span>                                    
                                    <!---<span class="label label-primary">
                                    {{ experience.start_date || '?'}} &gt; {{ experience.end_date || '?'}} 
                                    </span>--->
                                    </a>                                                                        
                                    </h4> 
                                    
                                </div>                                                                          
                                
							</div>  <!--- end row--->                                                                                    
                            
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
                                     <span>{{ mainPeCtrl.str.IN_LOCATION }}</span>: {{ experience.city }}, {{ mainPeCtrl.getCtry(experience.country_code) }} 
                                </div>  
                                                                                
                                <div class="col-sm-2">
                                    <span>{{ mainPeCtrl.str.TIME_FROM }}</span>: {{ experience.start_date }} 
                                </div>  
                                
                                <div class="col-sm-2">
                                     <span>{{ mainPeCtrl.str.TIME_UNTIL }}</span>: {{ experience.end_date }} 
                                </div> 
                                
                                <div class="col-sm-2">
                                    <span>Day count: {{ mainPeCtrl.expDayCount(experience.id) }}</span>
                                </div>                                                                
                                
							</div>  <!--- end row--->                                                                                    
                            
                        </div>  <!---end panel heading --->                         
                                                                      
                        
                        <div class="panel-collapse collapse experience-{{experience.id}}-panel"> 
                        
                        	<div class="panel panel-default">	                                                    
                            
                            <div class="panel-body">   
                            
                            <div class="col-sm-6" style="border-right:1px solid grey">
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.COUNTRY }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ mainPeCtrl.getCtry(experience.country_code) }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'country_code')" class="help-block alt-data">{{ mainPeCtrl.getAltExpCtry(experience.id, 'country_code') }}</p>
                                </div>  
                                                                    
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.CITY }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.city }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'city')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'city') }}</p>
                                </div> 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.ORGANISATION }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.org }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'org')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'org') }}</p>
                                </div>      
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.POSITION_JOB_DESC }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.job }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'job')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'job') }}</p>
                                </div>                                      
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.START_DATE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.start_date }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'start_date')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'start_date') }}</p>
                                </div> 
                                                                    
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.END_DATE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.end_date }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'end_date')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'end_date') }}</p>
                                </div>                             
                            
                            </div>  <!---end col 2--->                               
                            
                            <div class="col-sm-6">                                 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.IS_EXPERIENCE_ACCEPTED }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.exp_is_accepted }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'exp_is_accepted')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'exp_is_accepted') }}</p>
                                </div> 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.WT_REGIME }} (%)</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.working_time_pct }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'working_time_pct')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'working_time_pct') }}</p>
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.WAS_CERTIFICATE_RECEIVED }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.cert_was_received }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'cert_was_received')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'cert_was_received') }}</p>
                                </div> 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.IS_CERTIFICATE_DOH }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.cert_is_declaration }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'cert_is_declaration')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'cert_is_declaration') }}</p>
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.BASE_DAYS }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ mainPeCtrl.days360(experience.id) }}</span></div>
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.RELEVANCE_OF_EXPERIENCE }} (%)</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.relevance_pct }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'relevance_pct')" class="help-block alt-data">{{ mainPeCtrl.getAltExp(experience.id, 'relevance_pct') }}</p>
                                </div>  
                                
                               <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainPeCtrl.str.DAYS }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ experience.relevance_pct }}</span></div>
                                    <p ng-if="mainPeCtrl.hasAltExp(experience.id, 'relevance_pct')" class="help-block alt-data">{{ mainPeCtrl.expDayCount(experience.id) }}</p>
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
                
                     <div class="col-sm-2">
                        <span class="form-control no-border" style="width:100%">[Experience Days]: {{ mainPeCtrl.getExperienceDayCount() }}</span>
                     </div>
                     
                    <div class="col-sm-2">
                        <span class="form-control no-border" style="width:100%">[Education Days]: {{ mainPeCtrl.getEducationDayCount() }}</span>
                     </div>    
                     
                    <div class="col-sm-2">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.TOTAL_DAYS }}: {{ mainPeCtrl.getTotalDayCount() }}</span>
                     </div>                                       
                     
                     <div class="col-sm-2">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.TOTAL_MONTHS }}: {{ mainPeCtrl.getTotalMonthCount() }}</span>
                     </div>
                     
                     <div class="col-sm-2">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.FUNCTION_GROUP }}: {{ mainPeCtrl.data.fg }}</span>
                     </div>
                     
                     <div class="col-sm-2">
                        <span class="form-control no-border" style="width:100%">{{ mainPeCtrl.str.COMPUTED_STEPS }}: {{ mainPeCtrl.getStepCount() }}</span>
                     </div>   
                     
                </div> <!---end row---> 
                          
            </div>              
        
        </div>    
        
        <nav class="navbar navbar-inverse navbar-fixed-bottom">
            <div class="container-fluid">            
                <button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='grid' value="grid" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainPeCtrl.str.BACK_TO_GRID }}</button>     
<cfif rc.chk_edit_pe EQ "Y">                 
                <button class="btn btn-primary navbar-btn" name='edit' value="edit" ng-click="mainPeCtrl.editPE()">{{ mainPeCtrl.str.EDIT }}</button>
</cfif> 
<cfif rc.chk_wf_start EQ "Y">
				<button class="btn btn-primary navbar-btn" name='wf_start' value="wf_start" ng-click="tabsCtrl.WF_Start()">{{ mainPeCtrl.str.START_WORKFLOW }}</button>
</cfif>     
<cfif rc.chk_wf_accept EQ "Y">
				<button class="btn btn-success navbar-btn" name='wf_accept' value="wf_accept" ng-click="tabsCtrl.WF_Accept()">{{ mainPeCtrl.str.WORKFLOW_ACCEPT }}</button>
</cfif>  
<cfif rc.chk_wf_reject EQ "Y">
				<button class="btn btn-danger navbar-btn" name='wf_reject' value="wf_reject" ng-click="tabsCtrl.WF_Reject()">{{ mainPeCtrl.str.WORKFLOW_REJECT }}</button>
</cfif>       
                <ul class="nav navbar-nav navbar-right">  
                	<li><a ng-click="mainPeCtrl.expandAll($event)" class="pointer-cursor">{{ mainPeCtrl.str.EXPAND_ALL }}</a></li> 
                	<li><a ng-click="mainPeCtrl.collapseAll($event)" class="pointer-cursor">{{ mainPeCtrl.str.COLLAPSE_ALL }}</a></li>                 	                	
                	<li><a ng-click="mainPeCtrl.reload()" class="pointer-cursor">{{ mainPeCtrl.str.RELOAD }}</a></li> 
                </ul>
            </div>
        </nav>            
        
	</div>  <!---end panel body--->
    
</div> <!---end panel--->  

</form>

</cfoutput>
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        



