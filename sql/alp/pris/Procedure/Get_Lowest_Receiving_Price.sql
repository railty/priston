
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Get the last receiving price
-- =============================================
CREATE PROCEDURE [dbo].[Get_Lowest_Receiving_Price] 
	@Product_ID nvarchar(15),
	@PO_ID nvarchar(12) out, @Date DateTime out, @Quantity float out, @Price float out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT Top 1 @PO_ID = POs.PO_ID, @Price = PriceReceived, @Date = ReceivingDate, @Quantity = UnitsReceived
	FROM [dbo].[POs]
	Join [dbo].[PO_Details]
	On POs.PO_ID = PO_Details.PO_ID
	Where PriceReceived Is Not Null And Product_ID = @Product_ID And DATEDIFF(day, ReceivingDate, GetDATE())<365
	Order By PriceReceived;
END

