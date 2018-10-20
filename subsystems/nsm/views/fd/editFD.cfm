<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });		

</script>

<style>

.angucomplete-dropdown {  
	overflow-y: auto;
	max-height: 200px;    
	z-index:1000;
}

.typeahead-demo .custom-popup-wrapper {
	position: absolute;
	top: 100%;
	left: 0;
	z-index: 1000;
	display: none;
	background-color: #f9f9f9;
}

.typeahead-demo .custom-popup-wrapper > .message {
	padding: 10px 20px;
	border-bottom: 1px solid #ddd;
	color: #868686;
}

.typeahead-demo .custom-popup-wrapper > .dropdown-menu {
	position: static;
	float: none;
	display: block;
	min-width: 160px;
	background-color: transparent;
	border: none;
	border-radius: 0;
	box-shadow: none;
}
  
</style>

<cfoutput>

<form name="mainFdCtrl.nsmEditFdForm" id="nsmEditFdForm" class="form-horizontal family-data-form" error-flagging update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel view-panel">

    <div class="panel-body">     
        
        <staff-banner ng-cloak></staff-banner> 
    
<!--- A. SPOUSE(S) --->           

        <div class="row" ng-show="mainFdCtrl.data.spouses">          
            
            <div class="stop-error-flagging">  
                
                <div class="panel-heading">                    
                    <h4 class="panel-title">  
                        <span>{{ (mainFdCtrl.data.spouses.length == 0) ?  mainFdCtrl.str.NO_SPOUSE : (mainFdCtrl.data.spouses.length > 1) ? mainFdCtrl.str.SPOUSES : mainFdCtrl.str.SPOUSE }} </span>
                    </h4> 
                </div>   
                
                    <div ng-repeat="parity in ['e','o']" ng-if="parity == 'e' ? tmp = 'e' : tmp = 'o'">
                    <div class="col-sm-6"> 
                    <div ng-repeat="spouse in mainFdCtrl.data.spouses track by spouse.id" ng-if="parity == 'e' ? $even : $odd"> 
                    <input type="hidden" name="spouse_family_link_{{ spouse.id }}" value="{{ spouse.family_link }}" />
                    <input type="hidden" name="spouse_deleted_{{ spouse.id }}" value="{{ spouse.deleted }}" />
                
                    <div class="panel panel-default fieldset-panel">
                
                        <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('relative', spouse.id)">  
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed" 
                                title="Click to expand or collapse panel (spouse id: {{ spouse.id }})" 
                                data-target=".spouse-{{ spouse.id }}-main-panel">
                                	{{spouse.lname}} {{spouse.fname}}
                                </a>  
                                <i ng-if="spouse.deleted == 'N' || spouse.deleted == 'R'" 
                                ng-click="mainFdCtrl.removeRelative(spouse.id, 'spouse')" 
                                class="pointer-cursor glyphicon glyphicon-remove" 
                                style="font-size:medium; vertical-align:middle">
                                </i> 
                                
                                <i ng-if="spouse.deleted == 'Y'" 
                                ng-click="mainFdCtrl.restoreRelative(spouse.id, 'spouse')" 
                                class="pointer-cursor glyphicon glyphicon-ok" 
                                style="font-size:medium; vertical-align:middle">
                                </i>                                                                       
                            </h4>                                                            
                        </div>                         
                        
                        <div class="panel-body" style="padding-left:15px; padding-right:15px">                             
                               
                                <span>Born {{ spouse.birth_date || '[birthdate N/A]' }} / </span> 
								<span>{{ spouse.gender || '[gender N/A]' }} / </span>                               
                                <span ng-if="spouse.is_dependent == 'Y'">{{ mainFdCtrl.str.DEPENDENT_SINCE | lowercase }} {{ spouse.dependent_since}} / </span>
                                <span ng-if="spouse.is_dependent == 'N'">{{ mainFdCtrl.str.NOT_DEPENDENT | lowercase }} / </span>
              <!---                  <span ng-if="spouse.is_expatriate == 'Y'">{{ mainFdCtrl.str.EXPAT_SINCE | lowercase }} {{ spouse.expatriate_since}} </span>
                                <span ng-if="spouse.is_expatriate == 'N'">{{ mainFdCtrl.str.NOT_DEXPAT | lowercase }} </span> --->                           
                            
     <!---                         <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.DOB }}: {{ spouse.birth_date || '[...]' }}</div>
                              <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.GENDER }}: {{ spouse.gender || '[...]' }}</div>
                              <div ng-if="spouse.is_dependent == 'Y'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.DEPENDENT_SINCE }} {{ spouse.dependent_since}}</div>
                              <div ng-if="spouse.is_dependent == 'N'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.NOT_DEPENDENT }}</div>
                              <div ng-if="spouse.is_expatriate == 'Y'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.EXPAT_SINCE }} {{ spouse.expatriate_since}}</div>
                              <div ng-if="spouse.is_expatriate == 'N'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.NOT_DEXPAT }}</div>--->                              
                            
                        </div>                             
                    
                        <div class="panel-collapse collapse spouse-{{ spouse.id }}-main-panel"> 
                        
                            <div class="panel-group sub-panel-container">  
                            
                                <div class="panel panel-default"> <!---sub-panel 1--->
                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 1 (spouse id: {{ spouse.id }})" 
                                            data-target=".spouse-{{ spouse.id }}-subpanel-1" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.PERSONAL_DATA }}
                                            </a>                            
                                        </h4>                            
                                    </div>                             
                        
                                    <div class="panel-collapse collapse edit-spouse-panel spouse-{{ spouse.id }}-subpanel-1" >   
                    
                                        <div class="panel-body"> 
                                    
                                            <div class="form-group">	           
                                                <label for="spouse_lname_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.LNAME }}</span>
												</label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_lname_{{spouse.id}}" 
                                                    id="spouse_lname_{{spouse.id}}" 
                                                    ng-model="spouse.lname" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control" 
                                                   ng-class="{changed: mainFdCtrl.nsmEditFdForm.spouse_lname_{{spouse.id}}.$dirty}"
                                                    required>
                                                    <div class="help-block" ng-focus="mainFdCtrl.isTouched(spouse.id, 'spouse_lname')">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - spouse.lname.length }}
													</div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'lname')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'lname') }}
													</div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_lname')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.LAST_NAME_REQUIRED }}</span>
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div> 
                                
                                            <div class="form-group">	           
                                                <label for="spouse_fname_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.FNAME }}</span>
												</label>                        
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_fname_{{spouse.id}}" 
                                                    id="spouse_fname_{{spouse.id}}" 
                                                    ng-model="spouse.fname" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control" 
                                                    required>
                                                    <div class="help-block">{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - spouse.fname.length }}</div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'fname')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'fname') }}
													</div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_fname')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.FIRST_NAME_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>  
                                            
                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainFdCtrl.str.GENDER }}</span></label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <label for="spouse_gender_{{spouse.id}}" class="radio-inline">
                                                    <input type="radio" 
                                                    ng-model="spouse.gender" 
                                                    value="M" 
                                                    name="spouse_gender_{{spouse.id}}" 
                                                    id="spouse_gender_{{spouse.id}}" 
                                                    ng-required=" !spouse_gender_{{spouse.id}} ">
                                                    	M
                                                    </label>
                                                    
                                                    <label for="spouse_gender_f_{{spouse.id}}" class="radio-inline">
                                                    <input type="radio" 
                                                    ng-model="spouse.gender" 
                                                    value="F" 
                                                    name="spouse_gender_{{spouse.id}}" 
                                                    id="spouse_gender_f_{{spouse.id}}" 
                                                    ng-required=" !spouse_gender_{{spouse.id}} ">
                                                    	F
                                                    </label>
                                                    
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'gender')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'gender') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.hasErrors(spouse.id, 'spouse_gender')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.GENDER_REQUIRED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>  
                                                                                
                                            <div class="form-group">	            
                                                <label for="spouse_birth_date_{{ spouse.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.DATE_OF_BIRTH }}</span>
												</label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <div class="input-group">
                                                        <input type="text" 
                                                        name="spouse_birth_date_{{ spouse.id }}"
                                                        id="spouse_birth_date_{{ spouse.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                        ng-model="mainFdCtrl.relatives[spouse.id].birth_date.date" 
                                                        ng-model-options="{ updateOn: 'blur' }"
                                                        is-open="mainFdCtrl.relatives[spouse.id].birth_date.popup.opened" 
                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                        datepicker-append-to-body="true"                                           
                                                        close-text="Close"
                                                        required                   
                                                        />
                                                        <span class="input-group-btn">
                                                        	<button 
                                                            type="button" 
                                                            class="btn btn-default" 
                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[spouse.id].birth_date)">
                                                        		<i class="glyphicon glyphicon-calendar"></i>
                                                            </button>
                                                        </span>
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'birth_date')" 
                                                    class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'birth_date') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_birth_date')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.BIRTHDATE_REQUIRED }}</span>  
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                    </div> 
                                                </div>   
                                            </div>                                             
                                            
											<div class="form-group">                                              
                                                <label for="spouse_birth_country_name_{{ spouse.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.COUNTRY_OF_BIRTH }}</span>
												</label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_birth_country_name_{{ spouse.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['spouse_birth_country_' + spouse.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small" 
                                                    ng-class="required" 
                                                    required="true">   
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'birth_country_code')" class="help-block alt-data">
                                                    	{{ MainFdCtrl.getCtry( mainFdCtrl.getAlt('spouse', spouse.id, 'birth_country_code') ) }}                                                       
                                                    </div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_birth_country_name')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div>                                               
                                            
                                            <div class="form-group">	           
                                                <label for="birth_city_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.CITY_OF_BIRTH }}</span>
												</label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_birth_city_{{spouse.id}}" 
                                                    id="spouse_birth_city_{{spouse.id}}" 
                                                    ng-model="spouse.birth_city" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control" 
                                                    required>
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - spouse.birth_city.length }}
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'birth_city')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'birth_city') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_birth_city')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.CITY_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>     
                                            
<!---                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.EXPATRIATE }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <label for="spouse_is_expatriate_{{spouse.id}}" class="radio-inline">
                                                        <input 
                                                        ng-model="spouse.is_expatriate" 
                                                        type="radio" 
                                                        value="Y" 
                                                        name="spouse_is_expatriate_{{spouse.id}}" id="spouse_is_expatriate_{{spouse.id}}" 
                                                        ng-required=" !spouse_is_expatriate_{{spouse.id}} ">
                                                        <span ng-bind-html="mainFdCtrl.str.YES"></span>
                                                    </label>
                                                    
                                                    <label for="spouse_is_expatriate_n_{{spouse.id}}" class="radio-inline">
                                                        <input type="radio"
                                                        ng-model="spouse.is_expatriate" 
                                                        value="N" 
                                                        name="spouse_is_expatriate_{{spouse.id}}" 
                                                        id="spouse_is_expatriate_n_{{spouse.id}}" 
                                                        ng-required=" !spouse_is_expatriate_{{spouse.id}} ">
                                                        <span ng-bind-html="mainFdCtrl.str.NO"></span>
                                                    </label>
                                                    
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'is_expatriate')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'is_expatriate') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.hasErrors(spouse.id, 'spouse_is_expatriate')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.IS_EXPATRIATE_REQUIRED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>---> 
                                            
