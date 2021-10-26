#!/bin/bash

java -jar  /home/slu/saxon/saxon9he.jar -xsl:schema_to_md.xsl conf/schema.xml  > README.md
