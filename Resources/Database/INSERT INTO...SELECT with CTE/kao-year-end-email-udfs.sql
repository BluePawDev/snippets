WITH
    RankedData
    AS
    (
        SELECT ROW_NUMBER()
	OVER(
		PARTITION BY
			M1.MemberID
		ORDER BY
			M1.MemberID,
			SUM(
				CASE
					WHEN T.MemberTransactionTypeID = 3
						AND MA.MemberAdjustmentTypeID IN (7,8,9)
					THEN 0
					ELSE T.Points
				END) DESC,
			ISNULL(DATEADD(MONTH, DATEDIFF(MONTH, 0, TransactionDate), 0), '2019-01-01')
		) AS SR,
            M1.MemberID,
            SUM(
				CASE
					WHEN T.MemberTransactionTypeID = 3
                AND MA.MemberAdjustmentTypeID IN (7,8,9)
					THEN 0
					ELSE T.Points
				END) AS Points,
            ISNULL(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.TransactionDate), 0), '2019-01-01') AS TransactionDate,
            M1.EmailAddress,
            M1.FirstName
        FROM Member AS M1
            LEFT JOIN MemberTransaction AS T ON M1.MemberID = T.MemberID
                AND T.MemberTransactionTypeID IN (1,3,4,5,6)
                AND T.IsActive = 1
            LEFT JOIN MemberAdjustment AS MA ON MA.MemberAdjustmentID = T.XRefID
                AND T.MemberTransactionTypeID = 3
                AND MA.IsActive = 1
        WHERE TransactionDate BETWEEN '2019-01-01' AND '2019-12-31'
            AND M1.IsActive = 1
            AND M1.MemberStatusID = 1
            AND M1.EMOptOutDate IS NULL
            AND M1.clientUID = 'c4081d24-579c-4c0d-9eac-6e2d720ce70e'
            AND M1.MemberTypeID <> 5
        GROUP BY
	M1.MemberID,
	M1.FirstName,
	M1.EmailAddress,
	DATEADD(MONTH, DATEDIFF(MONTH, 0, TransactionDate), 0)
    )
INSERT INTO EmailQueue
    (
    MessageClass,
    ServiceName,
    MemberID,
    RecipientEmail,
    TemplateFile,
    TriggerDate,
    UDF1,
    UDF2,
    UDF3,
    UDF4,
    UDF5,
    UDF6,
    EmailBlastID
    )
SELECT
    'M',
    'MandrillAPI',
    R1.MemberID,
    R1.EmailAddress,
    'KAO 20200113 2019 Year in Review',
    '2020-01-28 15:30:00.000',
    R1.FirstName,
    FORMAT(SUM(R1.Points), 'N0') AS Yr_Total_Pts,
    FORMAT(ISNULL(O1.Quantity,0),'N0') AS Qty,
    DATENAME(MONTH,R2.TransactionDate) AS Month,
    ISNULL(SalonName,''),
    '',
    899
FROM RankedData AS R1
    INNER JOIN (
		SELECT MemberID, Points, TransactionDate
    FROM RankedData
    WHERE SR = 1
		) AS R2 ON R1.MemberID = R2.MemberID
    LEFT JOIN (
		SELECT O.MemberID,
        SUM(OI.Quantity) AS Quantity
    FROM [Order] AS O
        INNER JOIN OrderItem AS OI ON O.OrderID = OI.OrderID
    WHERE O.DateCreated BETWEEN '2019-01-01' AND '2019-12-31'
        AND O.[Status] NOT IN ('Disapproved','Lost (Refund)','Cancelled (Refund)')
    GROUP BY O.MemberID
		) AS O1 ON R1.MemberID = O1.MemberID
	OUTER APPLY (
		SELECT TOP 1
        MemberSalonID,
        SalonName,
        Address1,
        Address2,
        City,
        State,
        Country,
        Phone,
        SalonFinderID,
        IsMaster
    FROM MemberSalon WITH(NOLOCK)
    WHERE 1=1
        AND IsActive = 1
        AND MemberID = R1.MemberID
    ORDER BY IsMaster DESC
		) AS MSAL
GROUP BY
	R1.MemberID,
	R2.TransactionDate,
	O1.Quantity,
	R1.EmailAddress,
	R1.FirstName,
	SalonName
ORDER BY
	R1.MemberID