<script src="views/nsm/js/editFD2.js"></script>

<cfoutput>

<style type="text/css">

.vertical-align {
    display: flex;
    align-items: center;
}

.xpadded-divs div { 	
	padding-top:10px;
	padding-bottom:10px;
	padding-right:15px;	
}

.xpadded-subdivs div div { 	
	padding-top:10px;
	padding-bottom:10px;
	padding-right:15px;	
}

</style>

<div ng-controller="nsmEditFd2Controller as editFd2Ctrl" ng-cloak>
<form name="nsmFd2EditForm" id="nsmFdEditForm" novalidate>   
<input type="hidden" name="staff_member_id" id="staff_member_id" value="{{editFd2Ctrl.fd.staff_member_id}}" />

	<div class="container-fluid"> 
    
	    <!--- HEADER ---> 
		<div class="row"> 
            
            <div class="col-sm-12">
                Relatives
            </div>     
            
            <div ng-show="editFd2Ctrl.all_relatives_count" style="margin-bottom:60px">
                <div class="col-sm-1">&nbsp;</div>
                <div class="col-sm-2"><span class="label label-info">Last Name</span></div>
                <div class="col-sm-2"><span class="label label-info">First Names(s)</span></div>
                <div class="col-sm-1"><span class="label label-info">Date of birth</span></div>
                <div class="col-sm-1"><span class="label label-info">Gender</span></div>                    
                <div class="col-sm-1"><span class="label label-info">Dependent</span></div>
                <div class="col-sm-1"><span class="label label-info">Since</span></div>
                <div class="col-sm-1"><span class="label label-info">Expatriate</span></div>
                <div class="col-sm-1"><span class="label label-info">Since</span></div>
                <div class="col-sm-1">&nbsp;</div>                    
            </div>    
            
            <div ng-hide="editFd2Ctrl.all_relatives_count" class="col-sm-12">
                No relatives
            </div>  
            
		</div> <!---end row--->  
        
        <div ng-repeat="spouse in editFd2Ctrl.fd.spouses track by spouse.id">
            <div class="row vertical-align">             
                <div class="col-sm-1 text-right">
                    <span class="label label-info">{{editFd2Ctrl.strings.JS[spouse.relation]}}</span>
                    <input type="hidden" value="{{spouse.relation}}" name='spouse_relation_{{spouse.id}}'>
                </div>
                <div class="col-sm-2">
                    <input ng-model="spouse.surname" type="text" class="form-control" name='spouse_surname_{{spouse.id}}'>
                </div>                
                <div class="col-sm-2">
                    <input ng-model="spouse.name" type="text" class="form-control" name='spouse_name_{{spouse.id}}'>
                </div>                
                <div class="col-sm-1">                    
                    <input type="text" ng-model="spouse.dob" class="form-control" placeholder="dd/mm/yyyy" name='spouse_dob_{{spouse.id}}'> 
                </div>                
                <div class="col-sm-1"> 
                    <label class="radio-inline"><input ng-model="spouse.gender" type="radio" value="M" name="spouse_gender_{{spouse.id}}">M</label>
                    <label class="radio-inline"><input ng-model="spouse.gender" type="radio" value="F" name="spouse_gender_{{spouse.id}}">F</label>
                </div>                
                <div class="col-sm-1">                                        
                    <label class="radio-inline"><input ng-model="spouse.is_dependent" type="radio" value="Y" name="spouse_is_dependent_{{spouse.id}}">Yes</label>
                    <label class="radio-inline"><input ng-model="spouse.is_dependent" type="radio" value="N" name="spouse_is_dependent_{{spouse.id}}">No</label>
                </div>                
                <div class="col-sm-1">
                    <input ng-model="spouse.dependent_since" type="text" class="form-control" name='spouse_dependent_since_{{spouse.id}}' placeholder="dd/mm/yyyy">  
                </div>                
                <div class="col-sm-1">
                    <label class="radio-inline"><input ng-model="spouse.is_expatriate" type="radio" value="Y" name="spouse_is_expatriate_{{spouse.id}}">Yes</label>
                    <label class="radio-inline"><input ng-model="spouse.is_expatriate" type="radio" value="N" name="spouse_is_expatriate_{{spouse.id}}">No</label>
                </div>                
                <div class="col-sm-1">
                    <input ng-model="spouse.expatriate_since" type="text" class="form-control" name='spouse_expatriate_since_{{spouse.id}}' placeholder="dd/mm/yyyy">
                </div>                
                <div class="col-sm-1"> 
                    <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="##spouse_collapsible_panel_{{spouse.id}}" title='Toggle Details Table'>
                        <span class="glyphicon glyphicon-collapse-down"></span>
                    </button> 
                </div> 
            </div>  
            
            <div class="row" style="background-color:xpink">
	            <div class="collapse col-sm-12" id="spouse_collapsible_panel_{{spouse.id}}" style="background-color:xpink">	
    
					<!--- A. LEFT COLUMNN --->
                    
					<div class="col-sm-4 padded-subdivs" style="background-color:xgrey"> 
                    	<div class="form-group vertical-align">
	                        <div class="col-sm-4 text-right">Occupation</div>
    	                    <div class="col-sm-8"> 	 
        		                <input ng-model="spouse.occupation" type="text" class="form-control" name='spouse_occupation_{{spouse.id}}'>				 				
                	        </div>	 
						</div>   
                           
                        <div class="form-group vertical-align"> 
                            <div class="col-sm-4 text-right"><span class="label label-info">City of birth</span></div>
                            <div class="col-sm-8"> 	
                            	<input ng-model="spouse.birth_city" type="text" class="form-control" name='spouse_birth_city_{{spouse.id}}'>				
                            </div> 
                        </div>                        
                       
						<div class="form-group vertical-align">
                        	<div class="col-sm-4 text-right"><span class="label label-info">Country of birth</span></div>
	                        <div class="col-sm-8"> 	
                                <select name="spouse_birth_country_code_{{spouse.id}}" 
                                    id="spouse_birth_country_code_{{spouse.id}}" 
                                    ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                    ng-model="editFdCtrl.spouses[spouse.id].birth_country"
                                    class="form-control"
                                    required-select>
                                    <option value=''>Please Select</option>               
                                </select> 
							</div>                                
                        </div>
                         
  <!---                      <div class="col-sm-12 sep">&##160;</div>
                        <div class="col-sm-12 sep">&##160;</div>
                        <div class="col-sm-12 sep">&##160;</div>
                        <div class="col-sm-12 sep">&##160;</div> --->                            
                            
       <!---                 <div class="col-sm-12">
                            <label>Contact in country of origin (CCO)</label>                             
                        </div> --->
                
                       	<div class="form-group">						
                            <div class="col-sm-4 text-right"><span class="label label-info">Idem NS</span></div>
                            <div class="col-sm-8">
                                <label class="radio-inline"><input ng-model="spouse.cco_same" type="radio" value="Y" name="spouse_cco_same_{{spouse.id}}">Yes</label>
                                <label class="radio-inline"><input ng-model="spouse.cco_same" type="radio" value="N" name="spouse_cco_same_{{spouse.id}}">No</label>				
                            </div>  
						</div>                            
                        
                       	<div class="form-group vertical-align">	
                            <div class="col-sm-4 text-right"><span class="label label-info">Address</span></div>                                
                            <div class="col-sm-8"> 
                                <textarea ng-model="spouse.cco_address" class="form-control" name='spouse_cco_address_{{spouse.id}}' rows="3" maxlength='500'></textarea>  
                            </div>	
						</div>                        							
                                                        
                       	<div class="form-group vertical-align">							
                            <div class="col-sm-4 text-right"><span class="label label-info">City</span></div>
                            <div class="col-sm-8">
                                <input ng-model="spouse.cco_city" type="text" class="form-control" name='spouse_cco_city_{{spouse.id}}'>					
                            </div>		
						</div>   
                                                 
						<div class="form-group vertical-align">							
                            <div class="col-sm-4 text-right"><span class="label label-info">Postal code</span></div>
                            <div class="col-sm-8">
                                <input type="text" ng-model="spouse.cco_postal_code" class="form-control"  name='spouse_cco_postal_code_{{spouse.id}}' style="width:100px">					
                            </div>	
                        </div>
                        
                        <div class="form-group vertical-align">							
                            <div class="col-sm-4 text-right"><span class="label label-info">Country</span></div>
                            <div class="col-sm-8">                                                             
                                <select name="spouse_cco_country_code_{{spouse.id}}" 
                                    id="spouse_cco_country_code_{{spouse.id}}" 
                                    ng-options="ctry.name for ctry in editFdCtrl.countries['LIB'] track by ctry.code"
                                    ng-model="editFdCtrl.spouses[spouse.id].cco_country"
                                    class="form-control"
                                    required-select>
                                    <option value=''>Please Select</option>               
                                </select>                                                             	
                            </div>
                        </div>
        
                        <div class="form-group vertical-align">								
                            <div class="col-sm-4 text-right"><span class="label label-info">Effect date</span></div>
                            <div class="col-sm-8">                                         
                                <input ng-model="spouse.cco_since" type="text" class="form-control" name='spouse_cco_since_{{spouse.id}}' placeholder="dd/mm/yyyy">
                            </div>     
                        </div> 
                          
                    </div>   <!---end left column--->                                
                    
				</div>   <!---end single outer column--->  
                               
            </div> <!---end row--->
            
     
                    
        </div> <!---end repeat row--->         
        
        
        
        
        
        
        
        
	</div> <!---end container--->

</form>
</div>
</cfoutput>
