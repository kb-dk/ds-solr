# Using SOLR for web service escaping nested search

Using SOLR for everything, while avoiding the complexity of nested
search. We achieve this by creating a special `solr_summary_record`
which contains all fielded data needed for searches in coarse-grained
fields like `creator`, `subject`, `title`, `description` etc.


In this small corpus I've made creator a list of names of names connected to the work through roles like

* aut (author)
* creator
* artist
* scribe
* translator

The titles are given as a list ordered by language

* Danish
* English
* other

regardless of the types of title (main, sub, uniform, whatever title)

notes and physical description goes to description


