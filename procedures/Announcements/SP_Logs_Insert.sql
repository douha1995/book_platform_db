/* =====================================================================
   Procedure: dbo.SP_Logs_Insert
   Kind: INSERT
   Purpose: Insert a log row into dbo.logs
   Author: Eslam Ragab
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_Logs_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_Logs_Insert;
GO

CREATE PROCEDURE dbo.SP_Logs_Insert
    @Real_date      DATETIME,
    @Action         NVARCHAR(4000),
    @Action_cat     NVARCHAR(200),
    @user_id        INT,
    @item_id        NVARCHAR(100),
    @item_name      NVARCHAR(4000),
    @Catid          INT,
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @Real_date IS NULL OR @Action IS NULL OR @Action_cat IS NULL OR @user_id IS NULL OR @Catid IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'بيانات اللوج الأساسية مطلوبة' ELSE N'Required log fields are missing' END;
            RETURN;
        END

        INSERT INTO dbo.logs ([Real_date],[Action],[Action_cat],[user_id],[item_id],[item_name],Catid)
        VALUES (@Real_date,@Action,@Action_cat,@user_id,@item_id,@item_name,@Catid);

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'تم إضافة اللوج بنجاح' ELSE N'Log inserted successfully' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO



