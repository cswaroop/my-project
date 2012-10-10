create or replace package pkg_phy_custom_reports is
  procedure sp_call_custom_reports(pc_corporate_id    varchar2,
                                   pd_trade_date      date,
                                   pc_process_id      varchar2,
                                   pc_user_id         varchar2,
                                   pc_process         varchar2,
                                   pc_dbd_id          varchar2,
                                   pc_prev_process_id varchar2,
                                   pc_prev_dbd_id     varchar2);
  procedure sp_derivative_booking_journal(pc_corporate_id varchar2,
                                          pd_trade_date   date,
                                          pc_process_id   varchar2,
                                          pc_user_id      varchar2,
                                          pc_process      varchar2,
                                          pc_dbd_id       varchar2);
  procedure sp_physical_booking_journal(pc_corporate_id varchar2,
                                        pd_trade_date   date,
                                        pc_process_id   varchar2,
                                        pc_user_id      varchar2,
                                        pc_process      varchar2,
                                        pc_dbd_id       varchar2);

  procedure sp_derivative_contract_journal(pc_corporate_id varchar2,
                                           pc_process      varchar2,
                                           pd_trade_date   date,
                                           pc_user_id      varchar2,
                                           pc_dbd_id       varchar2,
                                           pc_prev_dbd_id  varchar2);
  procedure sp_physical_contract_journal(pc_corporate_id    varchar2,
                                         pc_process         varchar2,
                                         pd_trade_date      date,
                                         pc_user_id         varchar2,
                                         pc_process_id      varchar2,
                                         pc_dbd_id          varchar2,
                                         pc_prev_dbd_id     varchar2,
                                         pc_prev_process_id varchar2);
  procedure sp_fixation_journal(pc_corporate_id    varchar2,
                                pd_trade_date      date,
                                pc_process_id      varchar2,
                                pc_user_id         varchar2,
                                pc_process         varchar2,
                                pc_dbd_id          varchar2,
                                pc_prev_process_id varchar2);

  function f_get_converted_price_pum(pc_corporate_id       varchar2,
                                     pn_price              number,
                                     pc_from_price_unit_id varchar2,
                                     pc_to_price_unit_id   varchar2,
                                     pd_trade_date         date,
                                     pc_product_id         varchar2)
    return number;
  procedure sp_physical_risk_position(pc_corporate_id varchar2,
                                      pd_trade_date   date,
                                      pc_process      varchar2,
                                      pc_process_id   varchar2,
                                      pc_user_id      varchar2);
  procedure sp_update_strategy_attributes(pc_corporate_id varchar2,
                                          pd_trade_date   date,
                                          pc_process      varchar2,
                                          pc_process_id   varchar2,
                                          pc_user_id      varchar2);

