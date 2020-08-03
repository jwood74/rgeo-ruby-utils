require 'rgeo/shapefile'

require_relative 'make_geojson'

factory = RGeo::Geos.factory(:srid => 4283)

puts "Enter path to file to split up"
shapefile = gets.chomp
column = nil

RGeo::Shapefile::Reader.open(shapefile, :factory => factory) do |file|

    file.each do |record| 
        unless column
            puts "Enter column to split on"
            puts record.attributes.keys.to_s
            column = gets.chomp
            puts "suffix?"
            suffix = gets.chomp
        end
        make_geojson(record.attributes[column].to_s.downcase.gsub(" ","").concat(suffix.to_s),[record])
    end
end