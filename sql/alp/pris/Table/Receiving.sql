COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
BestBeforeDate		YES	datetime						3	
LocationCode		YES	nvarchar	50	100					
Notes		YES	nvarchar	-1	-1					
PO_ID		NO	nvarchar	255	510					
Product_ID		NO	nvarchar	15	30					
ReceivedBy		YES	nvarchar	50	100					
Receiving_ID		NO	int			10	10	0		
ReceivingDate		NO	datetime						3	
SPEC_Package		YES	nvarchar	50	100					
SPEC_Size		YES	nvarchar	50	100					
SPEC_Weight		YES	nvarchar	50	100					
UnitReceivingPrice		YES	money			19	10	4		
UnitReceivingStatus		NO	bit							
UnitsAvailable		YES	real			24	2			
UnitsInShelf		YES	real			24	2			
UnitsInStock		YES	real			24	2			
UnitsInStorage		YES	int			10	10	0		
UnitsLost		YES	int			10	10	0		
UnitsOnPO		YES	int			10	10	0		
UnitsReceived	((0))	NO	int			10	10	0		
UnitsReceivedMatchFlag	((0))	NO	bit							
UnitsReturned		YES	real			24	2			
UnitsShrinked		YES	real			24	2			
UnitsSold		YES	int			10	10	0		
UnitsTechnicalLost		YES	int			10	10	0		
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
FK_Receiving_PO_Details	FOREIGN KEY	
PK_Receiving	PRIMARY KEY	
