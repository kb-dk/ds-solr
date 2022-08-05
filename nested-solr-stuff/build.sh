#!/bin/bash

SOURCE="../nested-corpus"
TRANSFORM="mods2solr.xsl"

: ${USE_UUID:="$1"}


: ${SAXON_JAR:="/home/$USER/saxon/saxon9he.jar"}
if [[ ! -s "$SAXON_JAR" ]]; then
    >&2 echo "$SAXON_JAR not available. Please install it from https://sourceforge.net/projects/saxon/files/Saxon-HE/"
    exit 2
fi
for TOOL in jq uuidgen; do
    if [[ -z $(which $TOOL) ]]; then
        >&2 echo "$TOOL not available. Please install it"
        exit 3
    fi
done

SAXON="java -jar "$SAXON_JAR" --suppressXsltNamespaceCheck:on  "

# set to 1 if you want to prettyprint you json

DEBUG_JSON=1
DEBUG_PARAMS="debug_params=yes"

mods_files=("albert-einstein.xml"
	    "hvidovre-teater.xml"
	    "simonsen-brandes.xml"
	    "tystrup-soroe.xml"
	    "homiliae-super-psalmos.xml"
	    "work_on_logic.xml"
	    "joergen_hansens_visebog.xml"
	    "jsmss-object62730.xml"
	    "responsa.xml")

for file in ${mods_files[@]}; do
    json=$(sed 's/.xml$/.json/' <<< "$file")
    echo " - Producing $json"
    
    use_id=''
    if [ "$USE_UUID" = "uuid" ]; then
	use_id=" collection_identifier=qwertycollection collection_type=quertyquerty record_identifier=`uuidgen` "
	echo "$use_id"
    fi

    if [ "$DEBUG_JSON" = "1" ]; then
	$SAXON -xsl:"$TRANSFORM" -s:"$SOURCE/$file" $use_id $DEBUG_PARAMS | jq . > "$json"
    else
	$SAXON -xsl:"$TRANSFORM" -s:"$SOURCE/$file" $use_id $DEBUG_PARAMS > "$json"
    fi
done
