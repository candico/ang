<script src="views/fom/js/edit.js"></script>

<!---<style type="text/css">

.label-div{	
	text-align:right;
	padding:12px;	
}

.item-div{	
	padding:12px;
}

.section-well{
	border-color:darkgrey;
	margin-bottom:6px;		
}

.edit-controller .label-primary{
	color:black;
	background-color:white;
	border:1px #428bca solid;
}

.edit-controller .label-warning{
	color:black;
	background-color:white;
	border:1px #f0ad4e solid;
}

/* reduces gutter between columns */
.small-gutter > [class*='col-'] {
    padding-right:3px;
    padding-left:3px;
}

.alt-data{
	font-style:italic;	
	color:blue;
}

input.ng-invalid, select.ng-invalid, input.ng-invalid-required, select.ng-invalid-required{
	border-left: 5px solid #E03930;	
}

input.ng-valid, select.ng-valid, input.ng-valid-required, select.ng-valid-required{
	border-left: 5px solid #57A83F;	
}

.errors{
	color: #E03930;	
}

/* prevents empty div from collapsing */
span:empty:before {content: '\a0';}
 
</style>--->

<style type="text/css">

.label-div{	
	text-align:right;	
	padding:6px;	
}

.item-div{			
	padding:6px;	
}

.fieldset-panel{
	background-color:#f5f5f5;
}

.alt-data{
	font-style:italic;	
	color:blue;
}

.edit-controller .label-primary{
	color:black;
	background-color:white;
	border:1px #428bca solid;
}

.edit-controller .label-warning{
	color:black;
	background-color:white;
	border:1px #f0ad4e solid;
}

.form-control-div{
	padding-left:6px;	
}

.control-label{
	padding-right:6px;	
}

.errors{
	color: #E03930;	
}

</style>

<cfoutput>
            
<div ng-controller="fieldOfficeEditController as foeCtrl" class="edit-controller">  

<form name="foeCtrl.fieldOfficeEditForm" id="fieldOfficeEditForm" class="form-horizontal" novalidate>

<div class="panel">

