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
| describing| name=describing type=string stored=true indexed=true ) | contains the id of the root document being described in a child document|
| described| name=described type=boolean stored=true indexed=true ) | is a boolean which is true if the document is a root doc, false otherwise|
| entity\_id| name=entity\_id type=string stored=true indexed=true ) | is a string used as a kind of classification code|
| entity\_type| name=entity\_type type=string stored=true indexed=true ) | is the name of (or related to) the pseudo field containing the child document|
| collection| name=collection type=string stored=true indexed=true ) | the name of the collection from which the material originated, such as _Dansk Vestindien_|
| local\_identifier| name=local\_identifier type=string stored=true required=false ) | contains a human usable id that can help a curator to identify which digital object is at hand and make it retrievable from a curatorial object store, like Cumulus|
| shelf\_mark| name=shelf\_mark type=text\_da stored=true indexed=true ) | the location of an original physical object in the Library's stocks|
| shelf\_mark\_verbatim| name=shelf\_mark\_verbatim type=string stored=true indexed=true ) |
| original\_object\_identifier| name=original\_object\_identifier type=text\_da stored=true indexed=true ) |
| doms\_guid| name=doms\_guid type=string stored=true required=false ) | the uuid of the item in the Copenhagen DOMS|

  
### References
  


## types and genres 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| media\_type| name=media\_type type=string stored=true indexed=true ) |

  
### References
  


## title, authors etc 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| title| name=title type=text\_da termVectors=true ) |
| title\_sort| name=title\_sort type=sort\_da ) |
| record\_name| name=record\_name type=string ) |
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
| agent\_name| name=agent\_name type=text\_da multiValued=true ) |
| agent\_name\_verbatim| name=agent\_name\_verbatim type=string multiValued=true ) |
| author\_sort| name=author\_sort type=sort\_da multiValued=true ) |
| agent\_name\_sort| name=agent\_name\_sort type=sort\_da multiValued=true ) |
| organization| name=organization type=text\_da multiValued=true ) |
| organization\_verbatim| name=organization\_verbatim type=string multiValued=true ) |

  
### References
  


## subject and coverage 
      


| Field  | Options | Description |
|:-------|:--------|:------------|

  
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
  


## administrative metadata 
      


| Field  | Options | Description |
|:-------|:--------|:------------|
| record\_created| name=record\_created type=date\_range ) |
| record\_revised| name=record\_revised type=date\_range ) |
| last\_modified\_by| name=last\_modified\_by type=string ) |

  
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
| additional\_physical\_form| name=additional\_physical\_form type=text\_da ) |
| extent| name=extent type=string stored=true indexed=true ) |
| size| name=size type=string stored=true indexed=true ) |
| width\_pixels| name=width\_pixels type=long ) |
| height\_pixels| name=height\_pixels type=long ) |
| depth\_pixels| name=depth\_pixels type=long ) |
| pixels| name=pixels type=long ) |
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

  
### References
  
