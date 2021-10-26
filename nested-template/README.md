# template1.6

## Internal Fields 
      
  
* \_version\_ (name=\_version\_ type=long )   
* \_root\_ (name=\_root\_ type=string indexed=true stored=true docValues=true )  -- **contains the id of the root document of a collection of nested solr documents**  
* \_nest\_path\_ (name=\_nest\_path\_ type=\_nest\_path\_ stored=true indexed=true )   
* \_nest\_parent\_ (name=\_nest\_parent\_ type=string indexed=true stored=true ) 
  
### References
  
[Schema configuration for nested documents](https://solr.apache.org/guide/8_10/indexing-nested-documents.html#schema-configuration) 


## SOLR id, other identifiers and related fields 
      
  
* id (name=id type=string stored=true indexed=true required=true )  -- **of the root document being described in a child document** -- **is a string used as a kind of classification code** -- **entifier contains a an human usable id that can help a curator to identify which digital object is at hand and then retrieve it from a curatorial object store, like Cumulus**  
* describing (name=describing type=string stored=true indexed=true )  -- **contains the id of the root document being described in a child document**  
* described (name=described type=boolean stored=true indexed=true )  -- **is a boolean which is true if the document is a root doc, false otherwise**  
* entity\_id (name=entity\_id type=string stored=true indexed=true )  -- **is a string used as a kind of classification code**  
* collection (name=collection type=string stored=true indexed=true )  -- **the name of the collection from which the material originated, such as _Dansk Vestindien_**  
* local\_identifier (name=local\_identifier type=string stored=true required=false )  -- **contains a an human usable id that can help a curator to identify which digital object is at hand and then retrieve it from a curatorial object store, like Cumulus**  
* shelf\_mark (name=shelf\_mark type=text\_da stored=true indexed=true )  -- **the location of an original object in the Library's stocks**  
* shelf\_mark\_verbatim (name=shelf\_mark\_verbatim type=string stored=true indexed=true )   
* original\_object\_identifier (name=original\_object\_identifier type=text\_da stored=true indexed=true )   
* doms\_guid (name=doms\_guid type=string stored=true required=false )   
* entity\_type (name=entity\_type type=string stored=true indexed=true )  -- **is the name of (or related to) the pseudo field containing the child document**
  
### References
  
