
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Normalize_Barcode] 
	@Barcode nvarchar(15), 
	@Normalized_Barcode nvarchar(15) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--cz+
-- if barcode length=13, trim last digit
--    if len(@Barcode)=13 
--    begin
--      set @Barcode = left(@Barcode, len(@Barcode) - 1);
--    end
 --cz-   
    Set @Barcode = RTRIM(@Barcode)

	if @Barcode = '' 
	Begin
		SET @Normalized_Barcode = '';
		return;
	End

	if PatIndex('%[^0-9]%', @Barcode) <> 0 
	Begin
		SET @Normalized_Barcode = '';
		return;
	End

	SELECT @Normalized_Barcode = Barcode From Products Where Barcode = @Barcode;

	-- trim the last digit (checksum)
	if @Normalized_Barcode is null 
	begin
		SELECT @Normalized_Barcode = Barcode From Products Where Barcode = left(@Barcode, len(@Barcode) - 1);
	end

	-- trim the leading 0	
	Declare @Barcode1 nvarchar(15);
	if @Normalized_Barcode is null 
	begin
		Declare @i int;
		Set @i = patindex('%[^0]%', @Barcode);

		Set @Barcode1 = right(@Barcode, len(@Barcode) - @i + 1)
		SELECT @Normalized_Barcode = Barcode From Products Where Barcode = @Barcode1;
	end

	-- trim the leading 0 and last digit	
	if @Normalized_Barcode is null 
	begin
		SELECT @Normalized_Barcode = Barcode From Products Where Barcode = left(@Barcode1, len(@Barcode1) - 1);
	end
	
	--add a leading 0
	if @Normalized_Barcode is null 
	begin
		SELECT @Normalized_Barcode = Barcode From Products Where Barcode = '0' + @Barcode;
	end
	
	--add a leading 0 and trim the last digit
	if @Normalized_Barcode is null 
	begin
		SELECT @Normalized_Barcode = Barcode From Products Where Barcode = '0' + left(@Barcode, len(@Barcode) - 1);
	end
	
	--trim the last digit and return
	if @Normalized_Barcode is null 
	begin
		SET @Normalized_Barcode = left(@Barcode, len(@Barcode) - 1);
	end

	if @Normalized_Barcode <> @Barcode 
	begin
		Insert into scan_logs(Normalized_Barcode, Barcode) values(@Normalized_Barcode, @Barcode);
	end
END

