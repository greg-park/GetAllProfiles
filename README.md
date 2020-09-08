# GetAllProfiles
Just creating a simple script that creates a PowerShell script form an existing profile, changes a setting in that script and then re-applys
the profile via that script
What the project does
GetAllProfiles simply pulls all the existing profiles from a given OneView/Synergy appliance, creates NEW power shell scripts based off those profiles, changes setting(s) in that powersheel script then assigsn that new profile to the servers in the appliance.

Why the project is useful
If you have a set of profiles created with Virtual serial numbers and you wish to change all those servers to physical serial numbers this script will do that.

How users can get started with the project
Carefully run the script against a set of test servers

Where users can get help with your project
* HPE OneView PowerShell docs
* HPE server information

Who maintains and contributes to the project
Greg Park ... sometimes
