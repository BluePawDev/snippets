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

    <cfoutput>
        <cffunction name="baseNumber" returnType="numeric">
            <cfargument name="a" type="numeric" required="true" />
            <cfset var x=arguments.a />
            <cfreturn x />
        </cffunction>

        <cffunction name="multiplyNumbers" returnType="string">
            <cfargument name="a" type="numeric" required="true" />
            <cfargument name="b" type="numeric" required="true" />
            <!--- multiply basenumber value by 10 --->
            <cfset var x=10 />
            <cfset var y=baseNumber(a) />
            <cfreturn y & " multiplied by " & x & " = " & x * arguments.b />
        </cffunction>

        <cfloop from="1" to="10" index="i">
            #multiplyNumbers(i,i)#<br />
        </cfloop>
    </cfoutput>

</cfcomponent>