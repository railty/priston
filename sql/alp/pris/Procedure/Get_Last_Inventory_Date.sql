-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Get_Last_Inventory_Date] 
	@Product_ID nvarchar(15),
	@LID Date output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

    Select @LID = Last_Inventory_Date From Products_Pris Where Barcode = @Product_ID;
    
	return DateDiff(Day, @LID, GetDate());
END
