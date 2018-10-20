<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });		

</script>

<cfoutput>

<form name="mainEdCtrl.nsmViewEdForm" id="nsmViewEdForm" class="form-horizontal education-form" update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel view-panel">

	<div class="panel-body">
        
        <staff-banner ng-cloak></staff-banner> 
    
		<div class="row">
                    
            <!---<div class="stop-error-flagging">--->  
                
                <div class="panel-heading">  
                                 
                    <h4 class="panel-title">  
                       <span>{{ (mainEdCtrl.data.diplomas.length == 0) ?  mainEdCtrl.str.NO_DIPLOMAS : (mainEdCtrl.data.diplomas.length > 1) ? mainEdCtrl.str.DIPLOMAS : mainEdCtrl.str.DIPLOMA }} </span>
                    </h4>    
                                            
                </div> 
                
                <div ng-repeat="parity in ['e','o']" ng-if="parity == 'e' ? tmp = 'e' : tmp = 'o'">
                <div class="col-sm-6">                     
                <div ng-repeat="diploma in mainEdCtrl.data.diplomas track by diploma.id" ng-if="parity == 'e' ? $even : $odd">  
                <input type="hidden" name="deleted_{{ diploma.id }}" value="{{ diploma.deleted }}" />
                <input type="hidden" name="edu_level_id_{{ diploma.id }}" value="{{ diploma.edu_level_id }}" />
                
                    <div class="panel panel-default fieldset-panel">  
                
                        <div class="panel-heading" ng-class="mainEdCtrl.getHeadingClasses(diploma.id)">                                               
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed" 
                                title="Click to expand or collapse panel (diploma id: {{ diploma.id }})" 
                                data-target=".diploma-{{ diploma.id }}-panel">
                                	[{{ $index + 1 }}] {{ diploma.edu_level_id }} - {{ diploma.graduation_date || '[...]'}} 
                                </a>  
                            </h4>                     
                        </div>            
                        
                        <div class="panel-body">  
                            <div class="row"> 
	                             <div class="col-sm-12">{{ diploma.edu_level_id }} - {{ diploma.graduation_date || '[...]' }}</div>
                            </div> 
                        </div>     
                        
                        <div class="panel-collapse collapse diploma-{{ diploma.id }}-panel"> 
                        
                            <div class="panel-body">                                  
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">[Level less Than Required]</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data">
                                    	<span>{{ diploma.less_than_required }}</span>
                                    </div>
                                    <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'less_than_required')" class="help-block alt-data">
	                                    {{ mainEdCtrl.getAltDip(diploma.id, 'less_than_required') }}
                                    </div>
                                </div>   
                                                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainEdCtrl.str.GRADUATION_DATE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data">
                                    	<span>{{ diploma.graduation_date }}</span>
                                    </div>
                                    <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'graduation_date')" class="help-block alt-data">
                                    	{{ mainEdCtrl.getAltDip(diploma.id, 'graduation_date') }}
                                    </div>
                                </div> 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainEdCtrl.str.ESTABLISHMENT }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data">
                                    	<span>{{ diploma.establishment }}</span>
                                    </div>
                                    <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'establishment')" class="help-block alt-data">
	                                    {{ mainEdCtrl.getAltDip(diploma.id, 'establishment') }}
                                    </div>
                                </div>       
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainEdCtrl.str.CITY }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data">
                                    	<span>{{ diploma.city }}</span>
                                    </div>
                                    <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'city')" class="help-block alt-data">
	                                    {{ mainEdCtrl.getAltDip(diploma.id, 'city') }}
                                    </div>
                                </div>  
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainEdCtrl.str.COUNTRY }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data">
                                    	<span>{{ mainEdCtrl.getCtry(diploma.country_code) }}</span>
                                    </div>
                                    <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'country_code')" class="help-block alt-data">
	                                    {{ mainEdCtrl.getCtry(mainEdCtrl.getAltDip(diploma.id, 'country_code')) }}
                                    </div>
                                </div>      
                                
                                <div ng-if="mainEdCtrl.isHigherEducation(diploma.edu_level_id)">
                                    <div class="col-sm-3 label-div">
                                        <span class="label label-primary">{{ mainEdCtrl.str.DOMAIN }}</span> 
                                    </div>   
                                    <div class="col-sm-8 item-div">	                      
                                        <div class="current-data">
                                        	<span>{{ mainEdCtrl.getDomain(diploma.domain_code) }}</span>
                                        </div>
                                        <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'domain')" class="help-block alt-data">
	                                        {{ mainEdCtrl.getDomain((mainEdCtrl.getAltDip(diploma.id, 'domain_code')) }}
                                        </div>
                                    </div>     
                                </div>
                                
                                <div ng-if="mainEdCtrl.isHigherEducation(diploma.edu_level_id)">
                                    <div class="col-sm-3 label-div">
                                        <span class="label label-primary">{{ mainEdCtrl.str.SPECIALTY }}</span> 
                                    </div>   
                                    <div class="col-sm-8 item-div">	                      
                                        <div class="current-data">
                                        	<span>{{ diploma.specialty }}</span>
                                        </div>
                                        <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'specialty')" class="help-block alt-data">
	                                        {{ mainEdCtrl.getAltDip(diploma.id, 'specialty') }}
                                        </div>
                                    </div>    
                                </div>
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainEdCtrl.str.COMMENTS }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data">
	                                    <span>{{ diploma.comments }}</span>
                                    </div>
                                    <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'comments')" class="help-block alt-data">
	                                    {{ mainEdCtrl.getAltDip(diploma.id, 'comments') }}
                                    </div>
                                </div>                                   
                                
                              	<!---<div class="form-group">--->
                                    <div class="col-sm-3 label-div">
                                        <span class="label label-primary">{{ mainEdCtrl.str.NBR_YEARS }}</span> 
                                    </div>     
                                    <div class="col-sm-8 item-div">                  
                                       <div class="current-data">
                                       		<span>{{ diploma.nbr_years }}</span>
                                        </div>
                                       <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'nbr_years')" class="help-block alt-data">
                                       		{{ mainEdCtrl.getAltDip(diploma.id, 'nbr_years') }}
                                       </div>
                                    </div>
                                    
                                    <div class="col-sm-3 label-div">
                                        <span class="label label-primary">{{ mainEdCtrl.str.YEARS_AS_EXP }}</span> 
                                    </div>  
                                    <div class="col-sm-8 item-div">  
                                        <div class="current-data">
                                        	<span>{{ diploma.years_as_exp }}</span>
                                        </div>
                                        <div ng-if="mainEdCtrl.hasAltDip(diploma.id, 'years_as_exp')" class="help-block alt-data">
                                        	{{ mainEdCtrl.getAltDip(diploma.id, 'years_as_exp') }}
                                        </div>
                                    </div> 
                                    
                              	<!---</div> --->          
                                
