COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
Active	((1))	NO	bit							
InspectedBy		YES	nchar	10	20					
InspectedDate		YES	datetime						3	
Location		YES	nvarchar	50	100					
LocationOnly	((1))	NO	bit							
Notes		YES	nvarchar	-1	-1					
Product_ID		YES	varchar	15	15					
Storage_ID		NO	int			10	10	0		
StoragedBy		YES	nvarchar	50	100					
StoragedDate		YES	datetime						3	
Store_ID		YES	int			10	10	0		
Units		YES	float			53	2			
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
PK_Storage	PRIMARY KEY	
