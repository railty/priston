-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Last_Sale_Date] 
	@Product_ID nvarchar(15),
	@LSD Date output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

    --Select @LSD = Last_Sale_Date From Products_Pris Where Barcode = @Product_ID;
    			
    Select Top 1 @LSD = POS_Sales_Today.Date From POS_Sales_Today Where Product_ID = @Product_ID Order By Date Desc
    			
	return DateDiff(Day, @LSD, GetDate());
END
