# Configuring a Site with Sentry Bug Tracking


A site must have a project within Sentry. If there is no project one will need to be created. To create the project follow the following steps within Sentry:

1. Click _Projects_ in the panel along the left side of the screen.
2. Click the _Add New_ button in the top right-hand corner and select _Project_.
3. Select _Java_ for the Language/Framework.
4. Enter in the name of your project.
5. Select the appropriate team.
6. Click create project.

Once a project is created you will need the DSN information in order to set it up correctly in the code. Follow the steps below within Sentry to get the DSN:

1. Click on _Projects_ in the panel along the left side of the screen.
2. Click on the project you need.
3. Click Settings in the top menu.
4. Click _Client Keys (DSN)_ in the menu on the left side of the screen.
5. Use the _DSN_ value in the directions below.

Coldfusion

The website code now needs to be modified to incorporate the sentry information. To do this, follow the steps below:

1. In **A**** pplication.cfc**:
  1. **onApplicationStart()**
    1. Add this code before **load**** CFC ****s** call:

application.sentry = new vansonbase.model.sentry(

release   : &quot;1.0.2&quot;,

environment : application.environment,

DSN  : &quot;[https://cf2b602eca324f3ba463d2987bba84d8@sentry.vts0.com/6&quot;](https://cf2b602eca324f3ba463d2987bba84d8@sentry.vts0.com/6%22%C2%B6)

);

**Note** : DSN is obtained from Sentry client. Use the non-deprecated DSN; as of 12/7/2018 Vansonbase has been updated.

1.
  1. **onError**
    1. Replace the onError function with this code:

  \&lt;cfscript\&gt;

    /\*\*

           \* &quot;Runs when an uncaught exception occurs in the application.&quot;

           \* @Exception &quot;The ColdFusion Exception object. For information on the structure of this object, see the description of the cfcatch variable in the cfcatch description.&quot;

           \* @EventName &quot;The name of the event handler that generated the exception. If the error occurs during request processing and you do not implement an onRequest method, EventName is the empty string.&quot;

           \*\*/

    public void function onError(required any exception, required string eventName){

      param name=&#39;request.prs&#39; default=&#39;&#39;;

      if( isDefined(&quot;application.environment&quot;) AND ListFindNoCase(application.environment,&quot;production&quot;)){

        if(structKeyExists(application,&quot;sentry&quot;)){

          application.sentry.captureException(

            exception : arguments.exception,

            additionalData       : {

              &quot;session&quot; : session,

              &quot;server&quot;: server,

              &quot;prs&quot;: request.prs

            },

            cgiVars           : cgi

          );

        }

      }

      if (cgi.script\_name CONTAINS &quot;/Admin/&quot;){

        include &quot;/admin/templates/ServerErrors/500.cfm&quot;;

      } else {

        include &quot;/templates/ServerErrors/500.cfm&quot;;

      }

      return;

    }

  \&lt;/cfscript\&gt;

2. In any CFC template containing a try/catch construct:

  a. in the init function (NOTE: If the CFC does not have an init function, one needs to be added):

    i. Add this code:

\&lt;cfargument name=&quot;sentryClient&quot; type=&quot;sentry&quot; required=&quot;true&quot;\&gt;

                \&lt;cfset variables.sentryClient = arguments.sentryClient\&gt;

  b. Send the application.sentry into the component upon initialization in loadCFCs

    i. Add application.sentry to the cfc intializations.

(ex. \&lt;cfset local.service.userGroup = new userGroup.userGroupService( new userGroupData(application.dsn, **application.sentry** )) /\&gt;)

  c. in the catch block

    i. Add this code:

      \&lt;!--- Capture an exception ---\&gt;

   \&lt;cfset variables.sentryClient.captureException(cfcatch)\&gt;

3. In any CFML template (cfm) containing a try/catch construct:

  a. in the catch block

    i. Add this code:(NOTE: This is cfscript and must be enclosed in cfscript. If you are not already within a cfscript block, you will need to add the \&lt;cfscript\&gt;\&lt;/cfscript\&gt; tags around the block below)

      application.sentry.captureException(

          exception : except,

          additionalData       : {

            &quot;session&quot; : session,

            &quot;server&quot;: server,

            &quot;prs&quot;: request.prs

          },

          cgiVars : cgi

      );

4. Remove the cfmail code from the admin/templates/ServerErrors/500.cfm (if it exists). This was causing a duplication of reporting of issues.

5. Conti Motorcycle also sends an alert to Sentry if no Active MemberStatus is found

  a.

application.sentry.captureMessage(

exception : &quot;No active member status with name the &#39;Active&#39; exists in the [dbo].[MemberStatus] table&quot;,

additionalData : {

&quot;session&quot;: session,

&quot;server&quot;: server,

&quot;prs&quot;: request.prs,

&quot;member&quot;: request.memberApp

      },

      cgiVars : cgi

    );

  (see **ctrlr-register.cfm** in Conti Motorcycle for details)

**JavaScript**

We also need to add Raven so that javascript errors are caught and reported in sentry. In order to do this, we need to have the raven CDN be the first script include on the site. To ensure this, all javascript within the page should be run together as part of the layout footer. To set this all up, follow the steps below:

1. **Application.cfc**
  1. In the onRequestStart function add:

request.footerJS = [];  // used for JavaScript in the page footer above the HTML body tags

1. includes/layout-js-deps.cfm
  1. If it does not already exist, create the layout-js-deps.cfm file in the includes directory.
  2. Add the code below to the file:

\&lt;cfoutput\&gt;

  \&lt;cfif structKeyExists(request, &quot;footerJS&quot;) and isArray(request.footerJS) \&gt;

    \&lt;cfloop array=&quot;#request.footerJS#&quot; index=&quot;pagejs&quot;\&gt;

            #pagejs#

          \&lt;/cfloop\&gt;

         \&lt;/cfif\&gt;

\&lt;/cfoutput\&gt;

1. All Javascript. **Note** : This assumes that all JavaScript is on pages that include **layout.cfm**. Please ensure that **layout.cfm** will be included as part of displaying the page. If **cfmodule** is used, ensure that your JavaScript comes before the close cfmodule tag.
  1. Move any **\&lt;script src=&quot;...** tags to the **includes/layout-js-dep.cfm** file. They should be between the **\&lt;cfoutput\&gt;** and the **\&lt;cfif\&gt;** tags, so starting on line 2. You can also eliminate any duplicates. **Note** : do not move style sheets; style sheets use **\&lt;link\&gt;** tags.)
  2. Around the **\&lt;script\&gt;\&lt;/script\&gt;** tags on the pages, add:

