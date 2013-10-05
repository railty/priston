-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Next_POID]
	-- Add the parameters for the stored procedure here
	@Store_ID int,
	@POID_STR NVARCHAR(9) output
AS
BEGIN
DECLARE @POID int;
DECLARE @STORE_STR NVARCHAR(2);
DECLARE @YEAR_STR NVARCHAR(2);
DECLARE @ID_STR NVARCHAR(5);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @POID = NextPOID from Stores where Store_ID = @Store_ID;
	update Stores set NextPOID = @POID + 1 where Store_ID = @Store_ID;
	
	SET @STORE_STR = CONVERT(NVARCHAR(2), @STORE_ID);
	SET @STORE_STR = REPLICATE('0', 2-LEN(@STORE_STR)) + @STORE_STR;
	
	SET @YEAR_STR = RIGHT(DATEPART(year, GETDATE()), 2);
	
	SET @ID_STR = CONVERT(NVARCHAR(5), @POID);
	SET @ID_STR = REPLICATE('0', 5-LEN(@ID_STR)) + @ID_STR;
	
	SET @POID_STR = @STORE_STR + @YEAR_STR + @ID_STR;
END
