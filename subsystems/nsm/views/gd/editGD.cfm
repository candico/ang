
<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });	

    $(".documents-panel").on('show.bs.collapse', function(e){  
		e.stopPropagation();     
		$(".toggle-documents").removeClass("col-sm-6");
		$(".toggle-documents").addClass("col-sm-12");		
    });
	
	$(".documents-panel").on('hide.bs.collapse', function(e){       
		e.stopPropagation();
		$(".toggle-documents").removeClass("col-sm-12");
		$(".toggle-documents").addClass("col-sm-6");		
    });		

</script>

<cfoutput>

<form name="mainGdCtrl.nsmEditGdForm" id="nsmEditGdForm" class="form-horizontal general-data-form" error-flagging update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />
<input type="hidden" name="address_id" id="address_id" value="{{ mainGdCtrl.data.address_id }}">

<div class="panel edit-panel">

	<div class="panel-body">
        
        <staff-banner ng-cloak></staff-banner> 
    
        <div class="row stop-error-flagging">
        
            <div class="col-sm-6">            
            
                <div class="panel-group">        
            
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading " ng-class="mainGdCtrl.getHeadingClasses('personalDetails')">  
                                          
                            <h4 class="panel-title">                    
                                <a data-toggle="collapse" class="collapse-link collapsed personal-details-panel-collapse-link" data-target=".personal-details-panel">
                                	{{ mainGdCtrl.str.PERSONAL_DATA }}
                                </a>    
                            </h4>   
                                             
                        </div>   
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">
                                    {{ mainGdCtrl.data.last_name | cut:true:20 }}, 
                                    {{ mainGdCtrl.data.first_name | cut:true:20 }}, 
                                    {{ mainGdCtrl.data.gender }}, 
                                    aged {{ mainGdCtrl.age }}, 
                                    born in {{ mainGdCtrl.getCtry(mainGdCtrl.data.birth_country_code) }} 
                                    on {{ mainGdCtrl.data.date_of_birth }}. 
                                    {{ mainGdCtrl.getCitiz( mainGdCtrl.data.alt.citizenship_1_country_code) }} citizen.
                                </div>
                                                                
                            </div>     
                        </div>                     
                        
                        <div class="panel-collapse collapse personal-details-panel">
                    
                            <div class="panel-body"> 
                                    
                                <div class="form-group">	           
                                    <label for="last_name" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainGdCtrl.str.LNAME }}</span>
                                    </label>                         
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" name="last_name" ng-model="mainGdCtrl.data.last_name" class="form-control form-control" required/>  
                                        <div ng-if="mainGdCtrl.hasAlt('last_name')" class="help-block alt-data">{{ mainGdCtrl.getAlt('last_name') }}</div>                                       
                                       <!--- <div ng-messages="mainGdCtrl.nsmEditGdForm.last_name.$touched && mainGdCtrl.nsmEditGdForm.last_name.$error" class="errors">---> 
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('last_name')" class="errors"> 
                                           <span ng-message="required">{{ mainGdCtrl.str.LAST_NAME_REQUIRED }}</span>
                                        </div> 
                                    </div>  
                                </div>  
                                
                                <div class="form-group">	           
                                    <label for="first_name" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainGdCtrl.str.FNAME }}</span>
                                    </label>                         
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" name="first_name" ng-model="mainGdCtrl.data.first_name" class="form-control form-control" required/>
                                        <div ng-if="mainGdCtrl.hasAlt('first_name')" class="help-block alt-data">{{ mainGdCtrl.getAlt('first_name') }}</div>                                      
                                        <!---<div ng-messages="mainGdCtrl.nsmEditGdForm.first_name.$touched && mainGdCtrl.nsmEditGdForm.first_name.$error" class="errors"> --->
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('first_name')" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.FIRST_NAME_REQUIRED }}</span>  
                                        </div> 
                                    </div> 
                                </div>         
                            
                                <div class="form-group">	           
                                    <label for="maiden_name" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.MNAME }}</span>
                                    </label>                         
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" name="maiden_name" ng-model="mainGdCtrl.data.maiden_name" class="form-control form-control" />
                                        <div ng-if="mainGdCtrl.hasAlt('maiden_name')" class="help-block alt-data">{{ mainGdCtrl.getAlt('maiden_name') }}</div>  
                                    </div> 
                                </div>    
                            
                                <div class="form-group">	            
                                    <label for="gender" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainGdCtrl.str.GENDER }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                                    
                                        <label class="radio-inline">
                                            <input type="radio" 
                                            ng-model="mainGdCtrl.data.gender" 
                                            value="M" name="gender" 
                                            id="gender" 
                                            ng-required="!mainGdCtrl.data.gender">
                                                M
                                        </label>
                                        
                                        <label class="radio-inline">
                                            <input type="radio" 
                                            ng-model="mainGdCtrl.data.gender" 
                                            value="F" 
                                            name="gender" id="genderF" 
                                            ng-required="!mainGdCtrl.data.gender">
                                                F
                                        </label> 
                                        
                                        <div ng-if="mainGdCtrl.hasAlt('gender')" class="help-block alt-data">{{ mainGdCtrl.getAlt('gender') }}</div> 
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.gender.$error" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.GENDER_REQUIRED }}</span>  
                                        </div>                             
                                    </div>
                                </div>  
                                
<!---                                 <div class="form-group">	            
                                    <label for="birth_country_name" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainGdCtrl.str.COUNTRY_OF_BIRTH }}</span></label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="birth_country_name"
                                            input-name="birth_country_name"                                    
                                            placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                            pause="100"
                                            selected-object="mainGdCtrl.setSelectedOption"
                                            selected-object-data="birth_country_code" 
                                            initial-value="mainGdCtrl.ac.birth_country.country"
                                            local-data="mainGdCtrl.countries['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"
                                            field-required="true"                                             
                                            ng-model="mainGdCtrl.data.birth_country_code"
                                        />  
                                        <div ng-if="mainGdCtrl.hasAlt('birth_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("birth_country_code") ) }}</div> 
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.birth_country_name.$error" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainGdCtrl.str.BIRTH_COUNTRY_REQUIRED }}</span>  
                                        </div>             
                                    </div>
                                </div> --->
                                
                                <div class="form-group">                                              
                                    <label for="birth_country_name" class="col-sm-3 control-label">
                                        <span class="label label-warning starred">{{ mainGdCtrl.str.COUNTRY_OF_BIRTH }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="birth_country_name" 
                                        ng-model="mainGdCtrl.ucountries['birth_country'].country" 
                                        uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small" 
                                        ng-class="required" 
                                        required="true">   
                                        <div ng-if="mainGdCtrl.hasAlt('birth_country_code')" class="help-block alt-data">
                                            {{ MainGdCtrl.getCtry( MainGdCtrl.getAlt('birth_country_code') ) }}                                                       
                                        </div>
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('birth_country_name')" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.BIRTH_COUNTRY_REQUIRED }}</span>  
                                        </div>                                             
                                    </div>
                                </div>  
                                
                                <div class="form-group">	            
                                    <label for="date_of_birth" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{ mainGdCtrl.str.DATE_OF_BIRTH }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <p class="input-group">
                                            <input 
                                                type="text" 
                                                name="date_of_birth"
                                                id="date_of_birth"
                                                class="form-control"                                             
                                                uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                ng-model="mainGdCtrl.birthDate.date" 
                                                is-open="mainGdCtrl.birthDate.popup.opened" 
                                                datepicker-options="mainGdCtrl.dateOptions"  
                                                datepicker-append-to-body="true"                                           
                                                close-text="Close"  
                                                ng-change="mainGdCtrl.setAge()"   
                                                ng-required="true"                                       
                                            />
                                            <span class="input-group-btn">
                                            <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.birthDate)">
                                            	<i class="glyphicon glyphicon-calendar"></i>
                                            </button>
                                            </span>
                                        </p> 
                                        <div ng-if="mainGdCtrl.hasAlt('date_of_birth')" class="help-block alt-data">{{ mainGdCtrl.getAlt('date_of_birth') }}</div>
                                       <!--- <div ng-messages="mainGdCtrl.nsmEditGdForm.date_of_birth.$touched && mainGdCtrl.nsmEditGdForm.date_of_birth.$error" class="errors"> --->
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('date_of_birth')" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.BIRTHDATE_REQUIRED }}</span>                                        
                                            <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                        </div>                     
                                    </div>
                                </div>                             
                                
                               <div class="form-group">	            
                                    <label class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.AGE }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <span class="form-control no-border" style="width:20%">{{mainGdCtrl.age}}</span>
                                    </div>
                                </div> 
                                
