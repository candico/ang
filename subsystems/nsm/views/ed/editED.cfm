
<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });	

</script>

<cfoutput>

<form name="mainEdCtrl.nsmEditEdForm" id="nsmEditEdForm" class="form-horizontal education-form" error-flagging update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel edit-panel">

	<div class="panel-body">
        
        <staff-banner ng-cloak></staff-banner> 
    
		<div class="row stop-error-flagging">
                    
           <!--- <div class="stop-error-flagging">--->  
                
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
                                	{{ diploma.edu_level_id }} - {{ diploma.graduation_date || '[...]'}} 
                                </a>  
                                
                                <i ng-if="diploma.deleted == 'N' || diploma.deleted == 'R'" 
                                ng-click="mainEdCtrl.removeDiploma(diploma.id)" 
                                class="pointer-cursor glyphicon glyphicon-remove" 
                                style="font-size:medium; vertical-align:middle">
                                </i> 
                                
                                <i ng-if="diploma.deleted == 'Y'" 
                                ng-click="mainEdCtrl.restoreDiploma(diploma.id)" 
                                class="pointer-cursor glyphicon glyphicon-ok" 
                                style="font-size:medium; vertical-align:middle">
                                </i>             
                                                      
                            </h4>                     
                        </div>                         
                        
                        <div class="panel-body">  
                            <div class="row"> 
	                             <div class="col-sm-12">{{ diploma.edu_level_id }} - {{ diploma.graduation_date || '[...]' }}</div>
                            </div> 
                        </div>     
                        
                        <div class="panel-collapse collapse diploma-{{ diploma.id }}-panel"> 
                        
                            <div class="panel-body">    
                            
                                <div class="form-group">	            
                                   <label for="less_than_required_{{ diploma.id }}" class="col-sm-3 control-label">
                                   <span class="label label-warning starred">{{ mainEdCtrl.str.LESS_THEN_REQUIRED }}</span>
                                   </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <label class="radio-inline"><input type="radio" ng-model="diploma.less_than_required" value="Y" name="less_than_required_{{ diploma.id }}" ng-required>Y</label>
                                        <label class="radio-inline"><input type="radio" ng-model="diploma.less_than_required" value="N" name="less_than_required_{{ diploma.id }}" ng-required>N</label>  
                                       <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'less_than_required')" class="help-block alt-data">
                                       		{{ mainEdCtrl.getAltDip(diploma.id, 'less_than_required') }}
                                       </p>
                                    </div>
                                </div>                                                                                                     
                    
                                <div class="form-group">		            
                                    <label for="graduation_date_{{ diploma.id }}" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainEdCtrl.str.GRADUATION_DATE }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <div class="input-group">
                                            <input 
                                                type="text" 
                                                name="graduation_date_{{ diploma.id }}"
                                                id="graduation_date_{{ diploma.id }}"
                                                class="form-control"                                             
                                                uib-datepicker-popup="{{mainEdCtrl.format}}" 
                                                ng-model="mainEdCtrl.diplomas[diploma.id].graduation_date.date" 
                                                ng-model-options="{ updateOn: 'blur' }"
                                                is-open="mainEdCtrl.diplomas[diploma.id].graduation_date.popup.opened" 
                                                datepicker-options="mainEdCtrl.dateOptions"  
                                                datepicker-append-to-body="true"                                           
                                                close-text="Close"
                                                required                   
                                            />
                                            <span class="input-group-btn">
                                                <button type="button" 
                                                class="btn btn-default" 
                                                ng-click="mainEdCtrl.popup(mainEdCtrl.diplomas[diploma.id].graduation_date)">
                                                    <i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                            </span>
                                        </div> 
                                        <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'graduation_date')" class="help-block alt-data">
                                        	{{ mainEdCtrl.getAltDip(diploma.id, 'graduation_date') }}
                                        </p>
                                       <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'graduation_date')" class="errors"> 
                                            <span ng-message="required">{{ mainEdCtrl.str.GRADUATION_DATE_REQUIRED }}</span>  
                                        </div>  
                                    </div>   
                                </div>  
                                
                                <div class="form-group">	            
                                    <label for="establishment_{{ diploma.id }}" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainEdCtrl.str.ESTABLISHMENT }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="diploma.establishment" 
                                        type="text" class="form-control" 
                                        name="establishment_{{ diploma.id }}" 
                                        id="establishment_{{ diploma.id }}" required>
                                        </input>
                                       <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'establishment')" class="help-block alt-data">
                                       {{ mainEdCtrl.getAltDip(diploma.id, 'establishment') }}
                                       </p>
                                       <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'establishment')" class="errors"> 
                                            <span ng-message="required">{{ mainEdCtrl.str.ESTABLISHMENT_REQUIRED }}</span>                                     
                                        </div>                                             
                                    </div>
                                </div>  
                                
                                <div class="form-group">	            
                                    <label for="city_{{ diploma.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainEdCtrl.str.CITY }}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="diploma.city" type="text" class="form-control" name="city_{{ diploma.id }}" id="city_{{ diploma.id }}" required></input>
                                       <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'city')" class="help-block alt-data">{{ mainEdCtrl.getAltDip(diploma.id, 'city') }}</p>
                                       <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'city')" class="errors"> 
                                            <span ng-message="required">{{ mainEdCtrl.str.CITY_REQUIRED }}</span>                                     
                                        </div>                                             
                                    </div>
                                </div>    
                                
                                                              
                                
