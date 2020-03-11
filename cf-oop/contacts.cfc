<cfcomponent name="contacts">
    <cffunction name="init">
        <cfargument name="datasource" type="string" required="true" />
        <cfscript>
            variables.attributes = structNew();
            variables.attributes.dsn = arguments.datasource;
        </cfscript>
        <cfreturn this />
    </cffunction>

    <!--- **** returns recordset of all contacts **** --->
    <cffunction name="getContacts">
        <cfset var rstContacts="" />
        <cfquery name="rstContacts" datasource="projectTracker">
            SELECT firstName, lastName
            FROM Owners
        </cfquery>
        <cfreturn rstContacts />
    </cffunction>


    <!--- **** returns single record based on ID of contact **** --->
    <cffunction name="getContact">
        <cfargument name="ID" type="numeric" />
        <cfset var rstContact="" />
        <cfquery name="rstContact" datasource="#variables.attributes.dsn#">
            SELECT firstName, lastName
            FROM Owners
            WHERE ID =
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#" />
        </cfquery>
        <cfreturn rstContact />
    </cffunction>


    <!--- **** using cfargument to combine methods **** --->
    <cffunction name="getContact">
        <cfargument name="ID" type="numeric" default="0" />
        <cfset var rstContact="" />
        <cfquery name="rstContact" datasource="#variables.attributes.dsn#">
            SELECT firstName, lastName
            FROM Owners
            <cfif arguments.ID GT 0>
                WHERE ID =
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#" />
            </cfif>
        </cfquery>
        <cfreturn rstContact />
    </cffunction>


</cfcomponent>