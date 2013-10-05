-- =============================================
-- Author:		<Shawn Ning>
-- Create date: <March 3, 2011>
-- Description:	Calculate Inventory
-- =============================================
CREATE PROCEDURE [dbo].[Calculate_Inventory_Staging]
	@nDay Int = 0
AS
BEGIN
	Declare @D1 As Date;
	SET NOCOUNT ON;

	Print 'Starting creating staging table at ' + Convert(Varchar(20), GetDate())

	Set @D1 = Dateadd(Day, @nDay, GetDate());
	
	Drop Table Inventory_Staging;
	
	Select Prod_Num As Product_ID, COALESCE(Max(InspectedDate), '2011-01-01') As LastInspectedDate, 0E0 As Inspected_Units, 
	0E0 As Sold_Units, 0E0 As Sold_Amount, 0E0 As Sold_Tax, 0E0 As Loss_Units, 0E0 As Receiving_Units, 
	GetDate() AS D2, 0E0 As D2_Inventory, Dateadd(Day, @nDay, GetDate()) AS D1, 
	0E0 As Sold_Units2, 0E0 As Sold_Amount2, 0E0 As Sold_Tax2, 0E0 As Loss_Units2, 0E0 As Receiving_Units2, 0E0 AS D1_Inventory
	Into Inventory_Staging
	From Storage A
	Right Join Products On Product_ID = Prod_Num 
	Group By Prod_Num;

	Update Inventory_Staging Set Inspected_Units = S.Total
	From (Select Storage.Product_ID, COALESCE(Sum(Units),0) AS Total From Storage Join Inventory_Staging On Storage.Product_ID = Inventory_Staging.Product_ID
	Where Datediff(Day, Storage.InspectedDate, Inventory_Staging.LastInspectedDate) = 0
	Group By Storage.Product_ID) S
	Where Inventory_Staging.Product_ID = S.Product_ID;

	Update Inventory_Staging Set Sold_Units = S.Quantity, Sold_Amount = S.Amount, Sold_Tax = S.Tax
	From (Select POS_Sales.Product_ID As Product_ID, COALESCE(Sum(Quantity),0) AS Quantity, COALESCE(Sum(Amount),0) AS Amount, COALESCE(Sum(Tax),0) AS Tax
	From POS_Sales Join Inventory_Staging On POS_Sales.Product_ID = Inventory_Staging.Product_ID
	Where POS_Sales.Date > Inventory_Staging.LastInspectedDate
	Group By POS_Sales.Product_ID) S
	Where Inventory_Staging.Product_ID = S.Product_ID;

	Update Inventory_Staging Set Sold_Units2 = S.Quantity, Sold_Amount2 = S.Amount, Sold_Tax2 = S.Tax
	From (Select POS_Sales.Product_ID As Product_ID, COALESCE(Sum(Quantity),0) AS Quantity, COALESCE(Sum(Amount),0) AS Amount, COALESCE(Sum(Tax),0) AS Tax
	From POS_Sales Join Inventory_Staging On POS_Sales.Product_ID = Inventory_Staging.Product_ID
	Where  POS_Sales.Date > Dateadd(Day, @nDay, GetDate())
	Group By POS_Sales.Product_ID) S
	Where Inventory_Staging.Product_ID = S.Product_ID;

	Update Inventory_Staging Set Loss_Units = S.Total
	From (Select Inventory_Actions.Product_ID, COALESCE(Sum(Quantity),0) As Total From Inventory_Actions Join Inventory_Staging On Inventory_Actions.Product_ID = Inventory_Staging.Product_ID
	Where Inventory_Actions.Completed = 1 And  Inventory_Actions.Complete_Time > Inventory_Staging.LastInspectedDate
	Group By Inventory_Actions.Product_ID) S
	Where Inventory_Staging.Product_ID = S.Product_ID;

	Update Inventory_Staging Set Loss_Units2 = S.Total
	From (Select Inventory_Actions.Product_ID, COALESCE(Sum(Quantity),0) As Total From Inventory_Actions Join Inventory_Staging On Inventory_Actions.Product_ID = Inventory_Staging.Product_ID
	Where Inventory_Actions.Completed = 1
	And Inventory_Actions.Complete_Time > Dateadd(Day, @nDay, GetDate())
	Group By Inventory_Actions.Product_ID) S
	Where Inventory_Staging.Product_ID = S.Product_ID;

	Update Inventory_Staging Set Receiving_Units = S.Total
	From (Select PO_Details.Product_ID, COALESCE(Sum(UnitsReceived),0) As Total From PO_Details Join Inventory_Staging On PO_Details.Product_ID = Inventory_Staging.Product_ID
	Where PO_Details.ReceivingDate > Inventory_Staging.LastInspectedDate
	Group By PO_Details.Product_ID) S
	Where Inventory_Staging.Product_ID = S.Product_ID;

	Update Inventory_Staging Set Receiving_Units2 = S.Total
	From (Select PO_Details.Product_ID, COALESCE(Sum(UnitsReceived),0) As Total From PO_Details Join Inventory_Staging On PO_Details.Product_ID = Inventory_Staging.Product_ID
	Where PO_Details.ReceivingDate > Dateadd(Day, @nDay, GetDate())
	Group By PO_Details.Product_ID) S
	Where Inventory_Staging.Product_ID = S.Product_ID;

	Update Inventory_Staging Set D2_Inventory = Inspected_Units + Receiving_Units - Loss_Units - Sold_Units;
	Update Inventory_Staging Set D1_Inventory = D2_Inventory - Receiving_Units2 + Loss_Units2 + Sold_Units2;
	Print 'Finish creating staging table at ' + Convert(Varchar(20), GetDate())
END
