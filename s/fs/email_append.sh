#!/usr/bin/env bash

for email_file in $(ls emails_*);
do
    locale=$(echo $email_file | sed "s/emails_//" | sed "s/\.html//")
    nl_file="newsletter-emails_$locale.html"
    let start_cut=$(grep -n 189567175300694257 $email_file | cut -d':' -f 1)-1
    let end_cut=$(grep -n '</table>' $email_file | cut -d':' -f 1)-1
    let insert_at=$(grep -n '</table>' $nl_file | cut -d':' -f 1)-1
    let insert_from=$insert_at+1
    outfile="/tmp/$nl_file"
    head -n $insert_at $nl_file > $outfile
    head -n $end_cut $email_file | tail -n +$start_cut >> $outfile
    tail -n +$insert_from $nl_file >> $outfile

    bak $nl_file
    cp $outfile $nl_file
done
