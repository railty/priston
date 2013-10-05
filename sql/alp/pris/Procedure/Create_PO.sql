CREATE PROCEDURE [dbo].[Create_PO]
	@Store_ID int, 
	@Supplier_ID int, 
	@Invoice nvarchar(50),	
	@Buyer_Name nvarchar(50),
	@PO_ID NVARCHAR(9) output
AS
BEGIN
Declare @Buyer_ID int;
Declare @Ct int;
 
	SET NOCOUNT ON;
	if @Invoice = 'Ordering' begin
		Select @Ct = Count(*) From POS Where Supplier_ID = @Supplier_ID And State = 'Ordering';
		if @Ct < 2 Begin
			Select @Buyer_ID = ID from Employees where [First Name] = @Buyer_Name and [Last Name] = 'Ordering';
			EXEC Get_Next_POID @Store_ID, @PO_ID out;
			insert into POs (PO_ID, Store_ID, Supplier_ID, Buyer_ID, Invoice, POComplete, State, PODraftDate, Ordering_Date, Ordered_By) values (@PO_ID, @Store_ID, @Supplier_ID, @Buyer_ID, @PO_ID, 0, 'Ordering', GETDATE(), GETDATE(), @Buyer_Name);
		end
	end
	else begin
		Select @Buyer_ID = ID from Employees where [First Name] = @Buyer_Name and [Last Name] = 'Receiving';
		EXEC Get_Next_POID @Store_ID, @PO_ID out;
		insert into POs (PO_ID, Store_ID, Supplier_ID, Buyer_ID, Invoice, POComplete, State, PODraftDate, Ordering_Date, Ordered_By) values (@PO_ID, @Store_ID, @Supplier_ID, @Buyer_ID, @Invoice, 0, 'Receiving', GETDATE(), GETDATE(), @Buyer_Name);
	end
	
	IF @@error <> 0 begin
		set @PO_ID = ''
	end
END


