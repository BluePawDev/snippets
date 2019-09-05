/**
 * Undocumented component
 */
component extends="taffy.core.api" {
    this.name = now();

    this.mappings["/resources"] = listDeleteAt(cgi.script_name, listLen(cgi.script_name, "/"), "/") & "/resources";
    this.mappings["/taffy"] = listDeleteAt(cgi.script_name, listLen(cgi.script_name, "/"), "/") & "/taffy";
    this.mappings["/rr4b"] = getDirectoryFromPath(getMetadata(this).path) & "../../../";

    variables.framework = {};
    variables.framework.debugKey = "debug";
    variables.framework.reloadKey = "reload";
    variables.framework.reloadPassword = "true";
    variables.framework.serializer = "taffy.core.nativeJsonSerializer";
    variables.framework.returnExceptionsAsJson = true;

    function onApplicationStart(){
        application.dsn = "GPP4E";
        return super.onApplicationStart();
    }

    function onRequestStart(TARGETPATH){
        return super.onRequestStart(TARGETPATH);
    }

    // this function is called after the request has been parsed and all request details are known
    function onTaffyRequest(verb, cfc, requestArguments, mimeExt){
        // this would be a good place for you to check API key validity and other non-resource-specific validation
        return true;
    }
}
