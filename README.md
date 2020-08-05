# rgeo-ruby-utils

Some useful utilities for RGEO

Documention on the Internet was hard to come by, so these have been fumbled together.

## Setup

- install the gems
- duplicate the `options_example` file and rename it `options`. If you are planning on upload data into MySQL, update this file with your SQL credentials.

## How to use

### Option 1

Require rgeo_utils within your existing project, and then call the relevant method. Each method takes various arguments (you can check the method to see) or it will prompt you to enter then when running.

### Option 2
run `ruby rgeo_utils` and supply the name of the method as an argument.

Eg. `ruby rgeo_utils concordance_point`

## Explanations

- concordance_point - for each point, find which shape it resides in

- concordance_shape - for each shape A, find what percentage it is in shape B

- distance_matrix - for each shape, calculate distance from centroid to each point

- split_up - create geojson file for each feature, splitting on column of your choice

- upload_shp - upload shapefile to mysql server

- make_geojson - convert array of features to geojson file

## to do

1. Clean up each method - make more consistent
2. Create better tests
3. Create better documentation