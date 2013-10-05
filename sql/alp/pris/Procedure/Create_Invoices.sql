CREATE PROCEDURE [dbo].[Create_Invoices]
AS
BEGIN
Declare @PO_ID NVARCHAR(9);
Declare @Invoice_ID int;

	Print 'Creating Invoices'

	DECLARE PO_ID_Cursor CURSOR FOR  
	Select POs.PO_ID From POs Left Join Payment.dbo.tblInvoice_Pris On POs.PO_ID = Payment.dbo.tblInvoice_Pris.PO_ID
	Where Pos.State = 'Received' And Payment.dbo.tblInvoice_Pris.PO_ID Is Null;

	OPEN PO_ID_Cursor;
	FETCH NEXT FROM PO_ID_Cursor INTO @PO_ID;
			
	WHILE @@FETCH_STATUS = 0   
	BEGIN   

		EXEC [dbo].[Create_Invoice] @PO_ID = @PO_ID, @Invoice_ID = @Invoice_ID OUTPUT;

		FETCH NEXT FROM PO_ID_Cursor INTO @PO_ID
	END   

	CLOSE PO_ID_Cursor
	DEALLOCATE PO_ID_Cursor
END