<!---                                <div class="form-group">	            
                                    <label for="citizenship_1_name" class="col-sm-3 control-label"><span class="label label-warning starred">{{ mainGdCtrl.str.CITIZENSHIP }}</span></label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <angucomplete-alt 
                                            id="citizenship_1_name"
                                            input-name="citizenship_1_name"                                    
                                            placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                            pause="100"
                                            selected-object="mainGdCtrl.setSelectedOption"
                                            selected-object-data="citizenship_1_country_code" 
                                            initial-value="mainGdCtrl.ac.citizenship_1.country"
                                            local-data="mainGdCtrl.citizenships['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                 
                                            input-class="form-control form-control-small ng-valid"
                                            field-required="true" 
                                            ng-model="mainGdCtrl.data.citizenship_1_country_code"
                                            multi="mainGdCtrl.noCitizDup" 
                                            pos=1
                                        />  
                                        <div ng-if="mainGdCtrl.hasAlt('citizenship_1_country_code')" class="help-block alt-data">
                                       		{{ mainGdCtrl.getCitiz( mainGdCtrl.getAlt("citizenship_1_country_code") ) }}
                                        </div>
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.citizenship_1_name.$touched && mainGdCtrl.nsmEditGdForm.citizenship_1_name.$error" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainGdCtrl.str.CITIZENSHIP_REQUIRED }}</span>  
                                            <span ng-message="multi">{{ mainGdCtrl.str.NO_DUPLICATE_CITIZENSHIP }}</span>
                                        </div>                             
                                    </div>
                                </div> --->
                                
                                <div class="form-group">                                              
                                    <label for="citizenship_1_name" class="col-sm-3 control-label">
                                        <span class="label label-warning starred">{{ mainGdCtrl.str.CITIZENSHIP }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="citizenship_1_name" 
                                        ng-model="mainGdCtrl.ucountries['citizenship_1_country'].country" 
                                        uib-typeahead="country as country.name for country in mainGdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small" 
                                        multi="mainGdCtrl.noCitizDup"
                                        ng-class="required" 
                                        required="true">   
                                        <div ng-if="mainGdCtrl.hasAlt('citizenship_1_country_code')" class="help-block alt-data">
                                            {{ MainGdCtrl.getCitiz( MainGdCtrl.getAlt('citizenship_1_country_code') ) }}                                                       
                                        </div>
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('citizenship_1_name')" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.CITIZENSHIP_REQUIRED }}</span>  
                                            <span ng-message="multi">{{ mainGdCtrl.str.NO_DUPLICATE_CITIZENSHIP }}</span>
                                        </div>                                             
                                    </div>
                                </div>                                  
                                
<!---                                <div class="form-group">	            
                                    <label for="citizenship_2_name" class="col-sm-3 control-label"><span class="label label-primary">{{ mainGdCtrl.str.CITIZENSHIP }} 2</span></label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="citizenship_2_name"
                                            input-name="citizenship_2_name"                                    
                                            placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                            pause="100"
                                            selected-object="mainGdCtrl.setSelectedOption"
                                            selected-object-data="citizenship_2_country_code" 
                                            initial-value="mainGdCtrl.ac.citizenship_2.country"
                                            local-data="mainGdCtrl.citizenships['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"  
                                            ng-model="mainGdCtrl.data.citizenship_2_country_code"
                                            multi="mainGdCtrl.noCitizDup" 
                                            pos=2                                                                             
                                        />  
                                        <div ng-if="mainGdCtrl.hasAlt('citizenship_2_country_code')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getCitiz( mainGdCtrl.getAlt("citizenship_2_country_code") ) }}
                                        </div>
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.citizenship_2_name.$touched && mainGdCtrl.nsmEditGdForm.citizenship_2_name.$error" class="errors">
                                            <span ng-message="multi">{{ mainGdCtrl.str.NO_DUPLICATE_CITIZENSHIP }}</span>
                                        </div>                             
                                    </div>
                                </div>  --->
                                
                                <div class="form-group">                                              
                                    <label for="citizenship_2_name" class="col-sm-3 control-label">
                                        <span class="label label-primary">{{ mainGdCtrl.str.CITIZENSHIP }} 2</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="citizenship_2_name" 
                                        ng-model="mainGdCtrl.ucountries['citizenship_2_country'].country" 
                                        uib-typeahead="country as country.name for country in mainGdCtrl.citizenships['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small" 
                                        multi="mainGdCtrl.noCitizDup">   
                                        <div ng-if="mainGdCtrl.hasAlt('citizenship_2_country_code')" class="help-block alt-data">
                                            {{ MainGdCtrl.getCitiz( MainGdCtrl.getAlt('citizenship_1_country_code') ) }}                                                       
                                        </div>
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('citizenship_2_name')" class="errors"> 
                                            <span ng-message="multi">{{ mainGdCtrl.str.NO_DUPLICATE_CITIZENSHIP }}</span>
                                        </div>                                             
                                    </div>
                                </div>                                  
                                
 <!---                               <div class="form-group">	            
                                    <label for="citizenship_3_name" class="col-sm-3 control-label"><span class="label label-primary">{{ mainGdCtrl.str.CITIZENSHIP }} 3</span></label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <angucomplete-alt 
                                            id="citizenship_3_name"
                                            input-name="citizenship_3_name"                                    
                                            placeholder="Select Citizenship"
                                            pause="100"
                                            selected-object="mainGdCtrl.setSelectedOption"
                                            selected-object-data="citizenship_3_country_code" 
                                            initial-value="mainGdCtrl.ac.citizenship_3.country"
                                            local-data="mainGdCtrl.citizenships['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"  
                                            ng-model="mainGdCtrl.data.citizenship_3_country_code"
                                            multi="mainGdCtrl.noCitizDup" 
                                            pos=3                                                                              
                                        />  
                                        <div ng-if="mainGdCtrl.hasAlt('citizenship_3_country_code')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getCitiz( mainGdCtrl.getAlt("citizenship_3_country_code") ) }}
                                        </div>
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.citizenship_3_name.$touched && mainGdCtrl.nsmEditGdForm.citizenship_3_name.$error" class="errors">
                                            <span ng-message="multi">{{ mainGdCtrl.str.NO_DUPLICATE_CITIZENSHIP }}</span>
                                        </div>                             
                                    </div>   
                                </div>   ---> 
                                
                                <div class="form-group">	            
                                    <label for="other_citizenships" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.OTHER_CITIZENSHIPS }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
										<input ng-model="mainGdCtrl.data.other_citizenships" 
                                        class="form-control" 
                                        type="text" 
                                        name="other_citizenships" 
                                        id="other_citizenships"> 
                                        <p ng-if="mainGdCtrl.data.alt.other_citizenships" class="help-block alt-data">
                                        	{{ mainGdCtrl.data.alt.other_citizenships }}
                                        </p>
                                    </div>   
                                </div>                                                               
                                
                                <div class="form-group">	            
                                    <label for="social_security_number" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.SSN }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.social_security_number" 
                                        class="form-control" 
                                        type="text" 
                                        name="social_security_number" 
                                        id="social_security_number"> 
                                        <p ng-if="mainGdCtrl.data.alt.social_security_number" class="help-block alt-data">
                                        	{{ mainGdCtrl.data.alt.social_security_number }}
                                        </p>
                                    </div>
                                </div> 
                                
                                <div class="form-group">	            
                                    <label for="date_of_death" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.DATE_OF_DEATH }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <p class="input-group">
                                            <input 
                                                type="text" 
                                                name="date_of_death"
                                                id="date_of_death"
                                                class="form-control"                                             
                                                uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                datepicker-append-to-body="true"
                                                ng-model="mainGdCtrl.deathDate.date" 
                                                is-open="mainGdCtrl.deathDate.popup.opened" 
                                                datepicker-options="mainGdCtrl.dateOptions"                                             
                                                close-text="Close"                    
                                            />
                                            <span class="input-group-btn">
                                            	<button type="button" 
                                                class="btn btn-default" 
                                                ng-click="mainGdCtrl.popup2(mainGdCtrl.deathDate)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                            </span>
                                        </p> 
                                        <div ng-if="mainGdCtrl.hasAlt('date_of_death')" class="help-block alt-data">{{ mainGdCtrl.getAlt('date_of_death') }}</div>                                 
                                       <!--- <div ng-messages="mainGdCtrl.nsmEditGdForm.date_of_death.$touched && mainGdCtrl.nsmEditGdForm.date_of_death.$error" class="errors">--->
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('date_of_death')" class="errors"> 
                                            <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                        </div>                     
                                    </div>
                                </div>   
                                
                                <div class="form-group">	            
                                    <label for="comments" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.COMMENTS }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <textarea ng-model="mainGdCtrl.data.comments" 
                                        class="form-control" 
                                        name="comments" 
                                        id="comments" 
                                        rows="3" 
                                        maxlength="300">
                                        </textarea> 
                                         <div ng-if="mainGdCtrl.hasAlt('comments')" class="help-block alt-data">
                                         	{{ mainGdCtrl.getAlt('comments') }}
                                         </div>
                                    </div>
                                </div>                                     
                                
                                <div class="form-group">	            
                                    <label for="cv" class="col-sm-3 control-label">
                                    	<span class="label label-primary">Curriculum Vitae</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                    
                                        <table width="100%">  
                                            <tr>        
                                                <td style="width:50%">                                                                      
                                                    <div class="col-sm-12 item-div">	                      
                                                        <div class="current-data">
                                                            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_cv_file', mainGdCtrl.data.doc_cv_hash)">
                                                                {{ mainGdCtrl.data.doc_cv_filename }} &nbsp;
                                                            </span>
                                                        </div>  
                                                        <div ng-if="mainGdCtrl.data.alt.cv_filename" class="alt-data">
                                                            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_cv_file', mainGdCtrl.data.alt.doc_cv_hash)">
                                                                {{ mainGdCtrl.data.alt.doc_cv_filename }}
                                                            </span>
                                                        </div> 
                                                    </div>                                                                                                    
                                                </td>                                                   
                                                <td style="width:50%">  
                                                	<input type="file" class="form-control" id="cv_file" ng-model="mainGdCtrl.data.cv_file" name="cv_file"/>  
                                                </td>
                                            </tr>
                                        </table>                           
                                                           
                                    </div>
                                    
                                </div>    
                                
                            </div> <!---end panel body--->   
                        
                        </div> <!---end collapse --->            
                    
                    </div> <!---end panel--->
                
                </div> <!---end panel group--->   
                
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('familyDetails')">
                        
                            <h4 class="panel-title">
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed family-details-panel-collapse-link" 
                                data-target=".family-details-panel">
                                	{{mainGdCtrl.str.FAMILY_DATA}}
                                </a>
                            </h4>  
                            
                        </div>     
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">
                                    {{ mainGdCtrl.str[mainGdCtrl.data.ms_status] || "Marital status N/A" }}
                                    <span ng-if="mainGdCtrl.data.ms_status && mainGdCtrl.data.ms_status != 'SIN'"> 
                                    	{{ mainGdCtrl.str[mainGdCtrl.data.ms_status] }} since {{ mainGdCtrl.data.ms_effective_from  || '[no date]'}}.
                                    </span>
                                    Has {{ mainGdCtrl.children_count }} children and
                                    {{ mainGdCtrl.spouses_count + mainGdCtrl.children_count + mainGdCtrl.other_relatives_count }} dependents in all.
                                </div>
                                                                
                            </div>     
                        </div>                        
                        
                        <div class="panel-collapse collapse family-details-panel">            
                    
                            <div class="panel-body">  
                                    
                                <div class="form-group">	            
                                    <label for="ms_status" class="col-sm-3 control-label">
                                    	<span class="label label-warning starred">{{mainGdCtrl.str.MARITAL_STATUS}}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <select ng-model="mainGdCtrl.data.ms_status" class="form-control" name="ms_status" id="ms_status" required> 
                                            <option value=''>{{mainGdCtrl.str.PLEASE_SELECT}}</option>  
                                            <option value='SIN'>{{mainGdCtrl.str.SIN}}</option> 
                                            <option value='MAR'>{{mainGdCtrl.str.MAR}}</option>  
                                            <option value='WID'>{{mainGdCtrl.str.WID}}</option>       
                                            <option value='DIV'>{{mainGdCtrl.str.DIV}}</option>    
                                            <option value='SEP'>{{mainGdCtrl.str.SEP}}</option>      
                                            <option value='CIV'>{{mainGdCtrl.str.CIV}}</option>                  
                                        </select> 
                                       <div ng-if="mainGdCtrl.hasAlt('ms_status')" class="help-block alt-data">{{ mainGdCtrl.str[mainGdCtrl.getAlt('ms_status')] || '[...]'}}</div>
                                       <!--- <div ng-messages="mainGdCtrl.nsmEditGdForm.ms_status.$touched && mainGdCtrl.nsmEditGdForm.ms_status.$error" class="errors"> --->
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('ms_status')" class="errors">                                   
                                            <span ng-message="required">{{ mainGdCtrl.str.MARITAL_STATUS_REQUIRED }}</span>
                                        </div>                         
                                    </div>
                                </div>                             
                                
                                <div class="form-group">	            
                                    <label for="ms_effective_from" class="col-sm-3 control-label">
                                    	<span class="label" ng-class="mainGdCtrl.data.ms_status != 'SIN' ? 'label-warning starred': 'label-primary'">
                                        	{{ mainGdCtrl.str.MS_EFFECTIVE_FROM }}
                                        </span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <p class="input-group">
                                            <input 
                                                type="text" 
                                                name="ms_effective_from"
                                                id="ms_effective_from"
                                                class="form-control"                                             
                                                uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                ng-model="mainGdCtrl.msEffectiveFrom.date" 
                                                is-open="mainGdCtrl.msEffectiveFrom.popup.opened" 
                                                datepicker-options="mainGdCtrl.dateOptions"                                                                                      
                                                close-text="Close" 
                                                datepicker-append-to-body="true"
                                                ng-required= "mainGdCtrl.data.ms_status != 'SIN' "                                                         
                                            />
                                            <span class="input-group-btn">
                                                <button type="button" 
                                                class="btn btn-default" 
                                                ng-click="mainGdCtrl.popup2(mainGdCtrl.msEffectiveFrom)">
                                                    <i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                            </span>
                                        </p> 
                                        <div ng-if="mainGdCtrl.hasAlt('ms_effective_from')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('ms_effective_from') }}
                                        </div>                                   
                                      <!---  <div ng-messages="mainGdCtrl.nsmEditGdForm.ms_effective_from.$touched && mainGdCtrl.nsmEditGdForm.ms_effective_from.$error" class="errors">--->
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('ms_effective_from')" class="errors"> 
                                            <span ng-message="required">{{mainGdCtrl.str.MS_EFFECTIVE_FROM_REQUIRED }}</span>
                                            <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                        </div>                     
                                    </div>
                                </div> 
                                                            
