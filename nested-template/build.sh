#!/bin/bash
export SAXON="java -jar  /home/slu/saxon/saxon9he.jar "

$SAXON -xsl:schema_to_md.xsl conf/schema.xml  > README.md
