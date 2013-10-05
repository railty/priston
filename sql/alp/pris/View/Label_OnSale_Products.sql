CREATE VIEW dbo.Label_OnSale_Products
AS
SELECT     TOP (100) PERCENT dbo.OnSaleProduct.StartDate, dbo.OnSaleProduct.EndDate, dbo.OnSaleProduct.ProdNum, dbo.Products.Prod_Num, 
                      dbo.ProductPrice.RegPrice AS Reg_Price, dbo.ProductPrice.OnsalePrice AS OnSale_Price, dbo.Products.Prod_Name AS Name, dbo.Products.Prod_Desc, 
                      dbo.Products.Measure, dbo.Products.OnSales, dbo.Products.Prod_Alias, dbo.Products.PackageSpec AS Spec, dbo.Products.NumPerPack, dbo.Products.Department, 
                      dbo.Products_Pris.Rank, dbo.Products_Pris.InStock, dbo.Products_Pris.InStockDate, dbo.Products_Pris.Last_Sale_Date, dbo.Products_Pris.Last_Inventory_Date, 
                      dbo.Products_Pris.Location_Code, dbo.Products_Pris.Category, dbo.Products.Tax1App AS Tax
FROM         dbo.OnSaleProduct INNER JOIN
                      dbo.Products ON dbo.OnSaleProduct.ProdNum = dbo.Products.Prod_Num INNER JOIN
                      dbo.Products_Pris ON dbo.OnSaleProduct.ProdNum = dbo.Products_Pris.Barcode INNER JOIN
                      dbo.ProductPrice ON dbo.OnSaleProduct.ProdNum = dbo.ProductPrice.ProdNum
WHERE     (dbo.OnSaleProduct.StartDate > { fn NOW() } - 7)
ORDER BY dbo.OnSaleProduct.EndDate DESC
