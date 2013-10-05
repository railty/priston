-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[Get_Next_BATCHID]
	-- Add the parameters for the stored procedure here
	@Store_ID int,
	@BATCHID_STR NVARCHAR(9) output
AS
BEGIN
DECLARE @BATCHID int;
DECLARE @STORE_STR NVARCHAR(2);
DECLARE @YEAR_STR NVARCHAR(2);
DECLARE @ID_STR NVARCHAR(5);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @BATCHID = NextBATCHID from Stores where Store_ID = @Store_ID;
	update Stores set NextBATCHID = @BATCHID + 1 where Store_ID = @Store_ID;
	
	SET @STORE_STR = CONVERT(NVARCHAR(2), @STORE_ID);
	SET @STORE_STR = REPLICATE('0', 2-LEN(@STORE_STR)) + @STORE_STR;
	
	SET @YEAR_STR = RIGHT(DATEPART(year, GETDATE()), 2);
	
	SET @ID_STR = CONVERT(NVARCHAR(5), @BATCHID);
	SET @ID_STR = REPLICATE('0', 5-LEN(@ID_STR)) + @ID_STR;
	
	SET @BATCHID_STR = @STORE_STR + @YEAR_STR + @ID_STR;
END
