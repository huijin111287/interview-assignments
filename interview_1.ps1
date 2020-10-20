$path = "C:\Users\huiji\Downloads\input.txt"
[string[]]$arrayFromFile = Get-Content $path
$hashtable = $null
$hashtable = @{} 

foreach($line in [System.IO.File]::ReadLines($path)) {
  if ($line -match("syslogd\[")) { continue }
  if ($line -match("remindd\[")) { continue }
  if ($line -match("syncdefaultsd\[")) { continue }
  if ($line -match("DEPRECATED USE")) { continue }
  $deviceName = [regex]::split($line, '(\s)+')[6]
  #$deviceName
  #skip the row if the deviceName is not specified
  if ($deviceName.Length -lt 8){continue;}
  #skip the row if the hour cannnot be determined
  try {
    $hour = [int][regex]::split($line, '(\s|:)+')[4]
    #$hour
  } catch {
    continue
  }
  $hour1 = $hour+1
  $processId = [regex]::split($line, '(\[|\])')[2]
  #$processId
  $processName = [regex]::split($line, '(\[|\]|\))')[4].replace("(","").replace(" ","")
  #$processName
  $description = [regex]::split($line, '(\)|:)')[-1]
  #$description
  if ($description.Length -eq $line.Length) {
    $line
    continue
  }
  $key = "$hour$deviceName$processId$processName$description"
  #$key
  if ($hashtable.Contains($key))
  {
    $hashtable[$key][5] = $hashtable[$key][5]+1
  } else {
    $hashtable.Add($key,@("deviceName=$deviceName","processId=$processId","processName=$processName","description=$description","timeWindow=$hour",1))
  }
}
#$hashtable | Format-Table
$hashtable.count
$body = $hashtable | ConvertTo-Json -Depth 4
$body

#Invoke-WebRequest -Uri https://foo.com/bar -Method POST -Body $body