<!---                                <div class="form-group">	            
                                    <label for="ms_country_name" class="col-sm-3 control-label"><span class="label" ng-class="mainGdCtrl.data.ms_status != 'SIN' ? 'label-warning starred': 'label-primary'">{{mainGdCtrl.str.COUNTRY}}</span></label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="ms_country_name"
                                            input-name="ms_country_name"                                    
                                            placeholder="Select Country"
                                            pause="100"
                                            selected-object="mainGdCtrl.setSelectedOption"
                                            selected-object-data="ms_country_code" 
                                            initial-value="mainGdCtrl.ac.ms_country.country"
                                            local-data="mainGdCtrl.countries['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"
                                            field-required="mainGdCtrl.data.ms_status != 'SIN'" 
                                        />                                      
                                        <div ng-if="mainGdCtrl.hasAlt('ms_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.getAlt('ms_country_code')) }}</div> 
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.ms_country_name.$touched && mainGdCtrl.nsmEditGdForm.ms_country_name.$error" class="errors"> 
                                            <span ng-message="autocomplete-required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>  
                                        </div>
                                    </div>                                       
                                </div> ---> 
                                
                               <div class="form-group">                                              
                                    <label for="ms_country_name" class="col-sm-3 control-label">
                                        <span class="label label-warning starred">{{ mainGdCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="ms_country_name" 
                                        ng-model="mainGdCtrl.ucountries['ms_country'].country" 
                                        uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small" 
                                        ng-class="required" 
                                        ng-required=" mainGdCtrl.data.ms_status != 'SIN' ">   
                                        <div ng-if="mainGdCtrl.hasAlt('ms_country_code')" class="help-block alt-data">
                                            {{ MainGdCtrl.getCtry( MainGdCtrl.getAlt('ms_country_code') ) }}                                                       
                                        </div>
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('ms_country_name')" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                        </div>                                             
                                    </div>
                                </div>                                                                   
                        
                               <div class="form-group">	            
                                    <label class="col-sm-3 control-label"><span class="label label-primary">{{mainGdCtrl.str.NUMBER_OF_CHILDREN}}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                       <!--- <span class="form-control no-border" style="width:20%">{{mainGdCtrl.children_count}}</span>--->
                                        <div class="current-data"><span id="span_children_count">{{ mainGdCtrl.data.childrenCount }}</span></div>  
	                                    <div ng-if="mainGdCtrl.hasAlt('childrenCount')" class="help-block alt-data">{{ mainGdCtrl.getAlt('childrenCount') }}</div>
                                    </div>
                                </div>   
                                    
                               <div class="form-group">	            
                                    <label class="col-sm-3 control-label"><span class="label label-primary">{{mainGdCtrl.str.NUMBER_OF_DEPENDENTS}}</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                       <!--- <span class="form-control no-border" style="width:20%">{{mainGdCtrl.spouses_count + mainGdCtrl.other_relatives_count}}</span>--->
										<div class="current-data"><span id="span_dependents_count">{{ mainGdCtrl.data.dependentsCount }}</span></div>  
                                    	<div ng-if="mainGdCtrl.hasAlt('dependentsCount')" class="help-block alt-data">{{ mainGdCtrl.getAlt('dependentsCount') }}</div>
                                    </div>
                                </div>   
                                    
                            </div>  <!---end panel body--->     
                        
                        </div> <!---end collapse--->                             
            
                    </div> <!---end panel--->
                
                </div> <!---end panel group--->   
                
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('languages')">   
                                         
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed languages-panel-collapse-link" 
                                data-target=".languages-panel">
                                	{{mainGdCtrl.str.LANGUAGES}} 
                                </a>                            
                            </h4>   
                                                 
                        </div>     
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">                            
                                    {{ mainGdCtrl.data.language_1 }}
                                    <span ng-if="mainGdCtrl.data.language_2">, {{ mainGdCtrl.data.language_2 }}</span>
                                    <span ng-if="mainGdCtrl.data.language_3">, {{ mainGdCtrl.data.language_3 }}</span>
                                </div>
                                                                
                            </div>     
                        </div>                       
                        
                        <div class="panel-collapse collapse languages-panel">            
                    
                            <div class="panel-body">
                            
                                <div class="form-group">	            
                                    <label for="language_1_id" class="col-sm-3 control-label"><span class="label label-warning starred">{{mainGdCtrl.str.LANGUAGE}} 1</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <select ng-model="mainGdCtrl.data.language_1_id" 
                                        class="form-control" 
                                        ng-change="mainGdCtrl.noLangDup()" 
                                        name="language_1_id" 
                                        id="language_1_id" 
                                        required>                
                                            <option value=''>{{mainGdCtrl.str.PLEASE_SELECT}}</option>
                                            <option value='ENG'>{{mainGdCtrl.str.ENG}}</option>
                                            <option value='FRA'>{{mainGdCtrl.str.FRA}}</option>
                                            <option value='SPA'>{{mainGdCtrl.str.SPA}}</option>
                                            <option value='RUS'>{{mainGdCtrl.str.RUS}}</option>
                                            <option value='ARA'>{{mainGdCtrl.str.ARA}}</option>
                                        </select>  
                                        <div ng-if="mainGdCtrl.hasAlt('language_1_id')" class="help-block alt-data">
                                        	{{ mainGdCtrl.str[mainGdCtrl.getAlt("language_1_id")] }}
                                        </div> 
                                       <!--- <div ng-messages="mainGdCtrl.nsmEditGdForm.language_1_id.$touched && mainGdCtrl.nsmEditGdForm.language_1_id.$error" class="errors">	---> 					                                		<div ng-messages="mainGdCtrl.isTouchedWithErrors('language_1_id')" class="errors">
                                            <span ng-message="required">{{ mainGdCtrl.str.THIS_LANGUAGE_REQUIRED }}</span>
                                            <span ng-message="multi">{{ mainGdCtrl.str.NO_DUPLICATE_LANGUAGE }}</span>
                                        </div>                        
                                    </div>
                                </div>                                     
                                
                                <div class="form-group">	            
                                    <label for="language_2_id" class="col-sm-3 control-label"><span class="label label-primary">{{mainGdCtrl.str.LANGUAGE}} 2</span></label>  
                                    <div class="col-sm-8 form-control-div">                  
                                      <select ng-model="mainGdCtrl.data.language_2_id" class="form-control" ng-change="mainGdCtrl.noLangDup()" name="language_2_id" id="language_2_id">                
                                            <option value=''>{{mainGdCtrl.str.PLEASE_SELECT}}</option>
                                            <option value='ENG'>{{mainGdCtrl.str.ENG}}</option>
                                            <option value='FRA'>{{mainGdCtrl.str.FRA}}</option>
                                            <option value='SPA'>{{mainGdCtrl.str.SPA}}</option>
                                            <option value='RUS'>{{mainGdCtrl.str.RUS}}</option>
                                            <option value='ARA'>{{mainGdCtrl.str.ARA}}</option>
                                        </select>  
                                       <div ng-if="mainGdCtrl.hasAlt('language_2_id')" class="help-block alt-data">
                                       		{{  mainGdCtrl.str[mainGdCtrl.getAlt("language_2_id")] 
                                       </div> 
                                       <!--- <div ng-messages="mainGdCtrl.nsmEditGdForm.language_2_id.$touched && mainGdCtrl.nsmEditGdForm.language_2_id.$error" class="errors">--->  
										<div ng-messages="mainGdCtrl.isTouchedWithErrors('language_2_id')" class="errors">                                        
                                            <span ng-message="multi">{{ mainGdCtrl.str.NO_DUPLICATE_LANGUAGE }}</span>
                                        </div>                                      
                                    </div>
                                </div>   
                                
                                <div class="form-group">	            
                                    <label for="language_3" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.OTHER_LANGUAGES }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <input ng-model="mainGdCtrl.data.language_3" class="form-control" type="text" name="language_3" id="language_3"> 
                                        <div ng-if="mainGdCtrl.hasAlt('language_3')" class="help-block alt-data">{{  mainGdCtrl.getAlt("language_3") }}</div> 
                                    </div>
                                </div>   
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->    
           
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('bankAccounts')">  
                                          
                            <h4 class="panel-title">  
                                                  
                                <a data-toggle="collapse" 
                                id="bankAccountsToggle" 
                                class="collapse-link collapsed" 
                                data-target=".bank-accounts-panel">
                                	{{ mainGdCtrl.str.BANK_ACCOUNTS }} ({{ mainGdCtrl.data.bankAccounts.length }})
                                </a> 
                                
                                <i ng-click="mainGdCtrl.addBankAccount()" class="pointer-cursor glyphicon glyphicon-plus" style="font-size:medium; vertical-align:middle"></i>
                            </h4>     
                                               
                        </div>      
                        
                        <div class="panel-collapse collapse bank-accounts-panel">            
                    
                            <div class="panel-body">
                            
                                <div ng-repeat="bankAccount in mainGdCtrl.data.bankAccounts track by bankAccount.id" class="panel panel-default">
                                <input type="hidden" name="bank_deleted_{{ bankAccount.id }}" value="{{ bankAccount.bank_deleted }}" />                                   
                                    
                                    <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('bankAccount', bankAccount.id)">                                                
                                        <h4 class="panel-title"> 
                                        
                                            <i ng-if="bankAccount.bank_deleted == 'N' || bankAccount.bank_deleted == 'R'" 
                                            ng-click="mainGdCtrl.removeBankAccount(bankAccount.id, 'bankAccount')"
                                            class="pointer-cursor glyphicon glyphicon-remove" 
                                            style="font-size:medium; vertical-align:middle">
                                            </i> 
                                            
                                            <i ng-if="bankAccount.bank_deleted == 'Y'" 
                                            ng-click="mainGdCtrl.restoreBankAccount(bankAccount.id)" 
                                            class="pointer-cursor glyphicon glyphicon-ok" 
                                            style="font-size:medium; vertical-align:middle">
                                            </i>                                          
                                                              
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed bank-account-{{ bankAccount.id }}-collapse-link" 
                                            title="Deleted? {{ bankAccount.bank_deleted_ }} - Click to expand or collapse panel (bank account id: {{ bankAccount.id }})" 
                                            data-target=".bank-account-{{ bankAccount.id }}">
                                            	Account held at {{ bankAccount.bank_name }}
                                            </a>   
                                                                                                                
                                        </h4>                                                            
                                    </div>   
                                    
                                    <div class="panel-body collapse bank-account-{{ bankAccount.id }}"> 
                                
                                       	<div class="form-group">	            
                                            <label for="bank_name_{{ bankAccount.id }}" class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">{{ mainGdCtrl.str.BANK_NAME }}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">                  
                                                <input ng-model="bankAccount.bank_name" 
                                                class="form-control" 
                                                type="text" 
                                                name="bank_name_{{ bankAccount.id }}" 
                                                id="bank_name_{{ bankAccount.id }}"> 
                                                <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_name')" 
                                                class="help-block alt-data">
                                               	 	{{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_name') }}
                                                </div>                                                                                                                                         
                                            </div>
                                        </div>    
                                        
                                       	<div class="form-group">	            
                                            <label for="bank_address_{{ bankAccount.id }}" class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">{{ mainGdCtrl.str.BANK_ADDRESS }}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">                  
                                                <input ng-model="bankAccount.bank_address" 
                                                class="form-control" 
                                                type="text" 
                                                name="bank_address_{{ bankAccount.id }}" 
                                                id="bank_address_{{ bankAccount.id }}"
                                                ng-required=" bankAccount.bank_name != '' "> 
                                                <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_address')" 
                                                class="help-block alt-data">
                                               		{{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_address') }}
                                                </div>
                                                <div ng-messages="mainGdCtrl.isTouchedWithErrors('bank_address', bankAccount.id)" class="errors"> 
                                                    <span ng-message="required">{{ mainGdCtrl.str.BANK_ADDRESS_REQUIRED }}</span>
                                                </div>                                                                                         
                                            </div>
                                        </div>          
                                        
                                       	<div class="form-group">	            
                                            <label for="bank_account_holder_{{ bankAccount.id }}" 
                                            class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">{{ mainGdCtrl.str.ACCOUNT_HOLDER }}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">                  
                                                <input ng-model="bankAccount.bank_account_holder" 
                                                class="form-control" 
                                                type="text" 
                                                name="bank_account_holder_{{ bankAccount.id }}" 
                                                id="bank_account_holder_{{ bankAccount.id }}"
                                                ng-required=" bankAccount.bank_name != '' ">  
                                                <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_account_holder')" 
                                                class="help-block alt-data">
                                               	 	{{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_account_holder') }}
                                                </div>
                                                <div ng-messages="mainGdCtrl.isTouchedWithErrors('bank_account_holder', bankAccount.id)" class="errors"> 
                                                    <span ng-message="required">{{ mainGdCtrl.str.ACCOUNT_HOLDER_REQUIRED }}</span>
                                                </div>                                                                                         
                                            </div>
                                        </div>       
                                        
                                       	<div class="form-group">	            
                                            <label for="bank_iban_{{ bankAccount.id }}" 
                                            class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">IBAN</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">                  
                                                <input ng-model="bankAccount.bank_iban" 
                                                class="form-control" 
                                                type="text" 
                                                name="bank_iban_{{ bankAccount.id }}" 
                                                id="bank_iban_{{ bankAccount.id }}"
                                                ng-required=" bankAccount.bank_name != '' "> 
                                                <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_iban')" 
                                                class="help-block alt-data">
                                               	 {{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_iban') }}
                                                </div>
                                                <div ng-messages="mainGdCtrl.isTouchedWithErrors('bank_iban', bankAccount.id)" class="errors"> 
                                                    <span ng-message="required">{{ mainGdCtrl.str.IBAN_REQUIRED }}</span>
                                                </div>                                                                                         
                                            </div>
                                        </div>   
                                        
                                       	<div class="form-group">	            
                                            <label for="bank_bic_{{ bankAccount.id }}" 
                                            class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">BIC</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">                  
                                                <input ng-model="bankAccount.bank_bic" 
                                                class="form-control" 
                                                type="text" 
                                                name="bank_bic_{{ bankAccount.id }}" 
                                                id="bank_bicn_{{ bankAccount.id }}"
                                                ng-required=" bankAccount.bank_name != '' "> 
                                                <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_bic')" 
                                                class="help-block alt-data">
                                               		{{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_bic') }}
                                                </div>
                                                <div ng-messages="mainGdCtrl.isTouchedWithErrors('bank_bic', bankAccount.id)" class="errors"> 
                                                    <span ng-message="required">{{ mainGdCtrl.str.BIC_REQUIRED }}</span>
                                                </div>                                                                                         
                                            </div>
                                        </div>                 
                                         
                                    </div>    <!---end local collapse--->                                
                                                               
                                </div>	<!---end repeated panel--->   
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->       
       
            </div> <!---end col 1--->
            
            <div class="col-sm-6">  
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('businessAddress')">
                        
                            <h4 class="panel-title">
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed origin-country-panel-collapse-link" 
                                data-target=".origin-country-panel">
                                	{{ mainGdCtrl.str.CONTACT_ORIGIN_COUNTRY }}
                                </a>
                            </h4>
                            
                        </div>   
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">
                                    <span ng-if="mainGdCtrl.data.business_address_street">
                                        {{ mainGdCtrl.data.business_address_street }} 
                                        - 
                                        {{ mainGdCtrl.data.business_address_city}} 
                                        {{ mainGdCtrl.data.business_address_postal_code }}
                                        {{ mainGdCtrl.getCtry( mainGdCtrl.data.alt.business_address_country_code) }}
                                    </span>
                                    <span ng-if="!mainGdCtrl.data.business_address_street">        
                                        No contact information specified
                                    </span>
                                </div>
                                                                
                            </div>     
                        </div>   
                        
                        <div class="panel-collapse collapse origin-country-panel">            
                    
                            <div class="panel-body">
                            
                                <div class="form-group">	            
                                    <label for="business_address_street" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.ADDRESS }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.business_address_street" 
                                        class="form-control" 
                                        type="text" 
                                        name="business_address_street" 
                                        id="business_address_street">
                                        <div ng-if="mainGdCtrl.hasAlt('business_address_street')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('business_address_street') }}
                                        </div>
                                    </div>
                                </div>     
                                
                                <div class="form-group">	            
                                    <label for="business_address_city" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.CITY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.business_address_city" 
                                        class="form-control" 
                                        type="text" 
                                        name="business_address_city" 
                                        id="business_address_city"> 
                                        <div ng-if="mainGdCtrl.hasAlt('business_address_city')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('business_address_city') }}
                                        </div>
                                    </div>
                                </div>  
                                
                                <div class="form-group">	            
                                    <label for="business_address_postal_code" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.POSTAL_CODE }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.business_address_postal_code" 
                                        class="form-control" 
                                        type="text" 
                                        name="business_address_postal_code" 
                                        id="business_address_postal_code"> 
                                        <div ng-if="mainGdCtrl.hasAlt('business_address_postal_code')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('business_address_postal_code') }}
                                        </div>                                    
                                    </div>
                                </div>  
                                
<!---                                 <div class="form-group">	            
                                    <label for="business_address_country_name" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="business_address_country_name"
                                            input-name="business_address_country_name"                                    
                                            placeholder="Select Country"
                                            pause="100"
                                            selected-object="mainGdCtrl.setSelectedOption"
                                            selected-object-data="business_address_country_code" 
                                            initial-value="mainGdCtrl.ac.business_address_country.country"
                                            local-data="mainGdCtrl.countries['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"
                                        />  
                                        <div ng-if="mainGdCtrl.hasAlt('business_address_country_code')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("business_address_country_code") )  }}
                                        </div>
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.business_address_country_name.$touched && mainGdCtrl.nsmEditGdForm.business_address_country_name.$error" class="errors"> 
                                            <span ng-message="autocomplete-required">{{mainGdCtrl.str.COUNTRY_REQUIRED}}</span>  
                                        </div>                                    
                                                            
                                    </div>
                                </div> --->
                                
                               <div class="form-group">                                              
                                    <label for="business_address_country_name" class="col-sm-3 control-label">
                                        <span class="label label-primary">{{ mainGdCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="business_address_country_name" 
                                        ng-model="mainGdCtrl.ucountries['business_address_country'].country" 
                                        uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small">   
                                        <div ng-if="mainGdCtrl.hasAlt('business_address_country_code')" class="help-block alt-data">
                                            {{ MainGdCtrl.getCtry( MainGdCtrl.getAlt('business_address_country_name') ) }}                                                       
                                        </div>                                 
                                    </div>
                                </div>                                 
                                
                                <div class="form-group">	            
                                    <label for="business_address_effective_from" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.BA_EFFECTIVE_FROM }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <p class="input-group">
                                            <input 
                                                type="text" 
                                                name="business_address_effective_from"
                                                id="business_address_effective_from"
                                                class="form-control"                                             
                                                uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                ng-model="mainGdCtrl.baEffectiveFrom.date" 
                                                is-open="mainGdCtrl.baEffectiveFrom.popup.opened" 
                                                datepicker-options="mainGdCtrl.dateOptions"                                                                                      
                                                close-text="Close" 
                                                datepicker-append-to-body="true"/>
                                            <span class="input-group-btn">
                                            <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.baEffectiveFrom)">
                                            	<i class="glyphicon glyphicon-calendar"></i>
                                            </button>
                                            </span>
                                        </p> 
                                        <div ng-if="mainGdCtrl.hasAlt('business_address_effective_from')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('business_address_effective_from') }}
                                        </div>
<!---                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.business_address_effective_from.$touched && mainGdCtrl.nsmEditGdForm.business_address_effective_from.$error" class="errors">--->
										<div ng-messages="mainGdCtrl.isTouchedWithErrors('business_address_effective_from')" class="errors">                                         
                                            <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                        </div>                     
                                    </div>
                                </div>
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->               
                    
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('privateAddress')">  
                                          
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed residence-country-panel-collapse-link" 
                                data-target=".residence-country-panel">
                                	{{ mainGdCtrl.str.CONTACT_RESIDENCE_COUNTRY }}
                                </a>                            
                            </h4>  
                                                  
                        </div>  
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">
                                    <span ng-if="mainGdCtrl.data.business_address_street">
                                    {{ mainGdCtrl.data.private_address_street }} 
                                    - 
                                    {{ mainGdCtrl.data.private_address_city}} 
                                    {{ mainGdCtrl.data.private_address_postal_code }}
                                    {{ mainGdCtrl.getCtry( mainGdCtrl.data.alt.private_address_country_code) }}
                                    </span>
                                    <span ng-if="!mainGdCtrl.data.business_address_street">        
                                        No contact information specified
                                    </span>
                                </div>   
                                                                
                            </div>     
                        </div>                         
                        
                        <div class="panel-collapse collapse residence-country-panel">            
                    
                            <div class="panel-body">
                            
                                <div class="form-group">	            
                                    <label for="private_address_street" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.ADDRESS }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <textarea ng-model="mainGdCtrl.data.private_address_street" 
                                        class="form-control" 
                                        name="private_address_street" 
                                        id="private_address_street" 
                                        rows="3" 
                                        maxlength="1000">
                                        </textarea> 
                                         <div ng-if="mainGdCtrl.hasAlt('private_address_street')" class="help-block alt-data">
                                         	{{ mainGdCtrl.getAlt('private_address_street') }}
                                         </div>
                                    </div>
                                </div>   
                                
                                <div class="form-group">	            
                                    <label for="private_address_city" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{mainGdCtrl.str.CITY}}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.private_address_city" 
                                        class="form-control" 
                                        type="text" 
                                        name="private_address_city" 
                                        id="private_address_city"> 
                                        <div ng-if="mainGdCtrl.hasAlt('private_address_city')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('private_address_city') }}
                                        </div>
                                    </div>
                                </div> 
                                
                                <div class="form-group">	            
                                    <label for="private_address_postal_code" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{mainGdCtrl.str.POSTAL_CODE}}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.private_address_postal_code"
                                        class="form-control" 
                                        type="text" 
                                        name="private_address_postal_code" 
                                        id="private_address_postal_code"> 
                                        <div ng-if="mainGdCtrl.hasAlt('private_address_postal_code')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('private_address_postal_code') }}
                                        </div>
                                    </div>
                                </div> 
                                
<!---                                 <div class="form-group">	            
                                    <label for="private_address_country_name" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">  
                                        <angucomplete-alt 
                                            id="private_address_country_name"
                                            input-name="private_address_country_name"                                    
                                            placeholder="Select Country"
                                            pause="100"
                                            selected-object="mainGdCtrl.setSelectedOption"
                                            selected-object-data="private_address_country_code" 
                                            initial-value="mainGdCtrl.ac.private_address_country.country"
                                            local-data="mainGdCtrl.countries['LIB']"
                                            search-fields="name"
                                            title-field="name"                                   
                                            minlength="1"                                    
                                            input-class="form-control form-control-small ng-valid"                                         
                                        /> 
                                        <div ng-if="mainGdCtrl.hasAlt('private_address_country_code')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getCtry(mainGdCtrl.getAlt('private_address_country_code')) }}
                                        </div>
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.private_address_country_name.$touched && mainGdCtrl.nsmEditGdForm.private_address_country_name.$error" class="errors"> 
                                            <span ng-message="autocomplete-required">{{mainGdCtrl.str.COUNTRY_REQUIRED}}</span> 
                                        </div>              
                                    </div>
                                </div>  --->    
                                
                               <div class="form-group">                                              
                                    <label for="private_address_country_name" class="col-sm-3 control-label">
                                        <span class="label label-primary">{{ mainGdCtrl.str.COUNTRY }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                        <input type="text" 
                                        name="private_address_country_name" 
                                        ng-model="mainGdCtrl.ucountries['private_address_country'].country" 
                                        uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small">   
                                        <div ng-if="mainGdCtrl.hasAlt('private_address_country_code')" class="help-block alt-data">
                                            {{ MainGdCtrl.getCtry( MainGdCtrl.getAlt('private_address_country_name') ) }}                                                       
                                        </div>                                    
                                    </div>
                                </div>                                                            
                            
                                <div class="form-group">	            
                                    <label for="private_address_phone_nbr" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.PHONE_NUMBER }} ({{mainGdCtrl.str.LC_LANDLINE}})</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.private_address_phone_nbr" 
                                        class="form-control" 
                                        type="text" 
                                        name="private_address_phone_nbr" 
                                        id="private_address_phone_nbr"> 
                                        <div ng-if="mainGdCtrl.hasAlt('private_address_phone_nbr')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('private_address_phone_nbr') }}
                                        </div>
                                    </div>
                                </div>       
                                
                                <div class="form-group">	            
                                    <label for="private_mobile_nbr_1" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.MOBILE_NUMBER }} 1</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.private_mobile_nbr_1" 
                                        class="form-control" 
                                        type="text" 
                                        name="private_mobile_nbr_1" 
                                        id="private_mobile_nbr_1"> 
                                        <div ng-if="mainGdCtrl.hasAlt('private_mobile_nbr_1')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('private_mobile_nbr_1') }}
                                        </div>
                                    </div>
                                </div>         
                            
                                <div class="form-group">	            
                                    <label for="private_mobile_nbr_2" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.MOBILE_NUMBER }} 2</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.private_mobile_nbr_2" 
                                        class="form-control" 
                                        type="text" 
                                        name="private_mobile_nbr_2" 
                                        id="private_mobile_nbr_2"> 
                                        <div ng-if="mainGdCtrl.hasAlt('private_mobile_nbr_2')" class="help-block alt-data">
                                        	{{ mainGdCtrl.getAlt('private_mobile_nbr_2') }}
                                        </div>
                                    </div>
                                </div>      
                                
  <!---                              <div class="form-group" ng-class="mainGdCtrl.error('private_email')">	            
                                    <label for="private_email" class="col-sm-3 control-label">
                                    	<span class="label label-primary">Email</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div">                  
                                        <input ng-model="mainGdCtrl.data.private_email" 
                                        type="email" 
                                        class="form-control" 
                                        name="private_email" 
                                        id="private_email">
                                       <div ng-if="mainGdCtrl.hasAlt('private_email')" class="help-block alt-data">
                                       		{ mainGdCtrl.getAlt('private_email') }}
                                       </div>
                                        <!---<div ng-messages="mainGdCtrl.nsmEditGdForm.private_email.$touched && mainGdCtrl.nsmEditGdForm.private_email.$error" class="errors">--->  
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('private_email')" class="errors">                                        
                                            <span ng-message="email">{{ mainGdCtrl.str.INVALID_EMAIL }}</span>
                                        </div>   
                                    </div>                
                                </div>  --->   
                                
								<div class="form-group">	            
                                    <label for="gender" class="col-sm-3 control-label">
                                    	<span class="label label-primary">{{ mainGdCtrl.str.LIFE_3_MONTHS }}</span>
                                    </label>  
                                    <div class="col-sm-8 form-control-div"> 
                                                    
                                        <label class="radio-inline">
                                            <input type="radio" 
                                            ng-model="mainGdCtrl.data.life_3_months" 
                                            value="Y" 
                                            name="life_3_months" 
                                            id="life_3_months" 
                                            ng-required="!mainGdCtrl.data.life_3_months">
                                                {{ mainGdCtrl.str.YES }}
                                        </label>
                                        
                                        <label class="radio-inline">
                                            <input type="radio" 
                                            ng-model="mainGdCtrl.data.life_3_months" 
                                            value="N" 
                                            name="life_3_months" 
                                            id="life_3_months_n" 
                                            ng-required="!mainGdCtrl.data.life_3_months">
                                                {{ mainGdCtrl.str.NO }}
                                        </label> 
                                        
                                        <div ng-if="mainGdCtrl.hasAlt('gender')" class="help-block alt-data">{{ mainGdCtrl.getAlt('gender') }}</div> 
                                        <div ng-messages="mainGdCtrl.nsmEditGdForm.gender.$error" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.GENDER_REQUIRED }}</span>  
                                        </div>                             
                                    </div>
                                </div>                                                        
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->   
                
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('medicals')">  
                                          
                            <h4 class="panel-title">  
                                                  
                                <a data-toggle="collapse" 
                                id="medicalExamsToggle" 
                                class="collapse-link collapsed medicals-panel-collapse-link" 
                                data-target=".medicals-panel">
                                	{{mainGdCtrl.str.MEDICAL_EXAMS}} ({{ mainGdCtrl.data.medicals.length }})
                                </a> 
                                
                                <i ng-click="mainGdCtrl.addMedical()" 
                                class="pointer-cursor glyphicon glyphicon-plus" 
                                style="font-size:medium; 
                                vertical-align:middle"></i>
                            </h4>     
                                               
                        </div>      
                        
                        <div class="panel-collapse collapse medicals-panel">            
                    
                            <div class="panel-body">
                            
                                <div ng-repeat="medical in mainGdCtrl.data.medicals track by medical.id" class="panel panel-default">
                                <input type="hidden" name="medical_deleted_{{ medical.id }}" value="{{ medical.medical_deleted }}" />                                   
                                    
                                    <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('medical', medical.id)">                                                
                                        <h4 class="panel-title"> 
                                        
                                           <i ng-if="medical.medical_deleted == 'N' || medical.medical_deleted == 'R'" 
                                            ng-click="mainGdCtrl.removeMedical(medical.id, 'medical')"
                                            class="pointer-cursor glyphicon glyphicon-remove" 
                                            style="font-size:medium; vertical-align:middle">
                                            </i> 
                                            
                                            <i ng-if="medical.medical_deleted == 'Y'" 
                                            ng-click="mainGdCtrl.restoreMedical(medical.id)" 
                                            class="pointer-cursor glyphicon glyphicon-ok" 
                                            style="font-size:medium; vertical-align:middle">
                                            </i>                                         
                                                              
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed medical-{{ medical.id }}-collapse-link" 
                                            title="Deleted? {{ medical.medical_deleted }} - Click to expand or collapse panel (medical id: {{ medical.id }})" 
                                            data-target=".medical-{{ medical.id }}">
                                            	{{ medical.medical_valid_from || 'N/A' }} &gt; {{ medical.medical_valid_until || 'N/A' }}
                                            </a>    
                                                                                                                
                                        </h4>                                                            
                                    </div>   
                                    
                                    <div class="panel-body collapse medical-{{ medical.id }}">                                    
                                        
                                        <div class="form-group">	            
                                            <label for="medical_valid_from_{{ medical.id }}" class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">{{ mainGdCtrl.str.VALID_FROM }}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">  
                                                <p class="input-group">
                                                    <input 
                                                        type="text" 
                                                        name="medical_valid_from_{{ medical.id }}"
                                                        id="medical_valid_from_{{ medical.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                        ng-model="mainGdCtrl.medicals[medical.id].validFromDate.date" 
                                                        is-open="mainGdCtrl.medicals[medical.id].validFromDate.popup.opened" 
                                                        datepicker-options="mainGdCtrl.dateOptions"                                                                                      
                                                        close-text="Close" 
                                                        datepicker-append-to-body="true"
                                                        ng-required="true"              
                                                    />
                                                    <span class="input-group-btn">
                                                        <button type="button" 
                                                        class="btn btn-default" 
                                                        ng-click="mainGdCtrl.popup2(mainGdCtrl.medicals[medical.id].validFromDate)">
                                                            <i class="glyphicon glyphicon-calendar"></i>
                                                        </button>
                                                    </span>
                                                </p> 
                                                <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_valid_from')" 
                                                class="help-block alt-data">
                                                	{{ mainGdCtrl.getAltMed(medical.id, 'medical_valid_from') }}
                                                </div>  
                                                <div ng-messages="mainGdCtrl.isTouchedWithErrors('medical_valid_from', medical.id)" class="errors"> 
                                                    <span ng-message="required">{{mainGdCtrl.str.START_DATE_REQUIRED }}</span>
                                                    <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span>                                                   
                                                </div>                                                            
                                            </div>
                                        </div>               
                                        
                                        <div class="form-group">	            
                                            <label for="medical_valid_until_{ medical.id }}" class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">{{ mainGdCtrl.str.TIME_UNTIL }}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">  
                                                <p class="input-group">
                                                    <input 
                                                        type="text" 
                                                        name="medical_valid_until_{{ medical.id }}"
                                                        id="medical_valid_until_{{ medical.id }}"
                                                        class="form-control"                                             
                                                        uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                        ng-model="mainGdCtrl.medicals[medical.id].validUntilDate.date" 
                                                        is-open="mainGdCtrl.medicals[medical.id].validUntilDate.popup.opened" 
                                                        datepicker-options="mainGdCtrl.dateOptions"                                                                                      
                                                        close-text="Close" 
                                                        datepicker-append-to-body="true"
                                                        ng-required="true"              
                                                    />
                                                    <span class="input-group-btn">
                                                        <button type="button" 
                                                        class="btn btn-default" 
                                                        ng-click="mainGdCtrl.popup2(mainGdCtrl.medicals[medical.id].validUntilDate)">
                                                            <i class="glyphicon glyphicon-calendar"></i>
                                                        </button>
                                                    </span>
                                                </p> 
                                                <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_valid_until')" 
                                                class="help-block alt-data">
                                                	{{ mainGdCtrl.getAltMed(medical.id, 'medical_valid_until') }}
                                                </div>  
                                                <div ng-messages="mainGdCtrl.isTouchedWithErrors('medical_valid_until', medical.id)" class="errors"> 
                                                    <span ng-message="required">{{mainGdCtrl.str.END_DATE_REQUIRED }}</span>
                                                    <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span>                                                   
                                                </div>                                                            
                                            </div>
                                        </div>                                        
                                
                                       <div class="form-group">	            
                                            <label for="medical_center" 
                                            class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">{{mainGdCtrl.str.MEDICAL_INSTITUTION}}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">                  
                                                <textarea ng-model="medical.medical_center" 
                                                class="form-control" 
                                                name="medical_center_{{ medical.id }}" 
                                                id="medical_center_{{ medical.id }}" 
                                                rows="3" 
                                                maxlength='1000' 
                                                required>
                                                </textarea> 
                                                <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_center')" 
                                                class="help-block alt-data">
                                               	 {{ mainGdCtrl.getAltMed(medical.id, 'medical_center') }}
                                                </div>
                                                <div ng-messages="mainGdCtrl.isTouchedWithErrors('medical', medical.id)" class="errors"> 
                                                    <span ng-message="required">{{ mainGdCtrl.str.MEDICAL_INSTITUTION_REQUIRED }}</span>
                                                </div>                                                                                         
                                            </div>
                                        </div>     
                                    
                                        <div class="form-group">	            
                                            <label for="medical_status" 
                                            class="col-sm-3 control-label">
                                            	<span class="label label-warning starred">{{ mainGdCtrl.str.MEDICALLY_FIT }}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div"> 
                                                             
                                                <label class="radio-inline">
                                                <input type="radio" 
                                                ng-model="medical.medical_status" 
                                                name="medical_status_{{ medical.id }}" 
                                                value="Y" required>
                                                	{{ mainGdCtrl.str.YES }}
                                                </label>
                                                
                                                <label class="radio-inline">
                                                <input type="radio" 
                                                ng-model="medical.medical_status" 
                                                name="medical_status_{{ medical.id }}" 
                                                value="N" required>
                                                	{{ mainGdCtrl.str.NO }}
                                                </label>
                                                
                                                <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_status')" class="help-block alt-data">
                                                	{{ mainGdCtrl.getAltMed(medical.id, 'medical_status') }}
                                                </div>
                                                <div ng-messages="mainGdCtrl.hasErrors(medical.id, 'medical_status')" class="errors"> 
                                                    <span ng-message="required">{{mainGdCtrl.str.MEDICAL_STATUS_REQUIRED }}</span>
                                                </div>                                            
                                            </div>
                                        </div>    
                                    
                                        <div class="form-group">	            
                                            <label for="medical_remarks" class="col-sm-3 control-label">
                                            	<span class="label label-primary">{{mainGdCtrl.str.REMARKS}}</span>
                                            </label>  
                                            <div class="col-sm-8 form-control-div">                  
                                                <textarea ng-model="medical.medical_remarks" 
                                                class="form-control" 
                                                name="medical_remarks_{{ medical.id }}" 
                                                id="medical_remarks_{{ medical.id }}" 
                                                rows="3">
                                                </textarea>
                                                <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_remarks')" 
                                                class="help-block alt-data">
                                                	{{ mainGdCtrl.getAltMed(medical.id, 'medical_remarks') }}
                                                </div>
                                            </div>
                                        </div>    
                                        
                                      <!--- <div class="form-group">	            
                                            <label class="col-sm-3 control-label">
                                            	<span class="label label-primary-alt">{{ mainGdCtrl.str.DOCUMENT_TO_UPLOAD }}</span>
                                            </label>                	
                                            <div class="form-group col-sm-9">    	            
                                                <!---<label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">Choose File</label>---> 
                                                <div class="col-sm-8 form-control-div"> 
                                                   <input type="file" 
                                                   class="form-control" 
                                                   id="medical_file_{{ medical.id }}" 
                                                   ng-model="medical.medical_file" 
                                                   name="medical_file_{{ medical.id }}"/> 
                                                </div>
                                            </div>  
                                        </div>  --->    
                                        
 <!---                                      <div class="form-group">	            
                                            <label class="col-sm-3 control-label"><span class="label label-primary-alt">{{ mainGdCtrl.str.CURRENT_DOCUMENT }}</span></label>                	
                                            <div class="form-group col-sm-9">  
                                                <div class="col-sm-8 form-control-div"> 
                                                
                                                    <span ng-if="medical.medical_filename" 
                                                    class="form-control no-border file-link" 
                                                    style="width:50%" ng-click="mainGdCtrl.openMedFile(medical.id, 'main')">
                                                    	{{ medical.medical_filename }}
                                                    </span>
                                                    
                                                    <span ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_filename')" 
                                                    class="form-control no-border alt-file-link alt-data" 
                                                    style="width:50%" 
                                                    ng-click="mainGdCtrl.openMedFile(medical.id, 'alt')">
                                                    	{{ mainGdCtrl.getAltMed(medical.id, 'medical_filename') }}
                                                    </span>
    
                                                </div>
                                            </div>  
                                        </div>  --->
                                        
                                       <div class="form-group">	            
                                            <label class="col-sm-3 control-label">
                                            	<span class="label label-primary-alt">{{ mainGdCtrl.str.CURRENT_DOCUMENT }}</span>
                                            </label>                	
                                            <div class="col-sm-8 form-control-div">  
                                                 <table width="100%">  
                                                    <tr>        
                                                        <td style="width:50%">                                                                      
                                                            <div class="item-div">	                      
                                                                <div class="current-data">
                                                                    <span class="file-link" ng-click="mainGdCtrl.openMedFile(medical.id, medical.medical_hash)">
                                                                        {{ medical.medical_filename }} &nbsp;
                                                                    </span>
                                                                </div>  
                                                                <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_filename')" class="help-block alt-data">
                                                                    <span class="alt-file-link" ng-click="mainGdCtrl.openMedFile( medical.id, mainGdCtrl.getAltMed(medical.id, 'medical_hash') )">
                                                                        {{ mainGdCtrl.getAltMed(medical.id, 'medical_filename') }}
                                                                    </span>
                                                                </div> 
                                                            </div>                                                                                                    
                                                        </td>                                                   
                                                        <td>  
                                                            <input type="file" 
                                                            class="form-control" 
                                                            id="medical_file_{{ medical.id }}" 
                                                            ng-model="medical.medical_file" 
                                                            name="medical_file_{{ medical.id }}"/>  
                                                        </td>
                                                    </tr>
                                                </table>    
                                            </div>  
                                        </div>                                         
                                        
                                        
                                                                      
                                         
                                    </div>    <!---end local collapse--->                                
                                                               
                                </div>	<!---end repeated panel--->   
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->    
                            
                        
            </div> <!---end col 2--->
        
        </div> <!---end row--->     
        
        <div class="row">    
        
            <div class="col-sm-6 toggle-documents">
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('documents')">  
                                          
                            <h4 class="panel-title">  
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed documents-panel-collapse-link" 
                                data-target=".documents-panel">
                                	{{ mainGdCtrl.str.DOCUMENTS }}
                                </a>                            
                            </h4>  
                                                  
                        </div>   
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">
                                    <span ng-if="mainGdCtrl.documents.length > 0" ng-repeat="document in mainGdCtrl.documents">
                                    	{{ mainGdCtrl.str[document.doc] }} (exp. {{ document.exp_date }}) 
                                    </span>
									<span ng-if="mainGdCtrl.documents.length == 0">No documents available.</span>                                  
                                </div>
                                                                
                            </div>     
                        </div>                        
                        
                        <div class="panel-collapse collapse documents-panel">            
                    
                            <div class="panel-body">                                        
                        
                                <table class="table table-striped root-table"> 
                                
                                    <tr>
                                        <th>&nbsp;</th>
                                        <th>{{mainGdCtrl.str.COUNTRY_OF_ISSUE}}</th>
                                        <th>{{mainGdCtrl.str.DOCUMENT_NUMBER}}</th>
                                        <th>{{mainGdCtrl.str.VALID_FROM}}</th>
                                        <th>{{mainGdCtrl.str.TIME_UNTIL}}</th>
                                        <th>{{mainGdCtrl.str.ISSUED_BY}}</th>
                                        <th>{{mainGdCtrl.str.ISSUED_AT}}</th>
                                        <th>{{mainGdCtrl.str.DOCUMENT}}</th>
                                    </tr>            
                                
                                    <!---driving licence--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.DRIVING_LICENCE}}</span>
                                        </td>  
                                        <td>                                           
