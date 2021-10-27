# template1.6

## Internal Fields 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| \_version\_| type=long |
| \_root\_| type=string indexed=true stored=true docValues=true | contains the id of the root document of a collection of nested solr documents|
| \_nest\_path\_| stored=true indexed=true |
| \_nest\_parent\_| type=string indexed=true stored=true |
    

### References
  

* [Schema configuration for nested documents](https://solr.apache.org/guide/8_10/indexing-nested-documents.html#schema-configuration) 


## SOLR id, other identifiers and related fields 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| id| type=string stored=true indexed=true required=true |
| describing| type=string stored=true indexed=true | contains the id of the root document being described in a child document. See [root and \_nest\_parent\_ above](#internal-fields)|
| described| type=boolean stored=true indexed=true | is a boolean which is true if the document is a root doc, false otherwise|
| entity\_id| type=string stored=true indexed=true | is a string used as a kind of classification code|
| entity\_type| type=string stored=true indexed=true | is the name of (or related to) the pseudo field containing the child document|
| collection| type=string stored=true indexed=true | the name of the collection from which the material originated, such as _Dansk Vestindien_|
| local\_identifier| type=string stored=true required=false | contains a human usable id that can help a curator to identify which digital object is at hand and make it retrievable from a curatorial object store, like Cumulus|
| record\_name| type=string | supposedly a synonym for local_identifier|
| shelf\_mark| type=text\_da stored=true indexed=true | the location of an original physical object in the Library's stocks|
| shelf\_mark\_verbatim| type=string stored=true indexed=true |
| original\_object\_identifier| type=text\_da stored=true indexed=true |
| doms\_guid| type=string stored=true required=false | the uuid of the item in the Copenhagen DOMS|
| location| type=text\_da |
| read\_direction| type=string stored=true required=false |
| physical\_source\_1| type=string |
| physical\_source\_2| type=string |
| archive\_location| type=string |
| accession\_number| type=string |
| source\_material\_reference| type=string |
| related\_url| type=string |
| related\_url\_text| type=text\_da |
    

### References
  

* [MODS location](https://www.loc.gov/standards/mods/userguide/location.html#shelflocator) 

* [MODS identifier](https://www.loc.gov/standards/mods/userguide/identifier.html) 


## types and genres 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| media\_type| type=string stored=true indexed=true |


## title, authors etc 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| title| type=text\_da termVectors=true | The name given to the resource by its creator, or occasionally by its cataloger| _sort ideally the title in a form suitable for sorting, like lower case and with leading determinate and indeterminate particles removed (a, an, the, den, det, en, et, ett ...)|
| title\_sort| type=sort\_da | ideally the title in a form suitable for sorting, like lower case and with leading determinate and indeterminate particles removed (a, an, the, den, det, en, et, ett ...)|
| description| type=text\_da |
| situation| type=text\_da |
| content| type=text\_da |
| reference| type=text\_da |
| subject\_name\_en| type=text\_da |
| subject\_name\_da| type=text\_da |
| note| type=text\_da multiValued=true |
| author| type=text\_da multiValued=true |
| author\_verbatim| type=string multiValued=true |
| authority| type=string stored=true indexed=true |
| agent\_name| type=text\_da multiValued=true | Name of an agent that has created or contributed to the material|
| agent\_name\_verbatim| type=string multiValued=true |
| author\_sort| type=sort\_da multiValued=true |
| agent\_name\_sort| type=sort\_da multiValued=true |
| organization| type=text\_da multiValued=true |
| organization\_verbatim| type=string multiValued=true |
    

### References
  

* [MODS title](https://www.loc.gov/standards/mods/userguide/titleinfo.html) 

* [MODS name](https://www.loc.gov/standards/mods/userguide/name.html) 


## subject and geographical coverage 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| subject\_person| type=text\_da multiValued=true |
| subject\_person\_verbatim| type=string multiValued=true |
| subject\_person\_sort| type=sort\_da multiValued=true |
| location\_coordinates| type=geo |
| area| type=text\_da |
| cadastre| type=text\_da |
| parish| type=text\_da |
| building| type=text\_da |
| zipcode| type=text\_da |
| housenumber| type=text\_da |
| street| type=text\_da |
| city| type=text\_da |
| subject| type=text\_da multiValued=true |
| keyword| type=text\_da multiValued=true termVectors=true |
| keyword\_verbatim| type=string multiValued=true |
| topic| type=text\_da multiValued=true termVectors=true |
| topic\_verbatim| type=string multiValued=true |
| logical\_path| type=descendent\_path multiValued=true |


## temporal coverage 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| datetime| type=date\_range |
| datetime\_verbatim| type=string |
| created\_date| type=date |
| not\_after\_date| type=date\_range |
| not\_before\_date| type=date\_range |
| visible\_date| type=text\_da multiValued=true |
| created\_date\_verbatim| type=string |
| modified\_date| type=date |
| modified\_date\_verbatim| type=string |


## technical and administrative metadata 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| record\_created| type=date\_range |
| record\_revised| type=date\_range |
| last\_modified\_by| type=string |
| width\_pixels| type=long | Image or moving image width in pixels.|
| height\_pixels| type=long | Image or moving image width in pixels.|
| depth\_pixels| type=long | The depth dimension is for 3D bitmaps, such as [MRI scans](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging).|
| pixels| type=long | Total number of pixels in a still image or a single frame for moving image.|
| dhash| type=string multiValued=true |


## physical description 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| text| multiValued=true |
| freetext| type=text\_da multiValued=true |
| page| type=int |
| width\_cm| type=double |
| height\_cm| type=double |
| depth\_cm| type=double |
| technique| type=text\_da stored=true indexed=true |
| medium| type=text\_da stored=true indexed=true |
| medium\_verbatim| type=string stored=true indexed=true |
| additional\_physical\_form| type=text\_da | seems to be a bug in COP export: Should really be any of script, medium or size.|
| extent| type=string stored=true indexed=true |
| size| type=string stored=true indexed=true |
| pages| type=string multiValued=true |
| image\_preview| type=string multiValued=true |
| image\_full| type=string |
| iiif| type=string |


## Licensing and terms and conditions 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| license| type=string |
| license\_notice| type=text\_da multiValued=true |


## Language 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| language| type=string multiValued=true | 'da' for Danish, 'en' for English, 'de' for German, jrb-Hebr i.e., Judeo-Arabic in Hebrew script (jrb is the *Arabic* spoken and written by the Jewish population in Arabic countries during the medieval times). We have a vast number of combinations of scripts and languages.|
| cataloging\_language| type=string multiValued=false | Either Danish 'da' or English 'en' depending on record source and expected target audience|
    

### References
  

* [Language tags for the material according to RFC5646](https://datatracker.ietf.org/doc/html/rfc5646) 

* [MODS Subelement: &lt;languageOfCataloging>](https://www.loc.gov/standards/mods/userguide/recordinfo.html#languageofcataloging) 
