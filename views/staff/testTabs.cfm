<script src="views/staff/js/testTabs.js"></script>

  <div ng-controller="MainCtrl">
  
    <div ng-controller="TabCtrl">      
      <uib-tabset active="active" template-url="views/staff/tabset.html">
        <uib-tab ng-repeat="tab in tabs" heading="{{tab.title}}" active="tab.active" template-url="views/staff/tab.html" select="onTabSelected(tab.slug)">
          <!---{{ tab.content }}--->
          <div ng-bind-html="tabDynamicContent[0]"></div>
        </uib-tab>
      </uib-tabset>
    </div>  

  </div>
  

  