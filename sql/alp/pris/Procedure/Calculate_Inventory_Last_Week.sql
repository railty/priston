-- =============================================
-- Author:		<Shawn Ning>
-- Create date: <March 3, 2011>
-- Description:	Calculate Inventory
-- =============================================
CREATE PROCEDURE [dbo].[Calculate_Inventory_Last_Week]
	@Date_Str Varchar(10) = Null
AS
BEGIN
	SET NOCOUNT ON;

	Declare @Dt As DateTime
	Declare @Last_Monday As DateTime
	Declare @This_Monday As DateTime

	If @Date_Str is Null 
		Begin
			Set @Dt = GetDate()
		End
	Else
		Begin
			Set @Dt = CONVERT(DateTime, @Date_Str, 111)	
		End

	Set @This_Monday = @Dt - DATEDIFF(day, 0, @Dt) %7
	Set @This_Monday = DateAdd(dd, datediff(dd, 0, @This_Monday)+0, 0)
	Print @This_Monday
	Set @Last_Monday = DATEDIFF(day, 7, @This_Monday)
	Print @Last_Monday
	
	Print 'Starting creating staging table at ' + Convert(Varchar(20), GetDate())
	
	Exec Calculate_Inventory_Range @Last_Monday, @This_Monday;
	Drop Table Inventory_Last_Week;
	Select * Into Inventory_Last_Week From Temp_Summary
	Where [Sold_Units]<>0 Or [Sold_Amount] <> 0 Or [Sold_Tax] <> 0 Or [Loss_Units] <>0 Or [Receiving_Units] <> 0;
	Print 'Finish creating staging table at ' + Convert(Varchar(20), GetDate())
END
