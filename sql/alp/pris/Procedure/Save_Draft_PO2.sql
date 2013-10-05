-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Save_Draft_PO2] 
	@Product_ID varchar(15), 
	@Quantity float,
	@User nvarchar(50)
AS
BEGIN
	Declare @Store_ID Int;
	Declare @Supplier_ID Int;
	Select @Store_ID = Store_ID From Stores Where Active = 'Y';
	
	Select @Supplier_ID = Supplier_ID From Supplier_Products Where Product_ID = @Product_ID;

	If @@ROWCOUNT = 1 
		Exec Save_Draft_PO_Supplier @Store_ID, @Supplier_ID, @Product_ID, @Quantity, @User
	Else
		Delete From Multiple_Suppliers Where Product_ID = @Product_ID;
		Delete From Multiple_Suppliers_Product Where Product_ID = @Product_ID;

		Insert Into Multiple_Suppliers (Product_ID, Supplier_ID, Quantity)
		Select @Product_ID, Supplier_ID, @Quantity From Supplier_Products Where Product_ID = @Product_ID;

		Delete From Product_Info;
		INSERT INTO Product_Info EXEC Get_Product_Info @Barcode = @Product_ID;
		
		Insert Into Multiple_Suppliers_Product(           
			[Product_ID]
           ,[Supplier_ID]
           ,[Name]
           ,[Name2]
           ,[Current #]
           ,[Department]
           ,[SPEC]
           ,[Rank]
           ,[Location]
           ,[Prod_Desc]
           ,[RegPrice]
           ,[OnSale$]
           ,[OnSales]
           ,[QtySale]
           ,[QtySale#]
           ,[QtySale$]
           ,[Tax]
           ,[Ordered]
           ,[Lst Rcv $]
           ,[Lwst Rcv $]
           ,[LSale Date]
           ,[LSale Day]
           ,[LInv Date])
		Select 
			[Product_ID]
           ,[Supplier_ID]
           ,[Name]
           ,[Name2]
           ,[Current #]
           ,[Department]
           ,[SPEC]
           ,[Rank]
           ,[Location]
           ,[Prod_Desc]
           ,[RegPrice]
           ,[OnSale$]
           ,[OnSales]
           ,[QtySale]
           ,[QtySale#]
           ,[QtySale$]
           ,[Tax]
           ,[Ordered]
           ,[Lst Rcv $]
           ,[Lwst Rcv $]
           ,[LSale Date]
           ,[LSale Day]
           ,[LInv Date] From Multiple_Suppliers Join Product_Info On Multiple_Suppliers.Product_ID = Product_Info.Barcode;
END


