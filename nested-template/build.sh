#!/bin/bash

: ${SAXON_JAR:="/home/$USER/saxon/saxon9he.jar"}
if [[ ! -s "$SAXON_JAR" ]]; then
    >&2 echo "$SAXON_JAR not available. Please install it from https://sourceforge.net/projects/saxon/files/Saxon-HE/"
    exit 2
fi

export SAXON="java -jar $SAXON_JAR "

$SAXON -xsl:schema_to_md.xsl conf/schema.xml  > README.md
