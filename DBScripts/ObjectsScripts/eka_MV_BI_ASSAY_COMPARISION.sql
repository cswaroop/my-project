DROP MATERIALIZED VIEW MV_BI_ASSAY_COMPARISION;
CREATE MATERIALIZED VIEW MV_BI_ASSAY_COMPARISION
REFRESH FORCE ON DEMAND
START WITH TO_DATE('25-06-2012 17:14:53', 'DD-MM-YYYY HH24:MI:SS') NEXT SYSDATE+20/1440  
AS
SELECT * FROM V_BI_ASSAY_COMPARISION;