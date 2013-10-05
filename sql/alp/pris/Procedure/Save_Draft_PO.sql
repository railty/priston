-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Save_Draft_PO] 
	@Product_ID varchar(15), 
	@Quantity float,
	@User nvarchar(50)
AS
BEGIN
	Declare @Store_ID Int;
	Declare @Supplier_ID Int;
	Select @Store_ID = Store_ID From Stores Where Active = 'Y';

	Declare @Ct Int;
	Select @Ct = Count(Supplier_ID) From Supplier_Products Where Product_ID = @Product_ID;

	If @Ct = 0 
		Begin
			Exec Save_Draft_PO_Supplier @Store_ID, 99999, @Product_ID, @Quantity, @User;
		End
	Else If @Ct = 1 
		Begin
			Select @Supplier_ID = Supplier_ID From Supplier_Products Where Product_ID = @Product_ID;
			Exec Save_Draft_PO_Supplier @Store_ID, @Supplier_ID, @Product_ID, @Quantity, @User;
		End
	Else
		Begin
			DECLARE Supplier_Cursor CURSOR FOR  
			Select Supplier_ID From Supplier_Products Where Product_ID = @Product_ID;

			OPEN Supplier_Cursor;
			FETCH NEXT FROM Supplier_Cursor INTO @Supplier_ID;
			
			WHILE @@FETCH_STATUS = 0   
			BEGIN   
				Delete From Multiple_Supplier_Products Where Barcode = @Product_ID And Supplier_ID = @Supplier_ID;
				EXEC Get_Product_Info @Barcode = @Product_ID;
				
				Update Product_Info Set Supplier_ID = @Supplier_ID;
				Update Product_Info Set Quantity = @Quantity;
				Update Product_Info Set [User] = @User;
				Update Product_Info Set [Time] = GETDATE();
				
				Declare @Price Float;
				SELECT Top 1 @Price = PriceReceived	FROM [dbo].[POs] Join [dbo].[PO_Details] On POs.PO_ID = PO_Details.PO_ID Where PriceReceived Is Not Null And Product_ID = @Product_ID And Supplier_ID=@Supplier_ID And DATEDIFF(day, ReceivingDate, GetDATE())<365 Order By PriceReceived;
				Update Product_Info Set [Lwst Rcv $] = @Price;
				
				Insert Into Multiple_Supplier_Products Select * From Product_Info;

				FETCH NEXT FROM Supplier_Cursor INTO @Supplier_ID
			END   

			CLOSE Supplier_Cursor
			DEALLOCATE Supplier_Cursor
		End
END


