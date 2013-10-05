-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[Delete_Product_Label]
	@Prod_Num varchar(15)
AS
BEGIN
Declare @Ct int;

	SET NOCOUNT ON;
	Select @Ct = Count(*) From Label_Products Where Prod_Num = @Prod_Num;

	If @Ct > 0 Begin
		Delete From Label_Products Where Prod_Num = @Prod_Num;
	End
END
