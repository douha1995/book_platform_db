/* =====================================================================
   Procedure: dbo.sp_PublishQuiz
   Kind: UPDATE
   Purpose: Publish quiz materials for students
   PageName: Page Materials_Quiz
   Ticket: SHEET-002
   Author: Abdelrahman Mamdouh
   Version: 1.0.0
   CreatedOn: 2025-12-25
   ===================================================================== */

IF OBJECT_ID('dbo.sp_PublishQuiz', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_PublishQuiz;
GO

CREATE PROCEDURE dbo.sp_PublishQuiz
    -- [Input Parameters]
    @p_sheet_id BIGINT,

    -- [Output Parameters]
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
SET NOCOUNT ON;

SET @o_success_code = -1;
SET @o_message = N'Uninitialized';

BEGIN TRY
    -- [Validation]
    IF @p_sheet_id IS NULL 
    BEGIN
        SET @o_success_code = 2001;
        SET @o_message = N'Sheet id is required';
        RETURN;
    END

    -- [DML & Transactions]
    BEGIN TRAN;
        UPDATE dbo.Sheets
        SET PUBLISH_QUIZ = 1
        WHERE ID = @p_sheet_id;
    COMMIT TRAN;

    -- [Output]
    SET @o_success_code = 0;
    SET @o_message = N'Quiz is published sucessfully';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    SET @o_success_code = -ERROR_NUMBER();
    SET @o_message = N'Error: ' + ERROR_MESSAGE();
END CATCH;
GO
