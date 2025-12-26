/* =====================================================================
   Procedure: dbo.SP_StudentsQuiz_GetMaterials
   Kind: RETRIEVE
   Purpose: Retrieve distinct materials for a student with filters
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_StudentsQuiz_GetMaterials', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_StudentsQuiz_GetMaterials;
GO

CREATE PROCEDURE dbo.SP_StudentsQuiz_GetMaterials
    @p_catid          INT,
    @p_student_id     INT,
    @p_group_id       INT,
    @p_class_id       INT,
    @p_academic_id    INT,
    @p_only_published BIT = 0,
    @p_lang           NVARCHAR(10) = 'ar',
    @o_success_code   INT OUTPUT,
    @o_message        NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_catid IS NULL OR @p_student_id IS NULL OR @p_group_id IS NULL
           OR @p_class_id IS NULL OR @p_academic_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'جميع الفلاتر مطلوبة'
                                  ELSE N'All filters are required' END;
            RETURN;
        END

        SELECT DISTINCT
            MaterialId,
            materialnm
        FROM dbo.Students_Quiz
        WHERE Catid      = @p_catid
          AND Student_Id = @p_student_id
          AND groupid    = @p_group_id
          AND ClassId    = @p_class_id
          AND AcademicId = @p_academic_id
          AND (
                @p_only_published = 0
                OR publish = 1
              );

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'لا توجد مواد بهذه الفلاتر'
                                  ELSE N'No materials found with these filters' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم جلب المواد بنجاح'
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO



DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_StudentsQuiz_GetMaterials
    @p_catid = 12,
    @p_student_id = 30454,
    @p_group_id = 1,
    @p_class_id = 1,
    @p_academic_id = 54,
    @p_only_published = 0,   -- مهم جدًا = 0 عشان publish عندك مش 1
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;
