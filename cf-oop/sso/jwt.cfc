 if (structkeyexists(arguments, "userName") || structkeyexists(arguments, "email")) {
     if (structkeyexists(arguments, "userName") and len(arguments.userName)) {
         args["userName"] = arguments.userName;
     }

     if (structkeyexists(arguments, "email") and len(arguments.email)) {
         args["emailAddress"] = arguments.email;
     }
 } else {
     throw (message = "user name or email is required.", type = "security.authenticate.requiredAguments", errorCode = "missing user identifier");
 }


<!--- **** OR ***** --->


 if (structKeyExists(arguments, "userName") AND len(trim(arguments.userName))) {
     args["userName"] = arguments.userName;
 } else if (structKeyExists(arguments, "email") AND len(trim(arguments.email))) {
     args["emailAddress"] = arguments.email;
 } else {
     throw (message = "user name or email is required.", type = "security.authenticate.requiredAguments", errorCode = "missing user identifier");
 }