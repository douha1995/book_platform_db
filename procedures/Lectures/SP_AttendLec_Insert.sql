/* =====================================================================
   Procedure: dbo.SP_AttendLec_Insert
   Kind: CREATE
   Purpose: Insert a new attendance row into attend_lec
   Author: Eslam Ragab
   Ticket: Lecture-002
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_AttendLec_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_AttendLec_Insert;
GO

CREATE PROCEDURE dbo.SP_AttendLec_Insert
    @ACAD_YEAR_ID           INT,
    @ACAD_YEAR              NVARCHAR(50),
    @ED_STUD_ID             INT,
    @STUD_CODE              NVARCHAR(50),
    @STUD_NAME              NVARCHAR(200),
    @STUD_NATIONAL_NUMBER   NVARCHAR(50),
    @STUDY_NATURE_ID        INT,
    @STUDY_NATURE           NVARCHAR(100),
    @FACULTY_CODE           INT,
    @FACULTY_NAME           NVARCHAR(200),
    @STUDY_METHOD_ID        INT,
    @STUDY_METHOD           NVARCHAR(100),
    @DEPARTMENT_ID          INT,
    @DEPARTMENT             NVARCHAR(200),
    @PHASE_ID               INT,
    @PHASE                  NVARCHAR(100),
    @SEMESTER_ID            INT,
    @SEMESTER               NVARCHAR(100),
    @PAY_FLAG               INT,
    @STUD_PHOTO             NVARCHAR(4000),
    @LAW_ID                 INT,
    @LAW_NAME               NVARCHAR(200),
    @GROUP_ID               INT,
    @GROUP_NAME             NVARCHAR(200),
    @ClassId                INT,
    @MaterialId             INT,
    @p_lang                 NVARCHAR(10) = 'ar',
    @o_success_code         INT OUTPUT,
    @o_message              NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @ACAD_YEAR_ID IS NULL OR @ED_STUD_ID IS NULL OR @FACULTY_CODE IS NULL
           OR @GROUP_ID IS NULL OR @ClassId IS NULL OR @MaterialId IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'حقول الحضور الأساسية مطلوبة'
                                  ELSE N'Required attendance fields are missing' END;
            RETURN;
        END

        -- Optional: prevent duplicate attendance for same student/class/material/year
        IF EXISTS (
            SELECT 1
            FROM dbo.attend_lec
            WHERE ACAD_YEAR_ID = @ACAD_YEAR_ID
              AND ED_STUD_ID   = @ED_STUD_ID
              AND ClassId      = @ClassId
              AND MaterialId   = @MaterialId
        )
        BEGIN
            SET @o_success_code = 4090;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                                  THEN N'تم تسجيل الحضور مسبقًا لنفس السنة/الطالب/الفصل/المادة'
                                  ELSE N'Attendance already exists for the same year/student/class/material' END;
            RETURN;
        END

        INSERT INTO dbo.attend_lec
        (
            [ACAD_YEAR_ID],[ACAD_YEAR],[ED_STUD_ID],[STUD_CODE],[STUD_NAME],[STUD_NATIONAL_NUMBER],
            [STUDY_NATURE_ID],[STUDY_NATURE],[FACULTY_CODE],[FACULTY_NAME],[STUDY_METHOD_ID],[STUDY_METHOD],
            [DEPARTMENT_ID],[DEPARTMENT],[PHASE_ID],[PHASE],[SEMESTER_ID],[SEMESTER],[PAY_FLAG],[STUD_PHOTO],
            [LAW_ID],[LAW_NAME],[GROUP_ID],[GROUP_NAME],[ClassId],[MaterialId]
        )
        VALUES
        (
            @ACAD_YEAR_ID,@ACAD_YEAR,@ED_STUD_ID,@STUD_CODE,@STUD_NAME,@STUD_NATIONAL_NUMBER,
            @STUDY_NATURE_ID,@STUDY_NATURE,@FACULTY_CODE,@FACULTY_NAME,@STUDY_METHOD_ID,@STUDY_METHOD,
            @DEPARTMENT_ID,@DEPARTMENT,@PHASE_ID,@PHASE,@SEMESTER_ID,@SEMESTER,@PAY_FLAG,@STUD_PHOTO,
            @LAW_ID,@LAW_NAME,@GROUP_ID,@GROUP_NAME,@ClassId,@MaterialId
        );

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar'
                              THEN N'تم تسجيل الحضور بنجاح'
                              ELSE N'Attendance inserted successfully' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO



DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_AttendLec_Insert
    @ACAD_YEAR_ID = 54,
    @ACAD_YEAR = N'2024/2025',
    @ED_STUD_ID = 30454,
    @STUD_CODE = N'202430454',
    @STUD_NAME = N'Ahmed Ali',
    @STUD_NATIONAL_NUMBER = N'29801011234567',
    @STUDY_NATURE_ID = 1,
    @STUDY_NATURE = N'Regular',
    @FACULTY_CODE = 12,
    @FACULTY_NAME = N'Engineering',
    @STUDY_METHOD_ID = 1,
    @STUDY_METHOD = N'Credit',
    @DEPARTMENT_ID = 5,
    @DEPARTMENT = N'Computer Science',
    @PHASE_ID = 2,
    @PHASE = N'Second',
    @SEMESTER_ID = 1,
    @SEMESTER = N'First',
    @PAY_FLAG = 1,
    @STUD_PHOTO = N'photo.jpg',
    @LAW_ID = 1,
    @LAW_NAME = N'Law Name',
    @GROUP_ID = 1,
    @GROUP_NAME = N'Group A',
    @ClassId = 1,
    @MaterialId = 11388,
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;
