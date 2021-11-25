# Using SOLR for web service escaping nested search

Using SOLR for everything, while avoiding the complexity of nested
search. We achieve this by creating a special `solr_summary_record`
which contains all fielded data needed for searches in coarse-grained
fields like `creator`, `subject`, `title`, `description` etc.


In this small corpus I've made `creator` a list of names connected to
the work through roles like

* aut (author)
* creator
* artist
* scribe
* translator

`Subject name` are copied to `subject_person` and so are recipients
and other passive roles.

The titles are given as a list ordered by language

* Danish
* English
* other

regardless of the types of title (main, sub, uniform, whatever
title). A brief hit presentation can be made by retrieving just the
first title.

`note` and `physical description` goes to `description`


