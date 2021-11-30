#!/bin/bash

SAXON="java -jar /home/slu/saxon/saxon9he.jar --suppressXsltNamespaceCheck:on  "

# set to 1 if you want to prettyprint you json

DEBUG_JSON=1

mods_files=("albert-einstein.xml"
	    "hvidovre-teater.xml"
	    "simonsen-brandes.xml"
	    "tystrup-soroe.xml"
	    "homiliae-super-psalmos.xml"
	    "work_on_logic.xml"
	    "joergen_hansens_visebog.xml"
	    "responsa.xml")

for file in ${mods_files[@]}; do
    json=$(echo $file | perl -pe 's/.xml/.json/g')
    if [ "$DEBUG_JSON" = "1" ]; then
	$SAXON -xsl:mods2solr.xsl -s:"$file" | jq > "$json"
    else
	$SAXON -xsl:mods2solr.xsl -s:"$file" > "$json"
    fi
done
