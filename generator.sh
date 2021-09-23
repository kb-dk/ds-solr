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
    local FIELDS=$(grep -o '<field  *name="[^"]*" [^>]*>' "$SCHEMA" | sed 's/.*name="\([^"]*\)".*/\1/')
    echo "$FIELDS"
    for IGNORED in $IGNORED_FIELDS; do
        if [[ -z "$IGNORED" ]]; then
            continue
        fi
        local FIELDS="$(grep -v "^$IGNORED$" <<< "$FIELDS")"
    done
    echo "$FIELDS"
}

# Get comment content immediately before the field definition
# Input: Fieldname
get_meta() {
    local FIELD="$1"
    #     <!-- Some comment
    #          possibly on multiple lines -->
    #     <field name="_version_" type="long"/>
    echo "N/A"
}

# Replaces newlines with \n and escapes " to \"
json_escape() {
    sed -e 's/$/\\n/g' -e 's/"/\\"/g' <<< "$1" | tr -d $'\n' | sed 's/\\n$//'
}

# Outputs a JSON key:"value" if the value is present.
# The value is treated as a String
# Input: key value
if_exists() {
    local KEY="$1"
    local VALUE="$2"
    if [[ ! -z "$VALUE" ]]; then
        echo "\"${KEY}\": \"$(json_escape "$VALUE")\","
    fi
}

# Outputs key:[ "val1", "val2" ], if any values are present.
# Values are newline delimited in the input, so single values containing newlines are not recognized
# Input: key values
if_exists_multi() {
    local KEY="$1"
    local VALUES="$2"
    if [[ ! -z "$VALUES" ]]; then
        echo "\"${KEY}\": [ $(sed -e 's/^\(.*\)$/"\1"/' -e 's/$/, /g' <<< "$VALUES" | tr -d $'\n' | sed 's/, $//' ) ],"
    fi
}

# Takes a multiline input and appends a comma to each line, except the last one
# Also removes empty lines
comma_lines() {
    local LINES="$1"
    sed -e 's/$/,/g' -e 's/^,$//' <<< "$LINES" | grep -v "^ *,$" | head -c -2
}

# Represent all properties for a field
# Input: Fieldname
describe_single_field() {
    local FIELD="$1"
    local META="$(get_meta "$FIELD")"

    #     <field name="_version_" type="long"/>
    local DEFINITION="$(grep "<field [^>]* name=\"$FIELD\"[^>]*>" "$SCHEMA")"
    local DEFINITION="$(grep "<field [^>]*name=\"$FIELD\"[^>]*>" "$SCHEMA")"
    if [[ -z "$DEFINITION" ]]; then
        fail "Inconsistent internal operation: Unable to locate definition for field '$FIELD' in schema '$SCHEMA'" 10
    fi
    local TYPE="$(sed 's/.* type="\([^"]*\)".*/\1/' <<< "$DEFINITION")"
    if [[ -z "$TYPE" ]]; then
        fail "Unable to derive type for field '$FIELD' in schema '$SCHEMA'" 11
    fi
    
    # <copyField source="title"      dest="title_sort"/>
    local COPY_DESTS="$(grep "<copyField [^>]*source=\"$FIELD\"[^>]*>" "$SCHEMA" | sed 's/.* dest="\([^"]*\)".*/\1/')"
    local COPY_SOURCES="$(grep "<copyField [^>]*dest=\"$FIELD\"[^>]*>" "$SCHEMA" | sed 's/.* source="\([^"]*\)".*/\1/')"
     
    # TODO: Alias from solrconfig.xml
    # TODO: stored docValues multiValued indexed
    local JSON_ELEMENTS=$(comma_lines "$(cat <<EOF
  "name": "$FIELD"
  "type": "$TYPE"
  $(if_exists description "$DESCRIPTION")
  $(if_exists_multi copied_from "$COPY_SOURCES")
  $(if_exists_multi copied_to "$COPY_DESTS")
EOF
          )")
    cat <<EOF
{
$JSON_ELEMENTS
}
EOF
#    echo "FIELD=$FIELD TYPE=$TYPE META=$META COPY_SOURCES=$COPY_SOURCES COPY_DESTS=$COPY_DESTS" | tr $'\n' '/'
#    echo ""
}    

describe() {
    while read -r FIELD; do
        describe_single_field "$FIELD"
    done <<< $(get_fields)
}

################################################################################
# FUNCTIONS
################################################################################

###############################################################################
# CODE
###############################################################################

check_parameters "$@"

$ACTION
