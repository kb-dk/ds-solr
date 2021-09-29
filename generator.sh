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
: ${CONFIG:="$(dirname "$SCHEMA")/solrconfig.xml"}
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
    if [[ ! -s "$CONFIG" ]]; then
        fail "Unable to access Solr config at '$SCHEMA'" 5
    fi
}

# Extracts all <field...> definitions from the schema
# Handles newlines inside of the definition properly
# Caches the result: Subsequent calls are fast
# <field name="_version_" type="long"/>
get_field_lines() {
    if [[ -z "$FIELD_LINES" ]]; then
        FIELD_LINES=$(tr $'\n' ' ' < "$SCHEMA" | grep -o "<field [^>]*>")
    fi
    echo "$FIELD_LINES"
}

# Extracts all <fieldType...> definitions from the schema (only the opening tag)
# Handles newlines inside of the definition properly
# Caches the result: Subsequent calls are fast
# <fieldType name="int"        class="solr.IntPointField"    indexed="true"  docValues="true" stored="false" multiValued="false" sortMissingLast="true" />
get_fieldtype_lines() {
    if [[ -z "$FIELDTYPE_LINES" ]]; then
        FIELDTYPE_LINES=$(tr $'\n' ' ' < "$SCHEMA" | grep -o "<fieldType [^>]*>")
    fi
    echo "$FIELDTYPE_LINES"
}

# Extract all <str name="f.FIELD.qf"... definitions from solrconfig
# Caches the result: Subsequent calls are fast
# <str name="f.title.qf">title_org^1.8 title_norm</str>
get_alias_lines() {
    if [[ -z "$ALIAS_LINES" ]]; then
        ALIAS_LINES=$(tr $'\n' ' ' < "$SCHEMA" | grep -o '<str [^>]*name="f[.][^>]*[.]fq"[^>]*>[^<]*<[^>]*>')
    fi
    echo "$ALIAS_LINES"
}
get_alias_lines
exit

# Resolves an attribute value, using the field and fieldType definition
# Input: attribute_name default field_line type_line
resolve_attribute() {
    local ATTRIBUTE="$1"
    local DEFAULT="$2"
    local FL="$3"
    local TL="$4"
#>&2 echo "a:$ATTRIBUTE d:$DEFAULT fl:$FL tl:$TL"
    local RESULT=""
    : ${RESULT:="$(grep " ${ATTRIBUTE}"'="\([^"]*\)".*' <<< "$TL" | sed 's/.* '${ATTRIBUTE}'="\([^"]*\)".*/\1/')"}
    : ${RESULT:="$(grep " ${ATTRIBUTE}"'="\([^"]*\)".*' <<< "$FL" | sed 's/.* '${ATTRIBUTE}'="\([^"]*\)".*/\1/')"}
    : ${RESULT:="$DEFAULT"}
    echo "$RESULT"
}
#resolve_attribute multiValued false '<field name="logical_path"     type="descendent_path" multiValued="true"/>' 'fieldType name="descendent_path" class="solr.TextField">'

