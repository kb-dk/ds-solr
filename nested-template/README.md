# template1.6

## Internal Fields 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| \_version\_| name=\_version\_ type=long ) |
| \_root\_| name=\_root\_ type=string indexed=true stored=true docValues=true ) | contains the id of the root document of a collection of nested solr documents|
| \_nest\_path\_| name=\_nest\_path\_ type=\_nest\_path\_ stored=true indexed=true ) |
| \_nest\_parent\_| name=\_nest\_parent\_ type=string indexed=true stored=true ) |

  
### References
  

* [Schema configuration for nested documents](https://solr.apache.org/guide/8_10/indexing-nested-documents.html#schema-configuration) 


## SOLR id, other identifiers and related fields 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| id| name=id type=string stored=true indexed=true required=true ) |
| describing| name=describing type=string stored=true indexed=true ) | contains the id of the root document being described in a child document. See [root and \_nest\_parent\_ above](#internal-fields)|
| described| name=described type=boolean stored=true indexed=true ) | is a boolean which is true if the document is a root doc, false otherwise|
| entity\_id| name=entity\_id type=string stored=true indexed=true ) | is a string used as a kind of classification code|
| entity\_type| name=entity\_type type=string stored=true indexed=true ) | is the name of (or related to) the pseudo field containing the child document|
| collection| name=collection type=string stored=true indexed=true ) | the name of the collection from which the material originated, such as _Dansk Vestindien_|
| local\_identifier| name=local\_identifier type=string stored=true required=false ) | contains a human usable id that can help a curator to identify which digital object is at hand and make it retrievable from a curatorial object store, like Cumulus|
| record\_name| name=record\_name type=string ) | supposedly a synonym for local_identifier|
| shelf\_mark| name=shelf\_mark type=text\_da stored=true indexed=true ) | the location of an original physical object in the Library's stocks|
| shelf\_mark\_verbatim| name=shelf\_mark\_verbatim type=string stored=true indexed=true ) |
| original\_object\_identifier| name=original\_object\_identifier type=text\_da stored=true indexed=true ) |
| doms\_guid| name=doms\_guid type=string stored=true required=false ) | the uuid of the item in the Copenhagen DOMS|

  
### References
  

* [MODS location](https://www.loc.gov/standards/mods/userguide/location.html#shelflocator) 

* [MODS identifier](https://www.loc.gov/standards/mods/userguide/identifier.html) 


## types and genres 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| media\_type| name=media\_type type=string stored=true indexed=true ) |

  
### References
  


## title, authors etc 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| title| name=title type=text\_da termVectors=true ) | The name given to the resource by its creator, or occasionally by its cataloger| _sort ideally the title in a form suitable for sorting, like lower case and with leading determinate and indeterminate particles removed (a, an, the, den, det, en, et, ett ...)|
| title\_sort| name=title\_sort type=sort\_da ) | ideally the title in a form suitable for sorting, like lower case and with leading determinate and indeterminate particles removed (a, an, the, den, det, en, et, ett ...)|
| description| name=description type=text\_da ) |
| situation| name=situation type=text\_da ) |
| content| name=content type=text\_da ) |
| reference| name=reference type=text\_da ) |
| subject\_name\_en| name=subject\_name\_en type=text\_da ) |
| subject\_name\_da| name=subject\_name\_da type=text\_da ) |
| note| name=note type=text\_da multiValued=true ) |
| author| name=author type=text\_da multiValued=true ) |
| author\_verbatim| name=author\_verbatim type=string multiValued=true ) |
| authority| name=authority type=string stored=true indexed=true ) |
| agent\_name| name=agent\_name type=text\_da multiValued=true ) | Name of an agent that has created or contributed to the material|
| agent\_name\_verbatim| name=agent\_name\_verbatim type=string multiValued=true ) |
| author\_sort| name=author\_sort type=sort\_da multiValued=true ) |
| agent\_name\_sort| name=agent\_name\_sort type=sort\_da multiValued=true ) |
| organization| name=organization type=text\_da multiValued=true ) |
| organization\_verbatim| name=organization\_verbatim type=string multiValued=true ) |

  
### References
  