<!---                                <div class="form-group">	            
                                    <label for="country_name_{{ diploma.id }}" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainEdCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="country_name_{{ diploma.id }}"
                                            input-name="country_name_{{ diploma.id }}"                                    
                                            placeholder="{{ mainEdCtrl.str.PLEASE_SELECT }}"
                                            pause="100"
                                            selected-object="mainEdCtrl.setSelectedOption"
                                            selected-object-data="country_code_{{ diploma.id }}" 
                                            initial-value="mainEdCtrl.diplomas[diploma.id].diploma_country.country"
                                            local-data="mainEdCtrl.countries['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"
                                            field-required="true" 
                                        /> 
                                        <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'country_code')" class="help-block alt-data">{{ mainEdCtrl.getCtry(mainEdCtrl.getAltDip(diploma.id, 'country_code')) }}</p>
                                         <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'country_name')" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainEdCtrl.str.COUNTRY_REQUIRED }}</span>                                                   
                                        </div>              
                                    </div>
                                </div> ---> 
                                
                                <div class="form-group">	            
                                    <label for="country_name_{{ diploma.id }}" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainEdCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <input type="text" 
                                        name="country_name_{{ diploma.id }}" 
                                        ng-model="mainEdCtrl.ucountries['country_' + diploma.id].country" 
                                        uib-typeahead="country as country.name for country in mainEdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small" 
                                        ng-class="required" 
                                        required="true"> 
                                        <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'country_code')" class="help-block alt-data">
                                        	{{ mainEdCtrl.getCtry(mainEdCtrl.getAltDip(diploma.id, 'country_code')) }}
                                        </p>
                                         <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'country_name')" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainEdCtrl.str.COUNTRY_REQUIRED }}</span>                                                   
                                        </div>              
                                    </div>
                                </div>     
                                
