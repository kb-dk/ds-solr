#!/bin/bash

SOLR_HOST=$1

echo "Solr host is to be found on: '$SOLR_HOST'"

echo "curl https://$SOLR_HOST/solr/ds/select?q=*%3A*"
curl "https://$SOLR_HOST/solr/ds/select?q=*%3A*"

echo "Toes here's to you ;)"

exit 1

