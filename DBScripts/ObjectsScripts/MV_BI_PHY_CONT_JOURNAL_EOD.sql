DROP materialized view MV_BI_PHY_CONT_JOURNAL_EOD;
DROP table MV_BI_PHY_CONT_JOURNAL_EOD;
create materialized view MV_BI_PHY_CONT_JOURNAL_EOD
refresh force on demand
as
select pcj.catogery,
       pcj.book_type,
       pcj.corporate_id,
       pcj.corporate_name,
       pcj.contract_ref_no,
       pcj.del_item_ref_no,
       pcj.internal_contract_ref_no,
       pcj.cp_id,
       pcj.companyname,
       pcj.trader_id,
       pcj.trader,
       pcj.inco_term_id,
       pcj.inco_term,
       pcj.inco_term_location,
       pcj.issue_date,
       pcj.product_id,
       pcj.product_desc,
       pcj.element_id,
       pcj.element,
       pcj.del_item_qty,
       pcj.del_item_qty_unit_id,
       pcj.del_item_qty_unit,
       pcj.del_date,
       pcj.price_basis,
       pcj.price,
       pcj.price_unit_id,
       pcj.price_unit_name,
       pcj.premium_disc_value,
       pcj.premium_disc_unit_id,
       pcj.pd_price_unit_name,
       pcj.eod_eom_date,
       pcj.process,
       tdc.created_date eod_eom_run_date,
       tdc.process_run_count eod_eom_run_count,
       pcj.catogery status,
       pcj.contract_qty contract_item_qty,
       pcj.cont_qty_unit contarct_item_qty_uom,
       pcj.issue_date contract_issue_date,
       pcj.del_date delivery_quota_period,
       pcj.profit_center_short_name profit_center,
       pcj.strategy strategy,
       pcj.del_quota_period,
       pcj.attribute_1,
       pcj.attribute_2,
       pcj.attribute_3,
       pcj.attribute_4,
       pcj.attribute_5
  from eod_eom_phy_contract_journal@eka_eoddb pcj,
       tdc_trade_date_closure@eka_eoddb       tdc
 where pcj.corporate_id = tdc.corporate_id
   and pcj.process_id = tdc.process_id
   and pcj.process = 'EOD';
