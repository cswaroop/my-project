CREATE OR REPLACE PACKAGE PKG_PHY_CALCULATE_COG is
  procedure sp_calc_invm_cog(pc_corporate_id varchar2,
                             pc_process_id   varchar2,
                             pc_user_id      varchar2,
                             pd_trade_date   date,
                             pc_process      varchar2);
  procedure sp_calc_invm_cogs(pc_corporate_id varchar2,
                              pc_process_id   varchar2,
                              pc_user_id      varchar2,
                              pd_trade_date   date,
                              pc_process      varchar2);
  procedure sp_calc_gmr_sec_cost(pc_corporate_id varchar2,
                                 pc_process_id   varchar2,
                                 pc_user_id      varchar2,
                                 pd_trade_date   date,
                                 pc_process      varchar2);
end; 
/
CREATE OR REPLACE PACKAGE BODY PKG_PHY_CALCULATE_COG is
  procedure sp_calc_invm_cog(pc_corporate_id varchar2,
                             pc_process_id   varchar2,
                             pc_user_id      varchar2,
                             pd_trade_date   date,
                             pc_process      varchar2) is
    vobj_error_log                tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count            number := 1;
    vc_error_msg                  varchar2(5) := '0';
    vn_qty_conv_price_to_stock    number;
    vn_qty_conv_stock_to_base     number;
    vn_fw_exch_rate_trans_to_base number;
    vn_forward_points             number;
    vc_exch_rate_string           varchar2(25);
    vc_base_cur_id                varchar2(15);
    vc_base_cur_code              varchar2(15);
    vn_price_to_base_fw_exch_rate number;
  begin
    select akc.base_cur_id,
           akc.base_currency_name
      into vc_base_cur_id,
           vc_base_cur_code
      from ak_corporate akc
     where akc.corporate_id = pc_corporate_id;
  
    insert into tinvp_temp_invm_cog
      (corporate_id,
       process_id,
       internal_cost_id,
       cost_type,
       internal_grd_ref_no,
       product_id,
       base_qty_unit_id,
       base_qty_unit,
       grd_current_qty,
       grd_qty_unit_id,
       cost_value,
       transformation_ratio,
       transaction_price_unit_id,
       transaction_cur_factor,
       transaction_amt_cur_id,
       transaction_amt_main_cur_id,
       base_cur_id,
       base_cur_code,
       base_price_unit_id,
       price_qty_unit_id,
       price_weight,
       price_to_stock_wt_conversion,
       stock_to_base_wt_conversion,
       transact_to_base_fw_exch_rate,
       base_price_unit_id_in_ppu,
       transact_amt_sign,
       gmr_qty)
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign transact_amt_sign,
             gmr.stock_current_qty
        from scm_stock_cost_mapping      scm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             invm_inventory_master       invm,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record gmr
       where scm.internal_grd_ref_no = grd.internal_grd_ref_no
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Accrual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and invm.internal_grd_ref_no = grd.internal_grd_ref_no
         and invm.process_id = pc_process_id
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and invm.is_active = 'Y'
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and grd.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             1,
             gmr.stock_current_qty
        from scm_stock_cost_mapping      scm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             invm_inventory_master       invm,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record gmr
       where scm.internal_grd_ref_no = grd.internal_grd_ref_no
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Actual' -- Overaccrual case avoid
         and cs.cost_ref_no in
             (select distinct cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_ref_no = cs.cost_ref_no
                 and cs_in.cost_type = 'Actual'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.is_deleted = 'N'
                 and cs_in.process_id = pc_process_id)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and invm.internal_grd_ref_no = grd.internal_grd_ref_no
         and invm.process_id = pc_process_id
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and invm.is_active = 'Y'
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_under_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and grd.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             case
               when scms.cost_display_name = 'Material Cost' then
                'Price'
               when scms.cost_display_name = 'Location Premium' then
                'Location Premium'
               when scms.cost_display_name = 'Quality Premium' then
                'Quality Premium'
               when scms.cost_display_name = 'Penalties' then
                'Penalties'
               when scms.cost_display_name = 'Refining Charges' then
                'Refining Charges'
               when scms.cost_display_name = 'Treatment Charges' then
                'Treatment Charges'
             end cost_type,
             grd.internal_grd_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             case when scms.cost_display_name = 'Material Cost' then cs.fx_to_base else 1 end,
             ppu.product_price_unit_id,
             1,
             gmr.stock_current_qty
        from scm_stock_cost_mapping      scm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             invm_inventory_master       invm,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record gmr
       where scm.internal_grd_ref_no = grd.internal_grd_ref_no
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_display_name in
             ('Material Cost', 'Location Premium', 'Quality Premium',
              'Penalties', 'Refining Charges', 'Treatment Charges')
         and cs.cost_type in ('Actual', 'Accrual')
         and cs.is_actual_posted_in_cog = 'Y'
         and cs.internal_cost_id in
             (select substr(max(to_char(axs.created_date,
                                        'yyyymmddhh24missff9') ||
                                cs.internal_cost_id),
                            24)
                from cs_cost_store      cs,
                     axs_action_summary axs
               where cs.process_id = pc_process_id
                 and cs.internal_action_ref_no = axs.internal_action_ref_no
                 and cs.process_id = pc_process_id
                 and cs.is_deleted = 'N'
               group by cs.cost_ref_no)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and invm.internal_grd_ref_no = grd.internal_grd_ref_no
         and invm.process_id = pc_process_id
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and invm.is_active = 'Y'
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_under_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and grd.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             case
               when scms.cost_display_name = 'Treatment Charges' then
                1
               when scms.cost_display_name = 'Refining Charges' then
                1
               when scms.cost_display_name = 'Penalties' then
                1
               else
                cs.transact_amt_sign
             end transact_amt_sign,
             gmr.stock_current_qty
        from scm_stock_cost_mapping      scm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             invm_inventory_master       invm,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record gmr
       where scm.internal_grd_ref_no = grd.internal_grd_ref_no
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Direct Actual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and invm.internal_grd_ref_no = grd.internal_grd_ref_no
         and invm.process_id = pc_process_id
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and invm.is_active = 'Y'
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_direct_actual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and grd.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             case
               when scms.cost_display_name = 'Treatment Charges' then
                1
               when scms.cost_display_name = 'Refining Charges' then
                1
               when scms.cost_display_name = 'Penalties' then
                1
               else
                cs.transact_amt_sign
             end transact_amt_sign,
             gmr.stock_current_qty
        from scm_stock_cost_mapping      scm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             invm_inventory_master       invm,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record gmr
       where scm.internal_grd_ref_no = grd.internal_grd_ref_no
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Reversal'
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and invm.internal_grd_ref_no = grd.internal_grd_ref_no
         and invm.process_id = pc_process_id
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and invm.is_active = 'Y'
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_over_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and grd.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id;
     commit;
    --
    -- Quantity Conversion from Price Weight Unit to Stock Weight Unit
    --         
    for cur_conv1 in (select t.product_id,
                             t.price_qty_unit_id,
                             t.grd_qty_unit_id
                        from tinvp_temp_invm_cog t
                       where t.process_id = pc_process_id
                         and t.price_qty_unit_id <> t.grd_qty_unit_id
                       group by t.price_qty_unit_id,
                                t.grd_qty_unit_id,
                                t.product_id)
    loop
      select pkg_general.f_get_converted_quantity(cur_conv1.product_id,
                                                  cur_conv1.price_qty_unit_id,
                                                  cur_conv1.grd_qty_unit_id,
                                                  1)
        into vn_qty_conv_price_to_stock
        from dual;
      update tinvp_temp_invm_cog t
         set t.price_to_stock_wt_conversion = vn_qty_conv_price_to_stock
       where t.price_qty_unit_id = cur_conv1.price_qty_unit_id
         and t.grd_qty_unit_id = cur_conv1.grd_qty_unit_id
         and t.product_id = cur_conv1.product_id
         and t.process_id = pc_process_id;
    end loop;
    commit;
    --
    -- Quantity Conversion from Stock Weight Unit to Product Base Unit
    --
    for cur_conv2 in (select t.product_id,
                             t.grd_qty_unit_id,
                             t.base_qty_unit_id
                        from tinvp_temp_invm_cog t
                       where t.grd_qty_unit_id <> t.base_qty_unit_id
                         and t.process_id = pc_process_id
                       group by t.product_id,
                                t.grd_qty_unit_id,
                                t.base_qty_unit_id)
    loop
      select pkg_general.f_get_converted_quantity(cur_conv2.product_id,
                                                  cur_conv2.grd_qty_unit_id,
                                                  cur_conv2.base_qty_unit_id,
                                                  1)
        into vn_qty_conv_stock_to_base
        from dual;
      update tinvp_temp_invm_cog t
         set t.price_to_stock_wt_conversion = vn_qty_conv_stock_to_base
       where t.base_qty_unit_id = cur_conv2.base_qty_unit_id
         and t.grd_qty_unit_id = cur_conv2.grd_qty_unit_id
         and t.product_id = cur_conv2.product_id
         and t.process_id = pc_process_id;
    end loop;
    commit;
    --
    -- Value in Transaction Currency
    --    
    update tinvp_temp_invm_cog t
       set t.value_in_transact_currency = t.cost_value *
                                          t.transaction_cur_factor *
                                          t.price_to_stock_wt_conversion *
                                          t.grd_current_qty *
                                          t.transformation_ratio /
                                          t.price_weight
     where t.process_id = pc_process_id;
     commit;
  
    --
    -- Get the Exchange Rate from Transaction Main Currency to Base Currency
    --
    for cur_exch_rate in (select t.transaction_amt_main_cur_id,
                                 t.base_cur_id,
                                 cm_base.cur_code base_cur_code,
                                 cm_trans.cur_code transaction_amt_main_cur_code
                            from tinvp_temp_invm_cog t,
                                 cm_currency_master  cm_trans,
                                 cm_currency_master  cm_base
                           where t.transaction_amt_main_cur_id <>
                                 t.base_cur_id
                             and t.process_id = pc_process_id
                             and t.transaction_amt_main_cur_id =
                                 cm_trans.cur_id
                             and t.base_cur_id = cm_base.cur_id
                             and t.cost_type not in ('Secondary Cost','Price')
                           group by t.transaction_amt_main_cur_id,
                                    t.base_cur_id,
                                    cm_base.cur_code,
                                    cm_trans.cur_code)
    loop
      pkg_general.sp_bank_fx_rate(pc_corporate_id,
                                  pd_trade_date,
                                  pd_trade_date,
                                  cur_exch_rate.transaction_amt_main_cur_id,
                                  cur_exch_rate.base_cur_id,
                                  30,
                                  'procedure pkg_phy_calculate_cog.sp_calc_invm_cog',
                                  pc_process,
                                  vn_fw_exch_rate_trans_to_base,
                                  vn_forward_points);
      update tinvp_temp_invm_cog t
         set t.trans_to_base_fw_exch_rate    = '1 ' ||
                                               cur_exch_rate.transaction_amt_main_cur_code || '=' ||
                                               vn_fw_exch_rate_trans_to_base || ' ' ||
                                               cur_exch_rate.base_cur_code,
             t.transact_to_base_fw_exch_rate = vn_fw_exch_rate_trans_to_base
       where t.transaction_amt_main_cur_id =
             cur_exch_rate.transaction_amt_main_cur_id
         and t.process_id = pc_process_id
         and t.cost_type not in ('Secondary Cost','Price');
    
    end loop;
   commit;
   
     --
    -- Get the Exchange Rate from Transaction Main Currency to Base Currency for seconday cost
    --
    for cur_exch_rate in (select t.transaction_amt_main_cur_id,
                                 t.base_cur_id,
                                 cm_base.cur_code base_cur_code,
                                 cm_trans.cur_code transaction_amt_main_cur_code,
                                 t.transact_to_base_fw_exch_rate,
                                 t.internal_cost_id
                            from tinvp_temp_invm_cog t,
                                 cm_currency_master  cm_trans,
                                 cm_currency_master  cm_base
                           where t.transaction_amt_main_cur_id <>
                                 t.base_cur_id
                             and t.process_id = pc_process_id
                             and t.transaction_amt_main_cur_id =
                                 cm_trans.cur_id
                             and t.base_cur_id = cm_base.cur_id
                             and t.cost_type in ('Secondary Cost','Price')
                           )
    loop  
      update tinvp_temp_invm_cog t
         set t.trans_to_base_fw_exch_rate    = '1 ' ||
                                               cur_exch_rate.transaction_amt_main_cur_code || '=' ||
                                               cur_exch_rate.transact_to_base_fw_exch_rate || ' ' ||
                                               cur_exch_rate.base_cur_code
       where t.transaction_amt_main_cur_id =
             cur_exch_rate.transaction_amt_main_cur_id
         and t.process_id = pc_process_id
         and t.cost_type in ('Secondary Cost','Price')
         and t.transact_to_base_fw_exch_rate = cur_exch_rate.transact_to_base_fw_exch_rate
         and t.internal_cost_id = cur_exch_rate.internal_cost_id;
    end loop;
   commit;
    --
    -- Update Value in Base and Avg Cost in Base Price Unit
    --
  
    update tinvp_temp_invm_cog t
       set t.value_in_base_currency = t.value_in_transact_currency *
                                      t.transact_to_base_fw_exch_rate *
                                      t.transact_amt_sign,
           t.avg_cost               = (t.transact_amt_sign *
                                      t.value_in_transact_currency *
                                      t.transact_to_base_fw_exch_rate) /
                                      (t.stock_to_base_wt_conversion *
                                      t.grd_current_qty)
     where t.process_id = pc_process_id;
     commit;
    --
    -- All calculations done and ready with data into invm_cog
    --
    insert into invm_cog
      (process_id,
       internal_grd_ref_no,
       material_cost_per_unit,
       secondary_cost_per_unit,
       product_premium_per_unit,
       quality_premium_per_unit,
       tc_charges_per_unit,
       rc_charges_per_unit,
       pc_charges_per_unit,
       total_mc_charges,
       total_tc_charges,
       total_rc_charges,
       total_pc_charges,
       total_sc_charges,
       price_to_base_fw_exch_rate_act,
       price_to_base_fw_exch_rate,
       contract_qp_fw_exch_rate,
       contract_pp_fw_exch_rate,
       accrual_to_base_fw_exch_rate,
       tc_to_base_fw_exch_rate,
       rc_to_base_fw_exch_rate,
       pc_to_base_fw_exch_rate)
      select pc_process_id,
             internal_grd_ref_no,
             nvl(sum(nvl(material_cost_per_unit,0)),0) ,
             nvl(sum(nvl(secondary_cost_per_unit,0)),0) ,
             nvl(sum(nvl(product_premium_per_unit,0)),0) ,
             nvl(sum(nvl(quality_premium_per_unit,0)),0) ,
             nvl(sum(tc_charges_per_unit), 0),
             nvl(sum(rc_charges_per_unit), 0),
             nvl(sum(pc_charges_per_unit), 0),
             nvl(sum(total_mc_charges), 0),
             nvl(sum(total_tc_charges), 0),
             nvl(sum(total_rc_charges), 0),
             nvl(sum(total_pc_charges), 0),
             nvl(sum(total_sc_charges), 0),
             min(price_to_base_fw_exch_rate_act),
             f_string_aggregate(price_to_base_fw_exch_rate),
             f_string_aggregate(contract_qp_fw_exch_rate),
             f_string_aggregate(contract_pp_fw_exch_rate),
             f_string_aggregate(accrual_to_base_fw_exch_rate),
             f_string_aggregate(tc_to_base_fw_exch_rate),
             f_string_aggregate(rc_to_base_fw_exch_rate),
             f_string_aggregate(pc_to_base_fw_exch_rate)
        from (select t.internal_grd_ref_no,
                    /* t.gmr_qty,*/
                     case
                       when t.cost_type = 'Price' then
                        t.cost_value
                       else
                        0
                     end as material_cost_per_unit,
                     case
                       when t.cost_type = 'Price' then
                        t.avg_cost * t.grd_current_qty *
                        t.stock_to_base_wt_conversion
                       else
                        0
                     end as total_mc_charges,
                     case
                       when t.cost_type = 'Price' then
                        t.transact_to_base_fw_exch_rate
                       else
                        null
                     end as price_to_base_fw_exch_rate_act,
                     case
                       when t.cost_type = 'Price' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as price_to_base_fw_exch_rate,
                     case
                       when t.cost_type = 'Location Premium' then
                        t.avg_cost * t.grd_current_qty *
                        t.stock_to_base_wt_conversion
                       else
                        0
                     end as total_lp_charges,
                     case
                       when t.cost_type = 'Location Premium' then
                        t.avg_cost
                       else
                        0
                     end as product_premium_per_unit,
                     case
                       when t.cost_type = 'Location Premium' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as contract_pp_fw_exch_rate,
                     case
                       when t.cost_type = 'Quality Premium' then
                        t.avg_cost
                       else
                        0
                     end as quality_premium_per_unit,
                      case
                       when t.cost_type = 'Quality Premium' then
                        t.avg_cost * t.grd_current_qty *
                        t.stock_to_base_wt_conversion
                       else
                        0
                     end as total_qp_charges,
                     case
                       when t.cost_type = 'Quality Premium' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as contract_qp_fw_exch_rate,
                     case
                       when t.cost_type = 'Secondary Cost' then
                        t.avg_cost
                       else
                        0
                     end as secondary_cost_per_unit,
                     case
                       when t.cost_type = 'Secondary Cost' then
                        t.avg_cost * t.grd_current_qty *
                        t.stock_to_base_wt_conversion
                       else
                        0
                     end as total_sc_charges,
                     case
                       when t.cost_type = 'Secondary Cost' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as accrual_to_base_fw_exch_rate,
                     case
                       when t.cost_type = 'Treatment Charges' then
                        t.avg_cost * t.grd_current_qty *
                        t.stock_to_base_wt_conversion
                       else
                        0
                     end as total_tc_charges,
                     case
                       when t.cost_type = 'Treatment Charges' then
                        t.avg_cost
                       else
                        0
                     end as tc_charges_per_unit,
                     case
                       when t.cost_type = 'Refining Charges' then
                        t.avg_cost
                       else
                        0
                     end as rc_charges_per_unit,
                     case
                       when t.cost_type = 'Penalties' then
                        t.avg_cost
                       else
                        0
                     end as pc_charges_per_unit,
                     case
                       when t.cost_type = 'Treatment Charges' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as tc_to_base_fw_exch_rate,
                     case
                       when t.cost_type = 'Refining Charges' then
                        t.avg_cost * t.grd_current_qty *
                        t.stock_to_base_wt_conversion
                       else
                        0
                     end as total_rc_charges,
                     case
                       when t.cost_type = 'Refining Charges' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as rc_to_base_fw_exch_rate,
                     case
                       when t.cost_type = 'Penalties' then
                        t.avg_cost * t.grd_current_qty *
                        t.stock_to_base_wt_conversion
                       else
                        0
                     end as total_pc_charges,
                     case
                       when t.cost_type = 'Penalties' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as pc_to_base_fw_exch_rate
                from tinvp_temp_invm_cog t
               where t.process_id = pc_process_id) t
       group by internal_grd_ref_no;
        commit; 
        
    -- update price unit
      for cc_update in (select t.internal_grd_ref_no,
                           pum.product_price_unit_id price_unit_id,
                           pum.cur_id price_unit_cur_id,
                           cm.cur_code price_unit_cur_code,
                           pum.weight_unit_id price_unit_weight_unit_id,
                           qum.qty_unit price_unit_weight_unit,
                           1 weight
                      from tinvp_temp_invm_cog      t,
                           v_ppu_pum                pum,
                           cm_currency_master       cm,
                           qum_quantity_unit_master qum
                     where t.process_id = pc_process_id
                       and t.cost_type = 'Price'
                       and t.transaction_price_unit_id = pum.price_unit_id
                       and t.product_id = pum.product_id
                       and pum.cur_id = cm.cur_id
                       and pum.weight_unit_id = qum.qty_unit_id)
  loop
    update invm_cog invm
       set invm.price_unit_id             = cc_update.price_unit_id,
           invm.price_unit_cur_id         = cc_update.price_unit_cur_id,
           invm.price_unit_cur_code       = cc_update.price_unit_cur_code,
           invm.price_unit_weight_unit_id = cc_update.price_unit_weight_unit_id,
           invm.price_unit_weight_unit    = cc_update.price_unit_weight_unit,
           invm.price_unit_weight         = cc_update.weight
     where invm.process_id = pc_process_id
       and invm.internal_grd_ref_no = cc_update.internal_grd_ref_no;  
  end loop;          
  commit;           
                 
    -- Insert Element Price/TC/RC Details
    insert into invme_cog_element
      (process_id,
       internal_grd_ref_no,
       element_id,
       mc_per_unit,
       mc_price_unit_id,
       tc_per_unit,
       tc_price_unit_id,
       rc_per_unit,
       rc_price_unit_id,
       payable_qty,
       payable_qty_unit_id)
      select pc_process_id,
             t.internal_grd_ref_no,
             t.element_id,
             sum(mc_per_unit),
             max(mc_price_unit_id),
             nvl(sum(tc_per_unit), 0),
             max(tc_price_unit_id),
             nvl(sum(rc_per_unit), 0),
             max(rc_price_unit_id),
             payable_qty,
             payable_qty_unit_id
        from (select t.internal_grd_ref_no,
                     ecs.element_id,
                     case
                       when t.cost_type = 'Price' then
                        ecs.cost_value
                       else
                        0
                     end mc_per_unit,
                     case
                       when t.cost_type = 'Price' then
                        ecs.rate_price_unit_id
                       else
                        null
                     end mc_price_unit_id,
                     case
                       when t.cost_type = 'Treatment Charges' then
                        ecs.cost_value
                       else
                        null
                     end tc_per_unit,
                     case
                       when t.cost_type = 'Treatment Charges' then
                        ecs.rate_price_unit_id
                       else
                        null
                     end tc_price_unit_id,
                     case
                       when t.cost_type = 'Refining Charges' then
                        ecs.cost_value
                       else
                        null
                     end rc_per_unit,
                     case
                       when t.cost_type = 'Refining Charges' then
                        ecs.rate_price_unit_id
                       else
                        null
                     end rc_price_unit_id,
                     ecs.payable_qty,
                     ecs.qty_unit_id payable_qty_unit_id
                from tinvp_temp_invm_cog    t,
                     ecs_element_cost_store ecs
               where t.process_id = pc_process_id
                 and ecs.process_id = pc_process_id
                 and t.internal_cost_id = ecs.internal_cost_id
                 and t.cost_type <> 'Secondary Cost'
                 and ecs.internal_cost_id in
                     (select substr(max(to_char(axs.created_date,
                                                'yyyymmddhh24missff9') ||
                                        cs.internal_cost_id),
                                    24)
                        from cs_cost_store      cs,
                             axs_action_summary axs
                       where cs.process_id = pc_process_id
                         and cs.internal_action_ref_no =
                             axs.internal_action_ref_no
                         and cs.process_id = pc_process_id
                         and cs.is_deleted = 'N'
                       group by cs.cost_ref_no)) t
       group by t.internal_grd_ref_no,
                t.element_id,
                t.payable_qty,
                t.payable_qty_unit_id;
         commit;
    update invme_cog_element t
       set (t.mc_price_unit_name, t.mc_price_unit_cur_id, t.mc_price_unit_cur_code, t.mc_price_unit_weight_unit_id, t.mc_price_unit_weight_unit, t.mc_price_unit_weight) = (select ppu.price_unit_name,
                                                                                                                                                                                   cm.cur_id,
                                                                                                                                                                                   cm.cur_code,
                                                                                                                                                                                   qum.qty_unit_id,
                                                                                                                                                                                   qum.qty_unit,
                                                                                                                                                                                   ppu.weight
                                                                                                                                                                              from v_ppu_pum                ppu,
                                                                                                                                                                                   cm_currency_master       cm,
                                                                                                                                                                                   qum_quantity_unit_master qum
                                                                                                                                                                             where ppu.product_price_unit_id =
                                                                                                                                                                                   t.mc_price_unit_id
                                                                                                                                                                               and cm.cur_id =
                                                                                                                                                                                   ppu.cur_id
                                                                                                                                                                               and qum.qty_unit_id =
                                                                                                                                                                                   ppu.weight_unit_id)
     where t.process_id = pc_process_id;
   commit;
    update invme_cog_element t
       set (t.tc_price_unit_name) = (select ppu.price_unit_name
                                       from v_ppu_pum ppu
                                      where ppu.product_price_unit_id =
                                            t.tc_price_unit_id)
     where t.process_id = pc_process_id;
    commit;
  
    update invme_cog_element t
       set (t.rc_price_unit_name) = (select ppu.price_unit_name
                                       from v_ppu_pum ppu
                                      where ppu.product_price_unit_id =
                                            t.rc_price_unit_id)
     where t.process_id = pc_process_id;
     
      commit;
  
    for cur_price_ex_rate in (select t.mc_price_unit_cur_id,
                                     t.mc_price_unit_cur_code
                                from invme_cog_element t
                               where t.process_id = pc_process_id
                                 and t.mc_price_unit_cur_id <>
                                     vc_base_cur_id)
    loop
      pkg_general.sp_bank_fx_rate(pc_corporate_id,
                                  pd_trade_date,
                                  pd_trade_date,
                                  cur_price_ex_rate.mc_price_unit_cur_id,
                                  vc_base_cur_id,
                                  30,
                                  'INVME_COG Element Price to Base',
                                  pc_process,
                                  vn_price_to_base_fw_exch_rate,
                                  vn_forward_points);
      if vn_price_to_base_fw_exch_rate <> 0 then
        update invme_cog_element t
           set t.price_to_base_fw_exch_rate = '1 ' ||
                                              cur_price_ex_rate.mc_price_unit_cur_code || '=' ||
                                              vn_price_to_base_fw_exch_rate || ' ' ||
                                              vc_base_cur_code
         where t.process_id = pc_process_id
           and t.mc_price_unit_cur_id =
               cur_price_ex_rate.mc_price_unit_cur_id;
      
      end if;
    
    end loop;
     commit;
  exception
    when others then
     commit;
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure pkg_phy_physical_process sp_calc_invm_cog',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           'Message:' ||
                                                           sqlerrm ||
                                                           dbms_utility.format_error_backtrace ||
                                                           'No ' ||
                                                           vc_error_msg,
                                                           '',
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
    
  end;

  procedure sp_calc_invm_cogs(pc_corporate_id varchar2,
                              pc_process_id   varchar2,
                              pc_user_id      varchar2,
                              pd_trade_date   date,
                              pc_process      varchar2) is
    vobj_error_log                tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count            number := 1;
    vc_error_msg                  varchar2(5) := '0';
    vn_qty_conv_price_to_stock    number;
    vn_qty_conv_stock_to_base     number;
    vn_fw_exch_rate_trans_to_base number;
    vn_forward_points             number;
    vc_exch_rate_string           varchar2(25);
    vc_base_cur_id                varchar2(15);
    vc_base_cur_code              varchar2(15);
    vn_price_to_base_fw_exch_rate number;
  begin
    select akc.base_cur_id,
           akc.base_currency_name
      into vc_base_cur_id,
           vc_base_cur_code
      from ak_corporate akc
     where akc.corporate_id = pc_corporate_id;
     
    insert into tinvs_temp_invm_cogs
      (corporate_id,
       process_id,
       internal_cost_id,
       cost_type,
       internal_grd_ref_no,
       sales_internal_gmr_ref_no,
       product_id,
       base_qty_unit_id,
       base_qty_unit,
       original_inv_qty,
       inv_qty_unit_id,
       cost_value,
       transformation_ratio,
       transaction_price_unit_id,
       transaction_cur_factor,
       transaction_amt_cur_id,
       transaction_amt_main_cur_id,
       base_cur_id,
       base_cur_code,
       base_price_unit_id,
       price_qty_unit_id,
       price_weight,
       price_to_stock_wt_conversion,
       stock_to_base_wt_conversion,
       transact_to_base_fw_exch_rate,
       base_price_unit_id_in_ppu,
       transact_amt_sign)
 select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             invm.sales_internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             invm.original_inv_qty stock_qty,
             invm.inv_qty_id qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign transact_amt_sign
        from scm_stock_cost_mapping      scm,
             invs_inventory_sales        invm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm
       where invm.internal_dgrd_ref_no = scm.internal_dgrd_ref_no
         and invm.process_id = pc_process_id
         and invm.sales_internal_gmr_ref_no = scm.internal_gmr_ref_no
         and scm.parent_stock_ref_no = grd.internal_grd_ref_no
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         AND scm.is_propagated_cost = 'Y'
         AND nvl(scm.is_material_cost,'N') = 'N'
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Accrual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and invm.is_active = 'Y'
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and cigc.cog_ref_no not in
             (select cigc_in.cog_ref_no
                from cigc_contract_item_gmr_cost cigc_in,
                     gmr_goods_movement_record   gmr
               where cigc_in.internal_gmr_ref_no = gmr.internal_gmr_ref_no
                 and cigc_in.process_id = pc_process_id
                 and gmr.process_id = pc_process_id
                 and gmr.is_deleted = 'N'
                 and cigc_in.is_deleted = 'N'
                 and gmr.contract_type = 'Sales')

      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             invm.sales_internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             invm.original_inv_qty stock_qty,
             invm.inv_qty_id inv_qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             1
        from scm_stock_cost_mapping      scm,
             invs_inventory_sales        invm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm
       where invm.process_id = pc_process_id
         and invm.internal_dgrd_ref_no = scm.internal_dgrd_ref_no
         and invm.process_id = pc_process_id
         and scm.internal_gmr_ref_no = invm.sales_internal_gmr_ref_no
         AND scm.parent_stock_ref_no = grd.internal_grd_ref_no
         AND scm.is_propagated_cost = 'Y'
          AND scm.is_material_cost = 'N'
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Actual' -- Overaccrual case avoid
         and cs.cost_ref_no in
             (select distinct cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_ref_no = cs.cost_ref_no
                 and cs_in.cost_type = 'Actual'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.is_deleted = 'N'
                 and cs_in.process_id = pc_process_id)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and invm.is_active = 'Y'
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_under_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and cigc.cog_ref_no not in
             (select cigc_in.cog_ref_no
                from cigc_contract_item_gmr_cost cigc_in,
                     gmr_goods_movement_record   gmr
               where cigc_in.internal_gmr_ref_no = gmr.internal_gmr_ref_no
                 and cigc_in.process_id = pc_process_id
                 and gmr.process_id = pc_process_id
                 and gmr.is_deleted = 'N'
                 and cigc_in.is_deleted = 'N'
                 and gmr.contract_type = 'Sales')
      union all 
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             case
               when scms.cost_display_name = 'Material Cost' then
                'Price'
               when scms.cost_display_name = 'Location Premium' then
                'Location Premium'
               when scms.cost_display_name = 'Quality Premium' then
                'Quality Premium'
               when scms.cost_display_name = 'Penalties' then
                'Penalties'
               when scms.cost_display_name = 'Refining Charges' then
                'Refining Charges'
               when scms.cost_display_name = 'Treatment Charges' then
                'Treatment Charges'
             end cost_type,
             grd.internal_grd_ref_no,
             invm.sales_internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             invm.original_inv_qty stock_qty,
             invm.inv_qty_id inv_qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             case when scms.cost_display_name = 'Material Cost' then cs.fx_to_base else 1 end,
             ppu.product_price_unit_id,
             1
        from scm_stock_cost_mapping      scm,
             invs_inventory_sales invm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm
       where invm.internal_dgrd_ref_no = scm.internal_dgrd_ref_no
         and invm.process_id = pc_process_id
         AND scm.parent_stock_ref_no = grd.internal_grd_ref_no
         and scm.internal_gmr_ref_no = invm.sales_internal_gmr_ref_no
         AND scm.is_propagated_cost = 'Y'
         AND scm.is_material_cost = 'Y'
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_display_name in
             ('Material Cost', 'Location Premium', 'Quality Premium',
              'Penalties', 'Refining Charges', 'Treatment Charges')
         and cs.cost_type in ('Actual', 'Accrual')
         and cs.internal_cost_id in
             (select substr(max(to_char(axs.created_date,
                                        'yyyymmddhh24missff9') ||
                                cs.internal_cost_id),
                            24)
                from cs_cost_store      cs,
                     axs_action_summary axs
               where cs.process_id = pc_process_id
                 and cs.internal_action_ref_no = axs.internal_action_ref_no
                 and cs.process_id = pc_process_id
                 and cs.is_deleted = 'N'
               group by cs.cost_ref_no)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and invm.is_active = 'Y'
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_under_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and cigc.cog_ref_no not in
             (select cigc_in.cog_ref_no
                from cigc_contract_item_gmr_cost cigc_in,
                     gmr_goods_movement_record   gmr
               where cigc_in.internal_gmr_ref_no = gmr.internal_gmr_ref_no
                 and cigc_in.process_id = pc_process_id
                 and gmr.process_id = pc_process_id
                 and gmr.is_deleted = 'N'
                 and cigc_in.is_deleted = 'N'
                 and gmr.contract_type = 'Sales')
      union all 
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost'cost_type,
             grd.internal_grd_ref_no,
             invm.sales_internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             invm.original_inv_qty stock_qty,
             invm.inv_qty_id inv_qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             case
               when scms.cost_display_name = 'Treatment Charges' then
                1
               when scms.cost_display_name = 'Refining Charges' then
                1
               when scms.cost_display_name = 'Penalties' then
                1
               else
                cs.transact_amt_sign
             end transact_amt_sign
        from scm_stock_cost_mapping      scm,
             invs_inventory_sales        invm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm
       where invm.internal_dgrd_ref_no = scm.internal_dgrd_ref_no
         and invm.process_id = pc_process_id
         and scm.internal_gmr_ref_no = invm.sales_internal_gmr_ref_no
         and scm.parent_stock_ref_no = grd.internal_grd_ref_no
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scm.is_propagated_cost = 'Y'
         and scm.is_material_cost = 'N'
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Direct Actual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and invm.is_active = 'Y'
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_direct_actual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and cigc.cog_ref_no not in
             (select cigc_in.cog_ref_no
                from cigc_contract_item_gmr_cost cigc_in,
                     gmr_goods_movement_record   gmr
               where cigc_in.internal_gmr_ref_no = gmr.internal_gmr_ref_no
                 and cigc_in.process_id = pc_process_id
                 and gmr.process_id = pc_process_id
                 and gmr.is_deleted = 'N'
                 and cigc_in.is_deleted = 'N'
                 and gmr.contract_type = 'Sales')
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             invm.sales_internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             invm.original_inv_qty stock_qty,
             invm.inv_qty_id inv_qty_unit_id,
             cs.cost_value,
             scm.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             case
               when scms.cost_display_name = 'Treatment Charges' then
                1
               when scms.cost_display_name = 'Refining Charges' then
                1
               when scms.cost_display_name = 'Penalties' then
                1
               else
                cs.transact_amt_sign
             end transact_amt_sign
        from scm_stock_cost_mapping      scm,
             invs_inventory_sales        invm,
             grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm
       where invm.internal_dgrd_ref_no = scm.internal_dgrd_ref_no
         and invm.process_id = pc_process_id
          AND scm.internal_gmr_ref_no = invm.sales_internal_gmr_ref_no
          AND scm.parent_stock_ref_no = grd.internal_grd_ref_no
          AND scm.is_propagated_cost = 'Y'
          AND scm.is_material_cost = 'N'
         and scm.cog_ref_no = cigc.cog_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Reversal'
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and scm.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and invm.is_active = 'Y'
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_over_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and grd.tolling_stock_type = 'None Tolling'
         and cigc.cog_ref_no not in
             (select cigc_in.cog_ref_no
                from cigc_contract_item_gmr_cost cigc_in,
                     gmr_goods_movement_record   gmr
               where cigc_in.internal_gmr_ref_no = gmr.internal_gmr_ref_no
                 and cigc_in.process_id = pc_process_id
                 and gmr.process_id = pc_process_id
                 and gmr.is_deleted = 'N'
                 and cigc_in.is_deleted = 'N'
                 and gmr.contract_type = 'Sales');
     commit;            
    --
    -- Quantity Conversion from Price Weight Unit to Stock Weight Unit
    --         
    for cur_conv1 in (select t.product_id,
                             t.price_qty_unit_id,
                             t.inv_qty_unit_id
                        from tinvs_temp_invm_cogs t
                       where t.process_id = pc_process_id
                         and t.price_qty_unit_id <> t.inv_qty_unit_id
                       group by t.price_qty_unit_id,
                                t.inv_qty_unit_id,
                                t.product_id)
    loop
      select pkg_general.f_get_converted_quantity(cur_conv1.product_id,
                                                  cur_conv1.price_qty_unit_id,
                                                  cur_conv1.inv_qty_unit_id,
                                                  1)
        into vn_qty_conv_price_to_stock
        from dual;
      update tinvs_temp_invm_cogs t
         set t.price_to_stock_wt_conversion = vn_qty_conv_price_to_stock
       where t.price_qty_unit_id = cur_conv1.price_qty_unit_id
         and t.inv_qty_unit_id = cur_conv1.inv_qty_unit_id
         and t.product_id = cur_conv1.product_id
         and t.process_id = pc_process_id;
    end loop;
    commit;
    --
    -- Quantity Conversion from Stock Weight Unit to Product Base Unit
    --
    for cur_conv2 in (select t.product_id,
                             t.inv_qty_unit_id,
                             t.base_qty_unit_id
                        from tinvs_temp_invm_cogs t
                       where t.inv_qty_unit_id <> t.base_qty_unit_id
                         and t.process_id = pc_process_id
                       group by t.product_id,
                                t.inv_qty_unit_id,
                                t.base_qty_unit_id)
    loop
      select pkg_general.f_get_converted_quantity(cur_conv2.product_id,
                                                  cur_conv2.inv_qty_unit_id,
                                                  cur_conv2.base_qty_unit_id,
                                                  1)
        into vn_qty_conv_stock_to_base
        from dual;
      update tinvs_temp_invm_cogs t
         set t.price_to_stock_wt_conversion = vn_qty_conv_stock_to_base
       where t.base_qty_unit_id = cur_conv2.base_qty_unit_id
         and t.inv_qty_unit_id = cur_conv2.inv_qty_unit_id
         and t.product_id = cur_conv2.product_id
         and t.process_id = pc_process_id;
    end loop;
    commit;
    --
    -- Value in Transaction Currency
    --    
    update tinvs_temp_invm_cogs t
       set t.value_in_transact_currency = t.cost_value *
                                          t.transaction_cur_factor *
                                          t.price_to_stock_wt_conversion *
                                          t.original_inv_qty *
                                          t.transformation_ratio /
                                          t.price_weight
     where t.process_id = pc_process_id;
    commit;
    --
    -- Get the Exchange Rate from Transaction Main Currency to Base Currency with out seconday cost
    --
    for cur_exch_rate in (select t.transaction_amt_main_cur_id,
                                 t.base_cur_id,
                                 cm_base.cur_code base_cur_code,
                                 cm_trans.cur_code transaction_amt_main_cur_code
                            from tinvs_temp_invm_cogs t,
                                 cm_currency_master   cm_trans,
                                 cm_currency_master   cm_base
                           where t.transaction_amt_main_cur_id <>
                                 t.base_cur_id
                             and t.process_id = pc_process_id
                             and t.transaction_amt_main_cur_id =
                                 cm_trans.cur_id
                             and t.base_cur_id = cm_base.cur_id
                             and t.cost_type not in ('Secondary Cost','Price')
                           group by t.transaction_amt_main_cur_id,
                                    t.base_cur_id,
                                    cm_base.cur_code,
                                    cm_trans.cur_code)
    loop
      pkg_general.sp_bank_fx_rate(pc_corporate_id,
                                  pd_trade_date,
                                  pd_trade_date,
                                  cur_exch_rate.transaction_amt_main_cur_id,
                                  cur_exch_rate.base_cur_id,
                                  30,
                                  'procedure pkg_phy_calculate_cog.sp_calc_invm_cogs',
                                  pc_process,
                                  vn_fw_exch_rate_trans_to_base,
                                  vn_forward_points);
    
      update tinvs_temp_invm_cogs t
         set t.trans_to_base_fw_exch_rate    = '1 ' ||
                                               cur_exch_rate.transaction_amt_main_cur_code || '=' ||
                                               vn_fw_exch_rate_trans_to_base || ' ' ||
                                               cur_exch_rate.base_cur_code,
             t.transact_to_base_fw_exch_rate = vn_fw_exch_rate_trans_to_base
       where t.transaction_amt_main_cur_id =
             cur_exch_rate.transaction_amt_main_cur_id
         and t.process_id = pc_process_id
         and t.cost_type not in ('Secondary Cost','Price');
    
    end loop;
    commit;
    
    
     --
    -- Get the Exchange Rate from Transaction Main Currency to Base Currency for seconday cost
    --
    for cur_exch_rate in (select t.transaction_amt_main_cur_id,
                                 t.base_cur_id,
                                 cm_base.cur_code base_cur_code,
                                 cm_trans.cur_code transaction_amt_main_cur_code,
                                 t.transact_to_base_fw_exch_rate,
                                 t.internal_cost_id
                            from tinvp_temp_invm_cog t,
                                 cm_currency_master  cm_trans,
                                 cm_currency_master  cm_base
                           where t.transaction_amt_main_cur_id <>
                                 t.base_cur_id
                             and t.process_id = pc_process_id
                             and t.transaction_amt_main_cur_id =
                                 cm_trans.cur_id
                             and t.base_cur_id = cm_base.cur_id
                             and t.cost_type in ('Secondary Cost','Price'))
    loop  
      update tinvs_temp_invm_cogs t
         set t.trans_to_base_fw_exch_rate    = '1 ' ||
                                               cur_exch_rate.transaction_amt_main_cur_code || '=' ||
                                               cur_exch_rate.transact_to_base_fw_exch_rate || ' ' ||
                                               cur_exch_rate.base_cur_code
       where t.transaction_amt_main_cur_id =
             cur_exch_rate.transaction_amt_main_cur_id
         and t.process_id = pc_process_id
         and t.cost_type in ('Secondary Cost','Price')
         and t.transact_to_base_fw_exch_rate = cur_exch_rate.transact_to_base_fw_exch_rate
         and t.internal_cost_id = cur_exch_rate.internal_cost_id;
    
    end loop;
   commit;
    --
    -- Update Value in Base and Avg Cost in Base Price Unit
    --
  
    update tinvs_temp_invm_cogs t
       set t.value_in_base_currency = t.value_in_transact_currency *
                                      t.transact_to_base_fw_exch_rate ,
           t.avg_cost               = ((t.value_in_transact_currency *
                                      t.transact_to_base_fw_exch_rate) /
                                      (t.stock_to_base_wt_conversion *
                                      t.original_inv_qty))
     where t.process_id = pc_process_id;
     commit;
    --
    -- All calculations done and ready with data into invm_cog
    --
    insert into invm_cogs
      (process_id,
       sales_internal_gmr_ref_no,
       internal_grd_ref_no,
       material_cost_per_unit,
       secondary_cost_per_unit,
       product_premium_per_unit,
       quality_premium_per_unit,
       tc_charges_per_unit,
       rc_charges_per_unit,
       pc_charges_per_unit,
       total_mc_charges,
       total_tc_charges,
       total_rc_charges,
       total_pc_charges,
       total_sc_charges,
       price_to_base_fw_exch_rate_act,
       price_to_base_fw_exch_rate,
       contract_qp_fw_exch_rate,
       contract_pp_fw_exch_rate,
       accrual_to_base_fw_exch_rate,
       tc_to_base_fw_exch_rate,
       rc_to_base_fw_exch_rate,
       pc_to_base_fw_exch_rate)
      select pc_process_id,
             sales_internal_gmr_ref_no,
             internal_grd_ref_no,
             case when sum(mc_stock_qty) = 0 then 0  -- This should never happen, price should not come as zero
             else
             sum(total_mc_charges_trans) / sum(mc_stock_qty)
             end material_cost_per_unit ,
             0 , -- secondary_cost_per_unit =  Will Update below as it has to be per Cost Component Name
             case when sum(lp_stock_qty)= 0 then 0 
             else
             sum(total_lp_charges_base) / sum(lp_stock_qty) 
             end product_premium_per_unit,
             case when sum(Qp_stock_qty) = 0 then 0 
             else
             sum(total_Qp_charges_base) / sum(Qp_stock_qty) 
             end  quality_premium_per_unit,
             0,--nvl(sum(tc_charges_per_unit), 0),
             0,--nvl(sum(rc_charges_per_unit), 0),
             0,--nvl(sum(pc_charges_per_unit), 0),
             0,--nvl(sum(total_mc_charges), 0),
             0,-- nvl(sum(total_tc_charges), 0),
             0,-- nvl(sum(total_rc_charges), 0),
             0,-- nvl(sum(total_pc_charges), 0),
             0,-- nvl(sum(total_sc_charges), 0),
             min(price_to_base_fw_exch_rate_act),
             f_string_aggregate(price_to_base_fw_exch_rate),
             f_string_aggregate(contract_qp_fw_exch_rate),
             f_string_aggregate(contract_pp_fw_exch_rate),
             f_string_aggregate(accrual_to_base_fw_exch_rate),
             null,--f_string_aggregate(tc_to_base_fw_exch_rate),
             null,--f_string_aggregate(rc_to_base_fw_exch_rate),
             null --f_string_aggregate(pc_to_base_fw_exch_rate),
            
        from (select t.internal_grd_ref_no,
                     t.original_inv_qty,
                     sales_internal_gmr_ref_no,
                     case
                       when t.cost_type = 'Price' then
                        t.original_inv_qty * t.transformation_ratio
                       else
                        0
                     end as mc_stock_qty,
                     case
                       when t.cost_type = 'Price' then
                        t.cost_value * t.original_inv_qty *
                        t.transformation_ratio
                       else
                        0
                     end as total_mc_charges_trans, -- Take it in Transaction currency as we have to show this to the user
                    case
                       when t.cost_type = 'Price' then
                        t.transact_to_base_fw_exch_rate
                       else
                        null
                     end as price_to_base_fw_exch_rate_act,
                     case
                       when t.cost_type = 'Price' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as price_to_base_fw_exch_rate,
                      case
                       when t.cost_type = 'Location Premium' then
                        t.original_inv_qty * t.transformation_ratio
                       else
                        0
                     end as lp_stock_qty,
                     case
                       when t.cost_type = 'Location Premium' then
                        t.cost_value   * t.transformation_ratio * t.transact_to_base_fw_exch_rate * t.original_inv_qty * t.transaction_cur_factor
                       else
                        0
                     end as total_lp_charges_base,
                     case
                       when t.cost_type = 'Location Premium' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as contract_pp_fw_exch_rate,
                      case
                       when t.cost_type = 'Quality Premium' then
                        t.original_inv_qty * t.transformation_ratio
                       else
                        0
                     end as Qp_stock_qty,
                     case
                       when t.cost_type = 'Quality Premium' then
                        t.cost_value   * t.transformation_ratio * t.transact_to_base_fw_exch_rate * t.original_inv_qty * t.transaction_cur_factor
                       else
                        0
                     end as total_Qp_charges_base,
                     case
                       when t.cost_type = 'Quality Premium' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as contract_qp_fw_exch_rate,
                     case
                       when t.cost_type = 'Secondary Cost' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as accrual_to_base_fw_exch_rate
                from tinvs_temp_invm_cogs t
               where t.process_id = pc_process_id)
       group by internal_grd_ref_no,sales_internal_gmr_ref_no;
  commit;
  
  --- update price unit
  for cc_update in (select t.internal_grd_ref_no,
                           pum.product_price_unit_id price_unit_id,
                           pum.cur_id price_unit_cur_id,
                           cm.cur_code price_unit_cur_code,
                           pum.weight_unit_id price_unit_weight_unit_id,
                           qum.qty_unit price_unit_weight_unit,
                           1 weight
                      from tinvs_temp_invm_cogs     t,
                           v_ppu_pum                pum,
                           cm_currency_master       cm,
                           qum_quantity_unit_master qum
                     where t.process_id = pc_process_id
                       and t.cost_type = 'Price'
                       and t.transaction_price_unit_id = pum.price_unit_id
                       and t.product_id = pum.product_id
                       and pum.cur_id = cm.cur_id
                       and pum.weight_unit_id = qum.qty_unit_id)
  loop
    update invm_cogs invm
       set invm.price_unit_id             = cc_update.price_unit_id,
           invm.price_unit_cur_id         = cc_update.price_unit_cur_id,
           invm.price_unit_cur_code       = cc_update.price_unit_cur_code,
           invm.price_unit_weight_unit_id = cc_update.price_unit_weight_unit_id,
           invm.price_unit_weight_unit    = cc_update.price_unit_weight_unit,
           invm.price_unit_weight         = cc_update.weight
     where invm.process_id = pc_process_id
       and invm.internal_grd_ref_no = cc_update.internal_grd_ref_no;  
  end loop;  
  commit;
 --
 -- Update Average Secondary Cost 
 -- Here we need to take the average of cost Per Cost Componennt first and then aggregate it
 --
