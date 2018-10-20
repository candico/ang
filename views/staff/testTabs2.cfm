
<script src="views/staff/js/testTabs2.js"></script>

<style type="text/css">
  form.tab-form-demo .tab-pane {
    margin: 20px 20px;
  }
</style>

<div ng-controller="TabsDemoCtrl">

  Tabs using nested forms:
  <form name="outerForm" class="tab-form-demo">
    <uib-tabset active="activeForm" template-url="views/staff/tabset.html">
      <uib-tab index="0" heading="Form Tab" template-url="views/staff/tab.html">
        <ng-form name="nestedForm">
          <div class="form-group">
            <label>Name</label>
            <input type="text" class="form-control" required ng-model="model.name"/>
          </div>
        </ng-form>
      </uib-tab>
      <uib-tab index="1" heading="Tab One" template-url="views/staff/tab.html">
        Some Tab Content
      </uib-tab>
      <uib-tab index="2" heading="Tab Two" template-url="views/staff/tab.html">
        More Tab Content
      </uib-tab>
    </uib-tabset>
  </form>
  
  Model:
  <pre>{{ model | json }}</pre>
  Nested Form:
  <pre>{{ outerForm.nestedForm | json }}</pre>
  
</div>

