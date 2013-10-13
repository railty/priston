$sql = <<EOF
CREATE TABLE [dbo].[Multiple_Supplier_Products](
	[Barcode] [nvarchar](15) NOT NULL,
	[Name] [varchar](50) NULL,
	[Name2] [nvarchar](40) NULL,
	[Current #] [int] NOT NULL,
	[Department] [nvarchar](20) NULL,
	[SPEC] [varchar](20) NULL,
	[Rank] [nvarchar](2) NULL,
	[Location] [nvarchar](32) NULL,
	[Prod_Desc] [varchar](80) NULL,
	[RegPrice] [money] NULL,
	[OnSale$] [money] NULL,
	[OnSales] [int] NULL,
	[QtySale] [int] NULL,
	[QtySale#] [int] NULL,
	[QtySale$] [float] NULL,
	[Tax] [varchar](3) NOT NULL,
	[Ordered] [decimal](8, 2) NULL,
	[Lst Rcv $] [decimal](8, 2) NULL,
	[Lst Rcv #] [float] NULL,
	[Lst Rcv UPP] [int] NULL,
	[Lwst Rcv $] [decimal](8, 2) NULL,
	[LSale Date] [varchar](10) NOT NULL,
	[LSale Day] [int] NOT NULL,
	[LInv Date] [varchar](10) NOT NULL,
	[Last Wk Sale] [float] NULL,
	[Supplier_ID] [int] NULL,
	[Quantity] [float] NULL,
	[User] [varchar](50) NULL,
	[Time] [datetime] NULL,
	[ID] [int] NOT NULL,
CONSTRAINT [PK_Multiple_Supplier_Products] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
EOF

class MultipleSupplierProducts < ActiveRecord::Migration
  def up
	  execute $sql
  end

  def down
  	execute "DROP TABLE [dbo].[Multiple_Supplier_Products]"
  end
end
