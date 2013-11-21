create or replace view v_eod_pagmr as
select corporate_id,
       process_id,
       eod_trade_date,
       product_id,
       product_type,
       contract_type,
       cp_id,
       counterparty_name,
       gmr_ref_no,
       element_id,
       element_name,
       payable_returnable_type,
       assay_content,
       assay_content_unit,
       payable_qty,
       payable_qty_unit_id,
       price,
       price_unit_id,
       price_unit_cur_id,
       price_unit_cur_code,
       pay_in_cur_id,
       pay_in_cur_code,
       payable_amt_price_ccy,
       payable_amt_pay_ccy,
       fx_rate_price_to_pay,
       tranascation_type,
       tcharges_amount,
       rcharges_amount,
       penalty_amount,
       frightcharges_amount,
       othercharges_amount,
       provisional_pymt_pctg,
       internal_gmr_ref_no,
       latest_internal_invoice_ref_no,
       invoice_ref_no,
       warehouse_profile_id,
       warehouse_name,
       is_afloat,
       is_pledge,
       supp_internal_gmr_ref_no,
       supp_gmr_ref_no,
       quality_id,
       quality_name,
       pledged_gmr_ref_nos
  from pa_purchase_accural_gmr@eka_eoddb
/