class DropTablePosSalesToday < ActiveRecord::Migration
  def up
	drop_sql_object(self.name.underscore)
  end

  def down
  end
end
