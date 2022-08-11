# Nested data and the SOLR search engine

## Introduction

The Royal Danish Library has been using the SOLR
(https://solr.apache.org/) search engine for at least a decade. Almost
all projects that need some search facilities is using it. A Swiss
army knife for searching in small as well as well as big datasets. A
trusty tool that provide many advantages to the alternative to use a
relational database management system (RDBMS) when working with
resource discovery systems.

At the first SOLR workshop I participated the teacher reiterated over
and over again that SOLR is a search engine, not a data management
tool. Although SOLR can Create, Retrieve, Update and Delete
([CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete))
documents, the transactions cannot really be characterized as having
Atomicity, Consistency, Isolation and Durability
([ACID](https://en.wikipedia.org/wiki/ACID)).

## The role of bibliographic structure

In a library we encounter data with much more structure than simple
packages attributes and values, but also much less structure than what
you expect from data in [database normal
form](https://en.wikipedia.org/wiki/Database_normalization). Bibliographical
data may for instance describe texts that

* have one or more titles
* have more than one author
* each author may have dates of birth and death 
* each of them may have an affiliation 

The data on persons could be stored in one database table, the titles
in another and there could be a third table keeping track of each
persons relations to the works to which they've contributed. Someone
made the illustrations, someone else wrote the texts.

These data are important. For instance the dates are used for
distinguishing between people with the same name, as well as deciding
if a given object is free from copyright or not.

Add to this that there are many more complications, like we may have
multiple copies of a given title and each copy may belong to different
collections with very different provenance. For historical objects we
may even have a manuscript in the manuscript and rare books department
and a modern pocket book in the open stocks.



