#!/bin/bash

pushd ${BASH_SOURCE%/*} > /dev/null
cd ..

curl "http://localhost:10007/solr/ds-structured/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-solr-stuff/albert-einstein.json
curl "http://localhost:10007/solr/ds-structured/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-solr-stuff/simonsen-brandes.json
curl "http://localhost:10007/solr/ds-structured/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-solr-stuff/hvidovre-teater.json
curl "http://localhost:10007/solr/ds-structured/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-solr-stuff/tystrup-soroe.json
curl "http://localhost:10007/solr/ds-structured/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-solr-stuff/responsa.json
curl "http://localhost:10007/solr/ds-structured/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-solr-stuff/work_on_logic.json
curl "http://localhost:10007/solr/ds-structured/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-solr-stuff/homiliae-super-psalmos.json

popd > /dev/null
