<style type="text/css">

.col-sm-8, col-sm-2 {
	min-height: 30px;	
	vertical-align: middle;
}

.section-header {
	padding-top: 30px;		
}

body {
	padding-top:140px;	
}

</style>

<cfoutput>

<script src="views/staff/js/editNSM2.js"></script>

<div ng-controller="NSMEditCtrl2" ng-cloak>

	<div class="container-fluid" style="margin-top:60px">

	<form name="nsmEditForm" id="nsmEditForm" novalidate>
	<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

		<!--- LEFT ---> 
        <div class="col-sm-6 pr0px pl0px">  
        
            <!--- Name information --->                                        
            <div class="col-sm-12">
                <label>Name</label> 
            </div>
            
            <div class="col-sm-2 text-right">
                <span class="label label-warning">Civility</span>
            </div>    
    <!---        <div class="col-sm-8">             
                <select ng-init="set('civility', '#rc.nsm.civility#')" name="civility" id="civility"
                    ng-options="opt.name for opt in civilities.opts track by opt.code"
                    ng-model="civilities.selOpt"
                    class="form-control">
                </select>                                           			
            </div> --->  
                
            <div class="col-sm-12 sep">&##160;</div>    						
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.LNAME}}</span>             
           </div>
            <div class="col-sm-8">
                &nbsp;&nbsp;&nbsp; {{nsm.last_name}}	
            </div>	        		
        
            <div class="col-sm-12 sep">&##160;</div>	
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.FNAME}}</span>           
            </div>
            <div class="col-sm-8">
                &nbsp;&nbsp;&nbsp; {{nsm.first_name}}   
            </div>		
        
            <div class="col-sm-12 sep">&##160;</div>
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.MNAME}}</span> 
            </div>    
            <div class="col-sm-8"> 
                <input ng-model="nsm.maiden_name" class="form-control" type="text" name="maiden_name" id="maiden_name" value="{{nsm.maiden_name}}"/>	           		
            </div>	
            
			<!--- Personal data --->
            <div class="col-sm-10 section-header">
                <label>Personal Data</label>
            </div>
        
            <div class="col-sm-12 sep">&##160;</div>	    						
            <div class="col-sm-2 text-right">
                <span class="label label-warning">{{strings.JS.GENDER}}</span>
            </div>    
            <div  class="col-sm-8">            
                <label class="radio-inline"><input type="radio" ng-model="nsm.gender" value="M" name="gender">M</label>
                <label class="radio-inline"><input type="radio" ng-model="nsm.gender" value="F" name="gender">F</label>            
            </div>    
        
            <div class="col-sm-12 sep">&##160;</div>    						
            <div class="col-sm-2 text-right">
                <span class="label label-warning">{{strings.JS.COUNTRY_OF_BIRTH}}</span> 
            </div>    
            <div class="col-sm-8">             
              <select name="birth_country_code" id="birth_country_code" 
                    ng-options="ctry.name for ctry in countries['LIB'] track by ctry.code"
                    ng-model="birth_country"
                    class="form-control"
                    required-select>
                <option value=''>Please Select</option>               
                </select>  
                <div ng-messages="nsmEditForm.birth_country_code.$error" class="errors">                  
                    <span ng-message="requiredSelect">requiredSelect</span>                 
                </div>                                   			
            </div>								
        
            <div class="col-sm-12 sep">&##160;</div>    						
            <div class="col-sm-2 text-right">
                <span class="label label-warning">{{strings.JS.DATE_OF_BIRTH}}</span> 
            </div>    
            <div class="col-sm-8">
                <div> 
                    <input class="form-control" type="text" name="date_of_birth" id="date_of_birth" value="{{nsm.date_of_birth}}">              
                </div>									
            </div>	
        
            <div class="col-sm-12 sep">&##160;</div>    						
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.AGE}}</span> 
            </div>    
            <div class="col-sm-8">
                &nbsp;&nbsp;&nbsp; <span>{{nsm.age}}</span>
            </div>	
        
            <div class="col-sm-12 sep">&##160;</div>    						
            <div class="col-sm-2 text-right">
                <span class="label label-warning">{{strings.JS.CITIZENSHIP}}</span> 
            </div>    
            <div class="col-sm-8">              
                <select name="citizenship_1_country_code" id="citizenship_1_country_code" 
                    ng-options="ctry.name for ctry in countries['LIB'] track by ctry.code"
                    ng-model="citizenship_1"
                    class="form-control"
                    required-select multi="noCitizDup" pos=1>
                    <option value=''>Please Select</option>
                </select>               
                 <div ng-messages="nsmEditForm.citizenship_1_country_code.$error" class="errors">                  
                    <span ng-message="requiredSelect">requiredSelect</span> 
                    <span ng-message="multi">multi 1</span> 
                </div>	                  				
            </div>	
        
            <div class="col-sm-12 sep">&##160;</div>    						
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.CITIZENSHIP_2}}</span> 
                </div>    
            <div class="col-sm-8">            
                <select name="citizenship_2_country_code" id="citizenship_2_country_code" 
                    ng-options="ctry.name for ctry in countries['LIB'] track by ctry.code"                
                    ng-model="citizenship_2"
                    class="form-control"
                    required-select multi="noCitizDup" pos=2>
                    <option value=''>Please Select</option>
                </select>                         
                 <div ng-messages="nsmEditForm.citizenship_2_country_code.$error" class="errors">  
                    <span ng-message="multi">multi 2</span>                        
                </div>            				
            </div>
        
            <div class="col-sm-12 sep">&##160;</div>	    						
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.CITIZENSHIP_3}}</span>
            </div>    
            <div class="col-sm-8">             
                <select name="citizenship_3_country_code" id="citizenship_3_country_code" 
                    ng-options="ctry.name for ctry in countries['LIB'] track by ctry.code"
                    ng-model="citizenship_3"
                    class="form-control"
                    required-select multi="noCitizDup" pos=3>
                    <option value=''>Please Select</option>
                </select>               
                 <div ng-messages="nsmEditForm.citizenship_3_country_code.$error" class="errors">  
                    <span ng-message="multi">multi 3</span>                 
                </div>                   			
            </div>								
        
            <div class="col-sm-12 sep">&##160;</div>	    						
            <div class="col-sm-2 text-right">
                <span class="label label-warning">{{strings.JS.SSN}}</span> 
            </div>    
            <div class="col-sm-8"> 
                <input ng-model="nsm.social_security_number" class="form-control" type="text" name="social_security_number" id="social_security_number" value="{{nsm.social_security_number}}">					
            </div>	
        
            <div class="col-sm-12 sep">&##160;</div>    						
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.DATE_OF_DEATH}}</span> 
            </div>    
            <div class="col-sm-8">
                <div class="input-group">
                    <input ng-model="nsm.date_of_death" class="form-control" type="text" name="date_of_death" id="date_of_death" value="{{nsm.date_of_death}}">             
                </div>													
            </div>	
        
			<!--- Family Data --->	
            <div class="col-sm-10 section-header"><label>{{strings.JS.FAMILY_DATA}}</label></div>   
             
            <div class="col-sm-12 sep">&##160;</div>        						
            <div class="col-sm-2 text-right">    
                <span class="label label-info">{{strings.JS.MARITAL_STATUS}}</span> 
            </div>        
            <div class="col-sm-8">                   
                <select ng-model="nsm.ms_status" class="form-control" name="ms_status" id="ms_status"> 
                    <option value=''>{{strings.JS.PLEASE_SELECT}}</option>  
                    <option value='SIN'>{{strings.JS.SINGLE}}</option> 
                    <option value='MAR'>{{strings.JS.MARRIED}}</option>  
                    <option value='WID'>{{strings.JS.WIDOW}}</option>       
                    <option value='DIV'>{{strings.JS.DIVORCED}}</option>    
                    <option value='SEP'>{{strings.JS.SEPARATED}}</option>                  
                </select>        		
            </div>
        
            <div class="col-sm-12 sep">&##160;</div>	    						
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.MS_EFFECTIVE_FROM}}</span> 
            </div>    
            <div class="col-sm-8">
                <div class="input-group"> 
                    <input ng-model="nsm.ms_effective_from" class="form-control" placeholder="dd/mm/yyyy" type="text" name="ms_effective_from" id="ms_effective_from" value="{{nsm.ms_effective_from}}"/>                
                </div>																	
            </div>	    
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.MS_JURISDICTION}}</span> 
            </div>
            <div class="col-sm-8">            
              <select name="ms_country_code" id="ms_country_code" 
                    ng-options="ctry.name for ctry in countries['LIB'] track by ctry.code"
                    ng-model="ms_country"
                    class="form-control"
                    required-select>
                <option value=''>Please Select</option>               
                </select>  
            </div>    
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.NUMBER_OF_CHILDREN}}</span> 
            </div>
            <div class="col-sm-8">
                <select ng-model="nsm.number_of_children" class="form-control" name="number_of_children" id="number_of_children">                 
                   <option value=''>{{strings.JS.PLEASE_SELECT}}</option>
                   <option>1</option>              
                   <option>2</option>              
                   <option>3</option>              
                   <option>4</option>              
                   <option>5</option>                                                                          
                </select>					
            </div>
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.NUMBER_OF_DEPENDENTS}}</span> 
            </div>
            <div class="col-sm-8">                   
                <select ng-model="nsm.nbr_of_dependents" convert-to-number class="form-control" name="nbr_of_dependents" id="nbr_of_dependents">    
                   <option value=''>{{strings.JS.PLEASE_SELECT}}</option>
                   <option value="1">1</option>              
                   <option value="2">2</option>              
                   <option value="3">3</option>              
                   <option value="4">4</option>              
                   <option value="5">5</option>                     
                </select>	
                <br />
                nsm.nbr_of_dependents: {{nsm.nbr_of_dependents}}				
            </div>	
        
			<!--- Languages --->
            <div class="col-sm-10 section-header">
                <label>{{strings.JS.LANGUAGES}}</label>
            </div>
            
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.LANGUAGE}} 1</span> 
            </div>
            <div class="col-sm-8">             
                 <select ng-model="nsm.language_1_id" class="form-control" name="language_1_id" id="language_1_id" multi="noLangDup" pos=1>                
                    <option value=''>{{strings.JS.PLEASE_SELECT}}</option>
                    <option value='ENG'>{{strings.JS.ENGLISH_LANG}}</option>
                    <option value='FRA'>{{strings.JS.FRENCH_LANG}}</option>
                    <option value='SPA'>{{strings.JS.SPANISH_LANG}}</option>
                    <option value='RUS'>{{strings.JS.RUSSIAN_LANG}}</option>
                    <option value='ARA'>{{strings.JS.ARABIC_LANG}}</option>
                </select> 	
                <div ng-messages="nsmEditForm.language_1_id.$error" class="errors">  
                    <span ng-message="multi">multi lang 1</span>                 
                </div>				
            </div>
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.LANGUAGE}} 2</span> 
            </div>
            <div class="col-sm-8">  
                <select ng-model="nsm.language_2_id" class="form-control" name="language_2_id" id="language_2_id" multi="noLangDup" pos=2>                <option value=''>{{strings.JS.PLEASE_SELECT}}</option>
                    <option value='ENG'>{{strings.JS.ENGLISH_LANG}}</option>
                    <option value='FRA'>{{strings.JS.FRENCH_LANG}}</option>
                    <option value='SPA'>{{strings.JS.SPANISH_LANG}}</option>
                    <option value='RUS'>{{strings.JS.RUSSIAN_LANG}}</option>
                    <option value='ARA'>{{strings.JS.ARABIC_LANG}}</option>
                </select> 		
                <div ng-messages="nsmEditForm.language_2_id.$error" class="errors">  
                    <span ng-message="multi">multi lang 2</span>                 
                </div>            			
            </div>	
    
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.LANGUAGE}} 3</span> 
            </div>
            <div class="col-sm-8">
                 <select ng-model="nsm.language_3_id" class="form-control" name="language_3_id" id="language_3_id" multi="noLangDup" pos=3>                <option value=''>{{strings.JS.PLEASE_SELECT}}</option>
                    <option value='ENG'>{{strings.JS.ENGLISH_LANG}}</option>
                    <option value='FRA'>{{strings.JS.FRENCH_LANG}}</option>
                    <option value='SPA'>{{strings.JS.SPANISH_LANG}}</option>
                    <option value='RUS'>{{strings.JS.RUSSIAN_LANG}}</option>
                    <option value='ARA'>{{strings.JS.ARABIC_LANG}}</option>
                </select> 	
                <div ng-messages="nsmEditForm.language_3_id.$error" class="errors">  
                    <span ng-message="multi">multi lang 3</span>                 
                </div>            			
            </div> 
        
	    </div> 
    
    
		<!--- RIGHT --->
        <div class="col-sm-6 pr0px pl0px">         
            <!--- BUSINESS Contact Details--->
            <div class="col-sm-12"><label>{{strings.JS.BUSINESS_CONTACT}}</label></div>
                    
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.ADDRESS}}</span>
                <br/>
                <span><small>{{strings.JS.COUNTRY_OF_ORIGIN}}</small></span>
            </div>
            <div class="col-sm-8" > 
                <textarea class="form-control" name="business_address_street" id="business_address_street" rows="3">{{nsm.business_address_street}}</textarea>  
            </div>								
            
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.CITY}}</span> 
            </div>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="business_address_city" id="business_address_city" value="{{nsm.business_address_city}}">					
            </div>		 
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.POSTAL_CODE}}</span>  
            </div>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="business_address_postal_code" id="business_address_postal_code" value="{{nsm.business_address_postal_code}}">					
            </div>	
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.COUNTRY}}</span> 
                </div>
            <div class="col-sm-8">             
             	<select name="business_address_country_code" id="business_address_country_code" 
                    ng-options="ctry.name for ctry in countries['LIB'] track by ctry.code"
                    ng-model="business_address_country"
                    class="form-control"
                    required-select>
                <option value=''>Please Select</option>               
                </select>   
            </div>															
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.BA_EFFECTIVE_FROM}}</span> 
            </div>
            <div class="col-sm-8">
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="dd/mm/yyyy" name="business_address_effective_from" id="business_address_effective_from" value="{{nsm.business_address_effective_from}}">              
                </div>				
            </div>
         
			<!--- PRIVATE Contact Details--->
            <div class="col-sm-12"><label>{{strings.JS.PRIVATE_CONTACT}}</label></div>
            
            <div class="col-sm-12 sep">&##160;</div>					
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.ADDRESS}}</span>
                <br/>
                <span><small>{{strings.JS.RESIDENCE_COUNTRY}}</small></span>
            </div>
            <div class="col-sm-8"> 
                <textarea class="form-control" name="private_address_street" id="private_address_street" rows="3" maxlength="1000">{{nsm.private_address_street}}</textarea> 					
            </div>	
    
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.CITY}}</span>
            </div>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="private_address_city" id="private_address_city" value="{{nsm.private_address_city}}">					
            </div>		 
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.POSTAL_CODE}}</span>  
            </div>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="private_address_postal_code" id="private_address_postal_code" value="{{nsm.private_address_postal_code}}">					
            </div>
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.COUNTRY}}</span> 
                </div>
            <div class="col-sm-8">             
              	<select name="private_address_country_code" id="private_address_country_code" 
                    ng-options="ctry.name for ctry in countries['LIB'] track by ctry.code"
                    ng-model="private_address_country"
                    class="form-control"
                    required-select>
                <option value=''>Please Select</option>               
                </select>	
            </div>	
    
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.PRIVATE_PHONE_NBR}}
                <span>({{strings.JS.LC_LANDLINE}})</span></span> 
            </div>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="private_address_phone_nbr" id="private_address_phone_nbr" value="{{nsm.private_address_phone_nbr}}">					
            </div>									
    
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.PRIVATE_MOBILE_NBR}}</span> 
            </div>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="private_mobile_nbr_1" id="private_mobile_nbr_1" value="{{nsm.private_mobile_nbr_1}}">					
            </div>		
    
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.PRIVATE_MOBILE_NBR}} 2</span> 
            </div>
            <div class="col-sm-8">
                <input type="text" class="form-control" name="private_mobile_nbr_2" id="private_mobile_nbr_2" value="{{nsm.private_mobile_nbr_2}}">					
            </div>								
    
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.PRIVATE_EMAIL}} *</span> 
            </div>
            <div class="col-sm-8">
                <input ng-model="nsm.private_email" type="text" class="form-control" name="private_email" id="private_email" value="{{nsm.private_email}}" ng-model-options="{ updateOn: 'blur' }" required ssv>	
            </div>            
            <div ng-if="nsmEditForm.private_email.$pending">
                 Checking....
            </div> 
            <div ng-messages="nsmEditForm.private_email.$error" class="errors">                  
                <span ng-message="ssv">SSV says no!!</span>             
            </div> 	
                                            
			<!--- Medical check --->
            <div class="col-sm-12"><label>{{strings.JS.MEDICAL_EXAM}}</label></div> 
                   
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.DATE}}</span> 
            </div>
            <div class="col-sm-8">
				<input ng-model="nsm.medical_exam_date" type="text" class="form-control" placeholder="dd/mm/yyyy" name="medical_exam_date" id="medical_exam_date" value="{{nsm.medical_exam_date}}">
            </div>
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.MEDICAL_INSTITUTION}}</span> 
            </div>
            <div class="col-sm-8"> 
                <textarea class="form-control" name="medical_exam_institution" id="medical_exam_institution" rows="3" maxlength='1000'>{{nsm.medical_exam_institution}}</textarea>	
            </div>	
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.MEDICALLY_FIT}}</span> 
            </div>
            <div class="col-sm-8">