* [MODS title](https://www.loc.gov/standards/mods/userguide/titleinfo.html) 

* [MODS name](https://www.loc.gov/standards/mods/userguide/name.html) 


## subject and geographical coverage 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| subject\_person| name=subject\_person type=text\_da multiValued=true ) |
| subject\_person\_verbatim| name=subject\_person\_verbatim type=string multiValued=true ) |
| subject\_person\_sort| name=subject\_person\_sort type=sort\_da multiValued=true ) |
| location\_coordinates| name=location\_coordinates type=geo ) |
| area| name=area type=text\_da ) |
| cadastre| name=cadastre type=text\_da ) |
| parish| name=parish type=text\_da ) |
| building| name=building type=text\_da ) |
| zipcode| name=zipcode type=text\_da ) |
| housenumber| name=housenumber type=text\_da ) |
| street| name=street type=text\_da ) |
| city| name=city type=text\_da ) |
| subject| name=subject type=text\_da multiValued=true ) |
| keyword| name=keyword type=text\_da multiValued=true termVectors=true ) |
| keyword\_verbatim| name=keyword\_verbatim type=string multiValued=true ) |
| topic| name=topic type=text\_da multiValued=true termVectors=true ) |
| topic\_verbatim| name=topic\_verbatim type=string multiValued=true ) |
| logical\_path| name=logical\_path type=descendent\_path multiValued=true ) |

  
### References
  


## temporal coverage 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| datetime| name=datetime type=date\_range ) |
| datetime\_verbatim| name=datetime\_verbatim type=string ) |
| created\_date| name=created\_date type=date ) |
| not\_after\_date| name=not\_after\_date type=date\_range ) |
| not\_before\_date| name=not\_before\_date type=date\_range ) |
| visible\_date| name=visible\_date type=text\_da multiValued=true ) |
| created\_date\_verbatim| name=created\_date\_verbatim type=string ) |
| modified\_date| name=modified\_date type=date ) |
| modified\_date\_verbatim| name=modified\_date\_verbatim type=string ) |

  
### References
  


## technical and administrative metadata 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| record\_created| name=record\_created type=date\_range ) |
| record\_revised| name=record\_revised type=date\_range ) |
| last\_modified\_by| name=last\_modified\_by type=string ) |
| width\_pixels| name=width\_pixels type=long ) | Image or moving image width in pixels.|
| height\_pixels| name=height\_pixels type=long ) | Image or moving image width in pixels.|
| depth\_pixels| name=depth\_pixels type=long ) | The depth dimension is for 3D bitmaps, such as [MRI scans](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging).|
| pixels| name=pixels type=long ) | Total number of pixels in a still image or a single frame for moving image.|
| dhash| name=dhash type=string multiValued=true ) |

  
### References
  


## physical description 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| text| name=text type=text\_da multiValued=true ) |
| freetext| name=freetext type=text\_da multiValued=true ) |
| page| name=page type=int ) |
| width\_cm| name=width\_cm type=double ) |
| height\_cm| name=height\_cm type=double ) |
| depth\_cm| name=depth\_cm type=double ) |
| technique| name=technique type=text\_da stored=true indexed=true ) |
| medium| name=medium type=text\_da stored=true indexed=true ) |
| medium\_verbatim| name=medium\_verbatim type=string stored=true indexed=true ) |
| additional\_physical\_form| name=additional\_physical\_form type=text\_da ) | seems to be a bug in COP export: Should really be any of script, medium or size.|
| extent| name=extent type=string stored=true indexed=true ) |
| size| name=size type=string stored=true indexed=true ) |
| pages| name=pages type=string multiValued=true ) |
| image\_preview| name=image\_preview type=string multiValued=true ) |
| image\_full| name=image\_full type=string ) |
| iiif| name=iiif type=string ) |

  
### References
  


## Licensing and terms and conditions 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| license| name=license type=string ) |
| license\_notice| name=license\_notice type=text\_da multiValued=true ) |

  
### References
  


## Language 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| cataloging\_language| name=cataloging\_language type=string multiValued=false ) |
| language| name=language type=string multiValued=true ) |

  
### References
  


## Left-overs? 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| location| name=location type=text\_da ) |
| read\_direction| name=read\_direction type=string stored=true required=false ) |
| physical\_source\_1| name=physical\_source\_1 type=string ) |
| physical\_source\_2| name=physical\_source\_2 type=string ) |
| archive\_location| name=archive\_location type=string ) |
| accession\_number| name=accession\_number type=string ) |
| source\_material\_reference| name=source\_material\_reference type=string ) |
| related\_url| name=related\_url type=string ) |
| related\_url\_text| name=related\_url\_text type=text\_da ) |

  
### References
  
