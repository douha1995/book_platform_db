/* =====================================================================
   Procedure: dbo.SP_Announcements_GetByFilters
   Kind: RETRIEVE
   Purpose: Retrieve announcements by student context filters
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_Announcements_GetByFilters','P') IS NOT NULL
    DROP PROCEDURE dbo.SP_Announcements_GetByFilters;
GO

CREATE PROCEDURE dbo.SP_Announcements_GetByFilters
    @p_catid INT,
    @p_material_id INT,
    @p_group_id INT,
    @p_class_id INT,
    @p_academic_id INT,
    @p_lang NVARCHAR(10)='ar',
    @o_success_code INT OUTPUT,
    @o_message NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT *
        FROM dbo.Announcements
        WHERE IsDeleted=0
          AND Catid=@p_catid
          AND MaterialId=@p_material_id
          AND groupid=@p_group_id
          AND ClassId=@p_class_id
          AND AcademicId=@p_academic_id;

        IF @@ROWCOUNT=0
        BEGIN SET @o_success_code=4404; SET @o_message=N'لا توجد إعلانات بهذه الفلاتر'; RETURN; END
        SET @o_success_code=0; SET @o_message=N'تم جلب الإعلانات بنجاح';
    END TRY
    BEGIN CATCH
        SET @o_success_code=-ERROR_NUMBER(); SET @o_message=ERROR_MESSAGE();
    END CATCH
END
GO

DECLARE @c INT,@m NVARCHAR(4000);
EXEC dbo.SP_Announcements_GetByFilters
     12,11388,1,1,54,'ar',@c OUTPUT,@m OUTPUT;
SELECT @c Code,@m Message;
