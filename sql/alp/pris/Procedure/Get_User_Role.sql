-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Get_User_Role]
	-- Add the parameters for the stored procedure here
	@Badge varchar(32),
	@UserRole nvarchar(50) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @UserRole = Position from Tss_Employees where Barcode = @Badge;
END