<!---                                <div>	            
                                    <label class="col-sm-3 control-label"><span class="label label-primary-alt">{{ mainEdCtrl.str.CURRENT_DOCUMENT }}</span></label>   
                                    <div class="col-sm-8 form-control-div"> 
                                    	<span ng-if="diploma.filename" class="form-control no-border file-link" ng-click="mainEdCtrl.openDocFile(diploma.id, 'main')">{{ diploma.filename }}</span>
                                    	<span ng-if="mainEdCtrl.hasAlt(diploma.id, 'filename')" class="form-control no-border alt-file-link alt-data" style="width:50%" ng-click="mainEdCtrl.openDocFile(diploma.id, 'alt')">{{ mainEdCtrl.getAlt(diploma.id, 'filename') }}</span>
                                    </div>
                                </div>  --->
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainEdCtrl.str.CURRENT_DOCUMENT }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                     	<div class="current-data">
                                            <span>
                                                <span ng-if="diploma.filename" 
                                                class="form-control no-border file-link" 
                                                ng-click="mainEdCtrl.openDiplomaFile(diploma.id, diploma.upld_hash)">
                                                	{{ diploma.filename }}
                                                </span>
                                            </span>
                                        </div>
                                    	<span ng-if="mainEdCtrl.hasAlt(diploma.id, 'filename')" 
                                        class="form-control no-border alt-file-link alt-data" style="width:50%" 
                                        ng-click="mainEdCtrl.openDiplomaFile(diploma.id, diploma.upld_hash)">
                                        	{{ mainEdCtrl.getAlt(diploma.id, 'filename') }}
                                        </span>
                                </div>                          
                
							</div>  <!---end panel body--->
                
						</div>  <!---end panel collapse--->
                
					</div>  <!---end panel--->
                
                </div> <!---end repeat diploma--->
                </div> <!---end col-sm-6--->
                </div> <!---end repeat parity--->
                
			<!---</div> ---> <!---end error flagging--->
            
		</div>  <!---end row--->   
    
		<nav class="navbar navbar-inverse navbar-fixed-bottom">
            <div class="container-fluid">            
                <button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='grid' value="grid" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainEdCtrl.str.BACK_TO_GRID }}</button>     
<cfif rc.chk_edit_ed EQ "Y">                 
                <button class="btn btn-primary navbar-btn" name='edit' value="edit" ng-click="mainEdCtrl.editED()">{{ mainEdCtrl.str.EDIT }}</button>
</cfif> 
<cfif rc.chk_wf_start EQ "Y">
				<button class="btn btn-primary navbar-btn" name='wf_start' value="wf_start" ng-click="tabsCtrl.WF_Start()">{{ mainEdCtrl.str.START_WORKFLOW }}</button>
</cfif>     
<cfif rc.chk_wf_accept EQ "Y">
				<button class="btn btn-success navbar-btn" name='wf_accept' value="wf_accept" ng-click="tabsCtrl.WF_Accept()">{{ mainEdCtrl.str.WORKFLOW_ACCEPT }}</button>
</cfif>  
<cfif rc.chk_wf_reject EQ "Y">
				<button class="btn btn-danger navbar-btn" name='wf_reject' value="wf_reject" ng-click="tabsCtrl.WF_Reject()">{{ mainEdCtrl.str.WORKFLOW_REJECT }}</button>
</cfif>        
                <ul class="nav navbar-nav navbar-right">  
                	<li><a ng-click="mainEdCtrl.expandAll($event)" class="pointer-cursor">{{ mainEdCtrl.str.EXPAND_ALL }}</a></li> 
                	<li><a ng-click="mainEdCtrl.collapseAll($event)" class="pointer-cursor">{{ mainEdCtrl.str.COLLAPSE_ALL }}</a></li>                 	                	
                	<li><a ng-click="mainEdCtrl.reload()" class="pointer-cursor">{{ mainEdCtrl.str.RELOAD }}</a></li> 
                </ul>
            </div>
        </nav>     
    
	</div> <!---end panel body--->

</div> <!---end panel--->  

</form>

</cfoutput>
 
 