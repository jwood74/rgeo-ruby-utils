class SqlDatabase
	require "mysql2"
	def self.connect(database)
		dbase = Mysql2::Client.new(:host => $mysql_host, :username => $mysql_user, :password => $mysql_password, :database => database, :flags => Mysql2::Client::MULTI_STATEMENTS)
		return dbase
	end

	def self.runQuery(databasestring,querystring)
		db = self.connect(databasestring.to_s)
		result = db.query(querystring.to_s)
		db.close
		return result
	end
end

def parse_shapefile_to_array(shapefile)
	array = Array.new
    RGeo::Shapefile::Reader.open(shapefile, :factory => FACTORY) do |file|
        file.each { |record| array << record }
	end
	return array
end

def csv_points_to_array(points)
	array = Array.new
    CSV.foreach(points, headers: true) do |c|
        tmp = c.to_h
        tmp['point'] = FACTORY.point(c['longitude'].to_f,c['latitude'].to_f)
        array << tmp
	end
	return array
end