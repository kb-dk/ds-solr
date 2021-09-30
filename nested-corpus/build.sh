#!/bin/bash

SAXON="java -jar /home/slu/saxon/saxon9he.jar "

mods_files=("albert-einstein.xml"
	    "hvidovre-teater.xml"
	    "simonsen-brandes.xml"
	    "tystrup-soroe.xml"
	    "homiliae_super_psalmos.xml")

for file in ${mods_files[@]}; do
    json=$(echo $file | perl -pe 's/.xml/.json/g')
    $SAXON -xsl:mods2solr.xsl -s:"$file" | jq > "$json"
done
