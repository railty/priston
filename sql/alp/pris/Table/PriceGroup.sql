COLUMN_NAME	COLUMN_DEFAULT	IS_NULLABLE	DATA_TYPE	CHARACTER_MAXIMUM_LENGTH	CHARACTER_OCTET_LENGTH	NUMERIC_PRECISION	NUMERIC_PRECISION_RADIX	NUMERIC_SCALE	DATETIME_PRECISION	
GroupName		NO	nvarchar	20	40					
isQtySale	((0))	YES	smallint			5	10	0		
MaxGroupQty	((0))	YES	smallint			5	10	0		
ModDate		YES	nvarchar	10	20					
ModTimeStamp	('0')	YES	nvarchar	14	28					
OnSale	('')	YES	nvarchar	1	2					
QtySalePrice	((1))	YES	float			53	2			
QtySaleQty	((0))	YES	int			10	10	0		
-------------------------------
CONSTRAINT_NAME	CONSTRAINT_TYPE	
PK_PriceGroup	PRIMARY KEY	
