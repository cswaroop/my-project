DROP materialized view MV_BI_DERIVATIVE_JOURNAL_EOM;
DROP table MV_BI_DERIVATIVE_JOURNAL_EOM;
create materialized view MV_BI_DERIVATIVE_JOURNAL_EOM
refresh force on demand
as
select edj.internal_derivative_ref_no,
       edj.journal_type,
       edj.book_type,
       edj.corporate_id,
       edj.corporate_name,
       edj.profit_center_id,
       edj.profit_center_name,
       edj.profit_center_short_name,
       edj.catogery,
       edj.derivative_ref_no,
       edj.clearer,
       edj.clearer_id,
       edj.trader,
       edj.strategy_id,
       edj.strategy_name,
       edj.trade_type,
       edj.trade_date,
       edj.product_id,
       edj.product,
       edj.prompt_date,
       edj.quantity,
       edj.quantity_uom,
       edj.trade_price,
       edj.price_unit,
       edj.strike_price,
       edj.strike_price_unit,
       edj.premium_discount,
       edj.put_call,
       edj.pd_price_unit,
       edj.declaration_date,
       edj.clearer_commission,
       edj.average_premium,
       edj.average_from_date,
       edj.average_to_date,
       edj.price_point_name,
       edj.status,
       edj.attribute_1,
       edj.attribute_2,
       edj.attribute_3,
       edj.attribute_4,
       edj.attribute_5,
       edj.eod_eom_date,
       edj.process,
       edj.process_id,
       edj.dbd_id,
       edj.instrument_id,
       edj.instrument_name,
       edj.instrument_type,
       edj.trade_quantity,
       edj.trade_quantity_unit,
       edj.exercised_expired_lots,
       edj.exercised_expired_quantity,
       edj.ext_trade_ref_no,
       edj.int_trade_ref_no,
       edj.master_cont_ref_no,
       edj.clearer_comm_type,
       edj.clearer_comm_perunit,
       edj.clearer_comm_unit,
       edj.exchange,
       edj.remarks,
       tdc.created_date eod_eom_run_date,
       tdc.process_run_count eod_eom_run_count
  from eod_eom_derivative_journal@eka_eoddb edj,
       tdc_trade_date_closure@eka_eoddb     tdc
 where edj.corporate_id = tdc.corporate_id
   and edj.process_id = tdc.process_id
   and edj.process = 'EOM';