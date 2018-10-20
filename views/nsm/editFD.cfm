<script src="views/nsm/js/editFD.js"></script>

<cfoutput>

<style type="text/css">

.gi-4xs{font-size: 0.25em;}
.gi-2xs{font-size: 0.5em;}
.gi-2x{font-size: 2em;}
.gi-3x{font-size: 3em;}
.gi-4x{font-size: 4em;}
.gi-5x{font-size: 5em;}

.padded-cells td { 	
	padding-top:10px;
	padding-bottom:10px;
	padding-right:15px;	
}

.ten-cells td { 		
	width:10%;	
}

.pointer-cursor{
	cursor:pointer;
}

.group-header-row{
	height:40px;
}

</style>

<div ng-controller="nsmEditFdController as editFdCtrl" ng-cloak>
<form name="nsmFdEditForm" id="nsmFdEditForm" novalidate>   
<input type="hidden" name="staff_member_id" id="staff_member_id" value="{{editFdCtrl.staff_member_id}}" />
	<div class="container-fluid"> 
		<div class="row">             
                                
<!--- HEADER --->

            <div class="col-sm-12">           
                        
                <table width="100%" id="headerTable" ng-cloak>   
                
                    <tr class="group-header-row">
						<th colspan="10">{{ editFdCtrl.str.RELATIVES }}</th>                       
                    </tr>                  
                
                    <tr ng-show="editFdCtrl.all_relatives_count" class="ten-cells" height="40px">
                        <td>&nbsp;</td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.LNAME }}</span></td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.FNAME }}</span></td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.DATE_OF_BIRTH }}</span></td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.GENDER }}</span></td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.DEPENDENT }}</span></td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.SINCE }}</span></td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.EXPATRIATE }}</span></td>
                        <td><span class="label label-primary">{{ editFdCtrl.str.SINCE }}</span></td>   
                        <td>&nbsp;</td>             
                    </tr>  
                    
                    <tr ng-hide="editFdCtrl.all_relatives_count" height="40px">
                        <td width="100%">{{ editFdCtrl.str.NO_RELATIVES }}</td>
                    </tr>                     
                    
				</table>
                
			</div>   
            
