#!/bin/bash

curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-corpus/albert-einstein.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-corpus/simonsen-brandes.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-corpus/hvidovre-teater.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-corpus/tystrup-soroe.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-corpus/responsa.json
work_on_logic.json
curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: application/json" --data-binary @nested-corpus/homiliae-super-psalmos.json