#!/bin/bash

filename=$1 # replace with your subtitles file
outputfile=$2 # output file

index=1
cat $filename | while IFS= read -r line
do
    if [[ $line == *"-->"* ]]; then
        starttime=$(echo $line | cut -d' ' -f1)
        endtime=$(echo $line | cut -d' ' -f3)
        starttime=$(echo $starttime | tr ',' '.')
        endtime=$(echo $endtime | tr ',' '.')
        startsecs=$(echo $starttime | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
        endsecs=$(echo $endtime | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
        diff=$(echo "$endsecs - $startsecs" | bc)
    elif [[ $line != "" ]]; then
        word_count=$(echo $line | wc -w)
        increment=$(echo "$diff / $word_count" | bc -l)
        currenttime=$startsecs
        for word in $line
        do
            current_end_time=$(printf "%.0f" $(echo "$currenttime + $increment" | bc))
            echo $index >> $outputfile
            printf "%02d:%02d:%02d,000 --> %02d:%02d:%02d,000\n" $(($currenttime/3600)) $(($currenttime%3600/60)) $(($currenttime%60)) $(($current_end_time/3600)) $(($current_end_time%3600/60)) $(($current_end_time%60)) >> $outputfile
            echo $word >> $outputfile
            echo "" >> $outputfile
            currenttime=$current_end_time
            ((index++))
        done
    fi
done