<!--- A. SPOUSE(S) --->             
            
			 <div class="col-sm-12" ng-show="editFdCtrl.spouses_count">                        
              
                <table width="100%" id="spousesOuterTable">            
                    
                    <tr ng-repeat="spouse in editFdCtrl.data.spouses track by spouse.id"> 
                        <td colspan="10">
                            <table width="100%">                    
                    
                                <tr class="padded-cells ten-cells"> <!---primary row--->
                                   <td class="text-right"><span class="label label-primary" title="{{spouse.id}}">{{editFdCtrl.str[spouse.relation]}}</span></td>
                                   		<input type="hidden" value="{{spouse.relation}}" name='spouse_relation_{{spouse.id}}'>
                                    <td>
                                        <input ng-model="spouse.surname" type="text" class="form-control" name='spouse_surname_{{spouse.id}}'>
                                    </td>
                                    <td>
                                        <input ng-model="spouse.name" type="text" class="form-control" name='spouse_name_{{spouse.id}}'>
                                    </td>
                                    <td>                     
                                        <input type="text" ng-model="spouse.dob" class="form-control" placeholder="dd/mm/yyyy" name='spouse_dob_{{spouse.id}}'> 
                                    </td>
                                    <td>  
                                        <label class="radio-inline"><input ng-model="spouse.gender" type="radio" value="M" name="spouse_gender_{{spouse.id}}">M</label>
						               	<label class="radio-inline"><input ng-model="spouse.gender" type="radio" value="F" name="spouse_gender_{{spouse.id}}">F</label>
                                    </td>
                                    <td>                                         
                                        <label class="radio-inline"><input ng-model="spouse.is_dependent" type="radio" value="Y" name="spouse_is_dependent_{{spouse.id}}">{{ editFdCtrl.str.YES }}</label>
						                <label class="radio-inline"><input ng-model="spouse.is_dependent" type="radio" value="N" name="spouse_is_dependent_{{spouse.id}}">{{ editFdCtrl.str.NO }}</label>
                                    </td>
                                    <td>
                                        <input ng-model="spouse.dependent_since" type="text" class="form-control" name='spouse_dependent_since_{{spouse.id}}' placeholder="dd/mm/yyyy">  
                                    </td>
                                    <td> 
                                        <label class="radio-inline"><input ng-model="spouse.is_expatriate" type="radio" value="Y" name="spouse_is_expatriate_{{spouse.id}}">{{ editFdCtrl.str.YES }}</label>
						                <label class="radio-inline"><input ng-model="spouse.is_expatriate" type="radio" value="N" name="spouse_is_expatriate_{{spouse.id}}">{{ editFdCtrl.str.NO }}</label>
                                    </td>
                                    <td>
                                        <input ng-model="spouse.expatriate_since" type="text" class="form-control" name='spouse_expatriate_since_{{spouse.id}}' placeholder="dd/mm/yyyy">
                                    </td>
                                   	<td> 
                                        <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="##spouse_collapsible_panel_{{spouse.id}}" title='Toggle Details Table'>
                                        	<span class="glyphicon glyphicon-collapse-down"></span> 
                                        </button> 
                                        <button class="btn btn-primary" type="button" ng-click="editFdCtrl.removeRelative(spouse.id)" title='Remove relative'>
                                        	<span class="glyphicon glyphicon-remove"></span>
                                        </button>                                        
                                    </td>            
                                </tr>  <!---end primary row--->                             
                            
								<tr>  <!---secondary row--->
                                    <td colspan="10" valign="top"> 
                                    	<div id="spouse_collapsible_panel_{{spouse.id}}" class="collapse">                                    
                                        	<table width="100%" border="0" class="table table-striped root-table" style="margin-top:5px">     
                                
                                                <tr> 
                                                    <td> 
                                                    <!--- A. LEFT COLUMNN --->
                                                    <div class="col-sm-4"> 
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.OCCUPATION }}</span> </div>
                                                        <div class="col-sm-8"> 	 
                                                        <input ng-model="spouse.occupation" type="text" class="form-control" name='spouse_occupation_{{spouse.id}}'>				 				
                                                        </div>	 
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>      
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.CITY_OF_BIRTH }}</span> </div>
                                                        <div class="col-sm-8"> 	
                                                        <input ng-model="spouse.birth_city" type="text" class="form-control" name='spouse_birth_city_{{spouse.id}}'>				
                                                        </div> 
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.COUNTRY_OF_BIRTH }}</span> </div>
                                                        <div class="col-sm-8"> 	
                                                            <select name="spouse_birth_country_code_{{spouse.id}}" 
                                                            	id="spouse_birth_country_code_{{spouse.id}}" 
	                                                            ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
    	                                                        ng-model="editFdCtrl.spouses[spouse.id].birth_country"
        	                                                    class="form-control"
            	                                                required-select>
                                                            	<option value=''>{{ editFdCtrl.str.PLEASE_SELECT }}</option>               
                                                            </select> 
                                                        </div>
                                                         
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div> 
                                                        	
                                                        <div class="col-sm-12">
                                                            <label>{{ editFdCtrl.str.CONTACT_IN_ORIGIN_CTRY }}</label> 
                                                            <span class="label label-primary"></span>
                                                        </div> 
                                                
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.IDEM_NS }}</span></div>
                                                        <div class="col-sm-8">
                                                            <label class="radio-inline"><input ng-model="spouse.cco_same" type="radio" value="Y" name="spouse_cco_same_{{spouse.id}}">Yes</label>
						               						<label class="radio-inline"><input ng-model="spouse.cco_same" type="radio" value="N" name="spouse_cco_same_{{spouse.id}}">No</label>				
                                                        </div>  
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.ADDRESS }}</span><br/></div>                                
                                                        <div class="col-sm-8"> 
                                                            <textarea ng-model="spouse.cco_address" class="form-control" name='spouse_cco_address_{{spouse.id}}' rows="3" maxlength='500'></textarea>  
                                                        </div>								
                                                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.CITY }}</span></div>
                                                        <div class="col-sm-8">
                                                            <input ng-model="spouse.cco_city" type="text" class="form-control" name='spouse_cco_city_{{spouse.id}}'>					
                                                        </div>		 
                                                
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.POSTAL_CODE }}</span></div>
                                                        <div class="col-sm-8">
                                                            <input type="text" ng-model="spouse.cco_postal_code" class="form-control"  name='spouse_cco_postal_code_{{spouse.id}}' style="width:100px">					
                                                        </div>	
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.COUNTRY }}</span></div>
                                                        <div class="col-sm-8">                                                             
                                                            <select name="spouse_cco_country_code_{{spouse.id}}" 
                                                            	id="spouse_cco_country_code_{{spouse.id}}" 
	                                                            ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
    	                                                        ng-model="editFdCtrl.spouses[spouse.id].cco_country"
        	                                                    class="form-control"
            	                                                required-select>
                                                            	<option value=''>{{ editFdCtrl.str.PLEASE_SELECT }}</option>               
                                                            </select>                                                             	
                                                        </div>	
                                        
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.MS_EFFECTIVE_FROM }}</span></div>
                                                        <div class="col-sm-8">                                         
                                                            <input ng-model="spouse.cco_since" type="text" class="form-control" name='spouse_cco_since_{{spouse.id}}' placeholder="dd/mm/yyyy">
                                                        </div>        
                                                    </div>
                                            
                                                    <!--- B. CENTER COLUMNN --->
                                                    <div class="col-sm-4"> 
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.ORGANISATION }}</span> </div>
                                                        <div class="col-sm-8">
	                                                         <input type="text" ng-model="spouse.employer" class="form-control"  name='spouse_employer_{{spouse.id}}'>					
                                                        </div>	
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.CITIZENSHIP }}</span> </div>
                                                        <div class="col-sm-8">                                                        
                                                            <select name="spouse_citizenship_1_country_code_{{spouse.id}}" 
                                                                id="spouse_citizenship_1_country_code_{{spouse.id}}" 
                                                                ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                                                ng-model="editFdCtrl.spouses[spouse.id].citizenship_1_country"
                                                                class="form-control"
                                                                required-select>
                                                            	<option value=''>{{ editFdCtrl.str.PLEASE_SELECT }}</option>               
                                                            </select>                                                                                                                 
                                                        </div>	
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.CITIZENSHIP }} 2</span> </div>
                                                        <div class="col-sm-8">                                                        
                                                            <select name="spouse_citizenship_2_country_code_{{spouse.id}}" 
                                                                id="spouse_citizenship_2_country_code_{{spouse.id}}" 
                                                                ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                                                ng-model="editFdCtrl.spouses[spouse.id].citizenship_2_country"
                                                                class="form-control">
                                                            	<option value=''>{{ editFdCtrl.str.PLEASE_SELECT }}</option>               
                                                            </select>   
                                                        </div>  
                                                 
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div> 
                                                    
                                                        <div class="col-sm-12"><label>{{ editFdCtrl.str.CONTACT_IN_RES_CTRY }}</label></div> 
                                                
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.IDEM_NS }}</span></div>
                                                        <div class="col-sm-8">
                                                            <label class="radio-inline"><input ng-model="spouse.crc_same" type="radio" value="Y" name="spouse_crc_same_{{spouse.id}}">{{ editFdCtrl.str.YES }}</label>
						               						<label class="radio-inline"><input ng-model="spouse.crc_same" type="radio" value="N" name="spouse_crc_same_{{spouse.id}}">{{ editFdCtrl.str.NO }}</label>					
                                                        </div>
                                                                                         
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-4 text-right">
                                                        <span class="label label-primary">{{ editFdCtrl.str.ADDRESS }}</span><br/></div>
                                                        <div class="col-sm-8"> 
                                                           <textarea ng-model="spouse.crc_address" class="form-control" name='spouse_crc_address_{{spouse.id}}' rows="3" maxlength='500'></textarea>   
                                                        </div>								
                                                
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.CITY }}</span> </div>
                                                        <div class="col-sm-8">
                                                             <input ng-model="spouse.crc_city" type="text" class="form-control" name='spouse_crc_city_{{spouse.id}}'>					
                                                        </div>		 
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.POSTAL_CODE }}</span> </div>
                                                        <div class="col-sm-8">
                                                           <input ng-model="spouse.crc_postal_code" type="text" class="form-control" name='spouse_crc_postal_code_{{spouse.id}}'>
                                                        </div>	
                                                
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.COUNTRY }}</span> </div>
                                                        <div class="col-sm-8">                                                             
                                                            <select name="spouse_crc_country_code_{{spouse.id}}" 
                                                                id="spouse_crc_country_code_{{spouse.id}}" 
                                                                ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                                                ng-model="editFdCtrl.spouses[spouse.id].crc_country"
                                                                class="form-control"
                                                                required-select>
                                                            <option value=''>{{ editFdCtrl.str.PLEASE_SELECT }}</option>               
                                                            </select>  		
                                                        </div>
                                                         <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.MS_EFFECTIVE_FROM }}</span> </div>
                                                        <div class="col-sm-8"> 
                                                            <input ng-model="spouse.crc_since" type="text" class="form-control" name='spouse_crc_since_{{spouse.id}}' placeholder="dd/mm/yyyy">
                                                        </div>
                                                    </div>
                                    
                                                    <!--- C. RIGHT COLUMNN--->
                                                    <div class="col-sm-4"> 
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.PROF_ANNUAL_INCOME }}</span></div>
                                                        <div class="col-sm-8">
                                                            <input type="text" ng-model="spouse.annual_income" class="form-control"  name='spouse_annual_income_{{spouse.id}}'> 
                                                        </div>	
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>                                
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.CURRENCY }}</span></div>
                                                        <div class="col-sm-8">  
                                                             <input type="text" ng-model="spouse.income_currency" class="form-control"  name='spouse_income_currency_{{spouse.id}}'> 				
                                                        </div>
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.DATE_OF_DEATH }}</span></div>
                                                        <div class="col-sm-8">                                            
                                                            <input type="text" ng-model="spouse.death_date" class="form-control" name='spouse_death_date_{{spouse.id}}' placeholder="dd/mm/yyyy"> 
                                                        </div>
                                                          
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                        
                                                        <div class="col-sm-12 sep">&##160;</div> 
                                            
                                                        <div class="col-sm-12"><label>{{ editFdCtrl.str.PRIVATE_CONTACT }}</label></div>  
                                                          
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.PRIVATE_PHONE_NBR }}</span> </div>
                                                        <div class="col-sm-8">
                                                           <input type="text" ng-model="spouse.phone_nbr" class="form-control" name='spouse_phone_nbr_{{spouse.id}}'> 					
                                                        </div>									
                                            
                                                        <div class="col-sm-12 sep">&##160;</div>							 
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.PRIVATE_MOBILE_NBR }}</span> </div>
                                                        <div class="col-sm-8">
                                                            <input type="text" ng-model="spouse.mobile_nbr" class="form-control" name='spouse_mobile_nbr_{{spouse.id}}'>					
                                                        </div>		
                                                    
                                                        <div class="col-sm-12 sep">&##160;</div>							 
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.OTHER_PHONE_NBR }}</span> </div>
                                                        <div class="col-sm-8">
                                                            <input type="text" ng-model="spouse.other_phone_nbr" class="form-control" name='spouse_other_phone_nbr_{{spouse.id}}'>					
                                                        </div>									
                                                        
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                        <div class="col-sm-12 sep">&##160;</div>
                                                                                    
                                                        <div class="col-sm-12 sep">&##160;</div>							 
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.PRIVATE_EMAIL }}</span> </div>
                                                        <div class="col-sm-8">
                                                           <input type="text" ng-model="spouse.email_1" class="form-control" name='spouse_email_1_{{spouse.id}}'>				
                                                        </div>
                                                
                                                        <div class="col-sm-12 sep">&##160;</div>							
                                                        <div class="col-sm-4 text-right"><span class="label label-primary">{{ editFdCtrl.str.PRIVATE_EMAIL }} 2</span> </div>
                                                        <div class="col-sm-8">
                                                           <input type="text" ng-model="spouse.email_2" class="form-control" name='spouse_email_2_{{spouse.id}}'>					
                                                        </div>	
                                                    </div>                                                 
                                                    </td>
                                                </tr>                               	
                                    
                                        	</table>                         
										</div>                
                               		</td>                
                            	</tr> <!---end econdary row--->
                
							</table>  
						</td>
					</tr>
                    
				</table>

			</div>	<!---end col-sm-12--->                  

