
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Get the last receiving price
-- =============================================
CREATE PROCEDURE [dbo].[Get_Last_Receiving_Price] 
	@Supplier_ID int, @Product_ID nvarchar(15),
	@PO_ID nvarchar(12) out, @Date DateTime out, @Quantity float out, @Price float out, @UnitsPerPackage int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	If @Supplier_ID = 0
	Begin
		SELECT Top 1 @PO_ID = POs.PO_ID, @Price = PriceReceived, @Date = ReceivingDate, @Quantity = UnitsReceived, @UnitsPerPackage = COALESCE(UnitsPerPackage, 1)
		FROM [dbo].[POs]
		Join [dbo].[PO_Details]
		On POs.PO_ID = PO_Details.PO_ID
		Where 
		Product_ID = @Product_ID 
		order by ReceivingDate Desc;

		if @UnitsPerPackage is null or @UnitsPerPackage = 0 begin
			Select @UnitsPerPackage = 1
		end
	else
		SELECT Top 1 @PO_ID = POs.PO_ID, @Price = PriceReceived, @Date = ReceivingDate, @Quantity = UnitsReceived, @UnitsPerPackage = COALESCE(UnitsPerPackage, 1)
		FROM [dbo].[POs]
		Join [dbo].[PO_Details]
		On POs.PO_ID = PO_Details.PO_ID
		Where 
		Product_ID = @Product_ID 
		And Supplier_ID = @Supplier_ID
		order by ReceivingDate Desc;

		if @UnitsPerPackage is null or @UnitsPerPackage = 0 begin
			Select @UnitsPerPackage = 1
		end
	end	
END

