# template1.6

## internal fields 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|\_version\_|long|||  ||
|\_root\_|string|true|true|  |contains the id of the root document of a collection of nested solr documents|
|\_nest\_path\_|\_nest\_path\_|true|true|  ||
|\_nest\_parent\_|string|true|true|  ||
    

### References
  

* [Schema configuration for nested documents](https://solr.apache.org/guide/8_10/indexing-nested-documents.html#schema-configuration) 


## SOLR id, other identifiers and related fields 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|id|string|true|true|  ||
|describing|string|true|true|  |contains the id of the root document being described in a child document. See [root and \_nest\_parent\_ above](#internal-fields)|
|described|boolean|true|true|  |is a boolean which is true if the document is a root doc, false otherwise|
|entity\_id|string|true|true|  |is a string used as a kind of classification code|
|entity\_type|string|true|true|  |is the name of (or related to) the pseudo field containing the child document|
|collection|string|true|true|  |the name of the collection from which the material originated, such as _Dansk Vestindien_|
|local\_identifier|string|true||  |contains a human usable id that can help a curator to identify which digital object is at hand and make it retrievable from a curatorial object store, like Cumulus|
|record\_name|string|||  |supposedly a synonym for local_identifier|
|shelf\_mark|text\_da|true|true|  |the location of an original physical object in the Library's stocks|
|shelf\_mark\_verbatim|string|true|true|  ||
|original\_object\_identifier|text\_da|true|true|  ||
|doms\_guid|string|true||  |the uuid of the item in the Copenhagen DOMS|
|location|text\_da|||  ||
|read\_direction|string|true||  ||
|physical\_source\_1|string|||  ||
|physical\_source\_2|string|||  ||
|archive\_location|string|||  ||
|accession\_number|string|||  ||
|source\_material\_reference|string|||  ||
|related\_url|string|||  ||
|related\_url\_text|text\_da|||  ||
    

### References
  

* [MODS location](https://www.loc.gov/standards/mods/userguide/location.html#shelflocator) 

* [MODS identifier](https://www.loc.gov/standards/mods/userguide/identifier.html) 


## types and genres 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|media\_type|string|true|true|  ||


## title, authors etc 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|title|text\_da|||  |The name given to the resource by its creator, or occasionally by its cataloger_sort ideally the title in a form suitable for sorting, like lower case and with leading determinate and indeterminate particles removed (a, an, the, den, det, en, et, ett ...)|
|title\_sort|sort\_da|||  |ideally the title in a form suitable for sorting, like lower case and with leading determinate and indeterminate particles removed (a, an, the, den, det, en, et, ett ...)|
|description|text\_da|||  ||
|situation|text\_da|||  ||
|content|text\_da|||  ||
|reference|text\_da|||  ||
|subject\_name\_en|text\_da|||  ||
|subject\_name\_da|text\_da|||  ||
|note|text\_da|||  true||
|author|text\_da|||  true||
|author\_verbatim|string|||  true||
|authority|string|true|true|  ||
|agent\_name|text\_da|||  true|Name of an agent that has created or contributed to the material|
|agent\_name\_verbatim|string|||  true||
|author\_sort|sort\_da|||  true||
|agent\_name\_sort|sort\_da|||  true||
|organization|text\_da|||  true||
|organization\_verbatim|string|||  true||
    

### References
  

* [MODS title](https://www.loc.gov/standards/mods/userguide/titleinfo.html) 

* [MODS name](https://www.loc.gov/standards/mods/userguide/name.html) 


## subject and geographical coverage 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|subject\_person|text\_da|||  true||
|subject\_person\_verbatim|string|||  true||
|subject\_person\_sort|sort\_da|||  true||
|location\_coordinates|geo|||  ||
|area|text\_da|||  ||
|cadastre|text\_da|||  ||
|parish|text\_da|||  ||
|building|text\_da|||  ||
|zipcode|text\_da|||  ||
|housenumber|text\_da|||  ||
|street|text\_da|||  ||
|city|text\_da|||  ||
|subject|text\_da|||  true||
|keyword|text\_da|||  true||
|keyword\_verbatim|string|||  true||
|topic|text\_da|||  true||
|topic\_verbatim|string|||  true||
|logical\_path|descendent\_path|||  true||


## temporal coverage 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|datetime|date\_range|||  ||
|datetime\_verbatim|string|||  ||
|created\_date|date|||  ||
|not\_after\_date|date\_range|||  ||
|not\_before\_date|date\_range|||  ||
|visible\_date|text\_da|||  true||
|created\_date\_verbatim|string|||  ||
|modified\_date|date|||  ||
|modified\_date\_verbatim|string|||  ||


## technical and administrative metadata 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|record\_created|date\_range|||  ||
|record\_revised|date\_range|||  ||
|last\_modified\_by|string|||  ||
|width\_pixels|long|||  |Image or moving image width in pixels.|
|height\_pixels|long|||  |Image or moving image height in pixels.|
|depth\_pixels|long|||  |The depth dimension is for 3D bitmaps, such as [MRI scans](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging).|
|pixels|long|||  |Total number of pixels in a still image or a single frame for moving image.|
|dhash|string|||  true||


## physical description 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|text|text\_da|||  true||
|freetext|text\_da|||  true||
|page|int|||  ||
|width\_cm|double|||  ||
|height\_cm|double|||  ||
|depth\_cm|double|||  ||
|technique|text\_da|true|true|  ||
|medium|text\_da|true|true|  ||
|medium\_verbatim|string|true|true|  ||
|additional\_physical\_form|text\_da|||  |seems to be a bug in COP export: Should really be any of script, medium or size.|
|extent|string|true|true|  ||
|size|string|true|true|  ||
|pages|string|||  true||
|image\_preview|string|||  true||
|image\_full|string|||  ||
|iiif|string|||  ||


## licensing and terms and conditions 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|license|string|||  ||
|license\_notice|text\_da|||  true||


## language 
      


| Field  | Type | Stored | Indexed | multiValued | Description |
|:-------|:--------|:------------|:-------|:--------|:------------|
|language|string|||  true|'da' for Danish, 'en' for English, 'de' for German, jrb-Hebr i.e., Judeo-Arabic in Hebrew script (jrb is the *Arabic* spoken and written by the Jewish population in Arabic countries during the medieval times). We have a vast number of combinations of scripts and languages.|
|cataloging\_language|string|||  false|Either Danish 'da' or English 'en' depending on record source and expected target audience|
    

### References
  

* [Language tags for the material according to RFC5646](https://datatracker.ietf.org/doc/html/rfc5646) 

* [MODS Subelement: &lt;languageOfCataloging>](https://www.loc.gov/standards/mods/userguide/recordinfo.html#languageofcataloging) 
