# template1.6

## Internal Fields 
      
  
* \_version\_ (name=_version_ type=long )   
* \_root\_ (name=_root_ type=string indexed=true stored=true docValues=true )  --  contains the id of the root document of a collection of nested solr documents   
* \_nest\_path\_ (name=_nest_path_ type=_nest_path_ stored=true indexed=true )   
* \_nest\_parent\_ (name=_nest_parent_ type=string indexed=true stored=true ) 
  
### References
  
[Schema configuration for nested documents](https://solr.apache.org/guide/8_10/indexing-nested-documents.html#schema-configuration) 
