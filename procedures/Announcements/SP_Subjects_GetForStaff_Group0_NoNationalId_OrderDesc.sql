/* =====================================================================
   Procedure: dbo.SP_Subjects_GetForStaff_Group0_NoNationalId_OrderDesc
   Kind: RETRIEVE
   Purpose: Get distinct subjects where Staff_Material.groupid=0 (no NatianalId) ordered desc
            NOTE: AcademicYear is INT in Staff_Material
   Author: Eslam Ragab
   Version: 1.0.1
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_Subjects_GetForStaff_Group0_NoNationalId_OrderDesc', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_Subjects_GetForStaff_Group0_NoNationalId_OrderDesc;
GO

CREATE PROCEDURE dbo.SP_Subjects_GetForStaff_Group0_NoNationalId_OrderDesc
    @p_faculty_code   INT,
    @p_department_id  INT,
    @p_phase_id       INT,
    @p_class_id       INT,
    @p_academic_year  INT,              -- ✅ changed to INT
    @p_lang           NVARCHAR(10) = 'ar',
    @o_success_code   INT OUTPUT,
    @o_message        NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_faculty_code IS NULL OR @p_department_id IS NULL OR @p_phase_id IS NULL
           OR @p_class_id IS NULL OR @p_academic_year IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'جميع الفلاتر مطلوبة'
                                  ELSE N'All filters are required' END;
            RETURN;
        END

        SELECT DISTINCT st.SUBJECT_CODE, st.SUBJECT_NAME
        FROM dbo.E_BOOK_SUBJECT_TOTAL st
        INNER JOIN dbo.Staff_Material sm
            ON st.SUBJECT_CODE = sm.MaterialId
        WHERE st.FACULTY_CODE  = @p_faculty_code
          AND st.DEPARTMENT_ID = @p_department_id
          AND st.PHASE_ID      = @p_phase_id
          AND sm.groupid       = 0
          AND sm.ClassId       = @p_class_id
          AND sm.AcademicYear  = @p_academic_year
        GROUP BY st.SUBJECT_CODE, st.SUBJECT_NAME
        ORDER BY st.SUBJECT_CODE DESC;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'لا توجد مواد'
                                  ELSE N'No subjects found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم جلب المواد بنجاح'
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO


DECLARE @c INT, @m NVARCHAR(4000);

EXEC dbo.SP_Subjects_GetForStaff_Group0_NoNationalId_OrderDesc
    @p_faculty_code=12,
    @p_department_id=5,
    @p_phase_id=2,
    @p_class_id=1,
    @p_academic_year=2025,  -- ✅ مثال رقم: غيّره لقيمة موجودة عندك
    @p_lang='ar',
    @o_success_code=@c OUTPUT,
    @o_message=@m OUTPUT;

SELECT @c Code, @m Message;
