CREATE PROCEDURE [dbo].[Create_Blank_PO]
	@Table varchar(32), @Supplier_ID_Field varchar(32), @Product_ID_Field varchar(32)
AS
BEGIN

/*
--first create po and po_details with default value
EXEC [dbo].[Create_Blank_PO] @Table = N'E1103',	@Supplier_ID_Field = N'Supplier_ID', @Product_ID_Field = N'NBarcode'
--update tax
UPDATE PO_Details SET TaxRate = 0.13
from PO_Details PD 
INNER JOIN POs PO  ON PD.PO_ID = PO.PO_ID
INNER JOIN E1103 E ON E.Supplier_ID = PO.Supplier_ID And E.NBarcode = PD.Product_ID
Where E.Tax='HST'
--update units and price  
UPDATE PO_Details SET UnitsOrdered = Units, PriceOrdered = Price, UnitsPerPackage = E.UnitsPerPackage
from PO_Details PD 
INNER JOIN POs PO  ON PD.PO_ID = PO.PO_ID
INNER JOIN E1103 E ON E.Supplier_ID = PO.Supplier_ID And E.NBarcode = PD.Product_ID
--list all the po created in last hour
select * from POS where DATEDIFF(HOUR, ordered_date, GETDATE())=0

*/
	If OBJECT_ID('t_Suppliers_Products') is not null
	Begin
		Drop Table t_Suppliers_Products;
	End

	Execute('Select ' + @Supplier_ID_Field + ' As Supplier_ID, ' + @Product_ID_Field + ' As Product_ID Into t_Suppliers_Products From ' + @Table + ';');

	DECLARE SP Cursor FOR Select Distinct Supplier_ID from t_Suppliers_Products;	
	DECLARE @Product_ID varchar(32), @Supplier_ID int, @PO_ID varchar(32)
	
	Open SP
	Fetch NEXT FROM SP INTO @Supplier_ID
	While (@@FETCH_STATUS <> -1)
	BEGIN
	IF (@@FETCH_STATUS <> -2)

		Exec Create_PO 39, @Supplier_ID, 'Ordering', N'qa', @PO_ID Output;

		Insert Into PO_Details (PO_ID, Product_ID, OrderingDate, OrderedBy, UnitsOrdered, PriceOrdered, UnitsPerPackage, Status) 
		Select Distinct @PO_ID, Product_ID , GETDATE(), N'qa', 0, 0, 1, 1 From t_Suppliers_Products Where Supplier_ID = @Supplier_ID

		Update PO_Details Set TaxRate = 0.13 From PO_Details PD Join Products P On P.Prod_Num = PD.Product_ID Where PD.PO_ID = @PO_ID And P.Tax1App = 1;
		Update PO_Details Set TaxRate = 0.05 From PO_Details PD Join Products P On P.Prod_Num = PD.Product_ID Where PD.PO_ID = @PO_ID And P.Tax2App = 1;
		
		Update POs Set Ordered_Date = GetDate(), Ordered_By = N'qa', DeliveryTo = N'qa', DeliveryDate = GetDate(), State = N'Ordered' Where PO_ID = @PO_ID;
		
--		Update POs Set State = 'Receiving' Where PO_ID = @PO_ID;

--		Update PO_Details Set ReceivingDate = GETDATE(), ReceivedBy = N'qa', UnitsReceived = 0, PriceReceived = 0 Where PO_ID = @PO_ID;

--		Update POs Set POComplete = 1, State = N'Received', Invoice = PO_ID, Received_Date = GetDate(), Received_By = N'qa' Where PO_ID = @PO_ID;
		  
		Fetch NEXT FROM SP INTO @Supplier_ID
	END

	CLOSE SP
	DEALLOCATE SP
	
END
