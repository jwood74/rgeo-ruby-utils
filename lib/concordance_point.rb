def concordance_point(shapes_file = nil, points_file = nil)
    unless shapes_file
        puts "Enter path for shapes layer"
        shapes_file = gets.chomp
    end
    unless points_file
        puts "Enter path of points csv"
        points_file = gets.chomp
    end

    shapes = parse_shapefile_to_array(shapes_file)
    points = csv_points_to_array(points_file)
    results = Array.new

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
        csv << points.first.keys[0..-2]
        points.each do |hash|
            csv << hash.values[0..-2]
        end
    end
end