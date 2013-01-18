create or replace view V_BI_MARKET_DATA_DOMAIN as
select to_char(cfq.trade_date, 'dd-Mon-rrrr') trade_date,
       'Currency' data_type,
       pdd.traded_on derivative_type,
       dim.instrument_name instrument_name,
       ps.price_source_name price_source,
       null price_type,
       null price_point,
       cfqd.rate price,
       pdd.derivative_def_name price_unit,
       null option_market_price,
       null delta,
       null gamma,
       null theta,
       null vega,
       drm.prompt_date maturity_date,
       (case
         when nvl(cfqd.is_spot, 'N') = 'Y' then
          'Spot'
         else
          'Forward'
       end) rate_type,
       null valuation_curve,
       null valuation_point,
       null futures_contract,
       null quality_name,
       null month,
       null premium_value
  from cfq_currency_forward_quotes    cfq,
       cfqd_currency_fwd_quote_detail cfqd,
       drm_derivative_master          drm,
       dim_der_instrument_master      dim,
       pdd_product_derivative_def     pdd,
       ps_price_source                ps
 where cfq.cfq_id = cfqd.cfq_id
   and cfqd.dr_id = drm.dr_id
   and cfq.instrument_id = dim.instrument_id
   and cfq.price_source_id = ps.price_source_id
   and dim.product_derivative_id = pdd.derivative_def_id
   and cfqd.is_deleted = 'N'
   and cfq.is_deleted = 'N'
   and dim.is_active = 'Y'
union all
select 
       to_char(dq.trade_date, 'dd-Mon-rrrr') trade_date,
       'Derivatives' data_type,
        pdd.traded_on derivative_type,
        dim.instrument_name instrument_name,
        ps.price_source_name price_source,
        apm.available_price_name price_type,
        pp.price_point_name price_point,
        (case when irm.instrument_type in('Option Put','Option Call','OTC Put Option','OTC Call Option') then
            null 
          else
            dqd.price
          end) price,
        pum.price_unit_name price_unit,
        (case when irm.instrument_type in('Option Put','Option Call','OTC Put Option','OTC Call Option') then
            dqd.price 
          else
            null
          end) option_market_price,
        dqd.delta delta,
        dqd.gamma gamma,
        dqd.theta theta,
        dqd.wega vega,
        drm.prompt_date maturity_date,
        null rate_type,
        null valuation_curve,
        null valuation_point,
        null futures_contract,
        null quality_name,
        null month,
        null premium_value
  from dq_derivative_quotes        dq,
       dqd_derivative_quote_detail dqd,
       drm_derivative_master       drm,
       dim_der_instrument_master   dim,
       irm_instrument_type_master irm,
       pdd_product_derivative_def pdd,       
       ps_price_source             ps,
       apm_available_price_master  apm,
       pum_price_unit_master       pum,
       pp_price_point pp
 where dq.dq_id = dqd.dq_id
   and dq.instrument_id = dim.instrument_id
   and dqd.dr_id = drm.dr_id
   and dim.instrument_type_id = irm.instrument_type_id
   and dim.product_derivative_id = pdd.derivative_def_id  
   and dq.price_source_id = ps.price_source_id
   and dqd.available_price_id = apm.available_price_id
   and dqd.price_unit_id = pum.price_unit_id
   and dq.is_deleted = 'N'
   and dqd.is_deleted = 'N'
   and drm.price_point_id = pp.price_point_id(+)