<!---                                <div ng-if="mainEdCtrl.isHigherEducation(diploma.edu_level_id)" class="form-group">		            
                                    <label for="domain_name_{{ diploma.id }}" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainEdCtrl.str.DOMAIN }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="domain_name_{{ diploma.id }}"
                                            input-name="domain_name_{{ diploma.id }}"                                    
                                            placeholder="{{ mainEdCtrl.str.PLEASE_SELECT }}"
                                            pause="100"
                                            selected-object="mainEdCtrl.setSelectedOption"
                                            selected-object-data="domain_code_{{ diploma.id }}" 
                                            initial-value="mainEdCtrl.diplomas[diploma.id].diploma_domain.domain"
                                            local-data="mainEdCtrl.domains"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"
                                            field-required="mainEdCtrl.isHigherEducation(diploma.id)" 
                                        /> 
                                        <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'domain_code')" class="help-block alt-data">
                                        	{{ mainEdCtrl.getDomain(mainEdCtrl.getAltDip(diploma.id, 'domain_code')) }}
                                        </p>
                                         <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'domain_name')" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainEdCtrl.str.DOMAIN_REQUIRED }}</span>                                                   
                                        </div>              
                                    </div>
                                </div>  --->
                                
                             	<div class="form-group">	            
                                    <label for="domain_name_{{ diploma.id }}" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainEdCtrl.str.DOMAIN }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <input type="text" 
                                        name="domain_name_{{ diploma.id }}" 
                                        ng-model="mainEdCtrl.udomains['domain_' + diploma.id].domain" 
                                        uib-typeahead="domain as domain.name for domain in mainEdCtrl.domains | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small" 
                                        ng-class="required" 
                                        required="true"> 
                                        <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'domain_code')" class="help-block alt-data">
                                        	{{ mainEdCtrl.getDomain(mainEdCtrl.getAltDip(diploma.id, 'domain_code')) }}
                                        </p>
                                         <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'domain_name')" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainEdCtrl.str.DOMAIN_REQUIRED }}</span>                                                   
                                        </div>               
                                    </div>
                                </div>                                 
                                
                                
                                
                                
                                
                                
                                
                                     
                                
                                <div ng-if="mainEdCtrl.isHigherEducation(diploma.edu_level_id)" class="form-group">	
	                                <label for="specialty_{{ diploma.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainEdCtrl.str.SPECIALTY }}</span></label>
                                     <div class="col-sm-8 form-control-div">  
                                         <input ng-model="diploma.specialty" type="text" class="form-control" name="specialty_{{ diploma.id }}" id="specialty_{{ diploma.id }}" ng-required="mainEdCtrl.isHigherEducation(diploma.id)"></input>                    
                                        <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'specialty')" class="help-block alt-data">{{ mainEdCtrl.getAltDip(diploma.id, 'specialty') }}</p>
                                    </div>                                                                                         
                                </div>
                                
                                <div class="form-group">	
	                                <label for="comments_{{ diploma.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainEdCtrl.str.COMMENTS  }}</span></label>
                                     <div class="col-sm-8 form-control-div">  
                            <textarea name="comments_{{diploma.id}}" id="comments_{{diploma.id}}" ng-model="diploma.comments" ng-maxlength="{{ mainEdCtrl.commentsLength }}" class="form-control form-control" row="3"></textarea>                    
                                        <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'comments')" class="help-block alt-data">{{ mainEdCtrl.getAltDip(diploma.id, 'comments') }}</p>
                                    </div>                                                                                         
                                </div>   
                                
                                
                                <div class="form-group">	
                                            
                                    <label for="nbr_years_{{ diploma.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainEdCtrl.str.NBR_YEARS }}</span></label>  
                                    <div class="col-sm-2 form-control-div">                  
                                        <input ng-model="diploma.nbr_years" type="text" class="form-control" name="nbr_years_{{ diploma.id }}" id="nbr_years_{{ diploma.id }}"></input>
                                       <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'nbr_years')" class="help-block alt-data">{{ mainEdCtrl.getAltDip(diploma.id, 'nbr_years') }}</p>
                                       <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'nbr_years')" class="errors"> 
                                            <span ng-message="required">{{ mainEdCtrl.str.ITEM_REQUIRED }}</span>                                     
                                        </div>                                             
                                    </div>
                                    
                                    <label for="years_as_exp_{{ diploma.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainEdCtrl.str.YEARS_AS_EXP }}</span></label>  
                                    <div class="col-sm-2 form-control-div">                  
                                        <input ng-model="diploma.years_as_exp" type="text" class="form-control" name="years_as_exp_{{ diploma.id }}" id="years_as_exp_{{ diploma.id }}"></input>
                                       <p ng-if="mainEdCtrl.hasAltDip(diploma.id, 'years_as_exp')" class="help-block alt-data">{{ mainEdCtrl.getAltDip(diploma.id, 'years_as_exp') }}</p>
                                       <div ng-messages="mainEdCtrl.isTouchedWithErrors(diploma.id, 'years_as_exp')" class="errors"> 
                                            <span ng-message="required">{{ mainEdCtrl.str.ITEM_REQUIRED }}</span>                                     
                                        </div>                                             
                                    </div>                                    
                                    
                                </div>                       
                                
                                <div class="form-group">	            
                                    <label class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainEdCtrl.str.DOCUMENT_TO_UPLOAD }}</span></label>  
                                    <div class="col-sm-8 form-control-div"> 
                                       <input type="file" class="form-control" id="diploma_file_{{ scholarship.id }}" ng-model="diploma.diploma_file" name="diploma_file_{{ diploma.id }}"/> 
                                    </div>
                                </div>        
                                
                                <div class="form-group">	            
                                    <label class="col-sm-3 control-label"><span class="label label-primary-alt">{{ mainEdCtrl.str.CURRENT_DOCUMENT }}</span></label>   
                                    <div class="col-sm-8 form-control-div"> 