for cur_update in( 
 select internal_grd_ref_no,
       sum(avg_sc) avg_sc,
       sales_internal_gmr_ref_no
  from (select sum((t.cost_value * t.transformation_ratio *
                   t.transact_to_base_fw_exch_rate * t.original_inv_qty)) /
               sum(t.original_inv_qty * t.transformation_ratio) avg_sc,
               t.internal_cost_id,
               t.internal_grd_ref_no,
               t.sales_internal_gmr_ref_no
          from tinvs_temp_invm_cogs t
         where t.process_id = pc_process_id
           and t.cost_type = 'Secondary Cost'
          group by t.internal_cost_id,
                  t.internal_grd_ref_no,
                  t.sales_internal_gmr_ref_no)
 group by internal_grd_ref_no,sales_internal_gmr_ref_no) loop
Update invm_cogs t
set t.secondary_cost_per_unit =  cur_update.avg_sc
where t.process_id = pc_process_id
and t.internal_grd_ref_no = cur_update.internal_grd_ref_no
and t.sales_internal_gmr_ref_no = cur_update.sales_internal_gmr_ref_no;
end loop;
commit; 


    -- Insert Element Price/TC/RC Details
    insert into invme_cogs_element
      (process_id,
       internal_grd_ref_no,
       sales_internal_gmr_ref_no,
       element_id,
       mc_per_unit,
       mc_price_unit_id,
       tc_per_unit,
       tc_price_unit_id,
       rc_per_unit,
       rc_price_unit_id,
       payable_qty,
       payable_qty_unit_id)
      select pc_process_id,
             t.internal_grd_ref_no,
             t.sales_internal_gmr_ref_no,
             t.element_id,
             sum(t.mc_per_unit) mc_per_unit,
             max(t.mc_price_unit_id) mc_price_unit_id,
             sum(t.tc_per_unit) tc_per_unit,
             max(t.tc_price_unit_id) tc_price_unit_id,
             nvl(sum(t.rc_per_unit), 0) rc_per_unit,
             max(t.rc_price_unit_id) rc_price_unit_id,
             payable_qty,
             payable_qty_unit_id
        from (select t.internal_grd_ref_no,
                     ecs.element_id,
                     case
                       when t.cost_type = 'Price' then
                        ecs.cost_value
                       else
                        0
                     end mc_per_unit,
                     case
                       when t.cost_type = 'Price' then
                        ecs.rate_price_unit_id
                       else
                        null
                     end mc_price_unit_id,
                     case
                       when t.cost_type = 'Treatment Charges' then
                        ecs.cost_value
                       else
                        null
                     end tc_per_unit,
                     case
                       when t.cost_type = 'Treatment Charges' then
                        ecs.rate_price_unit_id
                       else
                        null
                     end tc_price_unit_id,
                     case
                       when t.cost_type = 'Refining Charges' then
                        ecs.cost_value
                       else
                        null
                     end rc_per_unit,
                     case
                       when t.cost_type = 'Refining Charges' then
                        ecs.rate_price_unit_id
                       else
                        null
                     end rc_price_unit_id,
                     t.sales_internal_gmr_ref_no,
                     ecs.payable_qty,
                     ecs.qty_unit_id payable_qty_unit_id
                from tinvs_temp_invm_cogs   t,
                     ecs_element_cost_store ecs,
                     cs_cost_store          cs
               where t.process_id = pc_process_id
                 and ecs.process_id = pc_process_id
                 and t.internal_cost_id = ecs.internal_cost_id
                 and t.cost_type <> 'Secondary Cost'
                 and ecs.internal_cost_id = cs.internal_cost_id
                 and cs.process_id = pc_process_id
                 and cs.cog_ref_no not in
                     (select cigc_in.cog_ref_no
                        from cigc_contract_item_gmr_cost cigc_in,
                             gmr_goods_movement_record   gmr
                       where cigc_in.internal_gmr_ref_no =
                             gmr.internal_gmr_ref_no
                         and cigc_in.process_id = pc_process_id
                         and gmr.process_id = pc_process_id
                         and gmr.is_deleted = 'N'
                         and cigc_in.is_deleted = 'N'
                         and gmr.contract_type = 'Sales')) t
       group by t.internal_grd_ref_no,
                t.sales_internal_gmr_ref_no,
                t.element_id,
                t.payable_qty,
                t.payable_qty_unit_id;
  
    update invme_cogs_element t
       set (t.mc_price_unit_name, t.mc_price_unit_cur_id, t.mc_price_unit_cur_code, t.mc_price_unit_weight_unit_id, t.mc_price_unit_weight_unit, t.mc_price_unit_weight) = (select ppu.price_unit_name,
                                                                                                                                                                                   cm.cur_id,
                                                                                                                                                                                   cm.cur_code,
                                                                                                                                                                                   qum.qty_unit_id,
                                                                                                                                                                                   qum.qty_unit,
                                                                                                                                                                                   ppu.weight
                                                                                                                                                                              from v_ppu_pum                ppu,
                                                                                                                                                                                   cm_currency_master       cm,
                                                                                                                                                                                   qum_quantity_unit_master qum
                                                                                                                                                                             where ppu.product_price_unit_id =
                                                                                                                                                                                   t.mc_price_unit_id
                                                                                                                                                                               and cm.cur_id =
                                                                                                                                                                                   ppu.cur_id
                                                                                                                                                                               and qum.qty_unit_id =
                                                                                                                                                                                   ppu.weight_unit_id);
  commit;                                                                                                                                                                                   
    update invme_cogs_element t
       set t.tc_price_unit_name = (select ppu.price_unit_name
                                     from v_ppu_pum ppu
                                    where ppu.product_price_unit_id =
                                          t.tc_price_unit_id);
   commit;                                          
  
    update invme_cogs_element t
       set t.rc_price_unit_name = (select ppu.price_unit_name
                                     from v_ppu_pum ppu
                                    where ppu.product_price_unit_id =
                                          t.rc_price_unit_id);
  commit;                                          
  
    for cur_price_ex_rate in (select t.mc_price_unit_cur_id,
                                     t.mc_price_unit_cur_code
                                from invme_cogs_element t
                               where t.process_id = pc_process_id
                                 and t.mc_price_unit_cur_id <>
                                     vc_base_cur_id)
    loop
      pkg_general.sp_bank_fx_rate(pc_corporate_id,
                                  pd_trade_date,
                                  pd_trade_date,
                                  cur_price_ex_rate.mc_price_unit_cur_id,
                                  vc_base_cur_id,
                                  30,
                                  'INVME_COG Element Price to Base',
                                  pc_process,
                                  vn_price_to_base_fw_exch_rate,
                                  vn_forward_points);
      if vn_price_to_base_fw_exch_rate <> 0 then
        update invme_cogs_element t
           set t.price_to_base_fw_exch_rate = '1 ' ||
                                              cur_price_ex_rate.mc_price_unit_cur_code || '=' ||
                                              vn_price_to_base_fw_exch_rate || ' ' ||
                                              vc_base_cur_code
         where t.process_id = pc_process_id
           and t.mc_price_unit_cur_id =
               cur_price_ex_rate.mc_price_unit_cur_id;
      
      end if;
    
    end loop;
    commit;
  exception
    when others then
      commit;
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure pkg_phy_physical_process sp_calc_invm_cogs',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           'Message:' ||
                                                           sqlerrm ||
                                                           dbms_utility.format_error_backtrace ||
                                                           'No ' ||
                                                           vc_error_msg,
                                                           '',
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
    
  end;

  procedure sp_calc_gmr_sec_cost(pc_corporate_id varchar2,
                                 pc_process_id   varchar2,
                                 pc_user_id      varchar2,
                                 pd_trade_date   date,
                                 pc_process      varchar2) is
    vobj_error_log                tableofpelerrorlog := tableofpelerrorlog();
    vn_eel_error_count            number := 1;
    vc_error_msg                  varchar2(5) := '0';
    vn_qty_conv_price_to_stock    number;
    vn_qty_conv_stock_to_base     number;
    vn_fw_exch_rate_trans_to_base number;
    vn_forward_points             number;
    vc_exch_rate_string           varchar2(25);
  begin
  
    insert into tgsc_temp_gmr_sec_cost
      (corporate_id,
       process_id,
       internal_cost_id,
       cost_type,
       internal_grd_ref_no,
       internal_gmr_ref_no,
       product_id,
       base_qty_unit_id,
       base_qty_unit,
       grd_current_qty,
       grd_qty_unit_id,
       cost_value,
       transformation_ratio,
       transaction_price_unit_id,
       transaction_cur_factor,
       transaction_amt_cur_id,
       transaction_amt_main_cur_id,
       base_cur_id,
       base_cur_code,
       base_price_unit_id,
       price_qty_unit_id,
       price_weight,
       price_to_stock_wt_conversion,
       stock_to_base_wt_conversion,
       transact_to_base_fw_exch_rate,
       base_price_unit_id_in_ppu,
       transact_amt_sign,
       payment_due_date,
       gmr_grd_qty)
    -- 
    -- Section 1
    -- Purchase GMR Shipped But Not TT Query Start
    --
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.stock_current_qty
        from grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = grd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Accrual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(grd.inventory_status, 'NA') = 'NA'
         and grd.tolling_stock_type = 'None Tolling'
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             1,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.stock_current_qty
        from grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = grd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Actual'
         and cs.cost_ref_no in
             (select distinct cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_ref_no = cs.cost_ref_no
                 and cs_in.cost_type = 'Actual'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.is_deleted = 'N'
                 and cs_in.process_id = pc_process_id)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_under_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(grd.inventory_status, 'NA') = 'NA'
         and grd.tolling_stock_type = 'None Tolling'
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.stock_current_qty
        from grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = grd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Direct Actual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_direct_actual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(grd.inventory_status, 'NA') = 'NA'
         and grd.tolling_stock_type = 'None Tolling'
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             grd.internal_grd_ref_no,
             grd.internal_gmr_ref_no,
             grd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             grd.current_qty,
             grd.qty_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.stock_current_qty
        from grd_goods_record_detail     grd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.product_id = pc_process_id
         and gmr.internal_gmr_ref_no = grd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = grd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Reversal'
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and grd.is_deleted = 'N'
         and grd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and grd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and grd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = grd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_over_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(grd.inventory_status, 'NA') = 'NA'
         and grd.tolling_stock_type = 'None Tolling'
      --
      -- Purchase GMR Shipped But Not TT Query End
      --
      -- Section 2
      -- Sales GMR Shipped But Not TT Starts Here
      --
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             gmr.qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Accrual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(dgrd.inventory_status, 'NA') in ('NA', 'None')
         and dgrd.tolling_stock_type = 'None Tolling'
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             gmr.qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             1,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Actual'
         and cs.cost_ref_no in
             (select distinct cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_ref_no = cs.cost_ref_no
                 and cs_in.cost_type = 'Actual'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.is_deleted = 'N'
                 and cs_in.process_id = pc_process_id)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_under_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(dgrd.inventory_status, 'NA') in ('NA', 'None')
         and dgrd.tolling_stock_type = 'None Tolling'
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             gmr.qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Direct Actual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_direct_actual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(dgrd.inventory_status, 'NA') in ('NA', 'None')
         and dgrd.tolling_stock_type = 'None Tolling'
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             gmr.qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             1,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             gmr.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.product_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Reversal'
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_over_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and nvl(dgrd.inventory_status, 'NA') in ('NA', 'None')
         and dgrd.tolling_stock_type = 'None Tolling'
      
      -- Sales GMR Shipped But Not TT Ends Here
      -- 
      -- Section 3
      -- Sales GMR Inventory Out Starts Here
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             gmr.qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             scmt.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             dgrd.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr,
             scm_stock_cost_mapping      scmt
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Accrual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and dgrd.inventory_status = 'Out'
         and scmt.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and scmt.cog_ref_no = cigc.cog_ref_no
         and scmt.is_deleted = 'N'
         and dgrd.tolling_stock_type = 'None Tolling'
         and scmt.internal_dgrd_ref_no = dgrd.internal_dgrd_ref_no
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             dgrd.current_qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             scmt.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             1,
             nvl(cs.est_payment_due_date, pd_trade_date),
             dgrd.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr,
             scm_stock_cost_mapping      scmt
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Actual'
         and cs.cost_ref_no in
             (select distinct cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_ref_no = cs.cost_ref_no
                 and cs_in.cost_type = 'Actual'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.is_deleted = 'N'
                 and cs_in.process_id = pc_process_id)
         and cs.is_deleted = 'N'
         and cpm.corporate_id = pc_corporate_id
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_under_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and dgrd.inventory_status = 'Out'
         and scmt.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and scmt.cog_ref_no = cigc.cog_ref_no
         and scmt.is_deleted = 'N'
         and dgrd.tolling_stock_type = 'None Tolling'
         and scmt.internal_dgrd_ref_no = dgrd.internal_dgrd_ref_no
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             dgrd.current_qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             scmt.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             dgrd.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr,
             scm_stock_cost_mapping      scmt
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Direct Actual'
         and cs.cost_ref_no not in
             (select cs_in.cost_ref_no
                from cs_cost_store cs_in
               where cs_in.cost_type = 'Actual'
                 and cs_in.is_deleted = 'N'
                 and cs_in.is_actual_posted_in_cog = 'Y'
                 and cs_in.process_id = pc_process_id)
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_direct_actual = 'Y'
         and cs.income_expense = 'Expense'
         and dgrd.inventory_status = 'Out'
         and scmt.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and scmt.cog_ref_no = cigc.cog_ref_no
         and scmt.is_deleted = 'N'
         and dgrd.tolling_stock_type = 'None Tolling'
         and scmt.internal_dgrd_ref_no = dgrd.internal_dgrd_ref_no
      union all
      select pc_corporate_id,
             pc_process_id,
             cs.internal_cost_id,
             'Secondary Cost' cost_type,
             dgrd.internal_dgrd_ref_no,
             dgrd.internal_gmr_ref_no,
             dgrd.product_id,
             pum_base.weight_unit_id,
             qum.qty_unit,
             dgrd.current_qty,
             dgrd.net_weight_unit_id,
             cs.cost_value,
             scmt.transformation_ratio,
             cs.transaction_price_unit_id,
             nvl(scd.factor, 1),
             cs.transaction_amt_cur_id,
             nvl(scd.cur_id, cs.transaction_amt_cur_id),
             akc.base_cur_id,
             cm.cur_code,
             pum_base.price_unit_id as base_price_unit_id,
             pum_trans.weight_unit_id as price_weight_unit_id,
             nvl(pum_trans.weight, 1),
             1,
             1,
             cs.fx_to_base,
             ppu.product_price_unit_id,
             cs.transact_amt_sign,
             nvl(cs.est_payment_due_date, pd_trade_date),
             dgrd.current_qty
        from dgrd_delivered_grd          dgrd,
             cigc_contract_item_gmr_cost cigc,
             cs_cost_store               cs,
             cpm_corporateproductmaster  cpm,
             scm_service_charge_master   scms,
             pdm_productmaster           pdm,
             ak_corporate                akc,
             pum_price_unit_master       pum_base,
             scd_sub_currency_detail     scd,
             pum_price_unit_master       pum_trans,
             v_ppu_pum                   ppu,
             qum_quantity_unit_master    qum,
             cm_currency_master          cm,
             gmr_goods_movement_record   gmr,
             scm_stock_cost_mapping      scmt
       where cigc.internal_gmr_ref_no = gmr.internal_gmr_ref_no
         and gmr.process_id = pc_process_id
         and gmr.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and cigc.cog_ref_no = cs.cog_ref_no
         and cpm.product_id = dgrd.product_id
         and cs.cost_component_id = scms.cost_id
         and scms.cost_type = 'SECONDARY_COST'
         and cs.cost_type = 'Reversal'
         and cpm.corporate_id = pc_corporate_id
         and cs.is_deleted = 'N'
         and cigc.is_deleted = 'N'
         and dgrd.status = 'Active'
         and dgrd.product_id = pdm.product_id
         and cpm.corporate_id = akc.corporate_id
         and pum_base.cur_id = akc.base_cur_id
         and pum_base.weight_unit_id = pdm.base_quantity_unit
         and pum_base.is_active = 'Y'
         and pum_base.is_deleted = 'N'
         and cs.transaction_amt_cur_id = scd.sub_cur_id(+)
         and dgrd.process_id = pc_process_id
         and cs.process_id = pc_process_id
         and cigc.process_id = pc_process_id
         and cs.transaction_price_unit_id = pum_trans.price_unit_id
         and pum_trans.is_active = 'Y'
         and pum_trans.is_deleted = 'N'
         and dgrd.current_qty <> 0
         and ppu.price_unit_id = pum_base.price_unit_id
         and ppu.product_id = dgrd.product_id
         and pum_base.weight_unit_id = qum.qty_unit_id
         and akc.base_cur_id = cm.cur_id
         and cs.reversal_type = 'CONTRACT'
         and cs.acc_original_accrual = 'Y'
         and cs.acc_over_accrual = 'Y'
         and cs.income_expense = 'Expense'
         and dgrd.inventory_status = 'Out'
         and scmt.internal_gmr_ref_no = dgrd.internal_gmr_ref_no
         and scmt.cog_ref_no = cigc.cog_ref_no
         and scmt.is_deleted = 'N'
         and dgrd.tolling_stock_type = 'None Tolling'
         and scmt.internal_dgrd_ref_no = dgrd.internal_dgrd_ref_no;
     commit;         
    -- Sales GMR Inventory Out Ends Here
    --
    -- Quantity Conversion from Price Weight Unit to Stock Weight Unit
    --         
    for cur_conv1 in (select t.product_id,
                             t.price_qty_unit_id,
                             t.grd_qty_unit_id
                        from tgsc_temp_gmr_sec_cost t
                       where t.process_id = pc_process_id
                         and t.price_qty_unit_id <> t.grd_qty_unit_id
                       group by t.price_qty_unit_id,
                                t.grd_qty_unit_id,
                                t.product_id)
    loop
      select pkg_general.f_get_converted_quantity(cur_conv1.product_id,
                                                  cur_conv1.price_qty_unit_id,
                                                  cur_conv1.grd_qty_unit_id,
                                                  1)
        into vn_qty_conv_price_to_stock
        from dual;
      update tgsc_temp_gmr_sec_cost t
         set t.price_to_stock_wt_conversion = vn_qty_conv_price_to_stock
       where t.price_qty_unit_id = cur_conv1.price_qty_unit_id
         and t.grd_qty_unit_id = cur_conv1.grd_qty_unit_id
         and t.product_id = cur_conv1.product_id
         and t.process_id = pc_process_id;
    end loop;
    commit;
    --
    -- Quantity Conversion from Stock Weight Unit to Product Base Unit
    --
    for cur_conv2 in (select t.product_id,
                             t.grd_qty_unit_id,
                             t.base_qty_unit_id
                        from tgsc_temp_gmr_sec_cost t
                       where t.grd_qty_unit_id <> t.base_qty_unit_id
                         and t.process_id = pc_process_id
                       group by t.product_id,
                                t.grd_qty_unit_id,
                                t.base_qty_unit_id)
    loop
      select pkg_general.f_get_converted_quantity(cur_conv2.product_id,
                                                  cur_conv2.grd_qty_unit_id,
                                                  cur_conv2.base_qty_unit_id,
                                                  1)
        into vn_qty_conv_stock_to_base
        from dual;
      update tgsc_temp_gmr_sec_cost t
         set t.price_to_stock_wt_conversion = vn_qty_conv_stock_to_base
       where t.base_qty_unit_id = cur_conv2.base_qty_unit_id
         and t.grd_qty_unit_id = cur_conv2.grd_qty_unit_id
         and t.product_id = cur_conv2.product_id
         and t.process_id = pc_process_id;
    end loop;
    commit;
    --
    -- Value in Transaction Currency
    --    
    update tgsc_temp_gmr_sec_cost t
       set t.value_in_transact_currency = t.cost_value *
                                          t.transaction_cur_factor *
                                          t.price_to_stock_wt_conversion *
                                          t.grd_current_qty *
                                          t.transformation_ratio /
                                          t.price_weight
     where t.process_id = pc_process_id;
     commit;
  
    --
    --update fx rate string 
    --
    for cur_exch_rate in (select t.transaction_amt_main_cur_id,
                                 t.base_cur_id,
                                 cm_base.cur_code base_cur_code,
                                 cm_trans.cur_code transaction_amt_main_cur_code,
                                 transact_to_base_fw_exch_rate
                            from tgsc_temp_gmr_sec_cost t,
                                 cm_currency_master     cm_trans,
                                 cm_currency_master     cm_base
                           where t.transaction_amt_main_cur_id <>
                                 t.base_cur_id
                             and t.process_id = pc_process_id
                             and t.transaction_amt_main_cur_id =
                                 cm_trans.cur_id
                             and t.base_cur_id = cm_base.cur_id
                           group by t.transaction_amt_main_cur_id,
                                    t.base_cur_id,
                                    cm_base.cur_code,
                                    cm_trans.cur_code,
                                    transact_to_base_fw_exch_rate)
    loop
    
      update tgsc_temp_gmr_sec_cost t
         set t.trans_to_base_fw_exch_rate    = '1 ' ||
                                               cur_exch_rate.transaction_amt_main_cur_code || '=' ||
                                               cur_exch_rate.transact_to_base_fw_exch_rate || ' ' ||
                                               cur_exch_rate.base_cur_code
       where t.process_id = pc_process_id
         and t.transaction_amt_main_cur_id =
             cur_exch_rate.transaction_amt_main_cur_id;
    
    end loop;
    commit;
  
    --
    -- Update Value in Base and Avg Cost in Base Price Unit
    --
  
    update tgsc_temp_gmr_sec_cost t
       set t.value_in_base_currency = t.value_in_transact_currency *
                                      t.transact_to_base_fw_exch_rate *
                                      t.transact_amt_sign,
           t.avg_cost               = (t.transact_amt_sign *
                                      t.value_in_transact_currency *
                                      t.transact_to_base_fw_exch_rate) /
                                      (t.stock_to_base_wt_conversion *
                                      t.grd_current_qty)
     where t.process_id = pc_process_id;
     commit;
    --
    -- All calculations done and ready with data into invm_cog
    --
    insert into gscs_gmr_sec_cost_summary
      (process_id, internal_gmr_ref_no, avg_cost_fw_rate, fw_rate_string)
      select pc_process_id,
             internal_gmr_ref_no,
             nvl(sum(total_secondary_cost), 0) / gmr_grd_qty,
             f_string_aggregate(accrual_to_base_fw_exch_rate)
      
        from (select t.internal_gmr_ref_no,
                     t.gmr_grd_qty,
                     case
                       when t.cost_type = 'Secondary Cost' then
                        t.avg_cost
                       else
                        0
                     end as secondary_cost_per_unit,
                     case
                       when t.cost_type = 'Secondary Cost' then
                        t.value_in_base_currency
                       else
                        0
                     end as total_secondary_cost,
                     case
                       when t.cost_type = 'Secondary Cost' then
                        t.trans_to_base_fw_exch_rate
                       else
                        null
                     end as accrual_to_base_fw_exch_rate
                from tgsc_temp_gmr_sec_cost t
               where t.process_id = pc_process_id) t
       group by internal_gmr_ref_no,gmr_grd_qty;
       commit;
  exception
    when others then
     commit;
      vobj_error_log.extend;
      vobj_error_log(vn_eel_error_count) := pelerrorlogobj(pc_corporate_id,
                                                           'procedure pkg_phy_physical_process sp_calc_gmr_sec_cost',
                                                           'M2M-013',
                                                           'Code:' ||
                                                           sqlcode ||
                                                           'Message:' ||
                                                           sqlerrm ||
                                                           dbms_utility.format_error_backtrace ||
                                                           'No ' ||
                                                           vc_error_msg,
                                                           '',
                                                           pc_process,
                                                           pc_user_id,
                                                           sysdate,
                                                           pd_trade_date);
      sp_insert_error_log(vobj_error_log);
    
  end;
end; 
/