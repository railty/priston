CREATE PROCEDURE [dbo].[Import_Data](@SrcDB nvarchar(50))
AS
BEGIN
	SET NOCOUNT ON;

	Print 'Starting import from ' + @SrcDB + '...'
	
	Print 'Truncate all tables...'

	Execute	Truncate_Table N'PO_Details';
	Execute	Truncate_Table N'POs';	
	Execute	Truncate_Table N'Suppliers';
	Execute	Truncate_Table N'Products';
	Execute	Truncate_Table N'ProductPrice';
	Execute	Truncate_Table N'Products_Pris';
	Execute	Truncate_Table N'Invoice_Item';
	Execute	Truncate_Table N'Storage';
	Execute	Truncate_Table N'Employees';
	Execute	Truncate_Table N'Stores';

	Print 'Importing data....'
	
	SET IDENTITY_INSERT Suppliers ON
	Execute('Insert Into Suppliers ([Supplier_ID],[CompanyName],[ContactName],[ContactTitle],[Address],[City],[Region],[PostalCode],[Country],[Phone],[Fax],[HomePage],[DiscountRate],[CellNumber],[GSTNumber],[E_Mail_Address]) SELECT [Supplier_ID],[CompanyName],[ContactName],[ContactTitle],[Address],[City],[Region],[PostalCode],[Country],[Phone],[Fax],[HomePage],[DiscountRate],[CellNumber],[GSTNumber],[E_Mail_Address] FROM [' + @SrcDB + '].[dbo].[Suppliers];');
	RAISERROR ('Imported Suppliers (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;
	SET IDENTITY_INSERT Suppliers OFF
	
	SET IDENTITY_INSERT Pris.Dbo.Storage ON
	Execute('Insert Into Storage ([Storage_ID],[Store_ID],[Product_ID],[StoragedBy],[StoragedDate],[Location],[Units],[Notes],[InspectedBy],[InspectedDate]) SELECT [Storage_ID],[Store_ID],[Product_ID],[StoragedBy],[StoragedDate],[Location],[Units],[Notes],[InspectedBy],[InspectedDate] FROM [' + @SrcDB + '].[dbo].[Storage];');
	RAISERROR ('Imported Storage (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;
	SET IDENTITY_INSERT Pris.Dbo.Storage OFF

	Execute('Insert Into Products ([Prod_Num],[Prod_Name],[Prod_Desc],[Service],[Unit_Cost],[Measure],[Warranty],[Tot_Sales],[Tot_Profit],[OnSales],[Barcode],[Prod_Alias],[Serial_Control],[Tax1App],[Tax2App],[Tax3App],[ItemBonus],[SalePoint],[ServiceComm],[GM_UCost],[GM_ProdProfit],[QtySold],[LastyearSale],[LastyearProfit],[LastyearQtySold],[PackageSpec],[SuggestSalePrice],[PkLevel],[MasterProdNum],[NumPerPack],[PackageSpec2],[PkFraction],[PriceMode],[ConvUnit],[ConvFactor],[QtySale],[QtySaleQty],[QtySalePrice],[ModTimeStamp],[ScaleTray],[VolDisc],[VolQty1],[VolPrice1],[VolQty2],[VolPrice2],[Department],[Last_Ord_Date],[On_Order],[Ord_Point],[SuggestOrderQty],[Inactive],[EnvDepLink],[ExcludeOnRank],[QtyGroup],[ProportionalTare],[Deduct_Bag_Weight],[Bag_Weight],[MaxBuyQty],[MaxOnSaleQty],[isFood]) SELECT [Prod_Num],[Prod_Name],[Prod_Desc],[Service],[Unit_Cost],[Measure],[Warranty],[Tot_Sales],[Tot_Profit],[OnSales],[Barcode],[Prod_Alias],[Serial_Control],[Tax1App],[Tax2App],[Tax3App],[ItemBonus],[SalePoint],[ServiceComm],[GM_UCost],[GM_ProdProfit],[QtySold],[LastyearSale],[LastyearProfit],[LastyearQtySold],[PackageSpec],[SuggestSalePrice],[PkLevel],[MasterProdNum],[NumPerPack],[PackageSpec2],[PkFraction],[PriceMode],[ConvUnit],[ConvFactor],[QtySale],[QtySaleQty],[QtySalePrice],[ModTimeStamp],[ScaleTray],[VolDisc],[VolQty1],[VolPrice1],[VolQty2],[VolPrice2],[Department],[Last_Ord_Date],[On_Order],[Ord_Point],[SuggestOrderQty],[Inactive],[EnvDepLink],[ExcludeOnRank],[QtyGroup],[ProportionalTare],[Deduct_Bag_Weight],[Bag_Weight],[MaxBuyQty],[MaxOnSaleQty],[isFood] FROM [' + @SrcDB + '].[dbo].[Products];');
	RAISERROR ('Imported Products (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;

	Execute('Insert Into ProductPrice ([ProdNum],[Grade],[RegPrice],[BottomPrice],[OnsalePrice],[ModTimeStamp]) SELECT [ProdNum],[Grade],[RegPrice],[BottomPrice],[OnsalePrice],[ModTimeStamp] FROM [' + @SrcDB + '].[dbo].[ProductPrice];');
	RAISERROR ('Imported ProductPrice (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;

	Execute('Insert Into Products_Pris ([Barcode],[Rank],[Last_Rank]) SELECT [Barcode],[Rank],[Last_Rank] FROM [' + @SrcDB + '].[dbo].[Products_Pris];');
	RAISERROR ('Imported Products_Pris (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;

	Execute('Insert Into Invoice_Item ([Invoice_Num],[Prod_Num],[Ship_Quantity],[Unit_Price],[Extended_Price],[OnSale],[Date_Sent],[Unit_Cost],[Barcode],[Cost2],[ItemNumber],[TX],[Tax1],[Tax2],[DocType],[RegularPrice],[DiscountRate],[Member_Type],[Cust_Num],[SuggRetailPrice],[OrderQty],[SNControl],[Remark]) SELECT [Invoice_Num],[Prod_Num],[Ship_Quantity],[Unit_Price],[Extended_Price],[OnSale],[Date_Sent],[Unit_Cost],[Barcode],[Cost2],[ItemNumber],[TX],[Tax1],[Tax2],[DocType],[RegularPrice],[DiscountRate],[Member_Type],[Cust_Num],[SuggRetailPrice],[OrderQty],[SNControl],[Remark] FROM [' + @SrcDB + '].dbo.Invoice_Item;');
	RAISERROR ('Imported Invoice_Item (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;

	SET IDENTITY_INSERT Pris.Dbo.Employees ON
	Execute('Insert Into Employees ([ID],[Store_ID],[Last Name],[First Name],[E-mail Address],[Job Title],[Business Phone],[Home Phone],[Mobile Phone],[Fax Number],[Address],[City],[Province],[Postal Code],[Notes],[Attachments]) SELECT [ID],[Store_ID],[Last Name],[First Name],[E-mail Address],[Job Title],[Business Phone],[Home Phone],[Mobile Phone],[Fax Number],[Address],[City],[Province],[Postal Code],[Notes],[Attachments] FROM [' + @SrcDB + '].[dbo].[Employees];');
	RAISERROR ('Imported Employees (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;
	SET IDENTITY_INSERT Pris.Dbo.Employees OFF

	SET IDENTITY_INSERT Pris.Dbo.Stores ON
	Execute('Insert Into Stores ([Store_ID],[StoreName],[ContactName],[ContactTitle],[Address],[City],[Region],[PostalCode],[Country],[Phone],[Fax],[BusinessNo],[NextPOID],[StoreFullName]) SELECT [Store_ID],[StoreName],[ContactName],[ContactTitle],[Address],[City],[Region],[PostalCode],[Country],[Phone],[Fax],[BusinessNo],[NextPOID],[StoreFullName] FROM [' + @SrcDB + '].[dbo].[Stores];');
	RAISERROR ('Imported Stores (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;
	SET IDENTITY_INSERT Pris.Dbo.Stores OFF

	Execute('Insert Into POs ([PO_ID],[Store_ID],[Buyer_ID],[Supplier_ID],[SupplierContact],[PODraftDate],[PONote],[POStatus_ID],[POComplete],[DeliveryDate],[POReviewer],[POApprover],[POApprovedDate],[DeliveryTo],[FirstDeliveryDate],[LastDeliveryDate],[DeliveryFrequency],[Delivery Name],[Payment Type],[Paid Date],[Taxes],[Tax Status],[Notes],[Invoice],[Signature]) SELECT [PO_ID],[Store_ID],[Buyer_ID],[Supplier_ID],[SupplierContact],[PODraftDate],[PONote],[POStatus_ID],[POComplete],[DeliveryDate],[POReviewer],[POApprover],[POApprovedDate],[DeliveryTo],[FirstDeliveryDate],[LastDeliveryDate],[DeliveryFrequency],[Delivery Name],[Payment Type],[Paid Date],[Taxes],[Tax Status],[Notes],[Invoice],[Signature] FROM [' + @SrcDB + '].[dbo].[POs];');
	RAISERROR ('Imported POs (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;

--	ALTER TABLE PO_Details NOCHECK CONSTRAINT FK_PO_Details_POs;
	SET IDENTITY_INSERT Pris.Dbo.PO_Details ON
	Execute('Insert Into PO_Details ([Transaction_ID],[PO_ID],[Product_ID],[UnitsOnPO],[UnitPODraftPrice],[Discount],[Reviewed],[PriceApproved],[UnitsApproved],[ReceivedStatus],[Status],[Notes],[UnitsReceived],[ReceivingDate],[ReceivedBy],[PriceReceived],[UnitsPerPackage],[Taxable]) SELECT [Transaction_ID],[PO_ID],[Product_ID],[UnitsOnPO],[UnitPODraftPrice],[Discount],[Reviewed],[PriceApproved],[UnitsApproved],[ReceivedStatus],[Status],[Notes],[UnitsReceived],[ReceivingDate],[ReceivedBy],[PriceReceived],[UnitsPerPackage],[Taxable] FROM [' + @SrcDB + '].[dbo].[PO_Details];');
	RAISERROR ('Imported PO_Details (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;
	SET IDENTITY_INSERT Pris.Dbo.PO_Details OFF
--	ALTER TABLE PO_Details CHECK CONSTRAINT FK_PO_Details_POs;

	Update PO_Details Set TaxRate = 0.13 Where TaxAble = 1;
	RAISERROR ('Updated Taxrates (%d records)', 10, 1, @@ROWCOUNT) WITH NOWAIT;
	
	Print 'Finished Successfully!'
END

