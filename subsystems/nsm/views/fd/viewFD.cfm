
<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });		

</script>

<cfoutput>

<form name="mainFdCtrl.nsmViewFdForm" id="nsmViewFdForm" class="form-horizontal family-data-form" update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel view-panel">

    <div class="panel-body">    
        
        <staff-banner ng-cloak></staff-banner> 
    
<!--- A. SPOUSE(S) --->    
      
        <div class="row">           
            
            <div class="stop-error-flagging">  
                
                <div class="panel-heading">                    
                    <h4 class="panel-title">  
                        <span>{{ (mainFdCtrl.data.spouses.length == 0) 
                        ?  mainFdCtrl.str.NO_SPOUSE 
                        : (mainFdCtrl.data.spouses.length > 1) 
                        ? mainFdCtrl.str.SPOUSES 
                        : mainFdCtrl.str.SPOUSE }} </span>
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
                                <a data-toggle="collapse" class="collapse-link collapsed" title="Click to expand or collapse panel (spouse id: {{ spouse.id }})" data-target=".spouse-{{ spouse.id }}-main-panel">{{spouse.lname}} {{spouse.fname}}</a>                                                                        
                            </h4>  
                                                      
                        </div> 
                        
                        <div class="panel-body">  
                            <div class="row"> 
                              <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.DOB }}: {{ spouse.birth_date || '[...]' }}</div>
                              <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.GENDER }}: {{ spouse.gender || '[...]' }}</div>
                              <div ng-if="spouse.is_dependent == 'Y'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.DEPENDENT_SINCE }} {{ spouse.dependent_since}}</div>
                              <div ng-if="spouse.is_dependent == 'N'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.NOT_DEPENDENT }}</div>
<!---                              <div ng-if="spouse.is_expatriate == 'Y'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.EXPAT_SINCE }} {{ spouse.expatriate_since}}</div>
                              <div ng-if="spouse.is_expatriate == 'N'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.NOT_DEXPAT }}</div>--->
                            </div> 
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
                        
                                    <div class="panel-collapse collapse spouse-{{ spouse.id }}-subpanel-1">   
                    
                                        <div class="panel-body"> 
                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.LNAME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_spouse_lname_{{spouse.id}}">{{ spouse.lname }}</span>
												</div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'lname')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'lname') }}
                                                </div>
                                            </div> 
                                            
                                           <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.FNAME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_spouse_fname_{{spouse.id}}">{{ spouse.fname }}</span>
												</div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'fname')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'fname') }}
                                                </div>
                                            </div>                                              
                                
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.GENDER }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_gender_{{spouse.id}}">{{ spouse.gender }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'gender')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'gender') }}
                                                </div>
                                            </div>    
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.DATE_OF_BIRTH }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_birth_date_{{spouse.id}}">{{ spouse.birth_date }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'birth_date')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'birth_date') }}
                                                </div>
                                            </div>  
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.COUNTRY_OF_BIRTH }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_country_code_{{spouse.id}}">{{ mainFdCtrl.getCtry( spouse.birth_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'birth_country_code')" class="help-block alt-data">
													{{ mainFdCtrl.getCtry( mainFdCtrl.getAlt('spouse', spouse.id, 'birth_country_code') ) }}
                                                </div>
                                            </div>     
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITY_OF_BIRTH }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_birth_city_{{spouse.id}}">{{ spouse.birth_city }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'birth_city')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'birth_city') }}
                                                </div>
                                            </div>                                               
                                            
<!---                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.EXPATRIATE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data"><span id="span_spouse_is_expatriate_{{spouse.id}}">
                                                	{{ spouse.is_expatriate }}
                                                </span></div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'is_expatriate')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'is_expatriate') }}
                                                </div>
                                            </div> --->  
                                            
