COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
Action		NO	nvarchar	2	4					
Action_Time	(getdate())	NO	datetime						3	
BATCH_ID		YES	nvarchar	10	20					
Complete_Time		YES	datetime						3	
Complete_User		YES	nvarchar	50	100					
Completed		NO	bit							
ID		NO	int			10	10	0		
PO_ID		YES	nvarchar	50	100					
Price		YES	float			53	2			
Product_ID		NO	nvarchar	15	30					
Quantity		NO	float			53	2			
Signature		YES	varbinary	-1	-1					
Supplier_ID		NO	int			10	10	0		
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
PK_Inventory_Actions	PRIMARY KEY	
