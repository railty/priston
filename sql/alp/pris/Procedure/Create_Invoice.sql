CREATE PROCEDURE [dbo].[Create_Invoice]
	@PO_ID NVARCHAR(9),
	@Invoice_ID int output
AS
BEGIN
	Declare @Amount As Float;

	Select @Amount = SUM(ISNULL(UnitsReceived, 0)*ISNULL(PriceReceived, 0)*(1+ISNULL(TaxRate, 0))) From PO_Details Where PO_ID = @PO_ID;
	If @Amount = 0 Return;

	Print 'Creating Invoice'
	
	Declare @Store_ID As int;
	Select @Store_ID = Store_ID From Stores Where Active = 'Y';

	Insert Into Payment.dbo.tblInvoice_Pris(PayerID, InvoiceNumber, SupplierID, PO_ID)
	Select @Store_ID, Invoice, Supplier_ID, @PO_ID From POs Where POs.PO_ID = @PO_ID;

	Set @Invoice_ID = SCOPE_IDENTITY();
	
	Update Payment.dbo.tblInvoice_Pris
	Set Amount = @Amount;

	Update Payment.dbo.tblInvoice_Pris
	Set GST = (Select SUM(ISNULL(UnitsReceived, 0)*ISNULL(PriceReceived,0)*(ISNULL(TaxRate,0))) From PO_Details Where PO_ID = @PO_ID)
	Where InvoiceID = @Invoice_ID;

	Insert Into Payment.dbo.tblSubInvoice_Pris(InvoiceID, Category, SubAmount, GST)
	Select @Invoice_ID, Department, SUM(ISNULL(UnitsReceived,0)*ISNULL(PriceReceived,0)*(1+ISNULL(TaxRate,0))), SUM(ISNULL(UnitsReceived,0)*ISNULL(PriceReceived,0)*(ISNULL(TaxRate,0)))
	From PO_Details Join Products On Product_ID = Prod_Num Where PO_ID = @PO_ID
	Group by Department;
END