<!---                                            <angucomplete-alt 
                                                id="doc_dl_country_name"
                                                input-name="doc_dl_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_dl_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_dl_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"      
                                                field-required="mainGdCtrl.data.doc_dl_doc_nbr != ''"                                        
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dl_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_dl_country_code') ) }}</div>
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dl_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_dl_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>  
                                            </div> --->
                                   
                                        <input type="text" 
                                        name="doc_dl_country_name" 
                                        ng-model="mainGdCtrl.ucountries['doc_dl_country'].country" 
                                        uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                        typeahead-append-to-body="true" 
                                        class="form-control form-control-small" 
                                        ng-class="required" 
                                        ng-required=" mainGdCtrl.data.doc_dl_doc_nbr != '' ">   
                                        <div ng-if="mainGdCtrl.hasAlt('doc_dl_country_code')" class="help-block alt-data">
                                            {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_dl_country_code') ) }}                                                       
                                        </div>
                                        <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_dl_country_name')" class="errors"> 
                                            <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                        </div>                                                                                      
                                                                   
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_dl_doc_nbr" type="text" class="form-control" name="doc_dl_doc_nbr" id="doc_dl_doc_nbr">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dl_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dl_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dl_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_dl_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span> 
                                            </div>                                     
                                        </td>  
                                        <td>                                      
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_dl_valid_from"
                                                    id="doc_dl_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_dl_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_dl_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_dl_doc_nbr != ''"      
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_dl_valid_from, mainGdCtrl.doc_dl_valid_until)"                                  
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_dl_valid_from)"><i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p> 
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dl_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dl_valid_from") }}</div>                                         
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dl_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_dl_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_dl_valid_until"
                                                    id="doc_dl_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_dl_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_dl_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_dl_doc_nbr != ''"         
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_dl_valid_from, mainGdCtrl.doc_dl_valid_until)"
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_dl_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                         
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dl_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dl_valid_until") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dl_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_dl_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                 <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_dl_issued_by" type="text" class="form-control" name="doc_dl_issued_by" id="doc_dl_issued_by">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dl_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dl_issued_by") }}</div>                                        
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dl_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_dl_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_dl_issued_at" type="text" class="form-control" name="doc_dl_issued_at" id="doc_dl_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dl_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dl_issued_at") }}</div>  
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dl_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_dl_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".driving-licence-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_dl_filename || mainGdCtrl.data.alt.doc_dl_filename" class="glyphicon glyphicon-paperclip"></i>
                                        </td>
                                    </tr>   
                                    
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse driving-licence-file">                                    
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                       
    <div class="col-sm-12 item-div">	                      
        <div ng-if="mainGdCtrl.data.doc_dl_filename && mainGdCtrl.data.doc_dl_filename != '[...]'" class="current-data">
        
            <i ng-if="mainGdCtrl.documents.doc_dl_file.deleted == 'N' || mainGdCtrl.documents.doc_dl_file.deleted == 'R'" 
            ng-click="mainGdCtrl.removeDocument('doc_dl_file', mainGdCtrl.data.doc_dl_hash)" 
            class="pointer-cursor glyphicon glyphicon-remove" 
            style="font-size:medium; vertical-align:middle">
            </i>
            
            <i ng-if="mainGdCtrl.documents.doc_dl_file.deleted == 'Y'" 
            ng-click="mainGdCtrl.restoreDocument('doc_dl_file', mainGdCtrl.data.doc_dl_hash)" 
            class="pointer-cursor glyphicon glyphicon-ok" 
            style="font-size:medium; vertical-align:middle">  
            </i>        
            
            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_dl_file', mainGdCtrl.data.doc_dl_hash)">            
            	{{ mainGdCtrl.data.doc_dl_filename}} 
            </span> &nbsp;
            
        </div>  
        <div ng-if=" mainGdCtrl.data.alt.doc_dl_filename && mainGdCtrl.data.alt.doc_dl_filename != '[...]' " class="alt-data">
        
            <i ng-if="mainGdCtrl.documents.alt_doc_dl_file.deleted == 'N' || mainGdCtrl.documents.alt_doc_dl_file.deleted == 'R'" 
            ng-click="mainGdCtrl.removeDocument('alt_doc_dl_file', mainGdCtrl.data.alt.doc_dl_hash)" 
            class="pointer-cursor glyphicon glyphicon-remove" 
            style="font-size:medium; vertical-align:middle">
            </i>
            
            <i ng-if="mainGdCtrl.documents.alt_doc_dl_file.deleted == 'Y'" 
            ng-click="mainGdCtrl.restoreDocument('alt_doc_dl_file', mainGdCtrl.data.alt.doc_dl_hash)" 
            class="pointer-cursor glyphicon glyphicon-ok" 
            style="font-size:medium; vertical-align:middle">  
            </i> 
                    
            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_dl_file', mainGdCtrl.data.alt.doc_dl_hash)">            
                {{ mainGdCtrl.data.alt.doc_dl_filename }}
            </span>
        </div>
    </div>                                                                                                        
