/* =====================================================================
   Procedure: dbo.SP_StudentClass_GetByClassId
   Kind: RETRIEVE
   Purpose: Retrieve active StudentClass rows by ClassId
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_StudentClass_GetByClassId', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_StudentClass_GetByClassId;
GO

CREATE PROCEDURE dbo.SP_StudentClass_GetByClassId
    @p_class_id     INT,
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_class_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'رقم الفصل مطلوب'
                                  ELSE N'ClassId is required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.StudentClass
        WHERE IsDeleted = 0
          AND ClassId = @p_class_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'لا توجد بيانات لهذا الفصل'
                                  ELSE N'No data found for this class' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم جلب البيانات بنجاح'
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO



## Run this SP_StudentClass_GetByClassId
DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_StudentClass_GetByClassId
    @p_class_id = 2,
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;


