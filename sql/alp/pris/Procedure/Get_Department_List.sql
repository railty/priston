-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Department_List]
	-- Add the parameters for the stored procedure here
	@Hint nvarchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	set @Hint = @Hint + '%';
    -- Insert statements for procedure here
	SELECT Top 40 Department_ID, Name from Departments where Name like @Hint Order by Name;
END
