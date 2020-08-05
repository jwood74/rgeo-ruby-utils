def split_up(shapefile = nil, column = nil, suffix = nil, simplyfy = nil)
    unless shapefile
        puts "Enter path to file to split up"
        shapefile = gets.chomp
    end

    shapes = parse_shapefile_to_array(shapefile)

    unless column
        puts "Enter column to split on"
        puts shapes.first.attributes.keys.to_s
        column = gets.chomp
    end
    unless suffix
        puts "Enter a suffix for the end of each file. Leave blank if required."
        suffix = gets.chomp
    end
    unless simplyfy
        puts "Enter a number to simply each feature by. Leave blank if required."
        simplyfy = gets.chomp
    end

    shapes.each do |s|
        make_geojson(s.attributes[column].to_s.downcase.gsub(" ","").concat(suffix.to_s),[s],simplyfy)
    end
end