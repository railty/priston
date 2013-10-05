Create FUNCTION [dbo].[TimeStamp]()
RETURNS VARCHAR(MAX)
BEGIN
RETURN Replace(Replace(Replace(Convert(Varchar, GetDate(), 120), '-', ''), ':', ''), ' ', '')
END