<!---                                            <div class="form-group">	            
                                                <label for="spouse_expatriate_since_{{ spouse.id }}" class="col-sm-3 control-label">
                                                    <span 
                                                    class="label" 
                                                    ng-class="spouse.is_expatriate == 'Y' ? 'label-warning starred': 'label-primary'">
                                                    {{ mainFdCtrl.str.SINCE }}</span>
                                                </label>  
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" 
                                                        name="spouse_expatriate_since_{{ spouse.id }}"
                                                        id="spouse_expatriate_since_{{ spouse.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                        ng-model="mainFdCtrl.relatives[spouse.id].expatriate_since.date" 
                                                        ng-model-options="{ updateOn: 'blur' }"
                                                        is-open="mainFdCtrl.relatives[spouse.id].expatriate_since.popup.opened" 
                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                        datepicker-append-to-body="true"                                           
                                                        close-text="Close"     
                                                        ng-required=" spouse.is_expatriate == 'Y' "
                                                        />
                                                        <span class="input-group-btn">
                                                        <button 
                                                        type="button" 
                                                        class="btn btn-default" 
                                                        ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[spouse.id].expatriate_since)">
	                                                        <i class="glyphicon glyphicon-calendar"></i>
                                                        </button>
                                                        </span>
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'expatriate_since')" class="help-block alt-data">
                                                    {{ mainFdCtrl.getAlt('spouse', spouse.id, 'expatriate_since') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_expatriate_since')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.EXPAT_SINCE_REQUIRED }}</span>  
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                    </div>                                                                                                                    
                                                </div> 
                                            </div> --->
                                            
                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.DEPENDENT }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <label for="spouse_is_dependent_{{spouse.id}}" class="radio-inline">
                                                        <input type="radio" 
                                                        ng-model="spouse.is_dependent" 
                                                        value="Y" 
                                                        name="spouse_is_dependent_{{spouse.id}}" 
                                                        id="spouse_is_dependent_{{spouse.id}}" 
                                                        ng-required=" !spouse_is_dependent_{{spouse.id}} ">
                                                        <span ng-bind-html="mainFdCtrl.str.YES"></span>
                                                    </label>
                                                    
                                                    <label for="spouse_is_dependent_n_{{spouse.id}}" class="radio-inline">
                                                        <input type="radio" 
                                                        ng-model="spouse.is_dependent"                                                         
                                                        value="N" 
                                                        name="spouse_is_dependent_{{spouse.id}}" 
                                                        id="spouse_is_dependent_n_{{spouse.id}}" 
                                                        ng-required=" !spouse_is_dependent_{{spouse.id}} ">
                                                        <span ng-bind-html="mainFdCtrl.str.NO"></span>
                                                    </label>
                                                        
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'is_dependent')" class="help-block alt-data">
                                              	      {{ mainFdCtrl.str[ mainFdCtrl.getAlt('spouse', spouse.id, 'is_dependent') ] }} 
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.hasErrors(spouse.id, 'spouse_is_dependent')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.IS_DEPENDENT_REQUIRED }}</span>
                                                    </div> 
                                                </div>  
                                            </div> 
                                            
                                            <div class="form-group">	            
                                                <label for="spouse_dependent_since_{{ spouse.id }}" class="col-sm-3 control-label">
                                                	<span 
                                                    class="label" 
                                                    ng-class="spouse.is_dependent == 'Y' ? 'label-warning starred': 'label-primary'">
                                                  	  {{ mainFdCtrl.str.SINCE }}
                                                    </span>
                                                </label>  
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" 
                                                        name="spouse_dependent_since_{{ spouse.id }}"
                                                        id="spouse_dependent_since_{{ spouse.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                        ng-model="mainFdCtrl.relatives[spouse.id].dependent_since.date" 
                                                        ng-model-options="{ updateOn: 'blur' }"
                                                        is-open="mainFdCtrl.relatives[spouse.id].dependent_since.popup.opened" 
                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                        datepicker-append-to-body="true"                                           
                                                        close-text="Close"     
                                                        ng-required=" spouse.is_dependent == 'Y' ">
                                                        <span class="input-group-btn">
                                                            <button 
                                                            type="button" 
                                                            class="btn btn-default" 
                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[spouse.id].dependent_since)">
                                                                <i class="glyphicon glyphicon-calendar"></i>
                                                            </button>
                                                        </span>
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'dependent_since')" class="help-block alt-data">
                                             	       {{ mainFdCtrl.getAlt('spouse', spouse.id, 'dependent_since') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_dependent_since')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.DEPENDENT_SINCE_REQUIRED }}</span>  
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                    </div>                                                                                                                   
                                                </div>   
                                            </div>                                               
                                            
<!---                                            <div class="form-group">                                     
                                                <label for="spouse_citizenship_1_country_name_{{ spouse.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainFdCtrl.str.CITIZENSHIP }}</span></label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <angucomplete-alt 
                                                        id="spouse_citizenship_1_country_name_{{ spouse.id }}" 
                                                        input-name="spouse_citizenship_1_country_name_{{ spouse.id }}"                                    
                                                        placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                        pause="100"
                                                        selected-object="mainFdCtrl.setSelectedOption"                                               
                                                        selected-object-data="spouse_citizenship_1_country_code_{{ spouse.id }}" 
                                                        initial-value="mainFdCtrl.relatives[spouse.id].citizenship_1_country.country"
                                                        local-data="mainFdCtrl.countries['LIB']"
                                                        search-fields="name"
                                                        title-field="name"                                   
                                                        minlength="1"                                    
                                                        input-class="form-control form-control-small required"
                                                        field-required="true"
                                                    />  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'citizenship_1_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('spouse', spouse.id, 'citizenship_1_country_code') }}</div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_citizenship_1_country_name')" class="errors"> 
                                                        <span ng-message="autocomplete-required">{{ mainFdCtrl.str.CITIZENSHIP_REQUIRED }}</span>  
                                                    </div>                                    
                                                                        
                                                </div>
                                            </div>  --->                                            
                                            
											<div class="form-group">                                              
                                                <label for="spouse_citizenship_1_country_name_{{ spouse.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
												</label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_citizenship_1_country_name_{{ spouse.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['spouse_citizenship_1_country_' + spouse.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small" 
                                                    ng-class="required" 
                                                    required="true">   
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'citizenship_1_country_code')" class="help-block alt-data">
                                                    	{{ MainFdCtrl.getCitiz( mainFdCtrl.getAlt('spouse', spouse.id, 'citizenship_1_country_code') ) }} 
                                                    </div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'citizenship_1_country_name')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div>   
                                            
<!---                                            <div class="form-group">                                              
                                                <label for="spouse_citizenship_2_country_name_{{ spouse.id }}" class="col-sm-3 control-label"><span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span></label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <angucomplete-alt 
                                                        id="spouse_citizenship_2_country_name_{{ spouse.id }}" 
                                                        input-name="spouse_citizenship_2_country_name_{{ spouse.id }}"                                    
                                                        placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                        pause="100"
                                                        selected-object="mainFdCtrl.setSelectedOption"                                               
                                                        selected-object-data="spouse_citizenship_2_country_code_{{ spouse.id }}" 
                                                        initial-value="mainFdCtrl.relatives[spouse.id].citizenship_2_country.country"
                                                        local-data="mainFdCtrl.countries['LIB']"
                                                        search-fields="name"
                                                        title-field="name"                                   
                                                        minlength="1"                                    
                                                        input-class="form-control form-control-small"
                                                    />  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'citizenship_2_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('spouse', spouse.id, 'citizenship_2_country_code') }}</div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_citizenship_2_country_name')" class="errors"> 
                                                        <span ng-message="autocomplete-required">{{ mainFdCtrl.str.CITIZENSHIP_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div> ---> 
                                            
                                            
											<div class="form-group">                                              
                                                <label for="spouse_citizenship_2_country_name_{{ spouse.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span>
												</label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_citizenship_2_country_name_{{ spouse.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['spouse_citizenship_2_country_' + spouse.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small">                                                     
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'citizenship_2_country_code')" class="help-block alt-data">
                                                    	{{ MainFdCtrl.getCitiz( mainFdCtrl.getAlt('spouse', spouse.id, 'citizenship_2_country_code') ) }} 
                                                    </div>                           
                                                </div>
                                            </div>    
                                            
                                            <div class="form-group">	            
                                                <label for="spouse_death_date_{ spouse.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.DATE_OF_DEATH }}</span>
                                                </label>  
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" 
                                                        name="spouse_death_date_{{ spouse.id }}"
                                                        id="spouse_death_date_{{ spouse.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                        ng-model="mainFdCtrl.relatives[spouse.id].death_date.date" 
                                                        ng-model-options="{ updateOn: 'blur' }"
                                                        is-open="mainFdCtrl.relatives[spouse.id].death_date.popup.opened" 
                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                        datepicker-append-to-body="true"                                           
                                                        close-text="Close"                                                    
                                                        />
                                                        <span class="input-group-btn">
                                                        <button 
                                                        type="button" 
                                                        class="btn btn-default" 
                                                        ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[spouse.id].death_date)">
                                                        	<i class="glyphicon glyphicon-calendar"></i>
                                                        </button>
                                                        </span>
                                                    </div>
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'death_date')" class="help-block alt-data">
                                                  	  {{ mainFdCtrl.getAlt('spouse', spouse.id, 'death_date') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_death_date')" class="errors">                                             
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                    </div>                                                         
                                                </div>  
                                            </div>                                                                         
                                            
                                        </div>  <!---end panel-body  --->                                                                            
                                        
                                    </div>  <!---end panel-collapse--->                                         
                                    
                                </div>  <!---end sub-panel 1--->   
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 2--->
                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a 
                                            data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 2 (spouse id: {{ spouse.id }})" 
                                            data-target=".spouse-{{ spouse.id }}-subpanel-2" 
                                            style="font-size:18px; padding-left:10px">
                                           		{{ mainFdCtrl.str.OCCUPATION }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse edit-spouse-panel spouse-{{ spouse.id }}-subpanel-2">   
                    
                                        <div class="panel-body"> 
                                        
                                            <div class="form-group">	           
                                                <label for="spouse_occupation_{{spouse.id}}" class="col-sm-3 control-label">
                                               		<span class="label label-primary">{{ mainFdCtrl.str.ACTIVITY }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_occupation_{{spouse.id}}" 
                                                    id="spouse_occupation_{{spouse.id}}" 
                                                    ng-model="spouse.occupation" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - spouse.occupation.length }}
                                                    </div>                                                          
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'occupation')" class="help-block alt-data">
                                                  	  	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'occupation') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_occupation')" class="errors">
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div>                                                         
                                                </div>  
                                            </div>   
                                                                                
                                            <div class="form-group">	           
                                                <label for="spouse_employer_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span 
                                                    class="label" 
                                                    ng-class="spouse.occupation ? 'label-warning starred': 'label-primary'">
                                          	          {{ mainFdCtrl.str.ORGANISATION }}
                                                    </span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_employer_{{spouse.id}}" 
                                                    id="spouse_employer_{{spouse.id}}" 
                                                    ng-model="spouse.employer" 
                                                    ng-required=" spouse.occupation " 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                	    {{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - spouse.employer.length }}
                                                    </div>
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'employer')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'employer') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_employer')" class="errors">
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                           
                                                </div>  
                                            </div>   
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_annual_income_{{spouse.id}}" class="col-sm-3 control-label">
                                               	 <span 
                                                 class="label" 
                                                 ng-class="spouse.occupation ? 'label-warning starred': 'label-primary'">
                                           	      {{ mainFdCtrl.str.PROF_ANNUAL_INCOME }}
                                                 </span>
                                                </label>
                                                <div class="col-sm-8 form-control-div">                                                     
                                                    
                                                    <div class="input-group">
                                                      <span class="input-group-addon">&euro;</span>
                                                      <input type="number" 
                                                        name="spouse_annual_income_{{spouse.id}}" 
                                                        id="spouse_annual_income_{{spouse.id}}" 
                                                        ng-model="spouse.annual_income" 
                                                        ng-required=" spouse.occupation " 
                                                        ng-maxlength="10" 
                                                        class="form-control">
                                                    </div>
                                                    
                                         
                                                  <!---  <div class="help-block">                                                    
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.monetaryAmountLength - spouse.annual_income.length }}
                                                    </div> ---> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'annual_income')" class="help-block alt-data">
                                                   	 	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'annual_income') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_annual_income')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>  
                                                                                                           
                                                </div>  
                                            </div>  
                                            
                                            
                                        
                                            
