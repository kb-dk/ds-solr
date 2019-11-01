#!/bin/bash

SOLR_HOST=$1

echo "Solr host is to be found on: '$SOLR_HOST'"

curl 'http://ds-solr-test:10007/solr/ds/select?q=*%3A*'

echo "Toes here's to you ;)"

exit 1

