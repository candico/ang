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

<!---<script>

var headerHeight = 100;

$(window).bind('scroll', function () {
if ($(window).scrollTop() > headerHeight) {
    $('#myNav').removeClass('navbar-top');
    $('#myNav').addClass('navbar-fixed-top');
} else {
    $('#myNav').removeClass('navbar-fixed-top');
    $('#myNav').addClass('navbar-top');
}
}); 

</script>--->

<!---Shortcuts--->
<cfset rc.nsm = rc.staffMemberBasicsStruct>
<cfset rc.strings = Application[Session.user.displayLanguage]["FSM"]["GD"]>

<cfset rc.strings.JS_APOSTROPHE = "O\'Brien">

<cfoutput>

<!---

Uncomment to display values on the page (for debugging)

<script>

var staffMember = {};
staffMember.strings = {};


//Set National Staff Member data
<cfloop collection="#rc.nsm#" item="idx">staffMember["#idx#"] = "#rc.nsm[idx]#"
</cfloop>

//Set strings
<cfloop collection="#rc.strings#" item="idx">staffMember.strings["#idx#"] = "#rc.strings[idx]#"
</cfloop>

</script>--->

<script src="views/staff/js/editNSM.js"></script>

<div ng-controller="NSMEditCtrl" ng-cloak>

<div class="container-fluid">

<form name="nsmEditForm" id="nsmEditForm" novalidate>

	<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

	<!--- LEFT ---> 
    <div class="col-sm-6 pr0px pl0px">  
    <br /> 
        <!--- Name information --->                                        
        <div class="col-sm-12">
            <label>Name</label> 
        </div>
        
        <div class="col-sm-2 text-right">
            <h3><span class="label label-warning">Civility</span></h3>
        </div>    
        <div class="col-sm-8">             
            <select ng-init="set('civility', '#rc.nsm.civility#')" name="civility" id="civility"
	            ng-options="opt.name for opt in civilities.opts track by opt.code"
    	        ng-model="civilities.selOpt"
                class="form-control">
            </select>                                           			
        </div> 
                
        <div class="col-sm-12 sep">&##160;</div>    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_LNAME=('#rc.strings.JS_LNAME#')" class="label label-info">{{strings.JS_LNAME}}</span>             
       </div>
        <div ng-init="nsm.last_name=('#rc.nsm.last_name#')" class="col-sm-8">
            &nbsp;&nbsp;&nbsp; {{nsm.last_name}}	
        </div>	        		
        
        <div class="col-sm-12 sep">&##160;</div>	
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_FNAME=('#rc.strings.JS_FNAME#')" class="label label-info">{{strings["JS_FNAME"]}}</span>           
        </div>
        <div ng-init="nsm.first_name=('#rc.nsm.first_name#')" class="col-sm-8">
            &nbsp;&nbsp;&nbsp; {{nsm.first_name}}   
        </div>		
        
        <div class="col-sm-12 sep">&##160;</div>
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_MNAME=('#rc.strings.JS_MNAME#')" class="label label-info">{{strings.JS_MNAME}}</span> 
        </div>    
        <div class="col-sm-8"> 
            <input ng-init="nsm.maiden_name=('#rc.nsm.maiden_name#')" ng-model="nsm.maiden_name" class="form-control" type="text" name="maiden_name" id="maiden_name" value="{{nsm.maiden_name}}"/>	           		
        </div>	
            
        <!--- Personal data --->
        <div class="col-sm-10 section-header">
            <label>Personal Data</label>
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>	    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_GENDER=('#rc.strings.JS_GENDER#')" class="label label-warning">{{strings.JS_GENDER}}</span>
        </div>    
        <div  class="col-sm-8"> 
           <select ng-init="set('gender','#rc.nsm.gender#')" ng-model="nsm.gender" class="form-control" name="gender" id="gender">
                <option value='' ng-init="strings.JS_PLEASE_SELECT=('#rc.strings.JS_PLEASE_SELECT#')">{{strings.JS_PLEASE_SELECT}}</option>
                <option value='M' ng-init="strings.JS_MALE=('#rc.strings.JS_MALE#')">{{strings.JS_MALE}}</option>
                <option value='F' ng-init="strings.JS_FEMALE=('#rc.strings.JS_FEMALE#')">{{strings.JS_FEMALE}}</option>
            </select>           		
        </div>         
        
        <div class="col-sm-12 sep">&##160;</div>    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_COUNTRY_OF_BIRTH=('#rc.strings.JS_COUNTRY_OF_BIRTH#')" class="label label-warning">{{strings.JS_COUNTRY_OF_BIRTH}}</span> 
        </div>    
        <div class="col-sm-8">                                
            <select ng-init="set('birth_country_code','#rc.nsm.birth_country_code#')" ng-model="nsm.birth_country_code" class="form-control" name="birth_country_code" id="birth_country_code" >   				
            	<option value=''>{{strings.JS_PLEASE_SELECT}}</option>    
