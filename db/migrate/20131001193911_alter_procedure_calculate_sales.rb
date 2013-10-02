$sql = <<EOF
ALTER PROCEDURE [dbo].[Calculate_Sales]
AS
BEGIN
	SET NOCOUNT ON;

	Print 'Starting calculating at ' + Convert(Varchar(20), GetDate())

	Delete From POS_Sales;
	Print 'POS Sales Summary:'
	Insert into POS_Sales(Product_ID, Quantity, Amount, Tax, [Date])
	Select Prod_Num, Sum(Ship_Quantity), Sum(Ship_Quantity*Unit_Price+Tax1+Tax2), Sum(Tax1+Tax2), Date_Sent From Invoice_Item
	Group by Prod_Num, Date_Sent;

	Print 'Finish calculating at ' + Convert(Varchar(20), GetDate())
END

EOF
class AlterProcedureCalculateSales < ActiveRecord::Migration
  def up
	execute $sql
  end

  def down
  end
end
