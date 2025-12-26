/* =====================================================================
   Procedure: dbo.SP_Announcements_Update
   Kind: UPDATE
   Purpose: Update announcement by an_id
   Author: Eslam Ragab
   Version: 1.0.1
   CreatedOn: 2025-12-26
   ===================================================================== */

IF OBJECT_ID(N'dbo.SP_Announcements_Update', N'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_Announcements_Update;
GO

CREATE PROCEDURE dbo.SP_Announcements_Update
    @an_id            INT,
    @TitleArab        NVARCHAR(200) = NULL,
    @DescriptionArab  NVARCHAR(MAX) = NULL,
    @Photo            NVARCHAR(4000) = NULL,
    @URL              NVARCHAR(2000) = NULL,
    @user_id          INT = NULL,
    @Catid            INT = NULL,
    @Specialid        INT = NULL,
    @AcademicId       INT = NULL,
    @YearId           INT = NULL,
    @UpdatedDate      DATETIME = NULL,
    @MaterialId       INT = NULL,
    @ClassId          INT = NULL,
    @files            NVARCHAR(MAX) = NULL,
    @filename         NVARCHAR(4000) = NULL,
    @groupid          INT = NULL,
    @p_lang           NVARCHAR(10) = 'ar',
    @o_success_code   INT OUTPUT,
    @o_message        NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @an_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE 
                                WHEN LEFT(@p_lang,2)='ar' THEN N'معرف الإعلان مطلوب'
                                ELSE N'an_id is required'
                             END;
            RETURN;
        END

        UPDATE dbo.Announcements
        SET TitleArab       = @TitleArab,
            DescriptionArab = @DescriptionArab,
            Photo           = @Photo,
            URL             = @URL,
            user_id         = @user_id,
            Catid           = @Catid,
            Specialid       = @Specialid,
            AcademicId      = @AcademicId,
            YearId          = @YearId,
            UpdatedDate     = @UpdatedDate,
            MaterialId      = @MaterialId,
            ClassId         = @ClassId,
            files           = @files,
            filename        = @filename,
            groupid         = @groupid
        WHERE an_id = @an_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE 
                                WHEN LEFT(@p_lang,2)='ar' THEN N'لم يتم العثور على الإعلان'
                                ELSE N'Announcement not found'
                             END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE 
                            WHEN LEFT(@p_lang,2)='ar' THEN N'تم تحديث الإعلان بنجاح'
                            ELSE N'Updated successfully'
                         END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END
GO



