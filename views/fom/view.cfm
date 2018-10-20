<script src="views/fom/js/view.js"></script>

<!---<style type="text/css">

.label-div{	
	text-align:right;	
	padding:6px;	
}

.item-div{			
	padding:6px;	
}

.section-well{
	border-color:darkgrey;
	margin-bottom:6px;		
}

.view-controller .label-primary{
	color:black;
	background-color:white;
	border:1px #428bca solid;
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

.view-controller .label-primary{
	color:black;
	background-color:white;
	border:1px #428bca solid;
}

/* prevents empty div from collapsing */
span:empty:before {content: '\a0';}

</style>

<cfoutput>
            
<div ng-controller="fieldOfficeViewController as fovCtrl" class="view-controller">   

<form name="fieldOfficeViewForm" id="fieldOfficeViewForm" class="form-horizontal" novalidate>

<div class="panel">

<div class="panel-body">
                        
    <div class="row">
        
        <div class="col-sm-6">
        
<cfif rc.chkViewEditStatus EQ "Y">  
          
        	<div class="panel panel-default fieldset-panel" style="border: 1px dashed blue">	    
                <div class="panel-body"> 
            
                    <fieldset>                
                        <legend class="scheduler-border">Status</legend>   
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">Status</span> 
                        </div>
                        <div class="col-sm-9 item-div">	                      
                            <span class="current-data">{{fovCtrl.data.alt.status}}</span>                        
                        </div>  
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">Editor</span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span>{{fovCtrl.data.alt.editor}}</span>        	           
                        </div>	                                  
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">Edited on</span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span class="current-data">{{fovCtrl.data.alt.edited_on}}</span>                        
                        </div>	
                        
                        <div class="col-sm-3 label-div">
                            <span class="xlabel xlabel-primary"><b>Please Note:</b></span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span class="current-data">Current values are displayed in <span style="color:blue"><i>blue italic</i></span> type</span>                        
                        </div>	                        
                        
                    </fieldset>  
                </div> <!---end panel body--->
			</div> <!---end panel--->     
</cfif>                     
        
        	<div class="panel panel-default fieldset-panel">	    
                <div class="panel-body">                
                	<fieldset>
	                    <legend class="scheduler-border">{{ fovCtrl.lib.ADDRESS }}</legend>
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.ADDRESS_LINE }} 1</span> 
                        </div>
                        <div class="col-sm-9 item-div">	                      
                            <span class="current-data">{{fovCtrl.data.address_line_1 || 'Required'}}</span>
                            <p class="alt-data" ng-if="fovCtrl.data.alt.address_line_1">{{ fovCtrl.data.alt.address_line_1 }}</p>
                        </div>  
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.ADDRESS_LINE }} 2</span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span class="current-data">{{fovCtrl.data.address_line_2 || 'Required'}}</span>
                            <p class="alt-data" ng-if="fovCtrl.data.alt.address_line_2">{{ fovCtrl.data.alt.address_line_2 }}</p> 
                        </div>	                                  
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.POSTAL_CODE }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span class="current-data">{{fovCtrl.data.postal_code || 'Required'}}</span>
                            <p class="alt-data" ng-if="fovCtrl.data.alt.postal_code">{{ fovCtrl.data.alt.postal_code }}</p> 
                        </div>	
                	</fieldset> 
                </div> <!---end panel body--->
			</div> <!---end panel--->                	
            
        	<div class="panel panel-default fieldset-panel">	    
                <div class="panel-body">
                    <fieldset>   
                        <legend class="scheduler-border">{{ fovCtrl.lib.TELEPHONY }}</legend> 
                                                
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.PHONE_NUMBER }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">                    	
                            <span class="current-data">{{fovCtrl.data.phone_number || 'Required'}}</span>
                            <p class="alt-data" ng-if="fovCtrl.data.alt.phone_number">{{ fovCtrl.data.alt.phone_number }}</p> 
                        </div>		                   
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.FAX_NUMBER }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">	                     
                            <span class="current-data">{{fovCtrl.data.fax_number}}</span>	
                            <p class="alt-data" ng-if="fovCtrl.data.alt.fax_number">{{ fovCtrl.data.alt.fax_number }}</p>				
                        </div>		                    
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.MOBILE_NUMBER }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">						
                            <span class="current-data">{{fovCtrl.data.mobile_number}}</span>	
                            <p class="alt-data" ng-if="fovCtrl.data.alt.mobile_number">{{ fovCtrl.data.alt.mobile_number }}</p> 			
                        </div>	
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.SATELLITE_NUMBER }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span class="current-data">{{fovCtrl.data.satellite_number}}</span>				
                            <p class="alt-data" ng-if="fovCtrl.data.alt.satellite_number">{{ fovCtrl.data.alt.satellite_number }}</p>	
                        </div>	                    
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.IRIDIUM_NUMBER }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span class="current-data">{{fovCtrl.data.iridium_number}}</span>				
                            <p class="alt-data" ng-if="fovCtrl.data.alt.iridium_number">{{ fovCtrl.data.alt.iridium_number }}</p>	
                        </div>		
                    
                    </fieldset>
                </div> <!---end panel body--->
            </div> <!---end panel ---> 
            
		</div> <!---end col--->        
                    
        <div class="col-sm-6">
        
        	<div class="panel panel-default fieldset-panel">	    
                <div class="panel-body"> 
            
                    <fieldset>        
                        <legend class="scheduler-border">{{ fovCtrl.lib.EMAIL_ADDRESSES }}</legend> 
                                                
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.OFFICIAL_EMAIL }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">
                            <span class="current-data">{{fovCtrl.data.official_email || 'Required'}}</span>
                            <p class="alt-data" ng-if="fovCtrl.data.alt.official_email">{{ fovCtrl.data.alt.official_email }}</p>                        				
                        </div>	
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.ADMIN_EMAIL }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">	                    
                            <span class="current-data">{{fovCtrl.data.admin_email}}</span>	
                            <p class="alt-data" ng-if="fovCtrl.data.alt.admin_email">{{ fovCtrl.data.alt.admin_email }}</p>	
                        </div>	                    
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.FAVORITE_EMAIL }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">	                    
                            <span class="current-data">{{fovCtrl.data.favorite_email}}</span>	
                            <p class="alt-data" ng-if="fovCtrl.data.alt.favorite_email">{{ fovCtrl.data.alt.favorite_email }}</p>			
                        </div>	
                                            
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.PUBLIC_EMAIL }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">  	                    
                            <span class="current-data">{{fovCtrl.data.emtu_label || 'Required'}}</span>
                            <p class="alt-data" ng-if="fovCtrl.data.alt.emtu_code">{{ fovCtrl.lib[fovCtrl.data.alt.emtu_code] }}</p>
                        </div>	
                    
                    </fieldset>			
                
                </div>	<!---end panel body--->	
                                        
            </div>	<!---end panel--->	

        	<div class="panel panel-default fieldset-panel">	
                
                <div class="panel-body">
            
                    <fieldset>            
                        <legend class="scheduler-border">{{ fovCtrl.lib.MISCELLANEOUS }}</legend> 
                                                
