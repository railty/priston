$sql = <<EOF
CREATE TABLE [dbo].[Multiple_Suppliers](
	[Product_ID] [nvarchar](15) NOT NULL,
	[Supplier_ID] [int] NOT NULL,
	[Quantity] [float] NULL
) ON [PRIMARY]
EOF

class MultipleSuppliers < ActiveRecord::Migration
  def up
	execute $sql
  end

  def down
	execute "Drop TABLE [dbo].[Multiple_Suppliers]"
  end
end
