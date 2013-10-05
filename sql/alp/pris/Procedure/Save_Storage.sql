-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Save_Storage] 
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
declare @location_only bit;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @Quantity >= 0
		set @location_only = 0;
	else
		begin
			set @location_only = 1;
			Set @Quantity = 0;
		end

	set @dt = GETDATE();
	set @y = year(@dt);
	set @m = month(@dt);
	set @d = day(@dt);
	
	IF EXISTS (SELECT * FROM Storage WHERE Location = @Location and Product_ID = @Product and YEAR(InspectedDate) = @y and Month(InspectedDate) = @m and day(InspectedDate) = @d)
		begin
			update Storage set Units=@Quantity, InspectedBy=@User, InspectedDate=@dt, Active=1, LocationOnly = @location_only WHERE Location = @Location and Product_ID = @Product and YEAR(InspectedDate) = @y and Month(InspectedDate) = @m and day(InspectedDate) = @d;
		end
	else
		begin
			Insert into Storage(Store_ID, Product_ID, Location, Units, InspectedBy, InspectedDate, LocationOnly) values(@Store, @Product, @Location, @Quantity, @User, @dt, @location_only);
		end
		
		-- it was "if Left(@Location, 1)= 'B' "
	if (Left(@Location, 1)<> 'S' ) or (Left(@Location, 1)<> 'E' )
		Update Products_pris set Location_Code = @Location Where Barcode = @Product;
		
	if Left(@Location, 1)= 'E' 
		Update Products_pris set Location_Code = @Location Where Barcode = @Product And Location_Code Not Like 'B%';
		
END
