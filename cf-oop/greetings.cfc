<cfcomponent displayName="greetings">

    <cffunction name="sayHello">
        <cfset var strHelloMessage="Hello World!" />
        <cfreturn strHelloMessage />
    </cffunction>

    <cffunction name="getName">
        <cfargument name="firstName" type="string" />
        <cfargument name="lastName" type="string" />
        <cfset var strFullName=arguments.firstName & ' ' & arguments.lastName />
        <cfreturn strFullName />
    </cffunction>

    <cffunction name="personalGreeting">
        <cfargument name="firstName" type="string" />
        <cfargument name="lastName" type="string" />
        <cfscript>
            strHello = sayHello();
            strFullName = getName(firstName = arguments.firstName, lastName = arguments.lastName);
            strHelloMessage = strHello & ' My name is ' & strFullName;
        </cfscript>
        <cfreturn strHelloMessage />
    </cffunction>

</cfcomponent>