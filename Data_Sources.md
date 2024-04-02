## Data Sources

### **Study Area Boundaries:**

##### North Carolina County Polygons: Onemap Data Portal
https://www.nconemap.gov/datasets/9728285994804c8b9f20ce58bae45899/explore

##### South Carolina County Polygons
https://koordinates.com/layer/96987-south-carolina-county-boundaries/

##### Extent of Charlotte Metropolitan Statistical Area
https://en.wikipedia.org/wiki/Charlotte_metropolitan_area

(Converted to .cvs with https://wikitable2csv.ggor.de/ )


### **Satellite Images:**
All satellite images are from the "landsat-c2-l2" collection, and queried using https://planetarycomputer.microsoft.com/api/stac/v1 via PyStack on Microsoft Planetary Computer’s Python interface.

The scripts used for this data acquisition is in this repository.

### Historical Imagery: USGS Land Use and Land Cover Datasets 1970-1985
Historical satellite images from 
https://water.usgs.gov/GIS/dsdl/ds240/index.html.
These images are landcover classisfications encompassing the time period from 1970-1985.
We used the 5 images corresponding to our study area.

### Modern Imagery: Multi-Resolution Land Characteristics Consortium
Images of the past couple decades covering our study area from 
https://www.mrlc.gov/viewer/.
Images are landcover classifications covering 2001, 2011, and 2021.
