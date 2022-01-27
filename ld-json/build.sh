#!/bin/bash

SOURCE="../nested-corpus"
TRANSFORM_TO_SCHEMAORG="mods2schemaorg.xsl"
TRANSFORM_TO_IIIF="mods2iiif.xsl"
TRANSFORM_METS_TO_IIIF="mods-mets2iiif.xsl"

: ${SAXON_JAR:="/home/$USER/saxon/saxon9he.jar"}
if [[ ! -s "$SAXON_JAR" ]]; then
    >&2 echo "$SAXON_JAR not available. Please install it from https://sourceforge.net/projects/saxon/files/Saxon-HE/"
    exit 2
fi
for TOOL in xpath jq; do
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
    "boethius-consolatio-philosophiae.xml"
    "chinese-manuscripts.xml"
    "dansk-folkeparti.xml"
    "greenland-topographic-collection.xml"
    "homiliae-super-psalmos.xml"
    "hvidovre-teater.xml"
    "illum.xml"
    "jacob-hansen-bang-with.xml"
    "joergen_hansens_visebog.xml"
    "john-rosforth-johnson.xml"
    "luftfoto-sample.xml"
    "medicinsk-historisk-selskab.xml"
    "responsa.xml"
    "simonsen-brandes.xml"
    "tuti-nameh.xml"
    "tystrup-soroe.xml"
    "work_on_logic.xml")

mods_files=("boethius-consolatio-philosophiae.xml")


ISMETS="/m:mets/@OBJID"

for file in ${mods_files[@]}; do
   
    json=$(sed 's/.xml$/.json/' <<< "$file")
    iiif=$(sed 's/.xml$/_iiif.json/' <<< "$file")
    echo " - Producing $json & $iiif"
    iiif_param1="base_uri=https://raw.githubusercontent.com/kb-dk/ds-solr/iiif-presentation/ld-json"
    iiif_param2="result_object=$iiif"

    METS=$(xpath -q -e "$ISMETS" "$SOURCE/$file" )

    if [ "$DEBUG_JSON" = "1" ]; then
	if [[ "$METS" == *manus* ]]; then
	    $SAXON -xsl:"$TRANSFORM_METS_TO_IIIF" -s:"$SOURCE/$file" "$iiif_param1" "$iiif_param2" | jq . > "$iiif"
	else
	    $SAXON -xsl:"$TRANSFORM_TO_SCHEMAORG" -s:"$SOURCE/$file" | jq . > "$json"
	    $SAXON -xsl:"$TRANSFORM_TO_IIIF" -s:"$SOURCE/$file" "$iiif_param1" "$iiif_param2" | jq . > "$iiif"
	fi
    else
	$SAXON -xsl:"$TRANSFORM_TO_SCHEMAORG" -s:"$SOURCE/$file" > "$json"
	$SAXON -xsl:"$TRANSFORM_TO_IIIF" -s:"$SOURCE/$file" "$iiif_param1" "$iiif_param2" > "$iiif"
    fi
done
