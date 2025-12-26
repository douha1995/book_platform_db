/* =====================================================================
   Procedure: dbo.SP_LecturesTimetable_GetCurrentLectureTop1
   Kind: RETRIEVE
   Purpose: Get top 1 current lecture from Lectures_timetable (by time & day)
   Author: Eslam Ragab
   Ticket: Lecture-004
   Version: 1.0.1
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_LecturesTimetable_GetCurrentLectureTop1', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_LecturesTimetable_GetCurrentLectureTop1;
GO

CREATE PROCEDURE dbo.SP_LecturesTimetable_GetCurrentLectureTop1
    @p_catid        INT,
    @p_material_id  INT,
    @p_group_id     INT,
    @p_class_id     INT,
    @p_academic_id  INT,
    @p_day_name     NVARCHAR(50) = NULL,   -- optional: pass from app
    @p_current_time TIME = NULL,           -- optional: pass from app
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_catid IS NULL OR @p_material_id IS NULL OR @p_group_id IS NULL
           OR @p_class_id IS NULL OR @p_academic_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'جميع فلاتر الجدول مطلوبة'
                                  ELSE N'All timetable filters are required' END;
            RETURN;
        END

        -- defaults (server-side)
        IF @p_day_name IS NULL OR LTRIM(RTRIM(@p_day_name)) = N''
            SET @p_day_name = DATENAME(WEEKDAY, GETDATE());

        IF @p_current_time IS NULL
            SET @p_current_time = CONVERT(TIME(0), GETDATE());

        SELECT TOP (1) *
        FROM dbo.Lectures_timetable
        WHERE IsDeleted  = 0
          AND Catid      = @p_catid
          AND MaterialId = @p_material_id
          AND groupid    = @p_group_id
          AND ClassId    = @p_class_id
          AND AcademicId = @p_academic_id
          AND [day]      = @p_day_name
          AND @p_current_time BETWEEN [start_time] AND [end_time]
        ORDER BY id DESC;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'لا توجد محاضرة حالية حسب اليوم والوقت'
                                  ELSE N'No current lecture found for the given day/time' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم جلب المحاضرة الحالية بنجاح'
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO


DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_LecturesTimetable_GetCurrentLectureTop1
    @p_catid = 12,
    @p_material_id = 11388,
    @p_group_id = 1,
    @p_class_id = 1,
    @p_academic_id = 54,
    @p_day_name = N'Friday',      -- غيّرها لقيمة موجودة في Lectures_timetable.day
    @p_current_time = '20:30:00', -- جرّب وقت داخل الفترة
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;
