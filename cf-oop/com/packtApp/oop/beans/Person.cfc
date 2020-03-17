<cfcomponent displayname="Person" output="false" hint="Person Class">
    <cfproperty name="firstName" type="string" default=""/>
    <cfproperty name="lastName" type="string" default=""/>
    <cfporperty name="gender" type="string" default=""/>
    <cfproperty name="dob" type="string" default=""/>
    <cfproperty name="hairColor" type="string" default=""/>

    <!--- pseudo-constructor --->
    <cfset variables.instance = {
        firstName = '',
        lastName = '',
        gender = '',
        dob = '',
        hairColor = ''
    }/>

    <cffunction name="init" access="public" output="false" returntype="any" hint="Constructor method for Person Class">
        <cfargument name="firstName"    required="true" type="string" default="" hint="First name argument for Person Class"/>
        <cfargument name="lastName"     required="true" type="string" default="" hint="Last name argument for Person Class"/>
        <cfargument name="gender"       required="true" type="string" default="" hint="Gender argument for Person Class"/>
        <cfargument name="dob"          required="true" type="string" default="" hint="Date of birth argument for Person Class"/>
        <cfargument name="hairColor"    required="true" type="string" default="" hint="Hair color argument for Person Class"/>

        <!--- set bean initial values --->
        <cfscript>
            setFirstName(arguments.firstName);
            setLastName(arguments.lastName);
            setGender(arguments.gender);
            setDOB(arguments.dob);
            setHairColor(arguments.hairColor);
        </cfscript>

        <cfreturn this />
    </cffunction>


    <!--- setters --->
    <cffunction name="setFirstName" access="public" output="false" hint="Sets the first name into the variables.instance scope">
        <cfargument name="firstName" required="true" type="string" hint="Person's first name" />
        <cfset variables.instance.firstName = arguments.firstName/>
    </cffunction>

    <cffunction name="setLastName" access="private" output="false" hint="Sets the last name into the variables.instance scope">
        <cfargument name="lastName" required="true" type="string" hint="Person's last name" />
        <cfset variables.instance.lastName = arguments.lastName/>
    </cffunction>

    <cffunction name="setGender" access="private" output="false" hint="Sets the gender into the variables.instance scope">
        <cfargument name="gender" required="true" type="string" hint="Person's gender" />
        <cfset variables.instance.gender = arguments.gender/>
    </cffunction>

     <cffunction name="setDOB" access="private" output="false" hint="Sets the date of birth into the variables.instance scope">
        <cfargument name="dob" required="true" type="string" hint="Person's date of birth" />
        <cfset variables.instance.dob = arguments.dob/>
    </cffunction>

    <cffunction name="setHairColor" access="private" output="false" hint="Sets the hair color into the variables.instance scope">
        <cfargument name="hairColor" required="true" type="string" hint="Person's hair color" />
        <cfset variables.instance.hairColor = arguments.hairColor/>
    </cffunction>


    <!--- getters --->
    <cffunction name="getFirstName" access="public" output="false" hint="Returns the first name">
        <cfreturn variables.instance.firstname />
    </cffunction>

    <cffunction name="getLastName" access="public" output="false" hint="Returns the last name">
        <cfreturn variables.instance.lastName />
    </cffunction>

    <cffunction name="getGender" access="public" output="false" hint="Returns the gender">
        <cfreturn variables.instance.gender />
    </cffunction>

    <cffunction name="getDOB" access="public" output="false" hint="Returns the date of birth">
        <cfreturn variables.instance.dob />
    </cffunction>

    <cffunction name="getHairColor" access="public" output="false" hint="Returns the hair color">
        <cfreturn variables.instance.hairColor />
    </cffunction>
</cfcomponent>