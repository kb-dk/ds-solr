# Data from various source within legacy datasets in  KB @ Cph

## Introduction

This directory contains

1. a corpus of metadata/data for free data sets. The metadata is in
   MODS and TEI and there are also some text in TEI.
2. a transform generating a preliminary format that would help us
   normalize different data sources into a common framework.

A small sample with data in two formats but with overlapping search
characteristics (or what to call them). Here you would be able to find
a handful of persons connected to a handful of places and a handful of
digital library objects.

| File | Source | Format | Test for  |
|:-----|:-------|:-------|:----------------|
|[henrik-hertz.xml](henrik-hertz.xml)  | [letter-corpus](https://github.com/kb-dk/letter-corpus/tree/master/letter_books/001990301/001990301_000.xml) | TEI | Search for Berlin, Hertz, Brandes |
|[oersted.xml](oersted.xml) |  [letter-corpus](https://github.com/kb-dk/letter-corpus/tree/master/letter_books/002053861/002053861_X00.xml) | TEI | Search for Ørsted, Berlin, Sorø |
|[simonsen-brandes.xml](simonsen-brandes.xml) [[json](simonsen-brandes.json)] |Simonsen's Arkiv via [cop syndication](http://www5.kb.dk/cop/syndication/letters/judsam/2011/mar/dsa/subject1952/en/) | mods & RSS2 | Search for Simonsen, Brandes, København/Copenhagen |
| [albert-einstein.xml](albert-einstein.xml) [[json](albert-einstein.json)] | Simonsen's Arkiv via [cop syndication](http://www5.kb.dk/cop/syndication/letters/judsam/2011/mar/dsa/object7871) | mods & RSS2 | Search for Simonsen, Einstein, Berlin, Copenhagen |
|[tystrup-soroe.xml](tystrup-soroe.xml) [[json](tystrup-soroe.json)] | Danmark set fra luften via [cop syndication](http://www5.kb.dk/cop/syndication/images/luftfo/2011/maj/luftfoto/object322504/da/) | mods & RSS2 | Search for Sorø |
|[hvidovre-teater.xml]( hvidovre-teater.xml) [[json]( hvidovre-teater.json)] | Museet for Dansk Bladtegning via [cop syndication](http://www5.kb.dk/cop/syndication/images/billed/2010/okt/billeder/object356751) | mods & RSS2 | Search for Hvidovre, Claus Seidel, Waage Sandø, Lane Lind, Kjeld Abell |
|[homiliae-super-psalmos.xml](homiliae-super-psalmos.xml) [[json](homiliae-super-psalmos.json)]| Homiliae super Psalmos etc -- Manuscript collection via [cop syndication](http://www5.kb.dk/cop/syndication/manus/vmanus/2011/dec/ha/object71279)| mods | Just a multipage document |
| [responsa.xml](responsa.xml) [[json](responsa.json)] |[קובץ שאלות ותשובות](http://www5.kb.dk/cop/syndication/manus/judsam/2009/sep/dsh/object41158) | mods | multilingual fields (Hebrew and English). RFC5646 language tags (Like Judeo-arabic in Hebrew script |
| [work_on_logic.xml](work_on_logic.xml) [[json](work_on_logic.json)] | | | [Maimonides](https://en.wikipedia.org/wiki/Maimonides) is still widely read by students of the history of philosophy. His bibliographic authority is on http://viaf.org/viaf/100185495 |

## Transform

The dataset has been tranformed to an experimental JSON format. That
is preliminary format until we know if an SOLR implementation actually
works.

Two pieces software have been written:

* mods2solr.xsl - transform mods metadata into json using xslt 3.1. I
  use Saxon-HE 9.8.0.14J. The most similar one available as of writing this is [9.8.0-15](https://search.maven.org/artifact/net.sf.saxon/Saxon-HE/9.8.0-15/jar)
```
  <dependency>
	  <groupId>net.sf.saxon</groupId>
	  <artifactId>Saxon-HE</artifactId>
	  <version>9.8.0-15</version>
  </dependency>
```
* build.sh, which just runs the transforms. It uses <kbd>[jq](https://stedolan.github.io/jq/)</kbd> -
  commandline JSON processor for prettyprinting and syntax
  checking. It is for making the resulting JSON debuggable. Available
  as standard module for most linux distros.
  
## Encoding details

### Relators

Agent's (i.e., entities having a specified relation to the work
described) roles are named according to [marc relator
  list](https://www.loc.gov/marc/relators/relaterm.html) at library of
congress. The mods name field has been translated into a field given
by its relator code. Hence
  
  
```
    <md:name type="personal" xml:lang="he">
        <md:namePart>משה בן מימון</md:namePart>
        <md:role>
            <md:roleTerm type="code">aut</md:roleTerm>
        </md:role>
    </md:name>
```

is transformed to

```
"aut": { 
        "id": "/manus/judsam/2009/sep/dsh/object27137-disposable-subrecord-d3e54",
        "lang": "he",
        "name": "משה בן מימון"
   }
```

There are perhaps a handfull relators in use.

* act - actor
* art - artist (in this example a cartoonist)
* aut - author
* creator - a general originator role
* ctb - Contributor
* rcp - Addressee (as in recipient of a letter)
* scr - Scribe
* trl - Translator

I propose that the search user interface have three Agent role aggregations 

* creator
* contributor
* other person

*Creator* should contain author, artist etc. *Contributor* should
contain translator, scribe etc. *Other person* should for example
contain recipient (addressee) and persons as subjects, that is a
person depicted in a photograph or a person biographed in a biography.

### Cumulus categories

The category system is such that it includes basically a set
breadcrumb paths under which the resource can be found. I am convinced
that the category based search and navigation is obsoleted by facetted
search. Still, I have included the categories in these records. They
are given like the following:

```
 "categories": [
      {
        "id": "/manus/judsam/2009/sep/dsh/subject315",
        "da": "David Simonsens Håndskrifter",
        "en": "The David Simonsen Manuscripts"
      },
      {
        "id": "/manus/judsam/2009/sep/dsh/subject319",
        "da": "Sprog",
        "en": "Language"
      },
      {
        "id": "/manus/judsam/2009/sep/dsh/subject320",
        "da": "Hebraisk",
        "en": "Hebrew"
      },
	  ...

```

They are bilingual and hopefulle should be able to use that in
generating the facetting. 

What before appeared as 

```
"The David Simonsen Manuscripts"q->  "Language" -> "Hebrew"
```

will now be three independent facets. However. If you click on facet
"The David Simonsen Manuscripts" all objects will have "Language" as
one of the most commont facets. If you click on Language you will get
Hebre, Yiddish, Ladino etc. I.e., users that are used to the
categories will get same function in a slightly different fashion.

### Subrecord identifiers

I have been through some of the files and actually improved them when
it comes to identification; I have added some basic linked data
capabilities by identifying persons using [VIAF
permalinks](https://www.oclc.org/en/viaf.html).

Most nested records will, however, not have persistent
identification. I then generate and ID having the following form:

```
 "title": [
      {
        "id": "/images/billed/2010/okt/billeder/object356751-disposable-subrecord-d3e13",
        "lang": "da",
        "main": "Hvidovre Teater"
      }
    ]
```

The ID should be unique in the index given the way it is created. Note
that we added -disposable-subrecord- followed by a record ID inside
the mods.

Assuming that we want to delete record with ID
/images/billed/2010/okt/billeder/object35675

we should be able to do using a http POST of  

```
<delete><query>id:'/images/billed/2010/okt/billeder/object356751'</query></delete>
```

and

```
<delete><query>id:'/images/billed/2010/okt/billeder/object356751-disposable*'</query></delete>
```

The latter should purge all disposable stuff related to the record.

