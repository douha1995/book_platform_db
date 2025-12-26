/* =====================================================================
   Procedure: dbo.sp_GetSheetDetails
   Kind: RETRIEVE
   Purpose: Retrieve all details of sheets (exams) for specific faculty and material and academic year and phase 
   PageName: Page Materials_Quiz
   Ticket: SHEET-001
   Author: Abdelrahman
   Version: 1.0.0
   CreatedOn: 2025-12-25
   ===================================================================== */
IF OBJECT_ID('dbo.sp_GetSheetDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetSheetDetails;
GO

CREATE PROCEDURE dbo.sp_GetSheetDetails
    -- [Input Parameters]
    @p_faculty_code BIGINT,
    @p_material_id BIGINT,
    @p_group_id BIGINT,
    @p_academic_id BIGINT,
    @p_class_id BIGINT,
    @publish_quiz INT = -1, -- -1 all, 0 not published, 1 published
    @p_isdeleted INT = 0,
    @p_lang       NVARCHAR(10) = 'ar',
    -- [Output Parameters]
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        -- [Validation]
        IF @p_faculty_code IS NULL or @p_material_id IS NULL or @p_group_id IS NULL
        or @p_academic_id IS NULL or @p_class_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'من فضلك ادخل جميع المحددات' 
                                  ELSE N'ِAll sheet data is required' END;
            RETURN;
        END

        -- [Output]

        IF @publish_quiz IN (0,1)
        BEGIN
            SELECT *
            FROM dbo.Sheets
            WHERE CATID = @p_faculty_code AND 
                  MATERIALID = @p_material_id AND 
                  GROUPID = @p_group_id AND 
                  ACADEMICID = @p_academic_id AND 
                  CLASSID = @p_class_id AND
                  PUBLISH_QUIZ = @publish_quiz AND
                  ISDELETED = @p_isdeleted;
        END
        ELSE 
        BEGIN  
            SELECT *
            FROM dbo.Sheets
            WHERE CATID = @p_faculty_code AND 
                MATERIALID = @p_material_id AND 
                GROUPID = @p_group_id AND 
                ACADEMICID = @p_academic_id AND 
                CLASSID = @p_class_id AND
                ISDELETED = @p_isdeleted;
        END

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد اختبارات إلكترونية لهذه الماده' 
                                  ELSE N'No Sheets found for this material' END;
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
