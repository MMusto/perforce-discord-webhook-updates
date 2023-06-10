param (
    [Parameter(Mandatory=$true)]
    [string]$changelist
)

Start-Transcript -Path C:\log.txt -Append
$env:P4PORT="localhost:1666"
$env:P4USER="Insert Username Here"
$env:P4PASSWD="Insert Password Here"
$webhookUrl = "Insert Webhook URL Here"


$env:P4PASSWD | p4 login


$changelist = $changelist.Trim()
$username = ""
$client = ""
$description = ""

foreach ($line in & p4 -ztag describe -s $changelist) {
    $parts = $line.Split(" ", 3)
    $tag = $parts[1]
    $value = $parts[2]

    switch ($tag) {
        "user" {
            $username = $value
        }
        "client" {
            $client = $value
        }
        "desc" {
            $description = $value
        }
    }
}

$jsonPayload = @{
    "username"   = "Perforce"
    "avatar_url" = "https://i.imgur.com/iROHBfW.png"
	"embeds" = @(
        @{
			"title" 		= "$username@$client";
			"description"	= "$description"
			"color" 		= 701425
			"thumbnail"		= @{"url" = "https://i.imgur.com/unlgXvg.png"}
			"footer"		= @{"text" = "CL $changelist"
								"icon_url" = "https://i.imgur.com/unlgXvg.png"}
			"timestamp"		= (Get-Date).ToString("o")
		}
	)
} | ConvertTo-Json -Depth 3

try {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $response = Invoke-RestMethod -Uri $webhookUrl -Method 'Post' -ContentType 'application/json' -Body $jsonPayload
    "Webhook response: $($response | ConvertTo-Json -Depth 100)"
}
catch {
    "Error: $($_.Exception.Message)"
}

Stop-Transcript
