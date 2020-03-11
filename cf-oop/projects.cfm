<cfscript>
    objProjects = createObject('component', 'com.projects.projects');
</cfscript>
<cfoutput>
    The current date is #objProjects.getCurrentDate()#
</cfoutput>