<!---                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.SINCE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_expatriate_since_{{spouse.id}}">{{ spouse.expatriate_since }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'expatriate_since')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'expatriate_since') }}
                                                </div>
                                            </div>   --->                                                                                                             
                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.DEPENDENT }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">                                                
                                                	<span id="span_spouse_is_dependent_{{spouse.id}}">{{ mainFdCtrl.str[spouse.is_dependent] }}</span>
                                                </div>                                                  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'is_dependent')" class="help-block alt-data">                                            
                                                	{{ mainFdCtrl.str[ mainFdCtrl.getAlt('spouse', spouse.id, 'is_dependent') ] }} 
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.SINCE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span>{{ spouse.dependent_since }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'dependent_since')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'dependent_since') }}
                                                </div>
                                            </div>  
                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_spouse_citizenship_1_country_code_{{spouse.id}}">{{ mainFdCtrl.getCitiz( spouse.citizenship_1_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'citizenship_1_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('spouse', spouse.id, 'citizenship_1_country_code') ) }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_spouse_citizenship_2_country_code_{{spouse.id}}">{{ mainFdCtrl.getCitiz( spouse.citizenship_2_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'citizenship_2_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('spouse', spouse.id, 'citizenship_2_country_code') ) }}
                                                </div>
                                            </div>                                     
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.DATE_OF_DEATH }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_death_date_{{spouse.id}}">{{ spouse.death_date }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'death_date')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'death_date') }}
                                                </div>
                                            </div>                                                                               
                                            
                                        </div>  <!---end panel-body  --->                                                                            
                                        
                                    </div>  <!---end panel-collapse--->                                         
                                    
                                </div>  <!---end sub-panel 1--->   
                                
                                <div class="panel panel-default fieldset-panel"> <!---sub-panel 2--->
                
                                    <div class="panel-heading">                    
                                        <h4 class="panel-title">                        
                                            <a data-toggle="collapse" 
                                            class="collapse-link collapsed" 
                                            title="Click to expand or collapse sub-panel 2 (spouse id: {{ spouse.id }})" 
                                            data-target=".spouse-{{ spouse.id }}-subpanel-2" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.OCCUPATION }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse spouse-{{ spouse.id }}-subpanel-2">   
                    
                                        <div class="panel-body"> 
                                        
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.ACTIVITY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_occupation_{{spouse.id}}">{{ spouse.occupation }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'occupation')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'occupation') }}
                                                </div>
                                            </div>     
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.ORGANISATION }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_employer_{{spouse.id}}">{{ spouse.employer }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'employer')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'employer') }}
                                                </div>
                                            </div>                                                                  
                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.SINCE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_spouse_occupation_start_{{spouse.id}}">{{ spouse.occupation_start }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'occupation_start')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'occupation_start') }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.PROF_ANNUAL_INCOME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_annual_income_{{spouse.id}}">{{ spouse.annual_income }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'annual_income')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'annual_income') }}
                                                </div>
                                            </div>      
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CURRENCY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_income_currency_{{spouse.id}}">{{ spouse.income_currency }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'income_currency')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'income_currency') }}
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
                                            data-target=".spouse-{{ spouse.id }}-subpanel-3" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.CONTACT_ORIGIN_COUNTRY }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse spouse-{{ spouse.id }}-subpanel-3">   
                    
                                        <div class="panel-body">                                             
                                        
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.IDEM_NS }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_cco_same_{{spouse.id}}">{{ mainFdCtrl.str[spouse.cco_same] }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_same')" class="help-block alt-data">
                                                	{{ mainFdCtrl.str[mainFdCtrl.getAlt('spouse', spouse.id, 'cco_same')] }}
                                                </div>
                                            </div>     
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.ADDRESS }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_cco_address_{{spouse.id}}">{{ spouse.cco_address }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_address')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'cco_address') }}
                                                </div>
                                            </div>                                                                  
                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_spouse_cco_city_{{spouse.id}}">{{ spouse.cco_city }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_city')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'cco_city') }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.POSTAL_CODE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_cco_postal_code_{{spouse.id}}">{{ spouse.cco_postal_code }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_postal_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'cco_postal_code') }}
                                                </div>
                                            </div>      
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.COUNTRY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_cco_country_code_{{spouse.id}}">{{ mainFdCtrl.getCtry( spouse.cco_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'cco_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCtry( mainFdCtrl.getAlt('spouse', spouse.id, 'cco_country_code') ) }}
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
                                        
                                             <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.IDEM_NS }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_cco_same_{{spouse.id}}">{{ mainFdCtrl.str[spouse.crc_same] }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_same')" class="help-block alt-data">
                                                	{{ mainFdCtrl.str[mainFdCtrl.getAlt('spouse', spouse.id, 'crc_same')] }}
                                                </div>
                                            </div>     
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.ADDRESS }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_crc_address_{{spouse.id}}">{{ spouse.crc_address }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_address')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'crc_address') }}
                                                </div>
                                            </div>                                                                  
                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_crc_city_{{spouse.id}}">{{ spouse.crc_city }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_city')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'crc_city') }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.POSTAL_CODE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_crc_postal_code_{{spouse.id}}">{{ spouse.crc_postal_code }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_postal_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'crc_postal_code') }}
                                                </div>
                                            </div>      
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.COUNTRY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_crc_country_code_{{spouse.id}}">{{ mainFdCtrl.getCtry( spouse.crc_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'crc_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCtry( mainFdCtrl.getAlt('spouse', spouse.id, 'crc_country_code') ) }}
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
                                            data-target=".spouse-{{ spouse.id }}-subpanel-5" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.PRIVATE_CONTACT }}
                                            </a>                            
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse spouse-{{ spouse.id }}-subpanel-5">   
                    
                                        <div class="panel-body"> 
                                        
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.PRIVATE_PHONE_NBR }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_phone_nbr_{{spouse.id}}">{{ spouse.phone_nbr }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'phone_nbr')" class="help-block alt-data">
                                               		{{ mainFdCtrl.getAlt('spouse', spouse.id, 'phone_nbr') }}
                                                </div>
                                            </div>     
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.PRIVATE_MOBILE_NBR }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_mobile_nbr_{{spouse.id}}">{{ spouse.mobile_nbr }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'mobile_nbr')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'mobile_nbr') }}
                                                </div>
                                            </div>                                                                  
                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.OTHER_PHONE_NBR }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_spouse_other_phone_nbr_{{spouse.id}}">{{ spouse.other_phone_nbr }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'other_phone_nbr')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'other_phone_nbr') }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.EMAIL }} 1</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                               		<span id="span_spouse_email_1_{{spouse.id}}">{{ spouse.email_1 }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'email_1')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'email_1') }}
                                                </div>
                                            </div>      
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.EMAIL }} 2</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_spouse_email_2_{{spouse.id}}">{{ spouse.email_2 }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('spouse', spouse.id, 'email_2')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('spouse', spouse.id, 'email_2') }}
                                                </div>
                                            </div>                                             
                                        
                                        </div>  <!---end panel-body  --->                                                                            
                                        
                                    </div>  <!---end panel-collapse--->                                         
                                    
                                </div>  <!---end sub-panel 5--->                                        
                                
                            </div> <!---end body --->    
                            
                        </div> <!---end panel  --->                             
                        
                    </div>  <!---end collapse--->                                                                 
               
                </div> <!---end  spouse repeat--->                    
                </div> <!---end col-sm-6--->
                </div> <!---end parity repeat--->                
                
            </div>  <!---end group--->  			
            
		</div>  <!---end spouse(s) row--->       
        
        <div class="row spacer"></div>  
        
