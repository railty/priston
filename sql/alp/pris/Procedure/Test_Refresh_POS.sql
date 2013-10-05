-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Test_Refresh_POS]
AS
BEGIN
Declare @Product_ID Varchar(15);
Declare @Ct Int;
Declare @Ct1 Int;
Declare @Ct2 Int;

	SET NOCOUNT ON;

	Print 'Clean up'
	Delete From PM.MBPOSDB.DBO.Product Where Prod_Num Like 'A123456789%';
	Delete From PM.MBPOSDB.DBO.ProductPrice Where ProdNum Like 'A123456789%';
	
	Delete From Products Where Prod_Num Like 'A123456789%';
	Delete From ProductPrice Where ProdNum Like 'A123456789%';
	Delete From Products_Pris Where Barcode Like 'A123456789%';
	Delete From Storage Where Product_ID Like 'A123456789%';
	Delete From label_Products Where Prod_Num Like 'A123456789%';
	
	Print 'Add 3 Products'
	Set @Product_ID = 'A1234567890'
    Insert into PM.MBPOSDB.DBO.Product(Prod_Num, Prod_Name, Prod_Alias, Prod_Desc, PackageSpec, Department, Unit_Cost, Last_Ord_Date, On_Order, Ord_Point, isFood, Barcode, ModTimeStamp) 
    Values(@Product_ID, 'aaaa', 'xxxx', 'aaaa-xxxx', 'EA', 'Groceries 雜貨', 0, '2000-01-01', 0, 0, 1, @Product_ID, Dbo.TimeStamp());
	Insert Into PM.MBPOSDB.DBO.ProductPrice (ProdNum, Grade, RegPrice, OnsalePrice, ModTimeStamp) Values (@Product_ID, 'RETAIL', 1.23, 4.56, Dbo.TimeStamp());

	Set @Product_ID = 'A1234567891'
    Insert into PM.MBPOSDB.DBO.Product(Prod_Num, Prod_Name, Prod_Alias, Prod_Desc, PackageSpec, Department, Unit_Cost, Last_Ord_Date, On_Order, Ord_Point, isFood, Barcode, ModTimeStamp) 
    Values(@Product_ID, 'aaaa', 'xxxx', 'aaaa-xxxx', 'EA', 'Groceries 雜貨', 0, '2000-01-01', 0, 0, 1, @Product_ID, Dbo.TimeStamp());
	Insert Into PM.MBPOSDB.DBO.ProductPrice (ProdNum, Grade, RegPrice, OnsalePrice, ModTimeStamp) Values (@Product_ID, 'RETAIL', 1.23, 4.56, Dbo.TimeStamp());

	WAITFOR DELAY '00:00:01'
	Set @Product_ID = 'A1234567892'
    Insert into PM.MBPOSDB.DBO.Product(Prod_Num, Prod_Name, Prod_Alias, Prod_Desc, PackageSpec, Department, Unit_Cost, Last_Ord_Date, On_Order, Ord_Point, isFood, Barcode, ModTimeStamp) 
    Values(@Product_ID, 'aaaa', 'xxxx', 'aaaa-xxxx', 'EA', 'Groceries 雜貨', 0, '2000-01-01', 0, 0, 1, @Product_ID, Dbo.TimeStamp());
	Insert Into PM.MBPOSDB.DBO.ProductPrice (ProdNum, Grade, RegPrice, OnsalePrice, ModTimeStamp) Values (@Product_ID, 'RETAIL', 1.23, 4.56, Dbo.TimeStamp());

	--should have 3 products 
	Select @Ct = Count(*) From PM.MBPOSDB.DBO.Product Where Prod_Num Like 'A123456789%';
	If @Ct <> 3 
	Begin
		Print 'cannot insert test data into POS Product'	
		Return
	End
	Select @Ct = Count(*) From PM.MBPOSDB.DBO.ProductPrice Where ProdNum Like 'A123456789%'
	If @Ct <> 3 
	Begin
		Print 'cannot insert test data into POS ProductPrice'	
		Return
	End
	
	Print 'Refresh 1 product'
	EXEC Refresh_POS @Product_ID = 'A1234567890'

	
	Select @Ct = Count(*) From Products Where Prod_Num Like 'A123456789%';
	If @Ct <> 1 
	Begin
		Print 'Should have 1 in products, now have ' +  CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From ProductPrice Where ProdNum Like 'A123456789%';
	If @Ct <> 1 
	Begin
		Print 'Should have 1 in productPrice, now have ' + CAST(@CT As varchar)
		Return
	End

	Select @Ct = Count(*) From Products_Pris Where Barcode Like 'A123456789%';
	If @Ct <> 1 
	Begin
		Print 'Should have 1 in products_Pris, now have ' + CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From Storage Where Product_ID Like 'A123456789%';
	If @Ct <> 1 
	Begin
		Print 'Should have 1 in storage, now have ' + CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From Label_Products Where Prod_Num Like 'A123456789%';
	If @Ct <> 1
	Begin
		Print 'Should have 1 in Label_Products, now have ' + CAST(@CT As varchar)
		Return
	End

	Print 'Refresh 3 products'
	EXEC Refresh_POS

	Select @Ct = Count(*) From Products Where Prod_Num Like 'A123456789%';
	If @Ct <> 3 
	Begin
		Print 'Should have 3 in products, now have ' +  CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From ProductPrice Where ProdNum Like 'A123456789%';
	If @Ct <> 3 
	Begin
		Print 'Should have 3 in productPrice, now have ' + CAST(@CT As varchar)
		Return
	End

	Select @Ct = Count(*) From Products_Pris Where Barcode Like 'A123456789%';
	If @Ct <> 3 
	Begin
		Print 'Should have 1 in products_Pris, now have ' + CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From Storage Where Product_ID Like 'A123456789%';
	If @Ct <> 3 
	Begin
		Print 'Should have 3 in storage, now have ' + CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From Label_Products Where Prod_Num Like 'A123456789%';
	If @Ct <> 3
	Begin
		Print 'Should have 3 in Label_Products, now have ' + CAST(@CT As varchar)
		Return
	End

	Print 'Modify 3 Products'
	Set @Product_ID = 'A1234567890'
    Update PM.MBPOSDB.DBO.Product Set Prod_Name = @Product_ID, ModTimeStamp = Dbo.TimeStamp() Where Prod_Num = @Product_ID; 
	Update PM.MBPOSDB.DBO.ProductPrice Set RegPrice = 999.99, ModTimeStamp = Dbo.TimeStamp() Where ProdNum = @Product_ID; 

	Set @Product_ID = 'A1234567891'
    Update PM.MBPOSDB.DBO.Product Set Prod_Name = @Product_ID, ModTimeStamp = Dbo.TimeStamp() Where Prod_Num = @Product_ID; 
	Update PM.MBPOSDB.DBO.ProductPrice Set RegPrice = 999.99, ModTimeStamp = Dbo.TimeStamp() Where ProdNum = @Product_ID; 

	WAITFOR DELAY '00:00:01'
	Set @Product_ID = 'A1234567892'
    Update PM.MBPOSDB.DBO.Product Set Prod_Name = @Product_ID, ModTimeStamp = Dbo.TimeStamp() Where Prod_Num = @Product_ID; 
	Update PM.MBPOSDB.DBO.ProductPrice Set RegPrice = 999.99, ModTimeStamp = Dbo.TimeStamp() Where ProdNum = @Product_ID; 


	Print 'Refresh 1 product'
	EXEC Refresh_POS @Product_ID = 'A1234567890'

	Select @Ct = Count(*) From Products Where Prod_Name Like 'A123456789%';
	If @Ct <> 1 
	Begin
		Print 'Should have 1 in products, now have ' +  CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From ProductPrice Where RegPrice = 999.99;
	If @Ct <> 1 
	Begin
		Print 'Should have 1 in productPrice, now have ' + CAST(@CT As varchar)
		Return
	End

	Select @Ct = Count(*) From Label_Products Where Reg_Price = '$999.99';
	If @Ct <> 1
	Begin
		Print 'Should have 1 in Label_Products, now have ' + CAST(@CT As varchar)
		Return
	End

	Print 'Refresh 3 products'
	EXEC Refresh_POS

	Select @Ct = Count(*) From Products Where Prod_Name Like 'A123456789%';
	If @Ct <> 3 
	Begin
		Print 'Should have 3 in products, now have ' +  CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From ProductPrice Where RegPrice = 999.99;
	If @Ct <> 3 
	Begin
		Print 'Should have 3 in productPrice, now have ' + CAST(@CT As varchar)
		Return
	End

	Select @Ct = Count(*) From Label_Products Where Reg_Price = '$999.99';
	If @Ct <> 3
	Begin
		Print 'Should have 3 in Label_Products, now have ' + CAST(@CT As varchar)
		Return
	End

	Delete From PM.MBPOSDB.DBO.Product Where Prod_Num = 'A1234567890';
	Delete From PM.MBPOSDB.DBO.ProductPrice Where ProdNum = 'A1234567890';

	EXEC Refresh_POS @Full = 1	
	
	Select @Ct = Count(*) From Products Where Prod_Num Like 'A123456789%';
	If @Ct <> 2 
	Begin
		Print 'Should have 2 in products, now have ' +  CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From ProductPrice Where ProdNum Like 'A123456789%';
	If @Ct <> 2 
	Begin
		Print 'Should have 2 in productPrice, now have ' + CAST(@CT As varchar)
		Return
	End

	Select @Ct = Count(*) From Products_Pris Where Barcode Like 'A123456789%';
	If @Ct <> 2 
	Begin
		Print 'Should have 2 in products_Pris, now have ' + CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From Storage Where Product_ID Like 'A123456789%';
	If @Ct <> 2 
	Begin
		Print 'Should have 2 in storage, now have ' + CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From Label_Products Where Prod_Num Like 'A123456789%';
	If @Ct <> 2
	Begin
		Print 'Should have 2 in Label_Products, now have ' + CAST(@CT As varchar)
		Return
	End
	
	Select @Ct = Count(*) From Products Where Source='POS';

	Select @Ct2 = Count(*) From ProductPrice Where Source='POS';
	If @Ct <> @Ct2
	Begin
		Print 'ProductPrice Count is different with Products'
		Return
	End
	
	Select @Ct2 = Count(*) From Products_Pris Where Source='POS';
	If @Ct <> @Ct2
	Begin
		Print 'Products_Pris Count is different with Products'
		Return
	End
	
	Select @Ct2 = Count(Distinct Product_ID) From Storage;
	If @Ct <> @Ct2
	Begin
		Print 'Storage Products Count is different with Products'
		Return
	End

	Print 'So far so good'
END
