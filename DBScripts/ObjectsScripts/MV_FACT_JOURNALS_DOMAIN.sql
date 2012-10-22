DROP materialized view MV_BI_PHY_BOOK_JOURNAL_EOD;
DROP table MV_BI_PHY_BOOK_JOURNAL_EOD;
create materialized view MV_BI_PHY_BOOK_JOURNAL_EOD
refresh force on demand
with rowid
as
select eepbj.section_name,
       eepbj.corporate_id,
       eepbj.corporate_name,
       eepbj.product_id,
       eepbj.product_desc,
       eepbj.counter_party_id,
       eepbj.counter_party_name,
       eepbj.invoice_quantity,
       eepbj.invoice_quantity_uom,
       eepbj.fx_base,
       eepbj.profit_center_id,
       eepbj.profit_center,
       eepbj.strategy_id,
       eepbj.strategy_name,
       eepbj.base_cur_id,
       eepbj.base_currency,
       eepbj.invoice_ref_no,
       eepbj.contract_ref_no,
       eepbj.internal_contract_ref_no,
       eepbj.invoice_cur_id,
       eepbj.pay_in_currency,
       eepbj.amount_in_base_cur,
       eepbj.invoice_amt,
       eepbj.invoice_date,
       eepbj.invoice_due_date,
       eepbj.invoice_type,
       eepbj.bill_to_cp_country,
       eepbj.delivery_item_ref_no,
       eepbj.vat_amount,
       eepbj.vat_remit_cur_id,
       eepbj.vat_remit_currency,
       eepbj.fx_rate_for_vat,
       eepbj.vat_amount_base_currency,
       eepbj.commission_value,
       eepbj.commission_value_ccy,
       eepbj.attribute1,
       eepbj.attribute2,
       eepbj.attribute3,
       eepbj.attribute4,
       eepbj.attribute5,
       eepbj.process_id,
       eepbj.process,
       eepbj.eod_run_date,
       eepbj.eod_date,
       eepbj.process_run_count,
       eepbj.created_user_id,
       eepbj.created_user_name 
  from eod_eom_phy_booking_journal@eka_eoddb eepbj
    where eepbj.process='EOD';
DROP materialized view MV_BI_PHY_BOOK_JOURNAL_EOM;
DROP table MV_BI_PHY_BOOK_JOURNAL_EOM;

create materialized view MV_BI_PHY_BOOK_JOURNAL_EOM
refresh force on demand
with rowid
as
select eepbj.section_name,
       eepbj.corporate_id,
       eepbj.corporate_name,
       eepbj.product_id,
       eepbj.product_desc,
       eepbj.counter_party_id,
       eepbj.counter_party_name,
       eepbj.invoice_quantity,
       eepbj.invoice_quantity_uom,
       eepbj.fx_base,
       eepbj.profit_center_id,
       eepbj.profit_center,
       eepbj.strategy_id,
       eepbj.strategy_name,
       eepbj.base_cur_id,
       eepbj.base_currency,
       eepbj.invoice_ref_no,
       eepbj.contract_ref_no,
       eepbj.internal_contract_ref_no,
       eepbj.invoice_cur_id,
       eepbj.pay_in_currency,
       eepbj.amount_in_base_cur,
       eepbj.invoice_amt,
       eepbj.invoice_date,
       eepbj.invoice_due_date,
       eepbj.invoice_type,
       eepbj.bill_to_cp_country,
       eepbj.delivery_item_ref_no,
       eepbj.vat_amount,
       eepbj.vat_remit_cur_id,
       eepbj.vat_remit_currency,
       eepbj.fx_rate_for_vat,
       eepbj.vat_amount_base_currency,
       eepbj.commission_value,
       eepbj.commission_value_ccy,
       eepbj.attribute1,
       eepbj.attribute2,
       eepbj.attribute3,
       eepbj.attribute4,
       eepbj.attribute5,
       eepbj.process_id,
       eepbj.process,
       eepbj.eod_run_date,
       eepbj.eod_date,
       eepbj.process_run_count,
       eepbj.created_user_id,
       eepbj.created_user_name
  from eod_eom_phy_booking_journal@eka_eoddb eepbj
    where eepbj.process='EOM';