<script src="views/nsm/js/editGD.js"></script>

<cfoutput>

<style type="text/css">

.pointer-cursor{
	cursor:pointer;
}

.control-label {
	padding-right:3px;
}

.form-control-div {
	padding-left:3px;
}

.no-border {
    border: 0;
    box-shadow: none; /* You may want to include this as bootstrap applies these styles too */
}

</style>

<div ng-controller="nsmEditGdController as editGdCtrl" ng-cloak>

	<div class="container-fluid">

	<form name="nsmGdEditForm" id="nsmGdEditForm" class="form-horizontal" novalidate>
	<input type="hidden" name="staff_member_id" id="staff_member_id" value="{{editGdCtrl.data.staff_member_id}}" />

		<!--- LEFT ---> 
        <div class="col-sm-6 pr0px pl0px">     
            
			<div class="col-sm-10 section-header">
                {{editGdCtrl.str.PERSONAL_DATA}}
            </div>
            
             <!---
            <div class="col-sm-2 text-right">
                <span class="label label-primary">Civility</span>
            </div>    
           <div class="col-sm-8">             
                <select ng-init="set('civility', '#rc.nsm.civility#')" name="civility" id="civility"
                    ng-options="opt.name for opt in civilities.opts track by opt.code"
                    ng-model="civilities.selOpt"
                    class="form-control">
                </select>                                           			
            </div> --->  
                
           <!--- <div class="col-sm-12 sep">&##160;</div>  --->   
            
            <div class="form-group">	            
                <label class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.LNAME}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<span class="form-control no-border">{{editGdCtrl.data.last_name}}</span>
                </div>
            </div>
            
           <div class="form-group">	            
                <label class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.FNAME}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<span class="form-control no-border">{{editGdCtrl.data.first_name}}</span>
                </div>
            </div>  
                         
            <div class="form-group">	            
                <label for="maiden_name" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MNAME}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                <input ng-model="editGdCtrl.data.maiden_name" class="form-control" type="text" name="maiden_name" id="maiden_name"/>	
                </div>
            </div> 
            
            <div class="form-group">	            
                <label for="gender" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.GENDER}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<label class="radio-inline"><input type="radio" ng-model="editGdCtrl.data.gender" value="M" name="gender" id="genderM">M</label>
                	<label class="radio-inline"><input type="radio" ng-model="editGdCtrl.data.gender" value="F" name="gender" id="genderF">F</label> 
                </div>
            </div>  
            
            <div class="form-group">	            
                <label for="birth_country_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.COUNTRY_OF_BIRTH}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <select name="birth_country_code" id="birth_country_code" 
                    ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                    ng-model="editGdCtrl.birth_country"
                    class="form-control"
                    required-select>
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                    </select>
                </div>
            </div>  
            
            <div class="form-group">	            
                <label for="date_of_birth" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.DATE_OF_BIRTH}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.date_of_birth" class="form-control" type="text" name="date_of_birth" id="date_of_birth"> 
                </div>
            </div>   
            
            <div class="form-group">	            
                <label class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.AGE}}</span></label>  
                <div class="col-sm-2 form-control-div">                  
                	<span class="form-control no-border">{{editGdCtrl.data.age}}</span>
                </div>
            </div>  
            
            <div class="form-group">	            
                <label for="citizenship_1_country_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.CITIZENSHIP}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <select name="citizenship_1_country_code" id="citizenship_1_country_code" 
                        ng-options="ctry.name for ctry in editGdCtrl.citizenships['LIB'] track by ctry.code"
                        ng-model="editGdCtrl.citizenship_1"
                        class="form-control"
                        required-select multi="editGdCtrl.noCitizDup" pos=1>
                        <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>
                    </select> 
                </div>
            </div>   
            
            <div class="form-group">	            
                <label for="citizenship_2_country_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.SND_CITIZENSHIP}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <select name="citizenship_2_country_code" id="citizenship_2_country_code" 
                        ng-options="ctry.name for ctry in editGdCtrl.citizenships['LIB'] track by ctry.code"
                        ng-model="editGdCtrl.citizenship_2"
                        class="form-control"
                        multi="editGdCtrl.noCitizDup" pos=2>
                        <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>
                    </select> 
                </div>
            </div>   
            
            <div class="form-group">	            
                <label for="citizenship_3_country_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.TRD_CITIZENSHIP}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <select name="citizenship_3_country_code" id="citizenship_3_country_code" 
                        ng-options="ctry.name for ctry in editGdCtrl.citizenships['LIB'] track by ctry.code"
                        ng-model="editGdCtrl.citizenship_3"
                        class="form-control"
                        multi="editGdCtrl.noCitizDup" pos=3>
                        <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>
                    </select> 
                </div>
            </div>     
            
            <div class="form-group">	            
                <label for="social_security_number" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.SSN}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.social_security_number" class="form-control" type="text" name="social_security_number" id="social_security_number"> 
                </div>
            </div>   
            
            <div class="form-group">	            
                <label for="date_of_death" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.DATE_OF_DEATH}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.date_of_death" class="form-control" type="text" name="date_of_death" id="date_of_death"> 
                </div>
            </div>  
        
			<!--- Family Data --->	
            <div class="col-sm-10 section-header">
            	{{editGdCtrl.str.FAMILY_DATA}}
			</div>   
            
            <div class="form-group">	            
                <label for="ms_status" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MARITAL_STATUS}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                <select ng-model="editGdCtrl.data.ms_status" class="form-control" name="ms_status" id="ms_status"> 
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>  
                    <option value='SIN'>{{editGdCtrl.str.SINGLE}}</option> 
                    <option value='MAR'>{{editGdCtrl.str.MARRIED}}</option>  
                    <option value='WID'>{{editGdCtrl.str.WIDOW}}</option>       
                    <option value='DIV'>{{editGdCtrl.str.DIVORCED}}</option>    
                    <option value='SEP'>{{editGdCtrl.str.SEPARATED}}</option>      
                    <option value='CIV'>Civil Union</option>                  
                </select>  
                </div>
            </div>     
            
            <div class="form-group">	            
                <label for="ms_effective_from" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MS_EFFECTIVE_FROM}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.ms_effective_from" class="form-control" type="text" name="ms_effective_from" id="ms_effective_from"> 
                </div>
            </div>     
            
            <div class="form-group">	            
                <label for="ms_country_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MS_JURISDICTION}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                <select name="ms_country_code" id="ms_country_code" 
                    ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                    ng-model="editGdCtrl.ms_country"
                    class="form-control"
                    required-select>
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                </select> 
                </div>
            </div>                              
            
           <div class="form-group">	            
                <label class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.NUMBER_OF_CHILDREN}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<span class="form-control no-border">{{editGdCtrl.children_count}}</span>
                </div>
            </div>    
            
           <div class="form-group">	            
                <label class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.NUMBER_OF_DEPENDENTS}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<span class="form-control no-border">{{editGdCtrl.spouses_count + editGdCtrl.other_relatives_count}}</span>
                </div>
            </div>     
        
			<!--- Languages --->
            <div class="col-sm-10 section-header">
                {{editGdCtrl.str.LANGUAGES}}
            </div>            
            
            <div class="form-group">	            
                <label for="language_1_id" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.LANGUAGE}} 1</span></label>  
                <div class="col-sm-8 form-control-div">                  
                 <select ng-model="editGdCtrl.data.language_1_id" class="form-control" name="language_1_id" id="language_1_id" multi="editGdCtrl.noLangDup" pos=1>                
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>
                    <option value='ENG'>{{editGdCtrl.str.ENGLISH_LANG}}</option>
                    <option value='FRA'>{{editGdCtrl.str.FRENCH_LANG}}</option>
                    <option value='SPA'>{{editGdCtrl.str.SPANISH_LANG}}</option>
                    <option value='RUS'>{{editGdCtrl.str.RUSSIAN_LANG}}</option>
                    <option value='ARA'>{{editGdCtrl.str.ARABIC_LANG}}</option>
                </select> 
                </div>
            </div>      
            
            <div class="form-group">	            
                <label for="language_2_id" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.LANGUAGE}} 2</span></label>  
                <div class="col-sm-8 form-control-div">                  
                 <select ng-model="editGdCtrl.data.language_2_id" class="form-control" name="language_2_id" id="language_2_id" multi="editGdCtrl.noLangDup" pos=2>                
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>
                    <option value='ENG'>{{editGdCtrl.str.ENGLISH_LANG}}</option>
                    <option value='FRA'>{{editGdCtrl.str.FRENCH_LANG}}</option>
                    <option value='SPA'>{{editGdCtrl.str.SPANISH_LANG}}</option>
                    <option value='RUS'>{{editGdCtrl.str.RUSSIAN_LANG}}</option>
                    <option value='ARA'>{{editGdCtrl.str.ARABIC_LANG}}</option>
                </select> 
                </div>
            </div>     
            
            <div class="form-group">	            
                <label for="language_3_id" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.LANGUAGE}} 3</span></label>  
                <div class="col-sm-8 form-control-div">                  
                 <select ng-model="editGdCtrl.data.language_3_id" class="form-control" name="language_3_id" id="language_2_id" multi="editGdCtrl.noLangDup" pos=3>                
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>
                    <option value='ENG'>{{editGdCtrl.str.ENGLISH_LANG}}</option>
                    <option value='FRA'>{{editGdCtrl.str.FRENCH_LANG}}</option>
                    <option value='SPA'>{{editGdCtrl.str.SPANISH_LANG}}</option>
                    <option value='RUS'>{{editGdCtrl.str.RUSSIAN_LANG}}</option>
                    <option value='ARA'>{{editGdCtrl.str.ARABIC_LANG}}</option>
                </select> 
                </div>
            </div>           
            
  			<!--- Banking Information --->
            <div class="col-sm-10 section-header">
                {{editGdCtrl.str.BANKING_INFO}}
            </div>  
            
            <div class="form-group">	            
                <label for="bank_name" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.BANK_NAME}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.bank_name" class="form-control" type="text" name="bank_name" id="bank_name"> 
                </div>
            </div> 
            
          	<div class="form-group">	            
                <label for="bank_address" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.BANK_ADDRESS}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.bank_address" class="form-control" type="text" name="bank_address" id="bank_address"> 
                </div>
            </div>        
            
          	<div class="form-group">	            
                <label for="bank_account_holder" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.ACCOUNT_HOLDER}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.bank_account_holder" class="form-control" type="text" name="bank_account_holder" id="bank_account_holder"> 
                </div>
            </div>      
            
          	<div class="form-group">	            
                <label for="bank_iban" class="col-sm-3 control-label"><span class="label label-primary">IBAN</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.bank_iban" class="form-control" type="text" name="bank_iban" id="bank_iban"> 
                </div>
            </div>   
            
          	<div class="form-group">	            
                <label for="bank_bic" class="col-sm-3 control-label"><span class="label label-primary">BIC</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.bank_bic" class="form-control" type="text" name="bank_bic" id="bank_bic"> 
                </div>
            </div>   	
        
	    </div> 
    
		<!--- RIGHT COLUMN --->
        
        <div class="col-sm-6 pr0px pl0px">    
        
	        <!--- BUSINESS Contact Details--->
			<div class="col-sm-10 section-header">
                {{editGdCtrl.str.BUSINESS_CONTACT}}
            </div>
                   