</td>                                                    
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="dl_file" ng-model="mainGdCtrl.data.dl_file" name="dl_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>                
                                    </tr>                                      
                                    
                                    
                                    <!---passport--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.PASSPORT}}</span>
                                        </td>  
                                        <td>                                          
       <!---                                     <angucomplete-alt 
                                                id="doc_pass_country_name"
                                                input-name="doc_pass_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_pass_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_pass_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_pass_doc_nbr != ''"                                            
                                            />                                          
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_pass_country_code") ) }}</div>
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_pass_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div>   
                                            --->
                                            
                                            <input type="text" 
                                            name="doc_pass_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_pass_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_pass_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_pass_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_pass_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>                                                                                     
                                                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_pass_doc_nbr" type="text" class="form-control" name="doc_pass_doc_nbr" id="doc_pass_doc_nbr">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass_doc_nbr") }}</div>  
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_pass_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_pass_valid_from"
                                                    id="doc_pass_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_pass_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_pass_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_pass_doc_nbr != ''"    
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_pass_valid_from, mainGdCtrl.doc_pass_valid_until)"                                    
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_pass_valid_from)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                         
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass_valid_from") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_pass_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_pass_valid_until"
                                                    id="doc_pass_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_pass_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_pass_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_pass_doc_nbr != ''"   
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_pass_valid_from, mainGdCtrl.doc_pass_valid_until)"                                      
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_pass_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                          
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass_valid_until") }}</div>  
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_pass_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_pass_issued_by" type="text" class="form-control" name="doc_pass_issued_by" id="doc_pass_issued_by">
                                           <div ng-if="mainGdCtrl.hasAlt('doc_pass_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass_issued_by") }}</div>  
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_pass_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_pass_issued_at" type="text" class="form-control" name="doc_pass_issued_at" id="doc_pass_issued_at">
                                           <div ng-if="mainGdCtrl.hasAlt('doc_pass_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass_issued_at") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_pass_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".passport-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_pass_filename || mainGdCtrl.data.alt.doc_pass_filename" class="glyphicon glyphicon-paperclip"></i>
                                        </td>
                                    </tr>                                    
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse passport-file">   
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                     
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_pass_file', mainGdCtrl.data.doc_pass_hash)">
                {{ mainGdCtrl.data.doc_pass_filename}} &nbsp;
            </span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_dl_filename" class="alt-data">
            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_pass_file', mainGdCtrl.data.alt.doc_pass_hash)">
                {{ mainGdCtrl.data.alt.doc_pass_filename }}
            </span>
        </div>
    </div>                                                                                                        
