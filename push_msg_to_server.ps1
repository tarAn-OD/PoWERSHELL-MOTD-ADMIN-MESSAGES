#Push message to gaming server
#Read content from Adverts.txt line by line
#Push to Server wait 60 seconds
#Push until last line, once reach end of the file it will start from begin

$SERVER="IP"
$RCONPORT="PORT"
$RCONPASS="PASSWORD"
$MSGFILE=".\Adverts.txt"

#Get curent date for logging purpose
function dt 
{
    echo $(get-date -Format 'hh:mm:ss dd/MM/yyyy')

}

function PushMsgToServer
{

    echo "$(dt) Pusing message"
    
	./mcrcon.exe -c -H $SERVER -P $RCONPORT -p $RCONPASS "say $MSG"    
    
    #./mcron.ps1 "$SERVER" "$RCONPORT" "$RCONPASS" "$msg"

    echo "$(dt) Message pushed successfully"

    echo "$(dt) Waiting 60 seconds.........."    
    sleep 60
}

echo "$(dt) Process begin..."
echo "$(dt) Getting message from adverts.txt file"

$LineCount = [Linq.Enumerable]::Count([System.IO.File]::ReadLines("$MSGFILE"))

echo "$(dt) Total records in Adverts.txt = $($LineCount)"

#Start reading message file & call push notification utilites mcrcon.exe
$GetInfo = {
    echo "$(dt) *********************************************"
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