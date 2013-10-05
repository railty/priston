-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Save_Storage2] 
	@Store as int,
	@Product nvarchar(50), 
	@Location nvarchar(50),
	@Quantity float,
	@User nvarchar(50)
AS
BEGIN
declare @dt datetime;
declare @y int;
declare @m int;
declare @d int;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	set @dt = GETDATE();
	set @y = year(@dt);
	set @m = month(@dt);
	set @d = day(@dt);
	
	IF EXISTS (SELECT * FROM Storage WHERE Location = @Location and Product_ID = @Product and YEAR(InspectedDate) = @y and Month(InspectedDate) = @m and day(InspectedDate) = @d)
		begin
			update Storage set Units=@Quantity, InspectedBy=@User, InspectedDate=@dt, Active=1 WHERE Location = @Location and Product_ID = @Product and YEAR(InspectedDate) = @y and Month(InspectedDate) = @m and day(InspectedDate) = @d;
		end
	else
		begin
			Insert into Storage(Store_ID, Product_ID, Location, Units, InspectedBy, InspectedDate) values(@Store, @Product, @Location, @Quantity, @User, @dt);
		end
		
	Update Products_pris set Location_Code2 = @Location Where Barcode = @Product;
END
