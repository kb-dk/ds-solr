#!/bin/bash

pushd ${BASH_SOURCE%/*} > /dev/null
cd ..

curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @solr-summary-records/albert-einstein.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @solr-summary-records/simonsen-brandes.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @solr-summary-records/hvidovre-teater.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @solr-summary-records/tystrup-soroe.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @solr-summary-records/responsa.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @solr-summary-records/work_on_logic.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @solr-summary-records/homiliae-super-psalmos.json

popd > /dev/null
