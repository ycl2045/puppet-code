$ComputerName = ''

$IP=[System.Net.Dns]::GetHostAddresses($ComputerName) |
Where-Object {
   $_.AddressFamily -eq 'InterNetwork'
      
} |
 Select-Object -ExpandProperty IPAddressToString


 $Address = ($IP).Split(" ")[0]



 Write-Host "gfcertname=$Address"
