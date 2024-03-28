ALTER TABLE historical
DROP COLUMN fid_, DROP COLUMN lucode, DROP COLUMN landcover, DROP COLUMN shape_leng, DROP COLUMN shape_le_1, DROP COLUMN shape_area;
ALTER TABLE modern01
DROP COLUMN fid_, DROP COLUMN fid_1, DROP COLUMN dn, DROP COLUMN shape_leng,  DROP COLUMN shape_area;
ALTER TABLE modern11
DROP COLUMN fid_, DROP COLUMN fid_1, DROP COLUMN dn, DROP COLUMN shape_leng,  DROP COLUMN shape_area;
ALTER TABLE modern21
DROP COLUMN fid_, DROP COLUMN fid_1, DROP COLUMN dn, DROP COLUMN shape_leng,  DROP COLUMN shape_area;