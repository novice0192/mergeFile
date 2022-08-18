#!/bin/bash

echo "accnumber accname brname curbal grpname" > newmerge.txt
sed 's/"//g' account_list.txt > newaccount.txt
tail -n +2 details_list.txt > newdetails.txt
while read -r line; do
	accno=$(echo $line | cut -f1 -d' ' )
	accname=$(grep "${accno} " newaccount.txt | cut -f 2,3 -d ' ')
	brid=$(echo $line | cut -f2 -d' ')
	brname=$(grep "^${brid} " branch_list.txt | cut -f2 -d' ')
	curbal=$(grep "${accno} " account_list.txt | cut -f4 -d' ')
	grpname=''
	echo $line | cut -f3 -d' ' | cut -f1- -d',' --output-delimiter=$'\n' > tempgrp.txt
	while read -r grpid; do
		tempgrp=$(grep "^${grpid} " groups_list.txt | cut -f2 -d' ')
		grpname="${grpname},${tempgrp}"
	done < tempgrp.txt
	echo "${accno} ${accname} ${brname} ${curbal} ${grpname}" >> newmerge.txt
done < newdetails.txt