<!---			<div class="col-sm-12 sep">&##160;</div>                    
            <div class="col-sm-2 text-right">
                <span class="label label-primary">{{editGdCtrl.str.ADDRESS}}</span>
                <br/>
                <span><small>{{editGdCtrl.str.COUNTRY_OF_ORIGIN}}</small></span>
            </div>
            <div class="col-sm-8"> 
                <textarea ng-model="editGdCtrl.data.business_address_street" class="form-control" name="business_address_street" id="business_address_street" rows="3"></textarea>  
            </div>--->	            
            
          	<div class="form-group">	            
                <label for="business_address_street" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.ADDRESS}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.business_address_street" class="form-control" type="text" name="business_address_street" id="business_address_street"> 
                </div>
            </div>     
            
          	<div class="form-group">	            
                <label for="business_address_city" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.CITY}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.business_address_city" class="form-control" type="text" name="business_address_city" id="business_address_city"> 
                </div>
            </div>  
            
          	<div class="form-group">	            
                <label for="business_address_postal_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.POSTAL_CODE}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.business_address_postal_code" class="form-control" type="text" name="business_address_postal_code" id="business_address_postal_code"> 
                </div>
            </div>      
            
          	<div class="form-group">	            
                <label for="business_address_country_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.COUNTRY}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <select name="business_address_country_code" id="business_address_country_code" 
                        ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                        ng-model="editGdCtrl.business_address_country"
                        class="form-control"
                        required-select>
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                    </select>
                </div>
            </div>    
            
          	<div class="form-group">	            
                <label for="business_address_effective_from" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.BA_EFFECTIVE_FROM}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.business_address_effective_from" class="form-control" type="text" name="business_address_effective_from" id="business_address_effective_from"> 
                </div>
            </div> 

         
			<!--- PRIVATE Contact Details--->            
			<div class="col-sm-10 section-header">
                {{editGdCtrl.str.PRIVATE_CONTACT}}
            </div>
            
