IF NOT EXISTS (
    SELECT * FROM Test.sys.tables
    WHERE name = 'PATCH-Id'
)
BEGIN
    CREATE TABLE Test.dbo.[PATCH-Id] (id BIGINT)
END

DECLARE @actions TABLE (id BIGINT)

insert into @actions
select id from dbo.sptest

WHILE EXISTS (SELECT * FROM @actions)
BEGIN
    DECLARE @action BIGINT = (SELECT TOP 1 id FROM @actions)
    BEGIN TRANSACTION
        DECLARE @key BIGINT
        EXEC [dbo].[JJ] @id = 1, @newKey = @key OUTPUT;
		select @key
        UPDATE dbo.sptest
        SET [value] = 'applied' WHERE dbo.sptest.primaryKey = @key

	COMMIT

	INSERT INTO Test.dbo.[PATCH-Id]
	SELECT @action

	DELETE @actions WHERE id = @action

END