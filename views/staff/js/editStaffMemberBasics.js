console.log(staffMember);

$(document).ready(function() {
	
	console.log("editStaffMemberBasics ready");	
   
	$("#birth_country_code").kendoDropDownList({
		value: staffMember.birth_country_code
	});  
	
	$("#citizenship").kendoDropDownList({
		value: staffMember.citizenship_1_country_code
	});	 
	
	$("#citizenship_2").kendoDropDownList({
		value: staffMember.citizenship_2_country_code
	});	
	
	$("#citizenship_3").kendoDropDownList({
		value: staffMember.citizenship_3_country_code
	});	
	
	$("#civility").kendoDropDownList({
		value: staffMember.civility
	});  	
	
	$("#gender").kendoDropDownList({
		value: staffMember.gender
	}); 	
	
	$("#street_address").kendoEditor(); 
	
	$("#date_of_birth").kendoDateInput({
    	format: "dd/MM/yyyy",
		messages:{
			"year": "yyyy",
			"month": "mm",
			"day": "dd"       
		},
		value: staffMember.date_of_birth
	});
	
	$("#date_of_death").kendoDateInput({
    	format: "dd/MM/yyyy",
		messages:{
			"year": "yyyy",
			"month": "mm",
			"day": "dd"       
		},
		value: staffMember.date_of_death
	});
	
});
