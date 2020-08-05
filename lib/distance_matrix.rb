def distance_matrix(shapes_file = nil, points_file = nil)
    unless shapes_file
        puts "Enter path for shapes layer"
        shapes_file = gets.chomp
    end
    unless points_file
        puts "Enter path of points csv"
        points_file = gets.chomp
    end

    shapes_array = parse_shapefile_to_array(shapes_file)
    points_array = csv_points_to_array(points_file)
    results = Array.new

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
end