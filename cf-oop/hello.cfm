<cfset objGreeting=createObject('component', 'greetings' ) />
<cfoutput>#objGreeting.sayHello()#</cfoutput>

<!--- instatiate the component --->
<cfset objGreeting=createObject('component', 'greetings' ) />

<!--- access the method and assign results to a string --->
<cfset strPersonalGreeting=objGreeting.personalGreeting(firstName="Gary" , lastName="Brown" ) />
<cfoutput>#strPersonalGreeting#</cfoutput>