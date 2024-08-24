WITH SaleTotals AS (
    SELECT 
        s.BuyerEmail,
        s.SaleDate,
        SUM(sd.ProductQuantity * sd.ProductPrice) AS TotalPayment
    FROM Sales s
    JOIN SalesDetails sd ON s.SaleID = sd.SaleID
    GROUP BY s.BuyerEmail, s.SaleDate
)

SELECT 
    BuyerEmail
FROM SaleTotals
GROUP BY BuyerEmail
HAVING AVG(TotalPayment) > 1000;