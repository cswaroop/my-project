UPDATE RFC_REPORT_FILTER_CONFIG
SET IS_MANDATORY = 'Y'
WHERE REPORT_ID = '235'
AND LABEL_ID IN ('RFC235PHY01','RFC235PHY02');