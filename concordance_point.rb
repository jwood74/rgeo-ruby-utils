require 'rgeo/shapefile'
require 'csv'

puts "Enter path for shapes layer"
shapes_file = gets.chomp
puts "Enter path of points csv"
points_file = gets.chomp

shapes = Array.new
points = Array.new
results = Array.new

factory = RGeo::Geos.factory(:srid => 4283)

RGeo::Shapefile::Reader.open(shapes_file, :factory => factory) do |file|
    file.each { |record| shapes << record }
end

CSV.foreach(points_file, headers: true) do |c|
    tmp = c.to_h
    tmp['point'] = factory.point(c['longitude'].to_f,c['latitude'].to_f)
    points << tmp
end

results << points.first.keys[0..-2] + shapes.first.attributes.keys

points.reverse.each do |point|
    shapes.each do |shape|
        if point['point'].within? shape.geometry
            results << point.values[0..-2] + shape.attributes.values
            points.delete(point)
        end
    end
end

nowtime = Time.now.strftime("%Y%m%d%H%M%S")

File.write("results_#{nowtime}.csv", results.map(&:to_csv).join)

CSV.open("rejects_#{nowtime}.csv", "wb") do |csv|
    keys = points.first.keys[0..-2]
    csv << keys
    points.each do |hash|
      csv << hash.values[0..-2]
    end
end