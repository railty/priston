Create FUNCTION [dbo].[TimeStamp_To_String](@Tm Datetime)
RETURNS VARCHAR(14)
BEGIN
RETURN Replace(Replace(Replace(Convert(Varchar, @Tm, 120), '-', ''), ':', ''), ' ', '')
END

