
/**
 * deleteHOContent method
 */
public boolean function deleteHOContent(required string hoContentID="0", string lastUpdateHOUserID="0") output=false {
var qry = "";
cfquery( name="qry", datasource=application.dsn ) { //Note: queryExecute() is the preferred syntax but this syntax is easier to convert generically

    writeOutput("UPDATE HOContent
        SET IsActive = 0,
            LastUpdateHOUserID =");
    cfqueryparam( cfsqltype="CF_SQL_INTEGER", value=arguments.lastUpdateHOUserID );

    writeOutput(",
            LastUpdateDate = GETDATE()
        WHERE HOContentID =");
    cfqueryparam( cfsqltype="CF_SQL_INTEGER", value=arguments.hoContentID );
}
return 1;
}


<cffunction name="deleteHOContent" access="public" returntype="boolean" output="false" hint="deleteHOContent method">
    <cfargument name="hoContentID" required="yes" type="string" default="0" hint="hoContentID argument in deleteHOContent method">
    <cfargument name="lastUpdateHOUserID" required="no" type="string" default="0" hint="lastUpdateHOUserID argument in deleteHOContent method">
    <cfset var qry="">

    <cfquery name="qry" datasource="#application.dsn#">
        UPDATE HOContent
        SET IsActive = 0,
        LastUpdateHOUserID = <cfqueryparam value="#arguments.lastUpdateHOUserID#" cfsqltype="CF_SQL_INTEGER">,
            LastUpdateDate = GETDATE()
            WHERE HOContentID = <cfqueryparam value="#arguments.hoContentID#" cfsqltype="CF_SQL_INTEGER">
    </cfquery>

    <cfreturn 1>
</cffunction>