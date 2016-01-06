#!/bin/bash
#
# Program:Set Full Backup and Incremntal Backup
#
read -p "Please Enter Your SQL account: " account
stty -echo
read -p "Please Enter Your SQL password: " password
stty echo
echo
read -p "Please Enter Your ownCloud DB Name: " db
read -p "Please Enter Your Full Path of Back Up Dir: " path
while [ "${path}" == "" -o ! -d "${path}" ]
do
	echo -e "Error: Path not exists !!! "
	read -p "Please Enter Your Full Path of Back Up Dir: " path
done
read -p "Please Enter Name of Dir that You Want Restore: " dirname

while [ "${dirname}" == "" -o ! -d "${path}/${dirname}" ]
do
        echo -e "Error: Dir not exists !!! "
	read -p "Please Enter Name of Dir that You Want Restore: " dirname
done
innobackupex --use-memory=2G --user=${account} --password=${password} --apply-log --redo-only ${path}"/fullback"

if [ "${dirname}" == "fullback" ] ; then
	innobackupex --use-memory=2G --user=${account} --password=${password} --apply-log ${path}"/fullback"
	service mysql stop
	rm /var/lib/mysql/ib*
	innobackupex --copy-back --use-memory=2G ${path}"/fullback" --database=${db} --force-non-empty-directories
	chown -R mysql:mysql /var/lib/mysql/
	service mysql start
	exit 1
fi

array=($(ls -rt ${path}/))
i=0
while [ "${array[$i]}" != "${dirname}" ]
do
	if [ "${array[$i]}" == "fullback" ]; then
	        i=$(($i+1))
		continue
	fi
	innobackupex --use-memory=2G --user=${account} --password=${password} --apply-log --redo-only ${path}"/fullback" --incremental-dir=${path}"/"${array[$i]}
	i=$(($i+1))
done
echo ${array[$i]}
innobackupex --use-memory=2G --user=${account} --password=${password} --apply-log --redo-only ${path}"/fullback" --incremental-dir=${path}"/"${array[$i]}
innobackupex --use-memory=2G --user=${account} --password=${password} --apply-log ${path}"/fullback"
service mysql stop
rm /var/lib/mysql/ib*
innobackupex --copy-back --use-memory=2G ${path}"/fullback" --database=${db} --force-non-empty-directories
chown -R mysql:mysql /var/lib/mysql/
service mysql start