</td>                                                   <td style="width:20%">  
                                                            <input type="file" class="form-control" id="pass_file" ng-model="mainGdCtrl.data.pass_file" name="pass_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>   
                                                
                                            </div>
                                        </td>                
                                    </tr>                                        
                                    
                                    <!---passport 2--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.PASSPORT}} 2</span>
                                        </td>  
                                        <td>              
       <!---                                   <angucomplete-alt 
                                                id="doc_pass2_country_name"
                                                input-name="doc_pass2_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_pass2_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_pass2_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_pass2_doc_nbr != ''"                                            
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass2_country_code')" class="help-block alt-data">
                                            	{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_pass2_country_code") ) }}
                                            </div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass2_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_pass2_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div>  --->
                                            
                                            <input type="text" 
                                            name="doc_pass2_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_pass2_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_pass2_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass2_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_pass2_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_pass2_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>  
                                                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_pass2_doc_nbr" type="text" class="form-control" name="doc_pass2_doc_nbr" id="doc_pass2_doc_nbr">
                                           <div ng-if="mainGdCtrl.hasAlt('doc_pass2_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass2_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass2_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_pass2_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_pass2_valid_from"
                                                    id="doc_pass2_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_pass2_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_pass2_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_pass2_doc_nbr != ''"    
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_pass2_valid_from, mainGdCtrl.doc_pass2_valid_until)"                                     
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_pass2_valid_from)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                          
                                           <div ng-if="mainGdCtrl.hasAlt('doc_pass2_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass2_valid_from") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass2_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_pass2_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_pass2_valid_until"
                                                    id="doc_pass2_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_pass2_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_pass2_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_pass2_doc_nbr != ''"   
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_pass2_valid_from, mainGdCtrl.doc_pass2_valid_until)"                                    
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_pass2_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                        
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass2_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass2_valid_until") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass2_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_pass2_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_pass2_issued_by" type="text" class="form-control" name="doc_pass2_issued_by" id="doc_pass2_issued_by">
                                             <div ng-if="mainGdCtrl.hasAlt('doc_pass2_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass2_issued_by") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass2_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_pass2_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_pass2_issued_at" type="text" class="form-control" name="doc_pass2_issued_at" id="doc_pass2_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_pass2_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_pass2_issued_at") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_pass2_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_pass2_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".passport2-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_pass2_filename || mainGdCtrl.data.alt.doc_pass2_filename" class="glyphicon glyphicon-paperclip"></i>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse passport2-file">                                             
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                       
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_pass2_file', mainGdCtrl.data.doc_pass2_hash)">
                {{ mainGdCtrl.data.doc_pass2_filename}} &nbsp;
            </span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_pass2_filename" class="alt-data">
            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_pass2_file', mainGdCtrl.data.alt.doc_pass2_hash)">
                {{ mainGdCtrl.data.alt.doc_pass2_filename }}
            </span>
        </div>                      
    </div>                                                                
