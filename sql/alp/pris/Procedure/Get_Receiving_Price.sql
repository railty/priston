-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Receiving_Price] 
	@Supplier_ID int, @Product_ID nvarchar(15),
	@PO_ID nvarchar(12) out, @Price float out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @Supplier_ID = 0 
	Begin
		SELECT Top 1 @PO_ID = POs.PO_ID, @Price = PriceReceived
		FROM [dbo].[POs]
		Join [dbo].[PO_Details]
		On POs.PO_ID = PO_Details.PO_ID
		Where 
		DateDiff(day, ReceivingDate, GETDATE())<360 And 
		Product_ID = @Product_ID 
		Order by PriceReceived Desc ;
	end
	else
	begin
		SELECT Top 1 @PO_ID = POs.PO_ID, @Price = PriceReceived
		FROM [dbo].[POs]
		Join [dbo].[PO_Details]
		On POs.PO_ID = PO_Details.PO_ID
		Where 
		DateDiff(day, ReceivingDate, GETDATE())<360 And 
		Product_ID = @Product_ID And
		Supplier_ID = @Supplier_ID
		Order by PriceReceived Desc ;
	end
END