<div class="panel-body">
                        
    <div class="row">

        <div class="col-sm-6">
        
        	<div class="panel panel-default fieldset-panel">
            
                <div class="panel-body">
                
                    <fieldset>                
                        <legend class="scheduler-border">{{ foeCtrl.lib.ADDRESS }}</legend>
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.ADDRESS_LINE }} 1 *</span></label>                         
                            <div class="col-sm-6 form-control-div"> 
                                <input type="text" name="address_line_1" ng-model="foeCtrl.data.address_line_1" class="form-control form-control" required/>
                                <p ng-if="foeCtrl.data.alt.address_line_1" class="help-block alt-data">{{ foeCtrl.data.alt.address_line_1 }}</p>   
                                <div ng-messages="fieldOfficeEditForm.address_line_1.$touched && fieldOfficeEditForm.address_line_1.$error" class="errors"> 
                                    <span ng-if="foeCtrl.showError({'address_line_1':'required'})" ng-message="required">{{ foeCtrl.lib.ADDRESS_LINE_REQUIRED }}</span>  
                                </div> 
                            </div> 
                        </div>      
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.ADDRESS_LINE }} 2 *</span></label> 
                            <div class="col-sm-6 form-control-div">    	                                          
                                <input type="text" name="address_line_2" ng-model="foeCtrl.data.address_line_2" class="form-control form-control" required/>
                                <p ng-if="foeCtrl.data.alt.address_line_2" class="help-block alt-data">{{ foeCtrl.data.alt.address_line_2 }}</p> 
                                <div ng-messages="fieldOfficeEditForm.address_line_2.$touched && fieldOfficeEditForm.address_line_2.$error" class="errors"> 
                                    <span ng-if="foeCtrl.showError({'address_line_2':'required'})" ng-message="required">{{ foeCtrl.lib.ADDRESS_LINE_REQUIRED }}</span>  
                                </div> 
                            </div> 
                        </div>          
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.POSTAL_CODE }} *</span></label> 
                            <div class="col-sm-6 form-control-div">  	                                           
                                <input type="text" name="postal_code" ng-model="foeCtrl.data.postal_code" class="form-control form-control" required/>
                                <p ng-if="foeCtrl.data.alt.postal_code" class="help-block alt-data">{{ foeCtrl.data.alt.postal_code }}</p>  
                                <div ng-messages="fieldOfficeEditForm.postal_code.$touched && fieldOfficeEditForm.postal_code.$error" class="errors"> 
                                    <span ng-if="foeCtrl.showError({'postal_code':'required'})" ng-message="required">{{ foeCtrl.lib.POSTAL_CODE_REQUIRED }}</span>  
                                </div> 
                            </div> 
                        </div>  
                        
                    </fieldset>
                
                </div> <!---end panel body--->
    
            </div> <!---end panel --->
                
        	<div class="panel panel-default fieldset-panel">
            
                <div class="panel-body">
                
                    <fieldset>                    
                        <legend class="scheduler-border">{{ foeCtrl.lib.TELEPHONY }}</legend>   
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.PHONE_NUMBER }} *</span></label> 
                            <div class="col-sm-6 form-control-div"> 								                                                
                                <input type="text" name="phone_number" ng-model="foeCtrl.data.phone_number" class="form-control form-control" required/>
                                <p ng-if="foeCtrl.data.alt.phone_number" class="help-block alt-data">{{ foeCtrl.data.alt.phone_number }}</p>  
                                <div ng-messages="fieldOfficeEditForm.phone_number.$touched && fieldOfficeEditForm.phone_number.$error" class="errors"> 
                                    <span ng-if="foeCtrl.showError({'phone_number':'required'})" ng-message="required">{{ foeCtrl.lib.PHONE_NUMBER_REQUIRED }}</span>  
                                </div> 
                            </div> 
                        </div>         
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-primary">{{ foeCtrl.lib.FAX_NUMBER }}</span></label> 
                            <div class="col-sm-6 form-control-div">  
                                <input type="text" name="fax_number" ng-model="foeCtrl.data.fax_number" class="form-control form-control"/>     
                                <p ng-if="foeCtrl.data.alt.fax_number" class="help-block alt-data">{{ foeCtrl.data.alt.fax_number }}</p>                           
                            </div> 
                        </div>     
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-primary">{{ foeCtrl.lib.MOBILE_NUMBER }}</span></label> 
                            <div class="col-sm-6 form-control-div"> 	                                                 
                                <input type="text" name="mobile_number" ng-model="foeCtrl.data.mobile_number" class="form-control form-control"/>  
                                 <p ng-if="foeCtrl.data.alt.mobile_number" class="help-block alt-data">{{ foeCtrl.data.alt.mobile_number }}</p>                            
                            </div> 
                        </div>     
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-primary">{{ foeCtrl.lib.SATELLITE_NUMBER }}</span></label> 
                            <div class="col-sm-6 form-control-div"> 	                                                  
                                <input type="text" name="satellite_number" ng-model="foeCtrl.data.satellite_number" class="form-control form-control"/>      
                                <p ng-if="foeCtrl.data.alt.satellite_number" class="help-block alt-data">{{ foeCtrl.data.alt.satellite_number }}</p>                         
                            </div> 
                        </div>         
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-primary">{{ foeCtrl.lib.IRIDIUM_NUMBER }}</span></label> 
                            <div class="col-sm-6 form-control-div">   
                                <input type="text" name="iridium_number" ng-model="foeCtrl.data.iridium_number" class="form-control form-control"/>  
                                 <p ng-if="foeCtrl.data.alt.iridium_number" class="help-block alt-data">{{ foeCtrl.data.alt.iridium_number }}</p>                                
                            </div> 
                        </div>     
                        
                    </fieldset>                    
        
                </div> <!---end panel body--->
    
            </div> <!---end panel --->            
          
            
		</div> <!---end col--->
                    
        <div class="col-sm-6">
        
            <div class="panel panel-default fieldset-panel">
            
                <div class="panel-body">
                 
                    <fieldset>                    
                        <legend class="scheduler-border">{{ foeCtrl.lib.EMAIL_ADDRESSES }}</legend>             
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.OFFICIAL_EMAIL }} *</span></label> 
                            <div class="col-sm-6 form-control-div"> 
                                <input type="email" name="official_email" ng-model="foeCtrl.data.official_email" class="form-control form-control" required/>  
                                <p ng-if="foeCtrl.data.alt.official_email" class="help-block alt-data">{{ foeCtrl.data.alt.official_email }}</p> 
                                <div ng-messages="fieldOfficeEditForm.official_email.$touched && fieldOfficeEditForm.official_email.$error" class="errors"> 
                                    <span ng-if="foeCtrl.showError({'official_email':'required'})" ng-message="required">{{ foeCtrl.lib.EMAIL_REQUIRED }}</span> 
                                    <span ng-if="foeCtrl.showError({'official_email':'email'})" ng-message="email">{{ foeCtrl.lib.INVALID_EMAIL }}</span>  
                                </div>                                                             
                            </div> 
                        </div>  
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-primary">{{ foeCtrl.lib.ADMIN_EMAIL }}</span></label> 
                            <div class="col-sm-6 form-control-div">   	                                               
                                <input type="email" name="admin_email" ng-model="foeCtrl.data.admin_email" class="form-control form-control"/>                                 
                                <p ng-if="foeCtrl.data.alt.admin_email" class="help-block alt-data">{{ foeCtrl.data.alt.admin_email }}</p> 
                                <div ng-messages="fieldOfficeEditForm.admin_email.$touched && fieldOfficeEditForm.admin_email.$error" class="errors">                                     
                                    <span ng-if="foeCtrl.showError({'admin_email':'email'})" ng-message="email">{{ foeCtrl.lib.INVALID_EMAIL }}</span>  
                                </div>                                                             
                            </div> 
                        </div>        
                            
                            <div class="form-group">	           
                                <label class="col-sm-3 control-label"><span class="label label-primary">{{ foeCtrl.lib.FAVORITE_EMAIL }}</span></label> 
                                <div class="col-sm-6 form-control-div"> 
                                    <input type="email" name="favorite_email" ng-model="foeCtrl.data.favorite_email" class="form-control form-control"/> 
                                    <p ng-if="foeCtrl.data.alt.favorite_email" class="help-block alt-data">{{ foeCtrl.data.alt.favorite_email }}</p>  
                                    <div ng-messages="fieldOfficeEditForm.favorite_email.$touched && fieldOfficeEditForm.favorite_email.$error" class="errors">                                     
                                        <span ng-if="foeCtrl.showError({'favorite_email':'email'})" ng-message="email">{{ foeCtrl.lib.INVALID_EMAIL }}</span>  
                                    </div>                                                             
                                </div> 
                            </div>          
                            
                            <div class="form-group">	           
                                <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.PUBLIC_EMAIL }} *</span></label> 
                                <div class="col-sm-6 form-control-div">  
                                    <select ng-model="foeCtrl.data.emtu_code" class="form-control" name='emtu_code' id="emtu_code" required>
                                        <option value=''>{{ foeCtrl.lib.PLEASE_SELECT }}</option> 
                                        <option value="OFFICIAL_EMAIL">{{ foeCtrl.lib.OFFICIAL_EMAIL }}</option>
                                        <option value="ADMIN_EMAIL">{{ foeCtrl.lib.ADMIN_EMAIL }}</option>
                                        <option value="FAVORITE_EMAIL">{{ foeCtrl.lib.FAVORITE_EMAIL }}</option>
                                    </select>	 
                                    <p ng-if="foeCtrl.data.alt.emtu_label" class="help-block alt-data">{{ foeCtrl.lib[foeCtrl.data.alt.emtu_code] }}</p>  
                                    <div ng-messages="fieldOfficeEditForm.emtu_code.$touched && fieldOfficeEditForm.emtu_code.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'emtu_code':'required'})" ng-message="required">{{ foeCtrl.lib.EMAIL_REQUIRED }}</span>  
                                    </div>                                                                               
                                </div> 
                            </div>                                
                        
                        </fieldset>
                        
                    </div> <!---end panel body--->
    
            </div> <!---end panel --->  
        
        	<div class="panel panel-default fieldset-panel">
            
                <div class="panel-body">
                
                    <fieldset>                    
                        <legend class="scheduler-border">{{ foeCtrl.lib.MISCELLANEOUS }}</legend>          
                        
