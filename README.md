avature_importer
================
upload_resumes will help you to upload a resume into avature.

it's currently designed to upload resumes from a csv provided by grace hopper.

it depends on several awkward things, like being logged in to avature in your browser while you run it. this is due to the obnoxiousness of our corporate SSO's redirects. and because I was in a hurry to get it done.

avature_resume builds the hash that will get posted as json, and uses notes to add custom information

the cookie and these magic strings come from inspecting the polled request for synapserWait on avature. (chrome dev tools)

if you're logged in this should work fine. note that the session id changes periodically, the version changes less often. daily? "p" changes on login I think.

you'll probably also want a fresh copy of the cookie.

arg 0 is the csv


todo list: (probably will never happen)
-attach a file
-try and get links in notes to be clickable
-put the unique identifiers (session id, user/pass, etc) onto the command line
-I'm not 100% sure that the user/pass is required or even useful in creating the http connection.
-tests would be nice. but this kind of a one-off thing
-convert the puts to logging
-login to SSO