<!--- A. CHILDREN --->      
       
        <div class="row" ng-show="mainFdCtrl.data.children">           
            
            <div class="stop-error-flagging">  
                
                <div class="panel-heading">                    
                    <h4 class="panel-title">  
                        <span>{{ (mainFdCtrl.data.children.length == 0) 
                        ?  mainFdCtrl.str.NO_CHILDREN 
                        : (mainFdCtrl.data.children.length > 1) 
                        ? mainFdCtrl.str.CHILDREN 
                        : mainFdCtrl.str.CHILD }} </span>
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
                                <a data-toggle="collapse"
                                class="collapse-link collapsed" 
                                title="Click to expand or collapse panel (child id: {{ child.id }})" 
                                data-target=".child-{{ child.id }}-main-panel">
                                	{{child.lname}} {{child.fname}}
                                </a>                             
                            </h4>  
                                                      
                        </div> 
                        
                        <div class="panel-body">  
                            <div class="row"> 
                              <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.DOB }}: {{ child.birth_date || '[...]' }}</div>
                              <div class="col-sm-2 relative-overview">{{ mainFdCtrl.str.GENDER }}: {{ child.gender || '[...]' }}</div>
                              <div ng-if="child.is_dependent == 'Y'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.DEPENDENT_SINCE }} {{ child.dependent_since}}</div>
                              <div ng-if="child.is_dependent == 'N'" class="col-sm-4 relative-overview">{{ mainFdCtrl.str.NOT_DEPENDENT }}</div>  
                            </div> 
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
                                
                                            <div class="col-sm-3 label-div" style="background-color:pinkx">
                                                <span class="label label-primary">{{ mainFdCtrl.str.LNAME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div" style="background-color:lightbluex">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_child_lname_{{child.id}}">{{ child.lname }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'lname')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'lname') }}
                                                </div>
                                            </div>  
                                                                                
                                            <div class="col-sm-3 label-div" style="background-color:cyanx">
                                                <span class="label label-primary">{{ mainFdCtrl.str.FNAME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child_fname_{{child.id}}">{{ child.fname }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'fname')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'fname') }}
                                                </div>
                                            </div>      
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.GENDER }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child__gender_{{child.id}}">{{ child.gender }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'gender')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'gender') }}
                                                </div>
                                            </div>    
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.DATE_OF_BIRTH }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child_birth_date_{{child.id}}">{{ child.birth_date }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'birth_date')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'birth_date') }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.AGE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span>{{ mainFdCtrl.relatives[child.id].age }}</span>
                                                </div>  
                                            </div>                                  
                                            
                                            <div class="col-sm-3 label-div" style="background-color:pinkx">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div" style="background-color:lightbluex">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_child_citizenship_1_country_code_{{child.id}}">{{ mainFdCtrl.getCitiz( child.citizenship_1_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'citizenship_1_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('child', child.id, 'citizenship_1_country_code') ) }}
                                                </div>
                                            </div>  
                                                                                
                                            <div class="col-sm-3 label-div" style="background-color:cyanx">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child_citizenship_1_country_code_{{child.id}}">{{ mainFdCtrl.getCitiz( child.citizenship_2_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'citizenship_2_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('child', child.id, 'citizenship_2_country_code') ) }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.DEPENDENT }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_child_is_dependent_{{child.id}}">{{ mainFdCtrl.str[child.is_dependent] }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'is_dependent')" class="help-block alt-data">
                                                	{{ mainFdCtrl.str[ mainFdCtrl.getAlt('child', child.id, 'is_dependent') ] }} 
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.SINCE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child_dependent_since_{{child.id}}">{{ child.dependent_since }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'dependent_since')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'dependent_since') }}
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
                                    
                                    <div class="panel-collapse collapse" id="view_child_subpanel_2_{{ child.id }}">   
                    
                                        <div class="panel-body">  
                                        
                                            <div class="col-sm-3 label-div" style="background-color:pinkx">
                                                <span class="label label-primary">{{ mainFdCtrl.str.SCHOOL_NAME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div" style="background-color:lightbluex">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_child_school_name_{{child.id}}">{{ child.school_name }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_name')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'school_name') }}
                                                </div>
                                            </div>  
                                                                                
                                            <div class="col-sm-3 label-div" style="background-color:cyanx">
                                                <span class="label label-primary">{{ mainFdCtrl.str.ADDRESS }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child_school_address_{{child.id}}">{{ child.school_address }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_address')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'school_address') }}
                                                </div>
                                            </div>      
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child_school_city_{{child.id}}">{{ child.school_city }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_city')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('child', child.id, 'school_city') }}
                                                </div>
                                            </div>    
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.COUNTRY }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_child_school_country_code_{{child.id}}">{{ mainFdCtrl.getCtry( child.school_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('child', child.id, 'school_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCtry( mainFdCtrl.getAlt('child', child.id, 'school_country_code') ) }}
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
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse child-{{ child.id }}-subpanel-3">   
                    
                                        <div class="panel-body">  
                                        
                                            <div ng-repeat="scholarship in mainFdCtrl.data.scholarships[child.id] track by scholarship.id" 
                                            class="panel panel-default fieldset-panel" 
                                            ng-class="mainFdCtrl.getPanelClasses('scholarship', scholarship.id)">
                                            
                                                <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('scholarship', scholarship.id)">                    
                                                    <h5 class="panel-title">                        
                                                        <a data-toggle="collapse" 
                                                        class="collapse-link collapsed" 
                                                        title="Click to expand or collapse Scholarship panel (scholarship id: {{ scholarship.id }})" 
                                                        data-target=".scholarship-{{ scholarship.id }}-panel">
                                                        	{{ scholarship.academic_year }}
                                                        </a> 
													</h5>                            
                                                </div>  
                                                
                                                <div class="panel-collapse collapse scholarship-{{ scholarship.id }}-panel"> 
                                                
                                                    <div class="panel-body">    
                                                    
                                                        <div class="row">
                                                        
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.ACADEMIC_YEAR }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	                                 	                      
                                                                <div class="current-data">
                                                                	<span id="span_scholarship_academic_year_{{scholarship.id}}">{{ scholarship.academic_year }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'academic_year')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'academic_year') }}
                                                                </div>
                                                            </div>                                                             
                                    
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.NATURE_OF_SCHOLARSHIP }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	                                 	                      
                                                                <div class="current-data">
                                                                	<span id="span_scholarship_nature_{{scholarship.id}}">{{ scholarship.nature }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'nature')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'nature') }}
                                                                </div>
                                                            </div>  
                                                                                                
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.AMOUNT_OF_SCHOLARSHIP }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	
                                                                <div class="current-data">
                                                                	<span id="span_scholarship_monthly_amount_{{scholarship.id}}">{{ scholarship.monthly_amount }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'monthly_amount')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'monthly_amount') }}
                                                                </div>
                                                            </div>      
                                                            
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.COMMENTS }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	
                                                                <div class="current-data">
                                                                	<span id="span_scholarship_comments_{{scholarship.id}}">{{ scholarship.comments }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'comments')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'comments') }}
                                                                </div>
                                                            </div>    
                                                            
                                                        </div>  <!---end row 1--->
                                                        
                                                        <div class="row">                                                                  
                                                            
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.CURRENT_DOCUMENT }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	
                                                                <div ng-if="scholarship.scholarship_filename" 
                                                                class="current-data file-link" 
                                                                ng-click="mainFdCtrl.openScholarshipFile(scholarship.id, scholarship.upld_hash)">
                                                                	{{ scholarship.scholarship_filename }}
                                                                </div>
                                                                <div ng-if="mainFdCtrl.hasAlt('scholarship', scholarship.id, 'scholarship_filename')" 
                                                                class="help-block alt-file-link alt-data" 
                                                                ng-click="mainFdCtrl.openScholarshipFile(scholarship.id, mainFdCtrl.getAlt('scholarship', scholarship.id, 'upld_hash'))">
                                                                	{{ mainFdCtrl.getAlt('scholarship', scholarship.id, 'scholarship_filename') }}
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
                                        </h4>                            
                                    </div>    
                                    
                                    <div class="panel-collapse collapse child-{{ child.id }}-subpanel-4">   
                    
                                        <div class="panel-body">  
                                        
                                            <div ng-repeat="certificate in mainFdCtrl.data.certificates[child.id] track by certificate.id" 
                                            class="panel panel-default fieldset-panel" 
                                            ng-class="mainFdCtrl.getPanelClasses('certificate', certificate.id)">
                                            
                                                <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses('certificate', certificate.id)">                    
                                                    <h5 class="panel-title">                        
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
                                                        
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.VALID_FROM }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	                                 	                      
                                                                <div class="current-data">
                                                                	<span id="span_certificate_validity_from_{{certificate.id}}">{{ certificate.validity_from }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'validity_from')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'certificate_validity_from') }}
                                                                </div>
                                                            </div>  
                                                            
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.TIME_UNTIL }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	                                 	                      
                                                                <div class="current-data">
                                                                	<span id="span_certificate_validity_until_{{certificate.id}}">{{ certificate.validity_until }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'validity_until')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'certificate_validity_until') }}
                                                                </div>
                                                            </div>   
                                                            
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.RECEPTION_DATE }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	                                 	                      
                                                                <div class="current-data">
                                                                	<span id="span_certificate_reception_date_{{certificate.id}}">{{ certificate.reception_date }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'certificate_reception_date')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'certificate_reception_date') }}
                                                                </div>
                                                            </div>       
                                                            
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.COMMENTS }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	                                 	                      
                                                                <div class="current-data">
                                                                	<span id="span_certificate_comments_{{certificate.id}}">{{ certificate.comments }}</span>
                                                                </div>  
                                                                <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'comments')" class="help-block alt-data">
                                                                	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'certificate_comments') }}
                                                                </div>
                                                            </div>    
                                                        
                                                        </div>  <!---end row 1--->
                                                    
                                                        <div class="row">
                                                                  
                                                            <div class="col-sm-3 label-div">
                                                                <span class="label label-primary">{{ mainFdCtrl.str.CURRENT_DOCUMENT }}</span>
                                                            </div>   
                                                            <div class="col-sm-8 item-div">	
                                                                <div ng-if="certificate.certificate_filename" 
                                                                class="current-data file-link" 
                                                                ng-click="mainFdCtrl.openCertificateFile(certificate.id, certificate.upld_hash)">
                                                                	{{ certificate.certificate_filename }}
                                                                </div>
                                                                <div ng-if="mainFdCtrl.hasAlt('certificate', certificate.id, 'certificate_filename')" 
                                                                class="help-block alt-file-link alt-data" 
                                                                ng-click="mainFdCtrl.openCertificateFile(certificate.id, getAlt('certificate', certificate.id, 'upld_hash'))">
                                                                	{{ mainFdCtrl.getAlt('certificate', certificate.id, 'certificate_filename') }}
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
                </div> <!---end col-sm6--->
                </div><!--- end parity repeat--->    
                
                
            </div>  <!---end (used to be panel-group)--->			
            
		</div> <!---end children row--->
        