<!---            <div class="col-sm-12 sep">&##160;</div>					
            <div class="col-sm-2 text-right">
                <span class="label label-primary">{{editGdCtrl.str.ADDRESS}}</span>
                <br/>
                <span><small>{{editGdCtrl.str.RESIDENCE_COUNTRY}}</small></span>
            </div>
            <div class="col-sm-8"> 
                <textarea ng-model="editGdCtrl.data.private_address_street" class="form-control" name="private_address_street" id="private_address_street" rows="3" maxlength="1000"></textarea> 					
            </div>--->	
            
          	<div class="form-group">	            
                <label for="private_address_street" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.ADDRESS}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<textarea ng-model="editGdCtrl.data.private_address_street" class="form-control" name="private_address_street" id="private_address_street" rows="3" maxlength="1000"></textarea> 	
                </div>
            </div>   
            
          	<div class="form-group">	            
                <label for="private_address_city" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.CITY}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.private_address_city" class="form-control" type="text" name="private_address_city" id="private_address_city"> 
                </div>
            </div> 
            
          	<div class="form-group">	            
                <label for="private_address_postal_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.POSTAL_CODE}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.private_address_postal_code" class="form-control" type="text" name="private_address_postal_code" id="private_address_postal_code"> 
                </div>
            </div>    
            
          	<div class="form-group">	            
                <label for="private_address_country_code" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.COUNTRY}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <select name="private_address_country_code" id="private_address_country_code" 
                        ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                        ng-model="editGdCtrl.business_address_country"
                        class="form-control"
                        required-select>
                    <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                    </select>
                </div>
            </div>  
            
          	<div class="form-group">	            
                <label for="private_address_phone_nbr" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.PHONE}} ({{editGdCtrl.str.LC_LANDLINE}})</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.private_address_postal_code" class="form-control" type="text" name="private_address_phone_nbr" id="private_address_phone_nbr"> 
                </div>
            </div>       
            
          	<div class="form-group">	            
                <label for="private_mobile_nbr_1" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MOBILE}} 1</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.private_mobile_nbr_1" class="form-control" type="text" name="private_mobile_nbr_1" id="private_mobile_nbr_1"> 
                </div>
            </div>         
            
        	<div class="form-group">	            
                <label for="private_mobile_nbr_2" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MOBILE}} 2</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<input ng-model="editGdCtrl.data.private_mobile_nbr_1" class="form-control" type="text" name="private_mobile_nbr_2" id="private_mobile_nbr_2"> 
                </div>
            </div>      
            
        	<div class="form-group" ng-class="editGdCtrl.error('private_email')">	            
                <label for="private_email" class="col-sm-3 control-label"><span class="label label-primary">EMAIL {{editGdCtrl.str.EMAIL}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <input ng-model="editGdCtrl.data.private_email" type="text" class="form-control" name="private_email" id="private_email" required ssv>
					<div ng-if="nsmGdEditForm.private_email.$valid">
                    	Please enter an email address {{100-editGdCtrl.data.private_email.length}}
                    </div> 
                    <div ng-if="nsmGdEditForm.private_email.$pending">
                    	Checking....
                    </div> 
                    <div ng-messages="nsmGdEditForm.private_email.$error" class="errors">                  
                    	<span ng-message="ssv">Already used</span>             
                    </div> 
                </div>                
            </div>  
                                            
			<!--- Medical check --->            
			<div class="col-sm-10 section-header">
                {{editGdCtrl.str.MEDICAL_EXAM}} <span>{{100-editGdCtrl.data.private_email.length}} left</span>
            </div>            
                   
<!---            <div class="col-sm-12 sep">&##160;</div>							
            <div class="col-sm-2 text-right">
                <span class="label label-primary">Validity</span> 
            </div>
            <div class="col-sm-4">
				From: <input ng-model="editGdCtrl.data.medical_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="medical_valid_from" id="valid_from">                
            </div>
             <div class="col-sm-4">				
                Until: <input ng-model="editGdCtrl.data.medical_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="medical_valid_until" id="valid_until">
            </div>--->
            
        	<div class="form-group">	            
                <label class="col-sm-3 control-label"><span class="label label-primary">[Validity]</span></label>                	
	            <div class="form-group col-sm-4">    	            
                    <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[From]</label> 
                    <div class="col-sm-8 form-control-div"> 
	                    <input ng-model="editGdCtrl.data.medical_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="medical_valid_from" id="valid_from">                
                    </div>
                </div>                
                 <div class="form-group col-sm-4">				
                    <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[Until]</label> 
                     <div class="col-sm-8 form-control-div"> 
	                    <input ng-model="editGdCtrl.data.medical_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="medical_valid_until" id="valid_until">
					</div>                        
                </div>
            </div>   
            
        	<div class="form-group">	            
                <label for="medical_exam_institution" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MEDICAL_INSTITUTION}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                	<textarea ng-model="editGdCtrl.data.medical_exam_institution" class="form-control" name="medical_exam_institution" id="medical_exam_institution" rows="3" maxlength='1000'></textarea> 
                </div>
            </div>     
            
        	<div class="form-group">	            
                <label for="medical_exam_result" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.MEDICALLY_FIT}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <label class="radio-inline"><input type="radio" ng-model="editGdCtrl.data.medical_exam_result" name="medical_exam_result" value="Y">{{editGdCtrl.str.YES}}</label>
                    <label class="radio-inline"><input type="radio" ng-model="editGdCtrl.data.medical_exam_result" name="medical_exam_result" value="N">{{editGdCtrl.str.NO}}</label>
                </div>
            </div>    
            
        	<div class="form-group">	            
                <label for="medical_remarks" class="col-sm-3 control-label"><span class="label label-primary">{{editGdCtrl.str.REMARKS}}</span></label>  
                <div class="col-sm-8 form-control-div">                  
                    <textarea ng-model="editGdCtrl.data.medical_remarks" class="form-control" name='medical_remarks' id='medical_remarks' rows="3"></textarea>	  
                    <div ng-messages="editGdCtrl.data.medical_remarks.$touched && editGdCtrl.medical_remarks.$error" class="errors">                  
                        <span ng-message="maxlength">Too big!</span>             
                    </div>
                </div>
            </div>              
            
	    </div> <!---end col-sm-12--->
        
		<div class="col-sm-12 sep">&##160;</div>   
        
        <!---documents--->
        <div class="col-sm-12 pr0px pl0px">        
        
            <table class="table table-striped root-table"> 
                
                <tr>
                    <td></td>
                    <th>{{editGdCtrl.str.COUNTRY_OF_ISSUE}}</th>
                    <th>{{editGdCtrl.str.DOCUMENT_NUMBER}}</th>
                    <th>{{editGdCtrl.str.VALIID_FROM}}</th>
                    <th>{{editGdCtrl.str.VALIID_UNTIL}}</th>
                    <th>{{editGdCtrl.str.ISSUED_BY}}</th>
                    <th>{{editGdCtrl.str.ISSUED_AT}}</th>
                </tr>            
            
				<!---driving licence--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.DRIVING_LICENCE}}</span>&nbsp;*</td>  
                    <td>                           
                        <select name="doc_dl_country_code" id="doc_dl_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_dl_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dl_doc_nbr" type="text" class="form-control" name="doc_dl_doc_nbr" id="doc_dl_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dl_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_dl_valid_from" id="doc_dl_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dl_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_dl_valid_until" id="doc_dl_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dl_issued_by" type="text" class="form-control" name="doc_dl_issued_by" id="doc_dl_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dl_issued_at" type="text" class="form-control" name="doc_dl_issued_at" id="doc_dl_issued_at">
                    </td>
                </tr>
            
				<!---passport--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.PASSPORT}}</span>&nbsp;*</td>  
                    <td>                           
                        <select name="doc_pass_country_code" id="doc_pass_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_pass_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass_doc_nbr" type="text" class="form-control" name="doc_pass_doc_nbr" id="doc_pass_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_pass_valid_from" id="doc_pass_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_pass_valid_until" id="doc_pass_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass_issued_by" type="text" class="form-control" name="doc_pass_issued_by" id="doc_pass_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass_issued_at" type="text" class="form-control" name="doc_pass_issued_at" id="doc_pass_issued_at">
                    </td>
                </tr>     
            
			  <!---passport2--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.PASSPORT}} 2</span>&nbsp;*</td>  
                    <td>                           
                        <select name="doc_pass2_country_code" id="doc_pass2_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_pass2_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass2_doc_nbr" type="text" class="form-control" name="doc_pass2_doc_nbr" id="doc_pass2_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass2_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_pass2_valid_from" id="doc_pass2_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass2_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_pass2_valid_until" id="doc_pass2_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass2_issued_by" type="text" class="form-control" name="doc_pass2_issued_by" id="doc_pass2_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_pass2_issued_at" type="text" class="form-control" name="doc_pass2_issued_at" id="doc_pass2_issued_at">
                    </td>
                </tr>     
            
			  <!---Work Permit--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.WORK_PERMIT}}</span>&nbsp;*</td>  
                    <td>                           
                        <select name="doc_wl_country_code" id="doc_wl_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_wl_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_wl_doc_nbr" type="text" class="form-control" name="doc_wl_doc_nbr" id="doc_wl_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_wl_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_wl_valid_from" id="doc_wl_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_wl_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_wl_valid_until" id="doc_wl_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_wl_issued_by" type="text" class="form-control" name="doc_wl_issued_by" id="doc_wl_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_wl_issued_at" type="text" class="form-control" name="doc_wl_issued_at" id="doc_wl_issued_at">
                    </td>
                </tr>   
            
			  <!---Residence Permit--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.RESIDENCE_PERMIT}}</span>&nbsp;*</td>  
                    <td>                           
                        <select name="doc_rp_country_code" id="doc_rp_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_rp_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_rp_doc_nbr" type="text" class="form-control" name="doc_rp_doc_nbr" id="doc_rp_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_rp_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_rp_valid_from" id="doc_rp_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_rp_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_rp_valid_until" id="doc_rp_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_rp_issued_by" type="text" class="form-control" name="doc_rp_issued_by" id="doc_rp_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_rp_issued_at" type="text" class="form-control" name="doc_rp_issued_at" id="doc_rp_issued_at">
                    </td>
                </tr>     
            
			  <!---ECHO Field badge--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.ECHO_FIELD_BADGE}}</span>&nbsp;</td>  
                    <td>                           
                        <select name="doc_ebdg_country_code" id="doc_ebdg_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_ebdg_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_ebdg_doc_nbr" type="text" class="form-control" name="doc_ebdg_doc_nbr" id="doc_ebdg_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_ebdg_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_ebdg_valid_from" id="doc_ebdg_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_ebdg_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_ebdg_valid_until" id="doc_ebdg_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_ebdg_issued_by" type="text" class="form-control" name="doc_ebdg_issued_by" id="doc_ebdg_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_ebdg_issued_at" type="text" class="form-control" name="doc_ebdg_issued_at" id="doc_ebdg_issued_at">
                    </td>
                </tr>  
            
			  <!---DU Office Badge--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.DUE_OFFICE_BADGE}}</span>&nbsp;</td>  
                    <td>                           
                        <select name="doc_dbdg_country_code" id="doc_dbdg_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_dbdg_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dbdg_doc_nbr" type="text" class="form-control" name="doc_dbdg_doc_nbr" id="doc_dbdg_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dbdg_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_dbdg_valid_from" id="doc_dbdg_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dbdg_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_dbdg_valid_until" id="doc_dbdg_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dbdg_issued_by" type="text" class="form-control" name="doc_dbdg_issued_by" id="doc_dbdg_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_dbdg_issued_by" type="text" class="form-control" name="doc_dbdg_issued_at" id="doc_dbdg_issued_at">
                    </td>
                </tr>          
            
			<!---Laisser-passer--->
                <tr>
                    <td align="right"><span class="label label-primary">{{editGdCtrl.str.LAISSEZ_PASSER}}</span>&nbsp;</td>  
                    <td>                           
                        <select name="doc_lap_country_code" id="doc_lap_country_code" 
                            ng-options="ctry.name for ctry in editGdCtrl.countries['LIB'] track by ctry.code"
                            ng-model="editGdCtrl.doc_lap_country"
                            class="form-control"
                            required-select>
                            <option value=''>{{editGdCtrl.str.PLEASE_SELECT}}</option>               
                        </select>  
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_lap_doc_nbr" type="text" class="form-control" name="doc_lap_doc_nbr" id="doc_lap_doc_nbr">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_lap_valid_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_lap_valid_from" id="doc_lap_valid_from">                    
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_lap_valid_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="doc_lap_valid_until" id="doc_lap_valid_until"> 
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_lap_issued_by" type="text" class="form-control" name="doc_lap_issued_by" id="doc_lap_issued_by">
                    </td>
                    <td>
                        <input ng-model="editGdCtrl.data.doc_lap_issued_at" type="text" class="form-control" name="doc_lap_issued_at" id="doc_lap_issued_at">
                    </td>
                </tr>  
                			                
			</table>            
        
        </div> <!---end documents--->
        
    
