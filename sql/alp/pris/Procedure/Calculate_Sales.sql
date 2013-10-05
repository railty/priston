CREATE PROCEDURE [dbo].[Calculate_Sales]
AS
BEGIN
	SET NOCOUNT ON;

	Print 'Starting calculating at ' + Convert(Varchar(20), GetDate())

	Delete from IItem;
	Delete From POS_Sales;
		
--	Insert Into Pris.Dbo.Invoice_Item ([Invoice_Num],[Prod_Num],[Ship_Quantity],[Unit_Price],[Extended_Price],[OnSale],[Date_Sent],[Unit_Cost],[Barcode],[Cost2],[ItemNumber],[TX],[Tax1],[Tax2],[DocType],[RegularPrice],[DiscountRate],[Member_Type],[Cust_Num],[SuggRetailPrice],[OrderQty],[SNControl],[Remark])
--	SELECT [Invoice_Num],[Prod_Num],[Ship_Quantity],[Unit_Price],[Extended_Price],[OnSale],[Date_Sent],[Unit_Cost],[Barcode],[Cost2],[ItemNumber],[TX],[Tax1],[Tax2],[DocType],[RegularPrice],[DiscountRate],[Member_Type],[Cust_Num],[SuggRetailPrice],[OrderQty],[SNControl],[Remark] FROM PM.MBPOSDB.dbo.Invoice_Item;

	Insert Into IItem ([Prod_Num],[Ship_Quantity],[Unit_Price],[Date_Sent],[Tax1],[Tax2])
	SELECT [Prod_Num],[Ship_Quantity],[Unit_Price],[Date_Sent],[Tax1],[Tax2] FROM PM.MBPOSDB.dbo.Invoice_Item;

	DELETE IItem FROM IItem II INNER JOIN Products P On II.Prod_Num = P.Prod_Num
	Where Department Like '%meat%' Or Department Like 'Veg%' Or Department Like 'Fish%' Or Department Like 'Fru%';
	
	Insert into POS_Sales(Product_ID, Quantity, Amount, Tax, [Date])
	Select Prod_Num, Sum(Ship_Quantity), Sum(Ship_Quantity*Unit_Price+Tax1+Tax2), Sum(Tax1+Tax2), Date_Sent From IItem
	Group by Prod_Num, Date_Sent;

	Delete from Pris.Dbo.IItem;
	Print 'Finish calculating at ' + Convert(Varchar(20), GetDate())
END
