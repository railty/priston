COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
Barcode		YES	varchar	15	15					
Cost2	((0))	YES	money			19	10	4		
Cust_Num	('N/A')	YES	varchar	20	20					
Date_Sent		YES	varchar	10	10					
DiscountRate	((0))	YES	real			24	2			
DocType	((0))	YES	int			10	10	0		
Extended_Price	((0))	NO	money			19	10	4		
Invoice_Num		NO	varchar	15	15					
ItemNumber	((1))	NO	int			10	10	0		
Member_Type	((0))	YES	int			10	10	0		
OnSale	((0))	YES	int			10	10	0		
OrderQty	((0))	YES	float			53	2			
Prod_Num		NO	varchar	15	15					
RegularPrice	((0))	YES	money			19	10	4		
Remark	('')	YES	varchar	100	100					
Ship_Quantity	((0))	NO	float			53	2			
SNControl	((0))	YES	int			10	10	0		
SuggRetailPrice	((0))	YES	float			53	2			
Tax1	((0))	YES	money			19	10	4		
Tax2	((0))	YES	money			19	10	4		
TX		YES	varchar	5	5					
Unit_Cost	((0))	YES	money			19	10	4		
Unit_Price	((0))	NO	money			19	10	4		
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
PK_Invoice_Item	PRIMARY KEY	
