-- =============================================
-- Author:		<Shawn Ning>
-- Create date: <March 3, 2011>
-- Description:	Calculate Inventory
-- =============================================
CREATE PROCEDURE [dbo].[Calculate_Inventory_Last_Month]
	@Date_Str Varchar(10) = Null
AS
BEGIN
	SET NOCOUNT ON;

	Declare @Dt As DateTime
	Declare @First_Day_of_Last_Month As DateTime
	Declare @First_Day_of_This_Month As DateTime

	If @Date_Str is Null 
		Begin
			Set @Dt = GetDate()
		End
	Else
		Begin
			Set @Dt = CONVERT(DateTime, @Date_Str, 111)	
		End


	SET @First_Day_of_This_Month = Dateadd(d,1-DATEPART(d,@Dt),@Dt)

	SET @First_Day_of_Last_Month = DATEADD(m,-1, @First_Day_of_This_Month)

	Exec Calculate_Inventory_Range @First_Day_of_Last_Month, @First_Day_of_This_Month
	Drop Table Inventory_Last_Month;
	Select * Into Inventory_Last_Month From Temp_Summary;
	Print 'Finish creating staging table at ' + Convert(Varchar(20), GetDate())

END
