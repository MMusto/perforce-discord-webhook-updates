# Discord Notifications for Perforce Submissions
This document outlines the steps for setting up a script that triggers Discord notifications every time a changelist is submitted to the Perforce version control system.

# Prerequisites:
1. This has been tested with Perforce on a Windows-based system (Windows Server 2016).
2. The Perforce user should have read access to the depot in order to use the p4 describe command.
3. You should have a Discord Webhook configured.
4. Access to modify p4 triggers on the server is required.

# Setup
1. Modify the variables at the top of the script. (P4PORT, P4USER, P4PASSWD, WebhookUrl)
2. Save the script somewhere accessible to the Perforce user.
 - At this point, you should be able to manually execute the script with ./perforce_discord_update.ps1 <changelist number>
 3. Open the server triggers editor by running p4 triggers in a terminal and append a new trigger similar to the following, but with your specific depot/stream and path to your script (The tab is important):
  
 
 '''
  
Triggers:
  
      discord change-commit //depot/mainline/... "powershell.exe C:\perforce_discord_update.ps1 %changelist%"
 '''

  
