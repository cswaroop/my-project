ALTER TABLE grd_goods_record_detail
 ADD (is_clone_stock_spilt  CHAR(1) DEFAULT 'N');
 
 
ALTER TABLE GRDUL_GOODS_RECORD_DETAIL_UL
 ADD (IS_CLONE_STOCK_SPILT  CHAR(1));
 
 ALTER TABLE GRDL_GOODS_RECORD_DETAIL_LOG
 ADD (IS_CLONE_STOCK_SPILT  CHAR(1));