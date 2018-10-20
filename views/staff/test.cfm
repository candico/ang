
<style>
	
.label {		
	font-size:16px;
	font-weight: normal
}  

.control-label {
	padding-right:3px;
}

.padding-left-3 {
	padding-left:3px;
}

.padding-right-3 {
	padding-right:3px;
}

body {
	padding-top:185px;
	background-color:white
}

legend {
	font-size:18px;
	margin-bottom: 5px;
    cursor: pointer;
	border-bottom-color:grey;
}

.form-group {
	margin-bottom:8px;
}

.well {
	margin-bottom: 6px;
	/*box-shadow: 0px 2px 10px rgba(0, 0, 0, .25);*/
	/*background-color:gainsboro*/
}

.navbar-nav > li > a {
    padding-top: 5px;
    padding-bottom: 5px;
}

.collapsing {
    transition: height 0.3s;
}

.primary-border {
	border-color: #428bca;	
}

.warning-border {
	border-color: #f0ad4e;	
}

</style>



<div class="container" id="tabs">  

<ul class="nav nav-tabs" id="prodTabs" style="background-color:white">
  <li class="active"><a data-toggle="tab" href="#home">General Data</a></li>
  <li><a data-toggle="tab" data-url="index.cfm?action=staff.listNSM&jx" href="#menu1">Family Datum</a></li>
  <li><a data-toggle="tab" href="#menu2">Professional Experience</a></li>
</ul>

<div class="tab-content">
  <div id="home" class="tab-pane fade in active" style="background-color:white">   
    
	<form class="form-horizontal">
    
		<div class="row" style="min-height:1500px; background-color:lightgreyx; padding:3px">
    
            <div class="col-sm-6 padding-right-3" style="background-color:pinkx">
            
                <div class="well well-sm">
                
                    <fieldset>                    
                        
                        <legend class="scheduler-border" data-toggle="collapse" data-target="#bd1">Basic Details 1</legend>
                        
                        <div id="bd1" class="collapse">
                    
                            <div class="form-group" style="background-color:xpink">
                                <label class="control-label col-sm-5" for="email"><span class="label label-primary">Number of Children</span></label>
                                <div class="col-sm-7 padding-left-3">
                                    <input type="email" class="form-control primary-border" id="email" placeholder="Enter email">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="control-label col-sm-5" for="pwd"><span class="label label-warning">Password</span></label>
                                <div class="col-sm-7 padding-left-3"> 
                                    <input type="password" class="form-control warning-border" id="pwd" placeholder="Enter password">
                                </div>
                            </div>
                            
                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-10">
                                    <div class="checkbox">
                                        <label><input type="checkbox"> Remember me</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="submit" class="btn btn-default">Submit</button>
                                </div>
                            </div>
                        
                        </div>
                        
                    </fieldset>
        
        		</div> <!---end well--->
                
                <div class="well well-sm">
                
                    <fieldset>
                    
                        <legend class="scheduler-border" data-toggle="collapse" data-target="#bd2">Basic Details 2</legend>
                        
                        <div id="bd2" class="collapse">
                    
                            <div class="form-group" style="background-color:xpink">
                                <label class="control-label col-sm-5" for="email"><span class="label label-primary">Number of Children</span></label>
                                <div class="col-sm-7 padding-left-3">
                                    <input type="email" class="form-control primary-border" id="email" placeholder="Enter email">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="control-label col-sm-5" for="pwd"><span class="label label-warning">Second Citizenship</span></label>
                                <div class="col-sm-7 padding-left-3"> 
                                    <select class="form-control warning-border">
                                        <option>Please select</option>
                                        <option>Please select</option>
                                        <option>Please select</option>
                                        <option>Please select</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-10">
                                    <div class="checkbox">
                                        <label><input type="checkbox"> Remember me</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="submit" class="btn btn-default">Submit</button>
                                </div>
                            </div>
                        
                        </div>
                        
                    </fieldset>
        
        		</div> <!---end well--->               
    
        	</div> <!---end col--->
          
            <div class="col-sm-6 padding-left-3" style="background-color:lightyellowx">
            
                 <div class="well well-sm">
                 
                    <fieldset>
                        <legend class="scheduler-border" data-toggle="collapse" data-target="#contact">Contact</legend>
                        
                        <div id="contact" class="collapse">
                
                            <div class="form-group" style="background-color:xlightyellow">
                                <label class="control-label col-sm-5" for="email2"><span class="label label-primary">Number of Dependents</span></label>
                                <div class="col-sm-7 padding-left-3">
                                    <input type="email" class="form-control primary-border" id="email2" placeholder="Enter email">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="control-label col-sm-5" for="pwd2"><span class="label label-primary">Social Security Number</span></label>
                                <div class="col-sm-7 padding-left-3"> 
                                    <input type="password" class="form-control primary-border" id="pwd2" placeholder="Enter password">
                                </div>
                            </div>  
                        
                        </div> 
                    
                    </fieldset>
                
                </div>  <!---end well--->
                
				<div class="well well-sm">
                
                    <fieldset>
                    
                        <legend class="scheduler-border" data-toggle="collapse" data-target="#private_details">Private Detail</legend>
                        
                        <div id="private_details" class="collapse">
                    
                            <div class="form-group" style="background-color:xpink">
                                <label class="control-label col-sm-5" for="email"><span class="label label-primary">Number of Children</span></label>
                                <div class="col-sm-7 padding-left-3">
                                    <input type="email" class="form-control primary-border" id="email" placeholder="Enter email">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="control-label col-sm-5" for="pwd"><span class="label label-warning">Password</span></label>
                                <div class="col-sm-7 padding-left-3"> 
                                    <input type="password" class="form-control warning-border" id="pwd" placeholder="Enter password">
                                </div>
                            </div>
                            
                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-10">
                                    <div class="checkbox">
                                        <label><input type="checkbox">Remember me</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="submit" class="btn btn-default">Submit</button>
                                </div>
                            </div>
                        
                        </div>
                        
                    </fieldset>
        
        		</div> <!---end well--->                

            
            </div>  <!---end col--->       
        
        </div> <!---end row--->
    
     </form>    
    
    
    
  </div>
  
  <div id="menu1" class="tab-pane fade" style="background-color:white">
    <h3>Menu 1</h3>
    <p>Some content in menu 1.</p>
  </div>
  
  <div id="menu2" class="tab-pane fade" style="background-color:white">
    <h3>Menu 2</h3>
    <p>Some content in menu 2.</p>
  </div>
  
