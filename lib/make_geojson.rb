def make_geojson(name, features, simplify = "")
  result = {
    "type" => "FeatureCollection",
    "name" => name,
    "crs" => {
              "type" => "name",
              "properties" => { "name" => "urn:ogc:def:crs:EPSG::4283" },
            },
    "features" => Array.new,
  }
  features.each do |f|
    tmp = {
      "type" => "Feature",
      "properties" => Hash.new,
      "geometry" => Hash.new,
    }

    if f.respond_to? :geometry
        unless simplify == ""
            tmp["geometry"] = { "coordinates" => f.geometry.simplify(simplify).coordinates }
        else
            tmp["geometry"] = { "coordinates" => f.geometry.coordinates }
        end
        ## Probably a ShapeFile
        if f.geometry.geometry_type.to_s == "MultiPolygon"
            tmp["geometry"]["type"] = "MultiPolygon"
        elsif f.geometry.geometry_type.to_s == "Polygon"
            tmp["geometry"]["type"] = "Polygon"        
        elsif f.geometry.geometry_type.to_s == "Point"
            tmp["geometry"]["type"] = "Point"
        else
            puts "Something here"
        end

        f.attributes.keys.each do |k|
            tmp["properties"][k] = f.attributes[k]
        end
    elsif f.respond_to? :geometry_type
        ## Somesort of generated shape
        if f.geometry_type.to_s == "Polygon"
            tmp["geometry"] = { "coordinates" => f.coordinates }
            tmp["geometry"]["type"] = "Polygon"
        elsif f.geometry_type.to_s == "Point"
            tmp["geometry"] = { "coordinates" => f.coordinates }
            tmp["geometry"]["type"] = "Point"
        else
            puts "fdjdfjhd"
        end
    elsif f['point']
        ## An array of points
        if f['point'].geometry_type.to_s == 'Point'
            tmp["geometry"] = { "coordinates" => f['point'].coordinates }
            tmp["geometry"]["type"] = "Point"
        else
            "abcd"
        end

        f.keys[0..-2].each do |k|
            tmp["properties"][k] = f[k]
        end
    elsif f['latitude']
        ## An array of lat longs
        tmp["geometry"] = { "coordinates" => [f['longitude'], f['latitude']] }
        tmp["geometry"]["type"] = "Point"

        f.to_h.keys.each do |k|
            next if ['latitude','longitude'].include? k
            tmp["properties"][k] = f[k]
        end
    else
        puts "dsjfslkjdls"
    end
    result["features"] << tmp
  end
  File.open(File.expand_path("~/Downloads/#{name}.geojson"), "w") do |f|
    f.write(result.to_json)
  end
end
