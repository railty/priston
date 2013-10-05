
CREATE FUNCTION [dbo].[String_To_TimeStamp](@TmStr varchar(14))
RETURNS Datetime
BEGIN
Declare @Str nvarchar(20);
Declare @Tm Datetime;
	Select @Str = SubString(@TmStr, 1, 4) + '-' + SubString(@TmStr, 5, 2) + '-' + SubString(@TmStr, 7, 2) + ' ' + SubString(@TmStr, 9, 2) + ':' + SubString(@TmStr, 11, 2) + ':' + SubString(@TmStr, 13, 2);
	Select @Tm = Convert(Datetime, @Str, 120);
	RETURN @Tm;
END


