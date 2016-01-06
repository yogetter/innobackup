#!/bin/bash
#
# Program:Full Back Up DB.
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
#	echo -e "Error: Path not exists !!! "
#	read -p "Please Enter Full Path that You Want to store: " path
#done
while read line
do
	arg[$i]="$line"
	i=$(($i+1))
	echo "$line"
done < config.cnf
#get path
IFS==
set ${arg[9]}

innobackupex --${arg[6]} --${arg[7]} --${arg[8]} --use-memory=2G --no-timestamp $2"/fullback"
