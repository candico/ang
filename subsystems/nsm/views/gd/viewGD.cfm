
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

<form name="mainGdCtrl.nsmViewGdForm" id="nsmViewGdForm" class="form-horizontal general-data-form" update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel view-panel">

    <div class="panel-body">
            
        <staff-banner ng-cloak></staff-banner> 
    
        <div class="row">
        
            <div class="col-sm-6">
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('personalDetails')"> 
                                          
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".personal-details-panel">{{mainGdCtrl.str.PERSONAL_DATA}}</a>                            
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
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.LNAME }}</span> 
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_last_name">{{ mainGdCtrl.data.last_name }}</span></div>
                                    <div ng-if="mainGdCtrl.hasAlt('last_name')" class="alt-data">{{  mainGdCtrl.getAlt('last_name') }}</div>
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.FNAME }}</span> 
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_first_name">{{ mainGdCtrl.data.first_name }}</span></div>
                                    <div ng-if="mainGdCtrl.hasAlt('first_name')" class="alt-data">{{ mainGdCtrl.getAlt('first_name') }}</div>
                                </div>    
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.MNAME }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_maiden_name">{{ mainGdCtrl.data.maiden_name }}</span></div>
                                    <div ng-if="mainGdCtrl.hasAlt('maiden_name')" class="alt-data">{{ mainGdCtrl.getAlt('maiden_name') }}</div>
                                </div>      
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.GENDER }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_gender">{{ mainGdCtrl.data.gender }}</span></div>
                                    <div ng-if="mainGdCtrl.hasAlt('gender')" class="alt-data">{{ mainGdCtrl.getAlt('gender') }}</div>
                                </div>       
                                             
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.COUNTRY_OF_BIRTH }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_birth_country_code">{{ mainGdCtrl.getCtry(mainGdCtrl.data.birth_country_code) }}</span></div>   
                                    <div ng-if="mainGdCtrl.hasAlt('birth_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.data.alt.birth_country_code) }}</div>                                 
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.DATE_OF_BIRTH }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_date_of_birth">{{ mainGdCtrl.data.date_of_birth }}</span></div>
                                    <div ng-if="mainGdCtrl.hasAlt('date_of_birth')" class="help-block alt-data">{{ mainGdCtrl.getAlt('date_of_birth') }}</div>
                                </div>       
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.AGE }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.age }}</span></div>                                
                                </div> 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.CITIZENSHIP }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_citizenship_1_country_code">{{ mainGdCtrl.getCitiz(mainGdCtrl.data.citizenship_1_country_code) }}</span></div>                                  
                                    <div ng-if="mainGdCtrl.hasAlt('citizenship_1_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCitiz( mainGdCtrl.data.alt.citizenship_1_country_code) }}</div>
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.SND_CITIZENSHIP }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_citizenship_2_country_code">{{ mainGdCtrl.getCitiz(mainGdCtrl.data.citizenship_2_country_code) }}</span></div>                                  
                                    <div ng-if="mainGdCtrl.hasAlt('citizenship_2_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCitiz( mainGdCtrl.data.alt.citizenship_2_country_code) }}</div>
                                </div>     
                                
                              <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.OTHER_CITIZENSHIPS }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_other_citizenships">{{ mainGdCtrl.data.other_citizenships }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('other_citizenships')" class="help-block alt-data">{{ mainGdCtrl.getAlt('other_citizenships') }}</div>                            
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.SSN }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_social_security_number">{{ mainGdCtrl.data.social_security_number }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('social_security_number')" class="help-block alt-data">{{ mainGdCtrl.getAlt('social_security_number') }}</div>                            
                                </div>    
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.DATE_OF_DEATH }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_date_of_death">{{ mainGdCtrl.data.date_of_death }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('date_of_death')" class="help-block alt-data">{{ mainGdCtrl.getAlt('date_of_death') }}</div>                              
                                </div>  
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.COMMENTS }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.comments }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.comments" class="alt-data">{{ mainGdCtrl.data.alt.comments }}</div>                              
                                </div>                                 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">CV</span>	
                                </div>  
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data">
                                        <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_cv_file', mainGdCtrl.data.doc_cv_hash)">
                                            {{ mainGdCtrl.data.doc_cv_filename}} &nbsp;
                                        </span>
                                    </div>  
                                    <div ng-if="mainGdCtrl.data.alt.doc_cv_filename" class="alt-data">
                                        <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_cv_file', mainGdCtrl.data.alt.doc_cv_hash)">
                                            {{ mainGdCtrl.data.alt.doc_cv_filename }}
                                        </span>
                                    </div> 
                                </div> 
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->   
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('familyDetails')">
                                          
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".family-details-panel">{{mainGdCtrl.str.FAMILY_DATA}}</a>                            
                            </h4>      
                                              
                        </div>      
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">
                                   <!--- {{ mainGdCtrl.data.ms_status || "Marital status N/A" }}--->
                                    <span ng-if="mainGdCtrl.data.ms_status && mainGdCtrl.data.ms_status != 'SIN'"> {{ mainGdCtrl.str[mainGdCtrl.data.ms_status] }} since {{ mainGdCtrl.data.ms_effective_from  || '[no date]'}}</span>.
                                    Has {{ mainGdCtrl.children_count }} children and
                                    {{ mainGdCtrl.spouses_count + mainGdCtrl.children_count + mainGdCtrl.other_relatives_count }} dependents in all.
                                </div>
                                                                
                            </div>     
                        </div>                      
                        
                        <div class="panel-collapse collapse family-details-panel">            
                    
                            <div class="panel-body">
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.MARITAL_STATUS }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_ms_status">{{  mainGdCtrl.str[mainGdCtrl.data.ms_status] }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('ms_status')" class="help-block alt-data">{{ mainGdCtrl.str[mainGdCtrl.getAlt('ms_status')] || '[...]'}}</div>                  
                                </div>  
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.MS_EFFECTIVE_FROM }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_ms_effective_from">{{ mainGdCtrl.data.ms_effective_from }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('ms_effective_from')" class="help-block alt-data">{{ mainGdCtrl.getAlt('ms_effective_from') }}</div>                              
                                </div>     
                                                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.COUNTRY }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_ms_country_code">{{ mainGdCtrl.getCtry(mainGdCtrl.data.ms_country_code) }}</span></div>                                  
                                    <div ng-if="mainGdCtrl.hasAlt('ms_country_code')" class="help-block alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.getAlt('ms_country_code') ) }}</div> 
                                </div>  
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.NUMBER_OF_CHILDREN }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <!---<div class="current-data"><span>{{ mainGdCtrl.children_count }}</span></div> --->          
									<div class="current-data"><span id="span_children_count">{{ mainGdCtrl.data.childrenCount }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('childrenCount')" class="help-block alt-data">{{ mainGdCtrl.getAlt('childrenCount') }}</div>
                                </div>    
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.NUMBER_OF_DEPENDENTS }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                   <!--- <div class="current-data"><span>{{ mainGdCtrl.spouses_count + mainGdCtrl.other_relatives_count }}</span></div>  --->
									<div class="current-data"><span id="span_dependents_count">{{ mainGdCtrl.data.dependentsCount }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('dependentsCount')" class="help-block alt-data">{{ mainGdCtrl.getAlt('dependentsCount') }}</div>
                                </div>                          
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->    
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('languages')"> 
                                         
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".languages-panel">{{mainGdCtrl.str.LANGUAGES}}</a>                            
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
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.LANGUAGE }} 1</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="language_1_id">{{ mainGdCtrl.str[mainGdCtrl.data.language_1_id] }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('language_1_id')" class="alt-data">{{ mainGdCtrl.str[mainGdCtrl.getAlt("language_1_id")] || '[...]'}}</div>                              
                                </div>                         
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.LANGUAGE }} 2</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="language_2_id">{{ mainGdCtrl.str[mainGdCtrl.data.language_2_id] }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('language_2_id')" class="alt-data">{{ mainGdCtrl.str[mainGdCtrl.getAlt("language_2_id")] || '[...]'}}</div>                              
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.OTHER_LANGUAGES }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span id="span_language_3">{{ mainGdCtrl.data.language_3 }}</span></div>  
                                    <div ng-if="mainGdCtrl.hasAlt('language_3')" class="alt-data">{{  mainGdCtrl.getAlt("language_3") }}</div>                              
                                </div>  
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->                  
                
            	<div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('bankAccounts')">
                                           
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".bank-accounts-panel">
                                	{{ mainGdCtrl.str.BANK_ACCOUNTS }} ({{ mainGdCtrl.data.bankAccounts.length }})
                                </a>                           
                            </h4>    
                                                
                        </div>      
                        
                        <div class="panel-collapse collapse bank-accounts-panel">            
                    
                            <div class="panel-body">                        
                            
                                <div ng-repeat="bankAccount in mainGdCtrl.data.bankAccounts track by bankAccount.id" 
                                class="panel panel-default" 
                                ng-class="{ 'new-item': bankAccount.status_id == 0, 'updated-item': bankAccount.status_id == -1 }">
    
                                     <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('bankAccount', bankAccount.id)">  
                                        <h4 class="panel-title" 
                                        data-toggle="collapse" 
                                        data-target=".bank-account-{{ bankAccount.id }}" 
                                        title="Deleted? {{ bankAccount.account_deleted }} - Click to expand or collapse panel (bank account id: {{ bankAccount.id }})">
                                       		Account held at {{ bankAccount.bank_name }}
                                        </h4>
                                    </div>
                                    
                                    <div class="panel-body collapse bank-account-{{ bankAccount.id }}">                                
                                        
                                        <div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.BANK_NAME }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ bankAccount.bank_name }}</span></div>  
                                           <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_name')" class="help-block alt-data">
                                          	 {{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_name') }}
                                           </div>                         
                                        </div>    
                                        
                                   		<div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.BANK_ADDRESS }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ bankAccount.bank_address }}</span></div>  
                                           <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_address')" class="help-block alt-data">
                                          	 {{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_address') }}
                                           </div>                         
                                        </div>       
                                        
                                   		<div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.ACCOUNT_HOLDER }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ bankAccount.bank_account_holder }}</span></div>  
                                           <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_account_holder')" class="help-block alt-data">
                                          	 {{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_account_holder') }}
                                           </div>                         
                                        </div>     
                                        
                                   		<div class="col-sm-3 label-div">
                                            <span class="label label-primary">IBAN</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ bankAccount.bank_iban }}</span></div>  
                                           <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_iban')" class="help-block alt-data">
                                          	 {{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_iban') }}
                                           </div>                         
                                        </div>      
                                        
                                   		<div class="col-sm-3 label-div">
                                            <span class="label label-primary">BIC</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ bankAccount.bank_bic }}</span></div>  
                                           <div ng-if="mainGdCtrl.hasAltBankAccount(bankAccount.id, 'bank_bic')" class="help-block alt-data">
                                          	 {{ mainGdCtrl.getAltBankAccount(bankAccount.id, 'bank_bic') }}
                                           </div>                         
                                        </div>                            
                                    
                                    </div> <!---end local collapse--->
    
                                </div> <!---end repeated panel ---> 
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->  
                
            </div>  <!--- end col 1 --->  
            
            <div class="col-sm-6">     
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('businessAddress')">
                                            
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".origin-country-panel">{{ mainGdCtrl.str.CONTACT_ORIGIN_COUNTRY }}</a>                            
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
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.ADDRESS }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.business_address_street }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.business_address_street" class="alt-data">{{ mainGdCtrl.data.alt.business_address_street }}</div>                              
                                </div>      
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.CITY }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.business_address_city }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.business_address_city" class="alt-data">{{ mainGdCtrl.data.alt.business_address_city }}</div>                              
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.POSTAL_CODE }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.business_address_postal_code }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.business_address_postal_code" class="alt-data">{{ mainGdCtrl.data.alt.business_address_postal_code }}</div>                              
                                </div> 
                                                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.COUNTRY }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.business_address_country_code) }}</span></div>                                  
                                    <div ng-if="mainGdCtrl.data.alt.business_address_country_code" class="alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.data.alt.business_address_country_code) }}</div>
                                </div>                              
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.BA_EFFECTIVE_FROM }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.business_address_effective_from }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.business_address_effective_from" class="alt-data">{{ mainGdCtrl.data.alt.business_address_effective_from }}</div>                              
                                </div>                         
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->          
            
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('privateAddress')"> 
                                          
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".residence-country-panel">{{mainGdCtrl.str.CONTACT_RESIDENCE_COUNTRY}}</a>                            
                            </h4>     
                                               
                        </div>      
                        
                        <div class="panel-body">  
                            <div class="row">                  
                                
                                <div class="col-sm-12">
                                    <span ng-if="mainGdCtrl.data.private_address_street">
                                    {{ mainGdCtrl.data.private_address_street }} 
                                    - 
                                    {{ mainGdCtrl.data.private_address_city}} 
                                    {{ mainGdCtrl.data.private_address_postal_code }}
                                    {{ mainGdCtrl.getCtry( mainGdCtrl.data.alt.private_address_country_code) }}
                                    </span>
                                    <span ng-if="!mainGdCtrl.data.private_address_street">        
                                        No contact information specified
                                    </span>
                                </div>                            
                                                                
                            </div>     
                        </div>                      
                        
                        <div class="panel-collapse collapse residence-country-panel">            
                    
                            <div class="panel-body">
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.ADDRESS }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.private_address_street }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.private_address_street" class="alt-data">{{ mainGdCtrl.data.alt.private_address_street }}</div>                              
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.CITY }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.private_address_city }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.private_address_city" class="alt-data">{{ mainGdCtrl.data.alt.private_address_city }}</div>                              
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.POSTAL_CODE }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.private_address_postal_code }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.private_address_postal_code" class="alt-data">{{ mainGdCtrl.data.alt.private_address_postal_code }}</div>                              
                                </div>                                                                             
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.COUNTRY }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.private_address_country_code) }}</span></div>                                  
                                    <div ng-if="mainGdCtrl.data.alt.private_address_country_code" class="alt-data">{{ mainGdCtrl.getCtry( mainGdCtrl.data.alt.private_address_country_code) }}</div>
                                </div>        
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.PHONE_NUMBER }} ({{ mainGdCtrl.str.LC_LANDLINE }})</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.private_address_phone_nbr }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.private_address_phone_nbr" class="alt-data">{{ mainGdCtrl.data.alt.private_address_phone_nbr }}</div>                              
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.MOBILE_NUMBER }} 1</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.private_mobile_nbr_1 }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.private_mobile_nbr_1" class="alt-data">{{ mainGdCtrl.data.alt.private_mobile_nbr_1 }}</div>                              
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.MOBILE_NUMBER }} 2</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.private_mobile_nbr_2 }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.private_mobile_nbr_2" class="alt-data">{{ mainGdCtrl.data.alt.private_mobile_nbr_2 }}</div>                              
                                </div>    
                                
 <!---                               <div class="col-sm-3 label-div">
                                    <span class="label label-primary">Email</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.data.private_email }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.private_email" class="alt-data">{{ mainGdCtrl.data.alt.private_email }}</div>                              
                                </div>  --->
                                
                               <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainGdCtrl.str.LIFE_3_MONTHS }}</span>
                                </div>   
                                <div class="col-sm-9 item-div">	                      
                                    <div class="current-data"><span>{{ mainGdCtrl.str[mainGdCtrl.data.life_3_months] }}</span></div>  
                                    <div ng-if="mainGdCtrl.data.alt.life_3_months" class="alt-data">{{  mainGdCtrl.str[mainGdCtrl.data.alt.private_email] }}</div>                              
                                </div>                                  
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->    
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">
                    
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('medicals')">
                                           
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".medicals-panel">
                                	{{mainGdCtrl.str.MEDICAL_EXAMS}}({{ mainGdCtrl.data.medicals.length }})
                                </a>                           
                            </h4>    
                                                
                        </div>      
                        
                        <div class="panel-collapse collapse medicals-panel">            
                    
                            <div class="panel-body">                        
                            
                                <div ng-repeat="medical in mainGdCtrl.data.medicals track by medical.id" 
                                class="panel panel-default" 
                                ng-class="{ 'new-item': medical.status_id == 0, 'updated-item': medical.status_id == -1 }">
    
                                     <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('medical', medical.id)">  
                                        <h4 class="panel-title" 
                                        data-toggle="collapse" 
                                        data-target=".medical-{{ medical.id }}" 
                                        title="Deleted? {{ medical.medical_deleted }} - Click to expand or collapse panel (medical id: {{ medical.id }})">
                                       		{{ ::medical.medical_valid_from || 'N/A'}} &gt; {{ ::medical.medical_valid_until || 'N/A'}}
                                        </h4>
                                    </div>
                                    
                                    <div class="panel-body collapse medical-{{ medical.id }}">     
                                    
                                        <div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.VALID_FROM }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	
                                            <div class="current-data"><span>{{ medical.medical_valid_from }}</span></div>  
                                            <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_valid_from')" class="help-block alt-data">
                                                {{ mainGdCtrl.getAltMed(medical.id, 'medical_valid_from') }}
                                            </div>
                                        </div>
                                        
                                 		<div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.VALID_UNTIL }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	 
                                            <div class="current-data"><span>{{ medical.medical_valid_until }}</span></div>  
                                            <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_valid_until')" class="help-block alt-data">
                                                {{ mainGdCtrl.getAltMed(medical.id, 'medical_valid_until') }}
                                            </div>
                                        </div>                                        
                                        
                                        <div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.MEDICAL_INSTITUTION }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ medical.medical_center }}</span></div>  
                                           <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_center')" class="help-block alt-data">
                                          	 {{ mainGdCtrl.getAltMed(medical.id, 'medical_center') }}
                                           </div>                         
                                        </div>    
                                        
                                        <div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.MEDICALLY_FIT }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ mainGdCtrl.str[medical.medical_status] }}</span></div>  
                                           <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_status')" class="help-block alt-data">
 												{{ mainGdCtrl.getAltMed(medical.id, 'medical_status') }}
                                           </div>                         
                                        </div>                                                                                                                                                                  
                                          
                                        <div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.REMARKS }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	                      
                                            <div class="current-data"><span>{{ medical.medical_remarks }}</span></div>  
                                            <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_remarks')" 
                                            class="help-block alt-data">
                                            	{{ mainGdCtrl.getAltMed(medical.id, 'medical_remarks') }}
                                            </div>
                                        </div>  
                                        
                                        <div class="col-sm-3 label-div">
                                            <span class="label label-primary">{{ mainGdCtrl.str.DOCUMENT }}</span>
                                        </div>   
                                        <div class="col-sm-9 item-div">	 
                                                                           
                                            <div class="current-data">                                        	
                                                <span class="file-link"           
                                                style="width:50%" 
                                                ng-click="mainGdCtrl.openMedFile(medical.id, medical.medical_hash)">
                                                	{{ medical.medical_filename }} &nbsp;
                                                </span>
                                            </div>                                             
                                            <div ng-if="mainGdCtrl.hasAltMed(medical.id, 'medical_filename')" 
                                            class="alt-file-link alt-data" 
                                            style="width:50%" 
                                            ng-click="mainGdCtrl.openMedFile( medical.id, mainGdCtrl.getAltMed(medical.id, 'medical_hash') )">
                                            	<span>{{ mainGdCtrl.getAltMed(medical.id, 'medical_filename') }}</span>
                                           </div>  
                                                                                                           
                                        </div>                                  
                                    
                                    </div> <!---end local collapse--->
    
                                </div> <!---end repeated panel ---> 
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->  
                
                
                
                
                
                
                
                
                
            </div>  <!--- end col 2 --->    
            
        </div>  <!---end row--->
        
        <div class="row">    
        
            <div class="col-sm-6 toggle-documents">
            
                <div class="panel-group">         
                    
                    <div class="panel panel-default fieldset-panel">  
                                  
                        <div class="panel-heading" ng-class="mainGdCtrl.getHeadingClasses('documents')">  
                                          
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" class="collapse-link collapsed" data-target=".documents-panel">{{ mainGdCtrl.str.DOCUMENTS }}</a>                            
                            </h4>  
                                                  
                        </div>      
                        
                        <div class="panel-body">  
                            <div class="row">
                            
                                <div class="col-sm-12">
                                    <span ng-if="mainGdCtrl.documents.length > 0" ng-repeat="document in mainGdCtrl.documents">{{ mainGdCtrl.str[document.doc] }} (exp. {{ document.exp_date }}) / </span>
									<span ng-if="mainGdCtrl.documents.length == 0">No documents available.</span>                                  
                                </div>
                                                                
                            </div>     
                        </div>                      
                        
                        <div class="panel-collapse collapse documents-panel">            
                    
                            <div class="panel-body">
                            
                                <table class="table table-striped root-table"> 
                                
                                    <tr>
                                        <th width="12.5%">&nbsp;</th>
                                        <th width="12.5%">{{mainGdCtrl.str.COUNTRY_OF_ISSUE}}</th>
                                        <th width="12.5%">{{mainGdCtrl.str.DOCUMENT_NUMBER}}</th>
                                        <th width="12.5%">{{mainGdCtrl.str.VALID_FROM}}</th>
                                        <th width="12.5%">{{mainGdCtrl.str.VALID_UNTIL}}</th>
                                        <th width="12.5%">{{mainGdCtrl.str.ISSUED_BY}}</th>
                                        <th width="12.5%">{{mainGdCtrl.str.ISSUED_AT}}</th>
                                        <th width="12.5%">{{mainGdCtrl.str.DOCUMENT}}</th>
                                    </tr>            
                                
                                    <!---driving licence--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.DRIVING_LICENCE }}</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_dl_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dl_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_dl_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dl_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dl_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_dl_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dl_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dl_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_dl_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dl_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dl_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_dl_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dl_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dl_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_dl_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dl_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dl_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_dl_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
    <div class="current-data"><span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_dl_file', mainGdCtrl.data.doc_dl_hash)">{{ mainGdCtrl.data.doc_dl_filename}}</span></div>  
    <div ng-if="mainGdCtrl.data.alt.doc_dl_filename" class="alt-data"><span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_dl_file', mainGdCtrl.data.alt.doc_dl_hash)">{{ mainGdCtrl.data.alt.doc_dl_filename }}</span></div>
                                            </div>                                                                                                        
                                        </td>  
                                    </tr>     
                                    
                                    <!---passport--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.PASSPORT }}</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_pass_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_pass_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>   
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
    <div class="current-data"><span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_pass_file', mainGdCtrl.data.doc_pass_hash)">{{ mainGdCtrl.data.doc_pass_filename}}</span></div>  
    <div ng-if="mainGdCtrl.data.alt.doc_pass_filename" class="alt-data"><span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_pass_file', mainGdCtrl.data.alt.doc_pass_hash)">{{ mainGdCtrl.data.alt.doc_pass_filename }}</span></div>                             
                                            </div>                                                                
                                        </td>  
                                    </tr>     
                                    
                                    <!---passport 2--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.PASSPORT }} 2</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_pass2_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass2_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_pass2_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass2_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass2_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass2_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass2_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass2_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass2_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass2_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass2_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass2_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass2_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass2_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass2_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_pass2_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_pass2_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_pass2_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>   
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
    <div class="current-data"><span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_pass2_file', mainGdCtrl.data.doc_pass2_hash)">{{ mainGdCtrl.data.doc_pass2_filename}}</span></div>  
    <div ng-if="mainGdCtrl.data.alt.doc_pass2_filename" class="alt-data"><span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_pass2_file', mainGdCtrl.data.alt.doc_pass2_hash)">{{ mainGdCtrl.data.alt.doc_pass2_filename }}</span></div>                      
                                            </div>                                                                
                                        </td>  
                                    </tr>  
                                    
                                   <!---Work Permit (or License)--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.WORK_PERMIT }}</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_wl_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_wl_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_wl_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_wl_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_wl_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_wl_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_wl_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_wl_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_wl_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_wl_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_wl_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_wl_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_wl_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_wl_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_wl_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_wl_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_wl_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_wl_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
    <div class="current-data"><span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_wl_file', mainGdCtrl.data.doc_wl_hash)">{{ mainGdCtrl.data.doc_wl_filename}}</span></div>  
    <div ng-if="mainGdCtrl.data.alt.doc_wl_filename" class="alt-data"><span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_wl_file', mainGdCtrl.data.alt.doc_wl_hash)">{{ mainGdCtrl.data.alt.doc_wl_filename }}</span></div> 
                                            </div>                                                                
                                        </td>  
                                    </tr>  
                                    
                                   <!---Residence Permit--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.RESIDENCE_PERMIT }}</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_rp_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_rp_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_rp_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_rp_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_rp_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_rp_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_rp_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_rp_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_rp_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_rp_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_rp_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_rp_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_rp_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_rp_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_rp_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_rp_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_rp_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_rp_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
    <div class="current-data"><span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_rp_file', mainGdCtrl.data.doc_rp_hash)">{{ mainGdCtrl.data.doc_rp_filename}}</span></div>  
    <div ng-if="mainGdCtrl.data.alt.doc_rp_filename" class="alt-data"><span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_rp_file', mainGdCtrl.data.alt.doc_rp_hash)">{{ mainGdCtrl.data.alt.doc_rp_filename }}</span></div>              
                                            </div>                                                                
                                        </td>  
                                    </tr> 
                                    
                                   <!---ECHO Field badge--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.ECHO_FIELD_BADGE }}</span>
                                            </div>                                        
                                        </td> 
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_ebdg_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_ebdg_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_ebdg_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_ebdg_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_ebdg_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_ebdg_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_ebdg_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_ebdg_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_ebdg_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_ebdg_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_ebdg_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_ebdg_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_ebdg_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_ebdg_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_ebdg_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_ebdg_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_ebdg_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_ebdg_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>    
                                        <td>                                      
