require 'rgeo/shapefile'
require 'csv'

puts "Enter the path to shape file"
shapes = gets.chomp
puts "Enter the path of points csv"
points = gets.chomp

shapes_array = Array.new
points_array = Array.new
results = Array.new

factory = RGeo::Geos.factory(:srid => 4283)

RGeo::Shapefile::Reader.open(shapes, :factory => factory) do |file|
    file.each { |record| shapes_array << record }
end

CSV.foreach(points, headers: true) do |c|
    tmp = c.to_h
    tmp['point'] = factory.point(c['longitude'].to_f,c['latitude'].to_f)
    points_array << tmp
end

points_array.each do |a|
    shapes_array.each do |b|
        next if b.geometry.nil?
        results << a.values[0..-2] + b.attributes.values + [a['point'].distance(b.geometry.centroid)]
    end
end

nowtime = Time.now.strftime("%Y%m%d%H%M%S")

CSV.open("distance_matrix_#{nowtime}.csv", "wb") do |csv|
    csv << points_array.first.keys[0..-2] + shapes_array.first.attributes.keys + ['distance']
    results.each do |hash|
      csv << hash
    end
end