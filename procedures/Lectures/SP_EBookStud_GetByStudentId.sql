/* =====================================================================
   Procedure: dbo.SP_EBookStud_GetByStudentId
   Kind: RETRIEVE
   Purpose: Retrieve E_BOOK_STUD records by ED_STUD_ID
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_EBookStud_GetByStudentId', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_EBookStud_GetByStudentId;
GO

CREATE PROCEDURE dbo.SP_EBookStud_GetByStudentId
    @p_ed_stud_id    INT,
    @p_lang          NVARCHAR(10) = 'ar',
    @o_success_code  INT OUTPUT,
    @o_message       NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_ed_stud_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'رقم الطالب مطلوب'
                                  ELSE N'ED_STUD_ID is required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.E_BOOK_STUD
        WHERE ED_STUD_ID = @p_ed_stud_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'لا توجد بيانات للطالب'
                                  ELSE N'No records found for this student' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم جلب بيانات الطالب بنجاح'
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO


DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_EBookStud_GetByStudentId
    @p_ed_stud_id = 30454,   -- غيّرها لرقم طالب موجود فعلاً
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;
