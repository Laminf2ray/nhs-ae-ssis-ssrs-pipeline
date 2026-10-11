USE NHS_AE;
GO
DROP TABLE IF EXISTS dbo.stg_ae_raw, dbo.ae_clean, dbo.ae_errors, dbo.etl_run_log;
GO
-- Staging: all 22 CSV columns as text, so nothing is rejected on load
CREATE TABLE dbo.stg_ae_raw (
    Period NVARCHAR(100), OrgCode NVARCHAR(50), ParentOrg NVARCHAR(255), OrgName NVARCHAR(255),
    Att_T1 NVARCHAR(50), Att_T2 NVARCHAR(50), Att_Other NVARCHAR(50),
    AttBk_T1 NVARCHAR(50), AttBk_T2 NVARCHAR(50), AttBk_Other NVARCHAR(50),
    Over4_T1 NVARCHAR(50), Over4_T2 NVARCHAR(50), Over4_Other NVARCHAR(50),
    Over4Bk_T1 NVARCHAR(50), Over4Bk_T2 NVARCHAR(50), Over4Bk_Other NVARCHAR(50),
    DTA_4to12 NVARCHAR(50), DTA_12plus NVARCHAR(50),
    EmAdm_T1 NVARCHAR(50), EmAdm_T2 NVARCHAR(50), EmAdm_Other NVARCHAR(50), EmAdm_NonAE NVARCHAR(50),
    SourceFile NVARCHAR(260),
    LoadedAt DATETIME2 DEFAULT SYSDATETIME()
);
-- Clean: typed values plus derived measures
CREATE TABLE dbo.ae_clean (
    PeriodDate DATE NOT NULL,
    OrgCode NVARCHAR(10) NOT NULL,
    ParentOrg NVARCHAR(255),
    OrgName NVARCHAR(255) NOT NULL,
    Att_T1 INT, Att_T2 INT, Att_Other INT,
    AttBk_T1 INT, AttBk_T2 INT, AttBk_Other INT,
    Over4_T1 INT, Over4_T2 INT, Over4_Other INT,
    Over4Bk_T1 INT, Over4Bk_T2 INT, Over4Bk_Other INT,
    DTA_4to12 INT, DTA_12plus INT,
    EmAdm_T1 INT, EmAdm_T2 INT, EmAdm_Other INT, EmAdm_NonAE INT,
    TotalAttendances INT,
    TotalOver4hrs INT,
    PctWithin4hrs DECIMAL(5,2) NULL,   -- NULL when there are no attendances
    SourceFile NVARCHAR(260),
    CONSTRAINT PK_ae_clean PRIMARY KEY (PeriodDate, OrgCode)
);
-- Errors: raw identifying values plus the reason the row failed
CREATE TABLE dbo.ae_errors (
    Period NVARCHAR(100), OrgCode NVARCHAR(50), OrgName NVARCHAR(255),
    ErrorReason NVARCHAR(200), SourceFile NVARCHAR(260),
    LoggedAt DATETIME2 DEFAULT SYSDATETIME()
);
-- Run log: row counts at each stage
CREATE TABLE dbo.etl_run_log (
    RunID NVARCHAR(50),
    Step NVARCHAR(50),
    RowsCount INT,
    LoggedAt DATETIME2 DEFAULT SYSDATETIME()
);