<!---                                            <div class="form-group">	           
                                                <label for="spouse_income_currency_{{spouse.id}}" class="col-sm-3 control-label">
                                                    <span 
                                                    class="label" 
                                                    ng-class="spouse.occupation ? 'label-warning starred': 'label-primary'">
                                                        {{ mainFdCtrl.str.CURRENCY }}
                                                    </span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_income_currency_{{spouse.id}}" 
                                                    id="spouse_income_currency_{{spouse.id}}" 
                                                    ng-model="spouse.income_currency" 
                                                    ng-required=" spouse.occupation " 
                                                    ng-maxlength="mainFdCtrl.currencyCodeLength"                                                     
                                                    class="form-control form-control"
                                                    disabled>          
                                                </div>  
                                            </div>  --->   
                                            
                                            <div class="form-group">	            
                                                <label for="spouse_occupation_start_{ spouse.id }}" class="col-sm-3 control-label">
                                                    <span 
                                                    class="label" 
                                                    ng-class="spouse.occupation ? 'label-warning starred': 'label-primary'">
                                                    	{{ mainFdCtrl.str.SINCE }}
                                                    </span>
                                                </label>  
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" 
                                                        name="spouse_occupation_start_{{ spouse.id }}"
                                                        id="spouse_occupation_start_{{ spouse.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                        ng-model="mainFdCtrl.relatives[spouse.id].occupation_start.date" 
                                                        ng-model-options="{ updateOn: 'blur' }"
                                                        is-open="mainFdCtrl.relatives[spouse.id].occupation_start.popup.opened" 
                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                        datepicker-append-to-body="true"                                           
                                                        close-text="Close"    
                                                        ng-required=" spouse.occupation ">
                                                        <span class="input-group-btn">
                                                            <button type="button" 
                                                            class="btn btn-default" 
                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[spouse.id].occupation_start)">
                                                            	<i class="glyphicon glyphicon-calendar"></i>
                                                            </button>
                                                        </span>
                                                    </div>
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'occupation_start')" class="help-block alt-data">
                                                 	   {{ mainFdCtrl.getAlt('spouse', spouse.id, 'occupation_start') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_occupation_start')" class="errors">                                             
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                        
                                                </div> 
                                            </div>   
                                                                                        
                                        </div>  <!---end panel-body  --->                                                                            
                                        
                                    </div>  <!---end panel-collapse--->  
                                    
                                </div>  <!---end sub-panel 2---> 
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 3--->
                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 3 (spouse id: {{ spouse.id }})" 
                                            data-target=".spouse-{{ spouse.id }}-subpanel-3" style="font-size:18px; padding-left:10px">
                                           		{{ mainFdCtrl.str.CONTACT_ORIGIN_COUNTRY }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse spouse-{{ spouse.id }}-subpanel-3">   
                    
                                        <div class="panel-body">                                             
                                        
                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.IDEM_NS }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <label for="spouse_cco_same_{{spouse.id}}" class="radio-inline">
                                                        <input type="radio"
                                                        ng-model="spouse.cco_same"  
                                                        value="Y" 
                                                        name="spouse_cco_same_{{spouse.id}}" 
                                                        id="spouse_cco_same_{{spouse.id}}" 
                                                        ng-required=" !spouse_cco_same_{{spouse.id}} ">
                                                    	<span ng-bind-html="mainFdCtrl.str.YES"></span>
                                                    </label>
                                                    
                                                    <label for="spouse_cco_same_n_{{spouse.id}}" class="radio-inline">
                                                        <input type="radio"
                                                        ng-model="spouse.cco_same"  
                                                        value="N" 
                                                        name="spouse_cco_same_{{spouse.id}}" 
                                                        id="spouse_cco_same_n_{{spouse.id}}" 
                                                        ng-required=" !spouse_cco_same_{{spouse.id}} ">
                                                    	<span ng-bind-html="mainFdCtrl.str.NO"></span>
                                                    </label>                                                   
                                                    
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_same')" class="help-block alt-data">
                                                   		{{ mainFdCtrl[mainFdCtrl.getAlt('spouse', spouse.id, 'cco_same')] }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.hasErrors(spouse.id, 'spouse_cco_same')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                             
                                                </div>  
                                            </div>  
                                            
                                            <div class="form-group">	           
                                                <label 
                                                for="spouse_cco_address_{{spouse.id}}" 
                                                class="col-sm-3 control-label">
                                                <span class="label" ng-class="spouse.cco_same == 'N' ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.ADDRESS }}</span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <textarea 
                                                    name="spouse_cco_address_{{spouse.id}}" 
                                                    id="spouse_cco_address_{{spouse.id}}" 
                                                    ng-model="spouse.cco_address" 
                                                    ng-required=" spouse.cco_same == 'N' " 
                                                    ng-maxlength="{{ mainFdCtrl.addressLength }}" 
                                                    class="form-control form-control" 
                                                    row="3">
                                                    </textarea>
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.addressLength - spouse.cco_address.length }}
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_address')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'cco_address') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_cco_address')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                        
                                                </div>  
                                            </div>    
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_cco_city_{{spouse.id}}" class="col-sm-3 control-label">
                                                <span class="label" 
                                                ng-class="spouse.cco_same == 'N' ? 'label-warning starred': 'label-primary'">
                                                	{{ mainFdCtrl.str.CITY }}
                                                </span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input 
                                                    type="text" 
                                                    name="spouse_cco_city_{{spouse.id}}" 
                                                    id="spouse_cco_city_{{spouse.id}}" 
                                                    ng-model="spouse.cco_city" 
                                                    ng-required=" spouse.cco_same == 'N' " 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - spouse.cco_city.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_city')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'cco_city') }}</div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_cco_city')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                        
                                                </div>  
                                            </div>   
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_cco_postal_code_{{spouse.id}}" class="col-sm-3 control-label">
                                                    <span class="label" 
                                                    ng-class="spouse.cco_same == 'N' ? 'label-warning starred': 'label-primary'">
                                                    	{{ mainFdCtrl.str.POSTAL_CODE }}
                                                    </span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_cco_postal_code_{{spouse.id}}" 
                                                    id="spouse_cco_postal_code_{{spouse.id}}" 
                                                    ng-model="spouse.cco_postal_code" 
                                                    ng-required=" spouse.cco_same == 'N' "
                                                    ng-maxlength="{{ mainFdCtrl.postalCodeLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.postalCodeLength - spouse.cco_postal_code.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_postal_code')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'cco_postal_code') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_cco_postal_code')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                        
                                                </div>  
                                            </div>    
                                            
<!---                                            <div class="form-group">                                              
                                                <label for="spouse_cco_country_name_{{ spouse.id }}" class="col-sm-3 control-label"><span class="label" ng-class="spouse.cco_same == 'N' ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.COUNTRY }}</span></label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <angucomplete-alt 
                                                        id="spouse_cco_country_name_{{ spouse.id }}" 
                                                        input-name="spouse_cco_country_name_{{ spouse.id }}"                                    
                                                        placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                        pause="100"
                                                        selected-object="mainFdCtrl.setSelectedOption"                                               
                                                        selected-object-data="spouse_cco_country_code_{{ spouse.id }}" 
                                                        initial-value="mainFdCtrl.relatives[spouse.id].cco_country.country"
                                                        local-data="mainFdCtrl.countries['LIB']"
                                                        search-fields="name"
                                                        title-field="name"                                   
                                                        minlength="1"                                    
                                                        input-class="form-control form-control-small ng-class="spouse.cco_same == 'N' ? 'required': ''""
                                                        field-required="spouse.cco_same == 'N'"
                                                    />  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('spouse', spouse.id, 'cco_country_code') }}</div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_cco_country_name')" class="errors"> 
                                                        <span ng-message="autocomplete-required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div>  --->                             
                                            
											<div class="form-group">                                              
                                                <label for="spouse_cco_country_name_{{ spouse.id }}" class="col-sm-3 control-label">
                                                    <span class="label" 
                                                    ng-class="spouse.cco_same == 'N' ? 'label-warning starred': 'label-primary'">
                                                    	{{ mainFdCtrl.str.COUNTRY }}
                                                    </span>
                                                </label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input 
                                                    type="text" 
                                                    name="spouse_cco_country_name_{{ spouse.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['spouse_cco_country_' + spouse.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small" 
                                                    ng-class=" spouse.cco_same == 'N' ? 'required': '' " 
                                                    ng-required=" spouse.cco_same == 'N' ">   
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_country_code')" class="help-block alt-data">
                                                    	{{ MainFdCtrl.getCtry( mainFdCtrl.getAlt('spouse', spouse.id, 'cco_country_code') ) }} 
                                                    </div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_cco_country_name')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div>                                             
                                        
                                        </div>  <!---end panel-body  --->                                                                            
                                        
                                    </div>  <!---end panel-collapse--->                                         
                                    
                                </div>  <!---end sub-panel 3--->    
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 4--->
                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 4 (spouse id: {{ spouse.id }})" 
                                            data-target=".spouse-{{ spouse.id }}-subpanel-4" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.CONTACT_RESIDENCE_COUNTRY }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse spouse-{{ spouse.id }}-subpanel-4">   
                    
                                        <div class="panel-body">                                             
                                        
                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.IDEM_NS }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <label for="spouse_crc_same_{{spouse.id}}" class="radio-inline">
                                                        <input type="radio" 
                                                        ng-model="spouse.crc_same"  
                                                        value="Y" 
                                                        name="spouse_crc_same_{{spouse.id}}" 
                                                        id="spouse_crc_same_{{spouse.id}}" 
                                                        ng-required=" !spouse_crc_same_{{spouse.id}} ">
                                                   		<span ng-bind-html="mainFdCtrl.str.YES"></span>
                                                    </label>
                                                    
                                                    <label for="spouse_crc_same_n_{{spouse.id}}" class="radio-inline">
                                                        <input type="radio"
                                                        ng-model="spouse.crc_same" 
                                                        value="N" 
                                                        name="spouse_crc_same_{{spouse.id}}" 
                                                        id="spouse_crc_same_n_{{spouse.id}}" 
                                                        ng-required=" !spouse_crc_same_{{spouse.id}} ">
                                                    	<span ng-bind-html="mainFdCtrl.str.NO"></span>
                                                    </label>
                                                    
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_same')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.str[mainFdCtrl.getAlt('spouse', spouse.id, 'crc_same')] }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.hasErrors(spouse.id, 'spouse_crc_same')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                             
                                                </div>  
                                            </div>     
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_crc_address_{{spouse.id}}" class="col-sm-3 control-label">
                                                    <span class="label" 
                                                    ng-class="spouse.crc_same == 'N' ? 'label-warning starred': 'label-primary'">
                                                    	{{ mainFdCtrl.str.ADDRESS }}
                                                    </span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <textarea name="spouse_crc_address_{{spouse.id}}" 
                                                    id="spouse_crc_address_{{spouse.id}}" 
                                                    ng-model="spouse.crc_address" 
                                                    ng-required=" spouse.crc_same == 'N' " 
                                                    ng-maxlength="{{ mainFdCtrl.addressLength  }}" 
                                                    class="form-control" rows="3">
                                                    </textarea>
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.addressLength  - spouse.crc_address.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_address')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'crc_address') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_crc_address')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                        
                                                </div>  
                                            </div>   
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_crc_city_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label" 
                                                    ng-class="spouse.crc_same == 'N' ? 'label-warning starred': 'label-primary'">
                                                    	{{ mainFdCtrl.str.CITY }}
                                                    </span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_crc_city_{{spouse.id}}" 
                                                    id="spouse_crc_city_{{spouse.id}}" 
                                                    ng-model="spouse.crc_city" 
                                                    ng-required=" spouse.crc_same == 'N' " 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - spouse.crc_city.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_city')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'crc_city') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_crc_city')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                           
                                                </div>  
                                            </div> 
                                                                                
                                            <div class="form-group">	           
                                                <label for="spouse_crc_postal_code_{{spouse.id}}" class="col-sm-3 control-label">
                                                    <span class="label" 
                                                    ng-class="spouse.crc_same == 'N' ? 'label-warning starred': 'label-primary'">
                                                        {{ mainFdCtrl.str.POSTAL_CODE }}
                                                    </span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_crc_postal_code_{{spouse.id}}" 
                                                    id="spouse_crc_postal_code_{{spouse.id}}" 
                                                    ng-model="spouse.crc_postal_code" 
                                                    ng-required=" spouse.crc_same == 'N' " 
                                                    ng-maxlength="{{ mainFdCtrl.postalCodeLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.postalCodeLength - spouse.crc_postal_code.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_postal_code')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'crc_postal_code') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_crc_postal_code')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                    </div>                                                        
                                                </div>  
                                            </div>                                             
                                             
                                            
<!---                                            <div class="form-group">                                              
                                                <label for="spouse_crc_country_name_{{ spouse.id }}" class="col-sm-3 control-label">
                                                	<span class="label" ng-class="spouse.crc_same == 'N' ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.COUNTRY }}</span>
                                                </label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <angucomplete-alt 
                                                        id="spouse_crc_country_name_{{ spouse.id }}" 
                                                        input-name="spouse_crc_country_name_{{ spouse.id }}"                                    
                                                        placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                        pause="100"
                                                        selected-object="mainFdCtrl.setSelectedOption"                                               
                                                        selected-object-data="spouse_crc_country_code_{{ spouse.id }}" 
                                                        initial-value="mainFdCtrl.relatives[spouse.id].crc_country.country"
                                                        local-data="mainFdCtrl.countries['LIB']"
                                                        search-fields="name"
                                                        title-field="name"                                   
                                                        minlength="1"                                    
                                                        input-class="form-control form-control-small ng-valid"
                                                        field-required="spouse.crc_same == 'N'"
                                                    />  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('spouse', spouse.id, 'crc_country_code') }}</div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_crc_country_name')" class="errors"> 
                                                        <span ng-message="autocomplete-required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div> ---> 
                                            
                                            
											<div class="form-group">                                              
                                                <label for="spouse_crc_country_name_{{ spouse.id }}" class="col-sm-3 control-label">
                                                    <span class="label" 
                                                    ng-class="spouse.crc_same == 'N' ? 'label-warning starred': 'label-primary'">
                                                    	{{ mainFdCtrl.str.COUNTRY }}
                                                    </span>
                                                </label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input 
                                                    type="text" 
                                                    name="spouse_crc_country_name_{{ spouse.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['spouse_crc_country_' + spouse.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small" 
                                                    ng-class=" spouse.crc_same == 'N' ? 'required': '' " 
                                                    ng-required=" spouse.crc_same == 'N' ">   
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_country_code')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getCtry( mainFdCtrl.getAlt('spouse', spouse.id, 'crc_country_code') ) }}
                                                    </div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_crc_country_name')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div>  
                                        
                                        </div>  <!---end panel-body  --->                                                                            
                                        
                                    </div>  <!---end panel-collapse--->                                         
                                    
                                </div>  <!---end sub-panel 4--->    
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 5--->
                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 5 (spouse id: {{ spouse.id }})" 
                                            data-target=".spouse-{{ spouse.id }}-subpanel-5" style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.PRIVATE_CONTACT }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse spouse-{{ spouse.id }}-subpanel-5">   
                    
                                        <div class="panel-body"> 
                                        
                                            <div class="form-group">	           
                                                <label for="spouse_phone_nbr_{{spouse.id}}" class="col-sm-3 control-label">
                                        	        <span class="label label-primary">{{ mainFdCtrl.str.PRIVATE_PHONE_NBR }}</span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_phone_nbr_{{spouse.id}}" 
                                                    id="spouse_phone_nbr_{{spouse.id}}" 
                                                    ng-model="spouse.phone_nbr" 
                                                    ng-maxlength="{{ mainFdCtrl.phoneNumberLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.phoneNumberLength - spouse.phone_nbr.length }}
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'phone_nbr')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'phone_nbr') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_phone_nbr')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div>                                                        
                                                </div>  
                                            </div> 
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_mobile_nbr_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.PRIVATE_MOBILE_NBR }}</span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_mobile_nbr_{{spouse.id}}" 
                                                    id="spouse_mobile_nbr_{{spouse.id}}" 
                                                    ng-model="spouse.mobile_nbr" 
                                                    ng-maxlength="{{ mainFdCtrl.phoneNumberLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.phoneNumberLength - spouse.mobile_nbr.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'mobile_nbr')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'mobile_nbr') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_mobile_nbr')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div>                                                         
                                                </div>  
                                            </div>  
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_other_phone_nbr_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.OTHER_PHONE_NBR }}</span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="spouse_other_phone_nbr_{{spouse.id}}" 
                                                    id="spouse_other_phone_nbr_{{spouse.id}}" 
                                                    ng-model="spouse.other_phone_nbr" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.phoneNumberLength - spouse.other_phone_nbr.length }}
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'other_phone_nbr')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'other_phone_nbr') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_other_phone_nbr')" class="errors"> 
                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div>                                                        
                                                </div>  
                                            </div>  
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_email_1_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.EMAIL }}</span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="email" 
                                                    name="spouse_email_1_{{spouse.id}}" 
                                                    id="spouse_email_1_{{spouse.id}}" 
                                                    ng-model="spouse.email_1" 
                                                    class="form-control form-control">
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'email_1')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'email_1') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_email_1')" class="errors"> 
                                                        <span ng-message="email">{{ mainFdCtrl.str.INVALID_EMAIL }}</span>
                                                    </div>                                                          
                                                </div> 
                                            </div>                                          
                                            
                                            <div class="form-group">	           
                                                <label for="spouse_email_2_{{spouse.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.EMAIL }} 2</span>
                                                </label>
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="email" 
                                                    name="spouse_email_2_{{spouse.id}}" 
                                                    id="spouse_email_2_{{spouse.id}}" 
                                                    ng-model="spouse.email_2" class="form-control form-control">
                                                    <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'email_2')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'email_2') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(spouse.id, 'spouse_email_2')" class="errors"> 
                                                        <span ng-message="email">{{ mainFdCtrl.str.INVALID_EMAIL }}</span>
                                                    </div>                                                         
                                                </div>  
                                            </div>                                             
                                        
                                        </div>  <!---end panel-body  --->                                                                            
                                        
                                    </div>  <!---end panel-collapse--->                                         
                                    
                                </div>  <!---end sub-panel 5--->                                        
                                
                            </div> <!---end body --->    
                            
                        </div> <!---end panel  --->                             
                        
                    </div>  <!---end collapse--->    
                </div> <!---end spouse repeat--->
                </div> <!---end col-sm-6--->
                </div> <!---end parity repeat--->                                        
                
            </div>  <!---end group--->  			
            
		</div>  <!---end spouse(s) row--->       
        
        <div class="row spacer"></div>  
        
