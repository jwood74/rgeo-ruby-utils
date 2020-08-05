def upload_shape(shapefile = nil, database_table = nil)
    require 'progress_bar'

    max_length = 4190000

    unless shapefile
        puts "Enter file to upload"
        shapefile = gets.chomp
    end
    unless database_table
        puts "Enter <database>.<table_name>"
        database_table = gets.chomp
    end
    database = database_table.split(".").first

    array_1 = parse_shapefile_to_array(shapefile)
    rejects = Array.new

    sql = "drop table if exists #{database_table}; create table #{database_table} ("
    array_1.first.keys.each do |k|
        sql << "#{k} varchar(200),"
    end
    sql << " shape geometry not null, spatial index idx_shape (shape)); "
    SqlDatabase.runQuery(database,sql)
    bar = ProgressBar.new(array_1.count)
    sql = "insert into #{database_table} values "
    array_1.each do |a|
        if a.geometry.nil?
            rejects << a.attributes.values + ["no geometry"]
            line = ""
        else
            line = "('#{a.attributes.values.join("','")}',polyfromtext('#{a.geometry.as_text}', 4283)),"
        end
        
        simplify_amount = 0.00001
        until line.length < max_length
            line = "('#{a.attributes.values.join("','")}',polyfromtext('#{a.geometry.simplify(simplify_amount).as_text}', 4283)),"
            simplify_amount += 0.00001
        end

        if (sql.length + line.length) > max_length
            sql.chomp!(',')
            sql << "; "
            SqlDatabase.runQuery(database,sql)
            sql = "insert into #{database_table} values #{line}"
        else
            sql << line
        end

        if a == array_1.last
            sql.chomp!(',')
            sql << "; "
            SqlDatabase.runQuery(database,sql)
        end

        bar.increment!
    end

    puts "there were #{rejects.count} rejects"
    if rejects.count > 0
        CSV.open(ff.chomp(".shp").concat(".csv"), 'w') do |csv|
            rejects.each {|r| csv << r}
        end
    end
end