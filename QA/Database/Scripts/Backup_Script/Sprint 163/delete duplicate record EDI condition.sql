
WITH cte AS (
    SELECT 
      ColTableName, 
      ColColumnName ,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ColTableName, 
                ColColumnName
            ORDER BY 
                ColColumnName    ) row_num
     FROM 
       SYSTM000ColumnsAlias WHERE ColTableName = 'EDISummaryHeader' AND ColColumnName ='eshInterConsigneeContactEmail'
)


DELETE FROM cte
WHERE row_num > 1;