<!--- A. CHILDREN --->       
    
       <!--- <div class="row" ng-show="mainFdCtrl.children_count">--->
        <div class="row" ng-show="mainFdCtrl.data.children">
                    
            <div class="stop-error-flagging">  
                
                <div class="panel-heading">                    
                    <h4 class="panel-title">  
                        <span>
                        {{ (mainFdCtrl.data.children.length == 0) 
                        ?  mainFdCtrl.str.NO_CHILDREN : (mainFdCtrl.data.children.length > 1) 
                        ? mainFdCtrl.str.CHILDREN : mainFdCtrl.str.CHILD }}
                        </span>
                    </h4>                            
                </div> 
                
                <div ng-repeat="parity in ['e','o']" ng-if="parity == 'e' ? tmp = 'e' : tmp = 'o'">
                <div class="col-sm-6">                     
                <div ng-repeat="child in mainFdCtrl.data.children track by child.id" ng-if="parity == 'e' ? $even : $odd">  
                    <input type="hidden" name="child_family_link_{{ child.id }}" value="{{ child.family_link }}" />
                    <input type="hidden" name="child_deleted_{{ child.id }}" value="{{ child.deleted }}" />
                
                    <div class="panel panel-default fieldset-panel">
                
                        <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('relative', child.id)">                                               
                            <h4 class="panel-title">  
                            
								<i ng-if="child.deleted == 'N' || child.deleted == 'R'" 
                                ng-click="mainFdCtrl.removeRelative(child.id, 'child')" 
                                class="pointer-cursor glyphicon glyphicon-remove" 
                                style="font-size:medium; vertical-align:middle">
                                </i> 
                                
                                <i ng-if="child.deleted == 'Y'" 
                                ng-click="mainFdCtrl.restoreRelative(child.id, 'child')" 
                                class="pointer-cursor glyphicon glyphicon-ok" 
                                style="font-size:medium; 
                                vertical-align:middle">
                                </i>                             
                                                 
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed" 
                                title="Click to expand or collapse panel (child id: {{ child.id }})" 
                                data-target=".child-{{ child.id }}-main-panel">
                                	{{child.lname}} {{child.fname}}
                                </a>                                   
                                                                 
                            </h4>                     
                        </div> 
                        
                        <div class="panel-body" style="padding-left:15px; padding-right:15px">  
                        
                                <span>Born {{ child.birth_date || '[birthdate N/A]' }} / </span> 
								<span>{{ child.gender || '[gender N/A]' }} / </span>                               
                                <span ng-if="child.is_dependent == 'Y'">{{ mainFdCtrl.str.DEPENDENT_SINCE | lowercase }} {{ child.dependent_since}}</span>
                                <span ng-if="child.is_dependent == 'N'">{{ mainFdCtrl.str.NOT_DEPENDENT | lowercase }}</span>
                                                                
       <!---                     <div class="row"> 
                              <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.DOB }}: {{ child.birth_date || '[...]' }}</div>
                              <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.GENDER }}: {{ child.gender || '[...]' }}</div>
                              <div ng-if="child.is_dependent == 'Y'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.DEPENDENT_SINCE }} {{ child.dependent_since}}</div>
                              <div ng-if="child.is_dependent == 'N'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.NOT_DEPENDENT }}</div>  
                            </div> --->
                            
                        </div>                              
                        
                        <div class="panel-collapse collapse child-{{ child.id }}-main-panel"> 
                        
                            <div class="panel-group sub-panel-container">  
                            
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 1--->
                                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 1 (child id: {{ child.id }})" 
                                            data-target=".child-{{ child.id }}-subpanel-1" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.PERSONAL_DATA }}
                                            </a>                            
                                        </h4>                            
                                    </div>   
                                    
                                    <div class="panel-collapse collapse child-{{ child.id }}-subpanel-1">   
                    
                                        <div class="panel-body">                                                                           
                                
                                            <div class="form-group">	           
                                                <label for="child_lname_{{child.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.LNAME }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="child_lname_{{child.id}}" 
                                                    id="child_lname_{{child.id}}" 
                                                    ng-model="child.lname" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}"
                                                     class="form-control form-control" 
                                                     required>
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - child.lname.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'lname')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, lname') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_lname')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.LAST_NAME_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>   
                                    
                                            <div class="form-group">	           
                                                <label for="child_fname_{{child.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.FNAME }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div">                                                 
                                                    <input type="text" 
                                                    name="child_fname_{{child.id}}" 
                                                    id="child_fname_{{child.id}}" 
                                                    ng-model="child.fname" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control" 
                                                    required>
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - child.fname.length }}
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'fname')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'fname') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_fname')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.FIRST_NAME_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>  
                                    
                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.GENDER }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <label for="child_gender_{{child.id}}" class="radio-inline">
                                                    <input type="radio"
                                                    ng-model="child.gender"                                                      
                                                    value="M" 
                                                    name="child_gender_{{child.id}}"
                                                     id="child_gender_{{child.id}}" 
                                                     ng-required=" !child_gender_{{child.id}} ">
	                                                     M
                                                     </label>
                                                     
                                                    <label for="child_gender_f_{{child.id}}" class="radio-inline">
                                                    <input type="radio"
                                                    ng-model="child.gender"                                                      
                                                    value="F" 
                                                    name="child_gender_{{child.id}}" 
                                                    id="child_gender_f_{{child.id}}" 
                                                    ng-required=" !child_gender_{{child.id}} ">
                                                    	F
                                                    </label>
                                                    
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'gender')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'gender') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.hasErrors(child.id, 'child_gender')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.GENDER_REQUIRED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>  
                                                                        
                                            <div class="form-group">	            
                                                <label for="child_birth_date_{{ child.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.DATE_OF_BIRTH }}</span>
                                                </label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <div class="input-group">
                                                        <input type="text" 
                                                        name="child_birth_date_{{ child.id }}"
                                                        id="child_birth_date_{{ child.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                        ng-model="mainFdCtrl.relatives[child.id].birth_date.date" 
                                                        ng-model-options="{ updateOn: 'blur' }"
                                                        is-open="mainFdCtrl.relatives[child.id].birth_date.popup.opened" 
                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                        datepicker-append-to-body="true"                                           
                                                        close-text="Close"   
                                                        ng-change="mainFdCtrl.setAge(child.id)"   
                                                        required>
                                                        <span class="input-group-btn">
                                                            <button type="button" 
                                                            class="btn btn-default" 
                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[child.id].birth_date)">
                                                                <i class="glyphicon glyphicon-calendar"></i>
                                                            </button>
                                                        </span>
                                                    </div>                                         
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'birth_date')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'birth_date') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'birth_date')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.BIRTHDATE_REQUIRED }}</span>  
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                    </div> 
                                                </div>                                            
                                            </div>     
                                            
                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label"><span class="label label-primary">{{ mainFdCtrl.str.AGE }}</span></label>                         
                                                <div class="col-sm-8 form-control-div">                                                       
                                                   <p class="form-control-static">{{ mainFdCtrl.relatives[child.id].age }}</p>                                                      
                                                </div>  
                                            </div>                                                                                                                                            
                                            
<!---                                            <div class="form-group">                                     
                                                <label for="child_citizenship_1_country_name_{{ child.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
                                                </label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <angucomplete-alt 
                                                        id="child_citizenship_1_country_name_{{ child.id }}" 
                                                        input-name="child_citizenship_1_country_name_{{ child.id }}"                                    
                                                        placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                        pause="100"
                                                        selected-object="mainFdCtrl.setSelectedOption"                                               
                                                        selected-object-data="child_citizenship_1_country_code_{{ child.id }}" 
                                                        initial-value="mainFdCtrl.relatives[child.id].citizenship_1_country.country"
                                                        local-data="mainFdCtrl.countries['LIB']"
                                                        search-fields="name"
                                                        title-field="name"                                   
                                                        minlength="1"                                    
                                                        input-class="form-control form-control-small required"
                                                        field-required="true"
                                                    />  
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'citizenship_1_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('child', child.id, 'citizenship_1_country_code') }}</div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_citizenship_1_country_name')" class="errors"> 
                                                        <span ng-message="autocomplete-required">{{ mainFdCtrl.str.CITIZENSHIP_REQUIRED }}</span>  
                                                    </div>             
                                                </div>
                                            </div> --->  
                                            
                                            
											<div class="form-group">                                              
                                                <label for="child_citizenship_1_country_name_{{ child.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
												</label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="child_citizenship_1_country_name_{{ child.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['child_citizenship_1_country_' + child.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small" 
                                                    ng-class="required" 
                                                    required="true">   
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'citizenship_1_country_code')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('child', child.id, 'citizenship_1_country_code') ) }}
                                                    </div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'citizenship_1_country_name')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div> 
                                            
