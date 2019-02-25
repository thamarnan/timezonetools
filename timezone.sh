#!/bin/bash
# ig20180122 - displays meeting options in other time zones
# set the following variable to the start and end of your working day
#date +%R
#myday="0 23" # start and end time, with one space
myday="8 17"

# set the local TZ
myplace='America/Los_Angeles'

# set the most common places
place[1]='America/New_York'
place[3]='Asia/Tokyo'
place[2]='Asia/Bangkok'

# add cities using place[5], etc.
# set the date format for search
dfmt="%m-%d" # date format for meeting date
hfmt="+%B %e, %Y" # date format for the header



# no need to change onwards
format1="%-10s " # Increase if your cities are large
format2="%02d "
mdate=$1
if [[ "$1" == "" ]]; then mdate=`date "+$dfmt"`; fi
date -j -f "$dfmt" "$hfmt" "$mdate"
here=`TZ=$myplace date -j -f "$dfmt" +%z  "$mdate"`
here=$((`printf "%g" $here` / 100))
tznum=`TZ=$myplace date +%z`
printf "$format1 $format1" "Here" $tznum 
printf "$format2" `seq $myday` 
printf "\n"
for i in `seq 1 "${#place[*]}"`
do
    there=`TZ=${place[$i]} date -j -f "$dfmt" +%z  "$mdate"`
    there=$((`printf "%g" $there` / 100))
    city[$i]=${place[$i]/*\//}
    tznum=`TZ=${place[$i]} date +%z`
    tdiff[$i]=$(($there-$here))
    printf "$format1 $format1" ${city[$i]} $tznum
    for j in `seq $myday`
    do
        printf "$format2" $((($j+${tdiff[$i]})%24))
    done 
#    temp=$(((${tdiff[$i]})))
#    printf "(%+d)\n" $temp
     printf "\n"
done

