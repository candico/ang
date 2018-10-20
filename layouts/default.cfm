<cfsetting showDebugOutput="No">
<cfheader name="Access-Control-Max-Age" value="0">
<cfheader name="Cache-Control" value="max-age=0,no-cache,no-store,post-check=0,pre-check=0,must-revalidate">
<cfheader name="Expires" value="-1">
<!DOCTYPE html>
<html ng-app="app">
<head>    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge"/>	
	<meta name="viewport" content="width=device-width, initial-scale=1">   
    
    <!--- title set by a view - there is no default --->
    <title><cfoutput>#This.name# version #This.version#</cfoutput></title>        
    <!--- EU Stylesheets --->      
   <!--- <link href="css/common.css" rel="stylesheet" />--->
    <link href="css/header.css" rel="stylesheet" />
    <!--- FSM Stylesheets --->     
    <link href="css/fsm.css" rel="stylesheet" />    
    <!--- BOOTSTRAP --->
    <link href="../res/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!--- FONT AWESOME --->
    <link href="../res/css/font-awesome.min.css" rel="stylesheet">
    <!--- JS LIBS --->
    <script src="../res/jquery/jquery-3.2.1.min.js"></script>   
    <script src="../res/jquery/moment.min.js"></script>    
    <script src="../res/bootstrap/js/bootstrap.min.js"></script>    
    <!--- ANGULAR --->
    <script src="../res/angularjs/angular.js"></script>
    <script src="../res/angularjs/angular-touch.js"></script>
    <script src="../res/angularjs/angular-messages.js"></script>
    <script src="../res/angularjs/angular-animate.js"></script>
    <script src="../res/angularjs/angular-route.js"></script>    	
    <script src="../res/angularjs/angular-sanitize.js"></script>      
    <script src="../res/angularjs/ui-bootstrap-tpls.min.js"></script>
    <!--- UI ROUTER --->
    <script src="../res/lib/angular-ui-router/angular-ui-router.min.js"></script>
    <!--- UI GRID --->
    <script src="../res/angularjs/ui-grid.min.js"></script>
	<link rel="stylesheet" href="../res/angularjs/ui-grid.min.css" type="text/css">         
    <!--- AUTOCOMPLETE --->    
    <script src="../res/angularjs/angucomplete-alt.js"></script>
    <link rel="stylesheet" href="../res/angularjs/angucomplete-alt.css" type="text/css">  
    <!--- PROGRESS BAR --->  
    <script src="../res/lib/angular-loading-bar/loading-bar.min.js"></script>
    <link rel="stylesheet" href="../res/lib/angular-loading-bar/loading-bar.min.css" type="text/css">
    <!--- DIALOG --->  
    <script src="../res/lib/ngDialog/ngDialog.min.js"></script>
    <link rel="stylesheet" href="../res/lib/ngDialog/ngDialog.min.css" type="text/css">
    <link rel="stylesheet" href="../res/lib/ngDialog/ngDialog-theme-default.min.css" type="text/css">
    <!--- NG-TABLE --->
    <link rel="stylesheet" href="../res/lib/ngTable/ng-table.min.css" type="text/css">
    <script src="../res/lib/ngTable/ng-table.min.js"></script>
    <!--- DATERANGE PICKER --->
    <script src="../res/angularjs/daterangepicker.js"></script> 
    <link rel="stylesheet" href="../res/angularjs/daterangepicker.css" type="text/css">
    <!--- FILE-UPLOAD --->
    <script src="../res/lib/ngFileUpload/ng-file-upload.min.js"></script>
    <!--- NOTIFICATIONS --->
    <link rel="stylesheet" href="../res/angularjs/angular-ui-notification.css">     
    <script src="../res/angularjs/angular-ui-notification.js"></script>
    <!--- NG-STORAGE 
	<script src="../res/lib/ngStorage/ngStorage.min.js"></script>--->
    
	<script src="https://cdnjs.cloudflare.com/ajax/libs/ngStorage/0.3.11/ngStorage.min.js"></script>
	
    <!--- USER-DEFINED --->         
    <script src="js/polyfills.js"></script> 
    <script src="js/plugins.js"></script>     
    <script src="layouts/js/app.js"></script>  
    <script src="layouts/js/default.js"></script>    
    <script src="layouts/js/services.js"></script> 
    <script src="layouts/js/directives.js"></script>  
    <script src="layouts/js/router.js"></script>

    <script src="subsystems/eval/views/eval/js/grid.js"></script>
    <script src="subsystems/eval/views/eval/js/tabs.js"></script>
    <script src="subsystems/eval/views/preparation/preparation.js"></script>
    <script src="subsystems/eval/views/sass/js/setSass.js"></script>
    <script src="subsystems/eval/views/feedback/feedback.js"></script>
    <script src="subsystems/eval/views/closure/closure.js"></script>
    <script src="subsystems/eval/views/followup/followup.js"></script>

    <script src="views/fom/js/tabs.js"></script>

    <link rel="icon" type="image/x-icon" href="../res/images/favicon.ico">             
</head>
<body ng-controller="rootController as rootCtrl" ng-cloak> 

   <nav class="navbar navbar-default navbar-fixed-top">
    	<div class="container-fluid" style="padding-left:0; padding-right:0">     
    		<div id="header">
    			<p id="banner-title-text">EUROPEAN CIVIL PROTECTION AND HUMANITARIAN AID OPERATIONS</p> 
    			<p id="banner-site-name">
    				<img src="../res/images/ec_logo_en.gif" alt="European commission logo" id="banner-flag"> 
                    <span>ECHO D4 - Field Staff Management</span>
                    <span style="font-size:medium; vertical-align:central"></span>
    			</p>
    		</div> 
   		</div> 
    </nav>

    <div id="content">
        <cfoutput>#body#</cfoutput>
    </div>

    <div ng-controller="notificationController" ng-cloak>  
    	<div class="container"></div>        
    </div> 
      
</body>

<script>
var ts = "<cfoutput>#Now()#</cfoutput>";
</script>

</html>



<!---<cfscript>

str = "medical_remarks_114";
ref1 = REFind("^(medical_\D+)_(\d+)$", str ); 
ref2 = "";
if(ref1) {
	ref2 = REFind("^(medical_\D+)_(\d+)$", str , 1, true );
	core = Mid(str, ref2["POS"][2], ref2["LEN"][2]);
	id = Mid(str, ref2["POS"][3], ref2["LEN"][3]);
}

WriteDump(ref1);
WriteDump(ref2);

WriteOutput(core);
WriteOutput(id);



</cfscript>--->
