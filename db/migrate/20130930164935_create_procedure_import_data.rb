class CreateProcedureImportData < ActiveRecord::Migration
  def up
	run_sql_file(self.name.underscore)
  end

  def down
	drop_sql_object(self.name.underscore)
  end
end
