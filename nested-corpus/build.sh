#!/bin/bash

SAXON="java -jar /home/slu/saxon/saxon9he.jar --suppressXsltNamespaceCheck:on  "

mods_files=("albert-einstein.xml"
	    "hvidovre-teater.xml"
	    "simonsen-brandes.xml"
	    "tystrup-soroe.xml"
	    "homiliae-super-psalmos.xml"
	    "work_on_logic.xml"
	    "responsa.xml")

for file in ${mods_files[@]}; do
    json=$(echo $file | perl -pe 's/.xml/.json/g')
    $SAXON -xsl:mods2solr.xsl -s:"$file" | jq > "$json"
done
