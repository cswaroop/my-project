ALTER TABLE GRD_GOODS_RECORD_DETAIL MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);
ALTER TABLE GRDL_GOODS_RECORD_DETAIL_LOG MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);
ALTER TABLE DGRD_DELIVERED_GRD MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);
ALTER TABLE DGRDUL_DELIVERED_GRD_UL MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);
ALTER TABLE PRD_PHYSICAL_REALIZED_DAILY MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);
ALTER TABLE AGD_ALLOC_GROUP_DETAIL MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);
ALTER TABLE AGDUL_ALLOC_GROUP_DETAIL_UL MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);
ALTER TABLE POUD_PHY_OPEN_UNREAL_DAILY MODIFY realized_internal_stock_ref_no VARCHAR2(30);
ALTER TABLE ord_overall_realized_pnl_daily MODIFY INTERNAL_STOCK_REF_NO VARCHAR2(30);





