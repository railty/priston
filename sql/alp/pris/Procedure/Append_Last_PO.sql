CREATE PROCEDURE [dbo].[Append_Last_PO]
	@PO_ID NVARCHAR(9),
	@Buyer_Name nvarchar(50)
AS
BEGIN
Declare @Last_PO_ID NVARCHAR(9);
Declare @Store_ID int; 
Declare @Supplier_ID int;

	SET NOCOUNT ON;
	IF @PO_ID = ''  Begin 
		Return 0;
	end

	Select @Supplier_ID = Supplier_ID, @Store_ID = Store_ID From POs Where PO_ID = @PO_ID;

	Set @Last_PO_ID = ''
	Select Top 1 @Last_PO_ID = PO_ID From POs Where State = 'Received' And DeliveryDate is not null And Store_ID = @Store_ID And Supplier_ID = @Supplier_ID Order By Received_Date Desc;
	
	IF @Last_PO_ID = ''  Begin 
		Return 0;
	end
	
	IF @PO_ID <> '' begin
		Insert Into PO_Details (PO_ID, Product_ID, TaxRate, OrderingDate, OrderedBy, PriceOrdered, UnitsOrdered, UnitsPerPackage, Status)
	  	Select @PO_ID, A.Product_ID, A.TaxRate, GETDATE(), @Buyer_Name, A.PriceOrdered, A.UnitsOrdered, A.UnitsPerPackage, 1 From 
  		(Select * from PO_Details Where PO_ID = @Last_PO_ID) As A Left Join 
  		(Select * from PO_Details Where PO_ID = @PO_ID) As B
  		On A.Product_ID = B.Product_ID Where B.Product_ID is Null;
	End
	
	Return @@ROWCOUNT

END
