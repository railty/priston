-- =============================================
-- Author:		<Shawn Ning>
-- Create date: <March 3, 2011>
-- Description:	Calculate Inventory
-- =============================================
CREATE PROCEDURE [dbo].[Calculate_Inventory_Range]
	@D1 Date, @D2 Date
AS
BEGIN
	SET NOCOUNT ON;

	Print 'Starting creating staging table at ' + Convert(Varchar(20), GetDate())
	
	Drop Table Temp_Summary;
	
	Select Prod_Num As Product_ID, @D1 AS D1, @D2 AS D2, 
	0E0 As Sold_Units, 0E0 As Sold_Amount, 0E0 As Sold_Tax, 0E0 As Loss_Units, 0E0 As Receiving_Units 
	Into Temp_Summary
	From Storage A
	Right Join Products On Product_ID = Prod_Num 
	Group By Prod_Num;

	Update Temp_Summary Set Sold_Units = S.Quantity, Sold_Amount = S.Amount, Sold_Tax = S.Tax
	From (Select POS_Sales.Product_ID As Product_ID, COALESCE(Sum(Quantity),0) AS Quantity, COALESCE(Sum(Amount),0) AS Amount, COALESCE(Sum(Tax),0) AS Tax
	From POS_Sales Join Temp_Summary On POS_Sales.Product_ID = Temp_Summary.Product_ID
	Where POS_Sales.Date >= @D1 And POS_Sales.Date < @D2
	Group By POS_Sales.Product_ID) S
	Where Temp_Summary.Product_ID = S.Product_ID;

	Update Temp_Summary Set Loss_Units = S.Total
	From (Select Inventory_Actions.Product_ID, COALESCE(Sum(Quantity),0) As Total From Inventory_Actions Join Temp_Summary On Inventory_Actions.Product_ID = Temp_Summary.Product_ID
	Where Inventory_Actions.Completed = 1 And  Inventory_Actions.Complete_Time >= @D1 And  Inventory_Actions.Complete_Time < @D2
	Group By Inventory_Actions.Product_ID) S
	Where Temp_Summary.Product_ID = S.Product_ID;

	Update Temp_Summary Set Receiving_Units = S.Total
	From (Select PO_Details.Product_ID, COALESCE(Sum(UnitsReceived),0) As Total From PO_Details Join Temp_Summary On PO_Details.Product_ID = Temp_Summary.Product_ID
	Where PO_Details.ReceivingDate >= @D1 And PO_Details.ReceivingDate < @D2
	Group By PO_Details.Product_ID) S
	Where Temp_Summary.Product_ID = S.Product_ID;

	Print 'Finish creating staging table at ' + Convert(Varchar(20), GetDate())
END