<!---                                            <div class="form-group">                                     
                                                <label for="child_citizenship_2_country_name_{{ child.id }}" class="col-sm-3 control-label"><span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span></label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <angucomplete-alt 
                                                        id="child_citizenship_2_country_name_{{ child.id }}" 
                                                        input-name="child_citizenship_2_country_name_{{ child.id }}"                                    
                                                        placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                        pause="100"
                                                        selected-object="mainFdCtrl.setSelectedOption"                                               
                                                        selected-object-data="child_citizenship_2_country_code_{{ child.id }}" 
                                                        initial-value="mainFdCtrl.relatives[child.id].citizenship_2_country.country"
                                                        local-data="mainFdCtrl.countries['LIB']"
                                                        search-fields="name"
                                                        title-field="name"                                   
                                                        minlength="1"                                    
                                                        input-class="form-control form-control-small"                                                
                                                    />  
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'citizenship_2_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('child', child.id, 'citizenship_2_country_code') }}</div>           
                                                </div>
                                            </div> ---> 
                                            
											<div class="form-group">                                              
                                                <label for="child_citizenship_2_country_name_{{ child.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span>
												</label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="child_citizenship_2_country_name_{{ child.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['child_citizenship_2_country_' + child.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small">   
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'citizenship_2_country_code')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('child', child.id, 'citizenship_2_country_code') ) }}
                                                    </div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'citizenship_2_country_name')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div>   
                                            
                                            <div class="form-group">	           
                                                <label class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.DEPENDENT }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <label for="child_is_dependent_{{child.id}}" class="radio-inline">
                                                        <input type="radio" 
                                                        ng-model="child.is_dependent"
                                                        value="Y" 
                                                        name="child_is_dependent_{{child.id}}" 
                                                        id="child_is_dependent_{{child.id}}" 
                                                        ng-required=" !child_is_dependent_{{child.id}} ">
                                                   		<span ng-bind-html="mainFdCtrl.str.YES"></span>
                                                    </label>
                                                    
                                                    <label for="child_is_dependent_n_{{child.id}}" class="radio-inline">
                                                        <input type="radio"
                                                        ng-model="child.is_dependent" 
                                                        value="N" 
                                                        name="child_is_dependent_{{child.id}}" 
                                                        id="child_is_dependent_n_{{child.id}}" 
                                                        ng-required=" !child_is_dependent_{{child.id}} ">
                                                    	<span ng-bind-html="mainFdCtrl.str.NO"></span>
                                                    </label>
                                                    
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'is_dependent')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.str[ mainFdCtrl.getAlt('child', child.id, 'is_dependent') ] }} 
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.hasErrors(child.id, 'child_is_dependent')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.IS_DEPENDENT_REQUIRED }}</span>
                                                    </div> 
                                                </div>  
                                            </div> 
                                            
                                            <div class="form-group">	            
                                                <label for="child_dependent_since_{{ child.id }}" class="col-sm-3 control-label">
                                                    <span class="label" 
                                                    ng-class="child.is_dependent == 'Y' ? 'label-warning starred': 'label-primary'">
                                                        {{ mainFdCtrl.str.SINCE }}
                                                    </span>
                                                </label>  
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input 
                                                        type="text" 
                                                        name="child_dependent_since_{{ child.id }}"
                                                        id="child_dependent_since_{{ child.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                        ng-model="mainFdCtrl.relatives[child.id].dependent_since.date" 
                                                        ng-model-options="{ updateOn: 'blur' }"
                                                        is-open="mainFdCtrl.relatives[child.id].dependent_since.popup.opened" 
                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                        datepicker-append-to-body="true"                                           
                                                        close-text="Close"     
                                                        ng-required=" child.is_dependent == 'Y' "
                                                        />
                                                        <span class="input-group-btn">
                                                            <button type="button" 
                                                            class="btn btn-default" 
                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[child.id].dependent_since)">
                                                            	<i class="glyphicon glyphicon-calendar"></i>
                                                            </button>
                                                        </span>
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'dependent_since')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'dependent_since') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_dependent_since')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.DEPENDENT_SINCE_REQUIRED }}</span>  
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                    </div>                                                                                                                   
                                                </div>   
                                            </div>                                      
                                            
                                        </div> <!--- end panel-body--->                                            
                                        
                                    </div>  <!---end panel-collapse--->                                          
                                
                                </div><!--- end sub-panel  1--->  
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 2--->
                                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 2 (child id: {{ child.id }})" 
                                            data-target=".child-{{ child.id }}-subpanel-2" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.SCHOOL_INFO }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse child-{{ child.id }}-subpanel-2">   
                    
                                        <div class="panel-body">  
                                        
                                            <div class="form-group">	           
                                                <label for="child_school_name_{{child.id}}" class="col-sm-3 control-label">
                                                	<span class="label label-primary">{{ mainFdCtrl.str.NAME }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="child_school_name_{{child.id}}" 
                                                    id="child_school_name_{{child.id}}" 
                                                    ng-model="child.school_name" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - child.school_name.length }}
                                                    </div>  
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_name')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'school_name') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_school_name')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.NAME_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>  
                                            
                                            <div class="form-group">	           
                                                <label for="child_school_address_{{child.id}}" class="col-sm-3 control-label">
                                                	<span class="label" ng-class="child.school_name ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.ADDRESS }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <textarea name="child_school_address_{{child.id}}" 
                                                    id="child_school_address_{{child.id}}" 
                                                    ng-model="child.school_address" 
                                                    ng-maxlength="{{ mainFdCtrl.addressLength }}" 
                                                    class="form-control form-control" 
                                                    ng-required=" child.school_name ">
                                                    </textarea>
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.addressLength - child.school_address.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_address')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'school_address') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_school_address')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.ADDRESS_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>  
                                            
                                            <div class="form-group">	           
                                                <label for="child_school_city_{{child.id}}" class="col-sm-3 control-label">
                                                	<span class="label" 
                                                    ng-class="child.school_name ? 'label-warning starred': 'label-primary'">
                                                    	{{ mainFdCtrl.str.CITY }}
                                                    </span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="child_school_city_{{child.id}}" 
                                                    id="child_school_city_{{child.id}}" 
                                                    ng-model="child.school_city" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control" 
                                                    ng-required=" child.school_name ">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - child.school_city.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_city')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'school_city') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_school_city')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.CITY_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>   
                                            
                                            <div class="form-group">	           
                                                <label for="child_school_postal_code_{{child.id}}" class="col-sm-3 control-label">
                                                	<span class="label" ng-class="child.school_name ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.POSTAL_CODE }}</span>
                                                </label>                         
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="child_school_postal_code_{{child.id}}" 
                                                    id="child_school_postal_code_{{child.id}}" 
                                                    ng-model="child.school_postal_code" 
                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                    class="form-control form-control" 
                                                    ng-required=" child.school_name ">
                                                    <div class="help-block">
                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - child.school_postal_code.length }}
                                                    </div> 
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_postal_code')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('child', child.id, 'school_postal_code') }}
                                                    </div>  
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_school_postal_code')" class="errors"> 
                                                       <span ng-message="required">{{ mainFdCtrl.str.POSTAL_CODE_REQUIRED }}</span>
                                                       <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                    </div> 
                                                </div>  
                                            </div>                                                                                         
                                            
