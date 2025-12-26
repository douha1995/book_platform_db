/* =====================================================================
   Procedure: dbo.SP_StudentClass_GetAllActive
   Kind: RETRIEVE
   Purpose: Retrieve all active StudentClass rows (IsDeleted=0)
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_StudentClass_GetAllActive', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_StudentClass_GetAllActive;
GO

CREATE PROCEDURE dbo.SP_StudentClass_GetAllActive
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        SELECT *
        FROM dbo.StudentClass
        WHERE IsDeleted = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'لا توجد بيانات'
                                  ELSE N'No records found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم جلب البيانات بنجاح'
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO




DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_StudentClass_GetAllActive
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;
