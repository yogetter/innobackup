#!/bin/bash
#
# Program:Set Full Backup and Incremntal Backup
#
#read -p "Please Enter Your SQL account: " account
#stty -echo
#read -p "Please Enter Your SQL password: " password
#stty echo
#echo
#read -p "Please Enter Your ownCloud DB Name: " db
#read -p "Please Enter Full Path that You Want to store: " path
#while [ "${path}" == "" -o ! -d "${path}" ]
#do
#	read -p "Please Enter Full Path that You Want to store: " path
#	echo -e "Error: Path not exists !!! "
#done
min=$1 
hour=$2 
day=$3 
mon=$4 
week=$5 

while read line
do
        arg[$i]="$line"
        i=$(($i+1))
done < config.cnf
#get path
IFS==
set ${arg[9]}
echo "$min $hour $day $mon $week" "innobackupex --use-memory=2G --incremental $2 --${arg[6]} --${arg[7]} --${arg[8]}"  >> tmp

crontab -u root tmp
rm tmp
