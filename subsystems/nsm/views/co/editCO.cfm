
<script>

    $(".collapse").on('show.bs.collapse', function(e){  
		e.stopPropagation();	
    });
	
    $(".collapse").on('hide.bs.collapse', function(e){  
		e.stopPropagation();	
    });		

</script>

<cfoutput>

<form name="mainCoCtrl.nsmEditCoForm" id="nsmEditCoForm" class="form-horizontal" update-flagging novalidate>
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
                
                        <div class="panel-heading" ng-class="mainCoCtrl.getHeadingClasses(contract.version_id, 'top')">                                               
                            <h4 class="panel-title">                        
                                <a data-toggle="collapse" 
                                class="collapse-link collapsed" 
                                title="Click to expand or collapse panel (contract version id: {{ contract.version_id }})" 
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
                                    	{{ mainCoCtrl.getAltContract(contract.version_id, 'end_date') }}
                                    </p>
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
                                    <span class="label label-primary">[Last Update BO]</span> 
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
                                        ng-click="mainCoCtrl.openContractDocFile(contractDoc.id, contractDoc.hash)">
                                            {{ contractDoc.file_name }} 
                                        </div>                                        
                                    </div>  
                                </div>     
                                
                                <div class="col-sm-3 label-div">
                                    <span class="label label-primary">[Add File]</span> 
                                </div>   
                                <div class="col-sm-4 item-div">  
                                    <select ng-model="mainCoCtrl.data.type_code" class="form-control" name="type_code_{{ contract.version_id }}" id="type_code_{{ contract.version_id }}" required> 
                                        <option value=''>{{mainCoCtrl.str.PLEASE_SELECT}}</option>  
                                        <option value='EMPLOYMENT_CONTRACT'>{{mainCoCtrl.str.EMPLOYMENT_CONTRACT}}</option> 
                                        <option value='TERMS_OF_REFERENCE'>{{mainCoCtrl.str.TERMS_OF_REFERENCE}}</option>  
                                        <option value='GENERAL_CONDITIONS'>{{mainCoCtrl.str.GENERAL_CONDITIONS}}</option>       
                                        <option value='SPECIFIC_CONDITIONS'>{{mainCoCtrl.str.SPECIFIC_CONDITIONS}}</option>    
                                        <option value='ARA_FOR_PUBLICATION'>{{mainCoCtrl.str.ARA_FOR_PUBLICATION}}</option>      
                                        <option value='ARES_FOR_PUBLICATION'>{{mainCoCtrl.str.ARES_FOR_PUBLICATION}}</option> 
                                        <option value='ARA_FOR_RECRUITMENT'>{{mainCoCtrl.str.ARA_FOR_RECRUITMENT}}</option> 
                                        <option value='ARES_FOR_RECRUITMENT'>{{mainCoCtrl.str.ARES_FOR_RECRUITMENT}}</option> 
                                        <option value='CODE_OF_CONDUCT'>{{mainCoCtrl.str.CODE_OF_CONDUCT}}</option>                  
                                    </select> 
                                </div>                                
                                <div class="col-sm-4 item-div">	 
									<div class="form-group">	
                                       <input type="file" 
                                       class="form-control" 
                                       id="contract_file_{{ contract.version_id }}" 
                                       ng-model="contract.contract_file"
                                       name="contract_file_{{ contract.version_id }}" /> 
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
            
                <button ng-if="nsmGridCtrl.hasGrid" class="btn btn-default navbar-btn" name='switch' value="switch" ng-click="nsmGridCtrl.switchGridDetail()">{{ mainCoCtrl.str.BACK_TO_GRID }}</button>     
                <button class="btn btn-info navbar-btn" name='view' value="view" ng-click="mainCoCtrl.viewCO()">{{ mainCoCtrl.str.VIEW }}</button>                 
				<button ng-class="(mainCoCtrl.nsmEditCoForm.$invalid) ? 'btn navbar-btn btn-warning' : 'btn navbar-btn btn-success'" name='save' value="save" ng-click="mainCoCtrl.saveCO()">
                	{{ mainCoCtrl.str.SAVE }}
                </button>  
                
                <ul class="nav navbar-nav navbar-right">   
                	<li><a ng-click="mainCoCtrl.expandAll($event)" class="pointer-cursor">{{ mainCoCtrl.str.EXPAND_ALL }}</a></li> 
                	<li><a ng-click="mainCoCtrl.collapseAll($event)" class="pointer-cursor">{{ mainCoCtrl.str.COLLAPSE_ALL }}</a></li>                           	
                    <li><a ng-click="mainCoCtrl.reload()" class="pointer-cursor">{{ mainCoCtrl.str.RELOAD }}</a></li>
                </ul>
                
            </div>
        </nav>           
		
	</div>  <!---end panel body--->   
    
</div> <!---end panel--->      

</form>

</cfoutput>