<cfloop query="#rc.countriesQuery#">
				<option value="#country_code#">#country#</option>
</cfloop>                                   
            </select> 	            			
        </div>								
        
        <div class="col-sm-12 sep">&##160;</div>    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_DATE_OF_BIRTH=('#rc.strings.JS_DATE_OF_BIRTH#')" class="label label-warning">{{strings.JS_DATE_OF_BIRTH}}</span> 
        </div>    
        <div class="col-sm-8">
            <div> 
                <input ng-init="nsm.date_of_birth=('#rc.nsm.date_of_birth#')" ng-model="nsm.date_of_birth" class="form-control" type="text" name="date_of_birth" id="date_of_birth" value="{{nsm.date_of_birth}}">              
            </div>									
        </div>	
        
        <div class="col-sm-12 sep">&##160;</div>    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_AGE=('#rc.strings.JS_AGE#')" class="label label-info">{{strings.JS_AGE}}</span> 
        </div>    
        <div class="col-sm-8">
            &nbsp;&nbsp;&nbsp; <span ng-init="nsm.age=('#rc.nsm.age#')">{{nsm.age}}</span>
        </div>	
        
        <div class="col-sm-12 sep">&##160;</div>    						
        <div class="col-sm-2 text-right">
	        <span ng-init="strings.JS_CITIZENSHIP=('#rc.strings.JS_CITIZENSHIP#')" class="label label-warning">{{strings.JS_CITIZENSHIP}}</span> 
        </div>    
        <div class="col-sm-8">            
            <select ng-init="set('citizenship_1_country_code','#rc.nsm.citizenship_1_country_code#')" ng-model="nsm.citizenship_1_country_code" class="form-control" name="citizenship_1_country_code" id="citizenship_1_country_code" required-select multi="noCitizDup" pos=1>    
                <option value=''>{{strings.JS_PLEASE_SELECT}}</option>      
    <cfloop query="#rc.countriesQuery#">
                    <option value="#country_code#">#country#</option>
    </cfloop>                           
            </select> 
             <div ng-messages="nsmEditForm.citizenship_1_country_code.$error" class="errors">                  
                <span ng-message="requiredSelect">requiredSelect</span> 
                <span ng-message="multi">multi 1</span> 
            </div>	                  				
        </div>	
        
        <div class="col-sm-12 sep">&##160;</div>    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_2ND_CITIZENSHIP=('#rc.strings.JS_2ND_CITIZENSHIP#')" class="label label-info">{{strings.JS_2ND_CITIZENSHIP}}</span> 
            </div>    
        <div class="col-sm-8">
            <select ng-init="set('citizenship_2_country_code','#rc.nsm.citizenship_2_country_code#')" ng-model="nsm.citizenship_2_country_code" class="form-control" name="citizenship_2_country_code" id="citizenship_2_country_code" multi="noCitizDup" pos=2> 
                <option value=''>{{strings.JS_PLEASE_SELECT}}</option>       
    <cfloop query="#rc.countriesQuery#">
                    <option value="#country_code#">#country#</option>
    </cfloop>                           
            </select> 	
             <div ng-messages="nsmEditForm.citizenship_2_country_code.$error" class="errors">  
                <span ng-message="multi">multi 2</span>                        
            </div>            				
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>	    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_3RD_CITIZENSHIP=('#rc.strings.JS_3RD_CITIZENSHIP#')" class="label label-info">{{strings.JS_3RD_CITIZENSHIP}}</span>
        </div>    
        <div class="col-sm-8"> 
            <select ng-init="set('citizenship_3_country_code','#rc.nsm.citizenship_3_country_code#')" ng-model="nsm.citizenship_3_country_code" class="form-control" name="citizenship_3_country_code" id="citizenship_3_country_code" multi="noCitizDup" pos=3>   
                <option value=''>{{strings.JS_PLEASE_SELECT}}</option>                    	              
    <cfloop query="#rc.countriesQuery#">
                <option value="#country_code#">#country#</option>
    </cfloop>                              
            </select>	
             <div ng-messages="nsmEditForm.citizenship_3_country_code.$error" class="errors">  
                <span ng-message="multi">multi 3</span>                 
            </div>                   			
        </div>								
        
        <div class="col-sm-12 sep">&##160;</div>	    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_SSN=('#rc.strings.JS_SSN#')" class="label label-warning">{{strings.JS_SSN}}</span> 
        </div>    
        <div class="col-sm-8"> 
            <input ng-init="nsm.social_security_number=('#rc.nsm.social_security_number#')" ng-model="nsm.social_security_number" class="form-control" type="text" name="social_security_number" id="social_security_number" value="{{nsm.social_security_number}}">					
        </div>	
    
        <div class="col-sm-12 sep">&##160;</div>    						
        <div class="col-sm-2 text-right">
        	<span ng-init="strings.JS_DATE_OF_DEATH=('#rc.strings.JS_DATE_OF_DEATH#')" class="label label-info">{{strings.JS_DATE_OF_DEATH}}</span> 
        </div>    
        <div class="col-sm-8">
            <div class="input-group">
                <input ng-init="nsm.date_of_death=('#rc.nsm.date_of_death#')" ng-model="nsm.date_of_death" class="form-control" type="text" name="date_of_death" id="date_of_death" value="{{nsm.date_of_death}}">             
            </div>													
        </div>	
        
        <!--- Family Data --->	
        <div class="col-sm-10 section-header"><label ng-init="strings.JS_FAMILY_DATA=('#rc.strings.JS_FAMILY_DATA#')">{{strings.JS_FAMILY_DATA}}</label></div>   
         
        <div class="col-sm-12 sep">&##160;</div>        						
        <div class="col-sm-2 text-right">    
            <span ng-init="strings.JS_MARITAL_STATUS=('#rc.strings.JS_MARITAL_STATUS#')" class="label label-info">{{strings.JS_MARITAL_STATUS}}</span> 
        </div>        
        <div class="col-sm-8">                   
            <select ng-init="set('ms_status','#rc.nsm.ms_status#')" ng-model="nsm.ms_status" class="form-control" name="ms_status" id="ms_status"> 
                <option value=''>{{strings.JS_PLEASE_SELECT}}</option>  
                <option ng-init="strings.JS_SINGLE=('#rc.strings.JS_SINGLE#')" value='SIN'>{{strings.JS_SINGLE}}</option> 
                <option ng-init="strings.JS_MARRIED=('#rc.strings.JS_MARRIED#')" value='MAR'>{{strings.JS_MARRIED}}</option>  
                <option ng-init="strings.JS_WIDOW=('#rc.strings.JS_WIDOW#')" value='WID'>{{strings.JS_WIDOW}}</option>       
                <option ng-init="strings.JS_DIVORCED=('#rc.strings.JS_DIVORCED#')" value='DIV'>{{strings.JS_DIVORCED}}</option>    
                <option ng-init="strings.JS_SEPARATED=('#rc.strings.JS_SEPARATED#')" value='SEP'>{{strings.JS_SEPARATED}}</option>                  
            </select>        		
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>	    						
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_MS_EFFECTIVE_FROM=('#rc.strings.JS_MS_EFFECTIVE_FROM#')" class="label label-info">{{strings.JS_MS_EFFECTIVE_FROM}}</span> 
        </div>    
        <div class="col-sm-8">
            <div class="input-group"> 
                <input ng-init="nsm.ms_effective_from=('#rc.nsm.ms_effective_from#')" ng-model="nsm.ms_effective_from" class="form-control" placeholder="dd/mm/yyyy" type="text" name="ms_effective_from" id="ms_effective_from" value="{{nsm.ms_effective_from}}"/>                
            </div>																	
        </div>	    
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_MS_JURISDICTION=('#rc.strings.JS_MS_JURISDICTION#')" class="label label-info">{{strings.JS_MS_JURISDICTION}}</span> 
        </div>
        <div class="col-sm-8">
        	<select ng-init="set('ms_jurisdiction','#rc.nsm.ms_jurisdiction#')" ng-model="nsm.ms_jurisdiction" class="form-control" name="ms_jurisdiction" id="ms_jurisdiction">               
                <option value=''>{{strings.JS_PLEASE_SELECT}}</option> 
    <cfloop query="#rc.countriesQuery#">
                <option value="#country_code#">#country#</option>
    </cfloop>                                            
            </select>				
        </div>    
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_NUMBER_OF_CHILDREN=('#rc.strings.JS_NUMBER_OF_CHILDREN#')" class="label label-info">{{strings.JS_NUMBER_OF_CHILDREN}}</span> 
        </div>
        <div class="col-sm-8">
	        <select ng-init="set('number_of_children','#rc.nsm.number_of_children#')" ng-model="nsm.number_of_children" class="form-control" name="number_of_children" id="number_of_children">                 
               <option value=''>{{strings.JS_PLEASE_SELECT}}</option>
               <option>1</option>              
               <option>2</option>              
               <option>3</option>              
               <option>4</option>              
               <option>5</option>                                                                          
            </select>					
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
        	<span ng-init="strings.JS_NUMBER_OF_DEPENDENTS=('#rc.strings.JS_NUMBER_OF_DEPENDENTS#')" class="label label-info">{{strings.JS_NUMBER_OF_DEPENDENTS}}</span> 
        </div>
        <div class="col-sm-8">                   
			<select ng-init="set('number_of_dependents','#rc.nsm.number_of_dependents#')" ng-model="nsm.number_of_dependents" class="form-control" name="number_of_dependents" id="number_of_dependents">    
               <option value=''>{{strings.JS_PLEASE_SELECT}}</option>
               <option>1</option>              
               <option>2</option>              
               <option>3</option>              
               <option>4</option>              
               <option>5</option>                     
            </select>					
        </div>	
        
        <!--- Languages --->
        <div class="col-sm-10 section-header">
            <label ng-init="strings.JS_LANGUAGES=('#rc.strings.JS_LANGUAGES#')">{{strings.JS_LANGUAGES}}</label>
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_LANGUAGE=('#rc.strings.JS_LANGUAGE#')" class="label label-info">{{strings.JS_LANGUAGE}} 1</span> 
        </div>
        <div class="col-sm-8">             
             <select ng-init="set('language_1_id','#rc.nsm.language_1_id#')" ng-model="nsm.language_1_id" class="form-control" name="language_1_id" id="language_1_id" multi="noLangDup" pos=1>                <option value=''>{{strings.JS_PLEASE_SELECT}}</option>
                <option ng-init="strings.JS_ENGLISH_LANG=('#rc.strings.JS_ENGLISH_LANG#')" value='ENG'>{{strings.JS_ENGLISH_LANG}}</option>
                <option ng-init="strings.JS_FRENCH_LANG=('#rc.strings.JS_FRENCH_LANG#')" value='FRA'>{{strings.JS_FRENCH_LANG}}</option>
                <option ng-init="strings.JS_SPANISH_LANG=('#rc.strings.JS_SPANISH_LANG#')" value='SPA'>{{strings.JS_SPANISH_LANG}}</option>
                <option ng-init="strings.JS_RUSSIAN_LANG=('#rc.strings.JS_RUSSIAN_LANG#')" value='RUS'>{{strings.JS_RUSSIAN_LANG}}</option>
                <option ng-init="strings.JS_ARABIC_LANG=('#rc.strings.JS_ARABIC_LANG#')" value='ARA'>{{strings.JS_ARABIC_LANG}}</option>
            </select> 	
			<div ng-messages="nsmEditForm.language_1_id.$error" class="errors">  
                <span ng-message="multi">multi lang 1</span>                 
            </div>				
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span class="label label-info">{{strings.JS_LANGUAGE}} 2</span> 
        </div>
        <div class="col-sm-8">  
            <select ng-init="set('language_2_id','#rc.nsm.language_2_id#')"  ng-model="nsm.language_2_id" class="form-control" name="language_2_id" id="language_2_id" multi="noLangDup" pos=2>                <option value=''>{{strings.JS_PLEASE_SELECT}}</option>
                <option ng-init="strings.JS_ENGLISH_LANG=('#rc.strings.JS_ENGLISH_LANG#')" value='ENG'>{{strings.JS_ENGLISH_LANG}}</option>
                <option ng-init="strings.JS_FRENCH_LANG=('#rc.strings.JS_FRENCH_LANG#')" value='FRA'>{{strings.JS_FRENCH_LANG}}</option>
                <option ng-init="strings.JS_SPANISH_LANG=('#rc.strings.JS_SPANISH_LANG#')" value='SPA'>{{strings.JS_SPANISH_LANG}}</option>
                <option ng-init="strings.JS_RUSSIAN_LANG=('#rc.strings.JS_RUSSIAN_LANG#')" value='RUS'>{{strings.JS_RUSSIAN_LANG}}</option>
                <option ng-init="strings.JS_ARABIC_LANG=('#rc.strings.JS_ARABIC_LANG#')" value='ARA'>{{strings.JS_ARABIC_LANG}}</option>
            </select> 		
			<div ng-messages="nsmEditForm.language_2_id.$error" class="errors">  
                <span ng-message="multi">multi lang 2</span>                 
            </div>            			
        </div>	
    
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span class="label label-info">{{strings.JS_LANGUAGE}} 3</span> 
        </div>
        <div class="col-sm-8">
             <select ng-init="set('language_3_id','#rc.nsm.language_3_id#')" ng-model="nsm.language_3_id" class="form-control" name="language_3_id" id="language_3_id" multi="noLangDup" pos=3>                <option value=''>{{strings.JS_PLEASE_SELECT}}</option>
                <option ng-init="strings.JS_ENGLISH_LANG=('#rc.strings.JS_ENGLISH_LANG#')" value='ENG'>{{strings.JS_ENGLISH_LANG}}</option>
                <option ng-init="strings.JS_FRENCH_LANG=('#rc.strings.JS_FRENCH_LANG#')" value='FRA'>{{strings.JS_FRENCH_LANG}}</option>
                <option ng-init="strings.JS_SPANISH_LANG=('#rc.strings.JS_SPANISH_LANG#')" value='SPA'>{{strings.JS_SPANISH_LANG}}</option>
                <option ng-init="strings.JS_RUSSIAN_LANG=('#rc.strings.JS_RUSSIAN_LANG#')" value='RUS'>{{strings.JS_RUSSIAN_LANG}}</option>
                <option ng-init="strings.JS_ARABIC_LANG=('#rc.strings.JS_ARABIC_LANG#')" value='ARA'>{{strings.JS_ARABIC_LANG}}</option>
            </select> 	
			<div ng-messages="nsmEditForm.language_3_id.$error" class="errors">  
                <span ng-message="multi">multi lang 3</span>                 
            </div>            			
        </div> 
        
    </div> 
    
    <!--- ----------------------------------------------------------- ---> 
    <!--- RIGHT --->
    <div class="col-sm-6 pr0px pl0px">
        <br> 
        <!--- BUSINESS Contact Details--->
        <div class="col-sm-12"><label ng-init="strings.JS_BUSINESS_CONTACT=('#rc.strings.JS_BUSINESS_CONTACT#')">{{strings.JS_BUSINESS_CONTACT}}</label></div>
                
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_ADDRESS=('#rc.strings.JS_ADDRESS#')" class="label label-info">{{strings.JS_ADDRESS}}</span>
            <br/>
            <span ng-init="strings.JS_COUNTRY_OF_ORIGIN=('#rc.strings.JS_COUNTRY_OF_ORIGIN#')"><small>{{strings.JS_COUNTRY_OF_ORIGIN}}</small></span>
        </div>
        <div class="col-sm-8" > 
            <textarea ng-init="nsm.business_address_street=('#rc.nsm.business_address_street#')" class="form-control" name="business_address_street" id="business_address_street" rows="3">{{nsm.business_address_street}}</textarea>  
        </div>								
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_CITY=('#rc.strings.JS_CITY#')" class="label label-info">{{strings.JS_CITY}}</span> 
 		</div>
        <div class="col-sm-8">
            <input ng-init="nsm.business_address_city=('#rc.nsm.business_address_city#')" type="text" class="form-control" name="business_address_city" id="business_address_city" value="{{nsm.business_address_city}}">					
        </div>		 
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_POSTAL_CODE=('#rc.strings.JS_POSTAL_CODE#')" class="label label-info">{{strings.JS_POSTAL_CODE}}</span>  
 		</div>
        <div class="col-sm-8">
            <input ng-init="nsm.business_address_postal_code=('#rc.nsm.business_address_postal_code#')" type="text" class="form-control" name="business_address_postal_code" id="business_address_postal_code" value="{{nsm.business_address_postal_code}}">					
        </div>	
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_COUNTRY=('#rc.strings.JS_COUNTRY#')" class="label label-info">{{strings.JS_COUNTRY}}</span> 
            </div>
        <div class="col-sm-8"> 
            <select ng-init="set('business_address_country_code','#rc.nsm.business_address_country_code#')" class="form-control" name="business_address_country_code" id="business_address_country_code" ng-model="nsm.business_address_country_code">       
                <option value=''>{{strings.JS_PLEASE_SELECT}}</option> 
    <cfloop query="#rc.countriesQuery#">
                <option value="#country_code#">#country#</option>
    </cfloop>                                            
            </select>				
        </div>															
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
        	<span ng-init="strings.JS_BA_EFFECTIVE_FROM=('#rc.strings.JS_BA_EFFECTIVE_FROM#')" class="label label-info">{{strings.JS_BA_EFFECTIVE_FROM}}</span> 
        </div>
        <div class="col-sm-8">
            <div class="input-group">
                <input ng-init="nsm.business_address_effective_from=('#rc.nsm.business_address_effective_from#')" type="text" class="form-control" placeholder="dd/mm/yyyy" name="business_address_effective_from" id="business_address_effective_from" value="{{nsm.business_address_effective_from}}">              
            </div>				
        </div>
         
        <!--- PRIVATE Contact Details--->
        <div class="col-sm-12"><label ng-init="strings.JS_PRIVATE_CONTACT=('#rc.strings.JS_PRIVATE_CONTACT#')">{{strings.JS_PRIVATE_CONTACT}}</label></div>
        
        <div class="col-sm-12 sep">&##160;</div>					
        <div class="col-sm-2 text-right">
            <span class="label label-info">{{strings.JS_ADDRESS}}</span>
            <br/>
            <span ng-init="strings.JS_RESIDENCE_COUNTRY=('#rc.strings.JS_RESIDENCE_COUNTRY#')"><small>{{strings.JS_RESIDENCE_COUNTRY}}</small></span>
        </div>
        <div class="col-sm-8"> 
            <textarea ng-init="nsm.private_address_street=('#rc.nsm.business_address_effective_from#')" class="form-control" name="private_address_street" id="private_address_street" rows="3" maxlength="1000">{{nsm.private_address_street}}</textarea> 					
        </div>	
    
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span class="label label-info">{{strings.JS_CITY}}</span>
        </div>
        <div class="col-sm-8">
            <input ng-init="nsm.private_address_city=('#rc.nsm.private_address_city#')" type="text" class="form-control" name="private_address_city" id="private_address_city" value="{{nsm.private_address_city}}">					
        </div>		 
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span class="label label-info">{{strings.JS_POSTAL_CODE}}</span>  
 		</div>
        <div class="col-sm-8">
            <input ng-init="nsm.private_address_postal_code=('#rc.nsm.business_address_postal_code#')" type="text" class="form-control" name="private_address_postal_code" id="private_address_postal_code" value="{{nsm.private_address_postal_code}}">					
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span class="label label-info">{{strings.JS_COUNTRY}}</span> 
            </div>
        <div class="col-sm-8"> 
            <select ng-init="set('private_address_country_code','#rc.nsm.private_address_country_code#')" class="form-control" name="private_address_country_code" id="private_address_country_code" ng-model="nsm.private_address_country_code">     
                <option value=''>{{strings.JS_PLEASE_SELECT}}</option> 
    <cfloop query="#rc.countriesQuery#">
                <option value="#country_code#">#country#</option>
    </cfloop>                                            
            </select>				
        </div>	
    
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_PRIVATE_PHONE_NBR=('#rc.strings.JS_PRIVATE_PHONE_NBR#')" class="label label-info">{{strings.JS_PRIVATE_PHONE_NBR}}
            <span ng-init="strings.JS_LC_LANDLINE=('#rc.strings.JS_LC_LANDLINE#')">({{strings.JS_LC_LANDLINE}})</span></span> 
                        
        </div>
        <div class="col-sm-8">
            <input ng-init="nsm.private_address_phone_nbr=('#rc.nsm.private_address_phone_nbr#')" type="text" class="form-control" name="private_address_phone_nbr" id="private_address_phone_nbr" value="{{nsm.private_address_phone_nbr}}">					
        </div>									
    
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_PRIVATE_MOBILE_NBR=('#rc.strings.JS_PRIVATE_MOBILE_NBR#')" class="label label-info">{{strings.JS_PRIVATE_MOBILE_NBR}}</span> 
   		</div>
        <div class="col-sm-8">
            <input ng-init="nsm.private_mobile_nbr_1=('#rc.nsm.private_mobile_nbr_1#')" type="text" class="form-control" name="private_mobile_nbr_1" id="private_mobile_nbr_1" value="{{nsm.private_mobile_nbr_1}}">					
        </div>		
    
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span class="label label-info">{{strings.JS_PRIVATE_MOBILE_NBR}} 2</span> 
   		</div>
        <div class="col-sm-8">
            <input ng-init="nsm.private_mobile_nbr_2=('#rc.nsm.private_mobile_nbr_2#')" type="text" class="form-control" name="private_mobile_nbr_2" id="private_mobile_nbr_2" value="{{nsm.private_mobile_nbr_2}}">					
        </div>								
    
     	<div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_PRIVATE_EMAIL=('#rc.strings.JS_PRIVATE_EMAIL#')" class="label label-info">{{strings.JS_PRIVATE_EMAIL}} *</span> 
   		</div>
        <div class="col-sm-8">
            <input  ng-model="nsm.private_email" type="text" class="form-control" name="private_email" id="private_email" value="{{nsm.private_email}}" ng-model-options="{ updateOn: 'blur' }" required ssv>	
            
        <div ng-if="nsmEditForm.private_email.$pending">
             Checking....
        </div>         
        <!---ng-init="nsm.private_email=('#rc.nsm.private_email#')"--->
           <div ng-messages="nsmEditForm.private_email.$error" class="errors">                  
                <span ng-message="ssv">SSV says no!!</span>             
            </div>           
            				
        </div>	 
                                            
        <!--- Medical check --->
        <div class="col-sm-12"><label ng-init="strings.JS_MEDICAL_EXAM=('#rc.strings.JS_MEDICAL_EXAM#')">{{strings.JS_MEDICAL_EXAM}}</label></div>
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
        	<span ng-init="strings.JS_DATE=('#rc.strings.JS_DATE#')" class="label label-info">{{strings.JS_DATE}}</span> 
		</div>
        <div class="col-sm-8">
            	<input ng-init="nsm.medical_exam_date=('#rc.nsm.medical_exam_date#')" ng-model="nsm.medical_exam_date" type="text" class="form-control" placeholder="dd/mm/yyyy" name="medical_exam_date" id="medical_exam_date" value="{{nsm.medical_exam_date}}">          
        </div>
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
        	<span ng-init="strings.JS_MEDICAL_INSTITUTION=('#rc.strings.JS_MEDICAL_INSTITUTION#')" class="label label-info">{{strings.JS_MEDICAL_INSTITUTION}}</span> 
		</div>
        <div class="col-sm-8"> 
            <textarea ng-init="nsm.medical_exam_institution=('#rc.nsm.medical_exam_institution#')" class="form-control" name="medical_exam_institution" id="medical_exam_institution" rows="3" maxlength='1000'>{{nsm.medical_exam_institution}}</textarea>	
        </div>	
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
        	<span ng-init="strings.JS_MEDICALLY_FIT=('#rc.strings.JS_MEDICALLY_FIT#')" class="label label-info">{{strings.JS_MEDICALLY_FIT}}</span> 
		</div>
        <div class="col-sm-8">
			<select ng-init="set('medical_exam_result','#rc.nsm.medical_exam_result#')" class="form-control" name="medical_exam_result" id="medical_exam_result" ng-model="nsm.medical_exam_result">  
                <option ng-init="strings.JS_YES=('#rc.strings.JS_YES#')" value='1'>{{strings.JS_YES}}</option>
                <option ng-init="strings.JS_NO=('#rc.strings.JS_NO#')" value='0'>{{strings.JS_NO}}</option>
            </select>				
        </div>	
        
        <div class="col-sm-12 sep">&##160;</div>							
        <div class="col-sm-2 text-right">
            <span ng-init="strings.JS_REMARKS=('#rc.strings.JS_REMARKS#')" class="label label-info">{{strings.JS_REMARKS}}</span> 
		</div>
        <div class="col-sm-8"> 
            <textarea ng-init="nsm.remarks=('#rc.nsm.remarks#')" ng-model="nsm.remarks" class="form-control" name='remarks' id='remarks' rows="3" 
            ng-maxlength="200">{{nsm.remarks}}</textarea>	  
            <div ng-messages="nsmEditForm.remarks.$touched && nsmEditForm.remarks.$error" class="errors">                  
                <span ng-message="maxlength">Too big!</span>             
            </div>   
        </div> 	
    </div> 
    

    
 <!---   <button type="button" class="btn btn-success" ng-click="nsmEditSubmit()">Submit</button> 
    <button type="button" class="btn btn-success" ng-click="nsmEditSwitchLang()">Switch Language</button>  ---> 
    
   
