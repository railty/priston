-- =============================================
-- Author:		<Shawn Ning>
-- Create date: <March 3, 2011>
-- Description:	Calculate Inventory
-- =============================================
CREATE PROCEDURE [dbo].[Calculate_Inventory]
AS
BEGIN
	SET NOCOUNT ON;

	Print 'Starting calculating at ' + Convert(Varchar(20), GetDate())

	Drop Table Temp1;
	Select Product_ID, Max(InspectedDate) LastInspectedDate, 0 As Inspected_Units, 0 As Sold_Units, 0 As Loss_Units, 0 As Receiving_Units
	Into Temp1
	From Storage A
	Join Products On Product_ID = Prod_Num 
	Where Product_ID Is Not Null And LocationOnly = 0
	Group By Product_ID;

	Update Temp1 Set Inspected_Units = S.Total
	From (Select Storage.Product_ID, COALESCE(Sum(Units),0) AS Total From Storage Join Temp1 On Storage.Product_ID = Temp1.Product_ID
	Where LocationOnly = 0 And Datediff(Day, Storage.InspectedDate, Temp1.LastInspectedDate) = 0
	Group By Storage.Product_ID) S
	Where Temp1.Product_ID = S.Product_ID;

/*
	Update Temp1 Set Sold_Units = S.Total
	From (Select Invoice_Item.Barcode As Product_ID, COALESCE(Sum(Ship_Quantity),0) AS Total 
	From Invoice_Item Join Temp1 On Invoice_Item.Barcode = Temp1.Product_ID
	Where Invoice_Item.[Date_Sent] > Temp1.LastInspectedDate
	Group By Invoice_Item.Barcode) S
	Where Temp1.Product_ID = S.Product_ID;
*/

	Update Temp1 Set Sold_Units = S.Total
	From (Select POS_Sales.Product_ID As Product_ID, COALESCE(Sum(Quantity),0) AS Total 
	From POS_Sales Join Temp1 On POS_Sales.Product_ID = Temp1.Product_ID
	Where POS_Sales.Date > Temp1.LastInspectedDate
	Group By POS_Sales.Product_ID) S
	Where Temp1.Product_ID = S.Product_ID;

	Update Temp1 Set Loss_Units = S.Total
	From (Select Inventory_Actions.Product_ID, COALESCE(Sum(Quantity),0) As Total From Inventory_Actions Join Temp1 On Inventory_Actions.Product_ID = Temp1.Product_ID
	Where Inventory_Actions.Completed = 1 And  Inventory_Actions.Complete_Time > Temp1.LastInspectedDate And Quantity < 100000
	Group By Inventory_Actions.Product_ID) S
	Where Temp1.Product_ID = S.Product_ID;

	Update Temp1 Set Receiving_Units = S.Total
	From (Select PO_Details.Product_ID, COALESCE(Sum(UnitsReceived),0) As Total From PO_Details Join Temp1 On PO_Details.Product_ID = Temp1.Product_ID
	Where PO_Details.ReceivingDate > Temp1.LastInspectedDate
	Group By PO_Details.Product_ID) S
	Where Temp1.Product_ID = S.Product_ID;

	Disable Trigger Products_Pris_ModTime On Products_Pris;
	Update Products_Pris Set InStock = T.Inspected_Units - Sold_Units - Loss_Units + Receiving_Units, InStockDate = GETDATE()
	From Products_Pris As P Inner Join Temp1 As T On P.Barcode = T.Product_ID;
	
	Update Products_Pris Set Last_Sale_Date = S.Date
	From (Select Top 1 POS_Sales.Product_ID, POS_Sales.Date 
	From POS_Sales Join Products_Pris On POS_Sales.Product_ID = Products_Pris.Barcode Order By Date Desc) S
	Where Products_Pris.Barcode = S.Product_ID;

	Select Top 1 POS_Sales.Product_ID, POS_Sales.Date 
	From POS_Sales Where Product_ID = '1244' Order By Date Desc

	Update Products_Pris Set Last_Inventory_Date = GetDate() Where InStock>0;
	
	Enable Trigger Products_Pris_ModTime On Products_Pris;

	Print 'Finish calculating at ' + Convert(Varchar(20), GetDate())
END
