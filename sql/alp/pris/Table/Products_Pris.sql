COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
Barcode		NO	nvarchar	20	40					
Category		YES	nvarchar	64	128					
General_Category		YES	nvarchar	64	128					
InStock		YES	float			53	2			
InStockDate		YES	datetime						3	
Last_Inventory_Date		YES	date						0	
Last_Sale_Date		YES	date						0	
Location_Code		YES	nvarchar	32	64					
Location_Code2		YES	nvarchar	32	64					
ModTime	(getdate())	YES	datetime						3	
Rank		YES	nvarchar	2	4					
Rank1		YES	nvarchar	2	4					
Rank2		YES	nvarchar	2	4					
Rec_Date		YES	nvarchar	255	510					
Rec_Rank		YES	nvarchar	2	4					
Second_Name		YES	nvarchar	255	510					
Source		YES	nvarchar	15	30					
Source_ID		YES	nvarchar	15	30					
Sub_Category		YES	nvarchar	64	128					
User		YES	nvarchar	255	510					
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
PK_Products_Pris	PRIMARY KEY	
