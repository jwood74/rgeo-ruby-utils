require "mysql2"

class SqlDatabase
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