</td>                                                     
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="dl_file" ng-model="mainGdCtrl.data.pass2_file" name="pass2_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>   
                                                 
                                            </div>
                                        </td>                
                                    </tr>                                       
                                    
                                    <!---Work Permit (or License)--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.WORK_PERMIT}}</span>
                                        </td>  
                                        <td>                                          
 <!---                                         <angucomplete-alt 
                                                id="doc_wl_country_name"
                                                input-name="doc_wl_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_wl_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_wl_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_wl_doc_nbr != ''"                                            
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_wl_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_wl_country_code") ) }}</div>  
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_wl_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_wl_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div>   --->
                                            
                                            <input type="text" 
                                            name="doc_wl_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_wl_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_wl_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_wl_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_wl_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_wl_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>                                             
                                                                
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_wl_doc_nbr" type="text" class="form-control" name="doc_wl_doc_nbr" id="doc_wl_doc_nbr">
                                           <div ng-if="mainGdCtrl.hasAlt('doc_wl_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_wl_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_wl_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_wl_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_wl_valid_from"
                                                    id="doc_wl_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_wl_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_wl_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_wl_doc_nbr != ''"       
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_wl_valid_from, mainGdCtrl.doc_wl_valid_until)"                                
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_wl_valid_from)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                        
                                            <div ng-if="mainGdCtrl.hasAlt('doc_wl_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_wl_valid_from") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_wl_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_wl_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>                                        
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_wl_valid_until"
                                                    id="doc_wl_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_wl_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_wl_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_wl_doc_nbr != ''"    
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_wl_valid_from, mainGdCtrl.doc_wl_valid_until)"                                   
                                                />
                                                <span class="input-group-btn">
                                                <button type="mainGdCtrl.data.doc_wl_doc_nbr != ''" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_wl_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                         
                                            <div ng-if="mainGdCtrl.hasAlt('doc_wl_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_wl_valid_until") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_wl_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_wl_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_wl_issued_by" type="text" class="form-control" name="doc_wl_issued_by" id="doc_wl_issued_by">
                                           <div ng-if="mainGdCtrl.hasAlt('doc_wl_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_wl_issued_by") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_wl_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_wl_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_wl_issued_at" type="text" class="form-control" name="doc_wl_issued_at" id="doc_wl_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_wl_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_wl_issued_at") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_wl_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_wl_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".work-permit-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_wl_filename || mainGdCtrl.data.alt.doc_wl_filename" class="glyphicon glyphicon-paperclip"></i>                                            
                                        </td>
                                    </tr>
                                                                        
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse work-permit-file">   
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                    
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_wl_file', mainGdCtrl.data.doc_wl_hash)">
                {{ mainGdCtrl.data.doc_wl_filename}} &nbsp;
            </span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_wl_filename" class="alt-data">
            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_wl_file', mainGdCtrl.data.alt.doc_wl_hash)">
                {{ mainGdCtrl.data.alt.doc_wl_filename }}
            </span>
        </div> 
    </div>                                                                
</td>                                                  
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="dl_file" ng-model="mainGdCtrl.data.wl_file" name="wl_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>                                              
                                                
                                            </div>
                                        </td>                
                                    </tr>                                     
                                    
                                    <!---Residence Permit--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.RESIDENCE_PERMIT}}</span>
                                        </td>  
                                        <td>                                         
<!---                                          <angucomplete-alt 
                                                id="doc_rp_country_name"
                                                input-name="doc_rp_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_rp_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_rp_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_rp_doc_nbr != ''"                                            
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_rp_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_rp_country_code") ) }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_rp_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_rp_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div> ---> 
                                            
                                            <input type="text" 
                                            name="doc_rp_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_rp_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_rp_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_rp_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_rp_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_rp_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>                                                             
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_rp_doc_nbr" type="text" class="form-control" name="doc_rp_doc_nbr" id="doc_rp_doc_nbr">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_rp_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_rp_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_rp_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_rp_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>                                       
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_rp_valid_from"
                                                    id="doc_rp_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_rp_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_rp_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_rp_doc_nbr != ''"   
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_rp_valid_from, mainGdCtrl.doc_rp_valid_until)"                                    
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_rp_valid_from)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                          
                                            <div ng-if="mainGdCtrl.hasAlt('doc_rp_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_rp_valid_from") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_rp_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_rp_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_rp_valid_until"
                                                    id="doc_rp_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_rp_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_rp_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_rp_doc_nbr != ''"     
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_rp_valid_from, mainGdCtrl.doc_rp_valid_until)"                                  
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_rp_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                         
                                            <div ng-if="mainGdCtrl.hasAlt('doc_rp_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_rp_valid_until") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_rp_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_rp_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span> 
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span> 
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_rp_issued_by" type="text" class="form-control" name="doc_rp_issued_by" id="doc_rp_issued_by">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_rp_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_rp_issued_by") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_rp_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_rp_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_rp_issued_at" type="text" class="form-control" name="doc_rp_issued_at" id="doc_rp_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_rp_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_rp_issued_at") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_rp_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_rp_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".residence-permit-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_rp_filename || mainGdCtrl.data.alt.doc_rp_filename" class="glyphicon glyphicon-paperclip"></i>                                            
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse residence-permit-file">                                              
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                      
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_rp_file', mainGdCtrl.data.doc_rp_hash)">
                {{ mainGdCtrl.data.doc_rp_filename}} &nbsp;
            </span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_rp_filename" class="alt-data">
            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_rp_file', mainGdCtrl.data.alt.doc_rp_hash)">
                {{ mainGdCtrl.data.alt.doc_rp_filename }}
            </span>
        </div>              
    </div>                                                                
</td>                                                    
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="dl_file" ng-model="mainGdCtrl.data.rp_file" name="rp_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>                                              
                                                
                                            </div>
                                        </td>                
                                    </tr>                                      
                                    
                                    <!---ECHO Field badge--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.ECHO_FIELD_BADGE}}</span>
                                        </td>  
                                        <td>                                        
<!---                                          <angucomplete-alt 
                                                id="doc_ebdg_country_name"
                                                input-name="doc_ebdg_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_ebdg_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_ebdg_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_ebdg_doc_nbr != ''"                                            
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_ebdg_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_ebdg_country_code") ) }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_ebdg_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_ebdg_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div>  --->
                                            
                                            <input type="text" 
                                            name="doc_ebdg_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_ebdg_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_ebdg_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_ebdg_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_ebdg_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_ebdg_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>                                                                                                           
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_ebdg_doc_nbr" type="text" class="form-control" name="doc_ebdg_doc_nbr" id="doc_ebdg_doc_nbr">
                                           <div ng-if="mainGdCtrl.hasAlt('doc_ebdg_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_ebdg_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_ebdg_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_ebdg_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_ebdg_valid_from"
                                                    id="doc_ebdg_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_ebdg_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_ebdg_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_ebdg_doc_nbr != ''"   
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_ebdg_valid_from, mainGdCtrl.doc_ebdg_valid_until)"                                    
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_ebdg_valid_from)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                          
                                            <div ng-if="mainGdCtrl.hasAlt('doc_ebdg_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_ebdg_valid_from") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_ebdg_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_ebdg_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_ebdg_valid_until"
                                                    id="doc_ebdg_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_ebdg_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_ebdg_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_ebdg_doc_nbr != ''"         
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_ebdg_valid_from, mainGdCtrl.doc_ebdg_valid_until)"                               
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_ebdg_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                         
                                            <div ng-if="mainGdCtrl.hasAlt('doc_ebdg_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_ebdg_valid_until") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_ebdg_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_ebdg_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_ebdg_issued_by" type="text" class="form-control" name="doc_ebdg_issued_by" id="doc_ebdg_issued_by">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_ebdg_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_ebdg_issued_by") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_ebdg_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_ebdg_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_ebdg_issued_at" type="text" class="form-control" name="doc_ebdg_issued_at" id="doc_ebdg_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_ebdg_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_ebdg_issued_at") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_ebdg_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_ebdg_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".echo-badge-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_ebdg_filename || mainGdCtrl.data.alt.doc_ebdg_filename" class="glyphicon glyphicon-paperclip"></i>                                            
                                        </td>
                                    </tr>   
                                    
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse echo-badge-file">                                             
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                     
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_ebdg_file', mainGdCtrl.data.doc_ebdg_hash)">
                {{ mainGdCtrl.data.doc_ebdg_filename}} &nbsp;
            </span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_ebdg_filename" class="alt-data">
            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_ebdg_file', mainGdCtrl.data.alt.doc_ebdg_hash)">
                {{ mainGdCtrl.data.alt.doc_ebdg_filename }}
            </span>
        </div>  
    </div>                                                                
</td>                                                  
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="dl_file" ng-model="mainGdCtrl.data.ebdg_file" name="ebdg_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>   
                                                                                            
                                            </div>
                                        </td>                
                                    </tr>                                      
                                    
                                    <!---DU Office Badge--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.DUE_OFFICE_BADGE}}</span>
                                        </td>  
                                        <td>                                         
<!---                                          <angucomplete-alt 
                                                id="doc_dbdg_country_name"
                                                input-name="doc_dbdg_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_dbdg_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_dbdg_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_dbdg_doc_nbr != ''"                                            
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dbdg_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_dbdg_country_code") ) }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dbdg_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_dbdg_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div>    --->  
                                            
                                            <input type="text" 
                                            name="doc_dbdg_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_dbdg_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_dbdg_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dbdg_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_dbdg_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_dbdg_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>                                                                                                      
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_dbdg_doc_nbr" type="text" class="form-control" name="doc_dbdg_doc_nbr" id="doc_dbdg_doc_nbr">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dbdg_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dbdg_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dbdg_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_dbdg_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_dbdg_valid_from"
                                                    id="doc_dbdg_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_dbdg_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_dbdg_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_dbdg_doc_nbr != ''"    
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_dbdg_valid_from, mainGdCtrl.doc_dbdg_valid_until)"                                    
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_dbdg_valid_from)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                         
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dbdg_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dbdg_valid_from") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dbdg_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_dbdg_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_dbdg_valid_until"
                                                    id="doc_dbdg_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_dbdg_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_dbdg_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_dbdg_doc_nbr != ''"     
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_dbdg_valid_from, mainGdCtrl.doc_dbdg_valid_until)"                                  
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_dbdg_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                        
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dbdg_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dbdg_valid_until") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dbdg_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_dbdg_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_dbdg_issued_by" type="text" class="form-control" name="doc_dbdg_issued_by" id="doc_dbdg_issued_by">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dbdg_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dbdg_issued_by") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dbdg_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_dbdg_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_dbdg_issued_at" type="text" class="form-control" name="doc_dbdg_issued_at" id="doc_dbdg_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_dbdg_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_dbdg_issued_at") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_dbdg_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_dbdg_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".dbdg-badge-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_dbdg_filename || mainGdCtrl.data.alt.doc_dbdg_filename" class="glyphicon glyphicon-paperclip"></i>                                            
                                        </td>
                                    </tr>  
                                    
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse dbdg-badge-file">  
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
        	<span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_dbdg_file', mainGdCtrl.data.doc_dbdg_hash)">
            	{{ mainGdCtrl.data.doc_dbdg_filename }} &nbsp;
            </span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_dbdg_filename" class="alt-data">
        	<span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_dbdg_file', mainGdCtrl.data.alt.doc_dbdg_hash)">
            	{{ mainGdCtrl.data.alt.doc_dbdg_filename }}
            </span>
        </div>  
    </div>                                                                
</td>                                                   
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="dl_file" ng-model="mainGdCtrl.data.dbdg_file" name="dbdg_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>                                            
                                                
                                                
                                            </div>
                                        </td>                
                                    </tr>                                      
                                    
                                    <!---Laissez-passer--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">{{mainGdCtrl.str.LAISSEZ_PASSER}}</span>
                                        </td>  
                                        <td>                                        
