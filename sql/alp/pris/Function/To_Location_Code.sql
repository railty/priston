
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[To_Location_Code] 
(
	@Description nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	DECLARE @Code nvarchar(50)
	
	declare @StorageType nvarchar(10)
	declare @Aisle nvarchar(10)
	declare @Aisle_Section nvarchar(10)
	declare @Shelf nvarchar(10)
	declare @Elevation nvarchar(10)

	DECLARE @i1 int
	DECLARE @i2 int
	DECLARE @i3 int
	DECLARE @i4 int
	set @i1 = Charindex('-', @Description, 1)
	set @i2 = Charindex('-', @Description, @i1+1)
	set @i3 = Charindex('-', @Description, @i2+1)
	set @i4 = Charindex('-', @Description, @i3+1)
	if (@i1=0 or @i2=0 or @i3=0 or @i4=0 )
	begin
		SET @Code = ''
		RETURN @Code
	end
	
	set @StorageType = SubString(@Description, 1, @i1-1)
	set @Aisle = SubString(@Description, @i1+1, @i2-@i1-1)
	set @Aisle_Section = SubString(@Description, @i2+1, @i3-@i2-1)
	set @Shelf = SubString(@Description, @i3+1, @i4-@i3-1)
	set @Elevation  = SubString(@Description, @i4+1, 50)
	
	
	select @StorageType = case @StorageType
		when N'货架' then 'SF'
		when N'堆头' then 'SP'
		when N'货仓' then 'WH'
		when N'冰箱' then 'FR'
		when N'架端' then 'EC'
		when N'冰架' then 'FS'
		when N'架顶' then 'TS'
		when N'饮料堆' then 'BP'
		when N'米堆' then 'RP'
		when N'季节堆' then 'PP'
		when N'收银架' then 'CK'
		
		else @StorageType
	end

	select @Aisle = case @Aisle
		when N'肉部1区' then 'M01'
		when N'肉部2区' then 'M02'
		when N'海鲜1区' then 'S01'
		when N'海鲜2区' then 'S02'
		when N'牛奶' then 'DRY'
		when N'果菜' then 'PRO'
		when N'散装' then 'BKS'
		when N'收银' then 'CHK'
		when N'冷架' then 'RFD'
		when N'出口' then 'XIT'
		when N'五金' then 'HWR'
		when N'冰架' then 'FZS'
		when N'干货' then 'DGD'		
		when N'客服' then 'CSC'
		when N'杂货' then 'GRC'
		when N'面包' then 'BAK'
		
		else @Aisle
	end


	select @Shelf = case @Shelf
		when N'前段' then 'FR'
		when N'后段' then 'BK'
		
		else @Shelf
	end

	select @Elevation = case @Elevation
		when N'一楼' then 'A'
		when N'二楼' then 'B'
		
		else @Elevation
	end

	
	
	set @Code = @StorageType + '0' + @Aisle + @Aisle_Section + @Shelf + '0' + @Elevation
	set @Code = dbo.To_English(@Code)
	RETURN @Code
END

