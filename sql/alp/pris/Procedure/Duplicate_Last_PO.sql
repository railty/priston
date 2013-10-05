create PROCEDURE [dbo].[Duplicate_Last_PO]
	@Store_ID int, 
	@Supplier_ID int, 
	@Buyer_Name nvarchar(50),
	@PO_ID NVARCHAR(9) output
AS
BEGIN
Declare @Last_PO_ID NVARCHAR(9);

	SET NOCOUNT ON;
	Set @Last_PO_ID = ''
	Select Top 1 @Last_PO_ID = PO_ID From POs Where State = 'Received' And DeliveryDate is not null And Store_ID = @Store_ID And Supplier_ID = @Supplier_ID Order By Received_Date Desc;
	
	IF @Last_PO_ID = ''  Begin 
		Set @PO_ID = ''
		Return @PO_ID
	end
	
	EXEC Create_PO @Store_ID, @Supplier_ID, 'Ordering', @Buyer_Name, @PO_ID out;
	
	IF @PO_ID <> '' begin
		Insert Into PO_Details (PO_ID, Product_ID, TaxRate, OrderingDate, OrderedBy, PriceOrdered, UnitsOrdered, UnitsPerPackage, Status)
		Select @PO_ID, Product_ID, TaxRate, GETDATE(), @Buyer_Name, PriceOrdered, UnitsOrdered, UnitsPerPackage, 1
		From PO_Details Where PO_ID = @Last_PO_ID;
	End
	
	Return @PO_ID

END
