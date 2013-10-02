class AlterTablePosAddInvoiceDate < ActiveRecord::Migration
  def up
	execute "Alter TABLE [dbo].[POs] Add [Invoice_Date] [date] NULL"
  end

  def down
	execute "Alter TABLE [dbo].[POs] Drop Column [Invoice_Date]"
  end
end
