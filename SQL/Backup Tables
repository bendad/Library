-------------------------------------------------------------------------------
-- Backup tables
-- Auto-backup a set of tables to a secondary database or schema
-------------------------------------------------------------------------------

DECLARE @sourceDatabase VARCHAR(250)
DECLARE @sourceSchema VARCHAR(250)
DECLARE @backupDatabase VARCHAR(250)
DECLARE @backupSchema VARCHAR(250)

SET @sourceDatabase = 'ASSET_DIS'
SET @sourceSchema = 'dbo'
SET @backupDatabase = 'eamCleansing' -- Execute script on this database
SET @backupSchema = 'TNAD\bendad'

DECLARE @sqlString VARCHAR(MAX)

-- Create list of tables to copy from the ASSET_DIS database
SET @sqlString = 'IF EXISTS (SELECT 1 FROM sys.objects WHERE name = ''BackupTables'' AND type = ''U'' AND schema_id = (SELECT schema_id FROM sys.schemas WHERE name = ''' + @backupSchema + '''))
BEGIN
	DROP TABLE [' + @backupSchema + '].BackupTables
END'
EXEC (@sqlString)

SET @sqlString = 'CREATE TABLE [' + @backupSchema + '].BackupTables
(
	TableName VARCHAR(256)
)'
EXEC (@sqlString)

--------------------------------------------------------------------------------
-- List of tables to backup
--------------------------------------------------------------------------------
SET @sqlString = 'INSERT INTO [' + @backupSchema + '].BackupTables VALUES (''Network_CABN'')'
EXEC (@sqlString)
SET @sqlString = 'INSERT INTO [' + @backupSchema + '].BackupTables VALUES (''Network_SWOR'')'
EXEC (@sqlString)

-- Loop through BackupTables and take a copy of each specified table
SET @sqlString = 'DECLARE tableCursor CURSOR
FOR
	SELECT
		TableName
	FROM
		[' + @backupSchema + '].BackupTables'

EXEC (@sqlString)

DECLARE @TableToMigrate VARCHAR(256)

OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @TableToMigrate
WHILE @@FETCH_STATUS = 0
BEGIN
	-- For each required table, drop the eamCleansing.[TNAD\Bendad] copy if it exists
	SET @sqlString = N'
		IF EXISTS (SELECT 1 FROM sys.objects WHERE name = ''' + @TableToMigrate + ''' AND type = ''U'' AND schema_id = (SELECT schema_id FROM sys.schemas WHERE name = ''TNAD\BendaD''))
		BEGIN
			DROP TABLE [' + @backupSchema + '].' + @TableToMigrate + '
		END'
	EXEC (@sqlString)

	-- Recreate a copy of the table from the source
	SET @sqlString = N'SELECT * INTO [' + @backupSchema+ '].' + @TableToMigrate + ' FROM ' + @sourceDatabase + '.' + @sourceSchema + '.' + @TableToMigrate
	EXEC (@sqlString)

	FETCH NEXT FROM tableCursor INTO @TableToMigrate
END

CLOSE tableCursor
DEALLOCATE tableCursor