\&lt;cfsavecontent variable=&quot;pagejs&quot;\&gt;\&lt;/cfsavecontent\&gt; tags.

1.
  1. After the **\&lt;/cfsavecontent\&gt;** tag added in part b, add

\&lt;cfset arrayAppend(request.footerjs, pagejs) /\&gt;

1. **layout-js-deps.cfm**
  1. Add the raven CDN to the list of \&lt;script src= lines.

\&lt;script src=&quot;https://cdn.ravenjs.com/3.26.4/raven.min.js&quot; crossorigin=&quot;anonymous&quot;\&gt;\&lt;/script\&gt;

1.
  1. Add the following javascript before the **\&lt;cfif\&gt;** tag

\&lt;cfif isDefined(&quot;application.environment&quot;) AND ListFindNoCase(application.environment,&quot;production&quot;)\&gt;

  Raven.config(&#39;https://7ad49c1012d74635ba462c1fcc0cd3c1@sentry.vts0.com/14&#39;).install()

  \&lt;cfif structKeyExists(request, &quot;userApp&quot;)\&gt;

    Raven.setUserContext({

      email: &#39;#encodeForJavaScript(request.userapp.emailAddress)#&#39;,

      id: &#39;#encodeForJavaScript(request.userapp.userId)#&#39;

    });

  \&lt;cfelse\&gt;

    \&lt;cfif structKeyExists(request, &quot;memberApp&quot;)\&gt;

      Raven.setUserContext({

        email: &#39;#encodeForJavaScript(request.memberApp.emailAddress)#&#39;,

        id: &#39;#encodeForJavaScript(request.memberApp.memberId)#&#39;

      });

    \&lt;/cfif\&gt;

  \&lt;/cfif\&gt;

\&lt;/cfif\&gt;

**Warning** : when adding the Raven code above, be sure to consider your environment, i.e. **request.userapp** usually does not exist on a member site unless you are impersonating.

1.
  1. Replace the content of the **config** function with the DSN found in sentry for the project you are working.Refer to the directions from Setup above to get the DSN)

1. Include **layout-js-deps.cfm**
  1. **layout.cfm** or **layout\_end.cfm** , this will need to be done in both the **admin** and **member** layouts)
    1. Include the **includes/layout-js-deps.cfm** file before the closing **\&lt;/body\&gt;** tag, but after all the JavaScript (you may need to change the path):

\&lt;cfinclude template=&quot;../includes/layout-js-deps.cfm&quot;\&gt;

1.
  1. Pages that did not include **layout.cfm**
    1. Include the **includes/layout-js-deps.cfm** file before the closing **\&lt;/body\&gt;** tag, but after any JavaScript (you may need to change the path):

\&lt;cfinclude template=&quot;includes/layout-js-deps.cfm&quot;\&gt;