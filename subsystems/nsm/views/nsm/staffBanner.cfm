<div class="panel panel-default fieldset-panel">

    <div class="panel-heading nsm-details">   
      <div class="row">
          <div class="col-sm-1 label-div nsm-details identity">{{ tabsCtrl.str.IDENTITY }}:</div>
          <div class="col-sm-2 item-div nsm-details">{{ tabsCtrl.nsm_details.last_name }} {{ tabsCtrl.nsm_details.first_name }}</div>
          
          <div class="col-sm-2 label-div nsm-details">{{ tabsCtrl.str.CONTRACT_ROLE }}:</div>
          <div class="col-sm-3 item-div nsm-details">{{ tabsCtrl.nsm_details.contract_role }}</div>
          
          <div class="col-sm-1 label-div nsm-details">{{ tabsCtrl.str.CONTRACT }}:</div>
          <div class="col-sm-3 item-div nsm-details">{{ tabsCtrl.nsm_details.contract_start || 'N/A' }} &gt; {{ tabsCtrl.nsm_details.contract_end  ||  tabsCtrl.str.OPEN_ENDED }}</div>
      </div>
    </div>
    
    <div class="panel-body nsm-details">
      <div class="row">
          <div class="col-sm-1 label-div nsm-details">{{ tabsCtrl.str.OFFICE }}:</div>
          <div class="col-sm-2 item-div nsm-details">{{ tabsCtrl.nsm_details.home_office }}</div>
          
          <div class="col-sm-2 label-div nsm-details">{{ tabsCtrl.str.POSITION_ROLE }}:</div>
          <div class="col-sm-3 item-div nsm-details">{{ tabsCtrl.nsm_details.position_role }}</div>
          
          <div class="col-sm-1 label-div nsm-details">{{ tabsCtrl.str.FG }} / {{ tabsCtrl.str.ADMIN_STEP }}:</div>
          <div class="col-sm-3 item-div nsm-details">{{ tabsCtrl.nsm_details.function_group || 'N/A' }} / {{ tabsCtrl.nsm_details.step || 'N/A' }}</div>
      </div>      
    </div>        

</div>