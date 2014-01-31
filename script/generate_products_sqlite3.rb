require 'prislib'

def fv(h, fd)
	return 'null' if h[fd] == nil
	return "'#{h[fd].gsub("'", "''")}'"
end

dbname = "db/products.sqlite3"

File.delete(dbname) if File.exist?(dbname)
sqlite = SQLite3::Database.new(dbname)

sqlite.execute( "create table departments(id int, name varchar(30))" )
sqlite.execute( "create table products(prod varchar(14), dept int, name varchar(50), alias varchar(50), desc varchar(50), spec varchar(20), reg_price real, onsale_price real)" )
  

sql = "
select Product.Prod_Num, Prod_Name, Prod_Desc, Prod_Alias, PackageSpec, Department, RegPrice, OnsalePrice from product 
join ProductPrice on product.Prod_Num = ProductPrice.ProdNum
join (select distinct prod_num as prod_num from Invoice_Item where date_sent >= '2013/10/01') as temp1 on product.Prod_Num = temp1.Prod_Num
"


db = Db.new('localhost', 'MBPOSDB')
db.run_sql(sql) do |result|
	ct = 0
	depts = {}
	dept_id = 1
	result.each do |r|
		dept = r['Department']
		if depts[dept]==nil then
			depts[dept] = dept_id
			dept_id = dept_id + 1
		end
		sql = "insert into products(prod, dept, name, alias, desc, spec, reg_price, onsale_price) values(#{fv(r, 'Prod_Num')}, 1, #{fv(r, 'Prod_Name')}, #{fv(r, 'Prod_Alias')}, #{fv(r, 'Prod_Desc')}, #{fv(r, 'PackageSpec')}, #{r['RegPrice']}, #{r['OnsalePrice']})"
		#puts sql
		sqlite.execute sql
		ct = ct+1
		puts "#{ct}" if ct%100==0
	end
	depts.each do |k, v|
		sql = "insert into departments(id, name) values(#{v}, '#{k}')"
		puts sql
		sqlite.execute sql
	end
end
