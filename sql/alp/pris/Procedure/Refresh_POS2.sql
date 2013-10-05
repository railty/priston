-- =============================================
-- Author:		<Shawn Ning>
-- Create date: <March 3, 2011>
-- Description:	<Import Data from another (older) database>
--EXEC master.dbo.sp_addlinkedserver @server = N'POS', @provider=N'SQLNCLI', @datasrc=N'PM';
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'POS', @useself=N'False', @locallogin=NULL, @rmtuser=N'sa', @rmtpassword='';
--Alter Table Stores Add Active Varchar(2)
--Update Stores Set Active='Y' Where Store_ID = 39
-- =============================================
CREATE PROCEDURE [dbo].[Refresh_POS2]
@Product_ID Varchar(15) = Null,
@Full Int = 0
AS
BEGIN
Declare @LastProductTS nvarchar(14);
Declare @LastPriceTS nvarchar(14);
Declare @Product_Changed int;
Declare @Product_Added int;
Declare @Price_Changed int;
Declare @Price_Added int;
Declare @tm DateTime;
Declare @ms int;
Declare @Store_ID int;
Declare @Message nvarchar(32);

	SET NOCOUNT ON;
	Print 'Starting refreshing... '

	If @Full = 0
	Begin
		Print 'Dlt update'
		If @Product_ID Is Null Begin
			If Object_ID('Dlt_Product') Is Not Null
			Begin
				Drop Table Dlt_Product;
			End
			
			If Object_ID('Dlt_ProductPrice') Is Not Null
			Begin
				Drop Table Dlt_ProductPrice;
			End

			Select @LastProductTS = MAX(ModTimeStamp) from Products Where ModTimeStamp <> '9999';
			Select @LastPriceTS = MAX(ModTimeStamp) from ProductPrice Where ModTimeStamp <> '9999';

			Select @LastProductTS = dbo.TimeStamp_To_String(DateAdd(Minute, -6, Dbo.String_To_TimeStamp(@LastProductTS)));
			Select @LastPriceTS = dbo.TimeStamp_To_String(DateAdd(Minute, -6, Dbo.String_To_TimeStamp(@LastPriceTS)));

			Set @tm = GetDate();		
			Select * Into Dlt_Product From PM.MBPOSDB.dbo.Product Where ModTimeStamp <> '9999' And ModTimeStamp >= @LastProductTS;
			Select * Into Dlt_ProductPrice From PM.MBPOSDB.dbo.ProductPrice Where ModTimeStamp <> '9999' And ModTimeStamp >= @LastPriceTS;
			Set @ms = DateDiff(millisecond, @tm, GetDate());		
			
			Select @Store_ID = Store_ID From Stores Where Active = 'Y';
			INSERT INTO Storage (Product_ID, InspectedDate, Store_ID, Units, StoragedDate, Active)
			Select Dlt_Product.Prod_Num, GETDATE(), @Store_ID, 0, DATEADD(Day, -30, GETDATE()), 1 From Dlt_Product Left Join Products On Dlt_Product.Prod_Num = Products.Prod_Num Collate Chinese_Taiwan_Stroke_CI_AS
			Where Products.Prod_Num Is Null;

			Insert Into Products_Pris (Barcode, Rank, Source) 
			Select Dlt_Product.Prod_Num, 'N', 'POS' From Dlt_Product Left Join Products On Dlt_Product.Prod_Num = Products.Prod_Num Collate Chinese_Taiwan_Stroke_CI_AS
			Where Products.Prod_Num Is Null;
			
			Print 'Products changed:'
			DELETE Pris.Dbo.Products FROM Pris.Dbo.Products JOIN 
			Pris.dbo.Dlt_Product CHANGED
			ON Pris.Dbo.Products.Prod_Num Collate Chinese_Taiwan_Stroke_CI_AS = CHANGED.PROD_NUM
			Where Source = 'POS';
			Set @Product_Changed = @@ROWCOUNT;

			Print 'Products changed and added:'
			Insert Into Pris.Dbo.Products ([Prod_Num],[Prod_Name],[Prod_Desc],[Service],[Unit_Cost],[Measure],[Warranty],[Tot_Sales],[Tot_Profit],[OnSales],[Barcode],[Prod_Alias],[Serial_Control],
			[Tax1App],[Tax2App],[Tax3App],[ItemBonus],[SalePoint],[ServiceComm],[GM_UCost],[GM_ProdProfit],[QtySold],[LastyearSale],[LastyearProfit],[LastyearQtySold],
			[PackageSpec],[SuggestSalePrice],[PkLevel],[MasterProdNum],[NumPerPack],[PackageSpec2],[PkFraction],[PriceMode],[ConvUnit],[ConvFactor],[QtySale],[QtySaleQty],
			[QtySalePrice],[ModTimeStamp],[ScaleTray],[VolDisc],[VolQty1],[VolPrice1],[VolQty2],[VolPrice2],[Department],[Last_Ord_Date],[On_Order],[Ord_Point],[SuggestOrderQty],
			[Inactive],[EnvDepLink],[ExcludeOnRank],[QtyGroup],[ProportionalTare],[Deduct_Bag_Weight],[Bag_Weight],[MaxBuyQty],[MaxOnSaleQty],[isFood], Source)
			SELECT N.[Prod_Num],N.[Prod_Name],N.[Prod_Desc],N.[Service],N.[Unit_Cost],N.[Measure],N.[Warranty],N.[Tot_Sales],N.[Tot_Profit],N.[OnSales],N.[Barcode],N.[Prod_Alias],N.[Serial_Control],
			N.[Tax1App],N.[Tax2App],N.[Tax3App],N.[ItemBonus],N.[SalePoint],N.[ServiceComm],N.[GM_UCost],N.[GM_ProdProfit],N.[QtySold],N.[LastyearSale],N.[LastyearProfit],N.[LastyearQtySold],
			N.[PackageSpec],N.[SuggestSalePrice],N.[PkLevel],N.[MasterProdNum],N.[NumPerPack],N.[PackageSpec2],N.[PkFraction],N.[PriceMode],N.[ConvUnit],N.[ConvFactor],N.[QtySale],N.[QtySaleQty],
			N.[QtySalePrice],N.[ModTimeStamp],N.[ScaleTray],N.[VolDisc],N.[VolQty1],N.[VolPrice1],N.[VolQty2],N.[VolPrice2],N.[Department],N.[Last_Ord_Date],N.[On_Order],N.[Ord_Point],N.[SuggestOrderQty],
			N.[Inactive],N.[EnvDepLink],N.[ExcludeOnRank],N.[QtyGroup],N.[ProportionalTare],N.[Deduct_Bag_Weight],N.[Bag_Weight],N.[MaxBuyQty],N.[MaxOnSaleQty],N.[isFood], 'POS'
			FROM Pris.dbo.Dlt_Product N Left Join Pris.dbo.Products O
			ON O.Prod_Num Collate Chinese_Taiwan_Stroke_CI_AS = N.PROD_NUM
			Where O.Barcode Is NULL;
			Set @Product_Added = @@ROWCOUNT - @Product_Changed;

			Print 'ProductPrice changed:'
			DELETE Pris.Dbo.ProductPrice FROM Pris.Dbo.ProductPrice P JOIN Pris.dbo.Dlt_ProductPrice M 
			ON P.ProdNum Collate Chinese_Taiwan_Stroke_CI_AS = M.PRODNUM
			Where P.ModTimeStamp Collate Chinese_Taiwan_Stroke_CI_AS <> M.ModTimeStamp And Source = 'POS';;

			Set @Price_Changed = @@ROWCOUNT;

			Print 'ProductPrice changed and added:'
			Insert Into Pris.Dbo.ProductPrice ([ProdNum],[Grade],[RegPrice],[BottomPrice],[OnsalePrice],[ModTimeStamp], Source)
			Select N.[ProdNum],N.[Grade],N.[RegPrice],N.[BottomPrice],N.[OnsalePrice],N.[ModTimeStamp], 'POS' From Pris.dbo.Dlt_ProductPrice N Left Join Pris.Dbo.ProductPrice O
			ON O.ProdNum Collate Chinese_Taiwan_Stroke_CI_AS = N.PRODNUM AND O.GRADE Collate Chinese_Taiwan_Stroke_CI_AS = N.GRADE
			Where O.ProdNum Is Null;
			Set @Price_Added = @@ROWCOUNT - @Price_Changed;

			-- Temporrary remark this one 11/30/2012
			--EXEC Print_Product_Labels @Table = N'Dlt_Product', @Field = N'Prod_Num'

			Select @Product_Added As Product_Added, @Product_Changed As Product_Changed, @Price_Added As Price_Added, @Price_Changed As Price_Changed, @ms As Duration;
		End
		Else
		Begin
			DELETE FROM Pris.Dbo.Products Where Prod_Num =@Product_ID And Source = 'POS';
			If @@ROWCOUNT = 0 
			Begin
				Set @Message = 'New Product'
				Insert Into Products_Pris (Barcode, Rank, Source) Values(@Product_ID, 'N', 'POS');
				
				INSERT INTO Storage (Product_ID, InspectedDate, Store_ID, Units, StoragedDate, Active)
				Select @Product_ID, GETDATE(), Store_ID, 0, DATEADD(day, -30, GETDATE()), 1 From Stores Where Active = 'Y';
			End
			Else
			Begin
				Set @Message = 'Existing Product'
			End
			
			DELETE FROM Pris.Dbo.ProductPrice Where ProdNum = @Product_ID And Source = 'POS';
			
			Set @tm = GetDate();		
			Insert Into Pris.Dbo.Products ([Prod_Num],[Prod_Name],[Prod_Desc],[Service],[Unit_Cost],[Measure],[Warranty],[Tot_Sales],[Tot_Profit],[OnSales],[Barcode],[Prod_Alias],[Serial_Control],
			[Tax1App],[Tax2App],[Tax3App],[ItemBonus],[SalePoint],[ServiceComm],[GM_UCost],[GM_ProdProfit],[QtySold],[LastyearSale],[LastyearProfit],[LastyearQtySold],
			[PackageSpec],[SuggestSalePrice],[PkLevel],[MasterProdNum],[NumPerPack],[PackageSpec2],[PkFraction],[PriceMode],[ConvUnit],[ConvFactor],[QtySale],[QtySaleQty],
			[QtySalePrice],[ModTimeStamp],[ScaleTray],[VolDisc],[VolQty1],[VolPrice1],[VolQty2],[VolPrice2],[Department],[Last_Ord_Date],[On_Order],[Ord_Point],[SuggestOrderQty],
			[Inactive],[EnvDepLink],[ExcludeOnRank],[QtyGroup],[ProportionalTare],[Deduct_Bag_Weight],[Bag_Weight],[MaxBuyQty],[MaxOnSaleQty],[isFood], Source)
			SELECT N.[Prod_Num],N.[Prod_Name],N.[Prod_Desc],N.[Service],N.[Unit_Cost],N.[Measure],N.[Warranty],N.[Tot_Sales],N.[Tot_Profit],N.[OnSales],N.[Barcode],N.[Prod_Alias],N.[Serial_Control],
			N.[Tax1App],N.[Tax2App],N.[Tax3App],N.[ItemBonus],N.[SalePoint],N.[ServiceComm],N.[GM_UCost],N.[GM_ProdProfit],N.[QtySold],N.[LastyearSale],N.[LastyearProfit],N.[LastyearQtySold],
			N.[PackageSpec],N.[SuggestSalePrice],N.[PkLevel],N.[MasterProdNum],N.[NumPerPack],N.[PackageSpec2],N.[PkFraction],N.[PriceMode],N.[ConvUnit],N.[ConvFactor],N.[QtySale],N.[QtySaleQty],
			N.[QtySalePrice],N.[ModTimeStamp],N.[ScaleTray],N.[VolDisc],N.[VolQty1],N.[VolPrice1],N.[VolQty2],N.[VolPrice2],N.[Department],N.[Last_Ord_Date],N.[On_Order],N.[Ord_Point],N.[SuggestOrderQty],
			N.[Inactive],N.[EnvDepLink],N.[ExcludeOnRank],N.[QtyGroup],N.[ProportionalTare],N.[Deduct_Bag_Weight],N.[Bag_Weight],N.[MaxBuyQty],N.[MaxOnSaleQty],N.[isFood], 'POS'
			FROM PM.MBPOSDB.dbo.Product N Where N.Prod_Num = @Product_ID;

			Insert Into Pris.Dbo.ProductPrice ([ProdNum],[Grade],[RegPrice],[BottomPrice],[OnsalePrice],[ModTimeStamp], Source)
			Select N.[ProdNum],N.[Grade],N.[RegPrice],N.[BottomPrice],N.[OnsalePrice],N.[ModTimeStamp], 'POS' From PM.MBPOSDB.Dbo.ProductPrice N
			Where N.ProdNum = @Product_ID;
			
			Set @ms = DateDiff(millisecond, @tm, GetDate());
			Select @Product_ID As Product_ID, @Message As Message, @ms As Duration;

			-- Temporrary remark this one 11/30/2012
			--Exec Print_Product_Label @Prod_Num = @Product_ID;
		End
	End
	Else
	Begin
		Print 'Full update!'
		
		Delete From Storage Where Product_ID In (
		Select PP.Barcode From Pris.Dbo.Products_Pris PP Left Join PM.MBPOSDB.dbo.Product 
		On Product.Prod_Num = PP.Barcode Collate Chinese_Taiwan_Stroke_CI_AS
		Where Source='POS' And Product.Prod_Num is Null);

		Delete From Label_Products Where Prod_Num In (
		Select PP.Barcode From Pris.Dbo.Products_Pris PP Left Join PM.MBPOSDB.dbo.Product 
		On Product.Prod_Num = PP.Barcode Collate Chinese_Taiwan_Stroke_CI_AS
		Where Source='POS' And Product.Prod_Num is Null);

		Delete PP From Pris.Dbo.Products_Pris PP Left Join PM.MBPOSDB.dbo.Product 
		On Product.Prod_Num = PP.Barcode Collate Chinese_Taiwan_Stroke_CI_AS
		Where Source='POS' And Product.Prod_Num is Null;

		If Object_ID('Dlt_ProdNum') Is Not Null
		Begin
			Drop Table Dlt_ProdNum;
		End

		Select Product.Prod_Num Into Dlt_ProdNum 
		From Pris.Dbo.Products_Pris Right Join PM.MBPOSDB.dbo.Product 
		On Product.Prod_Num = Pris.Dbo.Products_Pris.Barcode Collate Chinese_Taiwan_Stroke_CI_AS
		Where Pris.Dbo.Products_Pris.Barcode is Null;

		Delete FROM Pris.Dbo.Products Where Source = 'POS';

		Insert Into Pris.Dbo.Products ([Prod_Num],[Prod_Name],[Prod_Desc],[Service],[Unit_Cost],[Measure],[Warranty],[Tot_Sales],[Tot_Profit],[OnSales],[Barcode],[Prod_Alias],[Serial_Control],
		[Tax1App],[Tax2App],[Tax3App],[ItemBonus],[SalePoint],[ServiceComm],[GM_UCost],[GM_ProdProfit],[QtySold],[LastyearSale],[LastyearProfit],[LastyearQtySold],
		[PackageSpec],[SuggestSalePrice],[PkLevel],[MasterProdNum],[NumPerPack],[PackageSpec2],[PkFraction],[PriceMode],[ConvUnit],[ConvFactor],[QtySale],[QtySaleQty],
		[QtySalePrice],[ModTimeStamp],[ScaleTray],[VolDisc],[VolQty1],[VolPrice1],[VolQty2],[VolPrice2],[Department],[Last_Ord_Date],[On_Order],[Ord_Point],[SuggestOrderQty],
		[Inactive],[EnvDepLink],[ExcludeOnRank],[QtyGroup],[ProportionalTare],[Deduct_Bag_Weight],[Bag_Weight],[MaxBuyQty],[MaxOnSaleQty],[isFood], [Source])
		SELECT [Prod_Num],[Prod_Name],[Prod_Desc],[Service],[Unit_Cost],[Measure],[Warranty],[Tot_Sales],[Tot_Profit],[OnSales],[Barcode],[Prod_Alias],[Serial_Control],
		[Tax1App],[Tax2App],[Tax3App],[ItemBonus],[SalePoint],[ServiceComm],[GM_UCost],[GM_ProdProfit],[QtySold],[LastyearSale],[LastyearProfit],[LastyearQtySold],
		[PackageSpec],[SuggestSalePrice],[PkLevel],[MasterProdNum],[NumPerPack],[PackageSpec2],[PkFraction],[PriceMode],[ConvUnit],[ConvFactor],[QtySale],[QtySaleQty],
		[QtySalePrice],[ModTimeStamp],[ScaleTray],[VolDisc],[VolQty1],[VolPrice1],[VolQty2],[VolPrice2],[Department],[Last_Ord_Date],[On_Order],[Ord_Point],[SuggestOrderQty],
		[Inactive],[EnvDepLink],[ExcludeOnRank],[QtyGroup],[ProportionalTare],[Deduct_Bag_Weight],[Bag_Weight],[MaxBuyQty],[MaxOnSaleQty],[isFood], 'POS' FROM PM.MBPOSDB.dbo.Product;

		Delete FROM Pris.Dbo.ProductPrice Where Source = 'POS';

		Insert Into Pris.Dbo.ProductPrice ([ProdNum],[Grade],[RegPrice],[BottomPrice],[OnsalePrice],[ModTimeStamp], Source)
		SELECT [ProdNum],[Grade],[RegPrice],[BottomPrice],[OnsalePrice],[ModTimeStamp], 'POS' FROM PM.MBPOSDB.dbo.ProductPrice;

		Select @Store_ID = Store_ID From Stores Where Active = 'Y';
		INSERT INTO Storage (Product_ID, InspectedDate, Store_ID, Units, StoragedDate, Active)
		Select Prod_Num, GETDATE(), @Store_ID, 0, DATEADD(Day, -30, GETDATE()), 1 From Storage Right Join Products On Storage.Product_ID = Products.Prod_Num 
		Where Storage.Product_ID Is Null;

		INSERT INTO Pris.Dbo.products_pris (Barcode, Rank, Source) 
		Select Products.Prod_Num, 'N', 'POS' From Products_Pris Right Join Products On Products_Pris.Barcode = Products.Prod_Num
		Where Products_Pris.Barcode Is Null;

		--Delete from Pris.Dbo.Invoice_Item;
		--Insert Into Pris.Dbo.Invoice_Item ([Invoice_Num],[Prod_Num],[Ship_Quantity],[Unit_Price],[Extended_Price],[OnSale],[Date_Sent],[Unit_Cost],[Barcode],[Cost2],[ItemNumber],[TX],[Tax1],[Tax2],[DocType],[RegularPrice],[DiscountRate],[Member_Type],[Cust_Num],[SuggRetailPrice],[OrderQty],[SNControl],[Remark])
		--SELECT [Invoice_Num],[Prod_Num],[Ship_Quantity],[Unit_Price],[Extended_Price],[OnSale],[Date_Sent],[Unit_Cost],[Barcode],[Cost2],[ItemNumber],[TX],[Tax1],[Tax2],[DocType],[RegularPrice],[DiscountRate],[Member_Type],[Cust_Num],[SuggRetailPrice],[OrderQty],[SNControl],[Remark] FROM MBPOSDB.dbo.Invoice_Item;

		--Select @Product_Added As Product_Added, @Product_Changed As Product_Changed, @Price_Added As Price_Added, @Price_Changed As Price_Changed, @ms As Duration;

		--EXEC Print_Product_Labels @Table = N'Dlt_ProdNum', @Field = N'Prod_Num'
		
	End
	Print 'Finished Successfully!'
END
