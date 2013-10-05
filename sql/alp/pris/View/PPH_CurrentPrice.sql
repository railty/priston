CREATE VIEW [PPH_CurrentPrice] As Select A.ProdNum As ProdNum, A.CurrentPrice, A.Date From PPH A Join (SELECT ProdNum, MAX(Date) As Date FROM PPH Group By ProdNum) B On A.ProdNum = B.ProdNum And A.Date = B.Date;
