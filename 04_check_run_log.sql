SELECT Step, RowsCount, LoggedAt
FROM dbo.etl_run_log
WHERE RunID = (SELECT TOP 1 RunID FROM dbo.etl_run_log ORDER BY LoggedAt DESC)
ORDER BY LoggedAt;