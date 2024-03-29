#!/bin/bash

#
# Sends a commit to the Solrcloud
#

###############################################################################
# CONFIG
###############################################################################

if [[ -s "cloud.conf" ]]; then
    source "cloud.conf"     # Local overrides
fi
pushd ${BASH_SOURCE%/*} > /dev/null
if [[ -s "cloud.conf" ]]; then
    source "cloud.conf"     # Project overrides
fi
source general.conf
: ${CLOUD:=`pwd`/cloud}
: ${SOLR:="$HOST:$SOLR_BASE_PORT/solr"}
: ${COLLECTION:="$1"}
popd > /dev/null

function usage() {
    echo "Usage: ./cloud_commit.sh collection"
    exit $1
}

check_parameters() {
    if [ ! -d ${CLOUD}/$VERSION ]; then
        >&2 echo "The Solr version $VERSION is not installed."
        >&2 echo "Please run ./install_cloud.sh $VERSION"
        usage 3
    fi
    if [[ "." == ".$COLLECTION" ]]; then
        echo "No collection specified. Available collections are"
        curl -s "$SOLR/admin/collections?action=LIST" | jq -r '.collections[]'
        #grep -o "<arr name=.collections.*</arr>" | grep -o "<str>[^<]*</str>" | sed 's/<\/*str>//g'
        echo ""
        usage 4
    fi
}

################################################################################
# FUNCTIONS
################################################################################

commit_collection() {
    curl -s "$SOLR/${COLLECTION}/update?commit=true"
}

###############################################################################
# CODE
###############################################################################

check_parameters "$@"
commit_collection
