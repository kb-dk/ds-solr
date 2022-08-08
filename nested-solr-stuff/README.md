# Data from various source within legacy datasets in  KB @ Cph

## Introduction

In recent releases, as of Solr 8, [facilities for the searching and
indexing nested documents has
improved](https://solr.apache.org/guide/8_0/major-changes-in-solr-8.html).

Solr nested documents are different from most other similar constructs. One
difference is that these Solr documents all have the same content
model. Anyone used to encoding (meta)data in SQL, XML, json or
whatever will think of elements or tables with different kinds column schemas or
element content models.

All documents in a Solr nesting-structure have the same content
model. When you get used to it, you will regard that as feature, not a
bug, and that it has a beauty.

Then, if you create (as I did) a series of fields like "tit"
containing titles the json I created looked like this:

```
 "tit": [
      {
        "describing": "manus-judsam-2009-sep-dsh-object41158",
        "described": false,
        "language": "he",
        "entity_type": "main",
        "title": [
          "קובץ שאלות ותשובות"
        ],
        "id": "manus-judsam-2009-sep-dsh-object41158-disposable-subrecord-d1e57"
      },
      {
        "describing": "manus-judsam-2009-sep-dsh-object41158",
        "described": false,
        "language": "en",
        "entity_type": "transcribed",
        "title": [
          "Qovets she'elot u-tshuvot"
        ],
        "id": "manus-judsam-2009-sep-dsh-object41158-disposable-subrecord-d1e63"
      }
    ],
```

What happens in the indexing and searching is actually a drastic change in the structure:

```
{
        "describing":"manus-judsam-2009-sep-dsh-object41158",
        "described":false,
        "entity_type":"main",
        "title":"קובץ שאלות ותשובות",
        "id":"manus-judsam-2009-sep-dsh-object41158-disposable-subrecord-d1e57",
        "_nest_path_":"/tit#0",
        "_nest_parent_":"manus-judsam-2009-sep-dsh-object41158",
        "_root_":"manus-judsam-2009-sep-dsh-object41158",
        "_version_":1714032457556164608,
        "title_sort":"e*\u0010\b(\u0003\u0004e.\u0006\u001c\u00100\u0003\u0004e\u00100.\u0010\b\u00100\u0001\u0016\u0000",
        "language":["he"],
        "score":2.336233}]
},
```

In particular, the field 'tit' is now a value in the automatically
generated ```_nest_path_``` field. You will not get the structure back
until you add ```*,[child]``` to your field list.

## The Corpus

See [../nested-corpus](../nested-corpus)

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
  
* mods2saxon.xsl can read parameters for setting a the record id, which is useful if it isn't passed along inside the the MODS.
  Note that it assumes that the passed parameter is a scalar, whereas the XML may contain many records in a
``` 
  <modsCollection> ... </modsCollection>.
``` 
When using the `record_identifier` parameter, the xsl throws an exception if there are multiple records in the same file. I.e., there is a 

```
    <xsl:if test="count(//m:mods) &gt; 1 and $record_identifier">
      <xsl:message terminate="yes">Fatal: We were passed one single record_identifier but have multiple records.</xsl:message>
    </xsl:if>
```

I.e., saxon will terminate.

No attempts has been made to transform the TEI letter stuff. I can do that at a later stage.

### Cumulus categories

The category system is such that it includes basically a set
breadcrumb paths under which the resource can be found. I am convinced
that the category based search and navigation is obsoleted by facetted
search. Still, I have included the categories in these records. They
are given like the following:

```

"categories": [

...

{
  "id": "manus-judsam-2009-sep-dsh-object27137-disposable-subrecord-d3e206",
  "describing": "manus-judsam-2009-sep-dsh-object27137",
  "described": false,
  "entity_id": "manus-judsam-2009-sep-dsh/subject315",
  "da": "David Simonsens Håndskrifter",
  "en": "The David Simonsen Manuscripts"
},
{
  "id": "manus-judsam-2009-sep-dsh-object27137-disposable-subrecord-d3e217",
  "describing": "manus-judsam-2009-sep-dsh-object27137",
  "described": false,
  "entity_id": "manus-judsam-2009-sep-dsh/subject319",
  "da": "Sprog",
  "en": "Language"
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
 "tit": [
      {
        "describing": "images-billed-2010-okt-billeder-object356751",
        "described": false,
        "language": "da",
        "entity_type": "main",
        "title": [
          "Hvidovre Teater"
        ],
        "id": "images-billed-2010-okt-billeder-object356751-disposable-subrecord-d1e51"
      }
    ],
```

The ID should be unique in the index given the way it is created. Note
that we added -disposable-subrecord- followed by a record ID inside
the mods.

Assuming that we want to delete record with ID

```images-billed-2010-okt-billeder-object35675```

we should be able to do using a http POST of  

```<delete><query>id:'images-billed-2010-okt-billeder-object356751'</query></delete>```

and

```<delete><query>id:'images-billed-2010-okt-billeder-object356751-disposable*'</query></delete>```

The latter should purge all disposable stuff related to the record.


## TODO

The type or genre is not included at this time.