<!---                      <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.BUSINESS_HOURS }} MO</span></label>                             
                            <div class="col-sm-6 form-control-div">  								           
                                <input type="text" name="office_hours_mo" ng-model="foeCtrl.data.office_hours_mo" class="form-control form-control" required/>  
                                <p ng-if="foeCtrl.data.alt.office_hours_mo" class="help-block alt-data">{{ foeCtrl.data.alt.office_hours_mo }}</p>
                                <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                    <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                </div>                                 
                            </div>                             
                        </div> --->
                        
                        <div ng-repeat="day in foeCtrl.data.businessHours track by day.id" class="form-group"> 
                        
	                        <label class="col-sm-3 control-label">
                            	<span class="label label-warning">{{ foeCtrl.lib.BUSINESS_HOURS }} {{ day.day }} AM</span>
							</label> 
                            <div class="form-group">	
                               
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.am_opening_hour" class="form-control" name='am_opening_hour_{{ day.id}}' id='am_opening_hour_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>                                       
                                        <option value="8">8</option>
                                        <option value="9">9</option>
                                        <option value="10">10</option>
                                        <option value="11">11</option>
                                        <option value="12">Noon</option>
                                    </select> 
                                    <p ng-if="foeCtrl.hasAltHour('am_opening_hour', day.id)" class="help-block alt-data">
                                    	{{ foeCtrl.getAltHour("am_opening_hour", day.id) }}
                                    </p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div>  
                                    
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.am_opening_minute" class="form-control" name='am_opening_minute_{{ day.id}}' id='am_opening_minute_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>
                                        <option value="0">00</option>
                                        <option value="15">15</option>
                                        <option value="30">30</option>
                                        <option value="45">45</option>
                                    </select>  
                                    <p ng-if="foeCtrl.hasAltHour('am_opening_minute', day.id)" class="help-block alt-data">
                                    	{{ foeCtrl.getAltHour("am_opening_minute", day.id) }}
                                    </p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div> 
                                
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.am_closing_hour" class="form-control" name='am_closing_hour_{{ day.id}}' id='am_closing_hour_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>                                                                              
                                        <option value="8">8</option>
                                        <option value="9">9</option>
                                        <option value="10">10</option>
                                        <option value="11">11</option>
                                        <option value="12">Noon</option>
                                    </select> 
                                    <p ng-if="foeCtrl.data.alt.office_hours_mo" class="help-block alt-data">{{ foeCtrl.data.alt.office_hours_mo }}</p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div>  
                                    
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.am_closing_minute" class="form-control" name='am_closing_minute_{{ day.id}}' id='am_closing_minute_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>
                                        <option value="0">00</option>
                                        <option value="15">15</option>
                                        <option value="30">30</option>
                                        <option value="45">45</option>
                                    </select>  
                                    <p ng-if="foeCtrl.data.alt.office_hours_mo" class="help-block alt-data">{{ foeCtrl.data.alt.office_hours_mo }}</p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div>                                 
                                                                                   
                            </div>  
       	                     
        				     <label class="col-sm-3 control-label">
                            	<span class="label label-warning">{{ foeCtrl.lib.BUSINESS_HOURS }} {{ day.day }} PM</span>
							</label> 
                            <div class="form-group">	
                               
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.pm_opening_hour" class="form-control" name='pm_opening_hour_{{ day.id}}' id='pm_opening_hour_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>
                                        <option value="0">Noon</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                        <option value="6">6</option>                                      
                                    </select> 
                                    <p ng-if="foeCtrl.data.alt.office_hours_mo" class="help-block alt-data">{{ foeCtrl.data.alt.office_hours_mo }}</p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div>  
                                    
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.pm_opening_minute" class="form-control" name='pm_opening_minute_{{ day.id}}' id='pm_opening_minute_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>
                                        <option value="0">00</option>
                                        <option value="15">15</option>
                                        <option value="30">30</option>
                                        <option value="45">45</option>
                                    </select>  
                                    <p ng-if="foeCtrl.data.alt.office_hours_mo" class="help-block alt-data">{{ foeCtrl.data.alt.office_hours_mo }}</p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div> 
                                
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.pm_closing_hour" class="form-control" name='pm_closing_hour_{{ day.id}}' id='pm_closing_hour_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>
                                        <option value="0">Noon</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                        <option value="6">6</option>  
                                    </select> 
                                    <p ng-if="foeCtrl.data.alt.office_hours_mo" class="help-block alt-data">{{ foeCtrl.data.alt.office_hours_mo }}</p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div>  
                                    
                                <div class="col-sm-2 form-control-div">  								           
                                    <select ng-model="day.pm_closing_minute" class="form-control" name='pm_closing_minute_{{ day.id}}' id='pm_closing_minute_{{ day.id}}' convert-to-number>
                                        <option value="" selected="selected">--</option>
                                        <option value="0">00</option>
                                        <option value="15">15</option>
                                        <option value="30">30</option>
                                        <option value="45">45</option>
                                    </select>  
                                    <p ng-if="foeCtrl.data.alt.office_hours_mo" class="help-block alt-data">{{ foeCtrl.data.alt.office_hours_mo }}</p>
                                    <div ng-messages="fieldOfficeEditForm.office_hours_mo.$touched && fieldOfficeEditForm.office_hours_mo.$error" class="errors">                                    
                                        <span ng-if="foeCtrl.showError({'office_hours_mo':'required'})" ng-message="email">{{ foeCtrl.lib.BUSINESS_HOURS_REQUIRED }}</span>  
                                    </div>                                 
                                </div>                                 
                                                                                   
                            </div>  
                            
						</div>                           
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-primary">CET</span></label> 
                            <div class="col-sm-6 form-control-div"> 	                                                 
                                <input type="text" name="cet" ng-model="foeCtrl.data.cet" class="form-control form-control"/>
                                <p ng-if="foeCtrl.data.alt.cet" class="help-block alt-data">{{ foeCtrl.data.alt.cet }}</p>
                            </div> 
                        </div>      
                        
                        <div class="form-group">	           
                            <label class="col-sm-3 control-label"><span class="label label-warning">{{ foeCtrl.lib.WEEKEND_DAYS }} *</span></label> 
                            <div class="col-sm-6 form-control-div">	                                                 
                                <select ng-model="foeCtrl.data.wed_code" class="form-control" name='wed_code' id='wed_code' required>
                                    <option value=''>{{ foeCtrl.lib.PLEASE_SELECT }}</option> 
                                    <option value="THU_FRI">{{ foeCtrl.lib.THU_FRI }}</option>
                                    <option value="FRI_SAT">{{ foeCtrl.lib.FRI_SAT }}</option>
                                    <option value="SAT_SUN">{{ foeCtrl.lib.SAT_SUN }}</option>
                                </select> 
                                <p ng-if="foeCtrl.data.alt.wed_label" class="help-block alt-data">{{ foeCtrl.lib[foeCtrl.data.alt.wed_code] }}</p> 
                                <div ng-messages="fieldOfficeEditForm.wed_code.$touched && fieldOfficeEditForm.wed_code.$error" class="errors">                                    
                                    <span ng-if="foeCtrl.showError({'wed_code':'required'})" ng-message="required">{{ foeCtrl.lib.WED_REQUIRED }}</span>  
                                </div>                                  
                            </div> 
                        </div>                             
                    
                    </fieldset>
        
        		</div> <!---end panel body---> 
                
			</div> <!---end panel--->               
            
		</div>  <!---end col--->       
        
	</div> <!---end row--->  
    
        <ul>
          <li ng-repeat="(key, errors) in foeCtrl.fieldOfficeEditForm.$error track by $index"> <strong>{{ key }}</strong> errors
            <ul>
              <li ng-repeat="e in errors">{{ e.$name }} has an error: <strong>{{ key }}</strong>.</li>
            </ul>
          </li>
        </ul>     
        
    <nav class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">
            <button class="btn btn-primary navbar-btn" name='cancel' value="cancel" ng-click="foeCtrl.cancelEditFieldOffice()">{{ foeCtrl.lib.CANCEL }}</button>     
            <button class="btn btn-success navbar-btn" name='save' value="save" ng-click="foeCtrl.saveEditFieldOffice()" ng-disabled="fieldOfficeEditForm.$invalid">{{ foeCtrl.lib.SAVE }}</button>
            <ul class="nav navbar-nav navbar-right">  
                <li><a ng-click="foeCtrl.reload()" class="pointer-cursor">{{ foeCtrl.lib.RELOAD }}</a></li>                
            </ul>    
        </div>
    </nav>    
    
    
    
</div> <!---end panel body---> 

</div> <!---end panel--->      

</form>
    
</div> <!---end controller --->
	 		  
</cfoutput>
