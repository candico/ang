
<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });		

</script>

<cfoutput>

<form name="mainCoCtrl.nsmViewCoForm" id="nsmViewCoForm" class="form-horizontal" update-flagging novalidate>
<input type="hidden" name="staff_member_id" id="staff_member_id" value="#rc.staff_member_id#" />

<div class="panel view-panel">

	<div class="panel-body">
    
		<staff-banner ng-cloak></staff-banner> 
    
		<div class="row">
        
            <!---<div class="stop-error-flagging"> ---> 
                
                <div class="panel-heading">  
                                 
                    <h4 class="panel-title">  
                       <span>{{ (mainCoCtrl.data.contracts.length == 0) ?  mainCoCtrl.str.NO_CONTRACTS : (mainCoCtrl.data.contracts.length > 1) ? mainCoCtrl.str.CONTRACTS : mainCoCtrl.str.CONTRACT }} </span>
                    </h4>    
                                            
                </div>                 
                
   				<div ng-repeat="parity in ['e','o']" ng-if="parity == 'e' ? tmp = 'e' : tmp = 'o'">
                <div class="col-sm-6">                     
                <div ng-repeat="contract in mainCoCtrl.data.contracts track by contract.version_id" ng-if="parity == 'e' ? $even : $odd">  
                <input type="hidden" name="deleted_{{ contract.version_id }}" value="{{ contract.deleted }}" />
                
                    <div class="panel panel-default fieldset-panel">  
                
                        <div class="panel-heading" ng-class=" mainCoCtrl.getHeadingClasses('contract', contract.version_id) ">                                               
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed" 
                                title="Click to expand or collapse panel (contract id: {{ contract.contract_id }} - contract version id: {{ contract.version_id }})" 
                                data-target=".contract-{{ contract.version_id }}-panel">
                                	{{ contract.start_date  || '[...]' }} - {{ contract.end_date || '[...]'}} 
                                </a>  
                            </h4>                     
                        </div>            
                        
                        <div class="panel-body">  
                            <div class="row"> 
	                             <div class="col-sm-12">{{ contract.start_date }} - {{ contract.end_date || '[...]' }}</div>
                            </div> 
                        </div>     
                        
                        <div class="panel-collapse collapse contract-{{ contract.version_id }}-panel"> 
                        
                            <div class="panel-body">      
                            
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.VERSION }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.contract_version }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'contract_version')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'contract_version') }}
                                    </p>
                                </div>                                               
                                                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.START_DATE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.start_date }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'start_date')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'start_date') }}
                                    </p>
                                </div> 
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.END_DATE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.start_date }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'end_date')" class="help-block alt-data">
                                    {{ mainCoCtrl.getAltContract(contract.version_id, 'end_date') }}</p>
                                </div>        
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.OFFICE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.office }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'office')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'office') }}
                                    </p>
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.COUNTRY }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.country_code }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'country_code')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'country_code') }}
                                    </p>
                                </div>    
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.CONTRACT_ROLE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.contract_role }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'contract_role')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'contract_role') }}
                                    </p>
                                </div>   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">[ Last Update BO]</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.last_update_bo }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'last_update_bo')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'last_update_bo') }}
                                    </p>
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.GROUP }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.function_group }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'function_group')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'function_group') }}
                                    </p>
                                </div>    
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.ADMIN_STEP }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.step }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'step')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'step') }}
                                    </p>
                                </div>
                                                                                                                                                                                                      
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.STATUS }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.status }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'status')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'status') }}
                                    </p>
                                </div>    
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.SIGNED_CONTRACT }}?</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.signed }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'signed')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'signed') }}
                                    </p>
                                </div>                   
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.INFO_SHEET }}?</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.info_sheet }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'info_sheet')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'info_sheet') }}
                                    </p>
                                </div>           
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.UNIT }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.unit }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'unit')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'unit') }}
                                    </p>
                                </div>      
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.APD_REFERENCE }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.apd_reference }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'apd_reference')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'apd_reference') }}
                                    </p>
                                </div>      
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">{{ mainCoCtrl.str.COMMENTS }}</span> 
                                </div>   
                                <div class="col-sm-8 item-div">	                      
                                    <div class="current-data"><span>{{ contract.comments }}</span></div>
                                    <p ng-if="mainCoCtrl.hasAltContract(contract.version_id, 'comments')" class="help-block alt-data">
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'comments') }}
                                    </p>
                                </div>                   
                                
                                <div ng-repeat="contractDoc in mainCoCtrl.data.contractDocs[contract.version_id] track by contractDoc.id">   
                                    <div class="col-sm-3 label-div">
                                        <span class="label" ng-class=" mainCoCtrl.getLabelClasses('contractDoc', contract.version_id, contractDoc.id) ">Document</span> 
                                    </div>   
                                    <div class="col-sm-4 item-div">	
	                                    <div class="current-data">
	                                        {{ mainCoCtrl.str[contractDoc.type_code] }}
                                        </div>                                     
                                    </div>                           
                                    <div class="col-sm-4 item-div">	  
                                        <div class="current-data file-link" 
                                        ng-click="mainCoCtrl.openContractDoc(contractDoc.id, contractDoc.hash)">
                                            {{ contractDoc.file_name }} 
                                        </div>
                                    </div>   
                                </div>                                   
                
							</div>  <!---end panel body--->
                
						</div>  <!---end panel collapse--->
                
					</div>  <!---end panel--->
                
                </div> <!---end repeat contract--->
                </div> <!---end col-sm-6--->
                </div> <!---end repeat parity--->                    
                
			<!---</div>--->  <!---end error flagging--->                     
        
        </div> <!---end row--->
        
		<nav class="navbar navbar-inverse navbar-fixed-bottom">
            <div class="container-fluid">            
                <button class="btn btn-default navbar-btn" name='grid' value="grid" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainCoCtrl.str.BACK_TO_GRID }}</button>     
