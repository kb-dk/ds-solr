# template1.6

## internal fields 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|\_version\_|long||||||
|\_root\_|string|true|true|||contains the id of the root document of a collection of nested solr documents|
|\_nest\_path\_|\_nest\_path\_|true|true||||
|\_nest\_parent\_|string|true|true||||
    

### References
  

* [Schema configuration for nested documents](https://solr.apache.org/guide/8_10/indexing-nested-documents.html#schema-configuration) 


## SOLR id, other identifiers and related fields 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|id|string|true|true||true||
|describing|string|true|true|||contains the id of the root document being described in a child document. See [root and \_nest\_parent\_ above](#internal-fields)|
|described|boolean|true|true|||is a boolean which is true if the document is a root doc, false otherwise|
|entity\_id|string|true|true|||is a string used as a kind of classification code|
|entity\_type|string|true|true|||is the name of (or related to) the pseudo field containing the child document|
|collection|string|true|true|||the name of the collection from which the material originated, such as _Dansk Vestindien_|
|local\_identifier|string|true|||false|contains a human usable id that can help a curator to identify which digital object is at hand and make it retrievable from a curatorial object store, like Cumulus|
|record\_name|string|||||supposedly a synonym for local_identifier|
|shelf\_mark|text\_da|true|true|||the location of an original physical object in the Library's stocks|
|shelf\_mark\_verbatim|string|true|true||||
|original\_object\_identifier|text\_da|true|true||||
|doms\_guid|string|true|||false|the uuid of the item in the Copenhagen DOMS|
|location|text\_da||||||
|read\_direction|string|true|||false|This is perhaps not obvious: Normally text is stored in the order it is to be read. However, from the point of view of people used to read western languages (LTR scripts) it might seem odd click on a left-arrow to get next page, but that is the way people reading Chinese, Arabic and Hebrew thinks (RTL scripts). And that is true for languages using those scripts, like Persian (using Arabic script) and Yiddish and Ladino using Hebrew script. Judeo-Arabic is a dialect of Arabic written using Hebrew script. We have all these in our collections. We have all these in our digital collections. However, around 2005-2010 someone decided that the staff doing the digitization cannot learn to recognize RTL or LTR objects, so a lot of texts has been digitized in what was claimed to be the "logical" direction, namely LTR. Instead of correcting the data we have done this in software.|
|physical\_source\_1|string||||||
|physical\_source\_2|string||||||
|archive\_location|string||||||
|accession\_number|string||||||
|source\_material\_reference|string||||||
|related\_url|string||||||
|related\_url\_text|text\_da||||||
|reference|text\_da||||||
    

### References
  

* [MODS location/shelflocator ](https://www.loc.gov/standards/mods/userguide/location.html#shelflocator) 

* [MODS identifier](https://www.loc.gov/standards/mods/userguide/identifier.html) 


## types and genres 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|media\_type|string|true|true|||`images`, `maps`, `letters`, `manus`, `pamphlets`, `books`, `editions`, `categories`|


## title, authors etc 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|title|text\_da|||||The name given to the resource by its creator, or occasionally by its cataloger|
|title\_sort|sort\_da|||||ideally the title in a form suitable for sorting, like lower case and with leading determinate and indeterminate particles removed (a, an, the, den, det, en, et, ett ...)|
|description|text\_da||||||
|situation|text\_da||||||
|content|text\_da||||||
|subject\_name\_en|text\_da||||||
|subject\_name\_da|text\_da||||||
|note|text\_da|||true|||
|author|text\_da|||true|||
|author\_verbatim|string|||true|||
|authority|string|true|true||||
|agent\_name|text\_da|||true||Name of an agent that has created or contributed to the material. An agent is a person or corporate body (or possibly automata) which stands in a relation to the object. Typical relators are aut, ctb, rcp, scr, trl, act and art (author, contributor, recipient, scribe, translator, actor and artist).|
|agent\_name\_verbatim|string|||true|||
|author\_sort|sort\_da|||true|||
|agent\_name\_sort|sort\_da|||true|||
|organization|text\_da|||true|||
|organization\_verbatim|string|||true|||
    

### References
  

* [MODS title](https://www.loc.gov/standards/mods/userguide/titleinfo.html) 

* [MODS name](https://www.loc.gov/standards/mods/userguide/name.html) 

* [Code List for Relators](https://www.loc.gov/marc/relators/relaterm.html) 


## subject and geographical coverage 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|subject\_person|text\_da|||true|||
|subject\_person\_verbatim|string|||true|||
|subject\_person\_sort|sort\_da|||true|||
|location\_coordinates|geo||||||
|area|text\_da|||||lokalitet|
|cadastre|text\_da|||||matrikelnummer|
|parish|text\_da|||||sogn|
|building|text\_da|||||bygningsnavn|
|zipcode|text\_da|||||postnummer|
|housenumber|text\_da|||||husnummer|
|street|text\_da|||||vejnavn|
|city|text\_da|||||by|
|subject|text\_da|||true|||
|keyword|text\_da|||true|||
|keyword\_verbatim|string|||true|||
|topic|text\_da|||true|||
|topic\_verbatim|string|||true|||
|logical\_path|descendent\_path|||true|||


## temporal coverage 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|datetime|date\_range|||||The date that the material is about. For a newspaper this would be the publication date. For a photography it would be the time the photo was taken. For a painting it would be the time it was painted. Note: This is a [DateRangeField](https://lucene.apache.org/solr/guide/8_1/working-with-dates.html#date-range-formatting) that supports non-precise dates such as `2000-11` as well as ranges such as `[2000-11-01 TO 2014-12-01]`.|
|datetime\_verbatim|string|||||Fallback representation for datetime, when the source datetime cannot be parsed. Copied verbatim from the source.|
|not\_after\_date|date\_range||||||
|not\_before\_date|date\_range||||||
|visible\_date|text\_da|||true|||
|modified\_date|date||||||
|modified\_date\_verbatim|string||||||
    

### References
  

* [SOLR DateRangeField](https://lucene.apache.org/solr/guide/8_1/working-with-dates.html#date-range-formatting) 

* [date element in TEI guidelines](https://tei-c.org/release/doc/tei-p5-doc/en/html/ref-date.html) 

* [Dates and Times](https://tei-c.org/release/doc/tei-p5-doc/en/html/CO.html#CONADA) 


## technical and administrative metadata 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|record\_created|date\_range||||||
|record\_revised|date\_range||||||
|last\_modified\_by|string||||||
|created\_date|date|||||The creation date of the material or metadata about the material in the backing system.|
|created\_date\_verbatim|string|||||Fallback representation for created_date, when the source datetime cannot be parsed. Copied verbatim from the source.|
|width\_pixels|long|||||Image or moving image width in pixels.|
|height\_pixels|long|||||Image or moving image height in pixels.|
|depth\_pixels|long|||||The depth dimension is for 3D bitmaps, such as [MRI scans](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging).|
|pixels|long|||||Total number of pixels in a still image or a single frame for moving image.|
|image\_preview|string|||true||One or more preview images if available. Size and quality is not defined, but aim for something fairly lightweight, i.e. < 100 KB and between 500x500 and 1000x1000 pixels. For image material there will typically only be a single preview, while moving images might provide more preview images.|
|image\_full|string|||||If the material is an image, this field contains an URL to the full image at the highest possible quality. If the material is not an image, this field will not be defined. Hint: If available, it is recommended for the user to use the iiif-field for image requests, as it offers more options.|
|iiif|string|||||If the material is served by an IIIF-compliant server, this is the base URL to the material on the server, e.g. [https://kb-images.kb.dk/DAMJP2/online_master_arkiv/non-archival/KOB/bs_kistebilleder-2/bs000007/]( https://kb-images.kb.dk/DAMJP2/online_master_arkiv/non-archival/KOB/bs_kistebilleder-2/bs000007/) [Hint: Parameters for image requests to IIIF can be found at iiif.io](https://iiif.io/api/image/2.1/#image-request-parameters)|
|dhash|string|||true||Image similarity DHash in the form of &lt;Complexity>&lt;bitcount>_&lt;value> e.g. "Simple30_890940". Note that the field is multi-valued and will eventually contain mutiple DHashes of varying complexity and bitcount.|
    

### References
  

* [MODS &lt;recordInfo>](https://www.loc.gov/standards/mods/userguide/recordinfo.html) 

* [IIIF image protocol](https://iiif.io/api/image/2.1/ 


## full text 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|text|text\_da|||true||The major text content of the material, if available. For a word file, this would be the textual content. For an image, there would be no value.|
|freetext|text\_da|||true||Fallback field for search. Misc. content that is not indexed in any other fields are added to this.|
|page|int|||||The page that the material is about, e.g. a page number from a book or a newspaper.|


## physical description 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|width\_cm|double||||||
|height\_cm|double||||||
|depth\_cm|double||||||
|technique|text\_da|true|true||||
|medium|text\_da|true|true||||
|medium\_verbatim|string|true|true||||
|additional\_physical\_form|text\_da|||||seems to be a bug in COP export: Should really be any of script, medium or size.|
|extent|string|true|true|||the number of pages of the object. Images scanned from photographs usually have two pages; and both are scanned but extent are only used for stuff with more than two pages 😉.|
|size|string|true|true|||the size of the objects as in widht x height, octavo or quarto or whatever.|
|pages|string|||true||In Cph we encode a list of URIs to the IIIF server.|


## licensing and terms and conditions 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|license|string|||||Short and controlled form of the licence for the material. Valid entries are [Creative commons short form](https://creativecommons.org/choose/), e.g. `by-nc-sa` or `cc0`. Other possibilities are `Apache License 2.0` or `GPL 3.0`. Traditionally metadata belongs to KB and are usually CC0. The objects belong to the creators and we cannot claim intellectual property rights on them. This does really belong to the cataloging rules.|
|license\_notice|text\_da|||true||Uncontrolled copyright oriented text|
    

### References
  

* [Creative commons short form](https://creativecommons.org/choose/) 


## language 
      
| field  | type | stored | indexed | multiValued | required | description |
|:-------|:--------|:-------|:------|:------|:--------|:--------|
|language|string|||true||'da' for Danish, 'en' for English, 'de' for German, jrb-Hebr i.e., Judeo-Arabic in Hebrew script (jrb is the *Arabic* spoken and written by the Jewish population in Arabic countries during the medieval times). We have a vast number of combinations of scripts and languages.|
|cataloging\_language|string|||false||Either Danish 'da' or English 'en' depending on record source and expected target audience|
    

### References
  

* [Language tags for the material according to RFC5646](https://datatracker.ietf.org/doc/html/rfc5646) 

* [MODS Subelement: &lt;languageOfCataloging>](https://www.loc.gov/standards/mods/userguide/recordinfo.html#languageofcataloging) 
