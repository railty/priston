-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
Create FUNCTION [dbo].[Normalized_Barcode](@barcode varchar(20))
RETURNS varchar(20)
AS
BEGIN
Declare @NBarcode varchar(20);

	if PatIndex('%[^0-9]%', @Barcode) <> 0 
	Begin
		SET @NBarcode = '';
	End
	Else
	Begin
		SELECT @NBarcode = Barcode From Products Where Barcode = @Barcode;	
		if @NBarcode is null 
		Begin
			-- try trim the last digit (checksum)
			SELECT @NBarcode = Barcode From Products Where Barcode = Left(@Barcode, Len(@Barcode) - 1);
		End

		-- try trim the leading 0	
		Declare @Barcode1 varchar(20);		
		If @NBarcode is null 
		Begin
			Declare @i int;
			Set @i = patindex('%[^0]%', @Barcode);

			Set @Barcode1 = right(@Barcode, len(@Barcode) - @i + 1)
			SELECT @NBarcode = Barcode From Products Where Barcode = @Barcode1;
		End

		-- try trim the leading 0 and last digit	
		If @NBarcode is null 
		Begin
			SELECT @NBarcode = Barcode From Products Where Barcode = left(@Barcode1, len(@Barcode1) - 1);
		End
		
		--still not found, return barcode as is
		If @NBarcode is null 
		Begin
			SET @NBarcode = @Barcode;
		End
	End
	
	RETURN @NBarcode;

END