# Derives the field definition from the field and field type.
# Input: fieldname
#
# Sets most of the variables from https://solr.apache.org/guide/8_0/field-type-definitions-and-properties.html#field-type-definitions-and-properties
# FIELD: Field name
# TYPE: Field type (<fieldType name="TYPE"...>)
# CLASS: solr.IntPointField et al
# INDEXED: boolean
# DOCVALUES: boolean
# STORED: boolean
# MULTIVALUED: boolean
# OMIT_NORMS: boolean
# OMIT_TF_AND_POS: boolean
# OMIT_POS: boolean
# TERM_VECTORS: boolean
# TERM_POSITIONS: boolean
# TERM_OFFSETS: boolean
# TERM_PAYLOADS: boolean
resolve_field_def() {
    FIELD="$1"

    #     <field name="_version_" type="long"/>

    local FIELD_LINE="$(grep -o "<field [^>]*name=\"$FIELD\"[^>]*>" <<< $(get_field_lines))"
    if [[ -z "$FIELD_LINE" ]]; then
        fail "Inconsistent internal operation: Unable to locate definition for field '$FIELD' in schema '$SCHEMA'" 10
    fi
    TYPE="$(sed 's/.* type="\([^"]*\)".*/\1/' <<< "$FIELD_LINE")"
    if [[ -z "$TYPE" ]]; then
        fail "Unable to derive type for field '$FIELD' in schema '$SCHEMA'" 11
    fi

    local TYPE_LINE="$(grep -o "<fieldType [^>]*name=\"$TYPE\"[^>]*>" <<< $(get_fieldtype_lines))"
    if [[ -z "$TYPE_LINE" ]]; then
        fail "Inconsistent internal operation: Unable to locate definition for fieldType '$TYPE' in schema '$SCHEMA'" 12
    fi

    CLASS="$(sed 's/.* class="\([^"]*\)".*/\1/' <<< "$TYPE_LINE")"
    # TODO: Solr has different defaults for different fields and these should be handled
    
    # <fieldType name="int"        class="solr.IntPointField"    indexed="true"  docValues="true" stored="false" multiValued="false" sortMissingLast="true" />
    INDEXED="$(resolve_attribute indexed true "$FIELD_LINE" "$TYPE_LINE")"
    DOCVALUES="$(resolve_attribute docValues false "$FIELD_LINE" "$TYPE_LINE")"
    STORED="$(resolve_attribute stored false "$FIELD_LINE" "$TYPE_LINE")"
    MULTIVALUED="$(resolve_attribute multiValued false "$FIELD_LINE" "$TYPE_LINE")"

    # TODO: Only output the attributes below for text fields
    
    if [[ "$TYPE" == "solr.TextField" ]]; then
        local DEF_OMIT_NORMS="false"
        local DEF_OMIT_TF_AND_POS="false"
        local DEF_OMIT_POS="false"
    else
        local DEF_OMIT_NORMS="true"
        local DEF_OMIT_TF_AND_POS="true"
        local DEF_OMIT_POS="true"
    fi
    OMIT_NORMS="$(resolve_attribute omitNorms $DEF_OMIT_NORMS "$FIELD_LINE" "$TYPE_LINE")"
    OMIT_TF_AND_POS="$(resolve_attribute omitTermFreqAndPositions $DEF_OMIT_TF_AND_POS "$FIELD_LINE" "$TYPE_LINE")"
    OMIT_POS="$(resolve_attribute omitPositions $DEF_OMIT_POS "$FIELD_LINE" "$TYPE_LINE")"
    
    TERM_VECTORS="$(resolve_attribute term_vectors $TERM_VECTORS false "$FIELD_LINE" "$TYPE_LINE")"
    TERM_POSITIONS="$(resolve_attribute term_positions false "$FIELD_LINE" "$TYPE_LINE")"
    TERM_OFFSETS="$(resolve_attribute term_offsets false "$FIELD_LINE" "$TYPE_LINE")"
    TERM_PAYLOADS="$(resolve_attribute term_payloads false "$FIELD_LINE" "$TYPE_LINE")"

    # TODO: Alias from solrconfig.xml
    # TODO: Alias description
    # <str name="f.title.qf">title_org^1.8 title_norm</str>
    

}
    
# Extracts all field names, except IGNORED, from the schema
get_fields() {
    #     <field name="_version_" type="long"/>
    local FIELDS=$(sed 's/.*name="\([^"]*\)".*/\1/' <<< $(get_field_lines))
    for IGNORED in $IGNORED_FIELDS; do
        if [[ -z "$IGNORED" ]]; then
            continue
        fi
        local FIELDS="$(grep -v "^$IGNORED$" <<< "$FIELDS")"
    done
    echo "$FIELDS"
}

# Get comment content immediately before the field definition, if any
# Input: Fieldname
# TODO: Make a better grep that supports '>' inside of comments
get_meta() {
    local FIELD="$1"
    #     <!-- Some comment
    #          possibly on multiple lines -->
    # Last head is to remove trailing NUL char (0)
    grep -azoP "<!-- [^>]*-->[^<]*<field [^>]*name=\"$FIELD\"[^>]*>" "$SCHEMA" | grep -azoP "<!-- [^>]*-->" | sed -e 's/<!-- *//' -e 's/ *-->//' | grep -av "^$" | head -c -2
    #     <field name="_version_" type="long"/>
}

# Replaces newlines with \n and escapes " with \"
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
    resolve_field_def "$FIELD" 
# FIELD: Field name
# TYPE: Field type (<fieldType name="TYPE"...>)
# CLASS: solr.IntPointField et al
# INDEXED: boolean
# DOCVALUES: boolean
# STORED: boolean
# MULTIVALUED: boolean
# OMIT_NORMS: boolean
# OMIT_TF_AND_POS: boolean
# OMIT_POS: boolean
# TERM_VECTORS: boolean
# TERM_POSITIONS: boolean
# TERM_OFFSETS: boolean
# TERM_PAYLOADS: boolean
    
    # <copyField source="title"      dest="title_sort"/>
    local COPY_DESTS="$(grep "<copyField [^>]*source=\"$FIELD\"[^>]*>" "$SCHEMA" | sed 's/.* dest="\([^"]*\)".*/\1/')"
    local COPY_SOURCES="$(grep "<copyField [^>]*dest=\"$FIELD\"[^>]*>" "$SCHEMA" | sed 's/.* source="\([^"]*\)".*/\1/')"
     
    # TODO: Alias from solrconfig.xml
    # TODO: Nest the Solr-specific parts
    # TODO: Add solr_class description
    # TODO: Add class-specific hints
    
    local JSON_ELEMENTS=$(comma_lines "$(cat <<EOF
  "name": "$FIELD"
  "type": "$TYPE"
  "solr_class": "$CLASS"
  "indexed": "$INDEXED"
  "doc_values": "$DOCVALUES"
  "stored": "$STORED"
  "multi_valued": "$MULTIVALUED"
  "omit_norms": "$OMIT_NORMS"
  "omit_term_freq_and_positions": "$OMIT_TF_AND_POS"
  "omit_positions": "$OMIT_POS"
  "term_vectors": "$TERM_VECTORS"
  "term_positions": "$TERM_POSITIONS"
  "term_offsets": "$TERM_OFFSETS"
  "term_payloads": "$TERM_PAYLOADS"
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
