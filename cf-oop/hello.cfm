<cfset objGreeting = createObject('component', 'greetings') />
<cfoutput>#objGreeting.sayHello()#</cfoutput>