<!---                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.BUSINESS_HOURS }}</span> 
                        </div>
                        <div class="col-sm-9 item-div">	                    
                            <span class="current-data">{{fovCtrl.data.office_hours}}</span>	
                            <p class="alt-data" ng-if="fovCtrl.data.alt.office_hours">{{ fovCtrl.data.alt.office_hours }}</p>			
                        </div>	--->  
                        
						<div ng-repeat="day in fovCtrl.data.businessHours track by day.id" class="form-group"> 
                        
                            <div class="col-sm-3 label-div">
                                <span class="label label-primary">{{ fovCtrl.lib.BUSINESS_HOURS }} {{ day.day }} </span> 
                            </div>
                            
<!---                            <div class="col-sm-3 item-div"> 
                            	<span class="current-data">{{ fovCtrl.formatSchedule("main", day.id, "AM") }}</span>
                                <p ng-if="fovCtrl.hasAltSchedule(day.id, 'AM')" class="help-block alt-data">
                                	{{ fovCtrl.getAltSchedule(day.id, "AM") }}
                                </p>
							</div> --->                               
                                
<!---							<div class="col-sm-3 item-div">                                 
                            	<span class="current-data">{{ fovCtrl.formatSchedule("main", day.id, "PM") }}</span>
                                <p ng-if="fovCtrl.hasAltSchedule(day.id, 'PM')" class="help-block alt-data">
                                	{{ fovCtrl.getAltSchedule(day.id, "PM") }}
                                </p>                              
                            </div>	--->
                            
							<div class="col-sm-3 item-div">                                 
                            	<span class="current-data">{{ fovCtrl.getSchedule(day.id) }}</span>                                                            
                            </div>	                            
                            
