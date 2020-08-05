# rgeo-ruby-utils

Some useful utilities for RGEO

Documention on the Internet was hard to come by, so these have been fumbled together.

## Explanations

concordance_point - for each point, find which shape it resides in

concordance_shape - for each shape A, find what percentage it is in shape B

distance_matrix - for each shape, calculate distance from centroid to each point

split_up - create geojson file for each feature, splitting on column of your choice

upload_shp - upload shapefile to mysql server

make_geojson - convert array of features to geojson file

## to do

1. Clean up each method - make more consistent
2. Create better tests
3. Create better documentation