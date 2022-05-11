#!/bin/bash

: ${INPUT:="$1"}
: ${XSLT:="mods2solr.xsl"}

: ${SAXON_JAR:="/home/$USER/saxon/saxon9he.jar"}
SAXON="java -jar "$SAXON_JAR" --suppressXsltNamespaceCheck:on  "
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
if [[ ! -s "$INPUT" ]]; then
    >&2 echo "No inputfile"
    echo ""
    echo "Usage: ./transform.sh <inputfile>"
    exit 2
fi
if [[ ! -s "$XSLT" ]]; then
    >&2 echo "No XSLT '$XSLT'"
    echo ""
    echo "Usage: ./transform.sh <inputfile>"
    exit 2
fi


# set to 1 if you want to prettyprint you json

#json=$(sed 's/.xml$/.json/' <<< "$file")
$SAXON -xsl:"$XSLT" -s:"$INPUT" | jq .
