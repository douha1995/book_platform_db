
/* =====================================================================
   Object: dbo.Customer
   Kind: DROP_TABLE
   Purpose: Drop table dbo.Customer safely
   Ticket: CRM-5002
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

    -- [Output]
    DROP TABLE dbo.Customer;

    SET @o_success_code = 0;
    SET @o_message = N'OK: Table dbo.Customer dropped successfully';
    PRINT @o_message;
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @    DECLARE @ErrNum INT = ERROR_NUMBER();

    SET @o_success_code = -@ErrNum;
    SET @o_message = N'Unexpected error (' + @ErrNum + N'): ' + @ErrMsg;
    PRINT @o_message;
END CATCH;
