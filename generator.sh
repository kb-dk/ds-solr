#!/bin/bash

#
# Generates OpenAPI and descriptive JSON scippets for the annotated fields in
# the Solr schema.
#

###############################################################################
# CONFIG
###############################################################################


if [[ -s "generator.conf" ]]; then
    source "generator.conf"     # Local overrides
fi
pushd ${BASH_SOURCE%/*} > /dev/null
if [[ -s "generator.conf" ]]; then
    source "generator.conf"     # Overall defaults
fi
SHOME=`pwd`
: ${ACTION:="$1"}
: ${ACTION:="describe"}
: ${SCHEMA:="${SHOME}/template/conf/schema.xml"}
popd > /dev/null
ACTIONS="describe" # Only 1 for now. TODO: Expand with openapi
: ${IGNORED_FIELDS:="_version_"} # Space separated

function usage() {
    cat <<EOF
"Usage: ./generator.sh action"

Where action can be

 describe: Generate a JSON structure with all fields, descriptions and hints

EOF
    exit $1
}
function fail() {
    local MESSAGE="$1"
    local RETURN_CODE="$2"
    if [[ ! -z "$MESSAGE" ]]; then
        >&2 echo "Error: $MESSAGE"
        >&2 echo ""
    fi
    usage $RETURN_CODE
}

check_parameters() {
    if [[ -z "$ACTION" ]]; then
        fail "Please state an output" 3
    fi
    if [[ -z "$(grep " $ACTION " <<< " $ACTIONS ")" ]]; then
        fail "Output was '$ACTION' but only $ACTIONS are supported" 4
    fi
    if [[ ! -s "$SCHEMA" ]]; then
        fail "Unable to access Solr schema at '$SCHEMA'" 5
    fi
}

get_fields() {
    #     <field name="_version_" type="long"/>
    local FIELDS=$(grep -o "<field  *name=\"[^\"]\"  .*" | sed 's/.*name="\([^"]\)".*/\1/')
    for IGNORED in $IGNORED_FIELDS; do
        local FIELDS="$(grep -v "^$IGNORED$" <<< "$FIELDS")"
    done
    echo "$FIELDS"
}

describe() {
    get_fields
}

################################################################################
# FUNCTIONS
################################################################################

###############################################################################
# CODE
###############################################################################

check_parameters "$@"

$ACTION
