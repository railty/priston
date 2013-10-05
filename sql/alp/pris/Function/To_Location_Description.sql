
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[To_Location_Description] 
(
	@Location_Code nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	DECLARE @Description nvarchar(50)

	set @Location_Code = UPPER(@Location_Code)
	declare @l1 nvarchar(1)
	declare @l2 nvarchar(1)
	
	set @l1 = SubString(@Location_Code, 1, 1)
	set @l2 = SubString(@Location_Code, 2, 1)
	
	if (@l1<'A' OR @l1>'Z' OR @l2<'A' OR @l2>'Z')
	begin
		SET @Description = ''
		RETURN @Description
	end

	declare @StorageType nvarchar(10)
	declare @Aisle nvarchar(10)
	declare @Aisle_Section nvarchar(10)
	declare @Shelf nvarchar(10)
	declare @Elevation nvarchar(10)

	set @StorageType = SubString(@Location_Code, 1, 2)
	set @Aisle = SubString(@Location_Code, 4, 3)
	set @Aisle_Section = SubString(@Location_Code, 7, 1)
	set @Shelf = SubString(@Location_Code, 8, 2)
	set @Elevation  = SubString(@Location_Code, 11, 1)

	select @StorageType = case @StorageType
		when 'SF' then N'货架'
		when 'SP' then N'堆头'
		when 'WH' then N'货仓'
		when 'FR' then N'冰箱'
		when 'EC' then N'架端'
		when 'FS' then N'冰架'
		when 'TS' then N'架顶'
		when 'BP' then N'饮料堆'
		when 'RP' then N'米堆'
		when 'PP' then N'季节堆'
		when 'CK' then N'收银架'
		
		else @StorageType
	end

	select @Aisle = case @Aisle
		when 'M01' then N'肉部1区'
		when 'M02' then N'肉部2区'
		when 'S01' then N'海鲜1区'
		when 'S02' then N'海鲜2区'
		when 'DRY' then N'牛奶'
		when 'PRO' then N'果菜'
		when 'BKS' then N'散装'
		when 'CHK' then N'收银'
		when 'RFD' then N'冷架'
		when 'XIT' then N'出口'
		when 'HWR' then N'五金'
		when 'FZS' then N'冰架'
		when 'DGD' then N'干货'		
		when 'CSC' then N'客服'		
		when 'GRC' then N'杂货'		
		when 'BAK' then N'面包'		
		
		else @Aisle
	end


	select @Shelf = case @Shelf
		when 'FR' then N'前段'
		when 'BK' then N'后段'
		
		else @Shelf
	end

	select @Elevation = case @Elevation
		when 'A' then N'一楼'
		when 'B' then N'二楼'
		
		else @Elevation
	end

	set @Description = @StorageType + '-' + @Aisle + '-' + @Aisle_Section + '-' + @Shelf + '-' + @Elevation

	RETURN @Description
END

