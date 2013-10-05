-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Print_PO_Labels]
	@PO_ID varchar(32)
AS
BEGIN
Declare @Ct int;
	SET NOCOUNT ON;
	If OBJECT_ID('t_POList') is not null
	Begin
		Drop Table t_POList;
	End

	Execute('Select Product_ID Into t_POList From Po_Details Where PO_ID = ' + @PO_ID);
	Execute Print_Product_Labels 't_POList', 'Product_ID'
	
END
