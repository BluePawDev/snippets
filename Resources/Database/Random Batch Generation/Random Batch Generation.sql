ALTER PROCEDURE dbo.usp_CreateCertificateBatch
    @CertificateBatchID INT,
    @Points INT,
    @Quantity INT,
    @CreatedUserID INT
AS DECLARE @RecordCount INT,
@LoopCounter INT IF OBJECT_ID('tempdb..#temp_CertBatch') IS NOT NULL DROP TABLE #temp_CertBatch
CREATE TABLE #temp_CertBatch
(
    CreateLookToBookUserID INT,
    LastUpdateLookToBookUserID INT,
    LookToBookCertificateBatchID INT,
    CertificateNumber VARCHAR(8),
    Points INT
)
SET
  @RecordCount = 0
SET
  @LoopCounter = 0 WHILE @RecordCount < @Quantity
    AND @LoopCounter <= 100 BEGIN
    INSERT INTO
  #temp_CertBatch
        (
        CreateLookToBookUserID,
        LastUpdateLookToBookUserID,
        LookToBookCertificateBatchID,
        CertificateNumber,
        Points
        )
    SELECT
        DISTINCT TOP (@Quantity - @RecordCount)
        @CreatedUserID,
        @CreatedUserID,
        @CertificateBatchID,
        RIGHT(NEWID(), 8),
        @Points
    FROM
        sys.columns
    SELECT
        @RecordCount = COUNT(DISTINCT cb.CertificateNumber)
    FROM
        #temp_CertBatch AS cb
        LEFT JOIN LookToBookCertificate AS c ON cb.CertificateNumber = c.CertificateNumber
    WHERE
  c.CertificateNumber IS NULL
    SET
  @LoopCounter = @LoopCounter + 1
END
INSERT INTO
  LookToBookCertificate
    (
    CreateLookToBookUserID,
    LastUpdateLookToBookUserID,
    LookToBookCertificateBatchID,
    CertificateNumber,
    Points
    )
SELECT
    DISTINCT cb.CreateLookToBookUserID,
    cb.LastUpdateLookToBookUserID,
    cb.LookToBookCertificateBatchID,
    cb.CertificateNumber,
    cb.Points
FROM
    #temp_CertBatch AS cb
    LEFT JOIN LookToBookCertificate AS c ON cb.CertificateNumber = c.CertificateNumber
WHERE
  c.CertificateNumber IS NULL
GO