<!---                                             <div class="form-group">                                                
                                                <label for="child_school_country_name_{{ child.id }}" class="col-sm-3 control-label"><span class="label" ng-class="child.school_name ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.COUNTRY }}</span></label>  
                                                <div class="col-sm-8 form-control-div">  
                                                    <angucomplete-alt 
                                                        id="child_school_country_name_{{ child.id }}" 
                                                        input-name="child_school_country_name_{{ child.id }}"                                    
                                                        placeholder="{{mainFdCtrl.str.PLEASE_SELECT}}"
                                                        pause="100"
                                                        selected-object="mainFdCtrl.setSelectedOption"                                               
                                                        selected-object-data="child_school_country_code_{{ child.id }}" 
                                                        initial-value="mainFdCtrl.relatives[child.id].school_country.country"
                                                        local-data="mainFdCtrl.countries['LIB']"
                                                        search-fields="name"
                                                        title-field="name"                                   
                                                        minlength="1"                                    
                                                        input-class="form-control form-control-small ng-valid"
                                                        field-required="child.school_name" 
                                                    />  
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('child', child.id, 'school_country_code') }}</div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'child_school_country_name')" class="errors"> 
                                                        <span ng-message="autocomplete-required">{{ mainFdCtrl.str.COUNTRY_REQUIRED }}</span>  
                                                    </div>             
                                                </div>
                                            </div> --->
                                            
											<div class="form-group">                                              
                                                <label for="child_school_country_name_{{ child.id }}" class="col-sm-3 control-label">
                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.COUNTRY }}</span>
												</label>  
                                                <div class="col-sm-8 form-control-div"> 
                                                    <input type="text" 
                                                    name="child_school_country_name_{{ child.id }}" 
                                                    ng-model="mainFdCtrl.ucountries['child_school_country_' + child.id].country" 
                                                    uib-typeahead="country as country.name for country in mainFdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                                    typeahead-append-to-body="true" 
                                                    class="form-control form-control-small" 
                                                    ng-class="required" 
                                                    ng-required=" child.school_name ">   
                                                    <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_country_code')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getCtry( mainFdCtrl.getAlt('child', child.id, 'school_country_code') ) }}
                                                    </div>
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(child.id, 'school_country_name')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                    </div>                                             
                                                </div>
                                            </div>                                               
                                        
                                        </div> <!---end panel-body--->
                                        
                                    </div> <!--- end panel-collapse--->                                                                                                                    
                                
                                </div>  <!---end sub-panel 2--->  
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 3--->
                                
                                    <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('scholarships')">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 3 (child id: {{ child.id }})" 
                                            data-target=".child-{{ child.id }}-subpanel-3" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.SCHOLARSHIPS }} ({{ mainFdCtrl.data.scholarships[child.id].length || 0 }})
                                            </a> 
                                            <i ng-click="mainFdCtrl.addScholarship(child.id)" 
                                            class="pointer-cursor glyphicon glyphicon-plus" 
                                            style="font-size:medium; vertical-align:middle">
                                            </i>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse child-{{ child.id }}-subpanel-3">   
                    
                                        <div class="panel-body">  
                                        
                                            <div ng-repeat="scholarship in mainFdCtrl.data.scholarships[child.id] track by scholarship.id" 
                                            class="panel panel-default fieldset-panel" 
                                            ng-class="mainFdCtrl.getPanelClasses('scholarship', scholarship.id)">
                                            
                                            <input type="hidden" name="scholarship_child_id_{{ scholarship.id }}" value="{{ child.id }}" />    
                                            <input type="hidden" name="scholarship_deleted_{{ scholarship.id }}" value="{{ scholarship.deleted }}" />                                              
                                            
                                                <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('scholarship', scholarship.id)">   
                                                                 
                                                    <h5 class="panel-title">  
                                                    
                                                        <a data-toggle="collapse" 
                                                        class="collapse-link collapsed" 
                                                        title="Click to expand or collapse Scholarship panel (scholarship id: {{ scholarship.id }})" 
                                                        data-target=".scholarship-{{ scholarship.id }}-panel">
                                                        	{{ scholarship.academic_year }}
                                                        </a> 
                                                        
                                                        <i ng-if="scholarship.deleted == 'N' || scholarship.deleted == 'R'" 
                                                        ng-click="mainFdCtrl.removeScholarship(child.id, scholarship.id)" 
                                                        class="pointer-cursor glyphicon glyphicon-remove" 
                                                        style="font-size:medium; vertical-align:middle">
                                                        </i>
                                                         
                                                        <i ng-if="scholarship.deleted == 'Y'" 
                                                        ng-click="mainFdCtrl.restoreScholarship(child.id, scholarship.id)" 
                                                        class="pointer-cursor glyphicon glyphicon-ok" 
                                                        style="font-size:medium; vertical-align:middle">
                                                        </i>
                                                        
                                                    </h5>     
                                                                              
                                                </div>                                                    
                                                
                                                <div class="panel-collapse collapse scholarship-{{ scholarship.id }}-panel"> 
                                                
                                                    <div class="panel-body">    
                                                    
                                                        <div class="row">
                                    
                                                           <div class="form-group">	            
                                                                <label for="scholarship_academic_year_{{ scholarship.id }}" class="col-sm-3 control-label">
                                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.ACADEMIC_YEAR }}</span>
                                                                </label>  
                                                                <div class="col-sm-8 form-control-div">                  
                                                                    <input type="test" 
                                                                    ng-model="scholarship.academic_year" 
                                                                    ng-maxlength="{{ mainFdCtrl.academicYearLength }}" 
                                                                    class="form-control" 
                                                                    name="scholarship_academic_year_{{ scholarship.id }}" 
                                                                    id="scholarship_academic_year_{{ scholarship.id }}" 
                                                                    placeholder="Use YYYY or YYYY-YYYY format" 
                                                                    required> 
                                                                    <div class="help-block">
                                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.academicYearLength - scholarship.academic_year.length }}
                                                                    </div> 
                                                                    <p ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'academic_year')" class="help-block alt-data">
                                                                    	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'academic_year') }}
                                                                    </p>
                                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(scholarship.id, 'scholarship_academic_year')" class="errors"> 
                                                                        <span ng-message="required">{{mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                                    </div>                                                                                         
                                                                </div>
                                                            </div>  
                                                    
                                                           <div class="form-group">	            
                                                                <label for="scholarship_nature_{{ scholarship.id }}" class="col-sm-3 control-label">
                                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.NATURE }}</span>
                                                                </label>  
                                                                <div class="col-sm-8 form-control-div">                  
                                                                    <input type="test" 
                                                                    ng-model="scholarship.nature" 
                                                                    ng-maxlength="{{ mainFdCtrl.maxFieldLength }}" 
                                                                    class="form-control" 
                                                                    name="scholarship_nature_{{ scholarship.id }}" 
                                                                    id="scholarship_nature_{{ scholarship.id }}" 
                                                                    required>
                                                                    <div class="help-block">
                                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.maxFieldLength - scholarship.scholarship_nature.length }}
                                                                    </div> 
                                                                    <p ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'nature')" class="help-block alt-data">
                                                                    	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'nature') }}
                                                                    </p>
                                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(scholarship.id, 'scholarship_nature')" class="errors"> 
                                                                        <span ng-message="required">{{mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                                    </div>                                                                                         
                                                                </div>
                                                            </div>  
                                                            
                                                           <div class="form-group">	            
                                                                <label for="scholarship_monthly_amount_{{ scholarship.id }}" class="col-sm-3 control-label">
                                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.MONTHLY_AMOUNT }}</span>
                                                                </label>  
                                                                <div class="col-sm-8 form-control-div">                  
                                                                    <input type="text" 
                                                                    ng-model="scholarship.monthly_amount" 
                                                                    ng-maxlength="{{ mainFdCtrl.monetaryAmountLength }}" 
                                                                    class="form-control" 
                                                                    name="scholarship_monthly_amount_{{ scholarship.id }}" 
                                                                    id="scholarship_monthly_amount_{{ scholarship.id }}" 
                                                                    required>
                                                                    <div class="help-block">
                                                                    	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.monetaryAmountLength - scholarship.monthly_amount.length }}
                                                                    </div> 
                                                                    <p ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'monthly_amount')" class="help-block alt-data">
                                                                    	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'monthly_amount') }}
                                                                    </p>
                                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(scholarship.id, 'scholarship_monthly_amount')" class="errors"> 
                                                                        <span ng-message="required">{{mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                                    </div>                                                                                         
                                                                </div>
                                                            </div>  
                                    
                                                           <div class="form-group">	            
                                                                <label for="scholarship_comments_{{ scholarship.id }}" class="col-sm-3 control-label">
                                                                	<span class="label label-primary">{{ mainFdCtrl.str.COMMENTS }}</span>
                                                                </label>  
                                                                <div class="col-sm-8 form-control-div">                  
                                                                    <input type="text" 
                                                                    ng-model="scholarship.comments" 
                                                                    ng-maxlength="{{ mainFdCtrl.commentsLength }}" 
                                                                    class="form-control" 
                                                                    name="scholarship_comments_{{ scholarship.id }}" 
                                                                    id="scholarship_comments_{{ scholarship.id }}">
                                                                    <div class="help-block">{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.commentsLength - scholarship.comments.length }}</div> 
                                                                    <p ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'comments')" class="help-block alt-data">
                                                                    	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'comments') }}
                                                                    </p>
                                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(scholarship.id, 'scholarship_comments')" class="errors"> 
                                                                        <span ng-message="required">{{mainFdCtrl.str.COMMENTS_REQUIRED }}</span>
                                                                        <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                                    </div>                                                                                         
                                                                </div>
                                                            </div>     
                                                            
                                                        </div>  <!---end row 1--->
                                                        
                                                        <div class="row">
                                    
                                                            <div class="form-group">	            
                                                                <label class="col-sm-3 control-label">
                                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.DOCUMENT_TO_UPLOAD }}</span>
                                                                </label>  
                                                                <div class="col-sm-8 form-control-div"> 
                                                                   <input type="file" 
                                                                   class="form-control" 
                                                                   id="scholarship_file_{{ scholarship.id }}" 
                                                                   ng-model="scholarship.scholarship_file"
                                                                    name="scholarship_file_{{ scholarship.id }}"/> 
                                                                </div>
                                                            </div>        
                                                            
                                                            <div class="form-group">	            
                                                                <label class="col-sm-3 control-label">
                                                                	<span class="label label-primary-alt">{{ mainFdCtrl.str.CURRENT_DOCUMENT }}</span>
                                                                </label>   
                                                                <div class="col-sm-8 form-control-div"> 
                                                                
                    												<span ng-if="scholarship.scholarship_filename" 
                                                                    class="form-control no-border file-link" 
                                                                    ng-click="mainFdCtrl.openScholarshipFile(scholarship.id, 'main')">
                                                                    	{{ scholarship.scholarship_filename }}
                                                                    </span>
                                                                    
                    												<span ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, scholarship.upld_hash)" 
                                                                    class="form-control no-border alt-file-link alt-data" 
                                                                    style="width:50%" 
                                                                    ng-click="mainFdCtrl.openScholarshipFile(scholarship.id, mainFdCtrl.getAlt('scholarship', scholarship.id, 'upld_hash'))">
                                                                    	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'scholarship_filename') }}
                                                                    </span>
                                                                    
                                                                </div>
                                                            </div>
                                                        
                                                        </div>  <!---end row 2--->                 
                                                    
                                                    </div> <!---end panel body--->
                                                    
                                                </div>  <!---end scholarship panel collapse--->
                                                
                                            </div>  <!---end scholarship repeat--->            
                                        
                                        </div> <!---end panel-body--->
                                        
                                    </div> <!--- end panel-collapse--->                                                                                                                    
                                
                                </div>  <!---end sub-panel 3--->                                      
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 4--->
                                
                                    <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('certificates')">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 4 (child id: {{ child.id }})" 
                                            data-target=".child-{{ child.id }}-subpanel-4" 
                                            style="font-size:18px; padding-left:10px">
                                            {{ mainFdCtrl.str.CERTIFICATES }} ({{ mainFdCtrl.data.certificates[child.id].length || 0 }})
                                            </a> 
                                            
                                            <i ng-if="mainFdCtrl.canAddCertificate(child.id)" ng-click="mainFdCtrl.addCertificate(child.id)" 
                                            class="pointer-cursor glyphicon glyphicon-plus" 
                                            style="font-size:medium; vertical-align:middle">
                                            </i>   
                                                                    
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse child-{{ child.id }}-subpanel-4">   
                    
                                        <div class="panel-body">  
                                        
                                            <div ng-repeat="certificate in mainFdCtrl.data.certificates[child.id] track by certificate.id" 
                                            class="panel panel-default fieldset-panel" 
                                            ng-class="mainFdCtrl.getPanelClasses('certificate', certificate.id)">
                                                                                        
                                                <input type="hidden" name="certificate_child_id_{{ certificate.id }}" value="{{ child.id }}" />      
                                                <input type="hidden" name="certificate_deleted_{{ certificate.id }}" value="{{ certificate.deleted }}" />    
                                            
                                                <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('certificate', certificate.id)"> 
                                                                   
                                                    <h5 class="panel-title"> 
                                                    
                                                        <i ng-if="certificate.deleted == 'N' || certificate.deleted == 'R'" 
                                                        ng-click="mainFdCtrl.removeCertificate(child.id, certificate.id)" 
                                                        class="pointer-cursor glyphicon glyphicon-remove" 
                                                        style="font-size:medium; vertical-align:middle">
                                                        </i>
                                                        
                                                        <i ng-if="certificate.deleted == 'Y'" 
                                                        ng-click="mainFdCtrl.restoreCertificate(child.id, certificate.id)" 
                                                        class="pointer-cursor glyphicon glyphicon-ok" 
                                                        style="font-size:medium; vertical-align:middle">
                                                        </i>                                                     
                                                    
                                                        <a data-toggle="collapse" 
                                                        class="collapse-link collapsed" 
                                                        title="Click to expand or collapse Certificate panel (certificate id: {{ certificate.id }})" 
                                                        data-target=".certificate-{{ certificate.id }}-panel">
                                                        {{ certificate.validity_from }} - {{ certificate.validity_until }}
                                                        </a>
                                                        
                                                    </h5>  
                                                                              
                                                </div>  
                                                
                                                <div class="panel-collapse collapse certificate-{{ certificate.id }}-panel"> 
                                                
                                                    <div class="panel-body">    
                                                    
                                                        <div class="row">

                                                            <div class="form-group">	            
                                                                <label for="certificate_validity_from_{{ certificate.id }}" class="col-sm-3 control-label">
                                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.VALID_FROM }}</span>
                                                                </label>  
                                                                <div class="col-sm-8 form-control-div">
                                                                    <div class="input-group">
                                                                        <input 
                                                                        type="text" 
                                                                        name="certificate_validity_from_{{ certificate.id }}"
                                                                        id="certificate_validity_from_{{ certificate.id }}"
                                                                        class="form-control"                                             
                                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                                        ng-model="mainFdCtrl.certificates[certificate.id].validity_from.date" 
                                                                        ng-model-options="{ updateOn: 'blur' }"
                                                                        is-open="mainFdCtrl.certificates[certificate.id].validity_from.popup.opened" 
                                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                                        datepicker-append-to-body="true"                                           
                                                                        close-text="Close"     
                                                                        required>
                                                                        <span class="input-group-btn">
                                                                            <button type="button" 
                                                                            class="btn btn-default" 
                                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.certificates[certificate.id].validity_from)">
                                                                            	<i class="glyphicon glyphicon-calendar"></i>
                                                                            </button>
                                                                        </span>
                                                                    </div>
                                                                    <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'validity_from')" class="help-block alt-data">
                                                                    	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'validity_from') }}
                                                                    </div> 
                                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(certificate.id, 'certificate_validity_from')" class="errors"> 
                                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                                    </div>         
                                                                </div>  
                                                            </div> 
                                                        
                                                            <div class="form-group">	            
                                                                <label for="certificate_validity_until_{{ certificate.id }}" class="col-sm-3 control-label">
                                                                	<span class="label label-warning starred">{{ mainFdCtrl.str.TIME_UNTIL }}</span>
                                                                </label>  
                                                                <div class="col-sm-8">
                                                                    <div class="input-group">
                                                                        <input 
                                                                        type="text" 
                                                                        name="certificate_validity_until_{{ certificate.id }}"
                                                                        id="certificate_validity_until_{{ certificate.id }}"
                                                                        class="form-control"                                             
                                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                                        ng-model="mainFdCtrl.certificates[certificate.id].validity_until.date" 
                                                                        ng-model-options="{ updateOn: 'blur' }"
                                                                        is-open="mainFdCtrl.certificates[certificate.id].validity_until.popup.opened" 
                                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                                        datepicker-append-to-body="true"                                           
                                                                        close-text="Close"     
                                                                        required>
																		<span class="input-group-btn">
                                                                            <button type="button" 
                                                                            class="btn btn-default" 
                                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.certificates[certificate.id].validity_until)">
                                                                            	<i class="glyphicon glyphicon-calendar"></i>
                                                                            </button>
                                                                        </span>
                                                                    </div>
                                                                    <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'validity_until')" class="help-block alt-data">
                                                                    	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'validity_until') }}
                                                                    </div> 
                                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(certificate.id, 'certificate_validity_until')" class="errors"> 
                                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                                    </div>                                                                     
                                                                </div>  
                                                            </div>       
                                                        
                                                            <div class="form-group">	            
                                                                <label for="certificate_reception_date_{{ certificate.id }}" class="col-sm-3 control-label"><span class="label label-warning starred">
                                                                	{{ mainFdCtrl.str.RECEPTION_DATE }}</span>
                                                                </label>  
                                                                <div class="col-sm-8">
                                                                    <div class="input-group">
                                                                        <input 
                                                                        type="text" 
                                                                        name="certificate_reception_date_{{ certificate.id }}"
                                                                        id="certificate_reception_date_{{ certificate.id }}"
                                                                        class="form-control"                                             
                                                                        uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                                        ng-model="mainFdCtrl.certificates[certificate.id].reception_date.date" 
                                                                        ng-model-options="{ updateOn: 'blur' }"
                                                                        is-open="mainFdCtrl.certificates[certificate.id].reception_date.popup.opened" 
                                                                        datepicker-options="mainFdCtrl.dateOptions"  
                                                                        datepicker-append-to-body="true"                                           
                                                                        close-text="Close"     
                                                                        required>
                                                                        <span class="input-group-btn">
                                                                            <button type="button" 
                                                                            class="btn btn-default" 
                                                                            ng-click="mainFdCtrl.popup(mainFdCtrl.certificates[certificate.id].reception_date)">
                                                                            	<i class="glyphicon glyphicon-calendar"></i>
                                                                            </button>
                                                                        </span>
                                                                    </div>
                                                                    <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'reception_date')" class="help-block alt-data">
                                                                    	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'reception_date') }}
                                                                    </div> 
                                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(certificate.id, 'certificate_reception_date')" class="errors"> 
                                                                        <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                                    </div>                                                                     
                                                                </div>  
                                                            </div>   
                                                                                        
                                                            <div class="form-group">	            
                                                            <label for="medical_center" class="col-sm-3 control-label">
                                                            	<span class="label label-warning">{{ mainFdCtrl.str.COMMENTS }}</span>
                                                            </label>  
                                                            <div class="col-sm-8 form-control-div">                  
                                                                <input type="text" 
                                                                ng-model="certificate.comments" 
                                                                ng-maxlength="{{ mainFdCtrl.commentsLength }}" 
                                                                class="form-control" 
                                                                name="certificate_comments_{{ certificate.id }}"
                                                                id="certificate_comments_{{ certificate.id }}"> 
                                                                <div class="help-block">
                                                                	{{ mainFdCtrl.str.CHARS_LEFT }}: {{ mainFdCtrl.commentsLength - certificate.comments.length }}
                                                                </div>  
                                                                <p ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'comments')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'comments') }}
                                                                </p>
                                                                <div ng-messages="mainFdCtrl.isTouchedWithErrors(certificate.id, 'certificate_comments')" class="errors"> 
                                                                    <span ng-message="required">{{mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                                                    <span ng-message="maxlength">{{ mainFdCtrl.str.MAX_CHARS_EXCEEDED }}</span>
                                                                </div>                                                                                         
                                                            </div>
                                                        </div>     
                                                        
                                                        </div>  <!---end row 1--->
                                                                
                                                        <div class="row">
                                
                                                            <div class="form-group">	            
                                                                <label class="col-sm-3 control-label">
                                                               		<span class="label label-primary-alt">{{ mainFdCtrl.str.DOCUMENT }}</span>
                                                                </label>  
                                                                <div class="col-sm-8 form-control-div"> 
                                                                   <input type="file" 
                                                                   class="form-control" id="certificate_file_{{ certificate.id }}" 
                                                                   ng-model="certificate.certificate_file" 
                                                                   name="certificate_file_{{ certificate.id }}"> 
                                                                </div>
                                                            </div>        
                                                        
                                                            <div class="form-group">	            
                                                                <label class="col-sm-3 control-label">
                                                                	<span class="label label-primary-alt">{{ mainFdCtrl.str.CURRENT_DOCUMENT }}</span>
                                                                </label>   
                                                                <div class="col-sm-8 form-control-div"> 
                                                                
                                                                    <span ng-if="certificate.certificate_filename" 
                                                                    class="form-control no-border file-link" 
                                                                    ng-click="mainFdCtrl.openCertificateFile(certificate.id, certificate.upld_hash)">
                                                                    	{{ certificate.certificate_filename }}
                                                                    </span>
                
                													<span ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'certificate_filename')" 
                                                                    class="form-control no-border alt-file-link alt-data" 
                                                                    style="width:50%" 
                                                                    ng-click="mainFdCtrl.openCertificateFile(certificate.id, mainFdCtrl.getAlt('certificate', certificate.id, 'upld_hash'))">
                                                                    	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'certificate_filename') }}
                                                                    </span>
                                                                    
                                                                </div>
                                                            </div>
                                                    
                                                        </div>  <!---end row 2--->    
                                                        
                                                    </div>  <!---end panel-body--->
                                                    
                                                </div>  <!---end certificate panel-collapse--->
                                                
                                            </div>  <!---end certificate repeat--->
                                            
                                        </div>  <!---end panel-body--->     
                                        
                                    </div>  <!---end panel-collapse--->
                                    
                                </div> <!--- end sub-panel 4--->                          
                                
                            </div>  <!---end panel-group--->
                            
                        </div>  <!---end panel-collapse--->                                                           						                                
                    
                    </div> <!--- end panel--->
                
                </div> <!---end child repeat--->
                </div> <!---end col-sm-6--->
                </div> <!---end parity repeat--->
                
            </div>  <!---end error flagging --->			
            
		</div> <!---end children row--->
        
