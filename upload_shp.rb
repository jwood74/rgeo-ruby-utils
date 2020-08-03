require 'rgeo/shapefile'
require 'progress_bar'

require_relative 'options'
require_relative 'commands'

MAX_LENGTH = 4190000

puts "Enter file to upload"
ff = gets.chomp
puts "Enter <database>.<table_name>"
database_table = gets.chomp
database = database_table.split(".").first

array_1 = Array.new
rejects = Array.new

factory = RGeo::Geos.factory(:srid => 4283)

RGeo::Shapefile::Reader.open(ff, :factory => factory) do |file|
    puts "File contains #{file.num_records} records."
    file.each do |record| 
        array_1 << record
        print "#{record.index}\r"
    end
end

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
        puts "No geometry"
        rejects << a.attributes.values + ["no geometry"]
        line = ""
    else
        line = "('#{a.attributes.values.join("','")}',polyfromtext('#{a.geometry.as_text}', 4283)),"
    end
    
    simplify_amount = 0.00001
    until line.length < MAX_LENGTH
        line = "('#{a.attributes.values.join("','")}',polyfromtext('#{a.geometry.simplify(simplify_amount).as_text}', 4283)),"
        simplify_amount += 0.00001
    end

    if (sql.length + line.length) > MAX_LENGTH
        sql.chomp!(',')
        sql << "; "
        SqlDatabase.runQuery(database,sql)
        sql = "insert into #{database_table} values #{line}"
    else
        sql << line
    end

    if a == array_1.last
        puts "last one"
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