
/* =====================================================================
   Object: dbo.Customer
   Kind: ALTER_TABLE
   Purpose: Alter table dbo.Customer (add column phone)
   Ticket: CRM-5003
   Author: YourName
   Version: 1.0.0
   CreatedOn: YYYY-MM-DD
   ===================================================================== */

DECLARE @o_success_code INT = -1;
DECLARE @o_message NVARCHAR(4000) = N'Uninitialized';

BEGIN TRY
    -- [Validation]
    IF OBJECT_ID(N'dbo.Customer', N'U') IS NULL
    BEGIN
        SET @o_success_code = 4204;
        SET @o_message = N'Table dbo.Customer not found';
        PRINT @o_message;
        RETURN;
    END

    -- If column already exists, skip or switch to MODIFY logic
    IF EXISTS (
        SELECT 1
        FROM sys.columns c
        WHERE c.object_id = OBJECT_ID(N'dbo.Customer', N'U')
          AND c.name = N'phone'
    )
    BEGIN
        SET @o_success_code = 4100;
        SET @o_message = N'Column phone already exists on dbo.Customer';
        PRINT @o_message;
        RETURN;
    END

    -- [Output]
    ALTER TABLE dbo.Customer
        ADD phone NVARCHAR(30) NULL;


    SET @o_success_code = 0;
    SET @o_message = N'OK: Column {phone} added to dbo.Customer';
    PRINT @o_message;
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrNum INT = ERROR_NUMBER();

    SET @o_success_code = -@ErrNum;
    SET @o_message = N'Unexpected error (' + @ErrNum + N'): ' + @ErrMsg;
       PRINT @o_message;
END CATCH;
