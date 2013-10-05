CREATE PROCEDURE [dbo].[Get_Store_ID]
	@Store_Name nvarchar(50),
	@Store_ID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @Store_ID = Store_ID from Stores where StoreName = @Store_Name
END