<!--- B. CHILDREN ---> 

            <div class="col-sm-12" ng-show="editFdCtrl.children_count">   
                        
                <table width="100%" id="childrenOuterTable">  	                  
                            
                    <tr ng-repeat="child in editFdCtrl.data.children track by child.id"> 
                        <td colspan="10">
                            <table width="100%">
                            
                                <tr class="padded-cells ten-cells">   <!---primary row--->         
                                    <td class="text-right">                                         
	                                   <span class="label label-primary" title="{{child.id}}">{{editFdCtrl.str[child.relation]}}</span>
                                       <input type="hidden" value="{{child.relation}}" name='child_relation_{{child.id}}'>
									</td>                                                                              
                                    <td>
                                        <input type="text" ng-model="child.surname" class="form-control" name='child_surname_{{child.id}}'>
                                    </td>
                                    <td>
                                       <input type="text" ng-model="child.name" class="form-control" name='child_name_{{child.id}}'>
                                    </td>
                                    <td> 
                                        <input type="text" ng-model="child.dob" class="form-control" placeholder="dd/mm/yyyy" name='child_dob_{{child.id}}'>  
                                    </td>
                                    <td>                                         
                                        <label class="radio-inline"><input ng-model="child.gender" type="radio" value="M" name="child_gender_{{child.id}}">M</label>
						               	<label class="radio-inline"><input ng-model="child.gender" type="radio" value="F" name="child_gender_{{child.id}}">F</label>
                                    </td>
                                    <td>                                        
                                        <label class="radio-inline"><input ng-model="child.is_dependent" type="radio" value="Y" name="child_is_dependent_{{child.id}}">{{ editFdCtrl.str.YES }}</label>
						               	<label class="radio-inline"><input ng-model="child.is_dependent" type="radio" value="N" name="child_is_dependent_{{child.id}}">{{ editFdCtrl.str.NO }}</label>
                                    </td>
                                    <td>
                                        <input ng-model="child.dependent_since" type="text" class="form-control" name='child_dependent_since_{{child.id}}' placeholder="dd/mm/yyyy">  
                                    </td>
                                    <td> 
										<label class="radio-inline"><input ng-model="child.is_expatriate" type="radio" value="Y" name="child_is_expatriate_{{child.id}}">{{ editFdCtrl.str.YES }}</label>
						               	<label class="radio-inline"><input ng-model="child.is_expatriate" type="radio" value="N" name="child_is_expatriate_{{child.id}}">{{ editFdCtrl.str.NO }}</label>
                                    </td>
                                    <td>
                                        <input ng-model="child.expatriate_since" type="text" class="form-control" name='child_expatriate_since_{{child.id}}' placeholder="dd/mm/yyyy">                 
                                    </td>
                                    <td>                 
                                        <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="##child_collapsible_zone_{{child.id}}">
                                            <span class="glyphicon glyphicon-collapse-down"></span>
                                        </button>  
                                        <button class="btn btn-primary" type="button" ng-click="editFdCtrl.removeRelative(child.id)" title='Remove relative'>
                                        	<span class="glyphicon glyphicon-remove"></span>
                                        </button>                                          
                                    </td>
                                </tr> <!---end primary row--->    
                                
                                                                                                
                                <tr> <!---secondary row--->
                                	<td colspan="10">
	                                     <div id="child_collapsible_zone_{{child.id}}" class="collapse">     
    	                                	<table width="100%" style="background-color:##f9f9f9;">                                            
                                            
                                            	<tr>
                                                	<td width="10%">&nbsp;</td>  
                                                    <td width="10%">
                                                    	<span class="label label-primary">{{editFdCtrl.str.CITIZENSHIP}}</span>                                                     
													</td>          
                                                    <td width="10%">
                                                    	<span class="label label-primary">{{editFdCtrl.str.CITIZENSHIP}} 2</span>
                                                    </td>            
                                                    <td width="10%">
                                                    	<span class="label label-primary">{{editFdCtrl.str.CHILD_SUPPORT}}</span>
                                                    </td>            
                                                    <td width="10%">
                                                    	<span class="label label-primary">{{editFdCtrl.str.PRIOR}}</span>
                                                    </td>
                                                    <td width="50%" colspan="5">&nbsp;</td>                                                                                                
												</tr>
                                                
                                    			<tr class="padded-cells">
                                                	<td>&nbsp;</td>  
                                                    <td>
                                                        <select name="child_citizenship_1_country_code_{{child.id}}" 
                                                            id="child_citizenship_1_country_code_{{child.id}}" 
                                                            ng-options="ctry.name for ctry in editFdCtrl.citizenships['LIB'] track by ctry.code"
                                                            ng-model="editFdCtrl.children[child.id].citizenship_1_country"
                                                            class="form-control"
                                                            required-select>
                                                        <option value=''>{{editFdCtrl.str.PLEASE_SELECT}}</option>               
                                                        </select>                                         
													</td>          
                                                    <td>
                                                        <select name="child_citizenship_2_country_code_{{child.id}}" 
                                                            id="child_citizenship_2_country_code_{{child.id}}" 
                                                            ng-options="ctry.name for ctry in editFdCtrl.citizenships['LIB'] track by ctry.code"
                                                            ng-model="editFdCtrl.children[child.id].citizenship_2_country"
                                                            class="form-control">
                                                            <option value=''>{{editFdCtrl.str.PLEASE_SELECT}}</option>               
                                                        </select> 
                                                    </td>            
                                                    <td>
                                                        <label class="radio-inline"><input ng-model="child.support_over_amount" type="radio" value="Y" name="child_support_over_amount_{{child.id}}">{{editFdCtrl.str.YES}}</label>
                                                        <label class="radio-inline"><input ng-model="child.support_over_amount" type="radio" value="N" name="child_support_over_amount_{{child.id}}">{{editFdCtrl.strS.NO}}</label>
                                                    </td>            
                                                    <td>
                                                        <label class="radio-inline"><input ng-model="child.assignment_period" type="radio" value="Y" name="child_assignment_period_{{child.id}}">{{editFdCtrl.str.YES}}</label>
                                                        <label class="radio-inline"><input ng-model="child.assignment_period" type="radio" value="N" name="child_assignment_period_{{child.id}}">{{editFdCtrl.str.NO}}</label>
                                                    </td>
                                                    <td colspan="5">&nbsp;</td>                                                                                                        
												</tr>                                                 
                                                
                           						<tr>
                                                	<td width="10%">&nbsp;</td>  
                                                    <td width="20%" colspan="2">
                                                    	<span class="label label-primary">{{editFdCtrl.str.SCHOOL_NAME}}</span>  
                                                    </td>            
                                                    <td width="20%" colspan="2">
                                                    	<span class="label label-primary">{{editFdCtrl.str.SCHOOL_ADDRESS}}</span>                                                  
                                                    </td>
                                   					<td width="20%" colspan="2">
                                                    	<span class="label label-primary">{{editFdCtrl.str.SCHOOL_CITY}}</span>                                                  
                                                    </td>  
                                   					<td width="10%">
                                                    	<span class="label label-primary">{{editFdCtrl.str.SCHOOL_COUNTRY}}</span>                                                  
                                                    </td>                                                                                                      
                                                    <td width="20%" colspan="2">&nbsp;<td>                                                                                                
												</tr>
                                                
                                    			<tr class="padded-cells">
                                           			<td width="10%">&nbsp;</td>  
                                                    <td width="20%" colspan="2">
                                                    	<input type="text" ng-model="child.school_name" class="form-control" name='child_school_name_{{child.id}}'> 
                                                    </td>            
                                                    <td width="20%" colspan="2">
                                                    	<input type="text" ng-model="child.school_address" class="form-control" name='child_school_address_{{child.id}}'>                                                  
                                                    </td>
                                   					<td width="20%" colspan="2">
                                                    	<input type="text" ng-model="child.school_city" class="form-control" name='child_school_city_{{child.id}}'>                                                    
                                                    </td>  
                                   					<td width="10%">
                                                        <select name="child_school_country_code_{{child.id}}" 
                                                            id="child_school_country_code_{{child.id}}" 
                                                            ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                                            ng-model="editFdCtrl.children[child.id].school_country"
                                                            class="form-control"
                                                            required-select>
                                                       		<option value=''>{{ editFdCtrl.str.PLEASE_SELECT }}</option>               
                                                        </select>                                                 
                                                    </td>                                                                                                      
                                                    <td width="20%" colspan="2">&nbsp;</td>                                                                                                
												</tr>                                                  
                                                
                                                <!---Allowance--->
												<tr>
                                                	<td width="10%">&nbsp;</td>  
                                                    <td width="30%" colspan="3">
                                                    	<span class="label label-primary">{{editFdCtrl.str.NATURE_OF_ALLOWANCE}}</span>  
                                                    </td>            
                                                    <td width="10%">
                                                    	<span class="label label-primary">{{editFdCtrl.str.AMOUNT_OF_ALLOWANCE}}</span>                                                  
                                                    </td>
                                   					<td width="40%" colspan="4">
                                                    	<span class="label label-primary">{{editFdCtrl.str.COMMENTS}}</span>                                                  
                                                    </td>                                                                                                
                                                    <td width="10%">&nbsp;</td>                                                                                                
												</tr>
                                                
                                    			<tr class="padded-cells">
                                           			<td width="10%" class="text-right"><span class="label label-primary">{{editFdCtrl.str.ALLOWANCE}}</span></td>  
                                                    <td width="30%" colspan="3">
                                                    	<input type="text" ng-model="child.ext_allow_nature" class="form-control" name='child_ext_allow_nature_{{child.id}}'> 
                                                    </td>            
                                                    <td width="10%">
                                                    	<input type="text" ng-model="child.ext_allow_amount" class="form-control" name='child_ext_allow_amount_{{child.id}}'>                                                  
                                                    </td>
                                   					<td width="40%" colspan="4">
                                                    	<input type="text" ng-model="child.ext_allow_comments" class="form-control" name='child_ext_allow_comments_{{child.id}}'>
                                                    </td>    
                                                     <td width="10%">&nbsp;</td>                                                                                  
												</tr>  
                                                
                                                <!---Scholarship--->
												<tr>
                                                	<td width="10%">&nbsp;</td>  
                                                    <td width="30%" colspan="3">
                                                    	<span class="label label-primary">{{editFdCtrl.str.NATURE_OF_SCHOLARSHIP}}</span>  
                                                    </td>            
                                                    <td width="10%">
                                                    	<span class="label label-primary">{{editFdCtrl.str.AMOUNT_OF_SCHOLARSHIP}}</span>                                                  
                                                    </td>
                                   					<td width="40%" colspan="4">
                                                    	<span class="label label-primary">{{editFdCtrl.str.COMMENTS}}</span>                                                  
                                                    </td>                                                                                                
                                                    <td width="10%">&nbsp;</td>                                                                                                
												</tr>
                                                
                                    			<tr class="padded-cells">
                                           			<td width="10%" class="text-right"><span class="label label-primary">{{editFdCtrl.str.SCHOLARSHIP}}</span></td>  
                                                    <td width="30%" colspan="3">
                                                    	<input type="text" ng-model="child.scholarship_nature" class="form-control" name='child_scholarship_nature_{{child.id}}'> 
                                                    </td>            
                                                    <td width="10%">
                                                    	<input type="text" ng-model="child.scholarship_amount" class="form-control" name='child_scholarship_amount_{{child.id}}'>
                                                    </td>
                                   					<td width="40%" colspan="4">
                                                    	<input type="text" ng-model="child.scholarship_comments" class="form-control" name='child_scholarship_comments_{{child.id}}'>
                                                    </td>
                                                     <td width="10%" >&nbsp;</td>                                                                                     
												</tr>                                                 
                                                                                        
                                            </table>
                                		</div>
                               		</td>     
                                </tr>  
                                                                
                            </table> 
                        </td>
                    </tr>   <!---end repeat--->                                       
                            
                </table>        
            </div> <!---end col-sm-12--->                  
            
