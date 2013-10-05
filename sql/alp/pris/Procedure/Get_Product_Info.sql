-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Product_Info]
	@Barcode nvarchar(15)
AS
BEGIN
	SET NOCOUNT ON;
	
	Delete From Product_Info;
	
	Insert Into Product_Info(
	Barcode, 
	Name, 
	Name2, 
	[Current #],
	Department,
	[SPEC],
	Rank, 
	Location,
	Prod_Desc,
	RegPrice, 
	[OnSale$],
	OnSales, 
	QtySale, 
	[QtySale#], 
	[QtySale$], 
	Tax,
	Ordered,
	[Lst Rcv $],
	[Lst Rcv #],
	[Lst Rcv UPP],
	[Lwst Rcv $],
	[LSale Date],
	[LSale Day],
	[LInv Date])
	Select 
	Prod_Num, 
	Prod_Name, 
	Prod_Alias, 
	0,
	Department,
	PackageSpec,
	Products_Pris.Rank, 
	Location_Code,
	Prod_Desc,
	RegPrice, 
	OnSalePrice,
	OnSales, 
	QtySale, 
	QtySaleQty, 
	QtySalePrice, 
	'   ',
	0,
	0,
	1,
	0,	
	0,
	'2012-01-01',
	0,
	'2012-01-01'
	from Products Join ProductPrice On Products.Prod_Num = ProductPrice.ProdNum 
	Left Join Products_Pris On Products.Prod_Num = Products_Pris.Barcode 
	Where Products.Prod_Num = @Barcode;

	if @@ROWCOUNT=1
		Begin 
			Declare @T1 Smallint;
			Declare @T2 Smallint;
			Declare @T varchar(4);
			Set @T = 'TAX';
			Select @T1 = Tax1App, @T2 = Tax2App From Products Where Prod_Num=@Barcode;

			If @T1 = 1 Set @T = 'HST'
			If @T2 = 1 Set @T = 'GST'

			Update Product_Info Set Tax = @T;
			
			Declare @Ordered Float;
			Select @Ordered = Sum(UnitsOrdered) From POs 
			Join PO_Details On POS.PO_ID = PO_Details.PO_ID Where State = 'Ordered' And Product_ID = @Barcode;

			If @Ordered Is Not Null Update Product_Info Set Ordered = @Ordered;
			
			DECLARE	@PO_ID nvarchar(12),
					@Date datetime,
					@Quantity float,
					@Price float,
					@UnitsPerPackage int

			EXEC	Get_Last_Receiving_Price
					@Supplier_ID = 0,
					@Product_ID = @Barcode,
					@PO_ID = @PO_ID OUTPUT,
					@Date = @Date OUTPUT,
					@Quantity = @Quantity OUTPUT,
					@Price = @Price OUTPUT,
					@UnitsPerPackage = @UnitsPerPackage OUTPUT
			
			If @Price Is Not Null Update Product_Info Set [Lst Rcv $] = @Price;
			If @Quantity Is Not Null Update Product_Info Set [Lst Rcv #] = @Quantity;
			If @UnitsPerPackage Is Not Null Update Product_Info Set [Lst Rcv UPP] = @UnitsPerPackage;

			EXEC Get_Lowest_Receiving_Price
				@Product_ID = @Barcode,
				@PO_ID = @PO_ID OUTPUT,
				@Date = @Date OUTPUT,
				@Quantity = @Quantity OUTPUT,
				@Price = @Price OUTPUT
				
			If @Price Is Not Null Update Product_Info Set [Lwst Rcv $] = @Price;
			
			DECLARE	@return_value int,
			@LSD date

			EXEC @return_value = [dbo].[Get_Last_Sale_Date] @Product_ID = @Barcode, @LSD = @LSD OUTPUT;
			--Select Top 1 @LSD = POS_Sales_Today.Date From POS_Sales_Today Where Product_ID = @Barcode Order By Date Desc
			If @LSD Is Not Null Update Product_Info Set [LSale Date] = @LSD;
			If @LSD Is Not Null Update Product_Info Set [LSale Day] = @return_value ;
			
			DECLARE	@Last_Inventory float,
			@Last_Insp_Date date,
			@Sold float,
			@Loss float,
			@Receiving float

			EXEC @return_value = [dbo].[Calculate_Current_Quantity]
			@Product_ID = @Barcode,
			@Last_Inventory = @Last_Inventory OUTPUT,
			@Last_Insp_Date = @Last_Insp_Date OUTPUT,
			@Sold = @Sold OUTPUT,
			@Loss = @Loss OUTPUT,
			@Receiving = @Receiving OUTPUT
			
--			EXEC @return_value = [dbo].[Get_Current_Quantity] @Product_ID = @Barcode;
			If @return_value Is Not Null Update Product_Info Set [Current #] = @return_value;

			DECLARE	@LID date;
			EXEC Get_Last_Inventory_Date @Product_ID = @Barcode, @LID = @LID OUTPUT;
			If @LID Is Not Null Update Product_Info Set [LInv Date] = @LID;

			Update Product_Info Set [Last Wk Sale] = (Select Sold_Units2 From inventory_staging Where Product_ID = @Barcode);

			Select 
			Name, 
			Name2, 
			[Current #],
			[Last Wk Sale],
			[LSale Day],
			[Lst Rcv UPP],
			Rank, 
			Location,
			Department,
			Barcode, 
			[SPEC],
			Prod_Desc,
			RegPrice, 
			[OnSale$],
			OnSales, 
			QtySale, 
			[QtySale#], 
			[QtySale$], 
			Tax,
			Ordered,
			[Lst Rcv $],
			[Lst Rcv #],
			[Lwst Rcv $],
			[LSale Date],
			[LInv Date]
			From Product_Info;
		end
	else
		Begin
			Select @Barcode As Barcode, 'New Product' As Name;
		end

END

