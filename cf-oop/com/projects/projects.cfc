<cfcomponent name="Projects" output="false">
    <!--- pseudo contructor code here --->
    <cfset this.dsn="projectTracker" />
    Our datasource is #this.dsn#
    <!--- function to get the current date --->
    <cffunction name="getCurrentDate" output="false" returnType="date">
        <cfreturn dateFormat(now(), "dd/mm/yyy" ) />
    </cffunction>
</cfcomponent>