<span ng-if="diploma.filename" class="form-control no-border file-link" ng-click="mainEdCtrl.openDocFile(diploma.id, 'main')">{{ diploma.filename }}</span>
<span ng-if="mainEdCtrl.hasAlt(diploma.id, 'filename')" class="form-control no-border alt-file-link alt-data" style="width:50%" ng-click="mainEdCtrl.openDocFile(diploma.id, 'alt')">{{ mainEdCtrl.getAlt(diploma.id, 'filename') }}</span>
                                    </div>
                                </div>                                               
                
							</div>  <!---end panel body--->
                
						</div>  <!---end panel collapse--->
                
					</div>  <!---end panel--->
                
                </div> <!---end repeat diploma--->
                </div> <!---end col-sm-6--->
                </div> <!---end repeat parity--->
                
			<!---</div>--->  <!---end error flagging--->
            
		</div>  <!---end row--->   
    
        <nav class="navbar navbar-inverse navbar-fixed-bottom"> 
            <div class="container-fluid">
            
                <button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='switch' value="switch" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainEdCtrl.str.BACK_TO_GRID }}</button>     
                <button class="btn btn-info navbar-btn" name='view' value="view" ng-click="mainEdCtrl.viewED()">{{ mainEdCtrl.str.VIEW }}</button>            
               <!--- <button class="btn btn-success navbar-btn" name='save' value="save" ng-click="mainEdCtrl.saveED()">{{ mainEdCtrl.str.SAVE }}</button>--->
				<button ng-class="(mainEdCtrl.nsmEditEdForm.$invalid) ? 'btn navbar-btn btn-warning' : 'btn navbar-btn btn-success'" name='save' value="save" ng-click="mainEdCtrl.saveED()">{{ mainEdCtrl.str.SAVE }}</button>                 
                
                <div class="btn-group dropup" style="display:inline-block">
                    <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">{{ mainEdCtrl.str.ADD_DIPLOMA }}&nbsp;&nbsp;<span class="caret"></span></button>
                    <ul class="dropdown-menu" style="overflow-y:auto">
                        <li><a ng-click="mainEdCtrl.addDiploma(4)" class="pointer-cursor">{{ mainEdCtrl.str.POST_UNIVERSITY }}</a></li>
                        <li><a ng-click="mainEdCtrl.addDiploma(3)" class="pointer-cursor">{{ mainEdCtrl.str.UNIVERSITY }}</a></li>
                        <li><a ng-click="mainEdCtrl.addDiploma(2)" class="pointer-cursor">{{ mainEdCtrl.str.POST_SECONDARY }}</a></li>
                        <li><a ng-click="mainEdCtrl.addDiploma(1)" class="pointer-cursor">{{ mainEdCtrl.str.SECONDARY }}</a></li>
                        <li><a ng-click="mainEdCtrl.addDiploma(5)" class="pointer-cursor">{{ mainEdCtrl.str.ELEMENTARY }}</a></li>
                    </ul>
                </div>  
                
                <ul class="nav navbar-nav navbar-right">   
                    <li><a ng-click="mainEdCtrl.expandAll($event)" class="pointer-cursor">{{ mainEdCtrl.str.EXPAND_ALL }}</a></li> 
                    <li><a ng-click="mainEdCtrl.collapseAll($event)" class="pointer-cursor">{{ mainEdCtrl.str.COLLAPSE_ALL }}</a></li>         
                    <li><a ng-click="mainEdCtrl.reload()" class="pointer-cursor">{{ mainEdCtrl.str.RELOAD }}</a></li>
                </ul>
                
            </div>
        </nav>     
        
<ul>
  <li ng-repeat="(key, errors) in mainEdCtrl.nsmEditFdForm.$error track by $index"> <strong>{{ key }}</strong> errors
    <ul>
      <li ng-repeat="e in errors">{{ e.$name }} has an error: <strong>{{ key }}</strong>.</li>
    </ul>
  </li>
</ul>         
    
	</div> <!---end body--->

</div> <!---end panel--->  

</form>

</cfoutput>
              