
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Delete_Product] 
	@Barcode nvarchar(15), 
	@Rc int output
AS
BEGIN

DECLARE	@Prod_Num nvarchar(15);

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC Normalize_Barcode @Barcode = @Barcode, @Normalized_Barcode = @Prod_Num OUTPUT;

	Delete From Products Where Prod_Num = @Prod_Num;
	Delete From ProductPrice Where ProdNum = @Prod_Num;
	Delete From Products_Pris Where Barcode = @Prod_Num;
	SET @Rc = 0;
END

