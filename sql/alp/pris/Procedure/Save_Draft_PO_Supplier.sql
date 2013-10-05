-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Save_Draft_PO_Supplier] 
	@Store_ID Int,
	@Supplier_ID Int,
	@Product_ID varchar(15), 
	@Quantity float,
	@User nvarchar(50)
AS
BEGIN
	Declare @PO_ID VARCHAR(9);
	Print @Supplier_ID;
	
	Select Top 1 @PO_ID = PO_ID From POs where State='Ordering' And Supplier_ID = @Supplier_ID Order By PO_ID Desc;
	if @@ROWCOUNT = 1 
		Begin
			Print 'Found'
			Print @PO_ID
		End
	Else
		Begin
			Print 'Not Found'
			Exec Create_PO @Store_ID, @Supplier_ID, 'Ordering',	@User, @PO_ID output;
			Print @PO_ID
		End
		
	Select Product_ID From PO_Details Where PO_ID = @PO_ID And Product_ID = @Product_ID;
	if @@ROWCOUNT = 1 
		Begin
			Print 'Existing Item'
			Update PO_Details Set OrderingDate = GetDate(), OrderedBy = @User, UnitsOrdered = @Quantity, PriceOrdered = 0, UnitsPerPackage = 1 Where PO_ID = @PO_ID And Product_ID = @Product_ID;
		End
	Else
		Begin
			Print 'New Item'
			Insert Into PO_Details (PO_ID, Product_ID, OrderingDate, OrderedBy, UnitsOrdered, PriceOrdered, UnitsPerPackage, Status) 
			Values (@PO_ID, @Product_ID, GetDate(), @User, @Quantity, 0, 1, 1);
		End
		
	Declare @Price Float;		
	SELECT Top 1 @Price = PriceReceived	FROM [dbo].[POs] Join [dbo].[PO_Details] On POs.PO_ID = PO_Details.PO_ID Where PriceReceived Is Not Null And Product_ID = @Product_ID And Supplier_ID=@Supplier_ID And DATEDIFF(day, ReceivingDate, GetDATE())<365 Order By PriceReceived;
	Update PO_Details Set PriceOrdered = @Price Where PO_ID = @PO_ID And Product_ID = @Product_ID;
		
END
