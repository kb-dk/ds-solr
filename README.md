# Digitale Samlinger Solr
Solr configuration files and setup instructions for the Digitale Samlinger project

## Basics
Solr is used for handling search as well as record metadata lookup.
This repository holds Solr configurations for the different collections
represented in Digitale Samlinger.

## Installation
In production, Solr installation, updating, backup etc. is handled by Operations.

For testing, Solr should be installed locally. The local installation runs in SolrCloud mode
and uses the same setup files as production. 

1. Ensure that the current folder for the term is the `ds-solr`-checkout.
1. Download a recent and stable binary release of Solr. We refer to such a version as X.Y.Z. As of writing this, X.Y.Z=8.10.1. You can pick up such a release at https://archive.apache.org/dist/lucene/solr/   If you want to cut and paste commands use `sed 's/X.Y.Z/your.favourate.release/' README.md  | less` and run them all.
`wget 'https://archive.apache.org/dist/lucene/solr/X.Y.Z/solr-X.Y.Z.tgz'`
1. Unpack it  
`tar xzovf solr-X.Y.Z.tgz`
1. If your X.Y.Z is older than from 05/Jul/19 14:48, compensate for the [SOLR-13606](https://issues.apache.org/jira/browse/SOLR-13606) bug  
`echo 'SOLR_OPTS="$SOLR_OPTS -Djava.locale.providers=JRE,SPI"' >> solr-X.Y.Z/bin/solr.in.sh`
1. Start Solr in cloud mode  
`solr-X.Y.Z/bin/solr -c -m 1g -p 10007`    
It will probably complain about `open file` and `max processes` limits. 
That should not be a problem for small-scale testing, but medium- to large-scale,
these limits should be raised.
1. Check that the local SolrCloud is running by visiting http://localhost:10007/solr/#/
1. Upload a collection configuration to SolrCloud    
`solr-X.Y.Z/bin/solr zk upconfig -z localhost:11007 -d template/ -n ds-conf` 
alternatively use `curl`
`cd template/conf/ ; zip -q -r t.zip * ; curl -X POST --header "Content-Type:application/octet-stream" --data-binary @t.zip "http://localhost:10007/solr/admin/configs?action=UPLOAD&name=ds-conf" ; rm t.zip ; cd -`
1. Create a collection in SolrCloud  
`solr-X.Y.Z/bin/solr create_collection -c ds -n ds-conf` 
alternatively use `curl`
`curl 'http://localhost:10007/solr/admin/collections?action=CREATE&name=ds&collection.configName=ds-conf&numShards=1&replicationFactor=1&wt=xml'`
1. Check that the collection was created by visiting 
[http://localhost:10007/solr/#/~cloud?view=graph](http://localhost:10007/solr/#/~cloud?view=graph)
1. Index a sample document  
`curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: text/xml" --data-binary @test/sample_document_1.xml`
1. Check that the document was indexed by performing a manual search through the 
[Solr admin web interface](http://localhost:10007/solr/#/ds/query) or with curl  
`curl 'http://localhost:10007/solr/ds/select?wt=json&q=*:*'`
1. Stop Solr with  
`solr-X.Y.Z/bin/solr stop -p 10007` 

After this, Solr can be started and stopped with  
`solr-X.Y.Z/bin/solr -c -m 1g -p 10007`  
and
`solr-X.Y.Z/bin/solr stop -p 10007`  
without losing any documents.

Documents, such at the `XML`-file produced by [ds-cumulus-export](https://github.com/Det-Kongelige-Bibliotek/ds-cumulus-export), are indexed in Solr with  
`solr-X.Y.Z/bin/post -p 10007 -c ds indexThisInSolr.xml`

All documents in the collection can be deleted with
`curl "http://localhost:10007/solr/ds/update?commit=true" -H "Content-Type: text/xml" --data-binary '<delete><query>*:*</query></delete>'`

## Search tips
1. Search for all material geographically with [geo rectangle](https://lucene.apache.org/solr/guide/8_1/spatial-search.html#filtering-by-an-arbitrary-rectangle)  
`curl` ['http://localhost:10007/solr/ds/select?wt=json&q=location_coordinates:\[54.0,9.0+TO+59.0,12.0\]&fl=*,\[child\]'](http://localhost:10007/solr/ds/select?wt=json&q=location_coordinates:\[54.0,9.0+TO+59.0,12.0\]&fl=*,\[child\])

2. Search for manuscripts completed early 16th century, e.g., [1500 - 1550]
 `curl`[http://localhost:10007/solr/ds/select?wt=json&q=not_before_date:\[1500 TO *\] AND not_after_date:\[* TO 1550\]&fl=*,\[child\]](http://localhost:10007/solr/ds/select?wt=json&q=not_before_date:\[1500+TO+*\]+AND+not_after_date:\[*+TO+1550\]&fl=*,\[child\])

## Fields
Field names are lowercase and `_` is the separation character.

The fields defined in the different `schema.xml` are sought to be shared as much as possible
 between the different collections. As such, there are three different types of fields. 
 See [the template schema.xml](template/conf/schema.xml) for details.

### Mandatory fields
Must be in all documents. There are only 3 mandatory fields that needs to be provided:
`id`, `type` and `collection`.

## Common fields
Common fields are the fields that are used in different collections in the same way.
Simple examples are `title`, `keyword` and `width_pixels`. Common fields are defined
the same way for all collections and are preferred over collection-specific fields:
Although `width_pixels` only currently makes sense for the image collection, it could
concievably be used for an upcoming newspaper collection and is thus a common field.

### Collection specific fields
Fields that are expected only to be used for the given collection. This could be
`newspaper_edition` or `cumulus_preservation_status_enumeration`. Preferably the
collection specific fields should be prefixed to indicate where they belong.

When writing the documentation for a collection specific field (as an XML comment
above the field definition), do state the source field, e.g. _"Corresponds to
 Preservation_statusenumeration in KB-Cumulus."_ 


## Principles
Be generous with indexing: Solr is the primary metadata delivery mechanism, so it should be
possible to get all relevant metadata for a given material from a Solr document lookup. 

## MoreLikeThis
To get results from solr for content similar to search word, send a query to solr with mlt=true. For example, to search for entries that have “Vilhelm” in their “keyword" and "title” field, we use the following:
 curl "http://localhost:10007/solr/ds/select?q=Vilhelm&mlt=true&mlt.fl=keyword,title"
In this example, solr returns all entries that have "Vilhelm" in their "keyword" and "title" field