<!--- C. OTHER RELATIVES ---> 

    		<div class="col-sm-12" ng-show="editFdCtrl.other_relatives_count">
     
        		<table width="100%" id="otherRelativesOuterTable">  
					
                    <tr ng-repeat="relative in editFdCtrl.data.other_relatives track by relative.id"> 
                        <td colspan="10">
                            <table width="100%">  
                            
                                <tr class="padded-cells ten-cells"> <!---primary row--->
                                    <td class="text-right">
                              			<span class="label label-primary" title="{{relative.id}}">{{editFdCtrl.str[relative.relation]}}</span>                                        
                                         <input type="hidden" value="{{relative.relation}}" name='relative_relation_{{relative.id}}'>
                                    </td>
                                    <td>
                                        <input type="text" ng-model="relative.surname" class="form-control" name='relative_surname_{{relative.id}}'>
                                    </td>
                                    <td>
                                        <input type="text" ng-model="relative.name" class="form-control" name='relative_name_{{relative.id}}'>
                                    </td>
                                    <td> 
                                        <div class="input-group">
                                            <input type="text" ng-model="relative.birthdate" class="form-control" placeholder="dd/mm/yyyy" name='relative_birthdate_{{relative.id}}'>
                                        </div>
                                    </td>
                                    <td> 
                                        <label class="radio-inline"><input ng-model="relative.gender" type="radio" value="M" name="relative_gender_{{relative.id}}">M</label>
						               	<label class="radio-inline"><input ng-model="relative.gender" type="radio" value="F" name="relative_gender_{{relative.id}}">F</label>
                                    </td>
                                    <td>                                        
                                        <label ng-model="relative.is_dependent" class="radio-inline"><input type="radio" value="Y" name="relative_is_dependent_{{relative.id}}">{{ editFdCtrl.str.YES }}</label>
						                <label ng-model="relative.is_dependent" class="radio-inline"><input type="radio" value="N" name="relative_is_dependent_{{relative.id}}">{{ editFdCtrl.str.NO }}</label>
                                    </td>
                                    <td>
                                        <input ng-model="relative.dependent_since" type="text" class="form-control" name='relative_dependent_since_{{relative_id}}' placeholder="dd/mm/yyyy">
                                    </td>
                                    <td>                                        
                                        <label class="radio-inline"><input ng-model="relative.is_expatriate" type="radio" value="Y" name="relative_is_expatriate_{{relative.id}}">{{ editFdCtrl.str.YES }}</label>
						                <label class="radio-inline"><input ng-model="relative.is_expatriate" type="radio" value="N" name="relative_is_expatriate_{{relative.id}}">{{ editFdCtrl.str.NO }}</label>
                                    </td>
                                    <td>
                                        <input ng-model="relative.expatriate_since" type="text" class="form-control" name='relative_expatriate_since_{{relative.id}}' placeholder="dd/mm/yyyy">                                    </td>
                                    <td>                             
                                    <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="##relative_collapsible_zone_{{relative.id}}">
                                        <span class="glyphicon glyphicon-collapse-down"></span>
                                    </button>  
                                    <button class="btn btn-primary" type="button" ng-click="editFdCtrl.removeRelative(relative.id)" title='Remove relative'>
                                        <span class="glyphicon glyphicon-remove"></span>
                                    </button>                                      
                                    </td>
                                </tr>   <!---end primary row--->
                                
								<tr>  <!---secondary row--->
                                    <td colspan="10" valign="top"> 
                                        <div id="relative_collapsible_zone_{{relative.id}}" class="collapse">                                    
                                            <table width="100%" border="0" class="table table-striped root-table" style="margin-top:5px">   
                                                                                                                     
                                                <tr height="40px">                                    
                                                    <td><span class="label label-primary">{{editFdCtrl.str.CITIZENSHIP}}</span></td> 
                                                    <td><span class="label label-primary">{{editFdCtrl.str.SND_CITIZENSHIP}}</span></td>
                                                    <td width='50%'>&nbsp;</td>                                   
                                                </tr>       
                                                
                                                <tr height="40px">
                                                    <td>                                                        
                                                        <select name="relative_citizenship_1_country_code_{{relative_id}}" 
                                                            id="relative_citizenship_1_country_code_{{relative_id}}" 
                                                            ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                                            ng-model="editFdCtrl.relatives[relative.id].citizenship_1_country"
                                                            class="form-control"
                                                            required-select>
                                                        	<option value=''>{{editFdCtrl.str.PLEASE_SELECT}}</option>               
                                                        </select> 
                                                    </td>              
                                                    <td>                                                        
                                                        <select name="relative_citizenship_2_country_code_{{relative_id}}" 
                                                            id="relative_citizenship_2_country_code_{{relative_id}}" 
                                                            ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                                            ng-model="editFdCtrl.relatives[relative.id].citizenship_2_country"
                                                            class="form-control"
                                                            required-select>
                                                        	<option value=''>{{editFdCtrl.str.PLEASE_SELECT}}</option>               
                                                        </select>                                                          
                                                    </td>
                                                    <td width='50%'>&nbsp;</td>                               
                                                </tr>  
                                                
											</table>  
										</div>  
									</td>   
								</tr>  <!---end secondary row--->                                                                       
                                  
                            </table>
                        </td>
                    </tr> 
                           
	            </table> 
			</div>  <!---end col-sm-12--->   
            
            <div class="col-sm-12" style="height:80px"></div>

		</div> <!---end row--->
	</div> <!---end container--->
