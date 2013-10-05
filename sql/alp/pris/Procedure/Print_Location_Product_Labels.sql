-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Print_Location_Product_Labels]
	@Location_ID varchar(32)
AS
BEGIN
Declare @Ct int;
	SET NOCOUNT ON;
	If OBJECT_ID('t_LocationProducts') is not null
	Begin
		Drop Table t_LocationProducts;
	End

	Execute('Select Barcode Into t_LocationProducts From Products_Pris Where Location_Code = ''' + @Location_ID + '''');

	Execute Print_Product_Labels 't_LocationProducts', 'Barcode'
	
END
