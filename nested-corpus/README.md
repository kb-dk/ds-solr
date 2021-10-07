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
|[henrik-hertz.xml](henrik-hertz.xml) | [letter-corpus](https://github.com/kb-dk/letter-corpus/tree/master/letter_books/001990301/001990301_000.xml) | TEI | Search for Berlin, Hertz, Brandes |
|[oersted.xml](oersted.xml) |  [letter-corpus](https://github.com/kb-dk/letter-corpus/tree/master/letter_books/002053861/002053861_X00.xml) | TEI | Search for Ørsted, Berlin, Sorø |
|[simonsen-brandes.xml](simonsen-brandes.xml) |Simonsen's Arkiv via [cop syndication](http://www5.kb.dk/cop/syndication/letters/judsam/2011/mar/dsa/subject1952/en/) | mods & RSS2 | Search for Simonsen, Brandes, København/Copenhagen |
| [albert-einstein.xml](albert-einstein.xml) | Simonsen's Arkiv via [cop syndication](http://www5.kb.dk/cop/syndication/letters/judsam/2011/mar/dsa/object7871) | mods & RSS2 | Search for Simonsen, Einstein, Berlin, Copenhagen |
|[tystrup-soroe.xml](tystrup-soroe.xml)| Danmark set fra luften via [cop syndication](http://www5.kb.dk/cop/syndication/images/luftfo/2011/maj/luftfoto/object322504/da/) | mods & RSS2 | Search for Sorø |
|[ hvidovre-teater.xml]( hvidovre-teater.xml)| Museet for Dansk Bladtegning via [cop syndication](http://www5.kb.dk/cop/syndication/images/billed/2010/okt/billeder/object356751) | mods & RSS2 | Search for Hvidovre, Claus Seidel, Waage Sandø, Lane Lind, Kjeld Abell |
|[homiliae-super-psalmos.xml](homiliae-super-psalmos.xml)| Homiliae super Psalmos etc -- Manuscript collection via [cop syndication](http://www5.kb.dk/cop/syndication/manus/vmanus/2011/dec/ha/object71279)| mods | Just a multipage document |
| [responsa.xml](responsa.xml) |[קובץ שאלות ותשובות](http://www5.kb.dk/cop/syndication/manus/judsam/2009/sep/dsh/object41158) | mods | multilingual fields (Hebrew and English). RFC5646 language tags (Like Judeo-arabic in Hebrew script |
| [work_on_logic.xml](work_on_logic.xml) | | | [Maimonides](https://en.wikipedia.org/wiki/Maimonides) is still widely read by students of the history of philosophy. His bibliographic authority is on http://viaf.org/viaf/100185495 |

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
* build.sh, which just runs the transforms. It uses <kbd>jq</kbd> -
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

