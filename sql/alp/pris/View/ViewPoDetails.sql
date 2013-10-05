

CREATE VIEW [dbo].[ViewPoDetails]
AS
SELECT     dbo.Products.Prod_Name, dbo.Products.Prod_Alias, dbo.Products.PackageSpec, dbo.Products.NumPerPack, dbo.Products.Prod_Desc,
                      dbo.Products.Measure, dbo.PO_Details.UnitsOnPO, dbo.PO_Details.Product_ID, dbo.PO_Details.PO_ID, dbo.PO_Details.UnitsReceived
FROM         dbo.PO_Details INNER JOIN
                      dbo.Products ON dbo.PO_Details.Product_ID = dbo.Products.Barcode