<!--- C. OTHER RELATIVE(S) --->       
    
        <!---<div class="row" ng-show="mainFdCtrl.relatives_count">--->
        <div class="row" ng-show="mainFdCtrl.data.relatives">
        
            <!---<div class="col-sm-12">--->
            
                <div class="stop-error-flagging">  
                    
                    <div class="panel-heading">                    
                        <h4 class="panel-title">  
                            <span>{{ (mainFdCtrl.data.relatives.length == 0) ?  mainFdCtrl.str.NO_RELATIVES : (mainFdCtrl.data.relatives.length > 1) ? mainFdCtrl.str.RELATIVES : mainFdCtrl.str.RELATIVE }} </span>
                        </h4>                            
                    </div>       
                    
    	            <div ng-repeat="parity in ['e','o']" ng-if="parity == 'e' ? tmp = 'e' : tmp = 'o'">
	                <div class="col-sm-6">                    
					<div ng-repeat="relative in mainFdCtrl.data.relatives track by relative.id" ng-if="parity == 'e' ? $even : $odd"> 
                  	<input type="hidden" name="relative_family_link_{{ relative.id }}" value="{{ relative.family_link }}" />
                    <input type="hidden" name="relative_deleted_{{ relative.id }}" value="{{ relative.deleted }}" />
                    
                    	<div class="panel panel-default fieldset-panel">
                    
                            <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('relative', relative.id)">       
                                <h4 class="panel-title">  
                                                      
                                    <a data-toggle="collapse" 
                                    class="collapse-link collapsed" 
                                    title="Click to expand or collapse panel (relative id: {{ relative.id }})" 
                                    data-target=".relative-{{ relative.id }}-panel">
                                    	{{relative.lname}} {{relative.fname}}
                                    </a>    
                                                                     
                                    <i ng-if="relative.deleted == 'N' || relative.deleted == 'R'" 
                                    ng-click="mainFdCtrl.removeRelative(relative.id, 'relative')" 
                                    class="pointer-cursor glyphicon glyphicon-remove" 
                                    style="font-size:medium; vertical-align:middle">
                                    </i> 
                                    
                                    <i ng-if="relative.deleted == 'Y'" ng-click="mainFdCtrl.restoreRelative(relative.id, 'relative')" 
                                    class="pointer-cursor glyphicon glyphicon-ok" 
                                    style="font-size:medium; vertical-align:middle">
                                    </i>    
                                                                                                        
                                </h4>                                                            
                            </div>  
                            
                            <div class="panel-body" style="padding-left:15px; padding-right:15px">  
                            
                                <div class="row"> 
                                    <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str[relative.family_link] }}</div>
                                    <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.DOB }}: {{ relative.birth_date || '[...]' }}</div>
                                    <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.GENDER }}: {{ relative.gender || '[...]' }}</div>
                                    <div ng-if="relative.is_dependent == 'Y'" class="col-sm-2 relative-overview">{{ mainFdCtrl.str.DEPENDENT_SINCE }} {{ relative.dependent_since}}</div>
                                    <div ng-if="relative.is_dependent == 'N'" class="col-sm-2 relative-overview">{{ mainFdCtrl.str.NOT_DEPENDENT }}</div>                         
                                </div> 
                            
                            </div>                             
                        
                        	<div class="panel-collapse collapse relative-{{ relative.id }}-panel"> 
                            
								<div class="panel-group sub-panel-container">  
                                
                                	<div class="panel panel-default fieldset-panel"> <!---sub-panel 1--->
                    
                                        <div class="panel-heading">                    
                                            <h4 class="panel-title">                        
                                                <a data-toggle="collapse" 
                                                class="collapse-link collapsed" 
                                                title="Click to expand or collapse sub-panel 1 (relative id: {{ relative.id }})" 
                                                data-target=".relative-{{ relative.id }}-subpanel-1" 
                                                style="font-size:18px; padding-left:10px">
                                                	{{ mainFdCtrl.str.PERSONAL_DATA }}
                                                </a>                            
                                            </h4>                            
                                        </div>     
                                        
                            			<div class="panel-collapse collapse relative-{{ relative.id }}-subpanel-1">   
                        
                                            <div class="panel-body"> 
                                                                        
                                                <div class="form-group">	           
                                                    <label for="relative_lname_{{relative.id}}" class="col-sm-3 control-label">
                                                    	<span class="label label-warning starred">{{ mainFdCtrl.str.LNAME }}</span>
                                                    </label>                         
                                                    <div class="col-sm-8 form-control-div"> 
                                                        <input type="text" 
                                                        name="relative_lname_{{relative.id}}" 
                                                        id="relative_lname_{{relative.id}}" 
                                                        ng-model="relative.lname"
                                                        class="form-control form-control" 
                                                        required>
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'lname')" class="help-block alt-data">
                                                        	{{ mainFdCtrl.getAlt('relative', relative.id, 'lname') }}
                                                        </div>  
                                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'relative_lname')" class="errors"> 
                                                           <span ng-message="required">{{ mainFdCtrl.str.LAST_NAME_REQUIRED }}</span>
                                                        </div> 
                                                    </div>  
                                                </div>    
                                                
                                                <div class="form-group">	           
                                                    <label for="relative_fname_{{relative.id}}" class="col-sm-3 control-label">
                                                    	<span class="label label-warning starred">{{ mainFdCtrl.str.FNAME }}</span>
                                                    </label>                         
                                                    <div class="col-sm-8 form-control-div"> 
                                                        <input type="text" 
                                                        name="relative_fname_{{relative.id}}" 
                                                        id="relative_fname_{{relative.id}}" 
                                                        ng-model="relative.fname" 
                                                        class="form-control form-control" 
                                                        required>
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'fname')" class="help-block alt-data">
                                                        	{{ mainFdCtrl.getAlt('relative', relative.id, 'fname') }}
                                                        </div>  
                                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'relative_fname')" class="errors"> 
                                                           <span ng-message="required">{{ mainFdCtrl.str.FIRST_NAME_REQUIRED }}</span>
                                                        </div> 
                                                    </div>  
                                                </div> 
                                                
                                                <div class="form-group">	           
                                                    <label class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainFdCtrl.str.GENDER }}</span></label>                         
                                                    <div class="col-sm-8 form-control-div"> 
                                                    
                                                        <label for="relative_gender_{{relative.id}}" class="radio-inline">
                                                            <input type="radio"
                                                            ng-model="relative.gender"                                                              
                                                            value="M" 
                                                            name="relative_gender_{{relative.id}}" 
                                                            id="relative_gender_{{relative.id}}" 
                                                            ng-required=" !relative_gender_{{relative.id}} ">
                                                            M
                                                        </label>
                                                        
                                                        <label for="relative_gender_f_{{relative.id}}" class="radio-inline">
                                                            <input 
                                                            ng-model="relative.gender" 
                                                            type="radio" 
                                                            value="F" 
                                                            name="relative_gender_{{relative.id}}" 
                                                            id="relative_gender_f_{{relative.id}}" 
                                                            ng-required=" !relative_gender_{{relative.id}} ">
                                                            F
                                                        </label>
                                                        
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'gender')" class="help-block alt-data">
                                                        	{{ mainFdCtrl.getAlt('relative', relative.id, 'gender') }}
                                                        </div>  
                                                        <div ng-messages="mainFdCtrl.hasErrors(relative.id, 'relative_gender')" class="errors"> 
                                                           <span ng-message="required">{{ mainFdCtrl.str.GENDER_REQUIRED }}</span>
                                                        </div> 
                                                    </div>  
                                                </div>  
                                                                                    
                                                <div class="form-group">	            
                                                    <label for="relative_birth_date_{{ relative.id }}" class="col-sm-3 control-label">
                                                    	<span class="label label-warning starred">{{ mainFdCtrl.str.DATE_OF_BIRTH }}</span>
                                                    </label>  
                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                            <input 
                                                            type="text" 
                                                            name="relative_birth_date_{{ relative.id }}"
                                                            id="relative_birth_date_{{ relative.id }}"
                                                            class="form-control"                                             
                                                            uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                            ng-model="mainFdCtrl.relatives[relative.id].birth_date.date" 
                                                            ng-model-options="{ updateOn: 'blur' }"
                                                            is-open="mainFdCtrl.relatives[relative.id].birth_date.popup.opened" 
                                                            datepicker-options="mainFdCtrl.dateOptions"  
                                                            datepicker-append-to-body="true"                                           
                                                            close-text="Close"     
                                                            required>
                                                            <span class="input-group-btn">
                                                                <button type="button" 
                                                                class="btn btn-default" 
                                                                ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[relative.id].birth_date)">
                                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                                </button>
                                                            </span>
                                                        </div>
                                                    </div>                                         
                                                    <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'birth_date')" class="help-block alt-data">
                                                    	{{ mainFdCtrl.getAlt('relative', relative.id, 'birth_date') }}
                                                    </div> 
                                                    <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'relative_birth_date')" class="errors"> 
                                                        <span ng-message="required">{{ mainFdCtrl.str.BIRTHDATE_REQUIRED }}</span>  
                                                        <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                    </div> 
                                                </div>                                                  
                                                
