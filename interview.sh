#!/bin/bash
declare -A hashtable=()
while read -r line; do
  echo $line
  array=($line)
  time=${array[2]}
  hour="${time:0:2}"
  #echo "hour: $hour"
  deviceName=${array[3]}
  #echo "deviceName: $deviceName"
  processName=${array[5]}
  #echo "processname: $processName"
  processId=${array[5]}
  #echo "processId: $processId"
  description=${array[@]:6}
  #echo "description: $description"
  key=$(echo "$hour$deviceName$processId$processName$description" | sed 's/ //g')
  echo "key=$key"
  [[ -v hashtable[$key] ]] && echo "test"
  array=(1 "$hour" "$deviceName" "$processId" "$processName" "$description")
  #echo ${array[0]} #hour
  #echo ${array[1]} #deviecName
  #echo ${array[2]} #processName
  #echo ${array[3]} #processName
  #echo ${array[4]} #description
  #echo ${array[5]} #count
  if [[ -v "hashtable[$key]" ]]  
  then
    hashtable[$key][0] = $hashtable[$key][0]+1
    #echo "$hashtable[$key][5]"
else
    hashtable[$key]=$array
  fi
  echo hashmap has ${#hashtable[@]} elements
  for key2 in ${!hashtable[@]}; do echo ${hashtable[$key2]}; done                     
done
  for i in "${!bashtable[@]}"
  do
    echo "$i" 
    echo "${hashtable[$i]}"
  done # |  jq -n -R 'reduce inputs as $i ({}; . + { ($i): (input|(tonumber? // .)) })'
