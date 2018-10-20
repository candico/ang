<script src="views/security/js/login.js"></script>

<cfparam name="rc.entrypoint" default="">

<cfoutput>
<!---rc.entrypoint: #rc.entrypoint# #buildURL(rc.entrypoint)#--->
<!---<form name="loginForm" action="index.cfm" method="POST">
<input type="hidden" name="action" value="security.validateLogin" />--->

<form name="loginForm" id="loginForm">
<div ng-controller="loginController as loginCtrl" style="margin-left:10%; margin-right:10%">                           
    <div class="row" style="padding-left:30%; padding-right:30%">
        <div class="col-sm-12">        
            <div class="well well-sm">            
                <fieldset>                
                    <legend class="scheduler-border">Login</legend>                
                    <div class="form-group has-feedback">
                        <label class="control-label" for="username">Username</label>                            
                        <input type="text" ng-model="loginCtrl.username" class="form-control primary-border" name="username" id="username"> 
						<label class="control-label" for="username">Password</label>  
						<input type="text" ng-model="loginCtrl.password" class="form-control primary-border" name="password" id="password">                                                   
                    </div>                    
                </fieldset>
               <button class="btn btn-success btn-sm" name='submitLogin' id='submitLogin' ng-click="loginCtrl.validateLogin()">Submit</button> 
                <!---<input type="submit" class="btn btn-success btn-sm" value="Log In">---> 
			</div>
		</div>                        
	</div>    
</div>	
</form>            

<!---isValid: #isValid("regex", "01/01/2020 01/01/2021", "^(\d{2}/\d{2}/\d{4}) (\d{2}/\d{2}/\d{4})$")#
<br />
<cfif REFind("^(\d{2}/\d{2}/\d{4}) (\d{2}/\d{2}/\d{4})$", "01/01/2020 01/01/2120" )>
	<cfset res = REFind("^(\d{2}/\d{2}/\d{4}) (\d{2}/\d{2}/\d{4})$", "01/01/2020 01/01/2021" , 1, true )>
    <cfset dte1 = res["MATCH"][2]> dte1: #dte1#
    <br />
    <cfset dte2 = res["MATCH"][3]> dte2: #dte2#    
	<cfdump var='#REFind("^(\d{2}/\d{2}/\d{4}) (\d{2}/\d{2}/\d{4})$", "01/01/2020 01/01/2021" , 1, true )#'>
</cfif>--->

</cfoutput>

<br />
Nairobi Office:
<br />
HoO: heffijo
<br />
HRFP: bunneni

<!---<cfdump var="#Session#" label="Session" expand="no">--->



