# Nested data and the SOLR search engine

## Introduction

The Royal Danish Library has been using the SOLR
(https://solr.apache.org/) search engine for at least a decade. Almost
all projects that need some search facilities is using it. A Swiss
army knife for searching in small as well as well as big data sets. A
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
packages of attributes and values, but also much less structure than what
you expect from data in [database normal
form](https://en.wikipedia.org/wiki/Database_normalization). Bibliographical
data may for instance describe texts that

* have one or more titles
* have more than one author
* each author may have dates of birth and death 
* each of them may have an affiliation 

If we were using a RDBMS, the data on persons could be stored in one
database table, the titles in another and there could be a third table
keeping track (through foreign keys) of each persons relations to the
works to which they've contributed. Someone made the illustrations,
someone else wrote the texts. A third one made the graphical design.

These data are important. For instance the dates are used for
distinguishing between people with the same name. (The digital phone
book krak.dk lists 43 now living persons named _Søren Kierkegaard_,
while _the philosopher_ died 1855). Another use case is how to decide
whether a given object is free from copyright or not, such as when the
originator has been dead for more than 75 years.

Add to this that there are many more complications, like we may have
multiple copies of a given title and that each copy may belong to different
collections with very different provenance. For historical objects we
may even have a manuscript in the manuscript and rare books department
and a modern pocket book in the open stocks.

The role of the data are to enable library patrons and service users
to search and retrieve. Typically users type a single word in the
search form, while ignoring the handful of fields that we provide
through the effort of catalogers, software developers etc.

The user gets a far too long list of results which contains author,
title and perhaps some subjects or keywords. Again typically, the user
clicks on a title an gets a landing page. This is far more detailed;
it presents many fields that will enable users to decide whether to
order or retrieve the object.

If we grossly simplify the process, a user might be up to one of two
things: (1) Finding a given reference or (2) Finding information on a
topic. See these two as endpoints on a scale. You may look for a
particular book Enten - Eller (Either/Or) by Kierkegaard or you might
be interested in the role of this philosopher in your study of the
origin of existentialism. In the former case you actually look for
Kierkegaard in the author field, in the latter case you look for him
in subject field.

## How to cope

