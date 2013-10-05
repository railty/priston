-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Calculate_Current_Quantity] 
	@Product_ID nvarchar(15), 
	@Last_Inventory Float out,
	@Last_Insp_Date Date out,
	@Sold Float out,
	@Loss Float out,
	@Receiving Float out
AS
BEGIN
DECLARE @Quantity Float;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
	Set @Last_Insp_Date = (Select Top 1 InspectedDate From Storage Where LocationOnly = 0 And Product_ID = @Product_ID Order By InspectedDate Desc);
    --Print @Last_Insp_Date;
    Select @Last_Inventory = COALESCE(Sum(Units),0) From Storage Where LocationOnly = 0 And  Product_ID = @Product_ID And Datediff(Day, InspectedDate, @Last_Insp_Date) = 0;
    
    --Date_Send does not have time information, so this might be a problem
    --Select @Sold = COALESCE(Sum(Ship_Quantity),0) From Invoice_Item Where Prod_Num = @Product_ID And Date_Sent > @Last_Insp_Date;
    --print @Sold
    Select @Sold = COALESCE(Sum(Quantity),0) From POS_Sales Where Product_ID = @Product_ID And [Date] > @Last_Insp_Date;
    --print @Sold
    
    --Use Complete Time
    Select @Loss = COALESCE(Sum(Quantity),0) From Inventory_Actions Where Product_ID = @Product_ID And Completed = 1 And Complete_Time > @Last_Insp_Date;

    --Use Complete Time
    Select @Receiving = COALESCE(Sum(UnitsReceived),0) From PO_Details Where Product_ID = @Product_ID And ReceivingDate > @Last_Insp_Date;
    
    --Print @Quantity
    --Print @Sold
    --Print @Loss
    Set @Quantity = @Last_Inventory + @Receiving - @Sold - @Loss;
	return @Quantity;
END