<!---                                                <div class="form-group">                                     
                                                    <label for="relative_citizenship_1_country_name_{{ relative.id }}" class="col-sm-3 control-label">
                                                    	<span class="label label-warning starred">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
                                                    </label>  
                                                    <div class="col-sm-8 form-control-div">  
                                                        <angucomplete-alt 
                                                            id="relative_citizenship_1_country_name_{{ relative.id }}" 
                                                            input-name="relative_citizenship_1_country_name_{{ relative.id }}"                                    
                                                            placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                            pause="100"
                                                            selected-object="mainFdCtrl.setSelectedOption"                                               
                                                            selected-object-data="relative_citizenship_1_country_code_{{ relative.id }}" 
                                                            initial-value="mainFdCtrl.relatives[relative.id].citizenship_1_country.country"
                                                            local-data="mainFdCtrl.countries['LIB']"
                                                            search-fields="name"
                                                            title-field="name"                                   
                                                            minlength="1"                                    
                                                            input-class="form-control form-control-small ng-valid"
                                                            field-required="true"
                                                        />  
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'citizenship_1_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('relative', relative.id, 'citizenship_1_country_code') }}</div>
                                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'relative_citizenship_1_country_name')" class="errors"> 
                                                            <span ng-message="autocomplete-required">{{ mainFdCtrl.str.CITIZENSHIP_REQUIRED }}</span>  
                                                        </div>             
                                                    </div>
                                                </div>  ---> 
                                                
                                                <div class="form-group">                                              
                                                    <label for="relative_citizenship_1_country_name_{{ relative.id }}" class="col-sm-3 control-label">
                                                        <span class="label label-warning starred">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
                                                    </label>  
                                                    <div class="col-sm-8 form-control-div"> 
                                                        <input type="text" 
                                                        name="relative_citizenship_1_country_name_{{ relative.id }}" 
                                                        ng-model="mainFdCtrl.ucountries['relative_citizenship_1_country_' + relative.id].country" 
                                                        uib-typeahead="country as country.name for country in mainFdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                                        typeahead-append-to-body="true" 
                                                        class="form-control form-control-small" 
                                                        ng-class="required" 
                                                        required="true">   
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'citizenship_1_country_code')" class="help-block alt-data">
                                                            {{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('relative', relative.id, 'citizenship_1_country_code') ) }}
                                                        </div>
                                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'citizenship_1_country_name')" class="errors"> 
                                                            <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                        </div>                                             
                                                    </div>
                                                </div>                                                    
                                                
  <!---                                              <div class="form-group">                                     
                                                    <label for="relative_citizenship_2_country_name_{{ relative.id }}" class="col-sm-3 control-label"><span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span></label>  
                                                    <div class="col-sm-8 form-control-div">  
                                                        <angucomplete-alt 
                                                            id="relative_citizenship_2_country_name_{{ relative.id }}" 
                                                            input-name="relative_citizenship_2_country_name_{{ relative.id }}"                                    
                                                            placeholder="{{ mainFdCtrl.str.PLEASE_SELECT }}"
                                                            pause="100"
                                                            selected-object="mainFdCtrl.setSelectedOption"                                               
                                                            selected-object-data="relative_citizenship_2_country_code_{{ relative.id }}" 
                                                            initial-value="mainFdCtrl.relatives[relative.id].citizenship_2_country.country"
                                                            local-data="mainFdCtrl.countries['LIB']"
                                                            search-fields="name"
                                                            title-field="name"                                   
                                                            minlength="1"                                    
                                                            input-class="form-control form-control-small ng-valid"                                                
                                                        />  
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'citizenship_2_country_code')" class="help-block alt-data">{{ mainFdCtrl.getAlt('relative', relative.id, 'citizenship_2_country_code') }}</div>
                                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'relative_citizenship_2_country_name')" class="errors"> 
                                                            <span ng-message="autocomplete-required">{{ mainFdCtrl.str.CITIZENSHIP_REQUIRED }}</span>  
                                                        </div>             
                                                    </div>
                                                </div>  --->
                                                
                                              	<div class="form-group">                                              
                                                    <label for="relative_citizenship_2_country_name_{{ relative.id }}" class="col-sm-3 control-label">
                                                        <span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
                                                    </label>  
                                                    <div class="col-sm-8 form-control-div"> 
                                                        <input type="text" 
                                                        name="relative_citizenship_2_country_name_{{ relative.id }}" 
                                                        ng-model="mainFdCtrl.ucountries['relative_citizenship_2_country_' + relative.id].country" 
                                                        uib-typeahead="country as country.name for country in mainFdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                                        typeahead-append-to-body="true" 
                                                        class="form-control form-control-small" 
                                                        ng-class="required" 
                                                        required="true">   
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'citizenship_2_country_code')" class="help-block alt-data">
                                                            {{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('relative', relative.id, 'citizenship_2_country_code') ) }}
                                                        </div>
                                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'citizenship_2_country_name')" class="errors"> 
                                                            <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>  
                                                        </div>                                             
                                                    </div>
                                                </div>                                                   
                                                
                                                <div class="form-group">	           
                                                    <label class="col-sm-3 control-label">
                                                    	<span class="label label-warning starred">{{ mainFdCtrl.str.DEPENDENT }}</span>
                                                    </label>                         
                                                    <div class="col-sm-8 form-control-div"> 
                                                    
                                                        <label for="relative_is_dependent_{{relative.id}}" class="radio-inline">
                                                            <input ng-model="relative.is_dependent" 
                                                            type="radio" 
                                                            value="Y" 
                                                            name="relative_is_dependent_{{relative.id}}" 
                                                            id="relative_is_dependent_{{relative.id}}" 
                                                            ng-required=" !relative_is_dependent_{{relative.id}} ">
                                                            <span ng-bind-html="mainFdCtrl.str.YES"></span>
                                                        </label>
                                                        
                                                        <label for="relative_is_dependent_n_{{relative.id}}" class="radio-inline">
                                                            <input ng-model="relative.is_dependent" 
                                                            type="radio" 
                                                            value="N" 
                                                            name="relative_is_dependent_{{relative.id}}" id="relative_is_dependent_n_{{relative.id}}" 
                                                            ng-required=" !relative_is_dependent_{{relative.id}} ">
                                                            <span ng-bind-html="mainFdCtrl.str.NO"></span>
                                                        </label>
                                                        
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'is_dependent')" class="help-block alt-data">
                                                        	{{ mainFdCtrl.str[ mainFdCtrl.getAlt('relative', relative.id, 'is_dependent') ] }} 
                                                        </div>  
                                                        <div ng-messages="mainFdCtrl.hasErrors(relative.id, 'relative_is_dependent')" class="errors"> 
                                                           <span ng-message="required">{{ mainFdCtrl.str.IS_DEPENDENT_REQUIRED }}</span>
                                                        </div> 
                                                    </div>  
                                                </div> 
                                                
                                                <div class="form-group">	            
                                                    <label for="relative_dependent_since_{{ relative.id }}" class="col-sm-3 control-label">
                                                    	<span class="label" ng-class="relative.is_dependent == 'Y' ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.SINCE }}</span>
                                                    </label>  
                                                    <div class="col-sm-8">
                                                        <div class="input-group">
                                                            <input 
                                                            type="text" 
                                                            name="relative_dependent_since_{{ relative.id }}"
                                                            id="relative_dependent_since_{{ relative.id }}"
                                                            class="form-control"                                             
                                                            uib-datepicker-popup="{{mainFdCtrl.format}}" 
                                                            ng-model="mainFdCtrl.relatives[relative.id].dependent_since.date" 
                                                            ng-model-options="{ updateOn: 'blur' }"
                                                            is-open="mainFdCtrl.relatives[relative.id].dependent_since.popup.opened" 
                                                            datepicker-options="mainFdCtrl.dateOptions"  
                                                            datepicker-append-to-body="true"                                           
                                                            close-text="Close"     
                                                            ng-required=" relative.is_dependent == 'Y' ">
                                                            <span class="input-group-btn">
                                                                <button type="button" 
                                                                class="btn btn-default" 
                                                                ng-click="mainFdCtrl.popup(mainFdCtrl.relatives[relative.id].dependent_since)">
                                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                                </button>
                                                            </span>
														</div>  
                                                        <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'dependent_since')" class="help-block alt-data">
                                                        	{{ mainFdCtrl.getAlt('relative', relative.id, 'dependent_since') }}
                                                        </div> 
                                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(relative.id, 'relative_dependent_since')" class="errors"> 
                                                            <span ng-message="required">{{ mainFdCtrl.str.DEPENDENT_SINCE_REQUIRED }}</span>  
                                                            <span ng-message="date">{{ mainFdCtrl.str.PLEASE_USE_EURODATE }}</span>
                                                        </div>                                                                                                                   
													</div>   
                                                </div>                                                                                            
                                            
                                            </div> <!---end panel-body--->                                        
                                        
										</div>  <!---end panel-collapse--->
                                        
									</div>  <!---end panel--->
                                    
								</div>  <!---end panel-group--->
                                
							</div>  <!---end panel-collapse--->                              
                                        
						</div> <!---end panel--->
                        
					</div> <!---end relative repeat--->
	                </div> <!---end col-sm-6--->
    	            </div> <!---end parity repeat--->    
                                    
                    
				</div>  <!---end div--->
                
			<!---</div> --->  <!--- end col--->  
            
		</div>  <!---end relatives row--->          
                
<!--- D. ALLOWANCES --->           
        
        <div class="row">         
            
            <div class="stop-error-flagging">  
                
<!---                <div class="panel-heading">                    
                    <h4 class="panel-title">  
                        <span>[Family Allowances]</span>
                    </h4>                            
                </div>  --->  
              
                <div class="col-sm-6">    
                
                    <div class="panel panel-default fieldset-panel">
                
                        <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses2('allowances', 'top')">                                                
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed" 
                                title="Click to expand or collapse panel" 
                                data-target=".allowances-panel">
                                {{ mainFdCtrl.str.ALLOWANCES }}
                                </a>             
                            </h4>                                                            
                        </div>  
                        
                        <div class="panel-body" style="padding-laft:15px; padding-right:15px">  
                            
                             <span>[Allowance Details]</span>
                            
                        </div>                             
                    
                        <div class="panel-collapse collapse allowances-panel"> 
                    
                            <div class="panel-body">                                             
                                                        
                                <div class="form-group">	           
                                    <label for="allowances_nature" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainFdCtrl.str.ALLOWANCES_NATURE }}</span>
                                    </label>                         
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="allowances_nature" 
                                        id="allowances_nature" 
                                        ng-model="mainFdCtrl.data.allowances_nature" 
                                        class="form-control form-control">
                                        <div ng-if="mainFdCtrl.hasAlt('allowances', 0, 'allowances_nature')" class="help-block alt-data">
                                        	{{ mainFdCtrl.getAlt('allowances', 0, 'allowances_nature') }}
                                        </div>  
                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(0, 'allowances_nature')" class="errors"> 
                                           <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                        </div> 
                                    </div>  
                                </div>    
                                
                                <div class="form-group">	           
                                    <label for="allowances_amount" class="col-sm-3 control-label">
                                    <span class="label" ng-class="mainFdCtrl.data.allowances_nature ? 'label-warning starred': 'label-primary'">
                                    	{{ mainFdCtrl.str.AMOUNT }}
                                    </span>
                                    </label>                         
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="allowances_amount" 
                                        id="allowances_amount" 
                                        ng-model="mainFdCtrl.data.allowances_amount" 
                                        class="form-control form-control" 
                                        ng-required=" mainFdCtrl.allowances_nature ">
                                        <div ng-if="mainFdCtrl.hasAlt('allowances', 0 , 'allowances_amount')" class="help-block alt-data">
                                        	{{ mainFdCtrl.getAlt('allowances', 0, 'allowances_amount') }}
                                        </div>  
                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(0, 'allowances_amount')" class="errors"> 
                                           <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                        </div> 
                                    </div>  
                                </div>                                 
                                
                                <div class="form-group">	           
                                    <label for="allowances_comments" class="col-sm-3 control-label">
                                    	<span class="label" ng-class="mainFdCtrl.data.allowances_nature ? 'label-warning starred': 'label-primary'">{{ mainFdCtrl.str.COMMENTS }}</span>
                                    </label>                         
                                    <div class="col-sm-8 form-control-div">  
										<textarea name="allowances_comments" 
                                        id="allowances_comments" 
                                        ng-model="mainFdCtrl.data.allowances_comments" 
                                        ng-required=" mainFdCtrl.allowances_nature " 
                                        ng-maxlength="{{ mainFdCtrl.commentsLength }}" 
                                        class="form-control form-control" row="3">
                                        </textarea>      
                                        <div ng-if="mainFdCtrl.hasAlt('allowances', 0, 'allowances_comments')" class="help-block alt-data">
                                        	{{ mainFdCtrl.getAlt('allowances', 0,  'allowances_comments') }}
                                        </div>  
                                        <div ng-messages="mainFdCtrl.isTouchedWithErrors(0, 'allowances_comments')" class="errors"> 
                                           <span ng-message="required">{{ mainFdCtrl.str.ITEM_REQUIRED }}</span>
                                        </div> 
                                    </div>  
                                </div>    
                            
                            </div> <!---end panel-body--->     
                            
                        </div>  <!---end panel-collapse--->                              
                                    
                    </div> <!---end panel--->
                
                </div> <!---end col-sm-6--->
                
            </div>  <!---end div--->
            
		</div>  <!---end allowances row--->  
        
        <nav class="navbar navbar-inverse navbar-fixed-bottom">
            <div class="container-fluid">
            
                <button ng-if="vm.hasGrid" class="btn btn-default navbar-btn" name='cancel' value="cancel" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainFdCtrl.str.BACK_TO_GRID }}</button>     
                <button class="btn btn-info navbar-btn" name='view' value="view" ng-click="mainFdCtrl.viewFD()">{{ mainFdCtrl.str.VIEW }}</button>                  
				<button ng-class="(mainFdCtrl.nsmEditFdForm.$invalid) ? 'btn navbar-btn btn-warning' : 'btn navbar-btn btn-success'" name='save' value="save" ng-click="mainFdCtrl.saveFD()">{{ mainFdCtrl.str.SAVE }}</button>      
                <div class="btn-group dropup" style="display:inline-block">
                    <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">{{ mainFdCtrl.str.ADD_RELATIVE }}&nbsp;<span class="caret"></span></button>
                    <ul class="dropdown-menu" style="overflow-y:auto">
                        <li><a ng-click="mainFdCtrl.addRelative('WIFE', $event)" class="pointer-cursor">{{ mainFdCtrl.str.WIFE }}</a></li>
                        <li><a ng-click="mainFdCtrl.addRelative('HUSB', $event)" class="pointer-cursor">{{ mainFdCtrl.str.HUSB }}</a></li>                        
                        <li><a ng-click="mainFdCtrl.addRelative('CHIL', $event)" class="pointer-cursor">{{ mainFdCtrl.str.CHIL }}</a></li>
                        <li><a ng-click="mainFdCtrl.addRelative('FATH', $event)" class="pointer-cursor">{{ mainFdCtrl.str.FATH }}</a></li>
                        <li><a ng-click="mainFdCtrl.addRelative('MOTH', $event)" class="pointer-cursor">{{ mainFdCtrl.str.MOTH }}</a></li> 
                        <li><a ng-click="mainFdCtrl.addRelative('BROT', $event)" class="pointer-cursor">{{ mainFdCtrl.str.BROT }}</a></li> 
                        <li><a ng-click="mainFdCtrl.addRelative('SIST', $event)" class="pointer-cursor">{{ mainFdCtrl.str.SIST }}</a></li> 
                        <li><a ng-click="mainFdCtrl.addRelative('FATL', $event)" class="pointer-cursor">{{ mainFdCtrl.str.FATL }}</a></li> 
						<li><a ng-click="mainFdCtrl.addRelative('MOTL', $event)" class="pointer-cursor">{{ mainFdCtrl.str.MOTL }}</a></li>                                                 
                    </ul>
                </div> 
                
                <ul class="nav navbar-nav navbar-right">
                    <li><a ng-click="mainFdCtrl.expandAll($event)" class="pointer-cursor">{{ mainFdCtrl.str.EXPAND_ALL }}</a></li> 
                    <li><a ng-click="mainFdCtrl.collapseAll($event)" class="pointer-cursor">{{ mainFdCtrl.str.COLLAPSE_ALL }}</a></li>         
                    <li><a ng-click="mainFdCtrl.reload()" class="pointer-cursor">{{ mainFdCtrl.str.RELOAD }}</a></li>
                </ul>
                
            </div>
        </nav>   
        
<ul>
  <li ng-repeat="(key, errors) in mainFdCtrl.nsmEditFdForm.$error track by $index"> <strong>{{ key }}</strong> errors
    <ul>
      <li ng-repeat="e in errors">{{ e.$name }} has an error: <strong>{{ key }}</strong>.</li>
    </ul>
  </li>
</ul>           
        
	</div> <!---end body--->
    
</div> <!---end panel ---> 

</form>

</cfoutput>