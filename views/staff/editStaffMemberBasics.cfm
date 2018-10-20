<style type="text/css">

.col-sm-8, col-sm-2 {
	min-height: 30px;	
	vertical-align: middle;
}

.section-header {
	padding-top: 30px;		
}

</style>


<cfoutput>

<cfset rc.sm = rc.staffMemberBasicsStruct>
<cfset Local.strings = Application[Session.user.displayLanguage]["FSM"]["GD"]>

<script>

var staffMember = {};

//Set Javascript vars
<cfloop collection="#rc.sm#" item="idx">staffMember["#idx#"] = "#rc.sm[idx]#"
</cfloop>

//staffMember.country_of_birth = "AUS";
//staffMember.civility = "PROF";
/*staffMember.first_name = "#rc.sm.first_name#";
staffMember.last_name = "#rc.sm.last_name#";*/

</script>

<!--- LEFT ---> 
<div class="col-sm-6 pr0px pl0px">  
<br /> 
    <!--- Name information --->                                        
    <div class="col-sm-12">
    	<label>Name</label>
	</div>
    
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Civility</span> 
	</div>    
    <div class="col-sm-8"> 
        <select class="bootstrap-form-control" name="civility" id="civility">   
        	<option value=''>Please select</option>  
            <option value='Miss'>Miss</option> 
            <option value='Ms'>Ms</option>         
            <option value='Mr'>Mr</option>                     
        </select> 				
    </div>    
    
    <div class="col-sm-12 sep">&##160;</div>    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">#Local.strings["LIB_LNAME"]#</span> 
   </div>
    <div class="col-sm-8">
        &nbsp;&nbsp;&nbsp; #rc.sm.last_name#											
    </div>						
    
    <div class="col-sm-12 sep">&##160;</div>	
  	<div class="col-sm-2 text-right">
    	<span class="label label-info">#Local.strings["LIB_FNAME"]#</span> 
	</div>
    <div class="col-sm-8">
        &nbsp;&nbsp;&nbsp; #rc.sm.first_name#        
    </div>		
    
    <div class="col-sm-12 sep">&##160;</div>
    <div class="col-sm-2 text-right">
    	<span class="label label-info">#Local.strings["LIB_MNAME"]#</span> 
	</div>    
    <div class="col-sm-8"> 
        <input class="bootstrap-form-control k-input" type="text" name="maiden_name" id="maiden_name" value="#rc.sm.maiden_name#"/>				
    </div>	
    	
    <!--- Personal data --->
    <div class="col-sm-10 section-header">
    	<label>Personal Data</label>
	</div>
    
    <div class="col-sm-12 sep">&##160;</div>	    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">#Local.strings["LIB_GENDER"]#</span>
	</div>    
    <div class="col-sm-8"> 
        <select class="bootstrap-form-control" name="gender" id="gender">
	        <option value=''>#Local.strings["LIB_PLEASE_SELECT"]#</option>
            <option value='M'>#Local.strings["LIB_MALE"]#</option>
            <option value='F'>#Local.strings["LIB_FEMALE"]#</option>
        </select>					
    </div>
    
    <div class="col-sm-12 sep">&##160;</div>    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">#Local.strings["LIB_COUNTRY_OF_BIRTH"]#</span> 
	</div>    
    <div class="col-sm-8">                                
        <select class="bootstrap-form-control" name="birth_country_code" id="birth_country_code">    
            <option value=''>#Local.strings["LIB_PLEASE_SELECT"]#</option>    
<cfloop query="#rc.countriesQuery#">
				<option value="#country_code#">#country#</option>
</cfloop>                                   
        </select> 				
    </div>								
    
    <div class="col-sm-12 sep">&##160;</div>    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">#Local.strings["LIB_DATE_OF_BIRTH"]#</span> 
	</div>    
    <div class="col-sm-8">
        <div> 
            <input class="bootstrap-form-control" type="text" name="date_of_birth" id="date_of_birth"> 
            <!---<div class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></div--->
        </div>									
    </div>	
    
    <div class="col-sm-12 sep">&##160;</div>    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Age</span> 
    </div>    
    <div class="col-sm-8">
        &nbsp;&nbsp;&nbsp; 41 
    </div>	
    
    <div class="col-sm-12 sep">&##160;</div>    						
    <div class="col-sm-2 text-right"><span class="label label-info">Citizenship</span> </div>    
    <div class="col-sm-8">
        <select class="bootstrap-form-control" name="citizenship" id="citizenship">  
            <option value=''>Please select</option>      