<!---                            <div class="col-sm-3 label-div">
                                <span>&nbsp;</span> 
                            </div>                            
                            
                            <div class="col-sm-9 item-div"> 
                            	{{ fovCtrl.formatSchedule("main", day.id, "AM") }}
                                <p ng-if="fovCtrl.hasAltHour('am_opening_hour', day.id)" class="help-block alt-data">
                                	{{ fovCtrl.getAltHour("am_opening_hour", day.id) }}
                                </p>
                                
                            	{{ fovCtrl.formatSchedule("main", day.id, "PM") }}
                                <p ng-if="fovCtrl.hasAltHour('pm_opening_hour', day.id)" class="help-block alt-data">
                                	{{ fovCtrl.getAltHour("pm_opening_hour", day.id) }}
                                </p>                                
                            </div> --->                                                       
                            
						</div>  <!---end rng-epeat--->
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">CET</span> 
                        </div>
                        <div class="col-sm-9 item-div">	                    
                            <span class="current-data">{{ fovCtrl.data.cet }}</span>	
                            <p class="alt-data" ng-if="fovCtrl.data.alt.cet">{{ fovCtrl.data.alt.cet }}</p>
                        </div>		
                        
                        <div class="col-sm-3 label-div">
                            <span class="label label-primary">{{ fovCtrl.lib.WEEKEND_DAYS }}</span> 
                        </div>
                        <div class="col-sm-9 item-div"> 		                    
                            <span class="current-data">{{fovCtrl.data.wed_label}}</span>	
                            <p class="alt-data" ng-if="fovCtrl.data.alt.wed_code">{{ fovCtrl.lib[fovCtrl.data.alt.wed_code] }}</p>	
                        </div>
                    
                    </fieldset>
                
                </div>
                
			</div> <!---end panel body--->	                					
                                    
        </div> <!---end panel --->	
        
	</div> <!---end row --->         
        
    <nav class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">
<cfif rc.chkEdit EQ "Y">         
	        <button class="btn btn-primary navbar-btn" ng-click="fovCtrl.editFieldOffice()">{{ fovCtrl.lib.EDIT }}</button>             
</cfif>             
<cfif rc.chkRequestValidate EQ "Y">         
            <button class="btn btn-success navbar-btn" ng-click="fovCtrl.requestValidate()">{{ fovCtrl.lib.REQUEST_VALIDATION }}</button>   
           <!--- <button class="btn btn-warning navbar-btn" ng-click="fovCtrl.discardChanges()">{{ fovCtrl.lib.DISCARD_ALL_CHANGES }}</button> --->
</cfif> 
<cfif rc.chkValidate EQ "Y">         
	        <button class="btn btn-success navbar-btn" ng-click="fovCtrl.validateEdit()">{{ fovCtrl.lib.VALIDATE }}</button>  	
            <button class="btn btn-danger navbar-btn" ng-click="fovCtrl.rejectEdit()">{{ fovCtrl.lib.REJECT }}</button>    		            
<!---            <button class="btn btn-warning navbar-btn" ng-click="fovCtrl.discardChanges()">{{ fovCtrl.lib.DISCARD_ALL_CHANGES }}</button> --->
<!---<cfelseif rc.chkReject EQ "Y">         
	        <button class="btn btn-success navbar-btn" ng-click="fovCtrl.validateEdit()">{{ fovCtrl.lib.VALIDATE }}</button>  
			<button class="btn btn-danger navbar-btn" ng-click="fovCtrl.rejectEdit()">{{ fovCtrl.lib.REJECT }}</button>             
            <button class="btn btn-warning navbar-btn" ng-click="fovCtrl.discardChanges()">{{ fovCtrl.lib.DISCARD_ALL_CHANGES }}</button>  --->             
</cfif>         
            <ul class="nav navbar-nav navbar-right">  	            	                                                
                <!---<li><a ng-click="fovCtrl.changeLanguage()" class="pointer-cursor">{{ fovCtrl.lib.CHANGE_LANGUAGE }}</a></li>  --->                 
            </ul>    
        </div>
    </nav>                     
    
</div> <!---end panel body--->

</div> <!---end panel --->

</form>
    
</div> <!---end controller--->         
	 		  
</cfoutput>

