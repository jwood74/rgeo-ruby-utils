require 'rgeo/shapefile'
require 'csv'

puts "Enter path for shape 1"
shape_1 = gets.chomp
puts "Enter path of shape 2"
shape_2 = gets.chomp

new_file = File.expand_path('~/Downloads/'.concat(shape_1.split('/').last.split('.').first).concat('_to_').concat(shape_2.split('/').last.split('.').first).concat('.csv'))

array_1 = Array.new
array_2 = Array.new

factory = RGeo::Geos.factory(:srid => 4283)

RGeo::Shapefile::Reader.open(shape_1, :factory => factory) do |file|
    file.each { |record| array_1 << record }
end

RGeo::Shapefile::Reader.open(shape_2, :factory => factory) do |file|
    file.each { |record| array_2 << record }
end

results = [array_1.first.attributes.keys + array_2.first.attributes.keys + ['ratio']]

array_1.each do |a|
    next if a.geometry.nil?
    array_2.each do |b|
        next if b.geometry.nil?
        if a.geometry.intersects? b.geometry
            next unless (a.geometry.intersection(b.geometry).area / a.geometry.area).round(3) > 0.02
            results << a.attributes.values + b.attributes.values + [(a.geometry.intersection(b.geometry).area / a.geometry.area).round(3)]
        end
    end
end

CSV.open(new_file,'w') do |csv|
    results.each { |r| csv << r }
end