<!--- C. OTHER RELATIVE(S) --->       
    
        <!---<div class="row" ng-show="mainFdCtrl.relatives_count">--->
        <div class="row" ng-show="mainFdCtrl.data.relatives">           
            
            <div class="stop-error-flagging">  
                
                <div class="panel-heading">                    
                    <h4 class="panel-title">  
                        <span>
                        	{{ (mainFdCtrl.data.relatives.length == 0) 
                            ?  mainFdCtrl.str.NO_RELATIVES 
                            : (mainFdCtrl.data.relatives.length > 1) 
                            ? mainFdCtrl.str.RELATIVES 
                            : mainFdCtrl.str.RELATIVE }} 
                        </span>
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
                            </h4>  
                                                      
                        </div>  
                        
                        <div class="panel-body">  
                        
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
                                            data-target=".relative-{{ relative.id }}-subpabel-1" 
                                            style="font-size:18px; padding-left:10px">
                                            	{{ mainFdCtrl.str.PERSONAL_DATA }}
                                            </a>                            
                                        </h4>                            
                                    </div>     
                                    
                                    <div class="panel-collapse collapse relative-{{ relative.id }}-subpabel-1">   
                    
                                        <div class="panel-body"> 
                                                                    
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.LNAME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_relative_lname_{{relative.id}}">{{ relative.lname }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'lname')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('relative', relative.id, 'lname') }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.FNAME }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_relative_fname_{{relative.id}}">{{ relative.fname }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'fname')" class="help-block alt-data">
                                               		{{ mainFdCtrl.getAlt('relative', relative.id, 'fname') }}
                                                </div>
                                            </div>  
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.GENDER }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_relative_gender_{{relative.id}}">{{ relative.gender }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'gender')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('relative', relative.id, 'gender') }}
                                                </div>
                                            </div> 
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.DATE_OF_BIRTH }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_relative_birth_date_{{relative.id}}">{{ relative.birth_date }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'birth_date')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('relative', relative.id, 'birth_date') }}
                                                </div>
                                            </div> 
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_relative_citizenship_1_code_{{relative.id}}">{{ mainFdCtrl.getCitiz( relative.citizenship_1_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'citizenship_1_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('relative', relative.id, 'citizenship_1_country_code') ) }}
                                                </div>
                                            </div>      
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.CITIZENSHIP }} 2</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                <span id="span_relative_citizenship_2_code_{{relative.id}}">{{ mainFdCtrl.getCitiz( relative.citizenship_2_country_code ) }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'citizenship_2_country_code')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getCitiz( mainFdCtrl.getAlt('relative', relative.id, 'citizenship_2_country_code') ) }}
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.DEPENDENT }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	                                 	                      
                                                <div class="current-data">
                                                	<span id="span_relative_is_dependent_{{relative.id}}">{{ mainFdCtrl.str[relative.is_dependent] }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'is_dependent')" class="help-block alt-data">
                                                	{{ mainFdCtrl.str[ mainFdCtrl.getAlt('relative', relative.id, 'is_dependent') ] }} 
                                                </div>
                                            </div>   
                                            
                                            <div class="col-sm-3 label-div">
                                                <span class="label label-primary">{{ mainFdCtrl.str.SINCE }}</span>
                                            </div>   
                                            <div class="col-sm-8 item-div">	
                                                <div class="current-data">
                                                	<span id="span_relative_dependent_since_{{relative.id}}">{{ relative.dependent_since }}</span>
                                                </div>  
                                                <div ng-if="mainFdCtrl.hasAlt('relative', relative.id, 'dependent_since')" class="help-block alt-data">
                                                	{{ mainFdCtrl.getAlt('relative', relative.id, 'dependent_since') }}
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
            
		</div>  <!---end relatives row--->  
        
