<!--- instantiate the object --->
<cfset objContacts = createObject('component','contacts')/>

<!--- dump the results --->
<cfdump var="#objContacts.getContact()#"/>
