Create PROCEDURE [dbo].[Append_Zero_Inventory_Products]
	@PO_ID NVARCHAR(9),
	@Buyer_Name nvarchar(50)
AS
BEGIN
Declare @Last_PO_ID NVARCHAR(9);
Declare @Store_ID int; 
Declare @Supplier_ID int;

	SET NOCOUNT ON;

	IF @PO_ID <> '' begin
		Select @Supplier_ID = Supplier_ID, @Store_ID = Store_ID From POs Where PO_ID = @PO_ID;
	
		Insert Into PO_Details (PO_ID, Product_ID, OrderingDate, OrderedBy, Status)
  		Select @PO_ID, Product_ID, GETDATE(), @Buyer_Name, 1
		From Pos Join PO_Details On POs.PO_ID = PO_Details.PO_ID
		Where Supplier_ID = @Supplier_ID And Store_ID = @Store_ID
		And Product_ID In (Select Barcode From Products_Pris Where InStock = 0)
		Group by Product_ID;
	End
	
	Return @@ROWCOUNT

END
