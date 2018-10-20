<!---   ECAS Client for Coldfusion version 4.1.0 (20170531162035)
        This is the ECAS client code to integrate ECAS authentication into your Coldfusion application

        To use this client, one must create an instance of this component for each user of the application.
        The advised way of working is to store the instance in the user's session.

        After calling the "authenticate" function, the instance will hold the user data in public variables.

        Those accessible variables are:
        On successful authentication
            - authenticated: authentication result
            - userid: user's unique identifier
            - loginDate: date of login within the Ecas server
            - groups: array of user groups, according to the 'requestedGroups' attribute
        If user details where requested, those variables may also be available (if they exist for the current user)
            - departmentNumber: the Commission department number
            - domain: domain to which this user belongs
            - domainUsername: username within the domain
            - email
            - employeeType: short employee population identifier
            - firstname
            - lastname
            - telephoneNumber
            - userManager: the manager of the current logged in user (as a userid)
            - locale: the user chosen language in ECAS
        If debug was set to true
            - debug: the XML returned by ECAS on ticket validation or proxy ticket request
        If authentication failed
            - errorCode = ticket validation failure code
            - errorMessage = ticket validation failure message
--->
<cfcomponent displayname="ecasClient">

    <!--- 'static' constant data --->
    <cfset variables.useragent="EcasColdfusionClient/4.1.0 (20170531162035) (#Server.ColdFusion.ProductName#/#Server.ColdFusion.ProductVersion#; #Server.ColdFusion.AppServer#; OS/#Server.OS.Name# #Server.OS.Version#; Host/#CGI.HTTP_HOST#)"/>
    <cfset variables.assuranceLevels={TOP=40, HIGH=30, MEDIUM=20, LOW=10}/>
    <cfset variables.supportedLocales=["bg","cs","da","de","et","el","en","es","fr","hr","it","lv","lt","hu","mt","nl","pl","pt","ro","sk","sl","fi","sv"]/>

    <cffunction name="init" access="public" output="no" returntype="ecasClient"
                hint="Pseudo constructor, one should always call this function after creating the component instance and before any other action">
        <!--- mandatory --->
        <cfargument name="serviceUrl" type="string" required="true"
                    hint="The url of your application server, where the ECAS server will redirect the user after authentication.
                          This must be your application's host part of the URL only, the path is setup automatically by default or through the serviceUrlPath parameter if needed.
                          By default the complete redirection URL is dynamically build so, after authentication, the user goes back to the exact page he requested.">

        <!--- optional --->
        <cfargument name="serviceUrlPath" type="string" required="false"
                    hint="The path to the page where the user must be redirected after authentication.
                          By default, the client will auto-complete this parameter with the originally requested path and URL parameters if any.">
        <cfargument name="requestedGroups" type="string" default=""
                hint="Comma separated list of groups your application is interested in.  Only the specified or matching groups will
                          be returned if the user is a member of them. Accepts the '*' wildcard. (Default = no group requested)">

        <!--- ECAS server related URL's --->
        <cfargument name="ecasBaseUrl" type="string" default="https://ecas.cc.cec.eu.int:7002"
                    hint="ECAS host fragment to be used for all ECAS URLs (login, init, validate and proxy)."/>
        <cfargument name="ecasLoginUrl" type="string"
                    hint="The url of the ECAS server login page you would like to use (Default = ECAS production login page)">
        <cfargument name="ecasInitLoginUrl" type="string"
                    hint="The ECAS Server URL where an ECAS login request transaction is initiated">
        <cfargument name="ecasValidateUrl" type="string" hint="The ECAS ticket validation URL">

        <!--- authentication parameters --->
        <cfargument name="acceptedStrengths" type="string" default="PASSWORD,CLIENT_CERT"
                    hint="Comma separated list of authentication strengths your application accepts.
                          Possible candidates are 'BASIC' to authenticate on an ECAS Mockup, 'NTLM' for authentication with a Windows domain,
                          'CLIENT_CERT' to allow end-to-end monitoring, 'PASSWORDS_SMS' or 'PASSWORD_TOKEN for two factor authentication (registration needed).
                          (Default = 'PASSWORD,CLIENT_CERT', the ECAS producion password strength plus certificate authentication for monitoring)">
        <cfargument name="acceptedTicketTypes" type="string" default="SERVICE,PROXY"
                    hint="Comma separated list of ticket types your application accepts.
                          Possible options are SERVICE, PROXY and DESKTOP.">
        <cfargument name="assuranceLevel" type="string" default="TOP"
                    hint="User identity assurance level required by the application, default to TOP.
                          Options: TOP (EC internale population only), HIGH (=TOP+interinstitutional), MEDIUM (=HIGH+sponsored accounts), LOW (=MEDIUM+self registered accounts)">
        <cfargument name="propagateLocale" type="boolean" default="false"
                    hint="Indicate that your application wants the user locale to be propagated to ECAS, for this to work you must set the client locale first.
                          Note: language propagation is limited to registered applications which supports all european languages.">
        <cfargument name="locale" type="string"
                    hint="User locale to propagate to ECAS, init param to dispense from calling setLocale function.
                          Note: only useful with propagateLocale=true. See setLocale() for details.">
        <cfargument name="userDetails" type="boolean" default="false" hint="Flag to ask for user details">
        <cfargument name="renew" type="boolean" default="false" hint="Flag to force the user to re-enter his password, reject SSO login for this application">
        <!--- ECAS proxy parameters --->
        <cfargument name="proxyCallbackUrl" type="string" default=""
                    hint="The callback URL to receive proxy tickets from ECAS. This argument is the trigger for proxy authentication mechanism.
                          If you specify a callback URL, you MUST also specify a proxyCacheDataSource.">
        <cfargument name="ecasProxyUrl" type="string" hint="The ECAS url used to obtain proxy tickets">
        <cfargument name="proxyCacheDataSource" type="string" default=""
                    hint="Name of the data source for storing proxy granting tickets. The related database must contain the cache table before executing this code.">
        <cfargument name="proxyCacheTable" type="string" default="ECAS_PROXY_CACHE" hint="Name of the database table for storing proxy granting tickets">

        <!--- ECAS client behaviour settings --->
        <cfargument name="redirectOnInvalidTicket" type="boolean" default="true" hint="Indicate the client to redirect to ECAS in case of invalid ECAS ticket.">
        <cfargument name="throwOnError" type="boolean" default="false" hint="Flag to request for an exception to be thrown on authentication or proxy ticket request failure">
        <cfargument name="debug" type="boolean" default="false"
                hint="For development and problem solving purposes,
                      will fill the variable 'ecasDebug' with the XML returned from ECAS and log detailed information to the loggingFile">
        <cfargument name="loggingFile" type="string" default="ecasclient" hint="Name of the log file to write log statements, if the debug flag is set">

        <cfset variables.throwOnError = arguments.throwOnError>
        <cfset variables.debug = arguments.debug>
        <cfset variables.loggingFile = arguments.loggingFile>

        <!--- define all ECAS URL's --->
        <cfif isDefined("arguments.ecasInitLoginUrl")>
            <cfset variables.ecasInitLoginUrl = arguments.ecasInitLoginUrl/>
        <cfelse>
            <cfset variables.ecasInitLoginUrl = arguments.ecasBaseUrl & "/cas/login/init"/>
        </cfif>
        <cfif isDefined("arguments.ecasLoginUrl")>
            <cfset variables.ecasLoginUrl = arguments.ecasLoginUrl/>
        <cfelse>
            <cfset variables.ecasLoginUrl = arguments.ecasBaseUrl & "/cas/login"/>
        </cfif>
        <cfif isDefined("arguments.ecasValidateUrl")>
            <cfset variables.ecasValidateUrl = arguments.ecasValidateUrl/>
        <cfelse>
            <cfset variables.ecasValidateUrl = arguments.ecasBaseUrl & "/cas/TicketValidationService"/>
        </cfif>
        <cfif isDefined("arguments.ecasProxyUrl")>
            <cfset variables.ecasProxyUrl = arguments.ecasProxyUrl/>
        <cfelse>
            <cfset variables.ecasProxyUrl = arguments.ecasBaseUrl & "/cas/proxy"/>
        </cfif>

        <cfset variables.serviceUrl = arguments.serviceUrl>
        <cfif isDefined("arguments.serviceUrlPath")>
            <cfset variables.serviceUrlPath = arguments.serviceUrlPath/>
        </cfif>

        <cfset variables.acceptedStrengths = arguments.acceptedStrengths>
        <cfset variables.acceptedTicketTypes = arguments.acceptedTicketTypes>
        <cfset variables.assuranceLevel = arguments.assuranceLevel>
        <cfset variables.requestedGroups = arguments.requestedGroups>
        <cfset variables.propagateLocale = arguments.propagateLocale>
        <cfif isDefined("arguments.locale")>
            <cfinvoke method="setLocale" newLocale="#arguments.locale#"/>
        </cfif>
        <cfset variables.userDetails = arguments.userDetails>
        <cfset variables.renew = arguments.renew>
        <cfset variables.redirectOnInvalidTicket = arguments.redirectOnInvalidTicket>

        <cfset variables.proxyCallbackUrl = arguments.proxyCallbackUrl>
        <cfset variables.proxyCacheTable = arguments.proxyCacheTable>
        <cfset variables.proxyCacheDataSource = arguments.proxyCacheDataSource>

        <cfinvoke method="logging" level="Information" msg="Initialization of new ECAS client object done"/>
        <cfreturn this>
    </cffunction>

    <!---  Set the required user locale for ECAS, only useful in conjunction with propagateLocale init param set to true.
           The locale must be an ECAS supported european language in ISO-639-1 two letters code. No ColdFusion legacy locale format please.
           See metadata.supportedLocales for the known locales you can use.

           Returns the previously set locale, or empty if none previously defined.
           Throws an exception if newLocale is unknown to ECAS and throwOnError is set.
    --->
    <cffunction name="setLocale" access="public" output="no" returntype="string"
                hint="Set the ECAS required user locale as ISO-639-1 code, useful only if propagateLocale was set and if the application is registered in ECAS.">

        <cfargument name="newLocale" type="string" required="true">

        <cftry>
            <cfif NOT arrayContains(variables.supportedLocales, newlocale)>
                <cfthrow type="EcasClient" errorcode="BAD_INPUT" message="Locale '#newlocale#' is not supported by ECAS">
            </cfif>

            <cfset var oldLocale=""/>
            <cfif IsDefined("this.locale")>
                <cfset var oldLocale=this.locale/>
            </cfif>

            <cfinvoke method="logging" level="Information" msg="Setting user locale to [#newlocale#]"/>
            <cfset this.locale=newlocale/>
            <cfif oldLocale EQ "">
                <cfreturn/>
            <cfelse>
                <cfreturn oldLocale/>
            </cfif>

            <cfcatch>
                <cfinvoke method="logging" msg="Unable to set locale due to: #cfcatch.message#"/>
                <cfif variables.throwOnError>
                    <cfrethrow/>
                <cfelse>
                    <cfreturn/>
                </cfif>
            </cfcatch>
        </cftry>
    </cffunction>

    <!---   Authentication function.
            Must be called on each request.

            Takes an optional forceRenew flag, set to true to request re-authentication of logged-in users.

            Authentication process:
             - if the user was already authenticated and forceRenew is false, no further action is taken and the previous result is returned.
             - if the user is not yet authenticated and presents a ticket, the function validates the ticket with ECAS, establishing
               an SSL connection and receiving the XML validation containing user data
             - if the user is not authenticated and has no ticket or forceRenew is true, it will be redirected to the ECAS server.
               If the current browser contains a valid ECAS_TGC cookie for single sign-on, the login screen will not be presented.
               The user will be redirected after manual or automatic authentication, with a valid ticket, to this application.
             - if the user was in fact requesting a specific page with parameters (with a get), he will be redirected back
               to that specific page.
               If the user was posting a form,the FORM context is saved and re-filled on the redirection back from ECAS.
    --->
    <cffunction name="authenticate" access="public" output="no" returntype="boolean" hint="Authentication function.">

        <cfargument name="forceRenew" type="boolean" default="false"
                    hint="If true, force the user to re-authenticate even if already logged-in."/>
        <cfargument name="serviceUrlPath" required="false"
                    hint="In conjunction with a force renew and only needed if a different serviceUrlPath was defined at initialization"/>

        <cfset var failureCode=""/>
        <cfset var xmlresult=""/>
        <cfset var xml_authenticationsuccess=""/>
        <cfset var loginRequestId=""/>
        <cfset var validationUrl=""/>
        <cfset var ecasstrength=""/>

        <cftry>
            <cfif not IsDefined("this.authenticated") or arguments.forceRenew>

                <!--- No session: new user --->
                <cfinvoke method="logging" level="Information" msg="Starting user authentication"/>

                <cfif arguments.forceRenew AND IsDefined("arguments.serviceUrlPath")>
                    <cfset variables.serviceUrlPath = arguments.serviceUrlPath/>
                </cfif>

                <!--- Test if the user presents a ticket --->
                <cfif not IsDefined("url.ticket")>

                    <!--- No ticket: redirect to ECAS --->
                    <!--- save form context if any --->
                    <cfif (IsDefined("FORM") and not StructIsEmpty(FORM) and cgi.REQUEST_METHOD EQ "POST")>
                        <cfinvoke method="logging" level="Information" msg="Saving posted form before redirection"/>
                        <cfset variables.resubmitForm = Duplicate(FORM)>
                    </cfif>
                    <!--- redirect to ECAS --->
                    <cfinvoke method="logging" level="Information" msg="No ticket, negociating ECAS transaction"/>
                    <cfinvoke method="redirectToEcasLogin"  forceRenew="#arguments.forceRenew#"/>

                <cfelse>

                    <!--- Check ticket --->
                    <cfinvoke method="logging" level="Information" msg="Ticket present, let's check it"/>
                    <cfinvoke method="validateTicket"forceRenew="#arguments.forceRenew#" ticket="#url.ticket#" returnvariable="xmlresult"/>

                    <!--- Has authentication failed ? --->
                    <cfif IsDefined("xmlresult.serviceresponse.authenticationfailure")>

                        <cfset failureCode="#xmlresult.serviceresponse.authenticationfailure.xmlattributes.code#">

                        <cfif (failureCode EQ "INVALID_TICKET") OR (failureCode EQ "INVALID_STRENGTH") >
                            <cfif variables.redirectOnInvalidTicket>
                                <!--- Ticket is not good, let's try to get another one --->
                                <cfinvoke method="logging" level="Warning" msg="Invalid ticket, negociating new ECAS transaction"/>
                                <cfinvoke method="redirectToEcasLogin" forceRenew="#arguments.forceRenew#"/>
                            <cfelse>
                                <cfthrow type="EcasClient" errorcode="#failureCode#" message="Invalid ticket provided"/>
                            </cfif>
                        <cfelse>
                            <!--- Ticket validation has failed beyond recovery --->
                            <cfset this.authenticated="false">
                            <cfthrow type="EcasClient" errorcode="#failureCode#"
                                     message="ECAS returned an authentication failure : #failureCode# - #xmlresult.serviceresponse.authenticationfailure.xmltext#"/>
                        </cfif>

                    <cfelseif IsDefined("xmlresult.serviceresponse.authenticationsuccess")>

                        <!--- authentication success --->
                        <cfset xml_authenticationsuccess="#xmlresult.serviceresponse.authenticationsuccess#">

                        <!--- parse and save user data --->
                        <cfinvoke method="parseAuthenticationSuccess" xml="#xml_authenticationsuccess#"/>

                        <cfset this.authenticated="true">
                        <cfinvoke method="logging" level="Information" msg="ECAS authentication succeeded"/>

                        <!--- simulate repost of a form: restore the saved FORM context --->
                        <cfif IsDefined("Variables.resubmitForm")>
                            <cfinvoke method="logging" level="Information" msg="Recovering posted form before ECAS redirection"/>
                            <cfloop item="key" collection="#Variables.resubmitForm#">
                                <cfset StructInsert(FORM, key, Variables.resubmitForm[key])/>
                            </cfloop>
                            <cfset StructDelete(Variables, "resubmitForm")>
                        </cfif>

                    <cfelse>
                        <!--- ECAS XML result could not be parsed --->
                        <cfthrow type="EcasClient" errorcode="BAD_ECAS_XML" message="Ticket validation reply could not be parsed [#xmlresult#]">
                    </cfif>

                </cfif>

            <cfelse>
                <!--- the user is already authenticated, let's do nothing --->
                <cfinvoke method="logging" level="Information" msg="ECAS authentication already done"/>
            </cfif>

            <!--- sanity check --->
            <cfif not IsDefined("this.authenticated")>
                <cfinvoke method="logging" level="Fatal" msg="Internal ECAS client error: authenticated flag should be set"/>
                <cfabort showError="Internal ECAS client error: authenticated flag should be set">
            </cfif>

            <cfcatch>
                <cfset this.authenticated = false/>
                <cfinvoke method="logging" msg="Authentication failed due to: #cfcatch.message#"/>
                <cfset this.errorCode = cfcatch.errorcode/>
                <cfset this.errorMessage = cfcatch.message/>
                <cfif variables.throwOnError>
                    <cfrethrow/>
                </cfif>
            </cfcatch>
        </cftry>
        <cfreturn this.authenticated>
    </cffunction>


    <!--- Check if the authenticated user is member of the given group.
          Note: don't forget to request the groups you will need to check in the init() function's "requestedGroups" argument.
     --->
    <cffunction name="isInGroup" access="public" output="no" returntype="boolean"
                hint="Check if the authenticated user is member of the given group">

        <cfargument name="group" type="string" required="true">

        <cfif NOT IsDefined("this.groups") OR arraylen(this.groups) EQ 0>
            <cfinvoke method="logging" level="Information" msg="User has no group"/>
            <cfreturn false>
        </cfif>

        <cfreturn arrayFind(this.groups, arguments.group)/>
    </cffunction>


    <!---   Proxy Call Back, for proxy authentication only.
            Must be made accessible from ECAS through an encrypted (https) un-authenticated (public) url.

            On authentication with the proxy mechanism, ECAS will call back this URL to provide a proxy granting ticket (PGT) for the user.
            This PGT is encrypted and store in database (available to all cluster members) in order to later obtain proxy tickets for this user.
    --->
    <cffunction name="proxyCallback" access="public" returnType="string" output="no"
                hint="Store a Proxy Granting Ticket sent by ECAS for an authenticated user">

        <cfargument name="pgtId" required="true"/>
        <cfargument name="pgtIou" required="true"/>

        <cfset var pgtIouHash = ""/>
        <cfset var pgtIouToken = ""/>
        <cfset var key = ""/>
        <cfset var pgtIdCrypt = ""/>
        <cfset var proxySuccess = ""/>

        <cftry>

            <!--- allow use of unsafe cache (like a db): encrypt pgtId with pgtIou as key and use hash of the pgtIou as primary key --->
            <cfset pgtIouHash = Hash(Hash(pgtIou, "SHA-256"), "SHA-256")>
            <!--- extract the 18 first bytes from the random part of the pgtIou --->
            <cfset pgtIouToken = ToBinary(Left(GetToken(arguments.pgtIou,3,"-"), 24))/>
            <!--- reduce to AES key size: 128 bits or 16 bytes --->
            <cfset key = BinaryDecode(Left(BinaryEncode(pgtIouToken, "HEX"), 32), "HEX")/>
            <!--- encryption --->
            <cfset pgtIdCrypt = Encrypt(pgtId, ToBase64(key), "AES/CBC/PKCS5Padding", "Base64")/>

            <cfquery dataSource="#variables.proxyCacheDataSource#">
                INSERT INTO #variables.proxyCacheTable# (PGTIOU, PGTID, CREATIONDATE) VALUES (
                <cfqueryparam value="#pgtIouHash#" CFSQLType="CF_SQL_VARCHAR"/>,
                <cfqueryparam value="#pgtIdCrypt#" CFSQLType="CF_SQL_VARCHAR"/>,
                <cfqueryparam value="#now()#" CFSQLType="CF_SQL_TIMESTAMP"/>)
            </cfquery>

            <cfxml variable="proxySuccess">
                <proxySuccess xmlns="http://www.yale.edu/tp/casClient"/>
            </cfxml>

            <cfinvoke method="logging" level="Information" msg="Received and cached a proxy granting ticket from ECAS"/>

            <cfreturn "#toString(proxySuccess)#">

            <cfcatch>
                <cfinvoke method="logging" msg="Callback failed due to #cfcatch.type# - #cfcatch.message#[#cfcatch.errorcode#]"/>
                <cfset this.errorCode = cfcatch.errorcode/>
                <cfset this.errorMessage = cfcatch.message/>
                <cfif variables.throwOnError>
                    <cfrethrow/>
                <cfelse>
                    <cfreturn "Callback failed: #cfcatch.type# - #cfcatch.message#[#cfcatch.errorcode#]"/>
                </cfif>
            </cfcatch>
        </cftry>
    </cffunction>


    <!---   Get a proxy ticket, for proxy authentication only.
            Used to request a proxy ticket from ECAS. This ticket can then be used to invoke a third party service in the name of this user.
            Return null in case of error, check the log file for more information.

            Proxy ticket is valid for only one use and for a limited period of time.
            Target service URL must be specified as the proxy ticket will only be valid to use with this service.
    --->
    <cffunction name="getProxyTicket" access="public" returnType="string" output="no"
                hint="Get a Proxy Ticket for an authenticated user and a target service">

        <cfargument name="targetServiceUrl" required="true"/>

        <cfset var pgtIouHash = ""/>
        <cfset var pgtIouToken = ""/>
        <cfset var key = ""/>
        <cfset var pgtIdCryptQuery = ""/>
        <cfset var proxyParams = ""/>
        <cfset var xmlresult = ""/>

        <cftry>
            <cfif not IsDefined("this.authenticated")>
                <cfthrow type="EcasClient" message="Can't get a proxy ticket for an unauthenticated session" >
            </cfif>

            <cfinvoke method="logging" level="Information" msg="Requesting a proxy ticket for service: #arguments.targetServiceUrl#"/>

            <cfif not IsDefined("variables.pgtId")>

                <!--- no pgtId in variables for this user, check in cache --->
                <cfinvoke method="logging" level="Information" msg="No pgtId in session, check in cache"/>
                <cfif not IsDefined("variables.pgtIou")>
                    <cfthrow type="EcasClient" message="Can't get a proxy ticket without PGTIOU for user '#this.userid#'" >
                </cfif>

                <!--- Use the pgtIou to retrieve the pgtId from cache --->
                <cfset pgtIouHash = Hash(Hash(variables.pgtIou, "SHA-256"), "SHA-256")>

                <cfquery name="pgtIdCryptQuery" dataSource="#variables.proxyCacheDataSource#" maxRows="1">
                    SELECT PGTID FROM #variables.proxyCacheTable# WHERE PGTIOU =
                    <cfqueryparam value="#pgtIouHash#" CFSQLType="CF_SQL_VARCHAR"/>
                </cfquery>

                <!--- cleanup db from unclaimed tickets (older than 1 day) --->
                <cfquery dataSource="#variables.proxyCacheDataSource#">
                    DELETE FROM #variables.proxyCacheTable# WHERE CREATIONDATE <
                    <cfqueryparam value="#DateAdd('h', -24, now())#" CFSQLType="CF_SQL_TIMESTAMP"/>
                </cfquery>

                <cfif pgtIdCryptQuery.RecordCount EQ 0>
                    <cfthrow type="EcasClient" message="Unable to find pgtId in cache for user '#this.userid#'" >
                </cfif>

                <!--- remove this pgtid from db as it will be kept in session --->
                <cfquery dataSource="#variables.proxyCacheDataSource#">
                    DELETE FROM #variables.proxyCacheTable# WHERE PGTIOU =
                    <cfqueryparam value="#pgtIouHash#" CFSQLType="CF_SQL_VARCHAR"/>
                </cfquery>

                <cfset pgtIouToken = ToBinary(Left(GetToken(variables.pgtIou,3,"-"), 24))/>
                <cfset key = BinaryDecode(Left(BinaryEncode(pgtIouToken, "HEX"), 32), "HEX")/>
                <!--- decode the pgtId and store it locally to avoid unnecessary db accesses--->
                <cfset variables.pgtId = Decrypt(pgtIdCryptQuery.PGTID, ToBase64(key), "AES/CBC/PKCS5Padding", "Base64")/>

                <cfinvoke method="logging" level="Information" msg="Retrieved pgtId from cache"/>
            </cfif>

            <!--- query ECAS for proxy ticket --->
            <cfset proxyParams = {
                "targetService" = "#arguments.targetServiceUrl#",
                "pgt" = "#variables.pgtId#"
            }/>
            <cfinvoke method="postToEcas" url="#variables.ecasProxyUrl#" params="#proxyParams#" returnvariable="xmlresult"/>

            <cfif IsDefined("xmlresult.serviceresponse.proxySuccess")>

                <cfinvoke method="logging" level="Information" msg="Successfully received a proxy ticket for  target service: #arguments.targetServiceUrl#"/>
                <cfreturn "#xmlresult.serviceresponse.proxySuccess.proxyTicket.xmltext#"/>

            <cfelseif IsDefined("xmlresult.serviceresponse.proxyFailure")>

                <cfthrow type="EcasClient" errorcode="#xmlresult.serviceresponse.proxyFailure.xmlattributes.code#"
                         message="Proxy failure response: #xmlresult.serviceresponse.proxyFailure.xmltext#"/>

            <cfelse>
                <!--- ECAS XML reply could not be parsed --->
                <cfthrow type="EcasClient" errorcode="BAD_ECAS_XML" message="Proxy ticket reply could not be parsed [#xmlresult#]"/>
            </cfif>

            <cfcatch>
                <cfinvoke method="logging" msg="Unable to obtain proxy ticket due to #cfcatch.type# - #cfcatch.message#[#cfcatch.errorcode#]"/>
                <cfset this.errorCode = cfcatch.errorcode/>
                <cfset this.errorMessage = cfcatch.message/>
                <cfif variables.throwOnError>
                    <cfrethrow/>
                <cfelse>
                    <cfreturn/>
                </cfif>
            </cfcatch>
        </cftry>
    </cffunction>


    <!--- Internal functions --->
    <cffunction name="redirectToEcasLogin" access="private" output="no">

        <cfargument name="forceRenew" type="boolean" default="false">

        <cfset var xmlresult=""/>
        <cfset var loginRequestId=""/>

        <!--- build structure with all configuration parameters for ECAS --->
        <cfset var loginRequestParams = {
            "service" = "#buildServiceUrl()#",
            "acceptStrengths" = "#variables.acceptedStrengths#"
        }/>

        <cfif variables.renew OR arguments.forceRenew>
            <cfset val=StructInsert(loginRequestParams, "renew", "true")>
        </cfif>
        <cfif variables.propagateLocale AND isdefined("this.locale")>
            <cfset val=StructInsert(loginRequestParams, "locale", this.locale)>
        </cfif>

        <cfinvoke method="postToEcas" url="#variables.ecasInitLoginUrl#" params="#loginRequestParams#" returnvariable="xmlresult"/>

        <!--- Do we have a login request token ? --->
        <cfif IsDefined("xmlresult.loginRequest.loginRequestSuccess.loginRequestId")>
            <cfset loginRequestId=xmlresult.loginRequest.loginRequestSuccess.loginRequestId.xmltext />
            <cfinvoke method="logging" level="Information" msg="Successfully received a login transaction id: #left(loginRequestId, 30)#..."/>
        <cfelse>
            <!--- ECAS XML reply could not be parsed --->
            <cfthrow type="EcasClient" errorcode="BAD_ECAS_XML" message="Login transaction reply could not be parsed [#xmlresult#]"/>
        </cfif>

        <cfset var loginUrl=variables.ecasLoginUrl/>
        <cfinvoke method="addUrlAttribute" returnVariable="loginUrl" url="#loginUrl#" attributeKey="loginRequestId" attributeValue="#loginRequestId#"/>
        <cfinvoke method="logging" level="Information" msg="Redirecting user to ECAS"/>
        <cfheader name="location" value="#loginUrl#">
        <cfheader statusCode="302" statusText="Document Moved">
        <cfabort>
    </cffunction>


    <cffunction name="validateTicket" access="private" output="no" returnType="xml">

        <cfargument name="ticket" type="string" required="true">
        <cfargument name="forceRenew" type="boolean" default="false">

        <!--- build structure with all configuration parameters for ECAS --->
        <cfset var ticketValidationParams = {
            "ticket" = "#ticket#",
            "service" = "#buildServiceUrl()#",
            "ticketTypes" = "#variables.acceptedTicketTypes#",
            "assuranceLevel" = "#variables.assuranceLevels[variables.assuranceLevel]#",
            "groups" = "#variables.requestedGroups#",
            "acceptStrengths" = "#variables.acceptedStrengths#"
        }/>

        <cfif variables.userDetails>
            <cfset val=StructInsert(ticketValidationParams, "userDetails", "true")>
        </cfif>
        <cfif variables.proxyCallbackUrl NEQ "">
            <cfset val=StructInsert(ticketValidationParams, "pgtUrl", "#variables.proxyCallbackUrl#")>
        </cfif>
        <cfif variables.renew OR arguments.forceRenew>
            <cfset val=StructInsert(ticketValidationParams, "renew", "true")>
        </cfif>

        <cfinvoke method="postToEcas" url="#variables.ecasValidateUrl#" params="#ticketValidationParams#" returnvariable="xmlresult"/>

        <cfreturn xmlresult>
    </cffunction>


    <cffunction name="buildServiceUrl" access="private" output="no" returntype="string">

        <cfset var requestedurl="">
        <cfset var cleanquerystring="">

        <!--- remove any existing ticket from the query string --->
        <cfset cleanquerystring="#REReplace(cgi.QUERY_STRING,"(^|&)ticket=(\w|_|-)*", "")#"/>

        <!--- build service url with given path or cgi.SCRIPT_NAME if no path provided --->
        <cfif IsDefined("variables.serviceUrlPath")>
            <cfinvoke method="assembleUrl" domain="#variables.serviceUrl#" path="#variables.serviceUrlPath#" query="#cleanquerystring#" returnvariable="requestedurl"/>
        <cfelse>
            <cfinvoke method="assembleUrl" domain="#variables.serviceUrl#" path="#cgi.SCRIPT_NAME#" query="#cleanquerystring#" returnvariable="requestedurl"/>
        </cfif>
               
		<!--- ajout pour la BASE BLEUE --->		
        <cfif findNocase(cgi.SCRIPT_NAME,'/dispo-extranet/CANDIDATES/LOGIN/receive_email_confirm_match_app.cfm')> 
           <cfset requestedurl="#variables.serviceUrl##Replace(cgi.SCRIPT_NAME, "/dispo-extranet/CANDIDATES/LOGIN/receive_email_confirm_match_app.cfm", "")#">
        <cfelseif findNocase(cgi.SCRIPT_NAME,'/dispo-extranet/CANDIDATES/LOGIN/receive_email_confirm.cfm')>
           <cfset requestedurl="#variables.serviceUrl##Replace(cgi.SCRIPT_NAME, "/dispo-extranet/CANDIDATES/LOGIN/receive_email_confirm.cfm", "")#">
        <cfelse>
          <!---  <cfset requestedurl="#variables.serviceUrl##Replace(cgi.SCRIPT_NAME, "dispo-extranet/CANDIDATES/", "")#"> --->
          <cfset requestedurl="#variables.serviceUrl##Replace(cgi.SCRIPT_NAME, "dispo-extranet/", "")#">
        </cfif> 

        <cfinvoke method="logging" level="Information" msg="Service URL build: #requestedurl#"/>
        <cfreturn requestedurl>
    </cffunction>

    <cffunction name="assembleUrl" access="private" output="no" returntype="string">
        <cfargument name="domain" required="true" hint="With the protocol please"/>
        <cfargument name="path" required="true"/>
        <cfargument name="query" required="false"/>

        <cfset var resultUrl = "#REReplace(trim(domain), "/$", "")#/#REReplace(trim(path), "^/", "")#"/>
        <cfif isdefined("query") AND len(trim(query)) NEQ 0>
            <cfset resultUrl = "#REReplace(trim(resultUrl), "\?$", "")#?#query#"/>
        </cfif>

        <cfreturn resultUrl/>
    </cffunction>

    <cffunction name="addUrlAttribute" access="private" returnType="string">

        <cfargument name="url" required="true">
        <cfargument name="attributeKey" required="true">
        <cfargument name="attributeValue" required="true">

        <cfset var newUrl=arguments.url>

        <cfif Find("?", arguments.url) GT 0>
            <cfif Find("?", arguments.url) NEQ Len(arguments.url)>
                <cfset newUrl = arguments.url & "&">
            </cfif>
        <cfelse>
            <cfset newUrl = arguments.url & "?">
        </cfif>

        <cfset newUrl = newUrl & arguments.attributeKey & "=" & arguments.attributeValue>

        <cfreturn newUrl>
    </cffunction>


    <cffunction name="postToEcas" access="private" output="no" returntype="xml"
            hint="Send an http request (POST) to the given ECAS url with the optional form content. Return the reply as XML object">

        <cfargument name="url" required="true" type="string">
        <cfargument name="params" required="false" type="struct">

        <cfset var xmlresult="">

        <cfinvoke method="logging" level="Information" msg="Sending POST request to ECAS (#url#)"/>
        <cfhttp url="#url#"
                method="POST"
                charset="utf-8"
                redirect="no"
                resolveurl="no"
                throwonerror="no"
                timeout="10"
                userAgent="#variables.useragent#"
                result="ecasResponse">
            <cfhttpparam type="Header" name="Accept" value="text/xml"/>
            <cfhttpparam type="Header" name="Accept-Charset" value="utf-8"/>
            <!--- avoid any compression of the response, for intermediate reverse proxies with bugged implementation --->
            <cfhttpparam type="Header" name="Accept-Encoding" value="identity;q=1.0, deflate;q=0, gzip;q=0, compress;q=0, x-gzip;q=0, x-compress;q=0, *;q=0"/>
            <cfhttpparam type="Header" name="TE" value="identity;q=1.0, deflate;q=0, gzip;q=0, compress;q=0, *;q=0"/>
            <cfhttpparam type="Header" name="Cache-Control" value="no-cache,no-store,no-transform"/>
            <cfhttpparam type="Header" name="Pragma" value="no-cache"/>

            <cfif isDefined("params")>
                <cfloop collection="#params#" item="name">
                    <cfhttpparam type="formfield" name="#name#" value="#params[name]#"/>
                </cfloop>
            </cfif>
        </cfhttp>

        <cfif variables.debug>
            <cfset this.debug="#ecasResponse.FileContent#">
        </cfif>

        <!--- Is ECAS answer valid ? --->
        <cfif Left(ecasResponse.statuscode,6) EQ "200 OK">
            <!--- Parse ECAS XML result --->
            <cfset var xmlresult=XmlParse(Replace(ecasResponse.FileContent,"cas:","","all"))/>
        <cfelse>
            <!--- Invalid ECAS http reply --->
            <cfthrow type="EcasClient"  errorcode="BAD_ECAS_HTTP"
                     message="Not a valid ECAS HTTP reply: #ecasResponse.statuscode# - #ecasResponse.errordetail#"/>
        </cfif>
        <cfreturn xmlresult/>
    </cffunction>


    <cffunction name="parseAuthenticationSuccess" access="private" output="no">

        <cfargument name="xml" required="yes" type="xml"/>

        <cfinvoke method="logging" level="Information" msg="Parsing authentication success"/>
        <cfset var groupsXml=""/>

        <!--- save user data --->
        <cfset this.userid="#xml.user.xmltext#">
        <cfset this.logindate="#xml.logindate.xmltext#">

        <cfset groupsXml=xmlsearch(xml,"//group")>
        <cfset this.groups = ArrayNew(1)/>
        <cfloop index="i" from="1" to="#ArrayLen(groupsXml)#">
            <cfset this.groups[i]=groupsXml[i].xmltext/>
        </cfloop>

        <!--- save user details if requested and available --->
        <cfif variables.userDetails>
            <cfif IsDefined("xml.departmentNumber")>
                <cfset this.departmentNumber="#xml.departmentNumber.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.email")>
                <cfset this.email="#xml.email.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.employeeType")>
                <cfset this.employeeType="#xml.employeeType.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.firstName")>
                <cfset this.firstname="#xml.firstName.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.lastName")>
                <cfset this.lastname="#xml.lastName.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.domain")>
                <cfset this.domain="#xml.domain.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.domainUsername")>
                <cfset this.domainUsername="#xml.domainUsername.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.telephoneNumber")>
                <cfset this.telephoneNumber="#xml.telephoneNumber.xmltext#"/>
            </cfif>
            <cfif IsDefined("xml.userManager")>
                <cfset this.userManager="#xml.userManager.xmltext#"/>
            </cfif>
            <cfif isDefined("xml.locale")>
                <cfset this.locale="#xml.locale.xmltext#"/>
            </cfif>
        </cfif>

        <!--- save pgtIou for later proxy authentication --->
        <cfif IsDefined("xml.proxyGrantingTicket")>
            <cfset variables.pgtIou="#xml.proxyGrantingTicket.xmltext#"/>
            <cfinvoke method="logging" level="Information" msg="Authentication reply contains a pgtIou"/>
        </cfif>

    </cffunction>


    <cffunction name="logging" access="private">

        <cfargument name="level" default="Error" required="no">
        <cfargument name="msg" required="yes">

        <cfif variables.debug>
            <cfif IsDefined("this.userid")>
                <cflog text="[#this.userid#] #msg#" type="#level#" file="#variables.loggingFile#">
            <cfelse>
                <cflog text="#msg#" type="#level#" file="#variables.loggingFile#">
            </cfif>
        </cfif>
    </cffunction>

</cfcomponent>
