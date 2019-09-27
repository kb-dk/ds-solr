# Digitale Samlinger Solr
Solr configuration files and setup instructions for the Digitale Samlinger project

## Premise
Solr is used for handling search as well as record metadata lookup.
This repository holds Solr configurations for the different collections
represented in Digitale Samlinger.

Field names are lowercase and `_` is the separation character.

The fields defined in the different `schema.xml` are sought to be shared
as much as possible between the different collections. As such, there are
three different types of fields:

### Mandatory fields

* **id**: Must be unique within the Royal Danish Library organization.
Prefix with `ds_` and append collection-name and a collection-specific identifier
for at total such as `ds_danskvestindien_324f243ed528`. No spaces allowed (replace with underscore `_`). 
* **type**: The material type. One of `image`, `moving_image`, `sound`, `text` and `other`.
The list of acceptable types will probably be extended, but do so by updating this
document first, to ensure consistent wording.
* **collection**: The name of the overall collection from which the material originated,
such as _Dansk Vestindien_.
* **indexed (date)**: A timestamp for when the material was added or updated in Solr.
Note: This is handled automatically by Solr.  

### Shared fields

* **title**: The title of the material.
* **author (multi value)**: Authors of the material. 
* **organization (multi value)**: the institution or organization associated with the material. 
* **subject (multi value)**: Uncontrolled subjects related to the material.
Subjects should be descriptive: `Christian 9 (1818-1906) konge af Danmark 1863-1906`.
* **keyword (multi value)**: Uncontrolled keywords related to the material.
Keywords should be short and generic: `konge`, `kongerække`, `Danmark`.
* **logical_path (multi value)**: The logical hierarchical position of the material, if available.
Separate values with `/`. Example: `Billeder/Samlinger/Avis- og bladarkiver/`.
Note: There can be more than one path.
* **datetime (datetime)**: The date that the material is about. For a newspaper this would be the
publication date. For a photography it would be the time the photo was taken. For a painting it
would be the time it was painted.
Note: This is a [DateRangeField](https://lucene.apache.org/solr/guide/8_1/working-with-dates.html#date-range-formatting)
that supports non-precise dates such as `2000-11` as well as date rages such as `[2000-11-01 TO 2014-12-01]`.  
* **created_date (datetime)**: The creation date of the material or metadata about the material
in the backing system.   
* **modified_date (datetime)**: When the material or metadata about the material was last changed.
If the material or metadata about the material was not changed after creation, this 
timestamp is the same as _created_date_.
* **text (multi value)**: The major text content of the material, if available. For a
word file, this would be the textual content. For an image, there would be no value.
* **freetext (multi value)**: Fallback field for search. Misc. content that is not indexed
in any other fields are added to this. 
* **page**: The page that the material is about, e.g. a page number from a book or a newspaper.
* **width_cm** / **height_cm** / **depth_cm** (floating point): Physical material dimensions in centimeters.
Note: For images this is not related to scanning resolution. The dimensions is for the original
physical object.  
* **width_pixels** / **height_pixels** / **depth_pixels**: Image dimensions in pixels. The depth
dimension is for 3D bitmaps, such as  [MRI scans](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging).
* **pixels**: total number of pixels in an image.

### Collection-specific fields
