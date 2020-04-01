WITH cte AS (
    SELECT	
		ColColumnName,
        ROW_NUMBER() OVER (
            PARTITION BY
				ColColumnName                
            ORDER BY
				ColColumnName

        ) row_num
     FROM
        SYSTM000ColumnsAlias WHERE ColTableName ='jobcargo'
)

DELETE FROM cte
WHERE row_num > 1