# Nested data and the SOLR search engine

> Are passions, then, the Pagans of the soul? <br>
> Reason alone baptized? alone ordain'd <br>
> To touch things sacred? <br>
> (Edward Young -- 1683-1765)

## Introduction

The Royal Danish Library has been using the Solr
(https://solr.apache.org/) search engine for at least a decade. Almost
all projects that need some search facilities are using it. A Swiss
army knife for searching in small as well as well as big data sets. A
trusty tool that provide many advantages to the alternative to use a
relational database management system (RDBMS) when working with
resource discovery systems.

At the first Solr workshop I participated the teacher reiterated over
and over again that Solr is a search engine, not a data management
tool. Although Solr can Create, Retrieve, Update and Delete
([CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete))
documents, the transactions cannot really be characterized as having
Atomicity, Consistency, Isolation and Durability
([ACID](https://en.wikipedia.org/wiki/ACID)).

## The role of bibliographic structure

In a library we encounter data with much more structure than simple
packages of attributes and values, but also much less structure than what
you expect from data in [database normal
form](https://en.wikipedia.org/wiki/Database_normalization). Bibliographical
data may *for instance* describe texts that

* have one or more titles, each having different type (main title, subtitle, transcribed title, uniform title to iterate some of the frequently used ones)
* may have one or more authors that may be persons or organizations
* each of which may have dates of birth and death 
* and an affiliation 

If we were using a RDBMS, the data on persons could be stored in one
database table, the titles in another and there could be a third table
keeping track (through foreign keys) of each persons relations to the
works to which they've contributed. Someone made the illustrations,
someone else wrote the texts. A third one made the graphical design.

For a portrait photograph we have one person being the photographer,
and another being the subject. The data on the subject can be as
important as the data on the artist.

These data are important. For instance the dates are used for
distinguishing between people with the same name. (The digital phone
book krak.dk lists 43 now living persons named _Søren Kierkegaard_,
while _the philosopher_ died 1855). An import use case is how to decide
whether a given object is free from copyright or not, such as when the
originator has been dead for more than 75 years.

Add to this that there are many more complications, like we may have
multiple copies of a given title and that each copy may belong to different
collections with very different provenance. For historical objects we
may even have a manuscript in the manuscript and rare books collections
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
things: (1) Finding or resolving a given reference, i.e., the right
object, perhaps the right edition. Or (2) Finding information on a
given topic. See these two as endpoints on a scale.

You may look for a particular book Enten - Eller (Either/Or) by
Kierkegaard (1843) or you might be interested in the role of this
philosopher in your study of the origin of existentialism. In the
former case you actually look for Kierkegaard in the author field, in
the latter case you look for him in subject field.

![Enten - eller cover page](http://kb-images.kb.dk/public/sks/ee1/ill_k1/full/full/0/native.jpg)

## Encoding, indexing and using

Assume we are about to add metadata on _Enten - eller_ by _Søren
Kierkegaard_ into a Solr index. What we get for that book might 
contain the data below. The example is encoded in a format called
[Metadata Object Description
Schema](https://www.loc.gov/standards/mods/). Note that the namespace
prefix `md` stands for the URI `http://www.loc.gov/mods/v3`

```
  <md:titleInfo>
    <md:title>Enten - eller</md:title>
    <md:subTitle>Et livsfragment</md:subTitle>
  </md:titleInfo>

  <md:name displayLabel="Author"
           type="personal"
           authorityURI="https://viaf.org/viaf/7392250/"
           xml:lang="en">
    <md:namePart type="family">Kierkegaard</md:namePart>
    <md:namePart type="given">Søren</md:namePart>
    <md:namePart type="date">1813/1855</md:namePart>
    <md:alternativeName altType="pseudonym">
      <md:namePart>Victor Eremita</md:namePart>
      <md:description>“Victorious hermit,” general editor of
      Either/Or, who also appears in the first part of its sequel,
      Stages on Life’s Way. Also the author of the satirical article
      “A Word of Thanks to Professor Heiberg.”</md:description>
    </md:alternativeName>
    <md:role>
      <md:roleTerm type="code">aut</md:roleTerm>
    </md:role>
  </md:name>
  
  <md:originInfo>
    <md:dateCreated>1843</md:dateCreated>
    <md:publisher>Universitetsboghandler C. A. Reitzel</md:publisher>
  </md:originInfo>
  
```

The work has a `title` and `name`. The name has a `role` (`aut` as in
author) and parts like family (Kierkegaard), given (Søren) and a date
(1813/1855 which is ISO's way to express a [date range](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/date/), i.e., the years
between which the philosopher was alive. His _Fragment of Life_.)

To get the birth and death dates you have to parse a string. As a
matter of fact, the name on the book cover wasn't Søren Kierkegaard,
but Victor Eremita (Victorious hermit), encoded as an
alternativeName. A telling pseudonym of the author of The Seducer's
Diary. [Søren was good at pseudonyms](https://www.reddit.com/r/philosophy/comments/1n2opm/a_whos_who_of_kierkegaards_formidable_army_of/).

Now we've identified a lot of possible fields to use, for cataloging
and for information retrieval. They have perfectly reasonable use
cases, and all of them are used in everyday library practice, so how
do I get them into my Solr index?

# The attempt

We have tried to put such records into Solr. The attempt was
successful. In the rest of this paper I will outline how we did that,
learn you a bit on how to use such an index and finally why decided
not to implement it.

If you are familiar with the workings of Solr, you know that the
datamodel (if I may label it as such) used is configured in a file
call `schema.xml`. It basically contains list of fields that can be
used in what is referred to as `Solr documents`. In such a schema you
may add 

```
    <field     name="_nest_path_" type="_nest_path_" stored="true" indexed="true" />
    <field     name="_nest_parent_" type="string" indexed="true" stored="true" />
```

the former of which is of the following type:

```
    <fieldType name="_nest_path_" class="solr.NestPathField" />
```

See the [Indexing Nested Child Documents](https://solr.apache.org/guide/8_1/indexing-nested-documents.html).




