COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
Approved_By		YES	nvarchar	255	510					
Approved_Date		YES	datetime						3	
Approved_Signature		YES	varbinary	-1	-1					
Buyer_ID		NO	int			10	10	0		
Delivery Name		YES	nvarchar	40	80					
DeliveryDate		YES	datetime						3	
DeliveryFrequency		YES	nvarchar	50	100					
DeliveryTo		YES	nvarchar	50	100					
FirstDeliveryDate		YES	datetime						3	
Invoice		YES	nvarchar	50	100					
Invoice_Date		YES	date						0	
LastDeliveryDate		YES	datetime						3	
Notes		YES	nvarchar	-1	-1					
Ordered_By		YES	nvarchar	255	510					
Ordered_Date		YES	datetime						3	
Ordered_Signature		YES	varbinary	-1	-1					
Ordering_Date		YES	datetime						3	
Paid Date		YES	datetime						3	
Payment Type		YES	nvarchar	50	100					
PO_ID		NO	nvarchar	255	510					
POApprovedDate		YES	datetime						3	
POApprover		YES	nvarchar	255	510					
POComplete	((0))	NO	bit							
PODraftDate		YES	datetime						3	
PONote		YES	nvarchar	255	510					
POReviewer		YES	nvarchar	255	510					
POStatus_ID		YES	int			10	10	0		
Received_By		YES	nvarchar	255	510					
Received_Date		YES	datetime						3	
Received_Signature		YES	varbinary	-1	-1					
Receiving_Date		YES	datetime						3	
SendToSupplier	((0))	YES	bit							
Signature		YES	varbinary	-1	-1					
State		YES	nvarchar	255	510					
Store_ID		YES	int			10	10	0		
Supplier_ID		NO	int			10	10	0		
SupplierContact		YES	nvarchar	50	100					
Tax Status		YES	nvarchar	50	100					
Taxes		YES	money			19	10	4		
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
FK_POs_Employees	FOREIGN KEY	
FK_POs_PO_Status	FOREIGN KEY	
FK_POs_Stores	FOREIGN KEY	
FK_POs_Suppliers	FOREIGN KEY	
IX_POs	UNIQUE	
PK_POs	PRIMARY KEY	
