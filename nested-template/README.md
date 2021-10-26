# template1.6

## Internal Fields 
      
  
* \_version\_ (name=\_version\_ type=long )   
* \_root\_ (name=\_root\_ type=string indexed=true stored=true docValues=true )  -- *contains the id of the root document of a collection of nested solr documents*  
* \_nest\_path\_ (name=\_nest\_path\_ type=\_nest\_path\_ stored=true indexed=true )   
* \_nest\_parent\_ (name=\_nest\_parent\_ type=string indexed=true stored=true ) 
  
### References
  
[Schema configuration for nested documents](https://solr.apache.org/guide/8_10/indexing-nested-documents.html#schema-configuration) 
