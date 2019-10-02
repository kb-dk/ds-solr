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

1. Download Solr 8.2 binary release from https://lucene.apache.org/solr/downloads.html  
`wget 'http://mirrors.dotsrc.org/apache/lucene/solr/8.2.0/solr-8.2.0.tgz'`
1. Unpack it  
`tar xzovf solr-8.2.0.tgz`
1. Start Solr in cloud mode  
`solr-8.2.0/bin/solr -c -m 1g`    
It will probably complain about `open file` and `max processes` limits. 
That should not be a problem for small-scale testing, but medium- to large-scale,
these limits should be raised.
1. Check that the local SolrCloud is running by visiting http://localhost:8983/solr/#/
1. Upload a collection configuration to SolrCloud    
`solr-8.2.0/bin/solr zk upconfig -z localhost:9983 -d template/ -n ds-conf`
1. Create a collection in SolrCloud  
`solr-8.2.0/bin/solr create_collection -c ds -n ds-conf`
1. Check that the collection was created by visiting [http://localhost:8983/solr/#/~cloud?view=graph](http://localhost:8983/solr/#/~cloud?view=graph)
1. Stop Solr with  
`solr-8.2.0/bin/solr stop` 


**TODO**: Add installation guide.

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
