require 'rgeo/shapefile'
require 'csv'

input = ARGV[0]
ARGV.clear

require_relative 'options'
require_relative 'lib/commands'
require_relative 'lib/concordance_point'
require_relative 'lib/concordance_shape'
require_relative 'lib/distance_matrix'
require_relative 'lib/make_geojson'
require_relative 'lib/split_up'
require_relative 'lib/upload_shp'

FACTORY = RGeo::Geos.factory(:srid => 4283)

case input
when 'concordance_point'
    concordance_point
when 'concordance_shape'
    concordance_shape
when 'distance_matrix'
    distance_matrix
when 'split_up'
    split_up
when 'upload_shape'
    upload_shape
end