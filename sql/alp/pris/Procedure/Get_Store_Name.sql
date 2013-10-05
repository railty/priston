CREATE PROCEDURE [dbo].[Get_Store_Name]
	-- Add the parameters for the stored procedure here
	@Store_ID int,
	@Store_Name nvarchar(50) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @Store_Name = StoreName from Stores where Store_ID = @Store_ID
END



