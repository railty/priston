COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
Discount		YES	real			24	2			
FreeItems	((0))	NO	int			10	10	0		
Notes		YES	nvarchar	-1	-1					
OrderedBy		YES	nvarchar	255	510					
OrderingDate		YES	datetime						3	
PaidItems	((1))	NO	int			10	10	0		
PO_ID		NO	nvarchar	255	510					
PriceApproved	((0))	NO	bit							
PriceOrdered		YES	float			53	2			
PriceReceived		YES	real			24	2			
Product_ID		NO	nvarchar	15	30					
ReceivedBy		YES	nvarchar	255	510					
ReceivedStatus	((0))	NO	bit							
ReceivingDate		YES	datetime						3	
Reviewed	((0))	NO	bit							
SRPRice		YES	float			53	2			
Status		NO	bit							
Taxable		YES	bit							
TaxRate	((0))	YES	float			53	2			
Transaction_ID		NO	int			10	10	0		
UnitPODraftPrice		YES	money			19	10	4		
UnitsApproved	((0))	NO	bit							
UnitsMissing		YES	float			53	2			
UnitsMissingDate		YES	datetime						3	
UnitsOnPO	((0))	NO	int			10	10	0		
UnitsOrdered		YES	float			53	2			
UnitsPerPackage		YES	int			10	10	0		
UnitsReceived	((0))	NO	int			10	10	0		
UnitsReturned		YES	float			53	2			
UnitsReturnedDate		YES	datetime						3	
UnitsShrinked		YES	float			53	2			
UnitsShrinkedDate		YES	datetime						3	
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
PK_PO_Details_1	PRIMARY KEY	
