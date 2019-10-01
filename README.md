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
