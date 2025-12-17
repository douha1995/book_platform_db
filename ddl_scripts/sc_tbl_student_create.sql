
/* =====================================================================
   Object: dbo.Customer
   Kind: CREATE_TABLE
   Purpose: Create table dbo.Customer with base columns and constraints
   Ticket: CRM-5001
   Author: YourName
   Version: 1.0.0
   CreatedOn: YYYY-MM-DD
   ===================================================================== */

-- Output placeholders for consistency (DDL script scope)
DECLARE @o_success_code INT = -1;
DECLARE @o_message NVARCHAR(4000) = N'Uninitialized';

BEGIN TRY
    -- [Validation]
    IF OBJECT_ID(N'dbo.Customer', N'U') IS NOT NULL
    BEGIN
        SET @o_success_code = 4100;
        SET @o_message = N'Table dbo.Customer already exists';
        PRINT @o_message;
        RETURN;
    END

    -- [Output]
    CREATE TABLE dbo.Customer (
        id            BIGINT            NOT NULL IDENTITY(1,1),
        first_name    NVARCHAR(50)      NOT NULL,
        last_name     NVARCHAR(50)      NOT NULL,
        email         NVARCHAR(255)     NOT NULL,
        created_at    DATETIME2(3)      NOT NULL CONSTRAINT DF_Customer_created_at DEFAULT SYSUTCDATETIME(),
        updated_at    DATETIME2(3)      NULL,
        CONSTRAINT PK_Customer PRIMARY KEY (id),
        CONSTRAINT UQ_Customer_email UNIQUE (email)
    );

    SET @o_success_code = 0;
    SET @o_message = N'OK: Table dbo.Customer created successfully';
    PRINT @o_message;
END TRY
BEGIN CATCH
    -- [Error Handling]
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrNum INT = ERROR_NUMBER();

    IF XACT_STATE() <> 0 ROLLBACK TRAN;

    SET @o_success_code = -@ErrNum;
    SET @o_message = N'Unexpected error (' + @Err    
    SET @o_message = N'Unexpected error (' + @ErrNum, N'): ', @ErrMsg;
    PRINT @o_message;

END CATCH;
