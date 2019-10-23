
echo "Uploading ds-conf"
$SOLR_DIR/bin/solr zk upconfig -z localhost:11007 -d template/ -n ds-conf

echo "Creating ds collection"
$SOLR_DIR/bin/solr create_collection -c ds -n ds-conf
