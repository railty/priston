
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Create_Product] 
	@Barcode nvarchar(15), 
	@Prod_Name nvarchar(50),
	@Prod_Desc nvarchar(50),
	@PackageSpec nvarchar(20),
	@Department nvarchar(20),
	@Source nvarchar(15), 
	@Source_ID nvarchar(15), 
	@Rc int output
AS
BEGIN

DECLARE	@Prod_Num nvarchar(15);

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--EXEC Normalize_Barcode @Barcode = @Barcode, @Normalized_Barcode = @Prod_Num OUTPUT;
	Select @Prod_Num = @Barcode;
	
	Print @Barcode + '-->' +  @Prod_Num;

	Insert into Products (Prod_Num, Prod_Name, Prod_Alias, Prod_Desc, PackageSpec, Department, Unit_Cost, Last_Ord_Date, On_Order, Ord_Point, isFood, Barcode, Source) Values(@Prod_Num, @Prod_Name, '', @Prod_Desc, @PackageSpec, @Department, 0, '2000-01-01', 0, 0, 1, @Prod_Num, @Source);
	Insert Into ProductPrice (ProdNum, Grade, Source) Values (@Prod_Num, 'RETAIL', @Source)
	Insert into Products_Pris (Barcode, Source, Source_ID) Values(@Prod_Num, @Source, @Source_ID);
	SET @Rc = 0;
END