</form>

</div> <!---end content container--->

<nav class="navbar navbar-default navbar-fixed-top">
<!---<nav id="myNav" class="navbar navbar-default " role="navigation">--->
	<div class="container-fluid">
    
        <div id="header">
        	<p id="banner-title-text">EUROPEAN CIVIL PROTECTION AND HUMANITARIAN AID OPERATIONS</p>
            <p id="banner-site-name">
                <img src="../res/images/ec_logo_en.gif" alt="European commission logo" id="banner-flag"> 
                <span>ECHO D4 - Field Staff Management</span>
            </p>
        </div>     
   
<!---        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" data-target="##navbarCollapse" data-toggle="collapse" class="navbar-toggle">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a href="" class="navbar-brand">Brand</a>
        </div>
        <!-- Collection of nav links and other content for toggling -->
        <div id="navbarCollapse" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="">Home</a></li>
                <li><a href="">Profile</a></li>
                <li><a href="">Messages</a></li>
               <!--- <li><button type="button" class="btn btn-success" ng-click="nsmEditSwitchLang()">Switch Language</button></li>--->
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="">Login</a></li>
                
            </ul>
        </div>--->
    </div> <!---end navbar container--->
</nav>

</div>  <!---end of NSMEditCtrl controller--->

</cfoutput>




