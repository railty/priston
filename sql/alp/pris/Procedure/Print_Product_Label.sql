-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
/*
Alter Table Products_Pris Add Second_Name nvarchar(255);
Alter Table Products_Pris Add Sub_Category nvarchar(32);
Alter Table Products_Pris Alter Column Location_Code nvarchar(32);

Alter Table Label_Products Alter Column Location_Code nvarchar(32);
Alter Table Label_Products Alter Column Quantity_Sale_Price varchar(6);

Drop View Label_Products;
Drop Table Label_Products;
Select top 100 Prod_Num, Prod_Name As Name, Prod_Alias As Second_Name, Department, PackageSpec As Spec, Measure, Prod_Desc As Origin, 
RegPrice As Reg_Price, OnsalePrice As OnSale_Price, 
CONVERT(CHAR(10), GetDate(), 111) As OnSale_Start,
CONVERT(CHAR(10), DATEADD(DAY, 7, GetDate()), 111) As OnSale_End,
Cast('' As varchar(5)) As Tax, 
Cast('' As varchar(5)) As Quantity_Sale_Quantity, 
Cast('' As varchar(5)) As Quantity_Sale_Price, 
Cast('' As varchar(15)) As Location_Code,
Cast('' As varchar(32)) As Misc_1,
Cast('' As varchar(32)) As Misc_2,
Cast('' As varchar(32)) As Misc_3,
Cast('' As varchar(32)) As Misc_4
Into Label_Products
From Products Join ProductPrice On Products.Prod_Num = ProductPrice.ProdNum;

Alter Table Label_Products Alter Column Reg_Price varchar(8)
Alter Table Label_Products Alter Column Onsale_Price varchar(8)
Alter Table Label_Products Alter Column Quantity_Sale_Price varchar(8)
Delete From Label_Products

*/
-- =============================================
CREATE PROCEDURE [dbo].[Print_Product_Label]
	@Prod_Num varchar(15),
	@Location_Code Varchar(15) = ''
AS
BEGIN

	SET NOCOUNT ON;
	Delete From Label_Products Where Prod_Num = @Prod_Num;

	Insert Into Label_Products(Prod_Num, Name, Second_Name, Department, Spec, Measure, Origin, Reg_Price, OnSale_Price, OnSale_Start, OnSale_End, Misc_1, Misc_2, MaxBuyQty, MaxOnSaleQty) 
	Select Prod_Num, Prod_Name, Prod_Alias, Department, PackageSpec, Measure, Prod_Desc, 
	'$'+Convert(Varchar, Convert(Decimal(10,2), RegPrice)), '$'+Convert(Varchar, Convert(Decimal(10,2), OnsalePrice)),
	CONVERT(CHAR(10), GetDate(), 111), CONVERT(CHAR(10), DATEADD(DAY, 7, GetDate()), 111),
	'$'+Convert(Varchar, Convert(Decimal(10,2), RegPrice/0.453592)),
	'$'+Convert(Varchar, Convert(Decimal(10,2), OnsalePrice/0.453592)),	
	MaxBuyQty, MaxOnSaleQty
	From Products Join ProductPrice On Products.Prod_Num = ProductPrice.ProdNum
	Where Prod_Num = @Prod_Num;
	
	If @@ROWCOUNT = 1
	Begin
		Update Label_Products Set Second_Name = p.Second_Name From Label_Products L Join Products_Pris P On L.Prod_Num = P.Barcode Where L.Prod_Num = @Prod_Num And P.Second_Name Is Not Null;
		Update Label_Products Set Location_Code = p.Location_Code From Label_Products L Join Products_Pris P On L.Prod_Num = P.Barcode Where L.Prod_Num = @Prod_num;
		Update Label_Products Set Location_Code2 = p.Location_Code2 From Label_Products L Join Products_Pris P On L.Prod_Num = P.Barcode Where L.Prod_Num = @Prod_num;
		
		Update Label_Products Set Quantity_Sale_Quantity = p.QtySaleQty, Quantity_Sale_Price = '$'+Convert(Varchar, Convert(Decimal(10,2), QtySalePrice)) From Label_Products L Join Products P On L.Prod_Num = P.Barcode Where L.Prod_Num = @Prod_Num And p.QtySale = 1;

		Update Label_Products Set Tax = 'HST' From Label_Products L Join Products P On L.Prod_Num = P.Barcode Where P.Tax1App = 1 And p.Barcode = @Prod_Num;

		Update Label_Products Set Tax = 'GST' From Label_Products L Join Products P On L.Prod_Num = P.Barcode Where P.Tax2App = 1 And p.Barcode = @Prod_Num;
	End
	if @Location_Code <> ''
		Update Label_Products Set Location_Code = @Location_Code Where Prod_Num = @Prod_num;
		
	Select * From Label_Products Where Prod_Num = @Prod_Num;
	Return @@RowCount;
END
