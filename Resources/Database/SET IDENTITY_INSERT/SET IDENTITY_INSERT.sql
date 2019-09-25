SET IDENTITY_INSERT [dbo].[Promotion] ON
INSERT INTO Promotion
    (PromotionID, [Name], StartDate, EndDate, IsActive)
VALUES
    (66, '2019 Book-Spin-Win', '09/10/2019', '11/16/2019', 'True')
SET IDENTITY_INSERT [dbo].[Promotion] OFF