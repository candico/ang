<!--- No #body# in this layout, because used exclusively with AJAX-inserted partials --->
<script src="layouts/js/main.js"></script> 



<style type="text/css">

.dropdown-menu {
	max-height: 200px;
	overflow-x: hidden;
	overflow-y: scroll;
}

</style>

<div ng-controller="topMenuController as topMenuCtrl">
    
    <!--- adds itself as an additional fixed bar under the EU banner --->
    <nav class="navbar navbar-default navbar-fixed-top fixed-top-menu">  
        <ul class="nav navbar-nav">
        
            <li class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'home'}">
                <a ng-click='topMenuCtrl.setTopMenuItem("home")'>Home</a>
            </li>   
                     
           <li class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'fom'}">                          
                <a ng-click='topMenuCtrl.setTopMenuItem("fom")' ng-attr-data-toggle="{{topMenuCtrl.officesDataToggleAttr}}">{{topMenuCtrl.currentFieldOffice}}
                <span class="caret"></span></a>  
                <ul class="dropdown-menu">                   	            
                	<li ng-repeat="office in topMenuCtrl.fieldOffices" title="id:{{office.key}}"><a ng-click='topMenuCtrl.setFieldOffice(office.key)'>{{office.value}}</a></li>                             
                </ul>                
            </li>  
            <li class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'nsm'}">
                <a ng-click='topMenuCtrl.setTopMenuItem("nsm")'>Staff</a>
            </li>   
            
            <li ng-if="topMenuCtrl.chk_view_evaluations" class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'eval'}">
                <a ng-click='topMenuCtrl.setTopMenuItem("eval")'>Evaluation</a>
            </li>       
                  
        </ul>   
               
        <ul class="nav navbar-nav navbar-right">
        	<li class="menu-item"><a ng-click="topMenuCtrl.logout()"><span class="glyphicon glyphicon-user"></span> Log As</a></li>
        </ul> 
          
		<p class="navbar-text navbar-right"><span style="font-weight:bold">        
        <span ng-if="topMenuCtrl.del_user_id">{{topMenuCtrl.del_user_fname}} {{topMenuCtrl.del_user_lname}} on behalf of</span>        
        {{topMenuCtrl.fname}} {{topMenuCtrl.lname}} [{{topMenuCtrl.profile}} - {{topMenuCtrl.homeOffice}}]        
        </span></p>             
    </nav>  
    	
    <div class="tab-content">
       <div ng-show='topMenuCtrl.activeItem == "home"'>            
            <div ng-include="topMenuCtrl.items.home && topMenuCtrl.homeURL"></div>
        </div>
        <div ng-show='topMenuCtrl.activeItem == "fom"'>
            <div ng-include="topMenuCtrl.items.fom && topMenuCtrl.fomURL"></div> <!---the whole tab structure for an office is reloaded--->
        </div>
        <div ng-show='topMenuCtrl.activeItem == "nsm"'>
            <div ng-include="topMenuCtrl.items.nsm && topMenuCtrl.nsmURL"></div>
        </div>
        <div ng-show='topMenuCtrl.activeItem == "eval"'>
            <div ng-include="topMenuCtrl.items.eval && topMenuCtrl.evalURL"></div>
        </div>
    </div>
    
</div>