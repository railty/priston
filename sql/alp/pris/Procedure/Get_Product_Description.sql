-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Product_Description]
	-- Add the parameters for the stored procedure here
	@Barcode nvarchar(50),
	@strProduct nvarchar(250) OUTPUT
AS
BEGIN
DECLARE @Prod_Name nVARCHAR(50);
DECLARE @Prod_Alias nVARCHAR(40);
DECLARE @PackageSpec nVARCHAR(20);
DECLARE @Prod_Desc nVARCHAR(80);
DECLARE @Measure nVARCHAR(50);
DECLARE @Department nVARCHAR(20);

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT @Prod_Name = Prod_Name, @Prod_Alias = Prod_Alias, @PackageSpec = PackageSpec, @Prod_Desc = Prod_Desc, @Measure = Measure, @Department = Department from Products where Barcode = @Barcode;
	SET @Prod_Name = dbo.trim(@Prod_Name)
	--TRIM does not work with Chinese
	--SET @Prod_Alias = dbo.trim(@Prod_Alias)
	SET @PackageSpec = dbo.trim(@PackageSpec)
	SET @Prod_Desc = dbo.trim(@Prod_Desc)
	SET @Measure = dbo.trim(@Measure)
	SET @Department = dbo.trim(@Department)
	
	set @strProduct = ''
	if @Prod_Name != '' set @strProduct = @strProduct + @Prod_Name + ','
	if @Prod_Alias != '' set @strProduct = @strProduct + @Prod_Alias + ','
	if @PackageSpec != '' set @strProduct = @strProduct + @PackageSpec + ','
	if @Prod_Desc != '' set @strProduct = @strProduct + @Prod_Desc + ','
	if @Measure != '' set @strProduct = @strProduct + @Measure + ','
	if @Department != '' set @strProduct = @strProduct + @Department
	
	
	
	
	
END

