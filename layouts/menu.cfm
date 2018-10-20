<!--- No #body# in this layout, because used exclusively with AJAX-inserted partials --->
<script src="layouts/js/menu.js"></script> 

<cfoutput>

<div ng-controller="topMenuController as topMenuCtrl">
    
    <!--- adds itself as an additional fixed bar under the EU banner --->
    <nav class="navbar navbar-default navbar-fixed-top fixed-top-menu">  
        <ul class="nav navbar-nav">

            <!--- <li class="menu-item" ng-class="{'active': $state.includes('home')}">
                <li class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'home'}">
                <a ng-click='topMenuCtrl.setTopMenuItem("home")'>Home</a>
            </li> --->
<!---            <li class="menu-item" ng-click='topMenuCtrl.setTopMenuItem("home")' ng-class="{'active': $state.includes('home')}">
                <a ui-sref="home">Home</a>
            </li>--->
            

            <li class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'home'}">
                <a ng-click='topMenuCtrl.setTopMenuItem("home")'>Home</a>
            </li> 


            <li class="dropdown" ng-if="topMenuCtrl.privs.changeOffice.visible">
                <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                    {{topMenuCtrl.currentFieldOffice}} <span class="caret"></span>                
                </a>
                <ul class="dropdown-menu" style="height: 200px; overflow-y: auto;">
                    <li ng-repeat="office in topMenuCtrl.fieldOffices" title="id:{{office.key}}" >
                        <a ui-sref="changeOffice({officeId: office.key})">{{office.value}}</a>
                    </li>
                </ul>
            </li>
<!--- style="cursor:pointer;" --->



        <!--- <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Separated link</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">One more separated link</a></li>
          </ul>
        </li> --->

        

         <!---  <li class="menu-item">
                 <a ng-click='topMenuCtrl.setTopMenuItem("fom")' ng-attr-data-toggle="{{topMenuCtrl.officesDataToggleAttr}}">{{topMenuCtrl.currentFieldOffice}}
                <span class="caret"></span></a>  
                <ul class="dropdown-menu" style="max-height: 200px; overflow-x: hidden; overflow-y: scroll; cursor: pointer;">                   	            
                	<li ng-repeat="office in topMenuCtrl.fieldOffices" title="id:{{office.key}}"><a ng-click='topMenuCtrl.setFieldOffice(office.key)'>{{office.value}}</a></li>
                </ul>                
            </li> --->

            <!--- <li class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'nsm'}">
                <a ng-click='topMenuCtrl.setTopMenuItem("nsm")'>Staff</a>
            </li> --->

            <li class="menu-item" ng-click='topMenuCtrl.setTopMenuItem("nsm")' ng-class="{'active': $state.includes('staff')}" ng-if="topMenuCtrl.privs.staff.visible">
                <a ui-sref="staff">Staff</a>
            </li>

            <!--- <li ng-if="topMenuCtrl.chk_view_evaluations" class="menu-item" ng-class="{active: topMenuCtrl.activeItem == 'eval'}">
                <a ng-click='topMenuCtrl.setTopMenuItem("eval")'>{{ topMenuCtrl.str.EVALUATIONS }}</a>
            </li> --->

            <li ng-if="topMenuCtrl.privs.evaluations.visible" class="menu-item" ng-class="{'active':$state.includes('evaluations')}">
                <a ui-sref="evaluations.list" ui-sref-active="active">{{ topMenuCtrl.str.EVALUATIONS }}</a>
            </li>

        </ul>   
               
        <ul class="nav navbar-nav navbar-right">
        	<li class="menu-item"  ng-if="topMenuCtrl.privs.loginAs.visible"><a ng-click="topMenuCtrl.logAs()"><span class="glyphicon glyphicon-user"></span> Log As</a></li>
            <li class="menu-item lang-menu-item"><a ng-click="rootCtrl.setLang('FR')"><span class="badge" style="background-color:dodgerblue">FR</span></a></li>
            <li class="menu-item lang-menu-item"><a ng-click="rootCtrl.setLang('EN')"><span class="badge" style="background-color:dodgerblue">EN</span></a></li>
        </ul>         
          
		<p class="navbar-text navbar-right"><span style="font-weight:bold">        
        <span ng-if="topMenuCtrl.del_user_id">{{topMenuCtrl.del_user_fname}} {{topMenuCtrl.del_user_lname}} on behalf of</span>        
        {{topMenuCtrl.fname}} {{topMenuCtrl.lname}} [{{topMenuCtrl.profile}} - {{topMenuCtrl.homeOffice}}]        
        </span></p>             
    </nav>  
    


    
	<div class="top-menu-content">
    <ui-view> 
       <div ng-show='topMenuCtrl.activeItem == "home"'>            
            <div ng-include="topMenuCtrl.items.home && topMenuCtrl.homeURL"></div>
        </div>
        <div ng-show='topMenuCtrl.activeItem == "fom"'>
            <div ng-include="topMenuCtrl.items.fom && topMenuCtrl.fomURL"></div> <!---the whole tab structure for an office is reloaded--->
        </div>
        <div ng-show='topMenuCtrl.activeItem == "nsm"'>
            <div ng-include="topMenuCtrl.items.nsm && topMenuCtrl.nsmURL"></div>
        </div>  
        <!--- <div ng-show='topMenuCtrl.activeItem == "eval"'>
            <div ng-include="topMenuCtrl.items.eval && topMenuCtrl.evalURL"></div>
        </div> --->
    </ui-view>
    </div> 
    
</div>

</cfoutput>