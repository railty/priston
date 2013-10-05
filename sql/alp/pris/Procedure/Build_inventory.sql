-- =============================================
-- Author:		<Shawn Ning>
-- Create date: <March 3, 2011>
-- Description:	<Import Data from another (older) database>
-- =============================================
CREATE PROCEDURE [dbo].[Build_inventory]
AS
BEGIN
	SET NOCOUNT ON;

	Execute Calculate_Inventory

	Execute Calculate_Inventory_Staging @nDay = -31

	Drop Table Inventory_Staging_30;

	Select * Into Inventory_Staging_30 From Inventory_Staging;

	Execute Calculate_Inventory_Staging @nDay = -8

	Execute Pris.Dbo.Calculate_Inventory_Last_Week
	Execute Pris.Dbo.Calculate_Inventory_Last_Month

	Print 'Finished Successfully!'
END
