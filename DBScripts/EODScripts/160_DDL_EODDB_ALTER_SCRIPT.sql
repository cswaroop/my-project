DROP MATERIALIZED VIEW  IID_INVOICABLE_ITEM_DETAILS;
CREATE MATERIALIZED VIEW  IID_INVOICABLE_ITEM_DETAILS  REFRESH FAST ON DEMAND WITH PRIMARY KEY AS  SELECT * FROM  IID_INVOICABLE_ITEM_DETAILS@eka_appdb;