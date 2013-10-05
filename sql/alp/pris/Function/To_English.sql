
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================

CREATE FUNCTION [dbo].[To_English]
(
	@Chinese nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	Declare @English nvarchar(50)
	Declare @ch nvarchar(1)
	Declare @i int
	Declare @l int
	
	set @English = ''
	set @l = len(@Chinese)
	set @i = 1
	while @i <= @l 
	begin
		set @ch = Substring(@Chinese, @i, 1)
		
		if unicode(@ch) >= unicode(N'Ａ') and unicode(@ch) <= unicode(N'Ｚ') 
			set @ch = nchar(unicode(@ch) - unicode(N'Ａ') + unicode(N'A'))
		if unicode(@ch) >= unicode(N'ａ') and unicode(@ch) <= unicode(N'ｚ') 
			set @ch = nchar(unicode(@ch) - unicode(N'ａ') + unicode(N'a'))
		if unicode(@ch) >= unicode(N'０') and unicode(@ch) <= unicode(N'９') 
			set @ch = nchar(unicode(@ch) - unicode(N'０') + unicode(N'0'))		
	
		set @English = @English + @ch
		set @i = @i + 1
	end
		
	RETURN @English

END

