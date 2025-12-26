/* =====================================================================
   Procedure: dbo.SP_AttendLec_GetByStudentClassMaterial
   Kind: RETRIEVE
   Purpose: Retrieve attend_lec record(s) by ED_STUD_ID + ClassId + MaterialId
   Author: Eslam Ragab
   Ticket: Lecture-001
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_AttendLec_GetByStudentClassMaterial', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_AttendLec_GetByStudentClassMaterial;
GO

CREATE PROCEDURE dbo.SP_AttendLec_GetByStudentClassMaterial
    @p_ed_stud_id    INT,
    @p_class_id      INT,
    @p_material_id   INT,
    @p_lang          NVARCHAR(10) = 'ar',
    @o_success_code  INT OUTPUT,
    @o_message       NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_ed_stud_id IS NULL OR @p_class_id IS NULL OR @p_material_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'رقم الطالب والفصل والمادة مطلوبة'
                                  ELSE N'StudentId, ClassId and MaterialId are required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.attend_lec
        WHERE ED_STUD_ID = @p_ed_stud_id
          AND ClassId    = @p_class_id
          AND MaterialId = @p_material_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'لا يوجد تسجيل حضور بهذه البيانات'
                                  ELSE N'No attendance record found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم جلب بيانات الحضور بنجاح'
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO


DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_AttendLec_GetByStudentClassMaterial
    @p_ed_stud_id  = 30454,
    @p_class_id    = 1,
    @p_material_id = 11388,
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;