<cfloop query="#rc.countriesQuery#">
				<option value="#country_code#">#country#</option>
</cfloop>                           
        </select> 					
    </div>	
    
	<div class="col-sm-12 sep">&##160;</div>    						
	<div class="col-sm-2 text-right">
    	<span class="label label-info">Second Citizenship</span> 
        </div>    
    <div class="col-sm-8">
        <select class="bootstrap-form-control" name="citizenship_2" id="citizenship_2">  
            <option value=''>Please select</option>      
<cfloop query="#rc.countriesQuery#">
				<option value="#country_code#">#country#</option>
</cfloop>                           
        </select> 					
    </div>	    
    
    <div class="col-sm-12 sep">&##160;</div>	    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Third Citizenship</span> 
	</div>    
    <div class="col-sm-8"> 
        <select class="bootstrap-form-control" name="citizenship_3" id="citizenship_3">   
			<option value=''>Please select</option>                   	              
<cfloop query="#rc.countriesQuery#">
			<option value="#country_code#">#country#</option>
</cfloop>                              
        </select>				
    </div>								
    
    <div class="col-sm-12 sep">&##160;</div>	    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">SSN</span> 
	</div>    
    <div class="col-sm-8"> 
        <input class="bootstrap-form-control k-input" type="text" name="social_security_number" id="social_security_number">					
    </div>	

    <div class="col-sm-12 sep">&##160;</div>    						
    <div class="col-sm-2 text-right"><span class="label label-info">Date of Death</label> </div>    
    <div class="col-sm-8">
        <div class="input-group">
        	<input class="bootstrap-form-control" type="text" name="date_of_death" id="date_of_death">             
        </div>													
    </div>	
    
	<!--- Family data --->	
    <div class="col-sm-10 section-header"><label>Family data</label></div>   
     
    <div class="col-sm-12 sep">&##160;</div>        						
    <div class="col-sm-2 text-right">    
    	<span class="label label-info">Marital Status</span> 
	</div>        
    <div class="col-sm-8">    
        <select class="bootstrap-form-control" name='marital_status' id='marital_status'>    
        	<option value=''>Please select</option>  
            <option value='SIN'>Single</option> 
            <option value='MAR'>Married</option>  
            <option value='WID'>Widow(er)</option>       
            <option value='DIV'>Divorced</option>    
            <option value='SEP'>Separated</option>                  
        </select>        		
    </div>
    
    <div class="col-sm-12 sep">&##160;</div>	    						
    <div class="col-sm-2 text-right">
    	<span class="label label-info">MS Date</span> 
	</div>    
    <div class="col-sm-8">
        <div class="input-group"> 
        	<input class="bootstrap-form-control" placeholder="dd/mm/yyyy" type="text" name="marital_status_date" id="marital_status_date" />
            <div class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></div>
        </div>																	
    </div>	    
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">MS Country</span> 
    </div>
    <div class="col-sm-8">
        <select class="bootstrap-form-control" type="text" name="marital_status_country" id="marital_status_country">     
            <option value=''>Please select</option>                           
        </select>				
    </div>    
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Number of Children</span> 
	</div>
    <div class="col-sm-8">
        <select class="bootstrap-form-control" name="children_count" id="children_count">       
            <option value=''>Please select</option>                    
        </select>					
    </div>
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Dependents</span> </div>
    <div class="col-sm-8"> 
         <select class="bootstrap-form-control" name="dependents_count" id="dependents_count">       
            <option value=''>Please select</option>                     
        </select>					
    </div>	
    
    <!--- Languages --->
    <div class="col-sm-10 section-header">
    	<label>Languages</label>
	</div>
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Language 1</span> 
	</div>
    <div class="col-sm-8"> 
         <select class="bootstrap-form-control" name="language_1" id="language_1">
            <option value=''>Please select</option>
            <option value='ENG'>English</option>
            <option value='FRA'>French</option>
            <option value='SPA'>Spanish</option>
            <option value='RUS'>Russian</option>
            <option value='ARA'>Arabic</option>
        </select> 					
    </div>
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Language 2</span> 
	</div>
    <div class="col-sm-8">  
         <select class="bootstrap-form-control" name="language_2" id="language_2">            
            <option value=''>Please select</option>
            <option value='ENG'>English</option>
            <option value='FRA'>French</option>
            <option value='SPA'>Spanish</option>
            <option value='RUS'>Russian</option>
            <option value='ARA'>Arabic</option>
        </select> 					
    </div>	

    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Other Languages</span> 
	</div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name="alt_languages" id="alt_languages">					
    </div> 
    
