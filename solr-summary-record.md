# Using SOLR for web service escaping nested search

Using SOLR for everything, while avoiding the complexity of nested
search. We achieve this by creating a special `solr_summary_record`
which contains all fielded data needed for searches in coarse-grained
fields like `creator`, `subject`, `title`, `description` etc.