<!--- D. ALLOWANCES --->           
        
        <div class="row">         
            
            <div class="stop-error-flagging">  
                
   <!---             <div class="panel-heading">                    
                    <h4 class="panel-title">  
                        <span>[Family Allowances]</span>
                    </h4>                            
                </div>   ---> 
              
                <div class="col-sm-6">    
                
                    <div class="panel panel-default fieldset-panel">
                
                        <div class="panel-heading" ng-class="mainFdCtrl.getHeadingClasses2('allowances')">                                                
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
                            
                             <span>{{ mainFdCtrl.str.OTHER_FAMILY_ALLOWANCES }}</span>                             
                            
                        </div>                             
                    
                        <div class="panel-collapse collapse allowances-panel"> 
                    
                            <div class="panel-body">     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainFdCtrl.str.ALLOWANCES_NATURE }}</span>
                                </div>   
                                <div class="col-sm-8 item-div">	                                 	                      
                                    <div class="current-data">
                                    	<span>{{ mainFdCtrl.data.allowances_nature }}</span>
                                    </div>  
                                    <div ng-if="mainFdCtrl.hasAlt('allowances', 0, 'allowances_nature')" class="help-block alt-data">
                                    	{{ mainFdCtrl.getAlt('allowances', 0, 'allowances_nature') }}
                                    </div> 
                                </div>
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainFdCtrl.str.AMOUNT }}</span>
                                </div>   
                                <div class="col-sm-8 item-div">	                                 	                      
                                    <div class="current-data">
                                    	<span>{{ mainFdCtrl.data.allowances_amount }}</span>
                                    </div>  
                                    <div ng-if="mainFdCtrl.hasAlt('allowances', 0, 'allowances_amount')" class="help-block alt-data">
                                    	{{ mainFdCtrl.getAlt('allowances', 0, 'allowances_amount') }}
                                    </div> 
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainFdCtrl.str.COMMENTS }}</span>
                                </div>   
                                <div class="col-sm-8 item-div">	                                 	                      
                                    <div class="current-data">
                                    	<span>{{ mainFdCtrl.data.allowances_comments }}</span>
                                    </div>  
                                    <div ng-if="mainFdCtrl.hasAlt('allowances', 0, 'allowances_comments')" class="help-block alt-data">
                                    	{{ mainFdCtrl.getAlt('allowances', 0, 'allowances_comments') }}
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
				<button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='grid' value="grid" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainFdCtrl.str.BACK_TO_GRID }}</button>   