</form> 

<nav class="navbar navbar-inverse navbar-fixed-bottom">
    <div class="container-fluid">
<!---    	<div class="navbar-header">
    		<a class="navbar-brand" href="##">WebSiteName</a>
    	</div>--->
        <ul class="nav navbar-nav">
            <li><a ng-click="gridCtrl.switchGridDetail()" class="pointer-cursor">Back to List</a></li>
            <li><a ng-click="editFdCtrl.nsmFdEditSubmit()" class="pointer-cursor">Submit</a></li>
        	<li><a ng-click="editFdCtrl.reload()" class="pointer-cursor">Reload</a></li>
            <!---<li><a ng-click="editFdCtrl.login()" class="pointer-cursor">Login</a></li>--->
             <li><a ng-click="editFdCtrl.changeLanguage()" class="pointer-cursor">Change Language</a></li> 
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="##">Add Relative
                <span class="caret"></span></a>
                <ul class="dropdown-menu">
                    <li><a ng-click="editFdCtrl.addRelative('SPOU', $event)">Spouse</a></li>
                    <li><a ng-click="editFdCtrl.addRelative('CHIL', $event)">Child</a></li>
                    <li><a ng-click="editFdCtrl.addRelative('FATH', $event)">Father</a></li>
                    <li><a ng-click="editFdCtrl.addRelative('MOTH', $event)">Mother</a></li> 
                </ul>
        	</li>
        </ul>
    </div>
</nav>

    
</div> <!---end controller---> 

</cfoutput>  