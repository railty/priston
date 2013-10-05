-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Get_Store_List](@StoreList nvarchar(255) OUTPUT)
AS
BEGIN
	Declare @StoreName nvarchar(20)
	SET NOCOUNT ON;

	Set @StoreList = ''
	Declare iStore Cursor For Select StoreName From Stores;
	Open iStore
	Fetch Next From iStore into @StoreName

	While @@Fetch_Status = 0
	BEGIN
		Print @StoreName
		Set @StoreList = @StoreList + @StoreName + CHAR(2)
		Fetch Next From iStore into @StoreName
	END

	Close iStore
	DeAllocate iStore
	
	Set @StoreList = Left(@StoreList, Len(@StoreList) - 1)
	Set @StoreList = @StoreList + CHAR(1) + @StoreList
END