<!---                <select class="form-control" name="medical_exam_result" id="medical_exam_result" ng-model="nsm.medical_exam_result">  
                    <option value='1'>{{strings.JS.YES}}</option>
                    <option value='0'>{{strings.JS.NO}}</option>
                </select>--->	
                
                                       
                <label class="radio-inline"><input type="radio" ng-model="nsm.medical_exam_result" name="medical_exam_result" value="Y">{{strings.JS.YES}}</label>
                <label class="radio-inline"><input type="radio" ng-model="nsm.medical_exam_result" name="medical_exam_result" value="N">{{strings.JS.NO}}</label>            
            </div>    			
            </div>	
        
            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-info">{{strings.JS.REMARKS}}</span> 
            </div>
            <div class="col-sm-8"> 
                <textarea ng-model="nsm.remarks" class="form-control" name='remarks' id='remarks' rows="3" 
                ng-maxlength="200">{{nsm.remarks}}</textarea>	  
                <div ng-messages="nsmEditForm.remarks.$touched && nsmEditForm.remarks.$error" class="errors">                  
                    <span ng-message="maxlength">Too big!</span>             
                </div>   
            </div> 
                    
	    </div> 
    
		<div class="col-sm-12 pr0px pl0px"> 
        
        	<div style="margin-top:25px; padding-left:200px;">
                <button type="button" class="btn btn-success" ng-click="nsmEditSubmit()">Submit</button> 
                <button type="button" class="btn btn-success" ng-click="changeLanguage()">Change Language</button> 
            </div>
            
        </div>    
   
	</form>

	</div> <!---end content container--->

    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container-fluid">        
            <div id="header">
                <p id="banner-title-text">EUROPEAN CIVIL PROTECTION AND HUMANITARIAN AID OPERATIONS</p>
                <p id="banner-site-name">
                    <img src="../res/images/ec_logo_en.gif" alt="European commission logo" id="banner-flag"> 
                    <span>ECHO D4 - Field Staff Management</span>
                </p>
            </div>  
        </div> <!---end navbar container--->
    </nav>

</div>  <!---end of NSMEditCtrl controller--->

<div style="padding-bottom:50px"></div>

</cfoutput>