end; 
/
create or replace package body pkg_phy_custom_reports is

  procedure sp_call_custom_reports(pc_corporate_id    varchar2,
                                   pd_trade_date      date,
                                   pc_process_id      varchar2,
                                   pc_user_id         varchar2,
                                   pc_process         varchar2,
                                   pc_dbd_id          varchar2,
                                   pc_prev_process_id varchar2,
                                   pc_prev_dbd_id     varchar2) is
    --------------------------------------------------------------------------------------------------------------------------
    --        Procedure Name                            : sp_call_custom_reports
    --        Author                                    : Siva
    --        Created Date                              : 25-Jul-2012
    --        Purpose                                   : this package is for custom report client specific
    --
    --        Parameters
    --        pc_corporate_id                           : Corporate ID
    --        pd_trade_date                             : Trade Date
    --        pc_user_id                                : User ID
    --        pc_process                                : Process EOD or EOM
    --
    --        Modification History
    --        Modified Date                             :
    --        Modified By                               :
    --        Modify Description                        :
    --------------------------------------------------------------------------------------------------------------------------
    vobj_error_log     tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count number := 1;
    vn_logno           number := 200;
    vc_err_msg         varchar2(200);
  begin
    vn_logno   := vn_logno + 1;
    vc_err_msg := 'sp_derivative_booking_journal ';
    sp_eodeom_process_log(pc_corporate_id,
                          pd_trade_date,
                          pc_process_id,
                          vn_logno,
                          'sp_derivative_booking_journal');
    sp_derivative_booking_journal(pc_corporate_id,
                                  pd_trade_date,
                                  pc_process_id,
                                  pc_user_id,
                                  pc_process,
                                  pc_dbd_id);
    vn_logno   := vn_logno + 1;
    vc_err_msg := 'sp_Physical_booking_journal ';
    sp_eodeom_process_log(pc_corporate_id,
                          pd_trade_date,
                          pc_process_id,
                          vn_logno,
                          'sp_physical_booking_journal');
    sp_physical_booking_journal(pc_corporate_id,
                                pd_trade_date,
                                pc_process_id,
                                pc_user_id,
                                pc_process,
                                pc_dbd_id);
    vn_logno := vn_logno + 1;
    sp_eodeom_process_log(pc_corporate_id,
                          pd_trade_date,
                          pc_process_id,
                          vn_logno,
                          'sp_fixation_journal');
    vc_err_msg := 'sp_fixation_journal ';
    if pkg_process_status.sp_get(pc_corporate_id, pc_process, pd_trade_date) =
       'Cancel' then
      goto cancel_process;
    end if;
    sp_fixation_journal(pc_corporate_id,
                        pd_trade_date,
                        pc_process_id,
                        pc_user_id,
                        pc_process,
                        pc_dbd_id,
                        pc_prev_process_id);
    vc_err_msg := 'sp_physical_contract_journal ';
    vn_logno   := vn_logno + 1;
    sp_eodeom_process_log(pc_corporate_id,
                          pd_trade_date,
                          pc_process_id,
                          vn_logno,
                          'sp_physical_contract_journal');
    sp_physical_contract_journal(pc_corporate_id,
                                 pc_process,
                                 pd_trade_date,
                                 pc_user_id,
                                 pc_process_id,
                                 pc_dbd_id,
                                 pc_prev_dbd_id,
                                 pc_prev_process_id);
  
    vc_err_msg := 'sp_derivative_contract_journal';
    vn_logno   := vn_logno + 1;
    sp_eodeom_process_log(pc_corporate_id,
                          pd_trade_date,
                          pc_process_id,
                          vn_logno,
                          'sp_derivative_contract_journal');
  
    sp_derivative_contract_journal(pc_corporate_id,
                                   pc_process,
                                   pd_trade_date,
                                   pc_user_id,
                                   pc_dbd_id,
                                   pc_prev_dbd_id);
    if pkg_process_status.sp_get(pc_corporate_id, pc_process, pd_trade_date) =
       'Cancel' then
      goto cancel_process;
    end if;
    vn_logno := vn_logno + 1;
    sp_eodeom_process_log(pc_corporate_id,
                          pd_trade_date,
                          pc_process_id,
                          vn_logno,
                          'sp_physical_risk_position');
    sp_physical_risk_position(pc_corporate_id,
                              pd_trade_date,
                              pc_process,
                              pc_process_id,
                              pc_user_id);
  
    commit;
    ----Note:  keep sp_update_strategy_attributes update procedue at end of custom reports call
    sp_update_strategy_attributes(pc_corporate_id,
                                  pd_trade_date,
                                  pc_process,
                                  pc_process_id,
                                  pc_user_id);
    <<cancel_process>>
    dbms_output.put_line('EOD/EOM Process Cancelled while journal calculation');
  exception
    when others then
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure pkg_phy_custom_reports.sp_call_custom_reports',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           ' Message:' ||
                                                           sqlerrm || ' ' ||
                                                           vc_err_msg,
                                                           null,
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
  end;
  procedure sp_derivative_booking_journal(pc_corporate_id varchar2,
                                          pd_trade_date   date,
                                          pc_process_id   varchar2,
                                          pc_user_id      varchar2,
                                          pc_process      varchar2,
                                          pc_dbd_id       varchar2) is
    --------------------------------------------------------------------------------------------------------------------------
    --        Procedure Name                            : sp_derivative_booking_journal
    --        Author                                    : Siva
    --        Created Date                              : 25-Jul-2012
    --        Purpose                                   :
    --
    --        Parameters
    --        pc_corporate_id                           : Corporate ID
    --        pd_trade_date                             : Trade Date
    --        pc_user_id                                : User ID
    --        pc_process                                : Process EOD or EOM
    --
    --        Modification History
    --        Modified Date                             :
    --        Modified By                               :
    --        Modify Description                        :
    --------------------------------------------------------------------------------------------------------------------------
    vobj_error_log     tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count number := 1;
    --  vn_conv_factor              number;
    vn_contract_value           number;
    vn_contract_value_in_base   number;
    vn_clearer_comm_amt         number;
    vn_clearer_comm_amt_in_base number;
    vc_trade_cur_id             varchar2(15);
    vc_trade_main_cur_id        varchar2(15);
    vc_trade_main_cur_code      varchar2(15);
    vn_trade_main_cur_conv_rate number;
    vn_trade_main_decimals      number;
    vn_trade_to_base_fx_rate    number;
    cursor cr_cdc_closeout is
      select dcoh.internal_close_out_ref_no,
             'Deleted' journal_type,
             'Closeout' book_type,
             dcoh.corporate_id,
             akc.corporate_name,
             cpc.profit_center_id,
             cpc.profit_center_name,
             cpc.profit_center_short_name,
             dcoh.close_out_ref_no,
             dcoh.close_out_date,
             dt.internal_derivative_ref_no,
             dt.derivative_ref_no,
             dt.external_ref_no,
             dt.trade_type,
             phd.companyname clearer,
             gab_akc.firstname || ' ' || gab_akc.lastname created,
             dcod.quantity_closed quantity,
             dcod.quantity_unit_id,
             qum.qty_unit quantity_unit,
             (case
               when nvl(dcod.clearer_comm_amt, 0) = 0 then
                nvl(dt.clearer_comm_amt, 0)
               else
                nvl(dcod.clearer_comm_amt, 0)
             end) clearer_comm_amt,
             dt.clearer_comm_cur_id,
             cm_clr.cur_code clearer_comm_cur_code,
             ((case
               when dt.trade_type = 'Sell' then
                1
               else
                -1
             end) * (round((dt.trade_price * dcod.quantity_closed *
                            nvl(pkg_general.f_get_converted_quantity(pdm.product_id,
                                                                      dcod.quantity_unit_id,
                                                                      pum_tp.weight_unit_id,
                                                                      1),
                                 1)),
                            4))) trade_amount,
             pkg_general.f_get_base_cur_id(pum_tp.cur_id) trade_currency,
             1 trade_to_corp_fx_rate,
             0 trade_amount_in_base_ccy,
             0 clearer_comm_in_base_ccy,
             cm_akc.cur_id base_cur_id,
             cm_akc.cur_code base_cur_code,
             pdd.product_id,
             pdm.product_desc,
             dt.trade_price,
             dt.trade_price_unit_id,
             pum_tp.price_unit_name,
             pum_tp.cur_id price_cur_id,
             cm_tp.cur_code price_cur_code,
             pum_tp.weight price_weight,
             pum_tp.weight_unit_id price_weight_unit_id,
             qum_tp.qty_unit price_weight_unit,
             dt.strategy_id
        from dcoh_der_closeout_header    dcoh,
             dcod_der_closeout_detail    dcod,
             dt_derivative_trade         dt,
             phd_profileheaderdetails    phd,
             ak_corporate                akc,
             cpc_corporate_profit_center cpc,
             cm_currency_master          cm_akc,
             cm_currency_master          cm_clr,
             qum_quantity_unit_master    qum,
             drm_derivative_master       drm,
             dim_der_instrument_master   dim,
             pdd_product_derivative_def  pdd,
             pdm_productmaster           pdm,
             pum_price_unit_master       pum_tp,
             qum_quantity_unit_master    qum_tp,
             cm_currency_master          cm_tp,
             ak_corporate_user           akcu,
             gab_globaladdressbook       gab_akc
       where dcoh.internal_close_out_ref_no =
             dcod.internal_close_out_ref_no
         and dcoh.process_id = dcod.process_id
         and dcod.internal_derivative_ref_no =
             dt.internal_derivative_ref_no
         and dcod.process_id = dt.process_id
         and dt.clearer_profile_id = phd.profileid
         and dt.corporate_id = akc.corporate_id
         and dt.profit_center_id = cpc.profit_center_id
         and akc.base_cur_id = cm_akc.cur_id
         and dt.clearer_comm_cur_id = cm_clr.cur_id(+)
         and dcod.quantity_unit_id = qum.qty_unit_id
         and dt.dr_id = drm.dr_id
         and drm.instrument_id = dim.instrument_id
         and dim.product_derivative_id = pdd.derivative_def_id
         and pdd.product_id = pdm.product_id
         and dt.trade_price_unit_id = pum_tp.price_unit_id(+)
         and dcoh.is_rolled_back = 'Y'
         and pum_tp.weight_unit_id = qum_tp.qty_unit_id(+)
         and pum_tp.cur_id = cm_tp.cur_id(+)
         and dcoh.created_by = akcu.user_id
         and akcu.gabid = gab_akc.gabid
         and dt.process_id=pc_process_id 
      union all
      select dcoh.internal_close_out_ref_no,
             'New' journal_type,
             'Closeout' book_type,
             dcoh.corporate_id,
             akc.corporate_name,
             cpc.profit_center_id,
             cpc.profit_center_name,
             cpc.profit_center_short_name,
             dcoh.close_out_ref_no,
             dcoh.close_out_date,
             dt.internal_derivative_ref_no,
             dt.derivative_ref_no,
             dt.external_ref_no,
             dt.trade_type,
             phd.companyname clearer,
             gab_akc.firstname || ' ' || gab_akc.lastname created,
             dcod.quantity_closed quantity,
             dcod.quantity_unit_id,
             qum.qty_unit quantity_unit,
             (case
               when nvl(dcod.clearer_comm_amt, 0) = 0 then
                nvl(dt.clearer_comm_amt, 0)
               else
                nvl(dcod.clearer_comm_amt, 0)
             end) clearer_comm_amt,
             dt.clearer_comm_cur_id,
             cm_clr.cur_code clearer_comm_cur_code,
             ((case
               when dt.trade_type = 'Sell' then
                1
               else
                -1
             end) * (round((dt.trade_price * dcod.quantity_closed *
                            nvl(pkg_general.f_get_converted_quantity(pdm.product_id,
                                                                      dcod.quantity_unit_id,
                                                                      pum_tp.weight_unit_id,
                                                                      1),
                                 1)),
                            4))) trade_amount,
             pkg_general.f_get_base_cur_id(pum_tp.cur_id) trade_currency,
             1 trade_to_corp_fx_rate,
             0 trade_amount_in_base_ccy,
             0 clearer_comm_in_base_ccy,
             cm_akc.cur_id base_cur_id,
             cm_akc.cur_code base_cur_code,
             pdd.product_id,
             pdm.product_desc,
             dt.trade_price,
             dt.trade_price_unit_id,
             pum_tp.price_unit_name,
             pum_tp.cur_id price_cur_id,
             cm_tp.cur_code price_cur_code,
             pum_tp.weight price_weight,
             pum_tp.weight_unit_id price_weight_unit_id,
             qum_tp.qty_unit price_weight_unit,
             dt.strategy_id
        from dcoh_der_closeout_header    dcoh,
             dcod_der_closeout_detail    dcod,
             dt_derivative_trade         dt,
             phd_profileheaderdetails    phd,
             ak_corporate                akc,
             cpc_corporate_profit_center cpc,
             cm_currency_master          cm_akc,
             cm_currency_master          cm_clr,
             qum_quantity_unit_master    qum,
             drm_derivative_master       drm,
             dim_der_instrument_master   dim,
             pdd_product_derivative_def  pdd,
             pdm_productmaster           pdm,
             pum_price_unit_master       pum_tp,
             qum_quantity_unit_master    qum_tp,
             cm_currency_master          cm_tp,
             ak_corporate_user           akcu,
             gab_globaladdressbook       gab_akc
       where dcoh.internal_close_out_ref_no =
             dcod.internal_close_out_ref_no
         and dcoh.process_id = dcod.process_id
         and dcod.internal_derivative_ref_no =
             dt.internal_derivative_ref_no
         and dcod.process_id = dt.process_id
         and dt.clearer_profile_id = phd.profileid
         and dt.corporate_id = akc.corporate_id
         and dt.profit_center_id = cpc.profit_center_id
         and akc.base_cur_id = cm_akc.cur_id
         and dt.clearer_comm_cur_id = cm_clr.cur_id(+)
         and dcod.quantity_unit_id = qum.qty_unit_id
         and dt.dr_id = drm.dr_id
         and drm.instrument_id = dim.instrument_id
         and dim.product_derivative_id = pdd.derivative_def_id
         and pdd.product_id = pdm.product_id
         and dt.trade_price_unit_id = pum_tp.price_unit_id(+)
         and dcoh.is_rolled_back = 'N'
         and pum_tp.weight_unit_id = qum_tp.qty_unit_id(+)
         and pum_tp.cur_id = cm_tp.cur_id(+)
         and dcoh.created_by = akcu.user_id
         and akcu.gabid = gab_akc.gabid
         and dt.process_id=pc_process_id;
  
  begin
    for cr_cdc_row in cr_cdc_closeout
    loop
      vc_trade_cur_id := nvl(cr_cdc_row.price_cur_id,
                             cr_cdc_row.base_cur_id);
      begin
        pkg_general.sp_get_main_cur_detail(vc_trade_cur_id,
                                           vc_trade_main_cur_id,
                                           vc_trade_main_cur_code,
                                           vn_trade_main_cur_conv_rate,
                                           vn_trade_main_decimals);
        vn_contract_value := (cr_cdc_row.trade_price * cr_cdc_row.quantity *
                             nvl(pkg_general.f_get_converted_quantity(cr_cdc_row.product_id,
                                                                       cr_cdc_row.quantity_unit_id,
                                                                       cr_cdc_row.price_weight_unit_id,
                                                                       1),
                                  1)) * vn_trade_main_cur_conv_rate;
      exception
        when others then
          vn_contract_value := 0;
      end;
      vn_contract_value := round(vn_contract_value * (case when cr_cdc_row.trade_type = 'Sell' then 1 else - 1 end), vn_trade_main_decimals);
      begin
        vn_trade_to_base_fx_rate := pkg_general.f_get_converted_currency_amt(pc_corporate_id,
                                                                             vc_trade_main_cur_id,
                                                                             cr_cdc_row.base_cur_id,
                                                                             pd_trade_date,
                                                                             1);
      exception
        when others then
          vn_trade_to_base_fx_rate := 0;
      end;
      vn_clearer_comm_amt := nvl(cr_cdc_row.clearer_comm_amt, 0);
      if cr_cdc_row.clearer_comm_cur_id is not null and
         cr_cdc_row.clearer_comm_cur_id <> cr_cdc_row.base_cur_id then
        vn_clearer_comm_amt_in_base := vn_clearer_comm_amt *
                                       pkg_general.f_get_converted_currency_amt(pc_corporate_id,
                                                                                cr_cdc_row.clearer_comm_cur_id,
                                                                                cr_cdc_row.base_cur_id,
                                                                                pd_trade_date,
                                                                                1);
      else
        vn_clearer_comm_amt_in_base := vn_clearer_comm_amt;
      end if;
      vn_contract_value_in_base := round(nvl(vn_contract_value, 0) *
                                         nvl(vn_trade_to_base_fx_rate, 1),
                                         vn_trade_main_decimals);
      insert into eod_eom_booking_journal
        (internal_close_out_ref_no,
         journal_type,
         book_type,
         corporate_id,
         corporate_name,
         profit_center_id,
         profit_center_name,
         profit_center_short_name,
         close_out_ref_no,
         close_out_date,
         internal_derivative_ref_no,
         derivative_ref_no,
         external_ref_no,
         trade_type,
         clearer,
         created_by,
         quantity,
         quantity_unit_id,
         quantity_unit,
         clearer_comm_amt,
         clearer_comm_cur_id,
         clearer_comm_cur_code,
         trade_amount,
         trade_currency,
         trade_to_corp_fx_rate,
         trade_amount_in_base_ccy,
         clearer_comm_in_base_ccy,
         base_cur_id,
         base_cur_code,
         product_id,
         product_desc,
         eod_eom_date,
         process,
         process_id,
         dbd_id,
         trade_price,
         trade_price_unit_id,
         trade_price_unit,
         price_cur_id,
         price_cur_code,
         price_weight,
         price_weight_unit_id,
         price_weight_unit,
         strategy_id)
      values
        (cr_cdc_row.internal_close_out_ref_no,
         cr_cdc_row.journal_type,
         cr_cdc_row.book_type,
         cr_cdc_row.corporate_id,
         cr_cdc_row.corporate_name,
         cr_cdc_row.profit_center_id,
         cr_cdc_row.profit_center_name,
         cr_cdc_row.profit_center_short_name,
         cr_cdc_row.close_out_ref_no,
         cr_cdc_row.close_out_date,
         cr_cdc_row.internal_derivative_ref_no,
         cr_cdc_row.derivative_ref_no,
         cr_cdc_row.external_ref_no,
         cr_cdc_row.trade_type,
         cr_cdc_row.clearer,
         cr_cdc_row.created,
         cr_cdc_row.quantity,
         cr_cdc_row.quantity_unit_id,
         cr_cdc_row.quantity_unit,
         vn_clearer_comm_amt, --by variable
         cr_cdc_row.clearer_comm_cur_id,
         cr_cdc_row.clearer_comm_cur_code,
         vn_contract_value, --by variable
         vc_trade_main_cur_code,
         vn_trade_to_base_fx_rate, --by variable
         vn_contract_value_in_base, --by variable
         vn_clearer_comm_amt_in_base, --by variable
         cr_cdc_row.base_cur_id,
         cr_cdc_row.base_cur_code,
         cr_cdc_row.product_id,
         cr_cdc_row.product_desc,
         pd_trade_date,
         pc_process,
         pc_process_id,
         pc_dbd_id,
         cr_cdc_row.trade_price,
         cr_cdc_row.trade_price_unit_id,
         cr_cdc_row.price_unit_name,
         cr_cdc_row.price_cur_id,
         cr_cdc_row.price_cur_code,
         cr_cdc_row.price_weight,
         cr_cdc_row.price_weight_unit_id,
         cr_cdc_row.price_weight_unit,
         cr_cdc_row.strategy_id);
    end loop;
  exception
    when others then
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure sp_derivative_journal',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           ' Message:' ||
                                                           sqlerrm,
                                                           null,
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
  end;

  procedure sp_physical_booking_journal(pc_corporate_id varchar2,
                                        pd_trade_date   date,
                                        pc_process_id   varchar2,
                                        pc_user_id      varchar2,
                                        pc_process      varchar2,
                                        pc_dbd_id       varchar2) is
    --------------------------------------------------------------------------------------------------------------------------
    --        Procedure Name                            : sp_Physical_booking_journal
    --        Author                                    : Ashok
    --        Created Date                              : 25-Jul-2012
    --        Purpose                                   :
    --
    --        Parameters
    --        pc_corporate_id                           : Corporate ID
    --        pd_trade_date                             : Trade Date
    --        pc_user_id                                : User ID
    --        pc_process                                : Process EOD or EOM
    --
    --        Modification History
    --        Modified Date                             :
    --        Modified By                               :
    --        Modify Description                        :
    --------------------------------------------------------------------------------------------------------------------------
    vobj_error_log     tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count number := 1;
  begin
  delete from temp_ii  ii where ii.corporate_id=pc_corporate_id;
  commit;
 insert into temp_ii
   (corporate_id, internal_invoice_ref_no, delivery_item_ref_no)
   select pc_corporate_id,
          iid.internal_invoice_ref_no,
          ii.delivery_item_ref_no
     from iid_invoicable_item_details iid,
          ii_invoicable_item          ii,
          is_invoice_summary          iss
    where ii.invoicable_item_id = iid.invoicable_item_id
    and iss.internal_invoice_ref_no=iid.internal_invoice_ref_no
    and iss.process_id=pc_process_id
    and iss.is_active='Y'
    and iid.is_active='Y'
    and ii.is_active='Y'   
    group by iid.internal_invoice_ref_no,
             ii.delivery_item_ref_no;
   commit;
      for cc_phy in (select 'New' section_name,
                            iss.corporate_id,
                            akc.corporate_name,
                            pdm.product_id,
                            pdm.product_desc,
                            pcm.cp_id counter_party_id,
                            phd_contract_cp.companyname counter_party_name,
                            iss.invoiced_qty invoice_quantity,
                            qum.qty_unit invoice_quantity_uom,
                            nvl(iss.fx_to_base, 1) fx_base,
                            nvl(cpc.profit_center_id, cpc1.profit_center_id) profit_center_id,
                            nvl(cpc.profit_center_short_name,
                                cpc1.profit_center_short_name) profit_center,
                            pcpd.strategy_id,
                            css.strategy_name,
                            akc.base_cur_id,
                            cm_akc_base_cur.cur_code base_currency,
                            nvl(iss.invoice_ref_no, 'NA') as invoice_ref_no,
                            nvl(pcm.contract_ref_no, 'NA') contract_ref_no,
                            nvl(pcm.internal_contract_ref_no, 'NA') internal_contract_ref_no,
                            iss.invoice_cur_id invoice_cur_id,
                            cm_p.cur_code pay_in_currency,
                            round(iss.total_amount_to_pay, 4) *
                            nvl(iss.fx_to_base, 1) *
                            (case
                               when nvl(iss.payable_receivable, 'NA') =
                                    'Payable' then
                                -1
                               when nvl(iss.payable_receivable, 'NA') =
                                    'Receivable' then
                                1
                               when nvl(iss.payable_receivable, 'NA') = 'NA' then
                                (case
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceReceived' then
                                -1
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceRaised' then
                                1
                               else
                                (case
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Raised' then
                                1
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Received' then
                                -1
                               else
                                1
                             end) end) else 1 end) amount_in_base_cur,
                            round(iss.total_amount_to_pay, 4) * case
                              when (iss.invoice_type = 'Commercial' or
                                   iss.invoice_type = 'DebitCredit') then
                               1
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Received' then
                               -1
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Raised' then
                               1
                              when nvl(iss.invoice_type_name, 'NA') =
                                   'AdvancePayment' and
                                   pcm.purchase_sales = 'P' then
                               -1
                              when nvl(iss.invoice_type_name, 'NA') =
                                   'AdvancePayment' and
                                   pcm.purchase_sales = 'S' then
                               1
                            end invoice_amt,
                            iss.invoice_issue_date invoice_date,
                            iss.payment_due_date invoice_due_date,
                            iss.invoice_type_name invoice_type,
                            iss.bill_to_address bill_to_cp_country,
                            pcm.contract_ref_no || '-' ||
                            ii.delivery_item_ref_no delivery_item_ref_no,
                            ivd.vat_amount_in_vat_cur vat_amount,
                            ivd.vat_remit_cur_id,
                            cm_vat.cur_code vat_remit_currency,
                            (nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) fx_rate_for_vat,
                            (ivd.vat_amount_in_vat_cur *
                            nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) vat_amount_base_currency,
                            null commission_value,
                            null commission_value_ccy,
                            null attribute1,
                            null attribute2,
                            null attribute3,
                            null attribute4,
                            null attribute5,
                            tdc.process_id,
                            tdc.created_date eod_run_date,
                            tdc.trade_date eod_date,
                            tdc.process_run_count
                       from is_invoice_summary                      iss,
                            cm_currency_master                      cm_p,
                            incm_invoice_contract_mapping@eka_appdb incm,
                            ivd_invoice_vat_details@eka_appdb       ivd,
                            pcm_physical_contract_main              pcm,
                            temp_ii                                 ii,
                          --  pcdi_pc_delivery_item                   pcdi,
                            ak_corporate                            akc,
                            cpc_corporate_profit_center             cpc,
                            cpc_corporate_profit_center             cpc1,
                            pcpd_pc_product_definition              pcpd,
                            cm_currency_master                      cm_akc_base_cur,
                            cm_currency_master                      cm_vat,
                            pdm_productmaster                       pdm,
                            phd_profileheaderdetails                phd_contract_cp,
                            qum_quantity_unit_master                qum,
                            tdc_trade_date_closure                  tdc,
                            css_corporate_strategy_setup            css
                      where iss.is_active = 'Y'
                        and iss.corporate_id is not null
                        and iss.internal_invoice_ref_no =
                            incm.internal_invoice_ref_no(+)
                        and iss.internal_invoice_ref_no =
                            ivd.internal_invoice_ref_no(+)
                        and incm.internal_contract_ref_no =
                            pcm.internal_contract_ref_no(+)
                        /*and pcdi.internal_contract_ref_no =
                            pcm.internal_contract_ref_no*/
                        and ii.internal_invoice_ref_no=iss.internal_invoice_ref_no 
                        and ii.corporate_id=iss.corporate_id 
                        and iss.corporate_id = akc.corporate_id
                        and iss.internal_contract_ref_no =
                            pcpd.internal_contract_ref_no
                        and iss.profit_center_id = cpc.profit_center_id(+)
                        and pcpd.profit_center_id = cpc1.profit_center_id(+)
                        and iss.invoice_cur_id = cm_p.cur_id(+)
                        and pcpd.product_id = pdm.product_id(+)
                        and phd_contract_cp.profileid(+) = iss.cp_id
                        and nvl(pcm.partnership_type, 'Normal') = 'Normal'
                       -- and qum.qty_unit_id = pcdi.qty_unit_id
                        and qum.qty_unit_id=iss.invoiced_qty_unit_id(+)
                        and iss.is_inv_draft = 'N'
                        and iss.invoice_type_name not in('Profoma','Service')
                        and cm_akc_base_cur.cur_id = akc.base_cur_id
                        and cm_vat.cur_id(+) = ivd.vat_remit_cur_id
                        and pcpd.input_output = 'Input'
                        and nvl(iss.total_amount_to_pay, 0) <> 0
                        and pcpd.strategy_id = css.strategy_id
                        and css.is_active = 'Y'
                        and iss.process_id = tdc.process_id
                        and iss.corporate_id = tdc.corporate_id
                        and iss.process_id = pc_process_id
                        and cm_p.is_active = 'Y'
                        and pcm.process_id = pc_process_id
                      --  and pcdi.process_id = pc_process_id
                        and pcpd.process_id = pc_process_id
                        and cm_akc_base_cur.is_active = 'Y'
                        and nvl(cm_vat.is_active, 'Y') = 'Y'
                        and pdm.is_active = 'Y'
                        and phd_contract_cp.is_active = 'Y'
                        and qum.is_active = 'Y'
                        and tdc.process_id = pc_process_id
                        and iss.is_invoice_new = 'Y'
                        and pcm.corporate_id = pc_corporate_id
                        and tdc.process = pc_process
                        and tdc.corporate_id = pc_corporate_id
                        and iss.corporate_id = pc_corporate_id
                     
                     ---2 Service invoices
                     union all
                     select 'New' section_name,
                            iss.corporate_id,
                            ak.corporate_name,
                            nvl(pdm.product_id, 'NA'),
                            nvl(pdm.product_desc, 'NA'),
                            iss.cp_id counter_party_id,
                            phd_cp.companyname counter_party_name,
                            iss.invoiced_qty invoice_quantity,
                            nvl(qum.qty_unit, 'MT') invoice_quantity_uom,
                            nvl(iss.fx_to_base, 1) fx_base,
                            coalesce(cpc.profit_center_id,
                                     cpc1.profit_center_id,
                                     'NA') profit_center_id,
                            coalesce(cpc.profit_center_short_name,
                                     cpc1.profit_center_short_name,
                                     'NA') profit_center,
                            pcpd.strategy_id,
                            css.strategy_name,
                            ak.base_cur_id,
                            cm_akc_base_cur.cur_code base_currency,
                            nvl(iss.invoice_ref_no, 'NA') as invoice_ref_no,
                            nvl(pcm.contract_ref_no, 'NA') contract_ref_no,
                            nvl(pcm.internal_contract_ref_no, 'NA') internal_contract_ref_no,
                            iss.invoice_cur_id invoice_cur_id,
                            cm_p.cur_code pay_in_currency,
                            round(iss.total_amount_to_pay, 4) *
                            nvl(iss.fx_to_base, 1) *
                            (case
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceReceived' then
                                -1
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceRaised' then
                                1
                               else
                                (case
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Raised' then
                                1
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Received' then
                                -1
                               else
                                1
                             end) end) amount_in_base_cur,
                            round(iss.total_amount_to_pay, 4) * case
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Received' then
                               -1
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Raised' then
                               1
                            end invoice_amt,
                            iss.invoice_issue_date invoice_date,
                            iss.payment_due_date invoice_due_date,
                            nvl(iss.invoice_type_name, 'NA') invoice_type,
                            iss.bill_to_address bill_to_cp_country,
                            pcm.contract_ref_no || '-' ||
                            ii.delivery_item_ref_no delivery_item_ref_no,
                            ivd.vat_amount_in_vat_cur vat_amount,
                            nvl(ivd.vat_remit_cur_id, 'NA'),
                            nvl(cm_vat.cur_code, 'NA') vat_remit_currency,
                            (nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) fx_rate_for_vat,
                            (ivd.vat_amount_in_vat_cur *
                            nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) vat_amount_base_currency,
                            null commission_value,
                            null commission_value_ccy,
                            null attribute1,
                            null attribute2,
                            null attribute3,
                            null attribute4,
                            null attribute5,
                            tdc.process_id,
                            tdc.created_date eod_run_date,
                            tdc.trade_date eod_date,
                            tdc.process_run_count
                       from is_invoice_summary                iss,
                            iam_invoice_action_mapping        iam,
                            iid_invoicable_item_details       iid,
                            axs_action_summary                axs,
                            cs_cost_store                     cs,
                            ivd_invoice_vat_details@eka_appdb ivd,
                            cigc_contract_item_gmr_cost       cigc,
                            gmr_goods_movement_record         gmr,
                            pcpd_pc_product_definition        pcpd,
                            pcm_physical_contract_main        pcm,
                            temp_ii                           ii,
                           -- pcdi_pc_delivery_item             pcdi,
                            ak_corporate                      ak,
                            ak_corporate_user                 akcu,
                            cpc_corporate_profit_center       cpc,
                            cpc_corporate_profit_center       cpc1,
                            phd_profileheaderdetails          phd_cp,
                            cm_currency_master                cm_akc_base_cur,
                            cm_currency_master                cm_vat,
                            cm_currency_master                cm_p,
                            pdm_productmaster                 pdm,
                            qum_quantity_unit_master          qum,
                            tdc_trade_date_closure            tdc,
                            css_corporate_strategy_setup      css
                      where iss.internal_contract_ref_no is null
                        and iss.is_active = 'Y'
                        and iss.internal_invoice_ref_no =
                            iam.internal_invoice_ref_no
                        and iss.internal_invoice_ref_no =
                            iid.internal_invoice_ref_no(+)
                        and iss.internal_invoice_ref_no =
                            ivd.internal_invoice_ref_no(+)
                        and iam.invoice_action_ref_no =
                            axs.internal_action_ref_no
                        and iam.invoice_action_ref_no =
                            cs.internal_action_ref_no(+)
                        and cs.cog_ref_no = cigc.cog_ref_no(+)
                        and cigc.internal_gmr_ref_no =
                            gmr.internal_gmr_ref_no(+)
                        and gmr.internal_contract_ref_no =
                            pcpd.internal_contract_ref_no(+)
                        and pcpd.internal_contract_ref_no =
                            pcm.internal_contract_ref_no(+)
                        and ii.internal_invoice_ref_no=iss.internal_invoice_ref_no
                        and ii.corporate_id=iss.corporate_id    
                      /*  and pcm.internal_contract_ref_no =
                            pcdi.internal_contract_ref_no(+)*/
                      --  and qum.qty_unit_id(+) = pcdi.qty_unit_id
                        and qum.qty_unit_id(+) = iss.invoiced_qty_unit_id(+)
                        and pcm.trader_id = akcu.user_id(+)
                        and pcpd.input_output(+) = 'Input'
                        and iss.invoice_type_name ='Service'
                        and iss.corporate_id = ak.corporate_id
                        and iss.profit_center_id = cpc.profit_center_id(+)
                        and pcpd.profit_center_id = cpc1.profit_center_id(+)
                        and iss.cp_id = phd_cp.profileid
                        and cm_akc_base_cur.cur_id = ak.base_cur_id
                        and iss.invoice_cur_id = cm_p.cur_id(+)
                        and pcpd.product_id = pdm.product_id(+)
                        and cm_vat.cur_id(+) = ivd.vat_remit_cur_id
                        and pcpd.strategy_id = css.strategy_id
                        and css.is_active = 'Y'
                        and iss.process_id = tdc.process_id
                        and iss.corporate_id = tdc.corporate_id
                        and iss.process_id = pc_process_id
                        and cm_p.is_active = 'Y'
                        and pcm.process_id = pc_process_id
                      --  and pcdi.process_id = pc_process_id
                        and pcpd.process_id = pc_process_id
                        and cm_akc_base_cur.is_active = 'Y'
                        and nvl(cm_vat.is_active, 'Y') = 'Y'
                        and pdm.is_active = 'Y'
                        and phd_cp.is_active = 'Y'
                        and qum.is_active = 'Y'
                        and tdc.process_id = pc_process_id
                        and iss.is_invoice_new = 'Y'
                        and pcm.corporate_id = pc_corporate_id
                        and tdc.process = pc_process
                        and tdc.corporate_id = pc_corporate_id
                        and iss.corporate_id = pc_corporate_id
                     
                      group by pdm.product_id,
                               pdm.product_desc,
                               iss.corporate_id,
                               iss.cp_id,
                               iss.invoiced_qty,
                               iss.fx_to_base,
                               pcm.contract_ref_no,
                               pcm.internal_contract_ref_no,
                               --pcdi.pcdi_id,
                               iss.invoice_type,
                               iss.invoice_ref_no,
                               iss.total_amount_to_pay,
                               iss.recieved_raised_type,
                               iss.bill_to_address,
                               iss.invoice_cur_id,
                               iss.invoice_issue_date,
                               iss.payment_due_date,
                               iss.invoice_type_name,
                               ak.corporate_name,
                               ak.base_cur_id,
                               phd_cp.companyname,
                               cpc.profit_center_id,
                               cpc.profit_center_short_name,
                               cpc1.profit_center_id,
                               cpc1.profit_center_short_name,
                               cm_akc_base_cur.cur_code,
                               cm_p.cur_code,
                               pcm.purchase_sales,
                               qum.qty_unit,
                               ivd.vat_amount_in_vat_cur,
                               ivd.vat_remit_cur_id,
                               cm_vat.cur_code,
                               ivd.fx_rate_vc_ic,
                               tdc.created_date,
                               tdc.trade_date,
                               tdc.process_run_count,
                               tdc.process_id,
                               --pcdi.delivery_item_no,
                               ii.delivery_item_ref_no,
                               pcpd.strategy_id,
                               css.strategy_name
                     union all
                     --For Cancelled INV
                     select 'Delete' section_name,
                            iss.corporate_id,
                            akc.corporate_name,
                            pdm.product_id,
                            pdm.product_desc,
                            pcm.cp_id counter_party_id,
                            phd_contract_cp.companyname counter_party_name,
                            iss.invoiced_qty invoice_quantity,
                            qum.qty_unit invoice_quantity_uom,
                            nvl(iss.fx_to_base, 1) fx_base,
                            nvl(cpc.profit_center_id, cpc1.profit_center_id) profit_center_id,
                            nvl(cpc.profit_center_short_name,
                                cpc1.profit_center_short_name) profit_center,
                            pcpd.strategy_id,
                            css.strategy_name,
                            akc.base_cur_id,
                            cm_akc_base_cur.cur_code base_currency,
                            nvl(iss.invoice_ref_no, 'NA') as invoice_ref_no,
                            nvl(pcm.contract_ref_no, 'NA') contract_ref_no,
                            nvl(pcm.internal_contract_ref_no, 'NA') internal_contract_ref_no,
                            iss.invoice_cur_id invoice_cur_id,
                            cm_p.cur_code pay_in_currency,
                            round(iss.total_amount_to_pay, 4) *
                            nvl(iss.fx_to_base, 1) *
                            (case
                               when nvl(iss.payable_receivable, 'NA') =
                                    'Payable' then
                                -1
                               when nvl(iss.payable_receivable, 'NA') =
                                    'Receivable' then
                                1
                               when nvl(iss.payable_receivable, 'NA') = 'NA' then
                                (case
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceReceived' then
                                -1
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceRaised' then
                                1
                               else
                                (case
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Raised' then
                                1
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Received' then
                                -1
                               else
                                1
                             end) end) else 1 end) amount_in_base_cur,
                            round(iss.total_amount_to_pay, 4) * case
                              when (iss.invoice_type = 'Commercial' or
                                   iss.invoice_type = 'DebitCredit') then
                               1
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Received' then
                               -1
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Raised' then
                               1
                              when nvl(iss.invoice_type_name, 'NA') =
                                   'AdvancePayment' and
                                   pcm.purchase_sales = 'P' then
                               -1
                              when nvl(iss.invoice_type_name, 'NA') =
                                   'AdvancePayment' and
                                   pcm.purchase_sales = 'S' then
                               1
                            end invoice_amt,
                            iss.invoice_issue_date invoice_date,
                            iss.payment_due_date invoice_due_date,
                            iss.invoice_type_name invoice_type,
                            iss.bill_to_address bill_to_cp_country,
                            pcm.contract_ref_no || '-' ||
                            ii.delivery_item_ref_no delivery_item_ref_no,
                            ivd.vat_amount_in_vat_cur vat_amount,
                            ivd.vat_remit_cur_id,
                            cm_vat.cur_code vat_remit_currency,
                            (nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) fx_rate_for_vat,
                            (ivd.vat_amount_in_vat_cur *
                            nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) vat_amount_base_currency,
                            null commission_value,
                            null commission_value_ccy,
                            null attribute1,
                            null attribute2,
                            null attribute3,
                            null attribute4,
                            null attribute5,
                            tdc.process_id,
                            tdc.created_date eod_run_date,
                            tdc.trade_date eod_date,
                            tdc.process_run_count
                       from is_invoice_summary                      iss,
                            cm_currency_master                      cm_p,
                            incm_invoice_contract_mapping@eka_appdb incm,
                            ivd_invoice_vat_details@eka_appdb       ivd,
                            pcm_physical_contract_main              pcm,
                            temp_ii                                 ii,
                           -- pcdi_pc_delivery_item                   pcdi,
                            ak_corporate                            akc,
                            cpc_corporate_profit_center             cpc,
                            cpc_corporate_profit_center             cpc1,
                            pcpd_pc_product_definition              pcpd,
                            cm_currency_master                      cm_akc_base_cur,
                            cm_currency_master                      cm_vat,
                            pdm_productmaster                       pdm,
                            phd_profileheaderdetails                phd_contract_cp,
                            qum_quantity_unit_master                qum,
                            tdc_trade_date_closure                  tdc,
                            css_corporate_strategy_setup            css
                      where iss.is_active = 'N'
                        and iss.is_cancelled_today = 'Y'
                        and iss.corporate_id is not null
                        and iss.internal_invoice_ref_no =
                            incm.internal_invoice_ref_no(+)
                        and iss.internal_invoice_ref_no =
                            ivd.internal_invoice_ref_no(+)
                        and incm.internal_contract_ref_no =
                            pcm.internal_contract_ref_no(+)
                        /*and pcdi.internal_contract_ref_no =
                            pcm.internal_contract_ref_no*/
                        and iss.internal_invoice_ref_no=ii.internal_invoice_ref_no
                        and iss.corporate_id=ii.corporate_id    
                        and iss.corporate_id = akc.corporate_id
                        and iss.internal_contract_ref_no =
                            pcpd.internal_contract_ref_no
                        and iss.profit_center_id = cpc.profit_center_id(+)
                        and pcpd.profit_center_id = cpc1.profit_center_id(+)
                        and iss.invoice_cur_id = cm_p.cur_id(+)
                        and pcpd.product_id = pdm.product_id(+)
                        and phd_contract_cp.profileid(+) = iss.cp_id
                        and nvl(pcm.partnership_type, 'Normal') = 'Normal'
                        --and qum.qty_unit_id = pcdi.qty_unit_id
                        and qum.qty_unit_id = iss.invoiced_qty_unit_id(+)
                        and iss.is_inv_draft = 'N'
                        and iss.invoice_type_name not in('Profoma','Service')
                        and cm_akc_base_cur.cur_id = akc.base_cur_id
                        and cm_vat.cur_id(+) = ivd.vat_remit_cur_id
                        and pcpd.input_output = 'Input'
                        and nvl(iss.total_amount_to_pay, 0) <> 0
                        and pcpd.strategy_id = css.strategy_id
                        and css.is_active = 'Y'
                        and iss.process_id = tdc.process_id
                        and iss.corporate_id = tdc.corporate_id
                        and iss.process_id = pc_process_id
                        and cm_p.is_active = 'Y'
                        and pcm.process_id = pc_process_id
                       -- and pcdi.process_id = pc_process_id
                        and pcpd.process_id = pc_process_id
                        and cm_akc_base_cur.is_active = 'Y'
                        and nvl(cm_vat.is_active, 'Y') = 'Y'
                        and pdm.is_active = 'Y'
                        and phd_contract_cp.is_active = 'Y'
                        and qum.is_active = 'Y'
                        and tdc.process_id = pc_process_id
                        and pcm.corporate_id = pc_corporate_id
                        and tdc.process = pc_process
                        and tdc.corporate_id = pc_corporate_id
                        and iss.corporate_id = pc_corporate_id
                     
                     ---2 Service invoices
                     --For Cancelled INV
                     union all
                     select 'Delete' section_name,
                            iss.corporate_id,
                            ak.corporate_name,
                            nvl(pdm.product_id, 'NA'),
                            nvl(pdm.product_desc, 'NA'),
                            iss.cp_id counter_party_id,
                            phd_cp.companyname counter_party_name,
                            iss.invoiced_qty invoice_quantity,
                            nvl(qum.qty_unit, 'MT') invoice_quantity_uom,
                            nvl(iss.fx_to_base, 1) fx_base,
                            coalesce(cpc.profit_center_id,
                                     cpc1.profit_center_id,
                                     'NA') profit_center_id,
                            coalesce(cpc.profit_center_short_name,
                                     cpc1.profit_center_short_name,
                                     'NA') profit_center,
                            pcpd.strategy_id,
                            css.strategy_name,
                            ak.base_cur_id,
                            cm_akc_base_cur.cur_code base_currency,
                            nvl(iss.invoice_ref_no, 'NA') as invoice_ref_no,
                            nvl(pcm.contract_ref_no, 'NA') contract_ref_no,
                            nvl(pcm.internal_contract_ref_no, 'NA') internal_contract_ref_no,
                            iss.invoice_cur_id invoice_cur_id,
                            cm_p.cur_code pay_in_currency,
                            round(iss.total_amount_to_pay, 4) *
                            nvl(iss.fx_to_base, 1) *
                            (case
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceReceived' then
                                -1
                               when nvl(iss.invoice_type_name, 'NA') =
                                    'ServiceInvoiceRaised' then
                                1
                               else
                                (case
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Raised' then
                                1
                               when nvl(iss.recieved_raised_type, 'NA') =
                                    'Received' then
                                -1
                               else
                                1
                             end) end) amount_in_base_cur,
                            round(iss.total_amount_to_pay, 4) * case
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Received' then
                               -1
                              when nvl(iss.invoice_type, 'NA') = 'Service' and
                                   nvl(iss.recieved_raised_type, 'NA') =
                                   'Raised' then
                               1
                            end invoice_amt,
                            iss.invoice_issue_date invoice_date,
                            iss.payment_due_date invoice_due_date,
                            nvl(iss.invoice_type_name, 'NA') invoice_type,
                            iss.bill_to_address bill_to_cp_country,
                            pcm.contract_ref_no || '-' ||
                            ii.delivery_item_ref_no delivery_item_ref_no,
                            ivd.vat_amount_in_vat_cur vat_amount,
                            nvl(ivd.vat_remit_cur_id, 'NA'),
                            nvl(cm_vat.cur_code, 'NA') vat_remit_currency,
                            (nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) fx_rate_for_vat,
                            (ivd.vat_amount_in_vat_cur *
                            nvl(ivd.fx_rate_vc_ic, 1) *
                            nvl(iss.fx_to_base, 1)) vat_amount_base_currency,
                            null commission_value,
                            null commission_value_ccy,
                            null attribute1,
                            null attribute2,
                            null attribute3,
                            null attribute4,
                            null attribute5,
                            tdc.process_id,
                            tdc.created_date eod_run_date,
                            tdc.trade_date eod_date,
                            tdc.process_run_count
                       from is_invoice_summary                iss,
                            iam_invoice_action_mapping        iam,
                            iid_invoicable_item_details       iid,
                            axs_action_summary                axs,
                            cs_cost_store                     cs,
                            ivd_invoice_vat_details@eka_appdb ivd,
                            cigc_contract_item_gmr_cost       cigc,
                            gmr_goods_movement_record         gmr,
                            pcpd_pc_product_definition        pcpd,
                            pcm_physical_contract_main        pcm,
                           -- pcdi_pc_delivery_item             pcdi,
                            temp_ii                           ii,
                            ak_corporate                      ak,
                            ak_corporate_user                 akcu,
                            cpc_corporate_profit_center       cpc,
                            cpc_corporate_profit_center       cpc1,
                            phd_profileheaderdetails          phd_cp,
                            cm_currency_master                cm_akc_base_cur,
                            cm_currency_master                cm_vat,
                            cm_currency_master                cm_p,
                            pdm_productmaster                 pdm,
                            qum_quantity_unit_master          qum,
                            tdc_trade_date_closure            tdc,
                            css_corporate_strategy_setup      css
                      where iss.internal_contract_ref_no is null
                        and iss.is_active = 'N'
                        and iss.is_cancelled_today = 'Y'
                        and iss.internal_invoice_ref_no =
                            iam.internal_invoice_ref_no
                        and iss.internal_invoice_ref_no =
                            iid.internal_invoice_ref_no(+)
                        and iss.internal_invoice_ref_no =
                            ivd.internal_invoice_ref_no(+)
                        and iam.invoice_action_ref_no =
                            axs.internal_action_ref_no
                        and iam.invoice_action_ref_no =
                            cs.internal_action_ref_no(+)
                        and cs.cog_ref_no = cigc.cog_ref_no(+)
                        and cigc.internal_gmr_ref_no =
                            gmr.internal_gmr_ref_no(+)
                        and gmr.internal_contract_ref_no =
                            pcpd.internal_contract_ref_no(+)
                        and pcpd.internal_contract_ref_no =
                            pcm.internal_contract_ref_no(+)
                        /*and pcm.internal_contract_ref_no =
                            pcdi.internal_contract_ref_no(+)*/                    
                        and ii.internal_invoice_ref_no=iss.internal_invoice_ref_no
                        and ii.corporate_id=iss.corporate_id
                           -- and qum.qty_unit_id(+) = pcdi.qty_unit_id
                        and qum.qty_unit_id(+) =iss.invoiced_qty_unit_id(+)
                        and pcm.trader_id = akcu.user_id(+)
                        and pcpd.input_output(+) = 'Input'
                         and iss.invoice_type_name='Service'
                        and iss.corporate_id = ak.corporate_id
                        and iss.profit_center_id = cpc.profit_center_id(+)
                        and pcpd.profit_center_id = cpc1.profit_center_id(+)
                        and iss.cp_id = phd_cp.profileid
                        and cm_akc_base_cur.cur_id = ak.base_cur_id
                        and iss.invoice_cur_id = cm_p.cur_id(+)
                        and pcpd.product_id = pdm.product_id(+)
                        and cm_vat.cur_id(+) = ivd.vat_remit_cur_id
                        and pcpd.strategy_id = css.strategy_id
                        and css.is_active = 'Y'
                        and iss.process_id = tdc.process_id
                        and iss.corporate_id = tdc.corporate_id
                        and iss.process_id = pc_process_id
                        and cm_p.is_active = 'Y'
                        and pcm.process_id = pc_process_id
                      --  and pcdi.process_id = pc_process_id
                        and pcpd.process_id = pc_process_id
                        and cm_akc_base_cur.is_active = 'Y'
                        and nvl(cm_vat.is_active, 'Y') = 'Y'
                        and pdm.is_active = 'Y'
                        and phd_cp.is_active = 'Y'
                        and qum.is_active = 'Y'
                        and tdc.process_id = pc_process_id
                        and pcm.corporate_id = pc_corporate_id
                        and tdc.process = pc_process
                        and tdc.corporate_id = pc_corporate_id
                        and iss.corporate_id = pc_corporate_id
                     
                      group by pdm.product_id,
                               pdm.product_desc,
                               iss.corporate_id,
                               iss.cp_id,
                               iss.invoiced_qty,
                               iss.fx_to_base,
                               pcm.contract_ref_no,
                               pcm.internal_contract_ref_no,
                              -- pcdi.pcdi_id,
                               iss.invoice_type,
                               iss.invoice_ref_no,
                               iss.total_amount_to_pay,
                               iss.recieved_raised_type,
                               iss.invoice_cur_id,
                               iss.invoice_issue_date,
                               iss.payment_due_date,
                               iss.invoice_type_name,
                               iss.bill_to_address,
                               ak.corporate_name,
                               ak.base_cur_id,
                               phd_cp.companyname,
                               cpc.profit_center_id,
                               cpc.profit_center_short_name,
                               cpc1.profit_center_id,
                               cpc1.profit_center_short_name,
                               cm_akc_base_cur.cur_code,
                               cm_p.cur_code,
                               pcm.purchase_sales,
                               qum.qty_unit,
                               ivd.vat_amount_in_vat_cur,
                               ivd.vat_remit_cur_id,
                               cm_vat.cur_code,
                               ivd.fx_rate_vc_ic,
                               tdc.created_date,
                               tdc.trade_date,
                               tdc.process_run_count,
                               tdc.process_id,
                               ii.delivery_item_ref_no,
                            --   pcdi.delivery_item_no,
                               pcpd.strategy_id,
                               css.strategy_name) loop 
     insert into eod_eom_phy_booking_journal
       (section_name,
        corporate_id,
        corporate_name,
        product_id,
        product_desc,
        counter_party_id,
        counter_party_name,
        invoice_quantity,
        invoice_quantity_uom,
        fx_base,
        profit_center_id,
        profit_center,
        strategy_id,
        strategy_name,
        base_cur_id,
        base_currency,
        invoice_ref_no,
        contract_ref_no,
        internal_contract_ref_no,
        invoice_cur_id,
        pay_in_currency,
        amount_in_base_cur,
        invoice_amt,
        invoice_date,
        invoice_due_date,
        invoice_type,
        bill_to_cp_country,
        delivery_item_ref_no,
        vat_amount,
        vat_remit_cur_id,
        vat_remit_currency,
        fx_rate_for_vat,
        vat_amount_base_currency,
        commission_value,
        commission_value_ccy,
        attribute1,
        attribute2,
        attribute3,
        attribute4,
        attribute5,
        process_id,
        process,
        eod_run_date,
        eod_date,
        process_run_count)
     values
       (cc_phy.section_name,
        cc_phy.corporate_id,
        cc_phy.corporate_name,
        cc_phy.product_id,
        cc_phy.product_desc,
        cc_phy.counter_party_id,
        cc_phy.counter_party_name,
        cc_phy.invoice_quantity,
        cc_phy.invoice_quantity_uom,
        cc_phy.fx_base,
        cc_phy.profit_center_id,
        cc_phy.profit_center,
        cc_phy.strategy_id,
        cc_phy.strategy_name,
        cc_phy.base_cur_id,
        cc_phy.base_currency,
        cc_phy.invoice_ref_no,
        cc_phy.contract_ref_no,
        cc_phy.internal_contract_ref_no,
        cc_phy.invoice_cur_id,
        cc_phy.pay_in_currency,
        cc_phy.amount_in_base_cur,
        cc_phy.invoice_amt,
        cc_phy.invoice_date,
        cc_phy.invoice_due_date,
        cc_phy.invoice_type,
        cc_phy.bill_to_cp_country,
        cc_phy.delivery_item_ref_no,
        cc_phy.vat_amount,
        cc_phy.vat_remit_cur_id,
        cc_phy.vat_remit_currency,
        cc_phy.fx_rate_for_vat,
        cc_phy.vat_amount_base_currency,
        cc_phy.commission_value,
        cc_phy.commission_value_ccy,
        cc_phy.attribute1,
        cc_phy.attribute2,
        cc_phy.attribute3,
        cc_phy.attribute4,
        cc_phy.attribute5,
        cc_phy.process_id,
        pc_process,
        cc_phy.eod_run_date,
        cc_phy.eod_date,
        cc_phy.process_run_count);
    end loop;
    commit;
  exception
    when others then
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure sp_physical_journal',
                                                           'GEN-001',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           ' Message:' ||
                                                           sqlerrm,
                                                           null,
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
  end;

  procedure sp_physical_contract_journal(pc_corporate_id    varchar2,
                                         pc_process         varchar2,
                                         pd_trade_date      date,
                                         pc_user_id         varchar2,
                                         pc_process_id      varchar2,
                                         pc_dbd_id          varchar2,
                                         pc_prev_dbd_id     varchar2,
                                         pc_prev_process_id varchar2) is
    --------------------------------------------------------------------------------------------------------------------------
    --        Procedure Name                            : sp_physical_contract_journal
    --        Author                                    : saurabraj
    --        Created Date                              : 25-Jul-2012
    --        Purpose                                   :
    --
    --        Parameters
    --        pc_corporate_id                           : Corporate ID
    --        pd_trade_date                             : Trade Date
    --        pc_user_id                                : User ID
    --        pc_process                                : Process EOD or EOM
    --
    --        Modification History
    --        Modified Date                             :
    --        Modified By                               :
    --        Modify Description                        :
    --------------------------------------------------------------------------------------------------------------------------
    vobj_error_log     tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count number := 1;
  begin
    for cr_phy_jornal in (select 'New' catogery,
                                 'Physical' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 null inco_term_id,
                                 null inco_term,
                                 null inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 null element_id,
                                 null element,
                                 diqs.total_qty del_item_qty,
                                 diqs.item_qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 pcbpd.price_basis,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_value
                                   else
                                    0
                                 end) price,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_unit_id
                                   else
                                    null
                                 end) price_unit_id,
                                 ppu_pum_price.price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 pcqpd.pd_price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                          
                            from pcm_physical_contract_main    pcm,
                                 pcdi_pc_delivery_item         pcdi,
                                 phd_profileheaderdetails      phd,
                                 ak_corporate_user             ak_trader,
                                 pcpd_pc_product_definition    pcpd,
                                 pdm_productmaster             pdm,
                                 diqs_delivery_item_qty_status diqs,
                                 qum_quantity_unit_master      qum_del,
                                 /*pcqpd_pc_qual_premium_discount pcqpd,*/
                                 (select pcm.contract_ref_no,
                                         pcm.internal_contract_ref_no,
                                         pum.price_unit_id premium_disc_unit_id,
                                         pum.price_unit_name pd_price_unit_name,
                                         sum(pci.item_qty *
                                             pcqpd.premium_disc_value) /
                                         sum(pci.item_qty) premium_disc_value
                                    from pcm_physical_contract_main     pcm,
                                         pcdi_pc_delivery_item          pcdi,
                                         pci_physical_contract_item     pci,
                                         pcqpd_pc_qual_premium_discount pcqpd,
                                         ppu_product_price_units        ppu,
                                         pum_price_unit_master          pum,
                                         pcpdqd_pd_quality_details      pcpdqd
                                   where pcm.internal_contract_ref_no =
                                         pcdi.internal_contract_ref_no
                                     and pcdi.pcdi_id = pci.pcdi_id
                                     and pci.pcpq_id = pcpdqd.pcpq_id
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.internal_contract_ref_no =
                                         pcqpd.internal_contract_ref_no(+)
                                     and pcqpd.premium_disc_unit_id =
                                         ppu.internal_price_unit_id(+)
                                     and ppu.price_unit_id =
                                         pum.price_unit_id(+)
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.process_id = pc_process_id
                                     and pcdi.process_id = pc_process_id
                                     and pci.process_id = pc_process_id
                                     and pcqpd.process_id = pc_process_id
                                     and pcm.corporate_id = pc_corporate_id
                                     and pcm.is_active = 'Y'
                                     and pcqpd.is_active = 'Y'
                                   group by pcm.contract_ref_no,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_id,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_name) pcqpd,
                                 --v_ppu_pum                      ppu_pum,
                                 ak_corporate                   akc,
                                 pcbph_pc_base_price_header     pcbph,
                                 poch_price_opt_call_off_header poch,
                                 pcbpd_pc_base_price_detail     pcbpd,
                                 pocd_price_option_calloff_dtls pocd,
                                 pffxd_phy_formula_fx_details   pffxd,
                                 v_ppu_pum                      ppu_pum_price,
                                 cqs_contract_qty_status        cqs,
                                 qum_quantity_unit_master       qum_cont,
                                 cpc_corporate_profit_center    cpc,
                                 css_corporate_strategy_setup   css
                          
                           where pcm.contract_type = 'BASEMETAL'
                             and pcm.process_id = pc_process_id
                             and pcm.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcpd.product_id = pdm.product_id
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = diqs.pcdi_id
                             and diqs.process_id = pc_process_id
                             and diqs.is_active = 'Y'
                             and diqs.item_qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcm.corporate_id = akc.corporate_id
                             and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no
                             and pcbph.process_id = pc_process_id
                             and pcdi.pcdi_id = poch.pcdi_id
                             and poch.pcbph_id = pcbph.pcbph_id
                             and poch.is_active = 'Y'
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and poch.poch_id = pocd.poch_id
                             and pocd.pcbpd_id = pcbpd.pcbpd_id
                             and pocd.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.contract_status <> 'Cancelled'
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and css.is_active = 'Y'
                             and pcdi.price_option_call_off_status in
                                 ('Not Applicable', 'Called Off')
                             and not exists
                           (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm.internal_contract_ref_no =
                                         pcm_in.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id)
                          union all
                          select 'New' catogery,
                                 'Physical' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 null inco_term_id,
                                 null inco_term,
                                 null inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 null element_id,
                                 null element,
                                 diqs.total_qty del_item_qty,
                                 diqs.item_qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 --For not called off , no need to show the pricing details
                                 /*pcbpd.price_basis,
                                                                                                                                    (case
                                                                                                                                      when pcbpd.price_basis = 'Fixed' then
                                                                                                                                       pcbpd.price_value
                                                                                                                                      else
                                                                                                                                       0
                                                                                                                                    end) price,
                                                                                                                                    (case
                                                                                                                                      when pcbpd.price_basis = 'Fixed' then
                                                                                                                                       pcbpd.price_unit_id
                                                                                                                                      else
                                                                                                                                       null
                                                                                                                                    end) price_unit_id,
                                                                                                                                    ppu_pum_price.price_unit_name,*/
                                 null price_basis,
                                 0 price,
                                 null price_unit_id,
                                 null price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 pcqpd.pd_price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                          
                            from pcm_physical_contract_main    pcm,
                                 pcdi_pc_delivery_item         pcdi,
                                 phd_profileheaderdetails      phd,
                                 ak_corporate_user             ak_trader,
                                 pcpd_pc_product_definition    pcpd,
                                 pdm_productmaster             pdm,
                                 diqs_delivery_item_qty_status diqs,
                                 qum_quantity_unit_master      qum_del,
                                 /*pcqpd_pc_qual_premium_discount pcqpd,*/
                                 (select pcm.contract_ref_no,
                                         pcm.internal_contract_ref_no,
                                         pum.price_unit_id premium_disc_unit_id,
                                         pum.price_unit_name pd_price_unit_name,
                                         sum(pci.item_qty *
                                             pcqpd.premium_disc_value) /
                                         sum(pci.item_qty) premium_disc_value
                                    from pcm_physical_contract_main     pcm,
                                         pcdi_pc_delivery_item          pcdi,
                                         pci_physical_contract_item     pci,
                                         pcqpd_pc_qual_premium_discount pcqpd,
                                         ppu_product_price_units        ppu,
                                         pum_price_unit_master          pum,
                                         pcpdqd_pd_quality_details      pcpdqd
                                   where pcm.internal_contract_ref_no =
                                         pcdi.internal_contract_ref_no
                                     and pcdi.pcdi_id = pci.pcdi_id
                                     and pci.pcpq_id = pcpdqd.pcpq_id
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.internal_contract_ref_no =
                                         pcqpd.internal_contract_ref_no(+)
                                     and pcqpd.premium_disc_unit_id =
                                         ppu.internal_price_unit_id(+)
                                     and ppu.price_unit_id =
                                         pum.price_unit_id(+)
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.process_id = pc_process_id
                                     and pcdi.process_id = pc_process_id
                                     and pci.process_id = pc_process_id
                                     and pcqpd.process_id = pc_process_id
                                     and pcm.corporate_id = pc_corporate_id
                                     and pcm.is_active = 'Y'
                                     and pcqpd.is_active = 'Y'
                                   group by pcm.contract_ref_no,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_id,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_name) pcqpd,
                                 --v_ppu_pum                      ppu_pum,
                                 ak_corporate                 akc,
                                 pci_physical_contract_item   pci,
                                 pcipf_pci_pricing_formula    pcipf,
                                 pcbph_pc_base_price_header   pcbph,
                                 pcbpd_pc_base_price_detail   pcbpd,
                                 pffxd_phy_formula_fx_details pffxd,
                                 v_ppu_pum                    ppu_pum_price,
                                 cqs_contract_qty_status      cqs,
                                 qum_quantity_unit_master     qum_cont,
                                 cpc_corporate_profit_center  cpc,
                                 css_corporate_strategy_setup css
                          
                           where pcm.contract_type = 'BASEMETAL'
                             and pcm.process_id = pc_process_id
                             and pcm.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcpd.product_id = pdm.product_id
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = diqs.pcdi_id
                             and diqs.process_id = pc_process_id
                             and diqs.is_active = 'Y'
                             and diqs.item_qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcm.corporate_id = akc.corporate_id
                             and pcdi.pcdi_id=pci.pcdi_id
                             and pci.process_id=pc_process_id
                             and pci.is_active='Y'
                             and pci.internal_contract_item_ref_no=pcipf.internal_contract_item_ref_no
                             and pcipf.process_id=pc_process_id
                             and pcipf.is_active='Y'
                             and pcipf.pcbph_id=pcbph.pcbph_id
                             /*and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no*/
                             and pcbph.process_id = pc_process_id
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.contract_status <> 'Cancelled'
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and css.is_active = 'Y'
                             and pcdi.price_option_call_off_status in
                                 ('Not Called Off')
                             and not exists
                           (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm.internal_contract_ref_no =
                                         pcm_in.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id)
                          union all
                          select 'Deleted' catogery,
                                 'Physical' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 null inco_term_id,
                                 null inco_term,
                                 null inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 null element_id,
                                 null element,
                                 diqs.total_qty del_item_qty,
                                 diqs.item_qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 --For not called off , no need to show the pricing
                                 /*pcbpd.price_basis,
                                                                                                   (case
                                                                                                     when pcbpd.price_basis = 'Fixed' then
                                                                                                      pcbpd.price_value
                                                                                                     else
                                                                                                      0
                                                                                                   end) price,
                                                                                                   (case
                                                                                                     when pcbpd.price_basis = 'Fixed' then
                                                                                                      pcbpd.price_unit_id
                                                                                                     else
                                                                                                      null
                                                                                                   end) price_unit_id,
                                                                                                   ppu_pum_price.price_unit_name,*/
                                 null price_basis,
                                 0 price,
                                 null price_unit_id,
                                 null price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 pcqpd.pd_price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                            from pcm_physical_contract_main    pcm,
                                 pcdi_pc_delivery_item         pcdi,
                                 phd_profileheaderdetails      phd,
                                 ak_corporate_user             ak_trader,
                                 pcpd_pc_product_definition    pcpd,
                                 pdm_productmaster             pdm,
                                 diqs_delivery_item_qty_status diqs,
                                 qum_quantity_unit_master      qum_del,
                                 /*pcqpd_pc_qual_premium_discount pcqpd,*/
                                 (select pcm.contract_ref_no,
                                         pcm.internal_contract_ref_no,
                                         pum.price_unit_id premium_disc_unit_id,
                                         pum.price_unit_name pd_price_unit_name,
                                         sum(pci.item_qty *
                                             pcqpd.premium_disc_value) /
                                         sum(pci.item_qty) premium_disc_value
                                  
                                    from pcm_physical_contract_main     pcm,
                                         pcdi_pc_delivery_item          pcdi,
                                         pci_physical_contract_item     pci,
                                         pcqpd_pc_qual_premium_discount pcqpd,
                                         ppu_product_price_units        ppu,
                                         pum_price_unit_master          pum,
                                         pcpdqd_pd_quality_details      pcpdqd
                                   where pcm.internal_contract_ref_no =
                                         pcdi.internal_contract_ref_no
                                     and pcdi.pcdi_id = pci.pcdi_id
                                     and pci.pcpq_id = pcpdqd.pcpq_id
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.internal_contract_ref_no =
                                         pcqpd.internal_contract_ref_no(+)
                                     and pcqpd.premium_disc_unit_id =
                                         ppu.internal_price_unit_id(+)
                                     and ppu.price_unit_id =
                                         pum.price_unit_id(+)
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.process_id = pc_process_id
                                     and pcdi.process_id = pc_process_id
                                     and pci.process_id = pc_process_id
                                     and pcqpd.process_id = pc_process_id
                                     and pcm.corporate_id = pc_corporate_id
                                     and pcm.is_active = 'Y'
                                     and pcqpd.is_active = 'Y'
                                   group by pcm.contract_ref_no,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_id,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_name) pcqpd,
                                 --v_ppu_pum                      ppu_pum,
                                 ak_corporate                 akc,
                                 pci_physical_contract_item   pci,
                                 pcipf_pci_pricing_formula    pcipf,
                                 pcbph_pc_base_price_header   pcbph,
                                 pcbpd_pc_base_price_detail   pcbpd,
                                 pffxd_phy_formula_fx_details pffxd,
                                 v_ppu_pum                    ppu_pum_price,
                                 cqs_contract_qty_status      cqs,
                                 qum_quantity_unit_master     qum_cont,
                                 cpc_corporate_profit_center  cpc,
                                 css_corporate_strategy_setup css
                           where pcm.contract_type = 'BASEMETAL'
                             and pcm.process_id = pc_process_id
                             and pcm.is_active = 'Y'
                             and pcm.contract_status = 'Cancelled'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcpd.product_id = pdm.product_id
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = diqs.pcdi_id
                             and diqs.process_id = pc_process_id
                             and diqs.is_active = 'Y'
                             and diqs.item_qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcm.corporate_id = akc.corporate_id
                            /* and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no*/
                             and pcdi.pcdi_id=pci.pcdi_id
                             and pci.process_id=pc_process_id
                             and pci.is_active='Y'
                             and pci.internal_contract_item_ref_no=pcipf.internal_contract_item_ref_no
                             and pcipf.process_id=pc_process_id
                             and pcipf.is_active='Y'
                             and pcipf.pcbph_id=pcbph.pcbph_id    
                             and pcbph.process_id = pc_process_id
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and css.is_active = 'Y'
                             and pcdi.price_option_call_off_status in
                                 ('Not Called Off')
                             and exists (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm_in.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id
                                     and pcm_in.corporate_id =
                                         pc_corporate_id
                                     and pcm_in.contract_status <>
                                         'Cancelled')
                          union all
                          select 'Deleted' catogery,
                                 'Physical' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 null inco_term_id,
                                 null inco_term,
                                 null inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 null element_id,
                                 null element,
                                 diqs.total_qty del_item_qty,
                                 diqs.item_qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 pcbpd.price_basis,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_value
                                   else
                                    0
                                 end) price,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_unit_id
                                   else
                                    null
                                 end) price_unit_id,
                                 ppu_pum_price.price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 pcqpd.pd_price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                            from pcm_physical_contract_main    pcm,
                                 pcdi_pc_delivery_item         pcdi,
                                 phd_profileheaderdetails      phd,
                                 ak_corporate_user             ak_trader,
                                 pcpd_pc_product_definition    pcpd,
                                 pdm_productmaster             pdm,
                                 diqs_delivery_item_qty_status diqs,
                                 qum_quantity_unit_master      qum_del,
                                 /*pcqpd_pc_qual_premium_discount pcqpd,*/
                                 (select pcm.contract_ref_no,
                                         pcm.internal_contract_ref_no,
                                         pum.price_unit_id premium_disc_unit_id,
                                         pum.price_unit_name pd_price_unit_name,
                                         sum(pci.item_qty *
                                             pcqpd.premium_disc_value) /
                                         sum(pci.item_qty) premium_disc_value
                                  
                                    from pcm_physical_contract_main     pcm,
                                         pcdi_pc_delivery_item          pcdi,
                                         pci_physical_contract_item     pci,
                                         pcqpd_pc_qual_premium_discount pcqpd,
                                         ppu_product_price_units        ppu,
                                         pum_price_unit_master          pum,
                                         pcpdqd_pd_quality_details      pcpdqd
                                   where pcm.internal_contract_ref_no =
                                         pcdi.internal_contract_ref_no
                                     and pcdi.pcdi_id = pci.pcdi_id
                                     and pci.pcpq_id = pcpdqd.pcpq_id
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.internal_contract_ref_no =
                                         pcqpd.internal_contract_ref_no(+)
                                     and pcqpd.premium_disc_unit_id =
                                         ppu.internal_price_unit_id(+)
                                     and ppu.price_unit_id =
                                         pum.price_unit_id(+)
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.process_id = pc_process_id
                                     and pcdi.process_id = pc_process_id
                                     and pci.process_id = pc_process_id
                                     and pcqpd.process_id = pc_process_id
                                     and pcm.corporate_id = pc_corporate_id
                                     and pcm.is_active = 'Y'
                                     and pcqpd.is_active = 'Y'
                                   group by pcm.contract_ref_no,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_id,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_name) pcqpd,
                                 --v_ppu_pum                      ppu_pum,
                                 ak_corporate                   akc,
                                 pcbph_pc_base_price_header     pcbph,
                                 poch_price_opt_call_off_header poch,
                                 pcbpd_pc_base_price_detail     pcbpd,
                                 pocd_price_option_calloff_dtls pocd,
                                 pffxd_phy_formula_fx_details   pffxd,
                                 v_ppu_pum                      ppu_pum_price,
                                 cqs_contract_qty_status        cqs,
                                 qum_quantity_unit_master       qum_cont,
                                 cpc_corporate_profit_center    cpc,
                                 css_corporate_strategy_setup   css
                           where pcm.contract_type = 'BASEMETAL'
                             and pcm.process_id = pc_process_id
                             and pcm.is_active = 'Y'
                             and pcm.contract_status = 'Cancelled'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcpd.product_id = pdm.product_id
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = diqs.pcdi_id
                             and diqs.process_id = pc_process_id
                             and diqs.is_active = 'Y'
                             and diqs.item_qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcm.corporate_id = akc.corporate_id
                             and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no
                             and pcbph.process_id = pc_process_id
                             and pcdi.pcdi_id = poch.pcdi_id
                             and poch.pcbph_id = pcbph.pcbph_id
                             and poch.is_active = 'Y'
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and poch.poch_id = pocd.poch_id
                             and pocd.pcbpd_id = pcbpd.pcbpd_id
                             and pocd.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and css.is_active = 'Y'
                             and pcdi.price_option_call_off_status in
                                 ('Not Applicable', 'Called Off')
                             and exists (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm_in.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id
                                     and pcm_in.corporate_id =
                                         pc_corporate_id
                                     and pcm_in.contract_status <>
                                         'Cancelled')
                          union all
                          select 'Modified' catogery,
                                 'Physical' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 null inco_term_id,
                                 null inco_term,
                                 null inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 null element_id,
                                 null element,
                                 diqs.total_qty del_item_qty,
                                 diqs.item_qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 --Not called off So no price details
                                 /*pcbpd.price_basis,
                                                                                                   (case
                                                                                                     when pcbpd.price_basis = 'Fixed' then
                                                                                                      pcbpd.price_value
                                                                                                     else
                                                                                                      0
                                                                                                   end) price,
                                                                                                   (case
                                                                                                     when pcbpd.price_basis = 'Fixed' then
                                                                                                      pcbpd.price_unit_id
                                                                                                     else
                                                                                                      null
                                                                                                   end) price_unit_id,
                                                                                                   ppu_pum_price.price_unit_name,*/
                                 null price_basis,
                                 0 price,
                                 null price_unit_id,
                                 null price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 pcqpd.pd_price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                            from pcm_physical_contract_main    pcm,
                                 pcdi_pc_delivery_item         pcdi,
                                 phd_profileheaderdetails      phd,
                                 ak_corporate_user             ak_trader,
                                 pcpd_pc_product_definition    pcpd,
                                 pdm_productmaster             pdm,
                                 diqs_delivery_item_qty_status diqs,
                                 qum_quantity_unit_master      qum_del,
                                 /*pcqpd_pc_qual_premium_discount pcqpd,*/
                                 (select pcm.contract_ref_no,
                                         pcm.internal_contract_ref_no,
                                         pum.price_unit_id premium_disc_unit_id,
                                         pum.price_unit_name pd_price_unit_name,
                                         sum(pci.item_qty *
                                             pcqpd.premium_disc_value) /
                                         sum(pci.item_qty) premium_disc_value
                                    from pcm_physical_contract_main     pcm,
                                         pcdi_pc_delivery_item          pcdi,
                                         pci_physical_contract_item     pci,
                                         pcqpd_pc_qual_premium_discount pcqpd,
                                         ppu_product_price_units        ppu,
                                         pum_price_unit_master          pum,
                                         pcpdqd_pd_quality_details      pcpdqd
                                   where pcm.internal_contract_ref_no =
                                         pcdi.internal_contract_ref_no
                                     and pcdi.pcdi_id = pci.pcdi_id
                                     and pci.pcpq_id = pcpdqd.pcpq_id
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.internal_contract_ref_no =
                                         pcqpd.internal_contract_ref_no(+)
                                     and pcqpd.premium_disc_unit_id =
                                         ppu.internal_price_unit_id(+)
                                     and ppu.price_unit_id =
                                         pum.price_unit_id(+)
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.process_id = pc_process_id
                                     and pcdi.process_id = pc_process_id
                                     and pci.process_id = pc_process_id
                                     and pcqpd.process_id = pc_process_id
                                     and pcm.corporate_id = pc_corporate_id
                                     and pcm.is_active = 'Y'
                                     and pcqpd.is_active = 'Y'
                                   group by pcm.contract_ref_no,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_id,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_name) pcqpd,
                                 --v_ppu_pum                      ppu_pum,
                                 ak_corporate                 akc,
                                 pci_physical_contract_item   pci,
                                 pcipf_pci_pricing_formula    pcipf,
                                 pcbph_pc_base_price_header   pcbph,
                                 pcbpd_pc_base_price_detail   pcbpd,
                                 pffxd_phy_formula_fx_details pffxd,
                                 v_ppu_pum                    ppu_pum_price,
                                 cqs_contract_qty_status      cqs,
                                 qum_quantity_unit_master     qum_cont,
                                 cpc_corporate_profit_center  cpc,
                                 css_corporate_strategy_setup css
                           where pcm.contract_type = 'BASEMETAL'
                             and pcm.process_id = pc_process_id
                             and pcm.contract_status = 'In Position'
                             and pcm.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcpd.product_id = pdm.product_id
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = diqs.pcdi_id
                             and diqs.process_id = pc_process_id
                             and diqs.is_active = 'Y'
                             and diqs.item_qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcm.corporate_id = akc.corporate_id
                             /*and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no*/
                             and pcdi.pcdi_id=pci.pcdi_id
                             and pci.process_id=pc_process_id
                             and pci.is_active='Y'
                             and pci.internal_contract_item_ref_no=pcipf.internal_contract_item_ref_no
                             and pcipf.process_id=pc_process_id
                             and pcipf.is_active='Y'
                             and pcipf.pcbph_id=pcbph.pcbph_id    
                             and pcbph.process_id = pc_process_id
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and css.is_active = 'Y'
                             and pcdi.price_option_call_off_status in
                                 ('Not Called Off')
                             and exists
                           (select pcmul.internal_contract_ref_no
                                    from pcmul_phy_contract_main_ul pcmul
                                   where pcmul.dbd_id = pc_dbd_id
                                     and pcmul.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcmul.entry_type = 'Update'
                                     and nvl(pcmul.contract_status, 'none') <>
                                         'Cancelled')
                             and exists (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm_in.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id -------prev
                                     and pcm_in.corporate_id =
                                         pc_corporate_id
                                     and pcm_in.contract_status <>
                                         'Cancelled')
                          union all
                          select 'Modified' catogery,
                                 'Physical' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 null inco_term_id,
                                 null inco_term,
                                 null inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 null element_id,
                                 null element,
                                 diqs.total_qty del_item_qty,
                                 diqs.item_qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 pcbpd.price_basis,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_value
                                   else
                                    0
                                 end) price,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_unit_id
                                   else
                                    null
                                 end) price_unit_id,
                                 ppu_pum_price.price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 pcqpd.pd_price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                            from pcm_physical_contract_main    pcm,
                                 pcdi_pc_delivery_item         pcdi,
                                 phd_profileheaderdetails      phd,
                                 ak_corporate_user             ak_trader,
                                 pcpd_pc_product_definition    pcpd,
                                 pdm_productmaster             pdm,
                                 diqs_delivery_item_qty_status diqs,
                                 qum_quantity_unit_master      qum_del,
                                 /*pcqpd_pc_qual_premium_discount pcqpd,*/
                                 (select pcm.contract_ref_no,
                                         pcm.internal_contract_ref_no,
                                         pum.price_unit_id premium_disc_unit_id,
                                         pum.price_unit_name pd_price_unit_name,
                                         sum(pci.item_qty *
                                             pcqpd.premium_disc_value) /
                                         sum(pci.item_qty) premium_disc_value
                                    from pcm_physical_contract_main     pcm,
                                         pcdi_pc_delivery_item          pcdi,
                                         pci_physical_contract_item     pci,
                                         pcqpd_pc_qual_premium_discount pcqpd,
                                         ppu_product_price_units        ppu,
                                         pum_price_unit_master          pum,
                                         pcpdqd_pd_quality_details      pcpdqd
                                   where pcm.internal_contract_ref_no =
                                         pcdi.internal_contract_ref_no
                                     and pcdi.pcdi_id = pci.pcdi_id
                                     and pci.pcpq_id = pcpdqd.pcpq_id
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.internal_contract_ref_no =
                                         pcqpd.internal_contract_ref_no(+)
                                     and pcqpd.premium_disc_unit_id =
                                         ppu.internal_price_unit_id(+)
                                     and ppu.price_unit_id =
                                         pum.price_unit_id(+)
                                     and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                     and pcm.process_id = pc_process_id
                                     and pcdi.process_id = pc_process_id
                                     and pci.process_id = pc_process_id
                                     and pcqpd.process_id = pc_process_id
                                     and pcm.corporate_id = pc_corporate_id
                                     and pcm.is_active = 'Y'
                                     and pcqpd.is_active = 'Y'
                                   group by pcm.contract_ref_no,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_id,
                                            pcm.internal_contract_ref_no,
                                            pum.price_unit_name) pcqpd,
                                 --v_ppu_pum                      ppu_pum,
                                 ak_corporate                   akc,
                                 pcbph_pc_base_price_header     pcbph,
                                 poch_price_opt_call_off_header poch,
                                 pcbpd_pc_base_price_detail     pcbpd,
                                 pocd_price_option_calloff_dtls pocd,
                                 pffxd_phy_formula_fx_details   pffxd,
                                 v_ppu_pum                      ppu_pum_price,
                                 cqs_contract_qty_status        cqs,
                                 qum_quantity_unit_master       qum_cont,
                                 cpc_corporate_profit_center    cpc,
                                 css_corporate_strategy_setup   css
                           where pcm.contract_type = 'BASEMETAL'
                             and pcm.process_id = pc_process_id
                             and pcm.contract_status = 'In Position'
                             and pcm.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcpd.product_id = pdm.product_id
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = diqs.pcdi_id
                             and diqs.process_id = pc_process_id
                             and diqs.is_active = 'Y'
                             and diqs.item_qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcm.corporate_id = akc.corporate_id
                             and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no
                             and pcbph.process_id = pc_process_id
                             and pcdi.pcdi_id = poch.pcdi_id
                             and poch.pcbph_id = pcbph.pcbph_id
                             and poch.is_active = 'Y'
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and poch.poch_id = pocd.poch_id
                             and pocd.pcbpd_id = pcbpd.pcbpd_id
                             and pocd.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and css.is_active = 'Y'
                             and pcdi.price_option_call_off_status in
                                 ('Not Applicable', 'Called Off')
                             and exists
                           (select pcmul.internal_contract_ref_no
                                    from pcmul_phy_contract_main_ul pcmul
                                   where pcmul.dbd_id = pc_dbd_id
                                     and pcmul.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcmul.entry_type = 'Update'
                                     and nvl(pcmul.contract_status, 'none') <>
                                         'Cancelled')
                             and exists (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm_in.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id -------prev
                                     and pcm_in.corporate_id =
                                         pc_corporate_id
                                     and pcm_in.contract_status <>
                                         'Cancelled')
                          --for Concentrate
                          union all
                          select 'New' catogery,
                                 'Physical' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 pcdb.inco_term_id,
                                 itm.incoterm inco_term,
                                 cim_inco.city_name inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 cipq.element_id,
                                 null element,
                                 cipq.payable_qty del_item_qty,
                                 cipq.qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 pcbpd.price_basis,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_value
                                   else
                                    0
                                 end) price,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_unit_id
                                   else
                                    null
                                 end) price_unit_id,
                                 ppu_pum_price.price_unit_name,
                                 pcqpd.premium_disc_value, ---here we need to sum  premium of all delivery_item for a contract,same for inco_term
                                 pcqpd.premium_disc_unit_id,
                                 ppu_pum.price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                            from pcm_physical_contract_main     pcm,
                                 pcdi_pc_delivery_item          pcdi,
                                 phd_profileheaderdetails       phd,
                                 ak_corporate_user              ak_trader,
                                 pcdb_pc_delivery_basis         pcdb,
                                 pcpd_pc_product_definition     pcpd,
                                 itm_incoterm_master            itm,
                                 pdm_productmaster              pdm,
                                 pci_physical_contract_item     pci,
                                 cipq_contract_item_payable_qty cipq,
                                 qum_quantity_unit_master       qum_del,
                                 pcqpd_pc_qual_premium_discount pcqpd,
                                 v_ppu_pum                      ppu_pum,
                                 ak_corporate                   akc,
                                 pcbph_pc_base_price_header     pcbph,
                                 pcbpd_pc_base_price_detail     pcbpd,
                                 pffxd_phy_formula_fx_details   pffxd,
                                 v_ppu_pum                      ppu_pum_price,
                                 cqs_contract_qty_status        cqs,
                                 qum_quantity_unit_master       qum_cont,
                                 cpc_corporate_profit_center    cpc,
                                 css_corporate_strategy_setup   css,
                                 cim_citymaster                 cim_inco
                           where pcm.contract_type = 'CONCENTRATES'
                             and pcm.is_tolling_contract = 'N'
                             and pcm.process_id = pc_process_id
                             and pcm.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcdb.internal_contract_ref_no
                             and pcdb.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcdb.inco_term_id = itm.incoterm_id
                             and itm.is_active = 'Y'
                             and itm.is_deleted = 'N'
                             and pcpd.product_id = pdm.product_id
                             and pcpd.input_output = 'Input'
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = pci.pcdi_id
                             and pci.internal_contract_item_ref_no =
                                 cipq.internal_contract_item_ref_no
                             and cipq.is_active = 'Y'
                             and cipq.qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcqpd.process_id(+) = pc_process_id
                             and pcqpd.premium_disc_unit_id =
                                 ppu_pum.product_price_unit_id(+)
                             and pcm.corporate_id = akc.corporate_id
                             and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no
                             and cipq.element_id = pcbph.element_id
                             and pcbph.process_id = pc_process_id
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcqpd.pffxd_id = pffxd.pffxd_id
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.contract_status <> 'Cancelled'
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and cim_inco.city_id = pcdb.city_id
                             and css.is_active = 'Y'
                             and not exists
                           (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm.internal_contract_ref_no =
                                         pcm_in.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id)
                          union all
                          select 'Modified' catogery,
                                 'Physical ' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 pcdb.inco_term_id,
                                 itm.incoterm inco_term,
                                 cim_inco.city_name inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 cipq.element_id,
                                 null element,
                                 cipq.payable_qty del_item_qty,
                                 cipq.qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 pcbpd.price_basis,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_value
                                   else
                                    0
                                 end) price,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_unit_id
                                   else
                                    null
                                 end) price_unit_id,
                                 ppu_pum_price.price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 ppu_pum.price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                            from pcm_physical_contract_main     pcm,
                                 pcmul_phy_contract_main_ul     pcmul,
                                 axs_action_summary             axs,
                                 pcdi_pc_delivery_item          pcdi,
                                 phd_profileheaderdetails       phd,
                                 ak_corporate_user              ak_trader,
                                 pcdb_pc_delivery_basis         pcdb,
                                 pcpd_pc_product_definition     pcpd,
                                 itm_incoterm_master            itm,
                                 pdm_productmaster              pdm,
                                 pci_physical_contract_item     pci,
                                 cipq_contract_item_payable_qty cipq,
                                 qum_quantity_unit_master       qum_del,
                                 pcqpd_pc_qual_premium_discount pcqpd,
                                 v_ppu_pum                      ppu_pum,
                                 ak_corporate                   akc,
                                 pcbph_pc_base_price_header     pcbph,
                                 pcbpd_pc_base_price_detail     pcbpd,
                                 pffxd_phy_formula_fx_details   pffxd,
                                 v_ppu_pum                      ppu_pum_price,
                                 cqs_contract_qty_status        cqs,
                                 qum_quantity_unit_master       qum_cont,
                                 cpc_corporate_profit_center    cpc,
                                 css_corporate_strategy_setup   css,
                                 cim_citymaster                 cim_inco
                           where pcm.internal_contract_ref_no =
                                 pcmul.internal_contract_ref_no
                             and pcm.contract_type = 'CONCENTRATES'
                             and pcm.is_tolling_contract = 'N'
                             and pcm.process_id = pc_process_id
                             and pcmul.dbd_id = pc_dbd_id
                             and pcmul.contract_status = 'In Position'
                             and pcm.is_active = 'Y'
                             and pcmul.is_active = 'Y'
                             and pcmul.entry_type = 'Update'
                             and pcmul.internal_action_ref_no =
                                 axs.internal_action_ref_no
                             and axs.dbd_id = pc_dbd_id
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcdb.internal_contract_ref_no
                             and pcdb.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcdb.inco_term_id = itm.incoterm_id
                             and itm.is_active = 'Y'
                             and itm.is_deleted = 'N'
                             and pcpd.product_id = pdm.product_id
                             and pcpd.input_output = 'Input'
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = pci.pcdi_id
                             and pci.internal_contract_item_ref_no =
                                 cipq.internal_contract_item_ref_no
                             and cipq.is_active = 'Y'
                             and cipq.qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcqpd.process_id(+) = pc_process_id
                             and pcqpd.dbd_id(+) = pc_dbd_id
                             and pcqpd.premium_disc_unit_id =
                                 ppu_pum.product_price_unit_id(+)
                             and pcm.corporate_id = akc.corporate_id
                             and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no
                             and cipq.element_id = pcbph.element_id
                             and pcbph.process_id = pc_process_id
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcqpd.pffxd_id = pffxd.pffxd_id
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and cim_inco.city_id = pcdb.city_id
                             and css.is_active = 'Y'
                             and exists
                           (select pcmul.internal_contract_ref_no
                                    from pcmul_phy_contract_main_ul pcmul
                                   where pcmul.dbd_id = pc_dbd_id
                                     and pcmul.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcmul.entry_type = 'Update'
                                     and nvl(pcmul.contract_status, 'none') <>
                                         'Cancelled')
                             and exists (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm_in.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id -------prev
                                     and pcm_in.corporate_id =
                                         pc_corporate_id
                                     and pcm_in.contract_status <>
                                         'Cancelled')
                          union all
                          select 'Deleted' catogery,
                                 'Physical ' book_type,
                                 pcm.corporate_id,
                                 akc.corporate_name,
                                 pcm.contract_ref_no,
                                 pcm.contract_ref_no || '-' ||
                                 pcdi.delivery_item_no del_item_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pcm.cp_id,
                                 phd.companyname,
                                 pcm.trader_id,
                                 ak_trader.login_name trader,
                                 pcdb.inco_term_id,
                                 itm.incoterm inco_term,
                                 cim_inco.city_name inco_term_location,
                                 pcm.issue_date,
                                 pcpd.product_id,
                                 pdm.product_desc,
                                 cipq.element_id,
                                 null element,
                                 cipq.payable_qty del_item_qty,
                                 cipq.qty_unit_id del_item_qty_unit_id,
                                 qum_del.qty_unit del_item_qty_unit,
                                 (case
                                   when pcdi.delivery_to_date is null then
                                    last_day('01-' || pcdi.delivery_to_month || '-' ||
                                             pcdi.delivery_to_year)
                                   else
                                    pcdi.delivery_to_date
                                 end) del_date,
                                 pcbpd.price_basis,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_value
                                   else
                                    0
                                 end) price,
                                 (case
                                   when pcbpd.price_basis = 'Fixed' then
                                    pcbpd.price_unit_id
                                   else
                                    null
                                 end) price_unit_id,
                                 ppu_pum_price.price_unit_name,
                                 pcqpd.premium_disc_value,
                                 pcqpd.premium_disc_unit_id,
                                 ppu_pum.price_unit_name,
                                 cqs.total_qty contract_qty,
                                 cqs.item_qty_unit_id cont_qty_unit_id,
                                 qum_cont.qty_unit contract_qty_unit,
                                 pcpd.profit_center_id,
                                 cpc.profit_center_short_name,
                                 cpc.profit_center_name,
                                 (case
                                   when pcdi.delivery_period_type = 'Month' then
                                    pcdi.delivery_from_month || '-' ||
                                    pcdi.delivery_from_year || 'To ' ||
                                    pcdi.delivery_to_month || '-' ||
                                    pcdi.delivery_to_year
                                   when pcdi.delivery_period_type = 'Date' then
                                    to_char(pcdi.delivery_from_date,
                                            'dd-Mon-yyyy') || ' To ' ||
                                    to_char(pcdi.delivery_to_date,
                                            'dd-Mon-yyyy')
                                 end) del_quota_period,
                                 pcpd.strategy_id,
                                 css.strategy_name strategy
                            from pcm_physical_contract_main     pcm,
                                 pcdi_pc_delivery_item          pcdi,
                                 phd_profileheaderdetails       phd,
                                 ak_corporate_user              ak_trader,
                                 pcdb_pc_delivery_basis         pcdb,
                                 pcpd_pc_product_definition     pcpd,
                                 itm_incoterm_master            itm,
                                 pdm_productmaster              pdm,
                                 pci_physical_contract_item     pci,
                                 cipq_contract_item_payable_qty cipq,
                                 qum_quantity_unit_master       qum_del,
                                 pcqpd_pc_qual_premium_discount pcqpd,
                                 v_ppu_pum                      ppu_pum,
                                 ak_corporate                   akc,
                                 pcbph_pc_base_price_header     pcbph,
                                 pcbpd_pc_base_price_detail     pcbpd,
                                 pffxd_phy_formula_fx_details   pffxd,
                                 v_ppu_pum                      ppu_pum_price,
                                 cqs_contract_qty_status        cqs,
                                 qum_quantity_unit_master       qum_cont,
                                 cpc_corporate_profit_center    cpc,
                                 css_corporate_strategy_setup   css,
                                 cim_citymaster                 cim_inco
                           where pcm.contract_type = 'CONCENTRATES'
                             and pcm.is_tolling_contract = 'N'
                             and pcm.process_id = pc_process_id
                             and pcm.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcdi.internal_contract_ref_no
                             and pcdi.process_id = pc_process_id
                             and pcdi.is_active = 'Y'
                             and pcm.cp_id = phd.profileid
                             and pcm.trader_id = ak_trader.user_id
                             and pcm.internal_contract_ref_no =
                                 pcdb.internal_contract_ref_no
                             and pcdb.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pcpd.internal_contract_ref_no
                             and pcpd.process_id = pc_process_id
                             and pcpd.is_active = 'Y'
                             and pcdb.inco_term_id = itm.incoterm_id
                             and itm.is_active = 'Y'
                             and itm.is_deleted = 'N'
                             and pcpd.product_id = pdm.product_id
                             and pcpd.input_output = 'Input'
                             and pdm.is_active = 'Y'
                             and pcdi.pcdi_id = pci.pcdi_id
                             and pci.internal_contract_item_ref_no =
                                 cipq.internal_contract_item_ref_no
                             and cipq.is_active = 'Y'
                             and cipq.qty_unit_id = qum_del.qty_unit_id
                             and qum_del.is_deleted = 'N'
                             and qum_del.is_active = 'Y'
                             and pcm.internal_contract_ref_no =
                                 pcqpd.internal_contract_ref_no(+)
                             and pcqpd.process_id(+) = pc_process_id
                             and pcqpd.dbd_id(+) = pc_dbd_id
                             and pcqpd.premium_disc_unit_id =
                                 ppu_pum.product_price_unit_id(+)
                             and pcm.corporate_id = akc.corporate_id
                             and pcm.internal_contract_ref_no =
                                 pcbph.internal_contract_ref_no
                             and cipq.element_id = pcbph.element_id
                             and pcbph.process_id = pc_process_id
                             and pcbph.pcbph_id = pcbpd.pcbph_id
                             and pcbpd.process_id = pc_process_id
                             and pcm.internal_contract_ref_no =
                                 pffxd.internal_contract_ref_no
                             and pffxd.pffxd_id = pcbpd.pffxd_id
                             and pffxd.process_id = pc_process_id
                             and pffxd.is_active = 'Y'
                             and pcbpd.price_unit_id =
                                 ppu_pum_price.product_price_unit_id(+)
                             and pcm.contract_status = 'Cancelled'
                             and pcm.internal_contract_ref_no =
                                 cqs.internal_contract_ref_no
                             and cqs.process_id = pc_process_id
                             and cqs.item_qty_unit_id = qum_cont.qty_unit_id
                             and qum_cont.is_active = 'Y'
                             and pcpd.profit_center_id =
                                 cpc.profit_center_id
                             and cpc.is_active = 'Y'
                             and pcpd.strategy_id = css.strategy_id
                             and cim_inco.city_id = pcdb.city_id
                             and css.is_active = 'Y'
                             and exists (select pcm_in.internal_contract_ref_no
                                    from pcm_physical_contract_main pcm_in
                                   where pcm_in.internal_contract_ref_no =
                                         pcm.internal_contract_ref_no
                                     and pcm_in.process_id =
                                         pc_prev_process_id
                                     and pcm_in.corporate_id =
                                         pc_corporate_id
                                     and pcm_in.contract_status <>
                                         'Cancelled'))
    loop
      insert into eod_eom_phy_contract_journal
        (catogery,
         book_type,
         corporate_id,
         corporate_name,
         contract_ref_no,
         del_item_ref_no,
         internal_contract_ref_no,
         cp_id,
         companyname,
         trader_id,
         trader,
         inco_term_id,
         inco_term,
         inco_term_location,
         issue_date,
         product_id,
         product_desc,
         element_id,
         element,
         del_item_qty,
         del_item_qty_unit_id,
         del_item_qty_unit,
         del_date,
         price_basis,
         price,
         price_unit_id,
         price_unit_name,
         premium_disc_value,
         premium_disc_unit_id,
         pd_price_unit_name,
         eod_eom_date,
         process,
         process_id,
         contract_qty,
         cont_qty_unit_id,
         cont_qty_unit,
         profit_center_id,
         profit_center_short_name,
         profit_center_name,
         del_quota_period,
         strategy_id,
         strategy)
      values
        (cr_phy_jornal.catogery,
         cr_phy_jornal.book_type,
         cr_phy_jornal.corporate_id,
         cr_phy_jornal.corporate_name,
         cr_phy_jornal.contract_ref_no,
         cr_phy_jornal.del_item_ref_no,
         cr_phy_jornal.internal_contract_ref_no,
         cr_phy_jornal.cp_id,
         cr_phy_jornal.companyname,
         cr_phy_jornal.trader_id,
         cr_phy_jornal.trader,
         cr_phy_jornal.inco_term_id,
         cr_phy_jornal.inco_term,
         cr_phy_jornal.inco_term_location,
         cr_phy_jornal.issue_date,
         cr_phy_jornal.product_id,
         cr_phy_jornal.product_desc,
         cr_phy_jornal.element_id,
         cr_phy_jornal.element,
         cr_phy_jornal.del_item_qty,
         cr_phy_jornal.del_item_qty_unit_id,
         cr_phy_jornal.del_item_qty_unit,
         cr_phy_jornal.del_date,
         cr_phy_jornal.price_basis,
         cr_phy_jornal.price,
         cr_phy_jornal.price_unit_id,
         cr_phy_jornal.price_unit_name,
         cr_phy_jornal.premium_disc_value,
         cr_phy_jornal.premium_disc_unit_id,
         cr_phy_jornal.pd_price_unit_name,
         pd_trade_date,
         pc_process,
         pc_process_id,
         cr_phy_jornal.contract_qty,
         cr_phy_jornal.cont_qty_unit_id,
         cr_phy_jornal.contract_qty_unit,
         cr_phy_jornal.profit_center_id,
         cr_phy_jornal.profit_center_short_name,
         cr_phy_jornal.profit_center_name,
         cr_phy_jornal.del_quota_period,
         cr_phy_jornal.strategy_id,
         cr_phy_jornal.strategy);
    
    end loop;
    commit;
    --update incoterm and incoterm location
    for cc in (select pcm.internal_contract_ref_no,
                      stragg(itm.incoterm_id) incoterm_id,
                      stragg(itm.incoterm) incoterm,
                      stragg(cim.city_name) city_name
                 from pcm_physical_contract_main pcm,
                      pcdb_pc_delivery_basis     pcdb,
                      itm_incoterm_master        itm,
                      cim_citymaster             cim,
                      pcdi_pc_delivery_item      pcdi,
                      pci_physical_contract_item pci
                where pcdb.internal_contract_ref_no =
                      pcm.internal_contract_ref_no
                  and pcdb.inco_term_id = itm.incoterm_id
                  and pcdb.city_id = cim.city_id
                  and pcdi.internal_contract_ref_no =
                      pcm.internal_contract_ref_no
                  and pcdi.pcdi_id = pci.pcdi_id
                  and pci.pcdb_id = pcdb.pcdb_id
                  and pcm.internal_contract_ref_no in
                      (select tt.internal_contract_ref_no
                         from eod_eom_phy_contract_journal tt
                        where tt.process_id = pc_process_id
                          and tt.corporate_id = pc_corporate_id
                        group by tt.internal_contract_ref_no)
                  and pcdi.process_id = pc_process_id
                  and pci.process_id = pc_process_id
                  and pcm.process_id = pc_process_id
                  and pcdb.process_id = pc_process_id
                  and pcm.corporate_id = pc_corporate_id
                  and itm.is_active = 'Y'
                  and itm.is_deleted = 'N'
                group by pcm.internal_contract_ref_no)
    loop
    
      update eod_eom_phy_contract_journal t1
         set t1.inco_term_id       = cc.incoterm_id,
             t1.inco_term          = cc.incoterm,
             t1.inco_term_location = cc.city_name
       where t1.internal_contract_ref_no = cc.internal_contract_ref_no
         and t1.corporate_id = pc_corporate_id
         and t1.process_id = pc_process_id
         and t1.process = pc_process;
    end loop;
    commit;
  exception
    when others then
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure sp_pysical_journal',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           ' Message:' ||
                                                           sqlerrm,
                                                           null,
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
  end;

  function f_get_converted_price_pum(pc_corporate_id       varchar2,
                                     pn_price              number,
                                     pc_from_price_unit_id varchar2,
                                     pc_to_price_unit_id   varchar2,
                                     pd_trade_date         date,
                                     pc_product_id         varchar2)
    return number is
    vn_result number;
  
  begin
    if pc_from_price_unit_id = pc_to_price_unit_id then
      return pn_price;
    else
    
      select nvl(round(nvl(pn_price, 0) *
                       pkg_general.f_get_converted_currency_amt(pc_corporate_id,
                                                                pum1.cur_id,
                                                                pum2.cur_id,
                                                                pd_trade_date,
                                                                1) *
                       pkg_general.f_get_converted_quantity(pc_product_id,
                                                            pum1.weight_unit_id,
                                                            pum2.weight_unit_id,
                                                            1) *
                       nvl(pum1.weight, 1) / nvl(pum2.weight, 1),
                       5),
                 0)
        into vn_result
        from pum_price_unit_master pum1,
             pum_price_unit_master pum2
       where pum1.price_unit_id = pc_from_price_unit_id
         and pum2.price_unit_id = pc_to_price_unit_id
         and pum1.is_deleted = 'N'
         and pum2.is_deleted = 'N';
      return vn_result;
    end if;
  exception
    when others then
      return 0;
  end;
  procedure sp_derivative_contract_journal(pc_corporate_id varchar2,
                                           pc_process      varchar2,
                                           pd_trade_date   date,
                                           pc_user_id      varchar2,
                                           pc_dbd_id       varchar2,
                                           pc_prev_dbd_id  varchar2) is
    --------------------------------------------------------------------------------------------------------------------------
    --        Procedure Name                            : sp_derivative_contract_journal
    --        Author                                    : saurabraj
    --        Created Date                              : 25-Jul-2012
    --        Purpose                                   :
    --
    --        Parameters
    --        pc_corporate_id                           : Corporate ID
    --        pd_trade_date                             : Trade Date
    --        pc_user_id                                : User ID
    --        pc_process                                : Process EOD or EOM
    --
    --        Modification History
    --        Modified Date                             :
    --        Modified By                               :
    --        Modify Description                        :
    --------------------------------------------------------------------------------------------------------------------------
    vobj_error_log     tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count number := 1;
    cursor derv_jour is(
      select 'New' catogery,
             dt.derivative_ref_no,
             nvl(phd_clr.company_long_name1, phd_clr.companyname) clearer,
             gab.firstname || ' ' || gab.lastname trader,
             css.strategy_name,
             dt.trade_type,
             dt.trade_date,
             pdm.product_desc product,
             drm.prompt_date prompt_date,
             round((dt.total_quantity * nvl(ucm.multiplication_factor, 1)),
                   pdm_qum.decimals) quantity_in_base_unit,
             pdm_qum.qty_unit uom,
             dt.trade_price,
             pum.price_unit_name,
             dt.strike_price,
             pum_strik.price_unit_name strike_price_unit,
             dt.premium_discount,
             (case
               when irmf.instrument_type in ('Option Put', 'OTC Put Option') then
                'PUT'
               else
                (case
               when irmf.instrument_type in
                    ('Option Call', 'OTC Call Option') then
                'CALL'
               else
                null
             end) end) put_call,
             pum_pd.price_unit_id premium_discount_price_unit,
             dt.option_expiry_date declaration_date,
             dt.clearer_comm_amt clearer_commission,
             (case
               when irmf.instrument_type = 'Average' then
                dt.premium_discount
               else
                null
             end) average_premium,
             dt.average_from_date,
             dt.average_to_date,
             pp.price_point_name,
             dt.status,
             dt.internal_derivative_ref_no,
             ak.corporate_id,
             ak.corporate_name,
             cpc.profit_center_id,
             cpc.profit_center_name,
             cpc.profit_center_short_name,
             tdc.process_id,
             irmf.instrument_type,
             drm.instrument_id,
             dim.instrument_name,
             dt.total_quantity,
             qum.qty_unit total_qty_unit,
             nvl(dt.expired_lots, 0) expired_lots,
             nvl(dt.exercised_lots, 0) exercised_lots,
             nvl(dt.expired_quantity, 0) expired_quantity,
             nvl(dt.exercised_quantity, 0) exercised_quantity,
             dt.external_ref_no ext_trade_ref_no,
             dt.int_trade_parent_der_ref_no int_trade_ref_no,
             cdcmc.master_contract_ref_no master_cont_ref_no,
             bct.commission_type_name clearer_comm_type,
             round((case
                     when dt.clearer_comm_amt <> 0 then
                      dt.clearer_comm_amt /
                      round((dt.total_quantity * nvl(ucm.multiplication_factor, 1)),
                            pdm_qum.decimals)
                     else
                      0
                   end),
                   4) clearer_comm_perunit,
             (case
               when dt.clearer_comm_cur_id is not null then
                cmcl.cur_code || '/' || pdm_qum.qty_unit
               else
                null
             end) clearer_comm_unit,
             dt.remarks,
             emt.exchange_name
        from dt_derivative_trade              dt,
             cpc_corporate_profit_center      cpc,
             ak_corporate                     ak,
             drm_derivative_master            drm,
             phd_profileheaderdetails         phd_broker,
             phd_profileheaderdetails         phd_clr,
             dim_der_instrument_master        dim,
             css_corporate_strategy_setup     css,
             qum_quantity_unit_master         pdm_qum,
             irm_instrument_type_master       irmf,
             pdd_product_derivative_def       pdd,
             tdc_trade_date_closure           tdc,
             pdm_productmaster                pdm,
             pp_price_point                   pp,
             pum_price_unit_master            pum,
             pum_price_unit_master            pum_strik,
             pum_price_unit_master            pum_pd,
             ak_corporate_user                akcu,
             gab_globaladdressbook            gab,
             ucm_unit_conversion_master       ucm,
             qum_quantity_unit_master         qum,
             emt_exchangemaster               emt,
             bct_broker_commission_types      bct,
             cdc_mc_master_contract@eka_appdb cdcmc,
             cm_currency_master               cmcl
       where drm.dr_id = dt.dr_id
         and dt.broker_profile_id = phd_broker.profileid(+)
         and dt.clearer_profile_id = phd_clr.profileid(+)
         and drm.instrument_id = dim.instrument_id
         and dim.instrument_type_id = irmf.instrument_type_id
         and dt.corporate_id = ak.corporate_id
         and dim.product_derivative_id = pdd.derivative_def_id
         and pdd.product_id = pdm.product_id
         and dt.strategy_id = css.strategy_id(+)
         and dt.profit_center_id = cpc.profit_center_id
         and dt.trade_price_unit_id = pum.price_unit_id(+)
         and dt.strike_price_unit_id = pum_strik.price_unit_id(+)
         and pdm.base_quantity_unit = pdm_qum.qty_unit_id
         and akcu.user_id = dt.trader_id
         and dt.premium_discount_price_unit_id = pum_pd.price_unit_id(+)
         and dt.price_point_id = pp.price_point_id(+)
         and nvl(dt.status, 'None') <> 'Delete'
         and irmf.is_active = 'Y'
         and irmf.is_deleted = 'N'
         and dt.quantity_unit_id = ucm.from_qty_unit_id
         and pdm.base_quantity_unit = ucm.to_qty_unit_id
         and dt.is_new_trade = 'Y'
         and dt.dbd_id = pc_dbd_id
         and dt.process_id = tdc.process_id
         and tdc.process = pc_process
         and ak.corporate_id = pc_corporate_id
         and akcu.gabid = gab.gabid
         and dt.quantity_unit_id = qum.qty_unit_id
         and pdd.exchange_id = emt.exchange_id(+)
         and dt.clearer_comm_type_id = bct.commission_type_id(+)
         and dt.master_contract_id = cdcmc.internal_contract_ref_no(+)
         and dt.clearer_comm_cur_id = cmcl.cur_id(+)
      
      union all
      select 'Deleted' catogery,
             dt.derivative_ref_no,
             nvl(phd_clr.company_long_name1, phd_clr.companyname) clearer,
             gab.firstname || ' ' || gab.lastname trader,
             css.strategy_name,
             dt.trade_type,
             dt.trade_date,
             pdm.product_desc product,
             drm.prompt_date prompt_date,
             round((dt.total_quantity * nvl(ucm.multiplication_factor, 1)),
                   pdm_qum.decimals) quantity_in_base_unit,
             pdm_qum.qty_unit uom,
             dt.trade_price,
             pum.price_unit_name,
             dt.strike_price,
             pum_strik.price_unit_name strike_price_unit,
             dt.premium_discount,
             (case
               when irmf.instrument_type in ('Option Put', 'OTC Put Option') then
                'PUT'
               else
                (case
               when irmf.instrument_type in
                    ('Option Call', 'OTC Call Option') then
                'CALL'
               else
                null
             end) end) put_call,
             pum_pd.price_unit_id premium_discount_price_unit,
             dt.option_expiry_date declaration_date,
             dt.clearer_comm_amt clearer_commission,
             (case
               when irmf.instrument_type = 'Average' then
                dt.premium_discount
               else
                null
             end) average_premium,
             dt.average_from_date,
             dt.average_to_date,
             pp.price_point_name,
             dt.status,
             dt.internal_derivative_ref_no,
             ak.corporate_id,
             ak.corporate_name,
             cpc.profit_center_id,
             cpc.profit_center_name,
             cpc.profit_center_short_name,
             tdc.process_id,
             irmf.instrument_type,
             drm.instrument_id,
             dim.instrument_name,
             dt.total_quantity,
             qum.qty_unit total_qty_unit,
             nvl(dt.expired_lots, 0) expired_lots,
             nvl(dt.exercised_lots, 0) exercised_lots,
             nvl(dt.expired_quantity, 0) expired_quantity,
             nvl(dt.exercised_quantity, 0) exercised_quantity,
             dt.external_ref_no ext_trade_ref_no,
             dt.int_trade_parent_der_ref_no int_trade_ref_no,
             cdcmc.master_contract_ref_no master_cont_ref_no,
             bct.commission_type_name clearer_comm_type,
             round((case
                     when dt.clearer_comm_amt <> 0 then
                      dt.clearer_comm_amt /
                      round((dt.total_quantity * nvl(ucm.multiplication_factor, 1)),
                            pdm_qum.decimals)
                     else
                      0
                   end),
                   4) clearer_comm_perunit,
             (case
               when dt.clearer_comm_cur_id is not null then
                cmcl.cur_code || '/' || pdm_qum.qty_unit
               else
                null
             end) clearer_comm_unit,
             dt.remarks,
             emt.exchange_name
        from dt_derivative_trade              dt,
             cpc_corporate_profit_center      cpc,
             ak_corporate                     ak,
             drm_derivative_master            drm,
             phd_profileheaderdetails         phd_broker,
             phd_profileheaderdetails         phd_clr,
             dim_der_instrument_master        dim,
             css_corporate_strategy_setup     css,
             qum_quantity_unit_master         pdm_qum,
             irm_instrument_type_master       irmf,
             tdc_trade_date_closure           tdc,
             pdd_product_derivative_def       pdd,
             pdm_productmaster                pdm,
             pp_price_point                   pp,
             pum_price_unit_master            pum,
             pum_price_unit_master            pum_strik,
             pum_price_unit_master            pum_pd,
             ak_corporate_user                akcu,
             ucm_unit_conversion_master       ucm,
             gab_globaladdressbook            gab,
             qum_quantity_unit_master         qum,
             emt_exchangemaster               emt,
             bct_broker_commission_types      bct,
             cdc_mc_master_contract@eka_appdb cdcmc,
             cm_currency_master               cmcl
       where drm.dr_id = dt.dr_id
         and dt.broker_profile_id = phd_broker.profileid(+)
         and dt.clearer_profile_id = phd_clr.profileid(+)
         and drm.instrument_id = dim.instrument_id
         and dim.instrument_type_id = irmf.instrument_type_id
         and dt.corporate_id = ak.corporate_id
         and dim.product_derivative_id = pdd.derivative_def_id
         and pdd.product_id = pdm.product_id
         and dt.strategy_id = css.strategy_id(+)
         and dt.trade_price_unit_id = pum.price_unit_id(+)
         and dt.strike_price_unit_id = pum_strik.price_unit_id(+)
         and pdm.base_quantity_unit = pdm_qum.qty_unit_id
         and dt.profit_center_id = cpc.profit_center_id
         and akcu.user_id = dt.trader_id
         and dt.premium_discount_price_unit_id = pum_pd.price_unit_id(+)
         and dt.price_point_id = pp.price_point_id(+)
         and dt.status = 'Delete'
         and irmf.is_active = 'Y'
         and irmf.is_deleted = 'N'
         and dt.quantity_unit_id = ucm.from_qty_unit_id
         and pdm.base_quantity_unit = ucm.to_qty_unit_id
         and dt.dbd_id = pc_dbd_id
         and dt.process_id = tdc.process_id
         and tdc.process = pc_process
         and ak.corporate_id = pc_corporate_id
         and akcu.gabid = gab.gabid
         and dt.quantity_unit_id = qum.qty_unit_id
         and pdd.exchange_id = emt.exchange_id(+)
         and dt.clearer_comm_type_id = bct.commission_type_id(+)
         and dt.master_contract_id = cdcmc.internal_contract_ref_no(+)
         and dt.clearer_comm_cur_id = cmcl.cur_id(+)
         and exists (select dt_in.internal_derivative_ref_no
                from dt_derivative_trade dt_in
               where dt_in.dbd_id = pc_prev_dbd_id
                 and dt_in.internal_derivative_ref_no =
                     dt.internal_derivative_ref_no
                 and dt_in.status = 'Verified')
      union all
      select 'Modified' catogery,
             dt.derivative_ref_no,
             nvl(phd_clr.company_long_name1, phd_clr.companyname) clearer,
             gab.firstname || ' ' || gab.lastname trader,
             css.strategy_name,
             dt.trade_type,
             dt.trade_date,
             pdm.product_desc product,
             drm.prompt_date prompt_date,
             round((dt.total_quantity * nvl(ucm.multiplication_factor, 1)),
                   pdm_qum.decimals) quantity_in_base_unit,
             pdm_qum.qty_unit uom,
             dt.trade_price,
             pum.price_unit_name,
             dt.strike_price,
             pum_strik.price_unit_name strike_price_unit,
             dt.premium_discount,
             (case
               when irmf.instrument_type in ('Option Put', 'OTC Put Option') then
                'PUT'
               else
                (case
               when irmf.instrument_type in
                    ('Option Call', 'OTC Call Option') then
                'CALL'
               else
                null
             end) end) put_call,
             pum_pd.price_unit_id premium_discount_price_unit,
             dt.option_expiry_date declaration_date,
             dt.clearer_comm_amt clearer_commission,
             (case
               when irmf.instrument_type = 'Average' then
                dt.premium_discount
               else
                null
             end) average_premium,
             dt.average_from_date,
             dt.average_to_date,
             pp.price_point_name,
             dt.status,
             dt.internal_derivative_ref_no,
             ak.corporate_id,
             ak.corporate_name,
             cpc.profit_center_id,
             cpc.profit_center_name,
             cpc.profit_center_short_name,
             tdc.process_id,
             irmf.instrument_type,
             drm.instrument_id,
             dim.instrument_name,
             dt.total_quantity,
             qum.qty_unit total_qty_unit,
             nvl(dt.expired_lots, 0) expired_lots,
             nvl(dt.exercised_lots, 0) exercised_lots,
             nvl(dt.expired_quantity, 0) expired_quantity,
             nvl(dt.exercised_quantity, 0) exercised_quantity,
             dt.external_ref_no ext_trade_ref_no,
             dt.int_trade_parent_der_ref_no int_trade_ref_no,
             cdcmc.master_contract_ref_no master_cont_ref_no,
             bct.commission_type_name clearer_comm_type,
             round((case
                     when dt.clearer_comm_amt <> 0 then
                      dt.clearer_comm_amt /
                      round((dt.total_quantity * nvl(ucm.multiplication_factor, 1)),
                            pdm_qum.decimals)
                     else
                      0
                   end),
                   4) clearer_comm_perunit,
             (case
               when dt.clearer_comm_cur_id is not null then
                cmcl.cur_code || '/' || pdm_qum.qty_unit
               else
                null
             end) clearer_comm_unit,
             dt.remarks,
             emt.exchange_name
        from dt_derivative_trade              dt,
             cpc_corporate_profit_center      cpc,
             ak_corporate                     ak,
             drm_derivative_master            drm,
             phd_profileheaderdetails         phd_broker,
             phd_profileheaderdetails         phd_clr,
             dim_der_instrument_master        dim,
             css_corporate_strategy_setup     css,
             qum_quantity_unit_master         pdm_qum,
             irm_instrument_type_master       irmf,
             tdc_trade_date_closure           tdc,
             pdd_product_derivative_def       pdd,
             pdm_productmaster                pdm,
             pp_price_point                   pp,
             pum_price_unit_master            pum,
             pum_price_unit_master            pum_strik,
             pum_price_unit_master            pum_pd,
             ak_corporate_user                akcu,
             gab_globaladdressbook            gab,
             ucm_unit_conversion_master       ucm,
             qum_quantity_unit_master         qum,
             emt_exchangemaster               emt,
             bct_broker_commission_types      bct,
             cdc_mc_master_contract@eka_appdb cdcmc,
             cm_currency_master               cmcl
       where drm.dr_id = dt.dr_id
         and dt.broker_profile_id = phd_broker.profileid(+)
         and dt.clearer_profile_id = phd_clr.profileid(+)
         and drm.instrument_id = dim.instrument_id
         and dim.instrument_type_id = irmf.instrument_type_id
         and dt.corporate_id = ak.corporate_id
         and dim.product_derivative_id = pdd.derivative_def_id
         and pdd.product_id = pdm.product_id
         and dt.strategy_id = css.strategy_id(+)
         and dt.profit_center_id = cpc.profit_center_id
         and dt.trade_price_unit_id = pum.price_unit_id(+)
         and dt.strike_price_unit_id = pum_strik.price_unit_id(+)
         and pdm.base_quantity_unit = pdm_qum.qty_unit_id
         and akcu.user_id = dt.trader_id
         and dt.premium_discount_price_unit_id = pum_pd.price_unit_id(+)
         and dt.price_point_id = pp.price_point_id(+)
         and dt.status = 'Verified'
         and nvl(dt.is_new_trade, 'N') <> 'Y'
         and irmf.is_active = 'Y'
         and irmf.is_deleted = 'N'
         and dt.quantity_unit_id = ucm.from_qty_unit_id
         and pdm.base_quantity_unit = ucm.to_qty_unit_id
         and dt.dbd_id = pc_dbd_id
         and dt.process_id = tdc.process_id
         and tdc.process = pc_process
         and ak.corporate_id = pc_corporate_id
         and akcu.gabid = gab.gabid
         and dt.quantity_unit_id = qum.qty_unit_id
         and pdd.exchange_id = emt.exchange_id(+)
         and dt.clearer_comm_type_id = bct.commission_type_id(+)
         and dt.master_contract_id = cdcmc.internal_contract_ref_no(+)
         and dt.clearer_comm_cur_id = cmcl.cur_id(+)
         and exists
       (select dtul.internal_derivative_ref_no
                from dtul_derivative_trade_ul dtul
               where dtul.dbd_id = pc_dbd_id
                 and dtul.internal_derivative_ref_no =
                     dt.internal_derivative_ref_no
                 and dtul.entry_type = 'Update'
                 and nvl(dtul.status, 'none') <> 'delete'));
  
  begin
  
    for dvj in derv_jour
    loop
      insert into eod_eom_derivative_journal
        (internal_derivative_ref_no,
         journal_type,
         book_type,
         corporate_id,
         corporate_name,
         profit_center_id,
         profit_center_name,
         profit_center_short_name,
         catogery,
         derivative_ref_no,
         clearer,
         trader,
         strategy_name,
         trade_type,
         trade_date,
         product,
         prompt_date,
         quantity,
         quantity_uom,
         trade_price,
         price_unit,
         strike_price,
         strike_price_unit,
         premium_discount,
         put_call,
         pd_price_unit,
         declaration_date,
         clearer_commission,
         average_premium,
         average_from_date,
         average_to_date,
         price_point_name,
         status,
         attribute_1,
         attribute_2,
         attribute_3,
         attribute_4,
         attribute_5,
         eod_eom_date,
         process,
         process_id,
         dbd_id,
         instrument_id,
         instrument_name,
         instrument_type,
         trade_quantity,
         trade_quantity_unit,
         exercised_expired_lots,
         exercised_expired_quantity,
         ext_trade_ref_no,
         int_trade_ref_no,
         master_cont_ref_no,
         clearer_comm_type,
         clearer_comm_perunit,
         clearer_comm_unit,
         exchange,
         remarks)
      values
        (dvj.internal_derivative_ref_no,
         dvj.catogery,
         'Derivative',
         dvj.corporate_id,
         dvj.corporate_name,
         dvj.profit_center_id,
         dvj.profit_center_name,
         dvj.profit_center_short_name,
         dvj.catogery,
         dvj.derivative_ref_no,
         dvj.clearer,
         dvj.trader,
         dvj.strategy_name,
         dvj.trade_type,
         dvj.trade_date,
         dvj.product,
         dvj.prompt_date,
         dvj.quantity_in_base_unit,
         dvj.uom,
         dvj.trade_price,
         dvj.price_unit_name,
         dvj.strike_price,
         dvj.strike_price_unit,
         dvj.premium_discount,
         dvj.put_call,
         dvj.premium_discount_price_unit,
         dvj.declaration_date,
         dvj.clearer_commission,
         dvj.average_premium,
         dvj.average_from_date,
         dvj.average_to_date,
         dvj.price_point_name,
         dvj.status,
         null,
         null,
         null,
         null,
         null,
         pd_trade_date,
         pc_process,
         dvj.process_id,
         pc_dbd_id,
         dvj.instrument_id,
         dvj.instrument_name,
         dvj.instrument_type,
         dvj.total_quantity,
         dvj.total_qty_unit,
         dvj.expired_lots + dvj.exercised_lots,
         dvj.expired_quantity + dvj.exercised_quantity,
         dvj.ext_trade_ref_no,
         dvj.int_trade_ref_no,
         dvj.master_cont_ref_no,
         dvj.clearer_comm_type,
         dvj.clearer_comm_perunit,
         dvj.clearer_comm_unit,
         dvj.exchange_name,
         dvj.remarks);
    
    end loop;
  
  exception
    when others then
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure sp_derivative_journal',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           ' Message:' ||
                                                           sqlerrm,
                                                           null,
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
  end;
  procedure sp_fixation_journal(pc_corporate_id    varchar2,
                                pd_trade_date      date,
                                pc_process_id      varchar2,
                                pc_user_id         varchar2,
                                pc_process         varchar2,
                                pc_dbd_id          varchar2,
                                pc_prev_process_id varchar2) is
    --------------------------------------------------------------------------------------------------------------------------
    --        Procedure Name                            : sp_derivative_booking_journal
    --        Author                                    : Ashok
    --        Created Date                              : 01-Aug-2012
    --        Purpose                                   :
    --
    --        Parameters
    --        pc_corporate_id                           : Corporate ID
    --        pd_trade_date                             : Trade Date
    --        pc_user_id                                : User ID
    --        pc_process                                : Process EOD or EOM
    --
    --        Modification History
    --        Modified Date                             :
    --        Modified By                               :
    --        Modify Description                        :
    --------------------------------------------------------------------------------------------------------------------------
    vobj_error_log     tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count number := 1;
    cursor cr_cdc_fixation is
      select 'New' journal_type, -- Section name
             'Derivative' book_type, --Price Fixation Type
             dpd.process_id,
             dpd.eod_trade_date,
             dpd.corporate_id,
             dpd.corporate_name,
             dpd.product_id,
             dpd.product_name,
             dpd.profit_center_id,
             dpd.profit_center_name,
             dpd.profit_center_short_name,
             dpd.settlement_ref_no price_fixation_refno,
             dpd.internal_derivative_ref_no,
             null delivery_item_ref_no,
             null delivery_item_qty,
             null delivery_item_qty_unit,
             dpd.derivative_ref_no contract_ref_no,
             dpd.clearer_profile_id,
             dpd.clearer_name,
             dpd.trader_name,
             fsh.settlement_date price_fixation_date, --settlement_date
             dpd.open_quantity fixed_quantity,
             dpd.quantity_unit,
             dpd.trade_price,
             dpd.trade_price_cur_code || '/' || dpd.trade_price_weight ||
             dpd.trade_price_weight_unit price_unit,
             0 adjustment,
             1 fx_rate,
             dpd.premium_discount contract_premium,
             dpd.pd_price_cur_code || '/' || dpd.pd_price_weight ||
             dpd.pd_price_weight_unit contract_premium_unit,
             --    null total_price,
             --   null total_price_unit,
             dpd.trade_date contract_issue_date,
             dpd.average_from_date,
             dpd.average_to_date,
             dpd.settlement_price,
             fsh.settlement_date,
             dpd.strategy_id,
             dpd.strategy_name,
             null attribute_1,
             null attribute_2,
             null attribute_3,
             null attribute_4,
             null attribute_5,
             dpd.base_cur_id,
             dpd.base_cur_code,
             dpd.trade_price_unit_id,
             dpd.premium_discount_price_unit_id,
             dpd.trade_price_cur_id,
             dpd.trade_price_cur_code,
             dpd.trade_price_weight,
             dpd.trade_price_weight_unit_id,
             dpd.trade_price_weight_unit,
             dpd.pd_price_cur_id,
             dpd.pd_price_cur_code,
             dpd.pd_price_weight,
             dpd.pd_price_weight_unit_id,
             dpd.pd_price_weight_unit,
             dpd.base_qty_unit_id,
             dpd.base_qty_unit
        from dpd_derivative_pnl_daily dpd,
             (select fsh.internal_derivative_ref_no,
                     fsh.settlement_ref_no,
                     fsh.settlement_date
                from fsh_fin_settlement_header fsh
               where fsh.process_id = pc_process_id
                 and fsh.is_settled = 'Y'
               group by fsh.internal_derivative_ref_no,
                        fsh.settlement_ref_no,
                        fsh.settlement_date) fsh
       where dpd.pnl_type = 'Realized'
         and dpd.instrument_type = 'Average'
         and dpd.corporate_id = pc_corporate_id
         and dpd.process_id = pc_process_id
         and dpd.internal_derivative_ref_no =
             fsh.internal_derivative_ref_no(+)
         and dpd.settlement_ref_no = fsh.settlement_ref_no(+)
      union all
      select 'Deleted' journal_type, -- Section name
             'Derivative' book_type, --Price Fixation Type
             dpd.process_id,
             dpd.eod_trade_date,
             dpd.corporate_id,
             dpd.corporate_name,
             dpd.product_id,
             dpd.product_name,
             dpd.profit_center_id,
             dpd.profit_center_name,
             dpd.profit_center_short_name,
             dpd.settlement_ref_no price_fixation_refno,
             dpd.internal_derivative_ref_no,
             null delivery_item_ref_no,
             null delivery_item_qty,
             null delivery_item_qty_unit,
             dpd.derivative_ref_no contract_ref_no,
             dpd.clearer_profile_id,
             dpd.clearer_name,
             dpd.trader_name,
             fsh.settlement_date price_fixation_date, --settlement_date
             dpd.open_quantity fixed_quantity,
             dpd.quantity_unit,
             dpd.trade_price,
             dpd.trade_price_cur_code || '/' || dpd.trade_price_weight ||
             dpd.trade_price_weight_unit price_unit,
             0 adjustment,
             1 fx_rate,
             dpd.premium_discount contract_premium,
             dpd.pd_price_cur_code || '/' || dpd.pd_price_weight ||
             dpd.pd_price_weight_unit contract_premium_unit,
             --             null total_price,
             --           null total_price_unit,
             dpd.trade_date contract_issue_date,
             dpd.average_from_date,
             dpd.average_to_date,
             dpd.settlement_price,
             fsh.settlement_date,
             dpd.strategy_id,
             dpd.strategy_name,
             null attribute_1,
             null attribute_2,
             null attribute_3,
             null attribute_4,
             null attribute_5,
             dpd.base_cur_id,
             dpd.base_cur_code,
             dpd.trade_price_unit_id,
             dpd.premium_discount_price_unit_id,
             dpd.trade_price_cur_id,
             dpd.trade_price_cur_code,
             dpd.trade_price_weight,
             dpd.trade_price_weight_unit_id,
             dpd.trade_price_weight_unit,
             dpd.pd_price_cur_id,
             dpd.pd_price_cur_code,
             dpd.pd_price_weight,
             dpd.pd_price_weight_unit_id,
             dpd.pd_price_weight_unit,
             dpd.base_qty_unit_id,
             dpd.base_qty_unit
        from dpd_derivative_pnl_daily dpd,
             (select fsh.internal_derivative_ref_no,
                     fsh.settlement_ref_no,
                     fsh.settlement_date
                from fsh_fin_settlement_header fsh
               where fsh.process_id = pc_process_id
              --and fsh.is_settled = 'Y'
               group by fsh.internal_derivative_ref_no,
                        fsh.settlement_ref_no,
                        fsh.settlement_date) fsh
       where dpd.pnl_type = 'Reverse Realized'
         and dpd.instrument_type = 'Average'
         and dpd.corporate_id = pc_corporate_id
         and dpd.process_id = pc_process_id
         and dpd.internal_derivative_ref_no =
             fsh.internal_derivative_ref_no(+)
         and dpd.settlement_ref_no = fsh.settlement_ref_no(+);
    cursor cr_phy_fixation is
      select 'New' journal_type,
             'Physical' book_type,
             pofh.corporate_id,
             akc.corporate_name,
             null product_id,
             null product_name,
             null profit_center_id,
             null profit_center_name,
             null profit_center_short_name,
             pofh.latest_pfc_no price_fixation_refno,
             pofh.pcdi_id internal_derivative_ref_no,
             (case
               when gmr.gmr_ref_no is not null then
                gmr.gmr_ref_no
               else
                pcm.contract_ref_no || '-' || pcdi.delivery_item_no
             end) delivery_item_ref_no, --bug id 69221
             diqs.total_qty delivery_item_qty,
             qum_diqs.qty_unit delivery_item_qty_unit,
             /*(case
                                                                   when gmr.gmr_ref_no is not null then
                                                                    gmr.gmr_ref_no
                                                                   else
                                                                    pcm.contract_ref_no
                                                                 end) contract_ref_no,*/
             pcm.contract_ref_no, --bug id 69221
             pcm.cp_id clearer_profile_id,
             phd_cp.companyname clearer_name,
             gab.firstname || ' ' || gab.lastname trader_name,
             pofh.finalize_date price_fixation_date,
             pofh.latest_fixed_qty fixed_quantity,
             qum_fxd.qty_unit quantity_unit,
             pofh.final_price trade_price, --has to use finalized price stored in pay-in currency for calculation, not the avg price
             ppu_pum_pay.price_unit_name price_unit, --pay in currency unit
             pofh.latest_adj_price,
             round(pkg_general.f_get_converted_currency_amt(pcm.corporate_id,
                                                            ppu_pum_pay.cur_id,
                                                            akc.base_cur_id,
                                                            pd_trade_date,
                                                            1),
                   10) pay_to_base_fx_rate, --payin currency to base
             0 contract_premium, --inside formula
             ppu_pum.price_unit_name contract_premium_unit, --inside variable
             pcm.issue_date contract_issue_date,
             (case
               when pocd.is_any_day_pricing = 'N' then
                to_char(pofh.qp_start_date, 'dd-Mon-yyyy')
               else
                null
             end) average_from_date,
             (case
               when pocd.is_any_day_pricing = 'N' then
                to_char(pofh.qp_end_date, 'dd-Mon-yyyy')
               else
                null
             end) average_to_date,
             round(pofh.final_price_in_pricing_cur, 6) settlement_price,
             pofh.latest_pfc_date settlement_date,
             null strategy_id,
             null strategy_name,
             null attribute_1,
             null attribute_2,
             null attribute_3,
             null attribute_4,
             null attribute_5,
             akc.base_cur_id,
             cm_base.cur_code base_cur_code,
             ppu_pum_pay.price_unit_id trade_price_unit_id,
             ppu_pum.price_unit_id premium_discount_price_unit_id,
             ppu_pum_pay.cur_id trade_price_cur_id,
             cm_pay.cur_code trade_price_cur_code,
             ppu_pum_pay.weight trade_price_weight,
             ppu_pum_pay.weight_unit_id trade_price_weight_unit_id,
             qum_pay.qty_unit trade_price_weight_unit,
             ppu_pum.cur_id pd_price_cur_id,
             cm_ppu.cur_code pd_price_cur_code,
             ppu_pum.weight pd_price_weight,
             ppu_pum.weight_unit_id pd_price_weight_unit_id,
             qum_ppu.qty_unit pd_price_weight_unit,
             pofh.pofh_id,
             aml.attribute_id,
             aml.attribute_name,
             pofh.final_price, -- this price has to be used for calculation
             pocd.pay_in_price_unit_id, -- this price has to be used for calculation
             ppu_pum_pay.price_unit_name pay_in_price_unit, -- this price has to be used for calculation
             cm_pay.cur_code pay_in_cur_code
        from pofh_history                   pofh,
             pocd_price_option_calloff_dtls pocd,
             pcdi_pc_delivery_item          pcdi,
             diqs_delivery_item_qty_status  diqs,
             qum_quantity_unit_master       qum_diqs,
             gmr_goods_movement_record      gmr,
             pcm_physical_contract_main     pcm,
             phd_profileheaderdetails       phd_cp,
             ak_corporate_user              ak_trader,
             gab_globaladdressbook          gab,
             qum_quantity_unit_master       qum_fxd,
             v_ppu_pum                      ppu_pum,
             cm_currency_master             cm_ppu,
             qum_quantity_unit_master       qum_ppu,
             ak_corporate                   akc,
             cm_currency_master             cm_base,
             aml_attribute_master_list      aml,
             v_ppu_pum                      ppu_pum_pay,
             cm_currency_master             cm_pay,
             qum_quantity_unit_master       qum_pay
       where pofh.is_new = 'Y'
         and pofh.is_active = 'Y'
            --  and pofh.is_deleted is null
         and pofh.pcdi_id = pcdi.pcdi_id
         and pofh.pocd_id = pocd.pocd_id
         and pofh.pcdi_id = diqs.pcdi_id
         and pocd.element_id = aml.attribute_id(+)
         and diqs.item_qty_unit_id = qum_diqs.qty_unit_id
         and pcdi.internal_contract_ref_no = pcm.internal_contract_ref_no
         and pofh.internal_gmr_ref_no = gmr.internal_gmr_ref_no(+)
         and pofh.process_id = gmr.process_id(+)
         and pcm.cp_id = phd_cp.profileid
         and pcm.trader_id = ak_trader.user_id
         and ak_trader.gabid = gab.gabid
         and pocd.qty_to_be_fixed_unit_id = qum_fxd.qty_unit_id(+)
         and pofh.latest_price_unit_id = ppu_pum.product_price_unit_id(+)
         and pcm.corporate_id = akc.corporate_id
         and akc.base_cur_id = cm_base.cur_id
         and ppu_pum.cur_id = cm_ppu.cur_id(+)
         and ppu_pum.weight_unit_id = qum_ppu.qty_unit_id(+)
         and pcdi.is_active = 'Y'
         and pcm.is_active = 'Y'
         and pofh.corporate_id = pc_corporate_id
         and pofh.process_id = pc_process_id
         and pofh.process = pc_process
         and pcm.process_id = pc_process_id
         and pcdi.process_id = pc_process_id
         and diqs.process_id = pc_process_id
         and pocd.pay_in_price_unit_id = ppu_pum_pay.product_price_unit_id
         and ppu_pum_pay.weight_unit_id = qum_pay.qty_unit_id(+)
         and pocd.pay_in_cur_id = cm_pay.cur_id(+)
	     and pcm.contract_status = 'In Position'
      -- and cm_pay.is_active = 'Y'
      union all
      select 'Deleted' journal_type,
             'Physical' book_type,
             pofh.corporate_id,
             akc.corporate_name,
             null product_id,
             null product_name,
             null profit_center_id,
             null profit_center_name,
             null profit_center_short_name,
             pofh.latest_pfc_no price_fixation_refno,
             pofh.pcdi_id internal_derivative_ref_no,
             (case
               when gmr.gmr_ref_no is not null then
                gmr.gmr_ref_no
               else
                pcm.contract_ref_no || '-' || pcdi.delivery_item_no
             end) delivery_item_ref_no, --bug id 69221
             diqs.total_qty delivery_item_qty,
             qum_diqs.qty_unit delivery_item_qty_unit,
             /*(case
                                                                   when gmr.gmr_ref_no is not null then
                                                                    gmr.gmr_ref_no
                                                                   else
                                                                    pcm.contract_ref_no
                                                                 end) contract_ref_no,*/
             pcm.contract_ref_no, --bug id 69221
             pcm.cp_id clearer_profile_id,
             phd_cp.companyname clearer_name,
             gab.firstname || ' ' || gab.lastname trader_name,
             pofh.finalize_date price_fixation_date,
             pofh.latest_fixed_qty fixed_quantity,
             qum_fxd.qty_unit quantity_unit,
             pofh.final_price trade_price, --has to use finalized price stored in pay-in currency for calculation, not the avg price
             ppu_pum_pay.price_unit_name price_unit,
             pofh.latest_adj_price,
             round(pkg_general.f_get_converted_currency_amt(pcm.corporate_id,
                                                            ppu_pum_pay.cur_id,
                                                            akc.base_cur_id,
                                                            pd_trade_date,
                                                            1),
                   10) pay_to_base_fx_rate,
             0 contract_premium, --inside formula
             ppu_pum.price_unit_name contract_premium_unit, --inside variable
             pcm.issue_date contract_issue_date,
             (case
               when pocd.is_any_day_pricing = 'N' then
                to_char(pofh.qp_start_date, 'dd-Mon-yyyy')
               else
                null
             end) average_from_date,
             (case
               when pocd.is_any_day_pricing = 'N' then
                to_char(pofh.qp_end_date, 'dd-Mon-yyyy')
               else
                null
             end) average_to_date,
             round(pofh.final_price_in_pricing_cur, 6) settlement_price,
             pofh.latest_pfc_date settlement_date,
             null strategy_id,
             null strategy_name,
             null attribute_1,
             null attribute_2,
             null attribute_3,
             null attribute_4,
             null attribute_5,
             akc.base_cur_id,
             cm_base.cur_code base_cur_code,
             ppu_pum_pay.price_unit_id trade_price_unit_id,
             ppu_pum.price_unit_id premium_discount_price_unit_id,
             ppu_pum_pay.cur_id trade_price_cur_id,
             cm_pay.cur_code trade_price_cur_code,
             ppu_pum_pay.weight trade_price_weight,
             ppu_pum_pay.weight_unit_id trade_price_weight_unit_id,
             qum_pay.qty_unit trade_price_weight_unit,
             ppu_pum.cur_id pd_price_cur_id,
             cm_ppu.cur_code pd_price_cur_code,
             ppu_pum.weight pd_price_weight,
             ppu_pum.weight_unit_id pd_price_weight_unit_id,
             qum_ppu.qty_unit pd_price_weight_unit,
             pofh.pofh_id,
             aml.attribute_id,
             aml.attribute_name,
             pofh.final_price,
             pocd.pay_in_price_unit_id,
             ppu_pum_pay.price_unit_name,
             cm_pay.cur_code pay_in_cur_code
        from pofh_history                   pofh,
             pocd_price_option_calloff_dtls pocd,
             aml_attribute_master_list      aml,
             pcdi_pc_delivery_item          pcdi,
             diqs_delivery_item_qty_status  diqs,
             qum_quantity_unit_master       qum_diqs,
             gmr_goods_movement_record      gmr,
             pcm_physical_contract_main     pcm,
             phd_profileheaderdetails       phd_cp,
             ak_corporate_user              ak_trader,
             gab_globaladdressbook          gab,
             qum_quantity_unit_master       qum_fxd,
             v_ppu_pum                      ppu_pum,
             cm_currency_master             cm_ppu,
             qum_quantity_unit_master       qum_ppu,
             ak_corporate                   akc,
             cm_currency_master             cm_base,
             v_ppu_pum                      ppu_pum_pay,
             qum_quantity_unit_master       qum_pay,
             cm_currency_master             cm_pay
       where pofh.is_deleted = 'Y'
         and pofh.pcdi_id = pcdi.pcdi_id
         and pofh.pocd_id = pocd.pocd_id
         and pofh.pcdi_id = diqs.pcdi_id
         and pocd.element_id = aml.attribute_id(+)
         and diqs.item_qty_unit_id = qum_diqs.qty_unit_id
         and pcdi.internal_contract_ref_no = pcm.internal_contract_ref_no
         and pofh.internal_gmr_ref_no = gmr.internal_gmr_ref_no(+)
         and pofh.process_id = gmr.process_id(+)
         and pcm.cp_id = phd_cp.profileid
         and pcm.trader_id = ak_trader.user_id
         and ak_trader.gabid = gab.gabid
         and pocd.qty_to_be_fixed_unit_id = qum_fxd.qty_unit_id(+)
         and pofh.latest_price_unit_id = ppu_pum.product_price_unit_id(+)
         and pcm.corporate_id = akc.corporate_id
         and akc.base_cur_id = cm_base.cur_id
         and ppu_pum.cur_id = cm_ppu.cur_id(+)
         and ppu_pum.weight_unit_id = qum_ppu.qty_unit_id(+)
         and pcdi.is_active = 'Y'
         and pcm.is_active = 'Y'
         and pofh.corporate_id = pc_corporate_id
         and pofh.process_id = pc_process_id
         and pofh.process = pc_process
         and pcm.process_id = pc_process_id
         and pcdi.process_id = pc_process_id
         and diqs.process_id = pc_process_id
         and pocd.pay_in_price_unit_id = ppu_pum_pay.product_price_unit_id
         and pocd.pay_in_cur_id = cm_pay.cur_id(+)
         and ppu_pum_pay.weight_unit_id = qum_pay.qty_unit_id
         and cm_pay.is_active = 'Y'
	     and pcm.contract_status = 'In Position'
      union all
      select 'Modified' journal_type,
             'Physical' book_type,
             pofh.corporate_id,
             akc.corporate_name,
             null product_id,
             null product_name,
             null profit_center_id,
             null profit_center_name,
             null profit_center_short_name,
             pofh.latest_pfc_no price_fixation_refno,
             pofh.pcdi_id internal_derivative_ref_no,
             (case
               when gmr.gmr_ref_no is not null then
                gmr.gmr_ref_no
               else
                pcm.contract_ref_no || '-' || pcdi.delivery_item_no
             end) delivery_item_ref_no, --bug id 69221
             diqs.total_qty delivery_item_qty,
             qum_diqs.qty_unit delivery_item_qty_unit,
             /*(case
                                                                   when gmr.gmr_ref_no is not null then
                                                                    gmr.gmr_ref_no
                                                                   else
                                                                    pcm.contract_ref_no
                                                                 end) contract_ref_no,*/
             pcm.contract_ref_no, --bug id 69221
             pcm.cp_id clearer_profile_id,
             phd_cp.companyname clearer_name,
             gab.firstname || ' ' || gab.lastname trader_name,
             pofh.finalize_date price_fixation_date,
             pofh.latest_fixed_qty fixed_quantity,
             qum_fxd.qty_unit quantity_unit,
             pofh.final_price trade_price, --has to use finalized price stored in pay-in currency for calculation, not the avg price
             ppu_pum_pay.price_unit_name price_unit,
             pofh.latest_adj_price,
             round(pkg_general.f_get_converted_currency_amt(pcm.corporate_id,
                                                            ppu_pum_pay.cur_id,
                                                            akc.base_cur_id,
                                                            pd_trade_date,
                                                            1),
                   10) pay_to_base_fx_rate,
             0 contract_premium, --inside formula
             ppu_pum.price_unit_name contract_premium_unit, --inside variable
             pcm.issue_date contract_issue_date,
             (case
               when pocd.is_any_day_pricing = 'N' then
                to_char(pofh.qp_start_date, 'dd-Mon-yyyy')
               else
                null
             end) average_from_date,
             (case
               when pocd.is_any_day_pricing = 'N' then
                to_char(pofh.qp_end_date, 'dd-Mon-yyyy')
               else
                null
             end) average_to_date,
             round(pofh.final_price_in_pricing_cur, 6) settlement_price,
             pofh.latest_pfc_date settlement_date,
             null strategy_id,
             null strategy_name,
             null attribute_1,
             null attribute_2,
             null attribute_3,
             null attribute_4,
             null attribute_5,
             akc.base_cur_id,
             cm_base.cur_code base_cur_code,
             ppu_pum_pay.price_unit_id trade_price_unit_id,
             ppu_pum.price_unit_id premium_discount_price_unit_id,
             ppu_pum_pay.cur_id trade_price_cur_id,
             cm_pay.cur_code trade_price_cur_code,
             ppu_pum_pay.weight trade_price_weight,
             ppu_pum_pay.weight_unit_id trade_price_weight_unit_id,
             qum_pay.qty_unit trade_price_weight_unit,
             ppu_pum.cur_id pd_price_cur_id,
             cm_ppu.cur_code pd_price_cur_code,
             ppu_pum.weight pd_price_weight,
             ppu_pum.weight_unit_id pd_price_weight_unit_id,
             qum_ppu.qty_unit pd_price_weight_unit,
             pofh.pofh_id,
             aml.attribute_id,
             aml.attribute_name,
             pofh.final_price,
             pocd.pay_in_price_unit_id,
             ppu_pum_pay.price_unit_name,
             cm_pay.cur_code pay_in_cur_code
        from pofh_history                   pofh,
             pocd_price_option_calloff_dtls pocd,
             aml_attribute_master_list      aml,
             pcdi_pc_delivery_item          pcdi,
             diqs_delivery_item_qty_status  diqs,
             qum_quantity_unit_master       qum_diqs,
             gmr_goods_movement_record      gmr,
             pcm_physical_contract_main     pcm,
             phd_profileheaderdetails       phd_cp,
             ak_corporate_user              ak_trader,
             gab_globaladdressbook          gab,
             qum_quantity_unit_master       qum_fxd,
             v_ppu_pum                      ppu_pum,
             cm_currency_master             cm_ppu,
             qum_quantity_unit_master       qum_ppu,
             ak_corporate                   akc,
             cm_currency_master             cm_base,
             v_ppu_pum                      ppu_pum_pay,
             cm_currency_master             cm_pay,
             qum_quantity_unit_master       qum_pay
       where pofh.is_modified = 'Y'
         and pofh.pcdi_id = pcdi.pcdi_id
         and pofh.pocd_id = pocd.pocd_id
         and pofh.pcdi_id = diqs.pcdi_id
         and pocd.element_id = aml.attribute_id(+)
         and diqs.item_qty_unit_id = qum_diqs.qty_unit_id
         and pcdi.internal_contract_ref_no = pcm.internal_contract_ref_no
         and pofh.internal_gmr_ref_no = gmr.internal_gmr_ref_no(+)
         and pofh.process_id = gmr.process_id(+)
         and pcm.cp_id = phd_cp.profileid
         and pcm.trader_id = ak_trader.user_id
         and ak_trader.gabid = gab.gabid
         and pocd.qty_to_be_fixed_unit_id = qum_fxd.qty_unit_id(+)
         and pofh.latest_price_unit_id = ppu_pum.product_price_unit_id(+)
         and pcm.corporate_id = akc.corporate_id
         and akc.base_cur_id = cm_base.cur_id
         and ppu_pum.cur_id = cm_ppu.cur_id(+)
         and ppu_pum.weight_unit_id = qum_ppu.qty_unit_id(+)
         and pcdi.is_active = 'Y'
         and pcm.is_active = 'Y'
         and pofh.corporate_id = pc_corporate_id
         and pofh.process_id = pc_process_id
         and pofh.process = pc_process
         and pcm.process_id = pc_process_id
         and pcdi.process_id = pc_process_id
         and diqs.process_id = pc_process_id
         and pocd.pay_in_price_unit_id = ppu_pum_pay.product_price_unit_id
         and pocd.pay_in_cur_id = cm_pay.cur_id(+)
         and ppu_pum_pay.weight_unit_id = qum_pay.qty_unit_id
	     and pcm.contract_status = 'In Position'
         and cm_pay.is_active = 'Y';
  
    vc_trade_cur_id        varchar2(15);
    vn_total_price         number(35, 5);
    vc_total_price_unit    varchar2(50);
    vn_pd_to_price_fx_rate number(35, 10);
    vn_pd_convertion_rate  number(35, 10);
    vn_prem_base_conv_rate number(35, 10);
    vn_prem_in_base        number(35, 10);
    vn_tp_in_base          number(35, 10);
    vn_tp_conv_rate        number(35, 10);
    vn_error_no            number := 0;
  
  begin
    for cr_cdc_row in cr_cdc_fixation
    loop
      vc_trade_cur_id := nvl(cr_cdc_row.trade_price_cur_id,
                             cr_cdc_row.base_cur_id);
      /* begin
        pkg_general.sp_get_main_cur_detail(vc_trade_cur_id,
                                           vc_trade_main_cur_id,
                                           vc_trade_main_cur_code,
                                           vn_trade_main_cur_conv_rate,
                                           vn_trade_main_decimals);
      exception
        when others then
          null;
      end;*/
    
      begin
        if vc_trade_cur_id is not null and
           cr_cdc_row.pd_price_cur_id is not null and
           vc_trade_cur_id <> cr_cdc_row.pd_price_cur_id then
          vn_pd_to_price_fx_rate := pkg_general.f_get_converted_currency_amt(pc_corporate_id,
                                                                             vc_trade_cur_id,
                                                                             cr_cdc_row.pd_price_cur_id,
                                                                             pd_trade_date,
                                                                             1);
        
        else
          vn_pd_to_price_fx_rate := 1;
        end if;
        if cr_cdc_row.trade_price_unit_id is not null and
           cr_cdc_row.premium_discount_price_unit_id is not null and
           cr_cdc_row.trade_price_unit_id <>
           cr_cdc_row.premium_discount_price_unit_id then
          vn_pd_convertion_rate := f_get_converted_price_pum(pc_corporate_id,
                                                             1,
                                                             cr_cdc_row.premium_discount_price_unit_id,
                                                             cr_cdc_row.trade_price_unit_id,
                                                             pd_trade_date,
                                                             null);
        else
          vn_pd_convertion_rate := 1;
        end if;
      exception
        when others then
          vn_pd_to_price_fx_rate := 1;
          vn_pd_convertion_rate  := 1;
      end;
      --      if cr_cdc_row.
      vn_total_price      := cr_cdc_row.trade_price +
                             (nvl(cr_cdc_row.contract_premium, 0) *
                             vn_pd_convertion_rate); --cr_cdc_row.total_price, -- be a variable
      vc_total_price_unit := cr_cdc_row.price_unit;
      vn_error_no         := 1;
      insert into eod_eom_fixation_journal
        (journal_type,
         book_type,
         process_id,
         process,
         eod_trade_date,
         corporate_id,
         corporate_name,
         product_id,
         product_name,
         profit_center_id,
         profit_center_name,
         profit_center_short_name,
         price_fixation_refno,
         internal_derivative_ref_no,
         delivery_item_ref_no,
         delivery_item_qty,
         delivery_item_qty_unit,
         contract_ref_no,
         clearer_profile_id,
         clearer_name,
         trader_name,
         price_fixation_date,
         fixed_quantity,
         quantity_unit,
         trade_price,
         price_unit,
         adjustment,
         fx_rate,
         contract_premium,
         contract_premium_unit,
         total_price,
         total_price_unit,
         contract_issue_date,
         average_from_date,
         average_to_date,
         settlement_price,
         settlement_date,
         strategy_id,
         strategy_name,
         attribute_1,
         attribute_2,
         attribute_3,
         attribute_4,
         attribute_5,
         base_cur_id,
         base_cur_code,
         price_to_base_conv_rate,
         prem_to_base_conv_rate,
         price_in_base_unit,
         premium_in_base_unit,
         base_price_unit,
         base_price_unit_id,
         trade_price_unit_id,
         prem_price_unit_id,
         base_qty_unit,
         base_qty_unit_id)
      values
        (cr_cdc_row.journal_type,
         cr_cdc_row.book_type,
         pc_process_id,
         pc_process,
         pd_trade_date,
         cr_cdc_row.corporate_id,
         cr_cdc_row.corporate_name,
         cr_cdc_row.product_id,
         cr_cdc_row.product_name,
         cr_cdc_row.profit_center_id,
         cr_cdc_row.profit_center_name,
         cr_cdc_row.profit_center_short_name,
         cr_cdc_row.price_fixation_refno,
         cr_cdc_row.internal_derivative_ref_no,
         cr_cdc_row.delivery_item_ref_no,
         cr_cdc_row.delivery_item_qty,
         cr_cdc_row.delivery_item_qty_unit,
         cr_cdc_row.contract_ref_no,
         cr_cdc_row.clearer_profile_id,
         cr_cdc_row.clearer_name,
         cr_cdc_row.trader_name,
         cr_cdc_row.price_fixation_date,
         cr_cdc_row.fixed_quantity,
         cr_cdc_row.quantity_unit,
         cr_cdc_row.trade_price,
         cr_cdc_row.price_unit,
         cr_cdc_row.adjustment,
         vn_pd_to_price_fx_rate, --need to be a variable
         cr_cdc_row.contract_premium,
         cr_cdc_row.contract_premium_unit,
         vn_total_price, --cr_cdc_row.total_price, -- be a variable
         vc_total_price_unit, -- cr_cdc_row.total_price_unit, --variable
         cr_cdc_row.contract_issue_date,
         cr_cdc_row.average_from_date,
         cr_cdc_row.average_to_date,
         cr_cdc_row.settlement_price,
         cr_cdc_row.settlement_date,
         cr_cdc_row.strategy_id,
         cr_cdc_row.strategy_name,
         cr_cdc_row.attribute_1,
         cr_cdc_row.attribute_2,
         cr_cdc_row.attribute_3,
         cr_cdc_row.attribute_4,
         cr_cdc_row.attribute_5,
         cr_cdc_row.base_cur_id,
         cr_cdc_row.base_cur_code,
         null, --price_to_base_conv_rate,
         null, --prem_to_base_conv_rate,
         null, --price_in_base_unit,
         null, --premium_in_base_unit,
         null, --base_price_unit,
         null, --base_price_unit_id,
         cr_cdc_row.trade_price_unit_id,
         cr_cdc_row.premium_discount_price_unit_id,
         cr_cdc_row.base_qty_unit,
         cr_cdc_row.base_qty_unit_id);
    end loop;
    commit;
    ---derivative price fixation ends here
    ---derivative price fixation ends here
    vn_error_no := 2;
    insert into pofh_history
      (corporate_id,
       process,
       process_id,
       trade_date,
       pcdi_id,
       pofh_id,
       pocd_id,
       internal_gmr_ref_no,
       qp_start_date,
       qp_end_date,
       qty_to_be_fixed,
       priced_qty,
       no_of_prompt_days,
       per_day_pricing_qty,
       final_price,
       finalize_date,
       version,
       is_active,
       avg_price_in_price_in_cur,
       avg_fx,
       no_of_prompt_days_fixed,
       event_name,
       delta_priced_qty,
       final_price_in_pricing_cur,
       internal_action_ref_no,
       hedge_correction_qty,
       qp_start_qty,
       is_provesional_assay_exist,
       balance_priced_qty,
       per_day_hedge_correction_qty,
       total_hedge_corrected_qty)
      select pc_corporate_id,
             pc_process,
             pc_process_id,
             pd_trade_date,
             pcdi.pcdi_id,
             pofh.pofh_id,
             pofh.pocd_id,
             pofh.internal_gmr_ref_no,
             pofh.qp_start_date,
             pofh.qp_end_date,
             pofh.qty_to_be_fixed,
             pofh.priced_qty,
             pofh.no_of_prompt_days,
             pofh.per_day_pricing_qty,
             pofh.final_price,
             pofh.finalize_date,
             pofh.version,
             pofh.is_active,
             pofh.avg_price_in_price_in_cur,
             pofh.avg_fx,
             pofh.no_of_prompt_days_fixed,
             pofh.event_name,
             pofh.delta_priced_qty,
             pofh.final_price_in_pricing_cur,
             pofh.internal_action_ref_no,
             pofh.hedge_correction_qty,
             pofh.qp_start_qty,
             pofh.is_provesional_assay_exist,
             pofh.balance_priced_qty,
             pofh.per_day_hedge_correction_qty,
             pofh.total_hedge_corrected_qty
        from pofh_price_opt_fixation_header pofh,
             pocd_price_option_calloff_dtls pocd,
             poch_price_opt_call_off_header poch,
             pcdi_pc_delivery_item          pcdi,
             pcm_physical_contract_main     pcm
       where pofh.pocd_id = pocd.pocd_id
         and pocd.poch_id = poch.poch_id
         and poch.pcdi_id = pcdi.pcdi_id
         and pcdi.internal_contract_ref_no = pcm.internal_contract_ref_no
         and pcm.corporate_id = pc_corporate_id
         and pcm.process_id = pc_process_id
         and pcdi.process_id = pc_process_id;
    --  and pcm.process_id = pc_process_id
    --  and pcdi.process_id = pc_process_id;
    commit;
    for cc in (select pfd.pofh_id,
                      max(axs.action_ref_no) price_fixation_no,
                      max(pfd.as_of_date) price_fixation_date,
                      round(sum(pfd.qty_fixed), 6) fixed_qty,
                      round(sum(pfd.qty_fixed * pfd.user_price) /
                            sum(pfd.qty_fixed),
                            6) avg_price,
                      max(pfd.price_unit_id) price_unit,
                      max(pfd.adjustment_price) adjustment_price
                 from pfd_price_fixation_details              pfd,
                      pfam_price_fix_action_mapping@eka_appdb pfam,
                      axs_action_summary@eka_appdb            axs
                where nvl(pfd.is_hedge_correction, 'N') = 'N'
                  and pfd.pfd_id = pfam.pfd_id
                  and pfam.internal_action_ref_no =
                      axs.internal_action_ref_no
                  and pfd.is_active = 'Y'
                  and pfam.is_active = 'Y'
                     --  and pfd.user_price is not null -- removed this check, as latest avg price not used, only qty fixed, pfc no to be shown
                  and axs.corporate_id = pc_corporate_id
                group by pfd.pofh_id)
    loop
      update pofh_history ppf
         set ppf.latest_pfc_no            = cc.price_fixation_no,
             ppf.latest_pfc_date          = cc.price_fixation_date,
             ppf.latest_fixed_qty         = cc.fixed_qty,
             ppf.latest_avg_price         = cc.avg_price, -- latest_avg_price this column should not be used for any calculation, as this logic changed to use the finalied price recorded in app
             ppf.latest_price_unit_id     = cc.price_unit,
             ppf.latest_adj_price         = nvl(cc.adjustment_price, 0),
             ppf.latest_adj_price_unit_id = cc.price_unit
       where ppf.corporate_id = pc_corporate_id
         and ppf.process = pc_process
         and ppf.process_id = pc_process_id
         and ppf.pofh_id = cc.pofh_id;
    end loop;
    commit;
  
    update pofh_history ppf
       set ppf.is_new = null, ppf.is_deleted = null
     where ppf.process_id = pc_process_id
       and ppf.corporate_id = pc_corporate_id
       and ppf.process = pc_process;
  
    commit;
    update pofh_history ppf
       set ppf.is_new = 'Y'
     where ppf.process_id = pc_process_id
       and ppf.corporate_id = pc_corporate_id
       and ppf.process = pc_process
       and ppf.final_price is not null
       and exists (select ppf1.pofh_id
              from pofh_history ppf1
             where ppf1.process_id = pc_prev_process_id
               and ppf1.corporate_id = pc_corporate_id
               and ppf1.process = pc_process
               and ppf1.pofh_id = ppf.pofh_id
               and ppf1.final_price is null);
    commit;
    update pofh_history ppf
       set ppf.is_new = 'Y'
     where ppf.process_id = pc_process_id
       and ppf.corporate_id = pc_corporate_id
       and ppf.process = pc_process
       and ppf.final_price is not null
       and not exists (select ppf1.pofh_id
              from pofh_history ppf1
             where ppf1.process_id = pc_prev_process_id
               and ppf1.corporate_id = pc_corporate_id
               and ppf1.process = pc_process
               and ppf1.pofh_id = ppf.pofh_id);
    commit;
    update pofh_history ppf
       set ppf.is_deleted = 'Y'
     where ppf.process_id = pc_process_id
       and ppf.corporate_id = pc_corporate_id
       and ppf.process = pc_process
       and ppf.final_price is null
       and exists (select ppf1.pofh_id
              from pofh_history ppf1
             where ppf1.process_id = pc_prev_process_id
               and ppf1.corporate_id = pc_corporate_id
               and ppf1.process = pc_process
               and ppf1.pofh_id = ppf.pofh_id
               and ppf1.final_price is not null);
    commit;
    --- check final price updated between last eod and current eod
    update pofh_history ppf
       set ppf.is_modified = 'Y'
     where ppf.process_id = pc_process_id
       and ppf.corporate_id = pc_corporate_id
       and ppf.process = pc_process
       and ppf.final_price is not null
       and exists (select ppf1.pofh_id
              from pofh_history ppf1
             where ppf1.process_id = pc_prev_process_id
               and ppf1.corporate_id = pc_corporate_id
               and ppf1.process = pc_process
               and ppf1.pofh_id = ppf.pofh_id
               and ppf1.final_price is not null
               and ppf1.final_price <> ppf.final_price);
    ---Physical price fixation starts here
    for cr_cdc_row in cr_phy_fixation
    loop
      vc_trade_cur_id := nvl(cr_cdc_row.trade_price_cur_id,
                             cr_cdc_row.base_cur_id);
    
      vn_error_no := 3;
      insert into eod_eom_fixation_journal
        (journal_type,
         book_type,
         process_id,
         process,
         eod_trade_date,
         corporate_id,
         corporate_name,
         product_id,
         product_name,
         profit_center_id,
         profit_center_name,
         profit_center_short_name,
         price_fixation_refno,
         internal_derivative_ref_no,
         delivery_item_ref_no,
         delivery_item_qty,
         delivery_item_qty_unit,
         contract_ref_no,
         clearer_profile_id,
         clearer_name,
         trader_name,
         price_fixation_date,
         fixed_quantity,
         quantity_unit,
         trade_price,
         price_unit,
         adjustment,
         fx_rate,
         contract_premium,
         contract_premium_unit,
         total_price,
         total_price_unit,
         contract_issue_date,
         average_from_date,
         average_to_date,
         settlement_price,
         settlement_date,
         strategy_id,
         strategy_name,
         attribute_1,
         attribute_2,
         attribute_3,
         attribute_4,
         attribute_5,
         base_cur_id,
         base_cur_code,
         price_to_base_conv_rate,
         prem_to_base_conv_rate,
         price_in_base_unit,
         premium_in_base_unit,
         base_price_unit,
         base_price_unit_id,
         trade_price_unit_id,
         prem_price_unit_id,
         attribute_id,
         attribute_name,
         price_in_pay_in_currency,
         pay_in_ccy_unit,
         pay_in_price_unit)
      values
        (cr_cdc_row.journal_type,
         cr_cdc_row.book_type,
         pc_process_id,
         pc_process,
         pd_trade_date,
         cr_cdc_row.corporate_id,
         cr_cdc_row.corporate_name,
         cr_cdc_row.product_id,
         cr_cdc_row.product_name,
         cr_cdc_row.profit_center_id,
         cr_cdc_row.profit_center_name,
         cr_cdc_row.profit_center_short_name,
         cr_cdc_row.price_fixation_refno,
         cr_cdc_row.internal_derivative_ref_no,
         cr_cdc_row.delivery_item_ref_no,
         cr_cdc_row.delivery_item_qty,
         cr_cdc_row.delivery_item_qty_unit,
         cr_cdc_row.contract_ref_no,
         cr_cdc_row.clearer_profile_id,
         cr_cdc_row.clearer_name,
         cr_cdc_row.trader_name,
         cr_cdc_row.price_fixation_date,
         cr_cdc_row.fixed_quantity,
         cr_cdc_row.quantity_unit,
         cr_cdc_row.trade_price,
         cr_cdc_row.price_unit,
         cr_cdc_row.latest_adj_price,
         cr_cdc_row.pay_to_base_fx_rate,
         cr_cdc_row.contract_premium,
         cr_cdc_row.contract_premium_unit,
         null, --cr_cdc_row.total_price, -- be a variable
         null, --cr_cdc_row.total_price_unit, --variable
         cr_cdc_row.contract_issue_date,
         cr_cdc_row.average_from_date,
         cr_cdc_row.average_to_date,
         cr_cdc_row.settlement_price,
         cr_cdc_row.settlement_date,
         cr_cdc_row.strategy_id,
         cr_cdc_row.strategy_name,
         cr_cdc_row.attribute_1,
         cr_cdc_row.attribute_2,
         cr_cdc_row.attribute_3,
         cr_cdc_row.attribute_4,
         cr_cdc_row.attribute_5,
         cr_cdc_row.base_cur_id,
         cr_cdc_row.base_cur_code,
         cr_cdc_row.pay_to_base_fx_rate, --price_to_base_conv_rate,
         null, --prem_to_base_conv_rate,
         null, --price_in_base_unit,
         null, --premium_in_base_unit,
         null, --base_price_unit,
         null, --base_price_unit_id,
         cr_cdc_row.trade_price_unit_id,
         cr_cdc_row.premium_discount_price_unit_id,
         cr_cdc_row.attribute_id,
         cr_cdc_row.attribute_name,
         cr_cdc_row.final_price,
         cr_cdc_row.pay_in_cur_code,
         cr_cdc_row.pay_in_price_unit);
    end loop;
    commit;
    vn_error_no := 4;
    for cc1 in (select pcdi.pcdi_id,
                       cpc.profit_center_id,
                       cpc.profit_center_name,
                       cpc.profit_center_short_name,
                       css.strategy_id,
                       css.strategy_name,
                       pdm.product_id,
                       pdm.product_desc product_name,
                       pdm.base_quantity_unit base_qty_unit_id,
                       qum.qty_unit base_qty_unit
                  from pcm_physical_contract_main   pcm,
                       pcdi_pc_delivery_item        pcdi,
                       pci_physical_contract_item   pci,
                       pcdb_pc_delivery_basis       pcdb,
                       pdm_productmaster            pdm,
                       pcpq_pc_product_quality      pcpq,
                       css_corporate_strategy_setup css,
                       pcpd_pc_product_definition   pcpd,
                       cpc_corporate_profit_center  cpc,
                       qum_quantity_unit_master     qum
                 where pcm.internal_contract_ref_no =
                       pcdi.internal_contract_ref_no
                   and pcdi.pcdi_id = pci.pcdi_id
                   and pci.pcpq_id = pcpq.pcpq_id
                   and pci.pcdb_id = pcdb.pcdb_id
                   and pcpq.pcpd_id = pcpd.pcpd_id
                   and pcm.internal_contract_ref_no =
                       pcdb.internal_contract_ref_no
                   and pcm.internal_contract_ref_no =
                       pcpd.internal_contract_ref_no
                   and pcpd.profit_center_id = cpc.profit_center_id
                   and pcpd.product_id = pdm.product_id
                   and pcpd.strategy_id = css.strategy_id
                   and pdm.base_quantity_unit = qum.qty_unit_id
                   and pcm.contract_status = 'In Position'
                   and pcm.contract_type = 'BASEMETAL'
                   and pcm.process_id = pc_process_id
                   and pcdi.process_id = pc_process_id
                   and pci.process_id = pc_process_id
                   and pcdb.process_id = pc_process_id
                   and pcpq.process_id = pc_process_id
                   and pcpd.process_id = pc_process_id
                   and nvl(pcm.is_tolling_contract, 'N') = 'N'
                   and pci.is_active = 'Y'
                   and pcm.is_active = 'Y'
                   and pcdi.is_active = 'Y'
                   and pcdi.pcdi_id in
                       (select eej.internal_derivative_ref_no
                          from eod_eom_fixation_journal eej
                         where eej.process_id = pc_process_id
                           and eej.corporate_id = pc_corporate_id
                           and eej.process = pc_process
                           and eej.book_type = 'Physical')
                 group by pcdi.pcdi_id,
                          cpc.profit_center_id,
                          cpc.profit_center_name,
                          cpc.profit_center_short_name,
                          css.strategy_id,
                          css.strategy_name,
                          pdm.product_id,
                          pdm.product_desc,
                          pdm.base_quantity_unit,
                          qum.qty_unit)
    loop
      update eod_eom_fixation_journal eej
         set eej.product_id               = cc1.product_id,
             eej.product_name             = cc1.product_name,
             eej.profit_center_id         = cc1.profit_center_id,
             eej.profit_center_name       = cc1.profit_center_name,
             eej.profit_center_short_name = cc1.profit_center_short_name,
             eej.strategy_id              = cc1.strategy_id,
             eej.strategy_name            = cc1.strategy_name,
             eej.base_qty_unit            = cc1.base_qty_unit,
             eej.base_qty_unit_id         = cc1.base_qty_unit_id
       where eej.process_id = pc_process_id
         and eej.corporate_id = pc_corporate_id
         and eej.process = pc_process
         and eej.book_type = 'Physical'
         and eej.internal_derivative_ref_no = cc1.pcdi_id;
    end loop;
    commit;
    for cr_premium in (select pcm.contract_ref_no,
                              pcdi.pcdi_id,
                              pcm.internal_contract_ref_no,
                              pum.price_unit_id premium_unit_id,
                              pum.price_unit_name premium_unit,
                              sum(pci.item_qty * pcqpd.premium_disc_value) /
                              sum(pci.item_qty) avg_premium
                       
                         from pcm_physical_contract_main     pcm,
                              pcdi_pc_delivery_item          pcdi,
                              pci_physical_contract_item     pci,
                              pcqpd_pc_qual_premium_discount pcqpd,
                              ppu_product_price_units        ppu,
                              pum_price_unit_master          pum,
                              pcpdqd_pd_quality_details      pcpdqd
                        where pcm.internal_contract_ref_no =
                              pcdi.internal_contract_ref_no
                          and pcdi.pcdi_id = pci.pcdi_id
                          and pci.pcpq_id = pcpdqd.pcpq_id
                          and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                          and pcm.internal_contract_ref_no =
                              pcqpd.internal_contract_ref_no(+)
                          and pcqpd.premium_disc_unit_id =
                              ppu.internal_price_unit_id(+)
                          and ppu.price_unit_id = pum.price_unit_id(+)
                          and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                          and pcm.process_id = pc_process_id
                          and pcdi.process_id = pc_process_id
                          and pci.process_id = pc_process_id
                          and pcqpd.process_id = pc_process_id
                          and pcm.corporate_id = pc_corporate_id
                          and pcm.is_active = 'Y'
                          and pcqpd.is_active = 'Y'
                        group by pcm.contract_ref_no,
                                 pcm.internal_contract_ref_no,
                                 pum.price_unit_id,
                                 pcdi.pcdi_id,
                                 pcm.internal_contract_ref_no,
                                 pum.price_unit_name)
    loop
    
      update eod_eom_fixation_journal eod_eom
         set eod_eom.prem_price_unit_id    = cr_premium.premium_unit_id,
             eod_eom.contract_premium      = cr_premium.avg_premium,
             eod_eom.contract_premium_unit = cr_premium.premium_unit
       where eod_eom.process_id = pc_process_id
         and eod_eom.corporate_id = pc_corporate_id
         and eod_eom.internal_derivative_ref_no = cr_premium.pcdi_id;
    end loop;
    commit;
    vn_error_no := 5;
    for cr_base in (select pum.price_unit_id,
                           pum.price_unit_name,
                           eod_eom.base_cur_id,
                           eod_eom.base_qty_unit_id
                      from eod_eom_fixation_journal eod_eom,
                           pum_price_unit_master    pum
                     where eod_eom.corporate_id = pc_corporate_id
                       and eod_eom.process_id = pc_process_id
                       and eod_eom.base_cur_id = pum.cur_id
                       and eod_eom.base_qty_unit_id = pum.weight_unit_id
                       and pum.weight is null
                       and pum.is_active = 'Y'
                       and pum.is_deleted = 'N'
                     group by pum.price_unit_id,
                              pum.price_unit_name,
                              eod_eom.base_cur_id,
                              eod_eom.base_qty_unit_id)
    loop
      update eod_eom_fixation_journal eod_eom
         set eod_eom.base_price_unit_id = cr_base.price_unit_id,
             eod_eom.base_price_unit    = cr_base.price_unit_name
       where eod_eom.process_id = pc_process_id
         and eod_eom.corporate_id = pc_corporate_id
         and eod_eom.base_cur_id = cr_base.base_cur_id
         and eod_eom.base_qty_unit_id = cr_base.base_qty_unit_id;
    end loop;
    commit;
    vn_error_no := 6;
    for cr_eod_eom in (select eod_eom.journal_type,
                              eod_eom.book_type,
                              eod_eom.prem_price_unit_id,
                              eod_eom.base_price_unit_id,
                              eod_eom.trade_price_unit_id,
                              eod_eom.product_id,
                              eod_eom.contract_premium,
                              eod_eom.trade_price, -- this price also in pay in currency
                              eod_eom.price_in_pay_in_currency,
                              eod_eom.internal_derivative_ref_no,
                              eod_eom.base_price_unit
                         from eod_eom_fixation_journal eod_eom
                        where eod_eom.corporate_id = pc_corporate_id
                          and eod_eom.process_id = pc_process_id
                       --and eod_eom.book_type = 'Physical'
                       )
    loop
    
      vn_prem_base_conv_rate := round(pkg_phy_custom_reports.f_get_converted_price_pum(pc_corporate_id,
                                                                                       1,
                                                                                       cr_eod_eom.prem_price_unit_id,
                                                                                       cr_eod_eom.base_price_unit_id,
                                                                                       pd_trade_date,
                                                                                       cr_eod_eom.product_id),
                                      4);
      vn_prem_in_base        := nvl(vn_prem_base_conv_rate *
                                    cr_eod_eom.contract_premium,
                                    0);
      vn_tp_conv_rate        := round(pkg_phy_custom_reports.f_get_converted_price_pum(pc_corporate_id,
                                                                                       1,
                                                                                       cr_eod_eom.trade_price_unit_id,
                                                                                       cr_eod_eom.base_price_unit_id,
                                                                                       pd_trade_date,
                                                                                       cr_eod_eom.product_id),
                                      4);
      /*vn_tp_in_base          := nvl(vn_tp_conv_rate *
      cr_eod_eom.trade_price,
      0);*/
      -- Note: here the trade price considered for physical is in pay-incurrency
      vn_tp_in_base := nvl(vn_tp_conv_rate * cr_eod_eom.trade_price, --don't use price_in_pay_in_currency column, this will not have data for derivative section
                           0); --bug id 68531,6859
    
      vn_total_price      := vn_tp_in_base + vn_prem_in_base;
      vc_total_price_unit := cr_eod_eom.base_price_unit;
      if cr_eod_eom.book_type = 'Physical' then
        update eod_eom_fixation_journal eod_eom
           set eod_eom.prem_to_base_conv_rate = vn_prem_base_conv_rate,
               --eod_eom.price_to_base_conv_rate = vn_tp_conv_rate,-- already added in insert query
               eod_eom.premium_in_base_unit = vn_prem_in_base,
               eod_eom.price_in_base_unit   = vn_tp_in_base,
               eod_eom.total_price          = vn_total_price,
               eod_eom.total_price_unit     = vc_total_price_unit
         where eod_eom.internal_derivative_ref_no =
               cr_eod_eom.internal_derivative_ref_no
           and eod_eom.process_id = pc_process_id
           and eod_eom.corporate_id = pc_corporate_id;
      else
        update eod_eom_fixation_journal eod_eom
           set eod_eom.prem_to_base_conv_rate  = vn_prem_base_conv_rate,
               eod_eom.fx_rate                 = vn_tp_conv_rate,
               eod_eom.price_to_base_conv_rate = vn_tp_conv_rate,
               eod_eom.premium_in_base_unit    = vn_prem_in_base,
               eod_eom.price_in_base_unit      = vn_tp_in_base,
               eod_eom.total_price             = vn_total_price,
               eod_eom.total_price_unit        = vc_total_price_unit
         where eod_eom.internal_derivative_ref_no =
               cr_eod_eom.internal_derivative_ref_no
           and eod_eom.process_id = pc_process_id
           and eod_eom.corporate_id = pc_corporate_id;
      end if;
    end loop;
    commit;
  exception
    when others then
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure sp_fixation_journal',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           ' Message:' ||
                                                           sqlerrm || ' No ' ||
                                                           vn_error_no,
                                                           null,
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
  end;

  procedure sp_physical_risk_position(pc_corporate_id varchar2,
                                      pd_trade_date   date,
                                      pc_process      varchar2,
                                      pc_process_id   varchar2,
                                      pc_user_id      varchar2) as
  
    vn_total_amount             number(30, 5);
    vn_total_amount_in_base_ccy number(30, 5);
    vn_total_market_price       number(25, 5);
    vn_total_di_price           number(25, 5);
  
  begin
  
    for cc_pofh_dtls in (select pcm.corporate_id,
                                pofh.process_id,
                                ak.corporate_name corporate,
                                pcm.cp_id,
                                phd.companyname counter_party,
                                (case
                                  when pcm.purchase_sales = 'P' then
                                   'Purchase'
                                  when pcm.purchase_sales = 'S' then
                                   'Sale'
                                end) trade_type,
                                pcm.contract_ref_no,
                                pcm.internal_contract_ref_no,
                                pcm.contract_ref_no || '-' ||
                                pcdi.delivery_item_no di_item_ref_no,
                                pcdi.pcdi_id,
                                pofh.internal_gmr_ref_no,
                                pcpd.product_id,
                                pdm.product_desc product_name,
                                pcm.contract_type product_type,
                                pcm.product_group_type,
                                null element_id,
                                null element_name,
                                pcpd.profit_center_id,
                                cpc.profit_center_name,
                                cpc.profit_center_short_name,
                                (case
                                  when pcdi.delivery_from_month is null and
                                       pcdi.delivery_from_year is null then
                                   to_char(pcdi.delivery_from_date,
                                           'dd-Mon-yyyy')
                                  else
                                   pcdi.delivery_from_month || '-' ||
                                   pcdi.delivery_from_year
                                end) del_from_date,
                                (case
                                  when pcdi.delivery_to_month is null and
                                       pcdi.delivery_to_year is null then
                                   to_char(pcdi.delivery_to_date,
                                           'dd-Mon-yyyy')
                                  else
                                   pcdi.delivery_to_month || '-' ||
                                   pcdi.delivery_to_year
                                end) del_to_date,
                                diqs.total_qty del_item_total_qty,
                                diqs.item_qty_unit_id di_qty_unit_id,
                                qum_di.qty_unit di_qty_unit,
                                cym.country_name || ' , ' || sm.state_name ||
                                ' , ' || cm_city.city_name stock_location,
                                pcdb.duty_status duty_status,
                                sum(nvl(pofh.priced_qty, 0)) priced_qty,
                                sum(pofh.qty_to_be_fixed) -
                                sum(nvl(pofh.priced_qty, 0)) del_item_qty,
                                pocd.qty_to_be_fixed_unit_id priced_qty_unit_id,
                                qum_priced.qty_unit price_qty_unit,
                                ak.base_cur_id,
                                cm_base.cur_code base_ccy,
                                /*cq.close_rate*/
                                pkg_general.f_get_converted_currency_amt(pc_corporate_id,
                                                                         pcm.invoice_currency_id,
                                                                         ak.base_cur_id,
                                                                         pd_trade_date,
                                                                         1) close_rate
                         
                           from pofh_history                   pofh,
                                pocd_price_option_calloff_dtls pocd,
                                poch_price_opt_call_off_header poch,
                                pcdi_pc_delivery_item          pcdi,
                                pcm_physical_contract_main     pcm,
                                ak_corporate                   ak,
                                phd_profileheaderdetails       phd,
                                pcpd_pc_product_definition     pcpd,
                                pdm_productmaster              pdm,
                                cpc_corporate_profit_center    cpc,
                                diqs_delivery_item_qty_status  diqs,
                                pcdb_pc_delivery_basis         pcdb,
                                cym_countrymaster              cym,
                                sm_state_master                sm,
                                cim_citymaster                 cm_city,
                                qum_quantity_unit_master       qum_di,
                                qum_quantity_unit_master       qum_priced,
                                cm_currency_master             cm_base
                         --cq_currency_quote              cq
                         
                          where pofh.pocd_id = pocd.pocd_id
                            and pocd.poch_id = poch.poch_id
                            and poch.pcdi_id = pcdi.pcdi_id
                            and pcdi.internal_contract_ref_no =
                                pcm.internal_contract_ref_no
                            and pofh.process_id = pc_process_id
                            and pofh.process = pc_process
                            and pcdi.process_id = pc_process_id
                            and pcm.process_id = pc_process_id
                            and pcm.corporate_id = ak.corporate_id
                            and pcm.cp_id = phd.profileid
                            and pcm.internal_contract_ref_no =
                                pcpd.internal_contract_ref_no
                            and pcpd.process_id = pc_process_id
                            and pcpd.product_id = pdm.product_id
                            and pcpd.profit_center_id = cpc.profit_center_id
                            and pcdi.pcdi_id = diqs.pcdi_id
                            and pcdi.process_id = pc_process_id
                            and diqs.process_id = pc_process_id
                            and pcm.internal_contract_ref_no =
                                pcdb.internal_contract_ref_no
                            and pcdb.process_id = pc_process_id
                            and pcdb.country_id = cym.country_id
                            and pcdb.state_id = sm.state_id
                            and pcdb.city_id = cm_city.city_id
                            and cym.country_id = sm.country_id
                               --and sm.state_id = cm_city.state_id --Bugid 69246
                            and diqs.item_qty_unit_id = qum_di.qty_unit_id
                            and diqs.process_id = pc_process_id
                            and pocd.qty_to_be_fixed_unit_id =
                                qum_priced.qty_unit_id
                            and ak.base_cur_id = cm_base.cur_id
                            and pcm.corporate_id = pc_corporate_id
                            and pcm.contract_type = 'BASEMETAL'
                               --and cq.corporate_id = pc_corporate_id
                               --and cq.cur_date = pd_trade_date
                               --and cq.cur_id = pcm.invoice_currency_id
                            and pcm.is_active = 'Y'
                            and pcdi.is_active = 'Y'
                            and poch.is_active = 'Y'
                            and pocd.is_active = 'Y'
                            and pofh.is_active = 'Y'
                               --and cq.is_deleted = 'N'
                            and pcm.contract_status = 'In Position'
                          group by pcm.corporate_id,
                                   pofh.process_id,
                                   ak.corporate_name,
                                   pcm.cp_id,
                                   phd.companyname,
                                   pcm.purchase_sales,
                                   pcm.purchase_sales,
                                   pcm.contract_ref_no,
                                   pcm.internal_contract_ref_no,
                                   pcm.contract_ref_no,
                                   pcdi.delivery_item_no,
                                   pcdi.pcdi_id,
                                   pofh.internal_gmr_ref_no,
                                   pcpd.product_id,
                                   pdm.product_desc,
                                   pcm.contract_type,
                                   pcm.product_group_type,
                                   pcpd.profit_center_id,
                                   cpc.profit_center_name,
                                   cpc.profit_center_short_name,
                                   pcdi.delivery_from_month,
                                   pcdi.delivery_from_year,
                                   pcdi.delivery_from_date,
                                   pcdi.delivery_to_month,
                                   pcdi.delivery_to_year,
                                   pcdi.delivery_to_date,
                                   diqs.total_qty,
                                   diqs.item_qty_unit_id,
                                   qum_di.qty_unit,
                                   pocd.qty_to_be_fixed_unit_id,
                                   qum_priced.qty_unit,
                                   ak.base_cur_id,
                                   cm_base.cur_code,
                                   --cq.close_rate,
                                   cym.country_name,
                                   sm.state_name,
                                   cm_city.city_name,
                                   pcdb.duty_status,
                                   pcm.invoice_currency_id)
    loop
    
      insert into prp_physical_risk_position
        (corporate_id,
         corporate,
         cp_id,
         counter_party,
         trade_type,
         cont_ref_no,
         int_cont_ref_no,
         di_item_ref_no,
         pcdi_id,
         int_gmr_ref_no,
         product_id,
         product_name,
         product_type,
         product_group,
         element_id,
         element_name,
         profit_center_id,
         profit_center_name,
         profit_center_short_name,
         del_from_date,
         del_to_date,
         del_item_qty,
         di_qty_unit_id,
         di_qty_unit,
         stock_location,
         duty_status,
         priced_qty,
         priced_qty_unit_id,
         price_qty_unit,
         base_cur_id,
         base_ccy,
         fx_rate,
         process_id,
         process)
      values
        (cc_pofh_dtls.corporate_id,
         cc_pofh_dtls.corporate,
         cc_pofh_dtls.cp_id,
         cc_pofh_dtls.counter_party,
         cc_pofh_dtls.trade_type,
         cc_pofh_dtls.contract_ref_no,
         cc_pofh_dtls.internal_contract_ref_no,
         cc_pofh_dtls.di_item_ref_no,
         cc_pofh_dtls.pcdi_id,
         cc_pofh_dtls.internal_gmr_ref_no,
         cc_pofh_dtls.product_id,
         cc_pofh_dtls.product_name,
         cc_pofh_dtls.product_type,
         cc_pofh_dtls.product_group_type,
         cc_pofh_dtls.element_id,
         cc_pofh_dtls.element_name,
         cc_pofh_dtls.profit_center_id,
         cc_pofh_dtls.profit_center_name,
         cc_pofh_dtls.profit_center_short_name,
         cc_pofh_dtls.del_from_date,
         cc_pofh_dtls.del_to_date,
         cc_pofh_dtls.del_item_qty,
         cc_pofh_dtls.di_qty_unit_id,
         cc_pofh_dtls.di_qty_unit,
         cc_pofh_dtls.stock_location,
         cc_pofh_dtls.duty_status,
         cc_pofh_dtls.priced_qty,
         cc_pofh_dtls.priced_qty_unit_id,
         cc_pofh_dtls.price_qty_unit,
         cc_pofh_dtls.base_cur_id,
         cc_pofh_dtls.base_ccy,
         cc_pofh_dtls.close_rate,
         cc_pofh_dtls.process_id,
         pc_process);
    end loop;
    commit;
    --contract price
    for cc_m2m_data in (select cipd.pcdi_id,
                               cipd.contract_price di_item_price,
                               ppu_pum.product_price_unit_id di_item_price_unit_id,
                               ppu_pum.price_unit_name di_item_price_unit,
                               pcqpd.avg_premium,
                               pcqpd.premium_unit_id,
                               pum_pd.price_unit_name
                          from cipd_contract_item_price_daily cipd,
                               v_ppu_pum                      ppu_pum,
                               /*pcqpd_pc_qual_premium_discount pcqpd,*/
                               (select pcm.contract_ref_no,
                                       pcdi.pcdi_id,
                                       pcm.internal_contract_ref_no,
                                       pum.price_unit_id premium_unit_id,
                                       pum.price_unit_name premium_unit,
                                       sum(pci.item_qty *
                                           pcqpd.premium_disc_value) /
                                       sum(pci.item_qty) avg_premium
                                
                                  from pcm_physical_contract_main     pcm,
                                       pcdi_pc_delivery_item          pcdi,
                                       pci_physical_contract_item     pci,
                                       pcqpd_pc_qual_premium_discount pcqpd,
                                       ppu_product_price_units        ppu,
                                       pum_price_unit_master          pum,
                                       pcpdqd_pd_quality_details      pcpdqd
                                 where pcm.internal_contract_ref_no =
                                       pcdi.internal_contract_ref_no
                                   and pcdi.pcdi_id = pci.pcdi_id
                                   and pci.pcpq_id = pcpdqd.pcpq_id
                                   and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                   and pcm.internal_contract_ref_no =
                                       pcqpd.internal_contract_ref_no(+)
                                   and pcqpd.premium_disc_unit_id =
                                       ppu.internal_price_unit_id(+)
                                   and ppu.price_unit_id =
                                       pum.price_unit_id(+)
                                   and pcpdqd.pcqpd_id = pcqpd.pcqpd_id
                                   and pcm.process_id = pc_process_id
                                   and pcdi.process_id = pc_process_id
                                   and pci.process_id = pc_process_id
                                   and pcqpd.process_id = pc_process_id
                                   and pcm.corporate_id = pc_corporate_id
                                   and pcm.is_active = 'Y'
                                   and pcqpd.is_active = 'Y'
                                 group by pcm.contract_ref_no,
                                          pcm.internal_contract_ref_no,
                                          pum.price_unit_id,
                                          pcdi.pcdi_id,
                                          pcm.internal_contract_ref_no,
                                          pum.price_unit_name) pcqpd,
                               pum_price_unit_master pum_pd
                         where cipd.price_unit_id =
                               ppu_pum.product_price_unit_id
                           and cipd.process_id = pc_process_id
                           and cipd.internal_contract_ref_no =
                               pcqpd.internal_contract_ref_no(+)
                           and cipd.pcdi_id = pcqpd.pcdi_id
                           and cipd.corporate_id = pc_corporate_id
                           and pcqpd.premium_unit_id = pum_pd.price_unit_id)
    loop
      update prp_physical_risk_position prp
         set prp.di_price                 = cc_m2m_data.di_item_price,
             prp.di_price_unit_id         = cc_m2m_data.di_item_price_unit_id,
             prp.di_price_unit            = cc_m2m_data.di_item_price_unit,
             prp.contract_premium         = cc_m2m_data.avg_premium,
             prp.contract_premium_unit_id = cc_m2m_data.premium_unit_id,
             prp.contract_premium_unit    = cc_m2m_data.price_unit_name
       where cc_m2m_data.pcdi_id = prp.pcdi_id
         and prp.process_id = pc_process_id
         and prp.corporate_id = pc_corporate_id
         and prp.di_price is null
         and prp.product_type = 'BASEMETAL';
    end loop;
    commit;
    --For updating the m2m price
    for cc_m2m_price in (select poud.pcdi_id,
                                nvl(md.m2m_settlement_price, 0) market_price,
                                md.m2m_price_unit_id,
                                pum.price_unit_name m2m_price_unit,
                                nvl(md.m2m_quality_premium, 0) market_premium,
                                md.base_price_unit_id_in_ppu market_premium_price_unit_id,
                                ppu_pum_pd.cur_id market_premium_cur_id,
                                cm_pd.cur_code market_premium_ccy
                           from poud_phy_open_unreal_daily poud,
                                md_m2m_daily               md,
                                pum_price_unit_master      pum,
                                v_ppu_pum                  ppu_pum_mp,
                                v_ppu_pum                  ppu_pum_pd,
                                cm_currency_master         cm_pd
                          where poud.corporate_id = pc_corporate_id
                               --and cipd.pcdi_id = poud.pcdi_id
                            and poud.process_id = pc_process_id
                            and poud.unrealized_type = 'Unrealized'
                            and poud.md_id = md.md_id
                            and md.process_id = pc_process_id
                            and md.m2m_price_unit_id = pum.price_unit_id
                            and pum.is_active = 'Y'
                            and md.base_price_unit_id_in_ppu =
                                ppu_pum_mp.product_price_unit_id
                            and ppu_pum_mp.cur_id = cm_pd.cur_id
                            and md.base_price_unit_id_in_ppu =
                                ppu_pum_pd.product_price_unit_id)
    loop
      update prp_physical_risk_position prp
         set prp.market_price          = cc_m2m_price.market_price,
             prp.market_price_unit_id  = cc_m2m_price.m2m_price_unit_id,
             prp.market_price_unit     = cc_m2m_price.m2m_price_unit, --
             prp.market_premium        = cc_m2m_price.market_premium,
             prp.market_premium_cur_id = cc_m2m_price.market_premium_cur_id,
             prp.market_premium_ccy    = cc_m2m_price.market_premium_ccy
      
       where cc_m2m_price.pcdi_id = prp.pcdi_id
         and prp.process_id = pc_process_id
         and prp.corporate_id = pc_corporate_id
         and prp.product_type = 'BASEMETAL';
    end loop;
    commit;
    --for event base price
    for cc_event in (select gpd.internal_gmr_ref_no,
                            gpd.corporate_id,
                            gpd.contract_price,
                            gpd.price_unit_id,
                            gpd.price_unit_cur_id,
                            gpd.price_unit_cur_code
                       from gpd_gmr_price_daily gpd
                      where gpd.process_id = pc_process_id
                        and gpd.corporate_id = pc_corporate_id)
    loop
      update prp_physical_risk_position prp
         set prp.di_price       = cc_event.contract_price,
             prp.di_qty_unit_id = cc_event.price_unit_id,
             prp.di_qty_unit    = cc_event.price_unit_cur_code
       where prp.corporate_id = cc_event.corporate_id
         and prp.process_id = pc_process_id
         and prp.process = pc_process
         and prp.di_price is null
         and prp.int_gmr_ref_no = cc_event.internal_gmr_ref_no
         and prp.product_type = 'BASEMETAL';
    end loop;
    commit;
    --for event based m2m data
    for cc_psu_data in (select psu.corporate_id,
                               psu.internal_gmr_ref_no,
                               nvl(psu.contract_premium_value, 0) contract_premium,
                               psu.prev_market_value_cur_id contract_premium_unit_id,
                               psu.prev_market_value_cur_code contract_premium_unit,
                               nvl(md.m2m_settlement_price, 0) market_price,
                               md.m2m_price_unit_cur_id market_price_unit_id,
                               md.m2m_price_unit_cur_code market_price_unit,
                               nvl(md.m2m_quality_premium, 0) m2m_quality_premium,
                               psu.m2m_price_unit_cur_id,
                               psu.m2m_price_unit_cur_code,
                               md.base_price_unit_id_in_pum,
                               pum.cur_id market_premium_cur_id,
                               cm.cur_code market_premium_cur
                          from psu_phy_stock_unrealized psu,
                               md_m2m_daily             md,
                               pum_price_unit_master    pum,
                               cm_currency_master       cm
                         where psu.process_id = md.process_id
                           and psu.md_id = md.md_id
                           and md.base_price_unit_id_in_pum =
                               pum.price_unit_id
                           and pum.cur_id = cm.cur_id
                           and psu.process_id = pc_process_id
                           and md.process_id = pc_process_id
                           and md.product_type = 'BASEMETAL')
    loop
      update prp_physical_risk_position prp
         set prp.contract_premium         = cc_psu_data.contract_premium,
             prp.contract_premium_unit_id = cc_psu_data.contract_premium_unit_id,
             prp.contract_premium_unit    = cc_psu_data.contract_premium_unit,
             prp.market_price             = cc_psu_data.market_price,
             prp.market_price_unit_id     = cc_psu_data.market_price_unit_id,
             prp.market_price_unit        = cc_psu_data.market_price_unit,
             prp.market_premium           = cc_psu_data.m2m_quality_premium,
             prp.market_premium_cur_id    = cc_psu_data.market_premium_cur_id,
             prp.market_premium_ccy       = cc_psu_data.market_premium_cur
      
       where cc_psu_data.internal_gmr_ref_no = prp.int_gmr_ref_no
         and prp.process_id = pc_process_id
         and prp.corporate_id = pc_corporate_id
         and prp.product_type = 'BASEMETAL';
    end loop;
    commit;
    --Calculate total
    for cc_prp in (select nvl(prp.market_premium, 0) market_premium,
                          nvl(prp.contract_premium, 0) contract_premium,
                          nvl(prp.market_price, 0) market_price,
                          nvl(prp.di_price, 0) di_price,
                          prp.del_item_qty,
                          nvl(prp.priced_qty, 0) priced_qty,
                          prp.market_premium_cur_id,
                          prp.fx_rate,
                          prp.pcdi_id
                     from prp_physical_risk_position prp
                    where prp.corporate_id = pc_corporate_id
                      and prp.process_id = pc_process_id)
    loop
    
      vn_total_market_price := cc_prp.market_price + cc_prp.market_premium;
      vn_total_di_price     := cc_prp.di_price + cc_prp.contract_premium;
    
      vn_total_amount             := round(cc_prp.del_item_qty *
                                           (vn_total_market_price -
                                           vn_total_di_price),
                                           4);
      vn_total_amount_in_base_ccy := vn_total_amount * cc_prp.fx_rate;
    
      update prp_physical_risk_position prp
         set prp.total_amount      = vn_total_amount,
             prp.total_in_base_ccy = vn_total_amount_in_base_ccy
       where prp.pcdi_id = cc_prp.pcdi_id
         and prp.process_id = pc_process_id
         and prp.corporate_id = pc_corporate_id;
    end loop;
    commit;
  exception
    when others then
      null; -- TODO siva
  end;
  procedure sp_update_strategy_attributes(pc_corporate_id varchar2,
                                          pd_trade_date   date,
                                          pc_process      varchar2,
                                          pc_process_id   varchar2,
                                          pc_user_id      varchar2) is
    --------------------------------------------------------------------------------------------------------------------------
    --        Procedure Name                            : sp_update_strategy_attributes
    --        Author                                    : Siva
    --        Created Date                              : 01-Aug-2012
    --        Purpose                                   :
    --
    --        Parameters
    --        pc_corporate_id                           : Corporate ID
    --        pd_trade_date                             : Trade Date
    --        pc_user_id                                : User ID
    --        pc_process                                : Process EOD or EOM
    --
    --        Modification History
    --        Modified Date                             :
    --        Modified By                               :
    --        Modify Description                        :
    --------------------------------------------------------------------------------------------------------------------------
    vobj_error_log     tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count number := 1;
    vn_error_no        number := 0;
  
    cursor stg is
      select tt.corporate_startegy_id startegy_id,
             tt.strategy_name,
             max(case
                   when tt.order_seq = 1 then
                    tt.attribute_name
                   else
                    null
                 end) attribute_name_1,
             max(case
                   when tt.order_seq = 1 then
                    tt.attribute_value
                   else
                    null
                 end) attribute_value_1,
             ----------
             max(case
                   when tt.order_seq = 2 then
                    tt.attribute_name
                   else
                    null
                 end) attribute_name_2,
             max(case
                   when tt.order_seq = 2 then
                    tt.attribute_value
                   else
                    null
                 end) attribute_value_2,
             ---------
             max(case
                   when tt.order_seq = 3 then
                    tt.attribute_name
                   else
                    null
                 end) attribute_name_3,
             max(case
                   when tt.order_seq = 3 then
                    tt.attribute_value
                   else
                    null
                 end) attribute_value_3,
             ----
             max(case
                   when tt.order_seq = 4 then
                    tt.attribute_name
                   else
                    null
                 end) attribute_name_4,
             max(case
                   when tt.order_seq = 4 then
                    tt.attribute_value
                   else
                    null
                 end) attribute_value_4,
             max(case
                   when tt.order_seq = 5 then
                    tt.attribute_name
                   else
                    null
                 end) attribute_name_5,
             max(case
                   when tt.order_seq = 5 then
                    tt.attribute_value
                   else
                    null
                 end) attribute_value_5
        from (select eam.entity_value_id corporate_startegy_id,
                     css.strategy_name,
                     etm.entity_type_name,
                     adm.attribute_def_id,
                     adm.attribute_name,
                     avm.attribute_value,
                     nvl(avm.attribute_value_desc, avm.attribute_value) attribute_value_desc,
                     rank() over(partition by eam.entity_value_id order by adm.attribute_name asc) order_seq
                from eam_entity_attribute_mapping@eka_appdb eam,
                     etm_entity_type_master@eka_appdb       etm,
                     adm_attribute_def_master@eka_appdb     adm,
                     avm_attribute_value_master@eka_appdb   avm,
                     css_corporate_strategy_setup           css
               where upper(etm.entity_type_name) = 'STRATEGY'
                 and eam.attribute_value_id = avm.attribute_value_id
                 and eam.attribute_def_id = adm.attribute_def_id
                 and eam.entity_type_id = etm.entity_type_id
                 and eam.entity_value_id = css.strategy_id
                 and css.corporate_id = 'BLD'
                 and css.is_active = 'Y'
                 and css.is_deleted = 'N'
                 and eam.is_deleted = 'N') tt
       where tt.order_seq <= 5
       group by tt.corporate_startegy_id,
                tt.strategy_name;
  
  begin
    for stg_rwo in stg
    loop
      update eod_eom_booking_journal eod
         set eod.attribute_1 = stg_rwo.attribute_value_1,
             eod.attribute_2 = stg_rwo.attribute_value_2,
             eod.attribute_3 = stg_rwo.attribute_value_3,
             eod.attribute_4 = stg_rwo.attribute_value_4,
             eod.attribute_5 = stg_rwo.attribute_value_5
       where eod.corporate_id = pc_corporate_id
         and eod.process_id = pc_process_id
         and eod.strategy_id = stg_rwo.startegy_id;
      commit;
      update eod_eom_derivative_journal eod
         set eod.attribute_1 = stg_rwo.attribute_value_1,
             eod.attribute_2 = stg_rwo.attribute_value_2,
             eod.attribute_3 = stg_rwo.attribute_value_3,
             eod.attribute_4 = stg_rwo.attribute_value_4,
             eod.attribute_5 = stg_rwo.attribute_value_5
       where eod.corporate_id = pc_corporate_id
         and eod.process_id = pc_process_id
         and eod.strategy_id = stg_rwo.startegy_id;
      commit;
      update eod_eom_fixation_journal eod
         set eod.attribute_1 = stg_rwo.attribute_value_1,
             eod.attribute_2 = stg_rwo.attribute_value_2,
             eod.attribute_3 = stg_rwo.attribute_value_3,
             eod.attribute_4 = stg_rwo.attribute_value_4,
             eod.attribute_5 = stg_rwo.attribute_value_5
       where eod.corporate_id = pc_corporate_id
         and eod.process_id = pc_process_id
         and eod.strategy_id = stg_rwo.startegy_id;
      commit;
      update eod_eom_phy_contract_journal eod
         set eod.attribute_1 = stg_rwo.attribute_value_1,
             eod.attribute_2 = stg_rwo.attribute_value_2,
             eod.attribute_3 = stg_rwo.attribute_value_3,
             eod.attribute_4 = stg_rwo.attribute_value_4,
             eod.attribute_5 = stg_rwo.attribute_value_5
       where eod.corporate_id = pc_corporate_id
         and eod.process_id = pc_process_id
         and eod.strategy_id = stg_rwo.startegy_id;
      commit;
    end loop;
    commit;
  exception
    when others then
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure sp_update_strategy_attributes',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           ' Message:' ||
                                                           sqlerrm ||
                                                           vn_error_no,
                                                           null,
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
  end;
end; 
/