<cfif rc.chk_edit_fd EQ "Y">               
				<button class="btn btn-primary navbar-btn" name='edit' value="edit" ng-click="mainFdCtrl.editFD()">{{ mainFdCtrl.str.EDIT }}</button>
</cfif>  
<cfif rc.chk_wf_start EQ "Y">
				<button class="btn btn-primary navbar-btn" name='wf_start' value="wf_start" ng-click="tabsCtrl.WF_Start()">{{ mainFdCtrl.str.START_WORKFLOW }}</button>
</cfif>     
<cfif rc.chk_wf_accept EQ "Y">
				<button class="btn btn-success navbar-btn" name='wf_accept' value="wf_accept" ng-click="tabsCtrl.WF_Accept()">{{ mainFdCtrl.str.WORKFLOW_ACCEPT }}</button>
</cfif>  
<cfif rc.chk_wf_reject EQ "Y">
				<button class="btn btn-danger navbar-btn" name='wf_reject' value="wf_reject" ng-click="tabsCtrl.WF_Reject()">{{ mainFdCtrl.str.WORKFLOW_REJECT }}</button>
</cfif>         
                <ul class="nav navbar-nav navbar-right">      
                    <li><a ng-click="mainFdCtrl.expandAll($event)" class="pointer-cursor">{{ mainFdCtrl.str.EXPAND_ALL }}</a></li> 
                    <li><a ng-click="mainFdCtrl.collapseAll($event)" class="pointer-cursor">{{ mainFdCtrl.str.COLLAPSE_ALL }}</a></li>                 	                	
                    <li><a ng-click="mainFdCtrl.reload()" class="pointer-cursor">{{ mainFdCtrl.str.RELOAD }}</a></li> 
                </ul>
            </div>
        </nav>         
        
	</div> <!---end body---> 
    
</div> <!---end panel ---> 

</form>

</cfoutput>