create or replace view v_bi_tpd_by_fxtrade as
select corporate_id,
       profit_center_id,
       profit_center_name,
       currency_pair_id,
       currency_pair_name,
       currency_pair_id instrument_id,
       currency_pair_name instrument_name,
       today_unrealized,
       today_realized,
       today_total,
       month_unrealized,
       month_realized,
       month_total,
       year_unrealized,
       year_realized,
       year_total,
       base_cur_code,
       base_cur_id
  from mv_trpnl_ccy_by_instrument