</div>

    
  
 
 </div> <!---end container--->
 
 <nav class="navbar navbar-default navbar-fixed-top" style="padding-bottom:0px">
  
    <div id="header">
        <p id="banner-title-text">EUROPEAN CIVIL PROTECTION AND HUMANITARIAN AID OPERATIONS</p>
        <p id="banner-site-name">
            <img src="../res/images/ec_logo_en.gif" alt="European commission logo" id="banner-flag"> 
            <span>ECHO D4 - Field Staff Management</span>
        </p>
    </div> 

    <div class="container-fluid">         
        <div class="navbar-header">   
<!---            <button type="button" class="btn btn-default navbar-btn">Back</button>
            <button type="button" class="btn btn-default navbar-btn">Save</button>--->
        </div>
        <!-- Collection of nav links and other content for toggling -->
        <div id="navbarCollapse" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="">Home</a></li>
                <li><a href="">Profile</a></li>
                <li><a href="">Messages</a></li>
               <!--- <li><button type="button" class="btn btn-success" ng-click="nsmEditSwitchLang()">Switch Language</button></li>--->
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="">Logged as Evrard Croes</a></li>
                
            </ul>
        </div>
   <!---     <div id="navbarCollapse" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">                
                <li><button type="button" class="btn btn-success navbar-btn">Back</button></li>
                <li><button type="button" class="btn btn-success navbar-btn">Save</button></li>
               <!--- <li><button type="button" class="btn btn-success" ng-click="nsmEditSwitchLang()">Switch Language</button></li>--->
            </ul>
        </div> --->       
	</div> <!---end navbar container--->
</nav>

<script>

$('#tabs').on('click','.tablink,#prodTabs a',function (e) {
	console.log("clicked!");
    e.preventDefault();
    var url = $(this).attr("data-url");

    if (typeof url !== "undefined") {
        var pane = $(this), href = this.hash;

        // ajax load from data-url
        $(href).load(url,function(result){  			  
            pane.tab('show');
        });
		
			
    } else {
        $(this).tab('show');
    }
});

</script>