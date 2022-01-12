#!/bin/bash

SOURCE="../nested-corpus"
TRANSFORM_TO_SCHEMAORG="mods2schemaorg.xsl"
TRANSFORM_TO_IIIF="mods2iiif.xsl"

: ${SAXON_JAR:="/home/$USER/saxon/saxon9he.jar"}
if [[ ! -s "$SAXON_JAR" ]]; then
    >&2 echo "$SAXON_JAR not available. Please install it from https://sourceforge.net/projects/saxon/files/Saxon-HE/"
    exit 2
fi
for TOOL in jq; do
    if [[ -z $(which $TOOL) ]]; then
        >&2 echo "$TOOL not available. Please install it"
        exit 3
    fi
done

SAXON="java -jar "$SAXON_JAR" --suppressXsltNamespaceCheck:on  "

# set to 1 if you want to prettyprint you json

DEBUG_JSON=1

mods_files=("albert-einstein.xml"
	    "astronomiae_instauratae_mechanica.xml"
	    "medicinsk-historisk-selskab.xml"
	    "hvidovre-teater.xml"
	    "simonsen-brandes.xml"
	    "tystrup-soroe.xml"
	    "luftfoto-sample.xml"
	    "homiliae-super-psalmos.xml"
	    "work_on_logic.xml"
	    "joergen_hansens_visebog.xml"
	    "john-rosforth-johnson.xml"
	    "greenland-topographic-collection.xml"
	    "chinese-manuscripts.xml"
	    "dansk-folkeparti.xml"
	    "tuti-nameh.xml"
	    "illum.xml"
	    "jacob-hansen-bang-with.xml"
	    "responsa.xml")

for file in ${mods_files[@]}; do
    json=$(sed 's/.xml$/.json/' <<< "$file")
    iiif=$(sed 's/.xml$/_iiif.json/' <<< "$file")
    iiif_param1="base_uri=https://raw.githubusercontent.com/kb-dk/ds-solr/iiif-presentation/ld-json"
    iiif_param2="result_object=$iiif"
    echo " - Producing $json & $iiif"
    if [ "$DEBUG_JSON" = "1" ]; then
	$SAXON -xsl:"$TRANSFORM_TO_SCHEMAORG" -s:"$SOURCE/$file" | jq . > "$json"
	$SAXON -xsl:"$TRANSFORM_TO_IIIF" -s:"$SOURCE/$file" "$iiif_param1" "$iiif_param2" | jq . > "$iiif"
    else
	$SAXON -xsl:"$TRANSFORM_TO_SCHEMAORG" -s:"$SOURCE/$file" > "$json"
	$SAXON -xsl:"$TRANSFORM_TO_IIIF" -s:"$SOURCE/$file" "$iiif_param1" "$iiif_param2" > "$iiif"
    fi
done
