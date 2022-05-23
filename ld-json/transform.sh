#!/bin/bash

: ${INPUT:="$1"}
: ${XSLT:="mods2schemaorg.xsl"}

source ../nested-solr-stuff/transform.sh