<cfif rc.chk_edit_co EQ "Y">                 
                <button class="btn btn-primary navbar-btn" name='edit' value="edit" ng-click="mainCoCtrl.editCO()">{{ mainCoCtrl.str.EDIT }}</button>
</cfif> 
<cfif 1 EQ 1 OR rc.chk_wf_start EQ "Y">
				<button class="btn btn-primary navbar-btn" name='wf_start' value="wf_start" ng-click="mainCoCtrl.WF_Start()">{{ mainCoCtrl.str.START_WORKFLOW }}</button>
</cfif>     
<cfif 1 EQ 1 OR rc.chk_wf_accept EQ "Y">
				<button class="btn btn-success navbar-btn" name='wf_approve' value="wf_accept" ng-click="mainCoCtrl.WF_Accept()">{{ mainCoCtrl.str.WORKFLOW_ACCEPT }}</button>
</cfif>  
<cfif 1 EQ 1 OR rc.chk_wf_reject EQ "Y">
				<button class="btn btn-danger navbar-btn" name='wf_reject' value="wf_reject" ng-click="mainCoCtrl.WF_Reject()">{{ mainCoCtrl.str.WORKFLOW_REJECT }}</button>
</cfif>         
                <ul class="nav navbar-nav navbar-right">  
                	<li><a ng-click="mainCoCtrl.expandAll($event)" class="pointer-cursor">{{ mainCoCtrl.str.EXPAND_ALL }}</a></li> 
                	<li><a ng-click="mainCoCtrl.collapseAll($event)" class="pointer-cursor">{{ mainCoCtrl.str.COLLAPSE_ALL }}</a></li>                 	                	
                	<!---<li><a ng-click="mainCoCtrl.reload()" class="pointer-cursor">{{ mainCoCtrl.str.RELOAD }}</a></li> --->
                </ul>
            </div>
        </nav>          
		
	</div>  <!---end panel body--->   
    
</div> <!---end panel--->      

</form>

</cfoutput>