</div> 

<!--- ----------------------------------------------------------- ---> 
<!--- RIGHT --->
<div class="col-sm-6 pr0px pl0px">
	<br> 
    <!--- BUSINESS Contact Details--->
    <div class="col-sm-12"><label>Business Contact</label></div>
            
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Address</span>
        <br/>
        <small>Country of Origin</small>
	</div>
    <div class="col-sm-8" > 
        <textarea class="bootstrap-form-control" name="street_address" id="street_address" rows="3"></textarea>  
    </div>								
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">City</span> 
        </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name="city_address" id="city_address">					
    </div>		 
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Postal code</span> 
        </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name="postcode_address" id="postcode_address_1">					
    </div>	
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Country</span> 
        </div>
    <div class="col-sm-8"> 
        <select class="bootstrap-form-control" name="country_address" id="country_address" style="width:220px" >
            <option value=''>Please select</option>            
        </select> 				
    </div>															
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Effective since</label> </div>
    <div class="col-sm-8">
        <div class="input-group">
        	<input type="text" class="bootstrap-form-control" placeholder="dd/mm/yyyy" name="date_address_1" id="date_address_1">
            <div class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></div>
        </div>				
    </div>
     
    <!--- PRIVATE Contact Details--->
    <div class="col-sm-12"><label>Private contact</label></div>
    
    <div class="col-sm-12 sep">&##160;</div>					
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Address</span>
        <br/>
        <small>Residence Country</small>
	</div>
    <div class="col-sm-8"> 
        <textarea class="bootstrap-form-control" name="street_address_2" id="street_address_2" rows="3" maxlength="1000"></textarea> 					
    </div>	

    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">City</span>
    </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name="city_address_2" id="city_address_2" value="">					
    </div>		 
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Postal Code</label> 
        </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name="postcode_address_2" id="postcode_address_2" value="">					
    </div>	
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Country</label> 
        </div>
    <div class="col-sm-8"> 
        <select class="bootstrap-form-control" name="country_address_2" style="width:220px" >
            <option value="">Please select</option>
        </select> 				
    </div>

    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
	    <span class="label label-info">Private Phone Number - Home</span>
    </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name='private_phone' value="">					
    </div>									

    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right">
    	<span class="label label-info">Private mobile number</span> 
        </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name='private_mobile' value="">					
    </div>		

    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Private mobile number 2</span> </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name='private_mobile_2' value="">					
    </div>									

    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Private email address</span> </div>
    <div class="col-sm-8">
        <input type="text" class="bootstrap-form-control" name='private_email' id='private_email' value="">					
    </div>	 
                                        
    <!--- Medical check --->
    <div class="col-sm-12"><label>Medical Exam</label></div>
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Date</span> </div>
    <div class="col-sm-8">
        <div class="input-group">
        <input type="text" class="bootstrap-form-control" placeholder="dd/mm/yyyy" name='medical_exam_date' value="">
            <div class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></div>
        </div>				
    </div>
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Institution</span> </div>
    <div class="col-sm-8"> 
        <textarea class="bootstrap-form-control" name='medical_exam_institution' id='medical_exam_institution' rows="3" maxlength='1000'></textarea>		
    </div>	
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Fit</span> </div>
    <div class="col-sm-8">
        <select class="bootstrap-form-control" name='medical_exam_result'  id='medical_exam_result'>
            <option value='1'>Yes</option>
            <option value='0'>No</option> 
        </select>				
    </div>	
    
    <div class="col-sm-12 sep">&##160;</div>							
    <div class="col-sm-2 text-right"><span class="label label-info">Remarks</span> </div>
    <div class="col-sm-8"> 
        <textarea class="bootstrap-form-control" name='remarks' rows="3" maxlength='1000' 
        style="width:220px;font-size:13px;font-family:Tahoma, Geneva, sans-serif"></textarea>		
    </div> 	
</div>    
</cfoutput>




<script src="views/staff/js/editStaffMemberBasics.js"></script>

