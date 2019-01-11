#SERVER RCON AND ADMIN MESSAGES BY KENTONE AND TARAN
$SERVER = ""
$PORT = ""
#API
$APIURL = "http://insurgency.pro/api/$SERVER`:$PORT"
$COUNT = -1

#Added by tarAn
$MSGFILE=".\Adverts.txt"

#RCON
$RCONPORT = 
#$securedvalue = Read-Host -Prompt 'RCON PASSWORD, PLEASE' -AsSecureString
#Converts secureString to String for the pass
#$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedValue)
#$RCONPASS = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

$RCONPASS = ""

#KICKING FUNCTION START
function _KICK
{
    $GETPLAYERS = Invoke-WebRequest $APIURL | ConvertFrom-Json | select -expand players | Sort-Object -Descending time | select -expand name
	
    foreach ($PLAYER in $($GETPLAYERS))
    { 
        $COUNT++
        Write-Host $COUNT $PLAYER
	}

    $SELECTEDPLAYER = Read-Host -Prompt 'WHO SHALL BE KICKED?? Just press enter to cancel'
    
    if ([string]::IsNullOrWhiteSpace($SELECTEDPLAYER))
    {
        write-host "Select one player next time, soz"
        pause
        break
    }

    $REASON = Read-Host -Prompt 'WHY?? 
-Write 0 (zero) for "we need your slot for a member"
-Write 1 for "Your are not asking if everyone is ready"'
	if ($REASON -eq 0)
	{
		$REASON = "We need your space for a member"
	}

    elseif ($REASON -eq 1)
    {
		$REASON = "Your are not asking if everyone is ready"
	}

    elseif ([string]::IsNullOrWhiteSpace($REASON))
    {
		$REASON = "IDK, too lazy to type"
	}

	write-host "$($GETPLAYERS | select -index $SELECTEDPLAYER) WILL BE KICKED BECAUSE $REASON"
    ./mcrcon.exe -c -H $SERVER -P $RCONPORT -p $RCONPASS "kick $($GETPLAYERS | select -index $SELECTEDPLAYER) $REASON"
    pause
}
#KICKING FUNCTION END

#BAN FUNCTION START
function _BAN
{
    $GETPLAYERS = Invoke-WebRequest $APIURL | ConvertFrom-Json | select -expand players | Sort-Object -Descending time | select -expand name
	
    foreach ($PLAYER in $($GETPLAYERS))
    { 
        $COUNT++
        Write-Host $COUNT $PLAYER
	}

    $SELECTEDPLAYER = Read-Host -Prompt 'WHO SHALL BE BANNED?? Just press enter to cancel'
    
    if ([string]::IsNullOrWhiteSpace($SELECTEDPLAYER))
    {
        write-host "Select one player next time, soz"
        pause
        break
    }

    $REASON = Read-Host -Prompt 'WHY?? 
-Write 0 (zero) for "Not behaving"
-Write 1 for "Being an ass"'
	if ($REASON -eq 0)
	{
		$REASON = "Not behaving"
	}

    elseif ($REASON -eq 1)
    {
		$REASON = "Being an ass"
	}

    elseif ([string]::IsNullOrWhiteSpace($REASON))
    {
		$REASON = "I am so angry that I didn't type anything, but that ban is for sure deserved"
	}

	write-host "$($GETPLAYERS | select -index $SELECTEDPLAYER) WILL BE BANNED BECAUSE $REASON"
    ./mcrcon.exe -c -H $SERVER -P $RCONPORT -p $RCONPASS "ban $($GETPLAYERS | select -index $SELECTEDPLAYER) $REASON"
    pause
}
#BAN FUNCTION END

#LIST FUNCTION START
function _LISTPLAYERS
{
	$playerlist = Invoke-WebRequest $APIURL | ConvertFrom-Json | select -expand players | Sort-Object -Descending time | select -expand name
    if ($playerlist)
    {
        $playerlist
    }
    else
    {
    Write-host "Server is empty."
    }
}
#LIST FUNCTION END

#CONSOLE FUNCTION START
function _INTCONSOLE
{
	./mcrcon.exe -c -H $SERVER -P $RCONPORT -p $RCONPASS -t
    pause
}
#CONSOLE FUNCTION END

#SAY FUNCTION START
function _RCONSAY
{
    $MESSAGE = Read-Host -Prompt 'Write a message to send  or leave it blank to go to the menu'
    
    if ([string]::IsNullOrWhiteSpace($MESSAGE))
    {
        write-host "Write at least one message next time"
        pause
        break
    }

    write-host "Sent $MESSAGE"
	./mcrcon.exe -c -H $SERVER -P $RCONPORT -p $RCONPASS "say $MESSAGE"
    pause
}
#SAY FUNCTION END


#Added this block by Chandru (freelancer) --------------
#Get curent date for logging purpose
function dt 
{
    echo $(get-date -Format 'hh:mm:ss dd/MM/yyyy')

}

function PushMsgToServer
{

    echo "$(dt) Pushing message"

    echo $SERVER $RCONPORT $RCONPASS $msg
    
	./mcrcon.exe -c -H $SERVER -P $RCONPORT -p $RCONPASS "say $msg"    
    
    #./mcron.ps1 "$SERVER" "$RCONPORT" "$RCONPASS" "$msg"

    echo "$(dt) Message pushed successfully"

    echo "$(dt) Waiting 60 seconds.........."    
    sleep 60
}


function PushMsgStart {
#Start reading message file & call push notification utilites mcrcon.exe
$GetInfo = {
    echo "$(dt) *********************************************"
    echo "$(dt) Process begin..."
    echo "$(dt) Getting message from adverts.txt file"

    $LineCount = [Linq.Enumerable]::Count([System.IO.File]::ReadLines("$MSGFILE"))

    echo "$(dt) Total records in Adverts.txt = $($LineCount)"

    echo "$(dt) Begning of the file"

    $line =(get-content $MSGFILE) 

     foreach($msg in $line ) {         
         if ($msg -ne "") {
            echo "$(dt) Push msg to server - $($msg)"
           #PushMsgToServer $msg
           PushMsgToServer
         }

    }
   echo "$(dt) End of the file"
   echo "$(dt) Restart again from the begning of the file"
   echo "$(dt) *********************************************"
.$GetInfo
}

&$GetInfo
}
#Added this block by tarAn --------------




#MENU FUNCTION START
function Show-Menu
{
	param (
	[string]$Title = 'RCONSOLE'
	)
	cls
	Write-Host -foregroundcolor red "================ $Title ================"
	Write-Host "IP: $server"
	Write-Host "PORT: $port"
	Write-Host "List of PLAYERS by time:"
    Write-host  -foregroundcolor cyan "--------------------------"
	_LISTPLAYERS
	Write-host  -foregroundcolor cyan "--------------------------"
	Write-Host "1: Kick"
    Write-Host "2: BAN"
	Write-Host "3: RCON (BUGGY)"
    Write-Host "4: Say"
	Write-Host "5: Push Admin messages"
    Write-Host "6: Refresh"
	Write-Host "Q: Press 'Q' to quit."
}
#MENU FUNCTION END

#MENU
do
{
	Show-Menu
    Write-Host -foregroundcolor RED "Please make a selection: " -NoNewline
	$input = Read-Host
	switch ($input)
	{
		'1' {
			cls
			_KICK
			} '2' {
			cls
			_BAN
            } '3' {
			cls
			_INTCONSOLE
            } '4' {
			cls
			_RCONSAY
			} '5'{
			cls
            PushMsgStart
            } '6' {
            cls
            } 'q' {
			return
		}
	}
	
}
until ($input -eq 'q')
#MENU END