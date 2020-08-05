def concordance_shape(shape_1 = nil, shape_2 = nil)
    unless shape_1
        puts "Enter path for shape 1"
        shape_1 = gets.chomp
    end
    unless shape_2
        puts "Enter path of shape 2"
        shape_2 = gets.chomp
    end

    array_1 = parse_shapefile_to_array(shape_1)
    array_2 = parse_shapefile_to_array(shape_2)

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

    new_file = File.expand_path('~/Downloads/'.concat(shape_1.split('/').last.split('.').first).concat('_to_').concat(shape_2.split('/').last.split('.').first).concat('.csv'))

    CSV.open(new_file,'w') do |csv|
        results.each { |r| csv << r }
    end
end