<!---		<div class="col-sm-12 pr0px pl0px"> 
        
        	<div style="margin-top:25px; padding-left:200px;">
                <button type="button" class="btn btn-success" ng-click="listCtrl.switchListDetail()">Back to List</button> 
                <button type="button" class="btn btn-success" ng-click="editGdCtrl.nsmEditSubmit()">Submit</button> 
                <button type="button" class="btn btn-success" ng-click="editGdCtrl.changeLanguage()">Change Language</button> 
                <button type="button" class="btn btn-success" ng-click="editGdCtrl.reload()">Reload</button> 
            </div>
            
        </div> --->   
   
	</form>

	</div> <!---end content container--->
    
    <div class="col-sm-12" style="height:80px"></div>
    
    
<nav class="navbar navbar-inverse navbar-fixed-bottom">
    <div class="container-fluid">
        <ul class="nav navbar-nav">
            <li><a ng-click="gridCtrl.switchGridDetail()" class="pointer-cursor">Back to List</a></li>
            <li><a ng-click="editGdCtrl.nsmEditSubmit()" class="pointer-cursor">Submit</a></li>
        	<li><a ng-click="editGdCtrl.reload()" class="pointer-cursor">Reload</a></li> 
            <li><a ng-click="editGdCtrl.changeLanguage()" class="pointer-cursor">Change Language</a></li>        	
        </ul>
    </div>
</nav>    
    

</div>  <!---end of NSMEditCtrl controller--->

<div style="padding-bottom:50px"></div>

</cfoutput>





