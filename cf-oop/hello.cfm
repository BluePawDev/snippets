<cfset objGreeting=createObject('component', 'greetings' ) />
<cfoutput>#objGreeting.sayHello()#</cfoutput>

<!--- instatiate the component --->
<cfset objGreeting=createObject('component', 'greetings' ) />

<!--- access the method and assign results to a string --->
<cfset strPersonalGreeting=objGreeting.personalGreeting(firstName="Gary" , lastName="Brown" ) />
<cfoutput>#strPersonalGreeting#</cfoutput>



<cfinvoke component="greetings" method="sayHello" returnVariable="strHello" />
    <cfinvokeargument name="firstName" value="Matt" />
    <cfinvokeargument name="lastName" value="James" />
</cfinvoke>
<cfoutput>#strHello#</cfoutput>

    <!--- **** OR...using attributes as arguments **** --->

<cfinvoke component="greetings" method="personalGreeting" firstName="Gary" lastName="Brown" returnVariable="strPersonalGreeting" />

    <!--- **** OR...using an argument collection **** --->

<cfscript>
    // creat structure to hold values
    stuArguments = structNew();
    stuArguments.firstName = "James";
    stuArguments.lastName = "Brown";
</cfscript>
<cfinvoke component="greetings" method="personalGreeting" argumentCollection="#stuArguments#" returnVariable="strPersonalGreeting"