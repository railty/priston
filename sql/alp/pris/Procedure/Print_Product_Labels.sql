-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Print_Product_Labels]
	@Table varchar(32), @Field varchar(32)
AS
BEGIN
Declare @Ct int;
	SET NOCOUNT ON;
	If OBJECT_ID('t_ProdList') is not null
	Begin
		Drop Table t_ProdList;
	End

	Execute('Select ' + @Field + ' As Product_ID Into t_ProdList From ' + @Table);

	If OBJECT_ID('t_Temp1') is not null
	Begin
		Drop Table t_Temp1;
	End

	Select * Into t_Temp1 FROM Label_Products;
	
	DELETE Label_Products FROM Label_Products L
	JOIN t_ProdList P ON L.Prod_Num = P.Product_ID Collate SQL_Latin1_General_CP1_CI_AS;
	
	Insert Into Label_Products(Prod_Num, Name, Second_Name, Department, Spec, Measure, Origin, Reg_Price, OnSale_Price, OnSale_Start, OnSale_End, Misc_1, Misc_2, MaxBuyQty, MaxOnSaleQty) 
	Select Prod_Num, Prod_Name, Prod_Alias, Department, PackageSpec, Measure, Prod_Desc, 
	'$'+Convert(Varchar, Convert(Decimal(10,2), RegPrice)), '$'+Convert(Varchar, Convert(Decimal(10,2), OnsalePrice)),
	CONVERT(CHAR(10), GetDate(), 111), CONVERT(CHAR(10), DATEADD(DAY, 7, GetDate()), 111),
	'$'+Convert(Varchar, Convert(Decimal(10,2), RegPrice/0.453592)),
	'$'+Convert(Varchar, Convert(Decimal(10,2), OnsalePrice/0.453592)),	
	MaxBuyQty, MaxOnSaleQty
	From Products Join ProductPrice On Products.Prod_Num = ProductPrice.ProdNum
	Join t_ProdList P on Prod_Num = P.Product_ID Collate SQL_Latin1_General_CP1_CI_AS;

	Update Label_Products Set 
	Second_Name = p.Second_Name
	From Label_Products L Join Products_Pris P On L.Prod_Num = P.Barcode
	Where L.Prod_Num In (Select Product_ID Collate SQL_Latin1_General_CP1_CI_AS From t_ProdList) And P.Second_Name Is Not Null;

	Update Label_Products Set 
	Location_Code = p.Location_Code 
	From Label_Products L Join Products_Pris P On L.Prod_Num = P.Barcode
	Where L.Prod_Num In (Select Product_ID Collate SQL_Latin1_General_CP1_CI_AS From t_ProdList);

	Update Label_Products Set 
	Location_Code2 = p.Location_Code2 
	From Label_Products L Join Products_Pris P On L.Prod_Num = P.Barcode
	Where L.Prod_Num In (Select Product_ID Collate SQL_Latin1_General_CP1_CI_AS From t_ProdList);

	Update Label_Products Set 
	Quantity_Sale_Quantity = p.QtySaleQty, Quantity_Sale_Price = '$'+Convert(Varchar, Convert(Decimal(10,2), QtySalePrice)) 
	From Label_Products L Join Products P On L.Prod_Num = P.Barcode
	Where L.Prod_Num In (Select Product_ID Collate SQL_Latin1_General_CP1_CI_AS From t_ProdList) And p.QtySale = 1;

	Update Label_Products Set Tax = 'HST' From Label_Products L Join Products P On L.Prod_Num = P.Barcode 
	Where L.Prod_Num In (Select Product_ID Collate SQL_Latin1_General_CP1_CI_AS From t_ProdList) And P.Tax1App = 1;
	
	Update Label_Products Set Tax = 'GST' From Label_Products L Join Products P On L.Prod_Num = P.Barcode 
	Where L.Prod_Num In (Select Product_ID Collate SQL_Latin1_General_CP1_CI_AS From t_ProdList) And P.Tax2App = 1;

	Update Label_Products Set Location_Code = T.Location_Code From Label_Products L Join t_Temp1 T On L.Prod_Num = T.Prod_Num;
	
END
