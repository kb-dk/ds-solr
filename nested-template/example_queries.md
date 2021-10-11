# Example Queries

Start a solr instance on your localhost according to the instructions in [README](../README.md)

This searches for records with cataloging-language:en, and returns everything.

```
"params": {
      "q": "{!term f=cataloging-language}en",
      "fl": "*,[child]"
    }

```

http://localhost:10007/solr/ds/select?fl=*%2C%5Bchild%5D&q=%7B!term%20f%3Dcataloging-language%7Den
