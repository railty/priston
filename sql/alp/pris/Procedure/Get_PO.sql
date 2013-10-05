CREATE PROCEDURE [dbo].[Get_PO]
	@Store_ID int, 
	@Supplier_ID int, 
	@Invoice nvarchar(50),	
	@PO_ID NVARCHAR(9) output,
	@Total Money output
AS
BEGIN
	SET NOCOUNT ON;
	Select @PO_ID = PO_ID From POs Where Store_ID = @Store_ID And Supplier_ID = @Supplier_ID And Invoice = @Invoice;
	Select @Total = Sum(PriceReceived*UnitsReceived*(1+Taxrate)) From POs join PO_Details on POs.PO_ID = PO_Details.PO_ID
	Where POs.PO_ID = @PO_ID;
END