<div class="col-sm-12 item-div">	                      
    <div class="current-data">
    <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_ebdg_file', mainGdCtrl.data.doc_ebdg_hash)">
	    {{ mainGdCtrl.data.doc_ebdg_filename}}
    </span>
    </div>  
    <div ng-if="mainGdCtrl.data.alt.doc_ebdg_filename" class="alt-data">
    <span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_ebdg_file', mainGdCtrl.data.alt.doc_ebdg_hash)">
    	{{ mainGdCtrl.data.alt.doc_ebdg_filename }}
    </span>
    </div>  
</div>                                                                
                                        </td>  
                                    </tr>          
                                    
                                    <!---DUE Field badge--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.DUE_OFFICE_BADGE }}</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{mainGdCtrl.getCtry(mainGdCtrl.data.doc_dbdg_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dbdg_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_dbdg_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dbdg_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dbdg_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_dbdg_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dbdg_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dbdg_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_dbdg_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dbdg_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dbdg_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_dbdg_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dbdg_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dbdg_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_dbdg_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_dbdg_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_dbdg_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_dbdg_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>    
                                        <td>                                      
<div class="col-sm-12 item-div">	                      
    <div class="current-data">
	    <span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_dbdg_file', mainGdCtrl.data.doc_dbdg_hash)">{{ mainGdCtrl.data.doc_dbdg_filename}}</span>
    </div>  
    <div ng-if="mainGdCtrl.data.alt.doc_dbdg_filename" class="alt-data">
    	<span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_dbdg_file', mainGdCtrl.data.alt.doc_dbdg_hash)">
            {{ mainGdCtrl.data.alt.doc_dbdg_filename }}
        </span>
</div>  
                                            </div>                                                                
                                        </td>  
                                    </tr>       
                                    
                                    <!---Laissez-passer--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">{{ mainGdCtrl.str.LAISSEZ_PASSER }}</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_lap_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_lap_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_lap_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_lap_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_lap_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_lap_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_lap_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_lap_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_lap_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_lap_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_lap_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_lap_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_lap_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_lap_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_lap_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_lap_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_lap_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_lap_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>    
                                        <td>                                                                       
<div class="col-sm-12 item-div">	                      
    <div class="current-data">
    	<span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_lap_file', mainGdCtrl.data.doc_lap_hash)">
	    	{{ mainGdCtrl.data.doc_lap_filename}}
        </span>
    </div>  
    <div ng-if="mainGdCtrl.data.alt.doc_lap_filename" class="alt-data">
    	<span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_lap_file', mainGdCtrl.data.alt.doc_lap_hash)">
            {{ mainGdCtrl.data.alt.doc_lap_filename }}
        </span>
    </div> 
</div>   

                                    <!---"JUREP"--->
                                    <tr>
                                        <td align="right">
                                            <div class="col-sm-12 item-div">	 
                                                <span class="label label-primary">[Juridical Report]</span>
                                            </div>                                        
                                        </td>  
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.getCtry(mainGdCtrl.data.doc_jurep_country_code) }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_lap_country_code" class="alt-data">{{ mainGdCtrl.getCtry(mainGdCtrl.data.alt.doc_jurep_country_code) }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_jurep_doc_nbr }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_jurep_doc_nbr" class="alt-data">{{ mainGdCtrl.data.alt.doc_jurep_doc_nbr }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_jurep_valid_from }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_jurep_valid_from" class="alt-data">{{ mainGdCtrl.data.alt.doc_jurep_valid_from }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_jurep_valid_until }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_jurep_valid_until" class="alt-data">{{ mainGdCtrl.data.alt.doc_jurep_valid_until }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_jurep_issued_by }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_jurep_issued_by" class="alt-data">{{ mainGdCtrl.data.alt.doc_jurep_issued_by }}</div>                              
                                            </div>                                                                
                                        </td>
                                        <td>                                      
                                            <div class="col-sm-12 item-div">	                      
                                                <div class="current-data"><span>{{ mainGdCtrl.data.doc_jurep_issued_at }}</span></div>  
                                                <div ng-if="mainGdCtrl.data.alt.doc_jurep_issued_at" class="alt-data">{{ mainGdCtrl.data.alt.doc_jurep_issued_at }}</div>                              
                                            </div>                                                                
                                        </td>    
                                        <td>                                                                       
<div class="col-sm-12 item-div">	                      
    <div class="current-data">
    	<span class="file-link" ng-click="mainGdCtrl.openDocFile('doc_jurep_file', mainGdCtrl.data.doc_jurep_hash)">
	    	{{ mainGdCtrl.data.doc_jurep_filename}}
        </span>
    </div>  
    <div ng-if="mainGdCtrl.data.alt.doc_jurep_filename" class="alt-data">
    	<span class="alt-file-link" ng-click="mainGdCtrl.openDocFile('doc_jurep_file', mainGdCtrl.data.alt.doc_jurep_hash)">
            {{ mainGdCtrl.data.alt.doc_jurep_filename }}
        </span>
    </div> 
</div>                                                                                                  
                                        </td>  
                                    </tr>                        
                                    
                                </table>                         
                            
                            </div> <!---end panel body--->
                            
                        </div>  <!---end collapse---> 
                        
                    </div>  <!---end panel--->
                    
                </div>  <!---end panel group--->           
            
                
            </div>  <!--- end col  --->   
            
        </div>  <!---end row--->    
                                
                                
        <nav class="navbar navbar-inverse navbar-fixed-bottom">
            <div class="container-fluid">
                <button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='grid' value="grid" ng-click="nsmGridCtrl.switchGridDetail()">
                	{{ mainGdCtrl.str.BACK_TO_GRID }} 
                </button>   
    <cfif rc.chk_edit_gd EQ "Y">               
                <button ng-if="mainGdCtrl.canEdit" class="btn btn-primary navbar-btn" name='edit' value="edit" ng-click="mainGdCtrl.editGD()">{{ mainGdCtrl.str.EDIT }}</button>
    </cfif>  
    <cfif rc.chk_wf_start EQ "Y">
				<button ng-if="mainGdCtrl.canStartWorkFlow " class="btn btn-primary navbar-btn" name='wf_start' value="wf_start" ng-click="tabsCtrl.WF_Start()">{{ mainGdCtrl.str.START_WORKFLOW }}</button>
    </cfif>     
    <cfif rc.chk_wf_accept EQ "Y">
                    <button class="btn btn-success navbar-btn" name='wf_accept' value="wf_accept" ng-click="tabsCtrl.WF_Accept()">{{ mainGdCtrl.str.WORKFLOW_ACCEPT }}</button>
    </cfif>  
    <cfif rc.chk_wf_reject EQ "Y">
                    <button class="btn btn-danger navbar-btn" name='wf_reject' value="wf_reject" ng-click="tabsCtrl.WF_Reject('lg', '.reject-reason')">{{ mainGdCtrl.str.WORKFLOW_REJECT }}</button>
    </cfif>          
                
                <ul class="nav navbar-nav navbar-right">      
                    <li><a ng-click="mainGdCtrl.expandAll($event)" class="pointer-cursor">{{ mainGdCtrl.str.EXPAND_ALL }}</a></li> 
                    <li><a ng-click="mainGdCtrl.collapseAll($event)" class="pointer-cursor">{{ mainGdCtrl.str.COLLAPSE_ALL }}</a></li>                 	                	
                    <li><a ng-click="mainGdCtrl.reload()" class="pointer-cursor">{{ mainGdCtrl.str.RELOAD }}</a></li> 
	<cfif rc.chk_wf EQ "Y">	                    
                    <li><a ng-click="tabsCtrl.openWorkflowModal('lg', '.reject-reason')" class="pointer-cursor">Open WF Dialog</a></li> 
	</cfif>                    
                </ul>
            </div>
        </nav>   
    
    </div> <!---end panel body--->

</div> <!---end panel --->

</form>

</cfoutput>

