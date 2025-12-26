/* =====================================================================
   Procedure: dbo.sp_GetStudentQuizSheets
   Kind: RETRIEVE
   Purpose: Retrieve student quizzes and related sheets based on faculty,
            material, group, academic year, class, and publish status
   PageName: Page Materials_Quiz
   Ticket: QUIZ-001
   Author: Abdelrahman
   Version: 1.0.0
   CreatedOn: 2025-12-27
   ===================================================================== */

IF OBJECT_ID('dbo.sp_GetStudentQuizSheets', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetStudentQuizSheets;
GO

CREATE PROCEDURE dbo.sp_GetStudentQuizSheets
    -- [Input Parameters]
    @p_faculty_code BIGINT,
    @p_material_id  BIGINT,
    @p_group_id     BIGINT,
    @p_academic_id  BIGINT,
    @p_class_id     BIGINT,
    @p_publish_quiz INT = 0,      -- 0 not published, 1 published, -1 all
    @p_isdeleted    INT = 0,
    @p_lang         NVARCHAR(10) = 'ar',

    -- [Output Parameters]
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        /* ================= Validation ================= */
        IF @p_faculty_code IS NULL
           OR @p_material_id IS NULL
           OR @p_group_id IS NULL
           OR @p_academic_id IS NULL
           OR @p_class_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE 
                                WHEN LEFT(@p_lang,2) = 'ar'
                                THEN N'من فضلك ادخل جميع المحددات'
                                ELSE N'All required parameters must be provided'
                             END;
            RETURN;
        END

        /* ================= Query ================= */
        IF @p_publish_quiz IN (0,1)
        BEGIN
            SELECT
                SQ.*,
                SH.*
            FROM dbo.Students_Quiz SQ
            INNER JOIN dbo.Sheets SH
                ON SQ.MaterialId = SH.MaterialId
            WHERE
                SQ.Catid       = @p_faculty_code
                AND SQ.MaterialId = @p_material_id
                AND SQ.GroupId    = @p_group_id
                AND SH.AcademicId = @p_academic_id
                AND SH.ClassId    = @p_class_id
                AND SH.Publish_Quiz = @p_publish_quiz
                AND SH.IsDeleted = @p_isdeleted;
        END
        ELSE
        BEGIN
            SELECT
                SQ.*,
                SH.*
            FROM dbo.Students_Quiz SQ
            INNER JOIN dbo.Sheets SH
                ON SQ.MaterialId = SH.MaterialId
            WHERE
                SQ.Catid       = @p_faculty_code
                AND SQ.MaterialId = @p_material_id
                AND SQ.GroupId    = @p_group_id
                AND SH.AcademicId = @p_academic_id
                AND SH.ClassId    = @p_class_id
                AND SH.IsDeleted = @p_isdeleted;
        END

        /* ================= Result Check ================= */
        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE 
                                WHEN LEFT(@p_lang,2) = 'ar'
                                THEN N'لا توجد اختبارات إلكترونية لهذه المادة'
                                ELSE N'No quizzes found for this material'
                             END;
            RETURN;
        END

        /* ================= Success ================= */
        SET @o_success_code = 0;
        SET @o_message = CASE 
                            WHEN LEFT(@p_lang,2) = 'ar'
                            THEN N'تم جلب البيانات بنجاح'
                            ELSE N'Success'
                         END;

    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
