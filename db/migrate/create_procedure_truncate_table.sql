Create PROCEDURE [dbo].[Truncate_Table]
	@Table_Name nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	Execute('Delete From ' + @Table_Name);
	RAISERROR ('Truncated Table %s (%d records)', 10, 1, @Table_Name, @@ROWCOUNT) WITH NOWAIT;	
END