<!---                                          <angucomplete-alt 
                                                id="doc_lap_country_name"
                                                input-name="doc_lap_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_lap_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_lap_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_lap_doc_nbr != ''"                                            
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_lap_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_lap_country_code") ) }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_lap_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_lap_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div>  --->     
                                            
                                            <input type="text" 
                                            name="doc_lap_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_lap_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_lap_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_lap_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_lap_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_lap_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>                                                                                                       
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_lap_doc_nbr" type="text" class="form-control" name="doc_lap_doc_nbr" id="doc_lap_doc_nbr">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_lap_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_lap_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_lap_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_lap_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_lap_valid_from"
                                                    id="doc_lap_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_lap_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_lap_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_lap_doc_nbr != ''"      
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_lap_valid_from, mainGdCtrl.doc_lap_valid_until)"                                 
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_lap_valid_from)"><i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>                                           
                                            <div ng-if="mainGdCtrl.hasAlt('doc_lap_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_lap_valid_from") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_lap_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_lap_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_lap_valid_until"
                                                    id="doc_lap_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_lap_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_lap_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_lap_doc_nbr != ''"   
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_lap_valid_from, mainGdCtrl.doc_lap_valid_until)"                                    
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_lap_valid_until)"><i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>                                        
                                            <div ng-if="mainGdCtrl.hasAlt('doc_lap_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_lap_valid_until") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_lap_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_lap_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_lap_issued_by" type="text" class="form-control" name="doc_lap_issued_by" id="doc_lap_issued_by">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_lap_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_lap_issued_by") }}</div>  
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_lap_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_lap_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_lap_issued_at" type="text" class="form-control" name="doc_lap_issued_at" id="doc_lap_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_lap_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_lap_issued_at") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_lap_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_lap_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".laissez-passer-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_lap_filename || mainGdCtrl.data.alt.doc_lap_filename" class="glyphicon glyphicon-paperclip"></i>                                            
                                        </td>
                                    </tr>
                                                                        
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse laissez-passer-file">                                             
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                                                      
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
            <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_lap_file', mainGdCtrl.data.doc_lap_hash)">
                {{ mainGdCtrl.data.doc_lap_filename }} &nbsp;
            </span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_lap_filename" class="alt-data">
            <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_lap_file', mainGdCtrl.data.alt.doc_lap_hash)">
                {{ mainGdCtrl.data.alt.doc_lap_filename }}
            </span>
        </div> 
    </div>                                                                                                    
</td>                                                   
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="dl_file" ng-model="mainGdCtrl.data.lap_file" name="lap_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>                                              
                                                
                                            </div>
                                        </td>                
                                    </tr>                                     
                                    
                                    <!---Juridical Report--->
                                    <tr>
                                        <td align="right">
                                            <span class="label label-primary">[Juridical Report]</span>
                                        </td>  
                                        <td>                                        
<!---                                          <angucomplete-alt 
                                                id="doc_jurep_country_name"
                                                input-name="doc_jurep_country_name"                                    
                                                placeholder="{{mainGdCtrl.str.PLEASE_SELECT}}"
                                                pause="100"
                                                selected-object="mainGdCtrl.setSelectedOption"
                                                selected-object-data="doc_jurep_country_code" 
                                                initial-value="mainGdCtrl.ac.doc_jurep_country.country"
                                                local-data="mainGdCtrl.countries['LIB']"
                                                search-fields="name"
                                                title-field="name"                                   
                                                minlength="1"                                    
                                                input-class="form-control form-control-small ng-valid"  
                                                field-required="mainGdCtrl.data.doc_jurep_doc_nbr != ''"                                            
                                            />  
                                            <div ng-if="mainGdCtrl.hasAlt('doc_jurep_country_code')" class="help-block alt-data">
                                            {{ mainGdCtrl.getCtry( mainGdCtrl.getAlt("doc_jurep_country_code") ) }}
                                            </div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_jurep_country_name.$touched && mainGdCtrl.nsmEditGdForm.doc_jurep_country_name.$error" class="errors"> 
                                                <span ng-message="autocomplete-required">{{ mainGdCtrl.str.DOCUMENT_FILE_REQUIRED }}</span>  
                                            </div>    --->
                                            
                                            <input type="text" 
                                            name="doc_jurep_country_name" 
                                            ng-model="mainGdCtrl.ucountries['doc_jurep_country'].country" 
                                            uib-typeahead="country as country.name for country in mainGdCtrl.countries['LIB'] | filter:$viewValue | limitTo:8"  
                                            typeahead-append-to-body="true" 
                                            class="form-control form-control-small" 
                                            ng-class="required" 
                                            ng-required=" mainGdCtrl.data.doc_jurep_doc_nbr != '' ">   
                                            <div ng-if="mainGdCtrl.hasAlt('doc_jurep_country_code')" class="help-block alt-data">
                                                {{ MainGdCtrl.getCtry( mainGdCtrl.getAlt('doc_jurep_country_code') ) }}                                                       
                                            </div>
                                            <div ng-messages="mainGdCtrl.isTouchedWithErrors('doc_jurep_country_name')" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.COUNTRY_REQUIRED }}</span>                                             
                                            </div>                                                                                                          
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_jurep_doc_nbr" type="text" class="form-control" name="doc_jurep_doc_nbr" id="doc_jurep_doc_nbr">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_jurep_doc_nbr')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_jurep_doc_nbr") }}</div> 
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_jurep_doc_nbr.$touched && mainGdCtrl.nsmEditGdForm.doc_jurep_doc_nbr.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_NUMBER_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_jurep_valid_from"
                                                    id="doc_lap_valid_from"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_jurep_valid_from.date" 
                                                    is-open="mainGdCtrl.doc_jurep_valid_from.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_jurep_doc_nbr != ''"      
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_jurep_valid_from, mainGdCtrl.doc_jurep_valid_until)"                                 
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_jurep_valid_from)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                           
                                            <div ng-if="mainGdCtrl.hasAlt('doc_jurep_valid_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_jurep_valid_from") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_jurep_valid_from.$touched && mainGdCtrl.nsmEditGdForm.doc_jurep_valid_from.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_FROM_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                                      
                                        </td>
                                        <td>
                                            <p class="input-group">
                                                <input 
                                                    type="text" 
                                                    name="doc_jurep_valid_until"
                                                    id="doc_jurep_valid_until"
                                                    class="form-control"                                             
                                                    uib-datepicker-popup="{{mainGdCtrl.format}}" 
                                                    ng-model="mainGdCtrl.doc_jurep_valid_until.date" 
                                                    is-open="mainGdCtrl.doc_jurep_valid_until.popup.opened" 
                                                    datepicker-options="mainGdCtrl.dateOptions"  
                                                    datepicker-append-to-body="true"                                           
                                                    close-text="Close"     
                                                    ng-required="mainGdCtrl.data.doc_jurep_doc_nbr != ''"   
                                                    ng-change="mainGdCtrl.dateCompare(mainGdCtrl.doc_jurep_valid_from, mainGdCtrl.doc_jurep_valid_until)"                                    
                                                />
                                                <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="mainGdCtrl.popup2(mainGdCtrl.doc_jurep_valid_until)">
                                                	<i class="glyphicon glyphicon-calendar"></i>
                                                </button>
                                                </span>
                                            </p>                                        
                                            <div ng-if="mainGdCtrl.hasAlt('doc_jurep_valid_until')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_jurep_valid_until") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_jurep_valid_until.$touched && mainGdCtrl.nsmEditGdForm.doc_jurep_valid_until.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_VALID_UNTIL_REQUIRED }}</span>  
                                                <span ng-message="date">{{ mainGdCtrl.str.PLEASE_USE_EURODATE }}</span> 
                                                <span ng-message="datecompare">{{ mainGdCtrl.str.BEFORE_IS_AFTER }}</span>
                                            </div>                                     
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_jurep_issued_by" type="text" class="form-control" name="doc_jurep_issued_by" id="doc_jurep_issued_by">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_jurep_issued_by')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_jurep_issued_by") }}</div>  
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_jurep_issued_by.$touched && mainGdCtrl.nsmEditGdForm.doc_jurep_issued_by.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_BY_REQUIRED }}</span>  
                                            </div>                                    
                                        </td>
                                        <td>
                                            <input ng-model="mainGdCtrl.data.doc_jurep_issued_at" type="text" class="form-control" name="doc_jurep_issued_at" id="doc_jurep_issued_at">
                                            <div ng-if="mainGdCtrl.hasAlt('doc_jurep_issued_at')" class="help-block alt-data">{{ mainGdCtrl.getAlt("doc_jurep_issued_at") }}</div>   
                                            <div ng-messages="mainGdCtrl.nsmEditGdForm.doc_jurep_issued_at.$touched && mainGdCtrl.nsmEditGdForm.doc_jurep_issued_at.$error" class="errors"> 
                                                <span ng-message="required">{{ mainGdCtrl.str.DOCUMENT_ISSUED_AT_REQUIRED }}</span>  
                                            </div>                                     
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-info" data-toggle="collapse" data-target=".jurep-file">{{ mainGdCtrl.str.FILE }}</button>
                                            &nbsp; <i ng-if=" mainGdCtrl.data.doc_jurep_filename || mainGdCtrl.data.alt.doc_jurep_filename" class="glyphicon glyphicon-paperclip"></i>                                            
                                        </td>
                                    </tr>  
                                    <tr>
                                        <td colspan="8">
                                            <div class="collapse jurep-file">                                             
                                                <table width="100%">  
                                                    <tr>
                                                        <td style="width:40%">&nbsp;</td>
<td style="width:20%; padding-right:10px">                                                                      
    <div class="col-sm-12 item-div">	                      
        <div class="current-data">
        	<span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_jurep_file', mainGdCtrl.data.doc_jurep_hash)">
            	{{ mainGdCtrl.data.doc_jurep_filename }} &nbsp;
        	</span>
        </div>  
        <div ng-if="mainGdCtrl.data.alt.doc_jurep_filename" class="alt-data">
        	<span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_jurep_file', mainGdCtrl.data.alt.doc_jurep_hash)">
            	{{ mainGdCtrl.data.alt.doc_jurep_filename }}
            </span>
        </div> 
    </div>                                                                                                    
</td>                                                   
                                                        <td style="width:20%">  
                                                            <input type="file" class="form-control" id="jurep_file" ng-model="mainGdCtrl.data.jurep_file" name="jurep_file"/>  
                                                        </td>
                                                    </tr>
                                                </table>                                              
                                                
                                            </div>
                                        </td>                
                                    </tr>                                              
                                                            
                                </table>                          
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->   
            
            </div> <!---end column--->    
        
        </div> <!---end row--->
        
        <nav class="navbar navbar-inverse navbar-fixed-bottom"> 
            <div class="container-fluid">
            
                <button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='switch' value="switch" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainGdCtrl.str.BACK_TO_GRID }}</button>     
                <button class="btn btn-info navbar-btn" name='view' value="view" ng-click="mainGdCtrl.viewGD()">{{ mainGdCtrl.str.VIEW }}</button>  
                <button ng-class="(mainGdCtrl.nsmEditGdForm.$invalid) ? 'btn navbar-btn btn-warning' : 'btn navbar-btn btn-success'" name='save' value="save" ng-click="mainGdCtrl.saveGD()">
                	{{ mainGdCtrl.str.SAVE }}
                </button>
                
<!---                <div class="btn-group dropup" style="display:inline-block">
                    <button type="button" ng-disabled="mainGdCtrl.hasNewMedicalExam === true" class="btn btn-info dropdown-toggle" data-toggle="dropdown">{{ mainGdCtrl.str.ADD_ITEM }}&nbsp;&nbsp;<span class="caret"></span></button>
                    <ul class="dropdown-menu" style="overflow-y:auto">
                        <li><a ng-click="mainGdCtrl.addMedical()">{{ mainGdCtrl.str.MEDICAL_EXAM }}</a></li>                    
                    </ul>
                </div> ---> 
                
                <ul class="nav navbar-nav navbar-right">     
                    <li><a ng-click="mainGdCtrl.expandAll($event)" class="pointer-cursor">{{ mainGdCtrl.str.EXPAND_ALL }}</a></li> 
                    <li><a ng-click="mainGdCtrl.collapseAll($event)" class="pointer-cursor">{{ mainGdCtrl.str.COLLAPSE_ALL }}</a></li>                      	
                    <li><a ng-click="mainGdCtrl.reload()" class="pointer-cursor">{{ mainGdCtrl.str.RELOAD }}</a></li>
                    <li><a ng-click="tabsCtrl.switchGdGroup()" class="pointer-cursor">Switch</a></li> 
                </ul>
                
            </div>
        </nav>      
        
        <ul>
          <li ng-repeat="(key, errors) in mainGdCtrl.nsmEditGdForm.$error track by $index"> <strong>{{ key }}</strong> errors
            <ul>
              <li ng-repeat="e in errors">{{ e.$name }} has an error: <strong>{{ key }}</strong>.</li>
            </ul>
          </li>
        </ul>      
        
<!---        <ul>
          <li ng-repeat="document in mainGdCtrl.documents"> <strong>{{ key }}</strong> documents
            <ul>
              <li>{{ document }}</strong>.</li>
            </ul>
          </li>
        </ul> --->                

	</div> <!---end panel body--->

</div> <!---end panel --->

</form>

</cfoutput>

                                                 
