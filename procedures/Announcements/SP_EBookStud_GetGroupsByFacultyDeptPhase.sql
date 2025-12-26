/* =====================================================================
   Procedure: dbo.SP_EBookStud_GetGroupsByFacultyDeptPhase
   Kind: RETRIEVE
   Purpose: Get distinct groups for faculty+department+phase (GROUP_ID != 0)
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_EBookStud_GetGroupsByFacultyDeptPhase', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_EBookStud_GetGroupsByFacultyDeptPhase;
GO

CREATE PROCEDURE dbo.SP_EBookStud_GetGroupsByFacultyDeptPhase
    @p_faculty_code  INT,
    @p_department_id INT,
    @p_phase_id      INT,
    @p_lang          NVARCHAR(10) = 'ar',
    @o_success_code  INT OUTPUT,
    @o_message       NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_faculty_code IS NULL OR @p_department_id IS NULL OR @p_phase_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'الفلاتر مطلوبة' ELSE N'Filters are required' END;
            RETURN;
        END

        SELECT DISTINCT GROUP_ID, GROUP_NAME
        FROM dbo.E_BOOK_STUD
        WHERE FACULTY_CODE  = @p_faculty_code
          AND DEPARTMENT_ID = @p_department_id
          AND PHASE_ID      = @p_phase_id
          AND GROUP_ID <> 0
        GROUP BY GROUP_ID, GROUP_NAME;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'لا توجد مجموعات' ELSE N'No groups found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'تم جلب المجموعات بنجاح' ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO


DECLARE @c INT, @m NVARCHAR(4000);
EXEC dbo.SP_EBookStud_GetGroupsByFacultyDeptPhase
    @p_faculty_code=12,
    @p_department_id=5,
    @p_phase_id=2,
    @p_lang='ar',
    @o_success_code=@c OUTPUT,
    @o_message=@m OUTPUT;
SELECT @c Code, @m Message;
