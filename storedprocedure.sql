SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
	SELECT * FROM sys.objects
	WHERE [name] = 'JJ' AND [type] = 'P'
)
DROP PROCEDURE dbo.[JJ]; 
GO

CREATE PROCEDURE [dbo].[JJ]
	@id BIGINT,
	@newKey BIGINT OUTPUT
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[sptest] WHERE [id] = @id)
	BEGIN
	
		SET NOCOUNT ON;

		DECLARE @schema NVARCHAR(MAX) = 'dbo'
		DECLARE @oldKey BIGINT 
		DECLARE @table NVARCHAR(MAX) = 'sptest'
		DECLARE @tableExternal NVARCHAR(MAX) = 'sptestexternal'
		DECLARE @tableHierarchical NVARCHAR(MAX) = 'sptesthierachical'
		DECLARE @SQL NVARCHAR(MAX)
		DECLARE @SQL2 NVARCHAR(MAX)

		DECLARE @columnList NVARCHAR(MAX) = (
			SELECT STUFF (
				(
					SELECT ',[' + COLUMN_NAME + ']'
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @table AND COLUMN_NAME != 'primaryKey'
					ORDER BY ORDINAL_POSITION
					FOR XML PATH('')
				),1,1,''
			)
		)

		DECLARE @columnListExternal NVARCHAR(MAX) = (
			SELECT STUFF (
				(
					SELECT ',[' + COLUMN_NAME + ']'
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @tableExternal AND COLUMN_NAME != 'key'
					ORDER BY ORDINAL_POSITION
					FOR XML PATH('')
				),1,1,''
			)
		)

		DECLARE @columnListHierarchical NVARCHAR(MAX) = (
			SELECT STUFF (
				(
					SELECT ',[' + COLUMN_NAME + ']'
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @tableHierarchical AND COLUMN_NAME != 'key'
					ORDER BY ORDINAL_POSITION
					FOR XML PATH('')
				),1,1,''
			)
		)

		BEGIN TRANSACTION
			SET @oldKey = (SELECT [primaryKey] FROM dbo.sptest WHERE [latest] = 1 AND [id] = @id)

			SET @SQL = '
			UPDATE [dbo].[sptest] SET [latest] = 0 WHERE [primaryKey] = ' + CAST(@oldKey AS VARCHAR(MAX)) + '
			INSERT INTO [' + @schema + '].[' + @table + '] (' + @columnList + ') SELECT ' + REPLACE(REPLACE(@columnList,'[latest]',1),'[created]','GETDATE()') + 
			' FROM [' + @schema + '].[' + @table + '] WHERE [id] = ' + CAST(@id AS VARCHAR(MAX)) + ' AND [primaryKey] = ' + CAST(@oldKey AS VARCHAR(MAX))

			EXEC sp_executesql @SQL

			SET @newKey = @@IDENTITY

			SET @SQL2 = '
			INSERT INTO [' + @schema + '].[' + @tableExternal + '] (' + @columnListExternal + ') SELECT ' + REPLACE(@columnListExternal, '[owner]', @newKey) + ' FROM [' + @schema + '].[' + @tableExternal + '] WHERE [owner] = ' + CAST(@oldKey AS VARCHAR(MAX)) +'
			INSERT INTO [' + @schema + '].[' + @tableHierarchical + '] (' + @columnListHierarchical + ') SELECT ' + REPLACE(@columnListHierarchical, '[node]', @newKey) + ' FROM [' + @schema + '].[' + @tableHierarchical + '] WHERE [node] = ' + CAST(@oldKey AS VARCHAR(MAX))

			EXEC sp_executesql @SQL2	
		COMMIT

	END
	Select @newKey
END;

GO