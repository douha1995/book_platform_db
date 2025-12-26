/* =====================================================================
   Procedure: dbo.SP_Announcements_GetById
   Kind: RETRIEVE
   Purpose: Get one announcement by an_id
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_Announcements_GetById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_Announcements_GetById;
GO

CREATE PROCEDURE dbo.SP_Announcements_GetById
    @p_an_id        INT,
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_an_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'معرف الإعلان مطلوب' ELSE N'Announcement id is required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.Announcements
        WHERE an_id = @p_an_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'الإعلان غير موجود' ELSE N'Announcement not found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'تم جلب الإعلان بنجاح' ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO



DECLARE @c INT, @m NVARCHAR(4000);
EXEC dbo.SP_Announcements_GetById
    @p_an_id = 1,
    @p_lang='ar',
    @o_success_code=@c OUTPUT,
    @o_message=@m OUTPUT;
SELECT @c Code, @m Message;
