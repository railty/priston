-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Supplier_Name]
	-- Add the parameters for the stored procedure here
	@Supplier_ID int,
	@Supplier_Name nvarchar(50) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @Supplier_Name = CompanyName from Suppliers where Supplier_ID = @Supplier_ID
END


