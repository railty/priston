-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Current_Quantity] 
	@Product_ID nvarchar(15) 
AS
BEGIN
DECLARE @Quantity Float;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

    Select @Quantity = InStock From Products_Pris Where Barcode = @Product_ID;
    
	return @Quantity;
END
