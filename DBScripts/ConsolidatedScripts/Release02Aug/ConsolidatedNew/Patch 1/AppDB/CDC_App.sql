------------------------------------
------------CDC 1.4.1---------------
------------------------------------
set define off;
drop MATERIALIZED VIEW LOG ON  MNM_MONTH_NAME_MASTER;
CREATE MATERIALIZED VIEW LOG ON  MNM_MONTH_NAME_MASTER;
drop MATERIALIZED VIEW LOG ON  CPC_CORPORATE_PROFIT_CENTER;
CREATE MATERIALIZED VIEW LOG ON  CPC_CORPORATE_PROFIT_CENTER;
delete from RPC_RF_PARAMETER_CONFIG rpc where RPC.REPORT_ID = '54';
delete from RFC_REPORT_FILTER_CONFIG rfc where RFC.REPORT_ID = '54';
commit;
update REF_REPORTEXPORTFORMAT rrf
set RRF.REPORT_FILE_NAME = 'DailyDerivativeReport_Excel.rpt'
where RRF.REPORT_ID = '54';
commit;

SET DEFINE OFF;
declare
begin
 for cc in (select *
               from ak_corporate akc
              where akc.is_internal_corporate = 'N')
  loop
    dbms_output.put_line(cc.corporate_id);
Insert into RFC_REPORT_FILTER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, LABEL_COLUMN_NUMBER, LABEL_ROW_NUMBER, 
    LABEL, FIELD_ID, COLSPAN, IS_MANDATORY)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-541', 1, 1,     
    'Created Date', 'GFF021', 1, 'Y');
Insert into RFC_REPORT_FILTER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, LABEL_COLUMN_NUMBER, LABEL_ROW_NUMBER, 
    LABEL, FIELD_ID, COLSPAN, IS_MANDATORY)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 1, 2, 
    'Profit Center', 'GFF1011', 1, 'N');
Insert into RFC_REPORT_FILTER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, LABEL_COLUMN_NUMBER, LABEL_ROW_NUMBER, 
    LABEL, FIELD_ID, COLSPAN, IS_MANDATORY)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-543', 1, 3, 
    'Exchange ', 'GFF1011', 1, 'N');
Insert into RFC_REPORT_FILTER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, LABEL_COLUMN_NUMBER, LABEL_ROW_NUMBER, 
    LABEL, FIELD_ID, COLSPAN, IS_MANDATORY)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-545', 1, 4, 
    'Strategy', 'GFF1011', 1, 'N');
Insert into RFC_REPORT_FILTER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, LABEL_COLUMN_NUMBER, LABEL_ROW_NUMBER, 
    LABEL, FIELD_ID, COLSPAN, IS_MANDATORY)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-546', 1, 5, 
    'Trade Type', 'GFF1011', 1, 'N');
Insert into RFC_REPORT_FILTER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, LABEL_COLUMN_NUMBER, LABEL_ROW_NUMBER, 
    LABEL, FIELD_ID, COLSPAN, IS_MANDATORY)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-547', 1, 6, 
    'Purpose', 'GFF1011', 1, 'N');
Insert into RFC_REPORT_FILTER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, LABEL_COLUMN_NUMBER, LABEL_ROW_NUMBER, 
    LABEL, FIELD_ID, COLSPAN, IS_MANDATORY)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-548', 1, 7, 
    'Nominee', 'GFF1011', 1, 'N');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-541', 'RFP0104', 'SYSTEM');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-541', 'RFP0026', 'AsOfDate');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 'RFP1045', 'reportProfitcenterList');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 'RFP1046', 'Book');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 'RFP1047', 'No');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 'RFP1048', 'Filter');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 'RFP1049', 'reportForm');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 'RFP1050', '1');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-542', 'RFP1051', 'multiple');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-543', 'RFP1045', 'exchangelist');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-543', 'RFP1046', 'Exchange');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-543', 'RFP1047', 'No');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-543', 'RFP1048', 'Filter');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-543', 'RFP1049', 'reportForm');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-543', 'RFP1050', '1');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-545', 'RFP1045', 'strategyDefinition');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-545', 'RFP1046', 'Strategy');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-545', 'RFP1047', 'No');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-545', 'RFP1048', 'Filter');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-545', 'RFP1049', 'reportForm');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-545', 'RFP1050', '1');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-546', 'RFP1045', 'tradeTypeByMasterContract');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-546', 'RFP1046', 'TradeType');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-546', 'RFP1047', 'No');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-546', 'RFP1048', 'Filter');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-546', 'RFP1049', 'reportForm');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-546', 'RFP1050', '1');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-547', 'RFP1045', 'setupDerivativeTradePurpose');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-547', 'RFP1046', 'Purpose');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-547', 'RFP1047', 'No');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-547', 'RFP1048', 'Filter');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-547', 'RFP1049', 'reportForm');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-547', 'RFP1050', '1');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-548', 'RFP1045', 'corporatebusinesspartner');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-548', 'RFP1046', 'Nominee');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-548', 'RFP1047', 'No');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-548', 'RFP1048', 'Filter');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-548', 'RFP1049', 'reportForm');
Insert into RPC_RF_PARAMETER_CONFIG
   (CORPORATE_ID, REPORT_ID, LABEL_ID, PARAMETER_ID, REPORT_PARAMETER_NAME)
 Values
   (cc.corporate_id, '54', 'RFC-CDC-548', 'RFP1050', '1');
COMMIT;
 end loop;
commit;
end;

CREATE OR REPLACE VIEW V_DAT_DERIVATIVE_AGG_TRADE
AS 
SELECT dat.aggregate_trade_id, dat.aggregate_trade_ref_no,
          dat.leg_1_int_der_ref_no, dat.leg_1_trade_type,
          dat.leg_2_int_der_ref_no, dat.leg_2_trade_type,
          DECODE (dt1.status, 'Settled', 'Closed out', dt1.status) status,
          pkg_general.f_get_corporate_user_name (dt1.created_by) created_by,
          TO_CHAR (dt1.created_date, 'DD-Mon-YYYY') created_date
     FROM dat_derivative_aggregate_trade dat,
          dt_derivative_trade dt1,
          dt_derivative_trade dt2,
          drm_derivative_master drm,
          dim_der_instrument_master dim,
          pm_period_master pm,
          dtm_deal_type_master dtm
    WHERE dat.leg_1_int_der_ref_no = dt1.internal_derivative_ref_no
      AND dat.leg_2_int_der_ref_no = dt2.internal_derivative_ref_no
      AND dt1.is_internal_trade = 'Y'
      AND dt2.is_internal_trade = 'Y'
      AND dt1.status <> 'Delete'
      AND dt2.status <> 'Delete'
      AND dt1.dr_id = drm.dr_id
      AND drm.instrument_id = dim.instrument_id
      AND drm.period_type_id = pm.period_type_id
      AND dtm.deal_type_id = dt1.deal_type_id;
/
/* Formatted on 2012/04/27 14:25 (Formatter Plus v4.8.8) */
declare
begin
  for temp in (select ct.internal_treasury_ref_no,
                      crtd.amount,
                      crtd.cur_id
                 from ct_currency_trade      ct,
                      crtd_cur_trade_details crtd
                where ct.internal_treasury_ref_no =
                      crtd.internal_treasury_ref_no
                  and crtd.leg_no = '1'
                  and crtd.is_base = 'Y'
                  and nvl(ct.outstanding_amount, 0) = 0)
  loop
    update ct_currency_trade ct1
       set ct1.outstanding_amount             = temp.amount,
           ct1.outstanding_amount_currency_id = temp.cur_id
     where ct1.internal_treasury_ref_no = temp.internal_treasury_ref_no;
  end loop;
end;
/
commit;


/* Formatted on 2012/04/27 14:25 (Formatter Plus v4.8.8) */
declare
begin
  for temp in (
SELECT ctul.internal_treasury_ref_no, crtd.amount, crtd.cur_id
  FROM crtd_cur_trade_details crtd, ctul_currency_trade_ul ctul
 WHERE ctul.internal_treasury_ref_no = crtd.internal_treasury_ref_no
   AND crtd.leg_no = '1'
   AND crtd.is_base = 'Y'
   AND NVL (ctul.outstanding_amount, 0) = 0)
  loop
    update CTUL_CURRENCY_TRADE_UL ctul1
       set ctul1.outstanding_amount             = temp.amount,
           ctul1.outstanding_amount_currency_id = temp.cur_id
     where ctul1.internal_treasury_ref_no = temp.internal_treasury_ref_no;
  end loop;
end;
/
commit;

DROP SNAPSHOT LOG ON  BRKMD_BROKER_MARGIN_DETAIL;
DROP SNAPSHOT LOG ON  BRKMM_BROKER_MARGIN_MASTER;
CREATE MATERIALIZED VIEW LOG ON  BRKMD_BROKER_MARGIN_DETAIL;
CREATE MATERIALIZED VIEW LOG ON  BRKMM_BROKER_MARGIN_MASTER;
UPDATE amc_app_menu_configuration amc
   SET amc.LINK_CALLED = '/cdc/getListingPage.action?gridId=LIST_SETTLEMENT_CLOSEOUT'
 WHERE amc.menu_id = 'CDC-D7'
 /


 Insert into GM_GRID_MASTER
   (GRID_ID, GRID_NAME, DEFAULT_COLUMN_MODEL_STATE, TAB_ID, URL, 
    DEFAULT_RECORD_MODEL_STATE, OTHER_URL, SCREEN_SPECIFIC_JSP, SCREEN_SPECIFIC_JS)
 Values
   ('LIST_SETTLEMENT_CLOSEOUT', 'List of settlement Closeout', '[{header: "Profit Center", width: 100, sortable: true,  dataIndex: ''profitcenter''},
{header: "Exchange Instrument", width: 100, sortable: true,  dataIndex: ''exchangeInst''},
{header: "Strike Price", width: 100, sortable: true,  dataIndex: ''''strikePrice''''},
{header: "Delivery Period", width: 100, sortable: true,  dataIndex: ''delPeriod''},
{header: "Clearer", width: 100, sortable: true,  dataIndex: ''clearer''},
{header: "Clearer Account", width: 100, sortable: true,  dataIndex: ''clearerAcc''},
{header: "Commision Type", width: 100, sortable: true,  dataIndex: ''commisionType''},
{header: "Buy Lots", width: 100, sortable: true,  dataIndex: ''buyLots''},
{header: "Sell Lots", width: 100, sortable: true,  dataIndex: ''sellLots''},
{header: "Available Lots", width: 100, sortable: true,  dataIndex: ''availLots''}', NULL, NULL, 
    NULL, NULL, 'settlements/ListOfSettlementCloseOut.jsp', '/private/js/settlements/ListOfSettlementCloseOut.js')

/
 
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('LIST_SETTLEMENT_CLOSEOUT-1', 'LIST_SETTLEMENT_CLOSEOUT', 'Operations', 1, 1, 
    NULL, 'function(){}', NULL, NULL, NULL)
/

Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   (' LIST_SETTLEMENT_CLOSEOUT-2', 'LIST_SETTLEMENT_CLOSEOUT', 'Manual', 2, 2, 
    NULL, 'function(){viewManual();}', NULL, 'LIST_SETTLEMENT_CLOSEOUT-1', NULL)
/

Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   (' LIST_SETTLEMENT_CLOSEOUT-3', 'LIST_SETTLEMENT_CLOSEOUT', 'LIFO', 3, 2, 
    NULL, 'function(){viewLIFO();}', NULL, 'LIST_SETTLEMENT_CLOSEOUT-1', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   (' LIST_SETTLEMENT_CLOSEOUT-4', 'LIST_SETTLEMENT_CLOSEOUT', 'FIFO', 4, 2, 
    NULL, 'function(){viewFIFO();}', NULL, 'LIST_SETTLEMENT_CLOSEOUT-1', NULL)
/

drop materialized view MV_FACT_BROKER_MARGIN_UTIL;
drop table MV_FACT_BROKER_MARGIN_UTIL;
create materialized view MV_FACT_BROKER_MARGIN_UTIL
refresh force on demand
as
select tdc.process_id,
       tdc.trade_date eod_date,
       tdc.corporate_id,
       bmu.corporate_name,
       bmu.broker_profile_id,
       bmu.broker_name,
       bmu.instrument_id,
       bmu.instrument_name,
       bmu.exchange_id,
       bmu.exchange_name,
       bmu.margin_cur_id,
       bmu.margin_cur_code,
       bmu.initial_margin_limit,
       bmu.current_credit_limit,
       bmu.variation_margin_limit,
       bmu.maintenance_margin,
       bmu.margin_calculation_method,
       bmu.base_cur_id,
       bmu.base_cur_code,
       bmu.fx_rate_margin_cur_to_base_cur,
       bmu.initial_margin_limit_in_base,
       bmu.current_credit_limit_in_base,
       variation_margin_limit_in_base,
       bmu.maintenance_margin_in_base,
       bmu.no_of_lots,
       bmu.net_no_of_lots,
       bmu.gross_no_of_lots,
       bmu.initial_margin_rate_cur_id,
       bmu.initial_margin_rate_cur_code,
       bmu.initial_margin_rate,
       bmu.initial_margin_requirement,
       bmu.fx_rate_imr_cur_to_base_cur,
       bmu.initial_margin_req_in_base,
       bmu.under_over_utilized_im,
       bmu.under_over_utilized_im_flag,
       bmu.trade_value_in_base,
       bmu.market_value_in_base,
       bmu.open_no_of_lots,
       bmu.lot_size,
       bmu.lot_size_unit,
       bmu.variation_margin_requirement,
       bmu.under_over_utilized_vm,
       bmu.under_over_utilized_vm_flag
  from bmu_broker_margin_utilization@eka_eoddb bmu,
       tdc_trade_date_closure@eka_eoddb        tdc
 where bmu.corporate_id = tdc.corporate_id
   and bmu.process_id = tdc.process_id;
/

commit;
set define off;
ALTER TABLE CT_CURRENCY_TRADE
 ADD (SPOT_RATE  NUMBER(20,10))
/

ALTER TABLE CT_CURRENCY_TRADE
 ADD (MARGIN_RATE  NUMBER(20,10))
/

ALTER TABLE CT_CURRENCY_TRADE
 ADD (OTHER_CHARGES  NUMBER(20,10))
/

ALTER TABLE CT_CURRENCY_TRADE
 ADD (SLIPPAGE_RATE  NUMBER(20,10))
/

ALTER TABLE CT_CURRENCY_TRADE
 ADD (IS_EXCHANGE_COMP  CHAR(1)                DEFAULT 'N')
/
 
ALTER TABLE CTUL_CURRENCY_TRADE_UL
 ADD (SPOT_RATE  VARCHAR2(20 CHAR))
/

ALTER TABLE CTUL_CURRENCY_TRADE_UL
 ADD (MARGIN_RATE  VARCHAR2(20 CHAR))
/

ALTER TABLE CTUL_CURRENCY_TRADE_UL
 ADD (OTHER_CHARGES  VARCHAR2(20 CHAR))
/

ALTER TABLE CTUL_CURRENCY_TRADE_UL
 ADD (SLIPPAGE_RATE  VARCHAR2(20 CHAR))
/

ALTER TABLE CTUL_CURRENCY_TRADE_UL
 ADD (IS_EXCHANGE_COMP  VARCHAR2(1 CHAR))
/
update CTUL_CURRENCY_TRADE_UL ctul
set CTUL.IS_EXCHANGE_COMP = 'N'
where CTUL.ENTRY_TYPE = 'Insert'
/

/* Formatted on 2012/05/09 17:11 (Formatter Plus v4.8.8) */
DECLARE
BEGIN
   FOR temp IN
      (SELECT dt.internal_derivative_ref_no, dt.strategy_id,
              dt.total_quantity, dt.quantity_unit_id, dt.profit_center_id,
              dt.trade_type
         FROM dt_derivative_trade dt
        WHERE dt.internal_derivative_ref_no NOT IN (
                                        SELECT dsa.internal_derivative_ref_no
                                          FROM dsa_der_strategy_account dsa))
   LOOP
      INSERT INTO dsa_der_strategy_account
                  (internal_der_strategy_acc_id, internal_derivative_ref_no,
                   acc_id, acc_qty,
                   acc_qty_unit_id, profit_center_id,
                   buy_sell, is_active, allocated_qty
                  )
           VALUES (seq_cdc_dsa.NEXTVAL, temp.internal_derivative_ref_no,
                   temp.strategy_id, temp.total_quantity,
                   temp.quantity_unit_id, temp.profit_center_id,
                   temp.trade_type, 'Y', temp.total_quantity
                  );
   END LOOP;
END;
/
/* Formatted on 2012/05/10 15:02 (Formatter Plus v4.8.8) */
ALTER TABLE dt_derivative_trade
MODIFY(total_lots NUMBER(6))
/

ALTER TABLE dt_derivative_trade
MODIFY(open_lots NUMBER(6))
/

ALTER TABLE dt_derivative_trade
MODIFY(exercised_lots NUMBER(6))
/

ALTER TABLE dt_derivative_trade
MODIFY(expired_lots NUMBER(6))
/
ALTER TABLE dt_derivative_trade
MODIFY(closed_lots NUMBER(6))
/

ALTER TABLE dcoh_der_closeout_header
MODIFY(tot_lots_closed NUMBER(7))
/
ALTER TABLE  cfqd_currency_fwd_quote_detail
ADD (is_imported CHAR(1) DEFAULT 'N'  )
/

ALTER TABLE  cfq_currency_forward_quotes
ADD ( is_imported CHAR(1) DEFAULT 'N'  )
/
--$$$$$$import fx forward start$$$$$$--
--ifm
Insert into IFM_IMPORT_FILE_MASTER
   (FILE_TYPE_ID, FILE_TYPE_NAME, TABLE_NAME, PROC_NAME, IS_ACTIVE, 
    SAMPLE_FILE_NAME, REMARKS, COLUMN_MODEL, RECORD_MODEL, FUNCTION_NAME, 
    FILE_MAPPING_TABLE_NAME, INSERT_QUERY, SELECT_QUERY, IS_ASYNCHRONOUS, IMPORT_LIMIT, 
    CONTEXT_PATH)
 Values
   ('IMPORT_FX_TRADES', 'Import Fx Trade', 'IFT_IMPORT_Fx_TRADES', NULL, 'Y', 
    'ImportFxOptionTrades.xls', NULL, '[{header:"Line No", width: 100, sortable: false,  dataIndex: "lineNo"},
      {header:"Bad Record", width: 100, sortable: true,renderer:processBadRecord,  dataIndex: "isBadRecord"},
      {header:"Trade Date", width: 100, sortable: false,  dataIndex:"tradeDate"},    
      {header:"External Trade Ref.No", width: 100, sortable: false,  dataIndex:"externalTradeRefNo"},  
      {header:"Deal Type", width: 100, sortable: false,  dataIndex:"dealTypeLongName"},  
      {header:"Trader", width: 100, sortable: false,  dataIndex:"trader"},
      {header:"Value Date", width: 100, sortable: false,  dataIndex:"valueDate"},
      {header:"Counter Party", width: 100, sortable: false,  dataIndex:"counterParty"},
      {header:"Trade Type", width: 100, sortable: false,  dataIndex:"tradeType"},
      {header:"Exchange Instrument", width: 100, sortable: false,  dataIndex:"exchangeInstrument"},
      {header:"Is Exchange Rate Component?", width: 100, sortable: false,  dataIndex:"isExchangeRateComponent"},
      {header:"Spot", width: 100, sortable: false,  dataIndex:"spot"},
      {header:"Premium", width: 100, sortable: false,  dataIndex:"premiumRate"},
      {header:"Slippage", width: 100, sortable: false,  dataIndex:"slippage"},
      {header:"Margin", width: 100, sortable: false,  dataIndex:"margin"},
      {header:"Other Charges", width: 100, sortable: false,  dataIndex:"otherCharges"},
      {header:"Exchange/Net Rate", width: 100, sortable: false,  dataIndex:"exchangeNetRate"},           
      {header:"Amount", width: 100, sortable: false,  dataIndex:"amount"},
      {header:"Payment Terms", width: 100, sortable: false,  dataIndex:"paymentTerms"},
      {header:"Payment Due Date", width: 100, sortable: false,  dataIndex:"paymentDueDate"},
      {header:"Bank Name", width: 100, sortable: false,  dataIndex:"bankName"},
      {header:"Bank Account", width: 100, sortable: false,  dataIndex:"bankAccount"}, 
      {header:"Bank Charges", width: 100, sortable: false,  dataIndex:"bankCharges"},
      {header:"Bank Charges Unit/%", width: 100, sortable: false,  dataIndex:"bankChargesUnitOrPercentage"},
      {header:"Profit Center", width: 100, sortable: false,  dataIndex:"profitCenter"}, 
      {header:"Strategy", width: 100, sortable: false,  dataIndex:"strategy"}, 
      {header:"Purpose", width: 100, sortable: false,  dataIndex:"purpose"},
      {header:"Nominee", width: 100, sortable: false,  dataIndex:"nominee"}, 
      {header:"Remarks", width: 100, sortable: false,  dataIndex:"remarks"}]', '[{name: "lineNo", mapping: "lineNo"},
      {name: "isBadRecord", mapping: "isBadRecord"},
      {name: "tradeDate", mapping: "property1"},
      {name: "externalTradeRefNo", mapping: "property2"},
      {name: "dealTypeLongName", mapping: "property3"},
      {name: "trader", mapping: "property4"},
      {name: "valueDate", mapping: "property5"},
      {name: "counterParty", mapping: "property6"},
      {name: "tradeType", mapping: "property7"},
      {name: "exchangeInstrument", mapping: "property8"},
      {name: "isExchangeRateComponent", mapping: "property9"},
      {name: "spot", mapping: "property10"},
      {name: "premiumRate", mapping: "property11"},
      {name: "slippage", mapping: "property12"},
      {name: "margin", mapping: "property13"},
      {name: "otherCharges", mapping: "property14"},
      {name: "exchangeNetRate", mapping: "property15"},              
      {name: "amount", mapping: "property16"},
      {name: "paymentTerms", mapping: "property17"},
      {name: "paymentDueDate", mapping: "property18"},
      {name: "bankName", mapping: "property19"},
      {name: "bankAccount", mapping: "property20"},
      {name: "bankCharges", mapping: "property21"},
      {name: "bankChargesUnitOrPercentage", mapping: "property22"},
      {name: "profitCenter", mapping: "property23"},
      {name: "strategy", mapping: "property24"},
      {name: "purpose", mapping: "property25"},
      {name: "nominee", mapping: "property26"},
      {name: "remarks", mapping: "property27"}]', 'window.opener.saveFxTradeImport', 
    'FMIIR_FILE_MAPPING_IIR', 'insert into IVR_IMPORT_VALID_RECORD(TRANSACTION_ID,LINE_NO,IS_BAD_RECORD,property1,property2,property3,property4,property5,property6,property7,property8,property9,property10,property11,property12,property13,property14,property15,property16,property17,property18,property19,property20,property21,property22,property23,property24,property25,property26,property27) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)', 'rn,count(*) over() TOTAL_NO_OF_RECORDS,TRANSACTION_ID,LINE_NO,IS_BAD_RECORD,property1,property2,property3,property4,property5,property6,property7,property8,property9,property10,property11,property12,property13,property14,property15,property16,property17,property18,property19,property20,property21,property22,property23,property24,property25,property26,property27 from IVR_IMPORT_VALID_RECORD', 'Y', 100, 
    'CDC');

--itcm
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Trader', 'TRADER', 'Trader detail', 0, 
    'TRADER_ID', 4, 'trader');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Deal Type', 'DEAL_TYPE_LONG_NAME', 'String containing the deal type.eg,Exchange Calendar Spread Future,Exchange Product Spread Future etc...', 0, 
    'DEAL_TYPE_ID', 3, 'dealTypeLongName');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Counter Party', 'COUNTER_PARTY', 'String containing the CP name', 0, 
    'COUNTER_PARTY_ID', 6, 'counterParty');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Payment Terms', 'PAYMENT_TERMS', 'String containing the payterms name', 0, 
    'PAYMENT_TERMS_ID', 17, 'paymentTerms');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Payment Due Date', 'PAYMENT_DUE_DATE', 'String containing the paymaent dua date', 0, 
    NULL, 18, 'paymentDueDate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Trade Type', 'TRADE_TYPE', 'String containing the tarde type buy sell', 0, 
    NULL, 7, 'tradeType');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Amount', 'AMOUNT', 'String containing the amount of the fx trade', 0, 
    NULL, 16, 'amount');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Exchange/Net Rate', 'EXCHANGE_NET_RATE', 'String containing the exchange rate of the fx trade currency instrument', 0, 
    NULL, 15, 'exchangeNetRate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Bank Name', 'BANK_NAME', 'String containing the bank name', 0, 
    'BANK_NAME_ID', 19, 'bankName');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Bank Account', 'BANK_ACCOUNT', 'String containing the bank account name', 0, 
    'BANK_ACCOUNT_ID', 20, 'bankAccount');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Bank Charges', 'BANK_CHARGES', 'String containing the bank Bank Charges', 0, 
    NULL, 21, 'bankCharges');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Bank Charges Unit/%', 'BANK_CHARGES_UNIT_OR_PERCENTAGE', 'String containing the bank Bank Charges unit or percentage', 0, 
    'BANK_CHARGES_UNIT_ID', 22, 'bankChargesUnitOrPercentage');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Profit Center', 'PROFIT_CENTER', 'String containing the profit center details', 0, 
    'PROFIT_CENTER_ID', 23, 'profitCenter');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Strategy', 'STRATEGY', 'String containing the Strategy details', 0, 
    'STRATEGY_ID', 24, 'strategy');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Purpose', 'PURPOSE', 'String containing the Purpose details', 0, 
    'PURPOSE_ID', 25, 'purpose');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Nominee', 'NOMINEE', 'String containing the Nominee details', 0, 
    'NOMINEE_ID', 26, 'nominee');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Remarks', 'REMARKS', 'String containing the Remarks details', 0, 
    NULL, 27, 'remarks');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Trade Date', 'TRADE_DATE', 'Trade date for which the trade is created', 0, 
    NULL, 1, 'tradeDate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'External Trade Ref.No', 'EXTERNAL_TRADE_REF_NO', 'User input ext ref num', 0, 
    NULL, 2, 'externalTradeRefNo');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Exchange Instrument', 'EXCHANGE_INSTRUMENT', 'currency Instrument used for the trade.', 0, 
    'EXCHANGE_INSTRUMENT_ID', 8, 'exchangeInstrument');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Is Exchange Rate Component?', 'IS_EXCHANGE_RATE_COMPONENT', 'Y indicates component rates,N indicates single rate.', 0, 
    NULL, 9, 'isExchangeRateComponent');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Spot', 'SPOT', 'holds the spot rate.', 0, 
    NULL, 10, 'spot');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Premium', 'PREMIUM_RATE', 'holds the Premium rate.', 0, 
    NULL, 11, 'premiumRate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Slippage', 'SLIPPAGE', 'holds the Slippage rate.', 0, 
    NULL, 12, 'slippage');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Margin', 'MARGIN', 'holds the Margin rate.', 0, 
    NULL, 13, 'margin');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Other Charges', 'OTHER_CHARGES', 'holds the Other Charges rate.', 0, 
    NULL, 14, 'otherCharges');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_TRADES', 'Value Date', 'VALUE_DATE', 'holds the value date for the currecny trade.', 0, 
    NULL, 5, 'valueDate');
--$$$$$$import fx forward end$$$$$$--

--$$$$$$import fx Option start$$$$$$--
--ifm
Insert into IFM_IMPORT_FILE_MASTER
   (FILE_TYPE_ID, FILE_TYPE_NAME, TABLE_NAME, PROC_NAME, IS_ACTIVE, 
    SAMPLE_FILE_NAME, REMARKS, COLUMN_MODEL, RECORD_MODEL, FUNCTION_NAME, 
    FILE_MAPPING_TABLE_NAME, INSERT_QUERY, SELECT_QUERY, IS_ASYNCHRONOUS, IMPORT_LIMIT, 
    CONTEXT_PATH)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Import Fx Option Trade', 'IFT_IMPORT_Fx_OPTION_TRADES', NULL, 'Y', 
    'ImportFxTrades.xls', NULL, '[{header:"Line No", width: 100, sortable: false,  dataIndex: "lineNo"},
      {header:"Bad Record", width: 100, sortable: true,renderer:processBadRecord,  dataIndex: "isBadRecord"},
      {header:"Trade Date", width: 100, sortable: false,  dataIndex:"tradeDate"},    
      {header:"External Trade Ref.No", width: 100, sortable: false,  dataIndex:"externalTradeRefNo"},  
      {header:"Deal Type", width: 100, sortable: false,  dataIndex:"dealTypeLongName"},  
      {header:"Trader", width: 100, sortable: false,  dataIndex:"trader"},
      {header:"Value Date", width: 100, sortable: false,  dataIndex:"valueDate"},
      {header:"Counter Party", width: 100, sortable: false,  dataIndex:"counterParty"},
      {header:"Trade Type", width: 100, sortable: false,  dataIndex:"tradeType"},
      {header:"Exchange Instrument", width: 100, sortable: false,  dataIndex:"exchangeInstrument"},
      {header:"Is Exchange Rate Component?", width: 100, sortable: false,  dataIndex:"isExchangeRateComponent"},
      {header:"Spot", width: 100, sortable: false,  dataIndex:"spot"},
      {header:"Premium", width: 100, sortable: false,  dataIndex:"premiumRate"},
      {header:"Slippage", width: 100, sortable: false,  dataIndex:"slippage"},
      {header:"Margin", width: 100, sortable: false,  dataIndex:"margin"},
      {header:"Other Charges", width: 100, sortable: false,  dataIndex:"otherCharges"},
      {header:"Exchange/Net Rate", width: 100, sortable: false,  dataIndex:"exchangeNetRate"},      
      {header:"Option Premium", width: 100, sortable: false,  dataIndex:"optionPremium"},
      {header:"Option Premium Unit", width: 100, sortable: false,  dataIndex:"optionPremiumCurUnit"},  
      {header:"Expiry Date", width: 100, sortable: false,  dataIndex:"expiryDate"},      
      {header:"Amount", width: 100, sortable: false,  dataIndex:"amount"},
      {header:"Payment Terms", width: 100, sortable: false,  dataIndex:"paymentTerms"},
      {header:"Payment Due Date", width: 100, sortable: false,  dataIndex:"paymentDueDate"},
      {header:"Bank Name", width: 100, sortable: false,  dataIndex:"bankName"},
      {header:"Bank Account", width: 100, sortable: false,  dataIndex:"bankAccount"}, 
      {header:"Bank Charges", width: 100, sortable: false,  dataIndex:"bankCharges"},
      {header:"Bank Charges Unit/%", width: 100, sortable: false,  dataIndex:"bankChargesUnitOrPercentage"},
      {header:"Profit Center", width: 100, sortable: false,  dataIndex:"profitCenter"}, 
      {header:"Strategy", width: 100, sortable: false,  dataIndex:"strategy"}, 
      {header:"Purpose", width: 100, sortable: false,  dataIndex:"purpose"},
      {header:"Nominee", width: 100, sortable: false,  dataIndex:"nominee"}, 
      {header:"Remarks", width: 100, sortable: false,  dataIndex:"remarks"}]', '[{name: "lineNo", mapping: "lineNo"},
      {name: "isBadRecord", mapping: "isBadRecord"},
      {name: "tradeDate", mapping: "property1"},
      {name: "externalTradeRefNo", mapping: "property2"},
      {name: "dealTypeLongName", mapping: "property3"},
      {name: "trader", mapping: "property4"},
      {name: "valueDate", mapping: "property5"},
      {name: "counterParty", mapping: "property6"},
      {name: "tradeType", mapping: "property7"},
      {name: "exchangeInstrument", mapping: "property8"},
      {name: "isExchangeRateComponent", mapping: "property9"},
      {name: "spot", mapping: "property10"},
      {name: "premiumRate", mapping: "property11"},
      {name: "slippage", mapping: "property12"},
      {name: "margin", mapping: "property13"},
      {name: "otherCharges", mapping: "property14"},
      {name: "exchangeNetRate", mapping: "property15"},    
      {name: "optionPremium", mapping: "property16"},
      {name: "optionPremiumCurUnit", mapping: "property17"},
      {name: "expiryDate", mapping: "property18"},           
      {name: "amount", mapping: "property19"},
      {name: "paymentTerms", mapping: "property20"},
      {name: "paymentDueDate", mapping: "property21"},
      {name: "bankName", mapping: "property22"},
      {name: "bankAccount", mapping: "property23"},
      {name: "bankCharges", mapping: "property24"},
      {name: "bankChargesUnitOrPercentage", mapping: "property25"},
      {name: "profitCenter", mapping: "property26"},
      {name: "strategy", mapping: "property27"},
      {name: "purpose", mapping: "property28"},
      {name: "nominee", mapping: "property29"},
      {name: "remarks", mapping: "property30"}]', 'window.opener.saveFxTradeImport', 
    'FMIIR_FILE_MAPPING_IIR', 'insert into IVR_IMPORT_VALID_RECORD(TRANSACTION_ID,LINE_NO,IS_BAD_RECORD,property1,property2,property3,property4,property5,property6,property7,property8,property9,property10,property11,property12,property13,property14,property15,property16,property17,property18,property19,property20,property21,property22,property23,property24,property25,property26,property27,property28,property29,property30) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)', 'rn,count(*) over() TOTAL_NO_OF_RECORDS,TRANSACTION_ID,LINE_NO,IS_BAD_RECORD,property1,property2,property3,property4,property5,property6,property7,property8,property9,property10,property11,property12,property13,property14,property15,property16,property17,property18,property19,property20,property21,property22,property23,property24,property25,property26,property27,property28,property29,property30 from IVR_IMPORT_VALID_RECORD', 'Y', 100, 
    'CDC');
--itcm
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Trader', 'TRADER', 'Trader detail', 0, 
    'TRADER_ID', 4, 'trader');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Deal Type', 'DEAL_TYPE_LONG_NAME', 'String containing the deal type.eg,Exchange Calendar Spread Future,Exchange Product Spread Future etc...', 0, 
    'DEAL_TYPE_ID', 3, 'dealTypeLongName');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Counter Party', 'COUNTER_PARTY', 'String containing the CP name', 0, 
    'COUNTER_PARTY_ID', 6, 'counterParty');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Payment Terms', 'PAYMENT_TERMS', 'String containing the payterms name', 0, 
    'PAYMENT_TERMS_ID', 20, 'paymentTerms');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Payment Due Date', 'PAYMENT_DUE_DATE', 'String containing the paymaent dua date', 0, 
    NULL, 21, 'paymentDueDate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Trade Type', 'TRADE_TYPE', 'String containing the tarde type buy sell', 0, 
    NULL, 7, 'tradeType');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Amount', 'AMOUNT', 'String containing the amount of the fx trade', 0, 
    NULL, 19, 'amount');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Exchange/Net Rate', 'EXCHANGE_NET_RATE', 'String containing the exchange rate of the fx trade currency instrument', 0, 
    NULL, 15, 'exchangeNetRate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Option Premium', 'OPTION_PREMIUM', 'String containing the option premium details', 0, 
    NULL, 16, 'optionPremium');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Option Premium Unit', 'OPTION_PREMIUM_CUR_UNIT', 'String containing the option premium unit details', 0, 
    'OPTION_PREMIUM_CUR_UNIT_ID', 17, 'optionPremiumCurUnit');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Expiry Date', 'EXPIRY_DATE', 'String containing the Remarks details', 0, 
    NULL, 18, 'expiryDate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Bank Name', 'BANK_NAME', 'String containing the bank name', 0, 
    'BANK_NAME_ID', 22, 'bankName');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Bank Account', 'BANK_ACCOUNT', 'String containing the bank account name', 0, 
    'BANK_ACCOUNT_ID', 23, 'bankAccount');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Bank Charges', 'BANK_CHARGES', 'String containing the bank Bank Charges', 0, 
    NULL, 24, 'bankCharges');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Bank Charges Unit/%', 'BANK_CHARGES_UNIT_OR_PERCENTAGE', 'String containing the bank Bank Charges unit or percentage', 0, 
    'BANK_CHARGES_UNIT_ID', 25, 'bankChargesUnitOrPercentage');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Profit Center', 'PROFIT_CENTER', 'String containing the profit center details', 0, 
    'PROFIT_CENTER_ID', 26, 'profitCenter');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Strategy', 'STRATEGY', 'String containing the Strategy details', 0, 
    'STRATEGY_ID', 27, 'strategy');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Purpose', 'PURPOSE', 'String containing the Purpose details', 0, 
    'PURPOSE_ID', 28, 'purpose');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Nominee', 'NOMINEE', 'String containing the Nominee details', 0, 
    'NOMINEE_ID', 29, 'nominee');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Remarks', 'REMARKS', 'String containing the Remarks details', 0, 
    NULL, 30, 'remarks');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Trade Date', 'TRADE_DATE', 'Trade date for which the trade is created', 0, 
    NULL, 1, 'tradeDate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'External Trade Ref.No', 'EXTERNAL_TRADE_REF_NO', 'User input ext ref num', 0, 
    NULL, 2, 'externalTradeRefNo');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Exchange Instrument', 'EXCHANGE_INSTRUMENT', 'currency Instrument used for the trade.', 0, 
    'EXCHANGE_INSTRUMENT_ID', 8, 'exchangeInstrument');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Is Exchange Rate Component?', 'IS_EXCHANGE_RATE_COMPONENT', 'Y indicates component rates,N indicates single rate.', 0, 
    NULL, 9, 'isExchangeRateComponent');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Spot', 'SPOT', 'holds the spot rate.', 0, 
    NULL, 10, 'spot');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Premium', 'PREMIUM_RATE', 'holds the Premium rate.', 0, 
    NULL, 11, 'premiumRate');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Slippage', 'SLIPPAGE', 'holds the Slippage rate.', 0, 
    NULL, 12, 'slippage');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Margin', 'MARGIN', 'holds the Margin rate.', 0, 
    NULL, 13, 'margin');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Other Charges', 'OTHER_CHARGES', 'holds the Other Charges rate.', 0, 
    NULL, 14, 'otherCharges');
Insert into ITCM_IMP_TABLE_COLUMN_MAPPING
   (FILE_TYPE_ID, FILE_COLUMN_NAME, DB_COLUMN_NAME, REMARKS, MIN_VALUE, 
    MAPPED_COLUMN_NAME, COLUMN_ORDER, PROPERTY_NAME)
 Values
   ('IMPORT_FX_OPTION_TRADES', 'Value Date', 'VALUE_DATE', 'holds the value date for the currecny trade.', 0, 
    NULL, 5, 'valueDate');
    
--$$$$$$import fx Option end$$$$$$--
ALTER TABLE CT_CURRENCY_TRADE ADD (IS_IMPORTED  CHAR(1 CHAR));
/* Formatted on 2012/05/28 17:58 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE "PKG_CDC_GENERAL"
IS
   -- All cdc general packages and procedures
   FUNCTION f_is_holiday_int_rate_entry (
      pc_interest_rate_id   IN   VARCHAR2,
      pc_trade_date              DATE
   )
      RETURN VARCHAR2;

   FUNCTION f_get_quality_name (pc_qualityid VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION f_get_curr_id (pc_price_unit_id IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION f_get_quantity_unit_id (pc_price_unit_id IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION f_get_option_type (pc_option_type_id IN VARCHAR2)
      RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY "PKG_CDC_GENERAL"
IS
  ------------------------------------------------------------------------------
  /* function to check if a date is holiday */
--------------------------------------------------------------------------
   FUNCTION f_is_holiday_int_rate_entry
/**************************************************************************************************
      Function Name                       : f_is_holiday_int_rate_entry
      Author                              : rahulbg
      Created Date                        : 23rd May 2011
      Purpose                             : To check if given date is an exchange holiday

      Parameters                          :

      pc_interest_rate_id                 : interest rate Id
      pc_trade_date                       : trade date
      Returns                             :'success' if holiday else 'failure' if not holiday

      Modification History

      Modified Date  :
      Modified By  :
      Modify Description :
      ***************************************************************************************************/
                                       (
      pc_interest_rate_id   IN   VARCHAR2,
      pc_trade_date              DATE
   )
      RETURN VARCHAR2
   IS
      pc_counter   NUMBER (1);
      result_val   VARCHAR2 (50);
   BEGIN
      --Checking the Week End Holiday List
      BEGIN
         SELECT COUNT (*)
           INTO pc_counter
           FROM DUAL
          WHERE TO_CHAR (pc_trade_date, 'Dy') IN (
                   SELECT clwh.holiday
                     FROM irs_interest_rate_setup irs,
                          clm_calendar_master clm,
                          clwh_calendar_weekly_holiday clwh
                    WHERE irs.applied_holiday_calendar_id = clwh.calendar_id
                      AND clm.calendar_id = clwh.calendar_id
                      AND clm.is_deleted = 'N'
                      AND clwh.is_deleted = 'N'
                      AND irs.interest_rate_id = pc_interest_rate_id);

         IF (pc_counter = 1)
         THEN
            result_val := 'success';
--        pc_error_code := '-20005';
            RETURN result_val;
         ELSE
            result_val := 'failure';
         END IF;

         IF (result_val = 'failure')
         THEN
            --Checking Other Holiday List
            SELECT COUNT (*)
              INTO pc_counter
              FROM DUAL
             WHERE TRIM (pc_trade_date) IN (
                      SELECT TRIM (hl.holiday_date)
                        FROM irs_interest_rate_setup irs,
                             hm_holiday_master hm,
                             hl_holiday_list hl,
                             clm_calendar_master clm
                       WHERE hm.holiday_id = hl.holiday_id
                         AND irs.applied_holiday_calendar_id = clm.calendar_id
                         AND clm.calendar_id = hm.calendar_id
                         AND hm.is_deleted = 'N'
                         AND hl.is_deleted = 'N'
                         AND irs.interest_rate_id = pc_interest_rate_id);

            IF (pc_counter = 1)
            THEN
               result_val := 'success';
               --pc_error_code := '-20005';
               RETURN result_val;
            ELSE
               result_val := 'failure';
               RETURN result_val;
            END IF;
         END IF;
      END;

      RETURN result_val;
   END f_is_holiday_int_rate_entry;

   FUNCTION f_get_quality_name (pc_qualityid VARCHAR2)
      RETURN VARCHAR2
   IS
      vc_qualityname   VARCHAR2 (50);
   BEGIN
      SELECT qat.quality_name
        INTO vc_qualityname
        FROM qat_quality_attributes qat
       WHERE UPPER (qat.quality_id) = UPPER (TRIM (pc_qualityid))
         AND qat.is_deleted = 'N';

      RETURN (vc_qualityname);
   END;

   FUNCTION f_get_curr_id (pc_price_unit_id IN VARCHAR2)
      RETURN VARCHAR2
   IS
      vc_qty_unit_id   VARCHAR2 (50);
   BEGIN
      SELECT cm.cur_id
        INTO vc_qty_unit_id
        FROM cm_currency_master cm, pum_price_unit_master pum
       WHERE pum.cur_id = cm.cur_id AND pum.price_unit_id = pc_price_unit_id;

      RETURN (vc_qty_unit_id);
   END;

   FUNCTION f_get_quantity_unit_id (pc_price_unit_id IN VARCHAR2)
      RETURN VARCHAR2
   IS
      vc_qty_unit_id   VARCHAR2 (50);
   BEGIN
      SELECT qum.qty_unit_id
        INTO vc_qty_unit_id
        FROM qum_quantity_unit_master qum, pum_price_unit_master pum
       WHERE pum.weight_unit_id = qum.qty_unit_id
         AND pum.price_unit_id = pc_price_unit_id;

      RETURN (vc_qty_unit_id);
   END;

   FUNCTION f_get_option_type (pc_option_type_id VARCHAR2)
      RETURN VARCHAR2
   IS
      vc_pc_option_type   VARCHAR2 (50);
   BEGIN
      SELECT istm.instrument_sub_type
        INTO vc_pc_option_type
        FROM istm_instr_sub_type_master istm
       WHERE istm.instrument_sub_type_id = UPPER (TRIM (pc_option_type_id))
         AND istm.is_deleted = 'N';

      RETURN (vc_pc_option_type);
   END;
END;
/
--gm
update GM_GRID_MASTER gm
set GM.DEFAULT_COLUMN_MODEL_STATE = 
'[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","id":"checker","sortable":false,"width":20},
 {header: "Ref No", width: 150, sortable: true, dataIndex: "tradeRefNo"},
 {header: "Product Quality", width: 150, sortable: true, dataIndex: "qualityName"},
 {header: "Market Location", width: 150, sortable: true, dataIndex: "marketLocation"},
 {header: "Instrument", width: 150, sortable: true, dataIndex: "instrumentName"},
 {header: "Trade Date", width: 150, sortable: true, dataIndex: "tradeDate"},
 {header: "Trader", width: 150, sortable: true, dataIndex: "traderName"},
 {header: "Counter Party", width: 150, sortable: true, dataIndex: "counterParty"},
 {header: "External Trade Ref. No.", width: 150, sortable: true, dataIndex: "externalRefNo"},
 {header: "Master Contract Ref. No.", width: 150, sortable: true, dataIndex: "masterContractRefNo"},
 {header: "Prompt/Delivery Details", width: 150, sortable: true, dataIndex: "deliveryDateMonth"},
 {header: "B/S", width: 150, sortable: true, dataIndex: "buySell"},                         
 {header: "Option Type", width: 150, sortable: true, dataIndex: "optionTypeName"},
 {header: "Average Period Start Date", width: 150, sortable: true, dataIndex: "avgPeriodStartDate"},
 {header: "Average Period End (Expiry) Date", width: 150, sortable: true, dataIndex: "avgPeriodEndDate"},                         
 {header: "Expiry Date", width: 150, sortable: true, dataIndex: "expiryDate"},
 {header: "Broker", width: 150, sortable: true, dataIndex: "brokerName"},
 {header: "Broker Commission Type", width: 150, sortable: true, dataIndex: "brokerCommissionTypeName"},
 {header: "Purpose", width: 150, sortable: true, dataIndex: "purposeDisplayName"},
 {header: "Deal Type", width: 150, sortable: true, dataIndex: "dealType"},
 {header: "Internal Trade Nos.", width: 150, sortable: true, dataIndex: "intTradeNumber"},
 {header: "Strategy", width: 150, sortable: true, dataIndex: "strategyName"},
 {header: "Total Quantity", width: 150, sortable: true, dataIndex: "totalQuantity"},
 {header: "Strike Price", width: 150, sortable: true, dataIndex: "strikePrice"},
 {header: "Premium", width: 150, sortable: true, dataIndex: "premium"},
 {header: "Status", width: 150, sortable: true, dataIndex: "status"},
 {header: "Payment Term", width: 150, sortable: true, dataIndex: "paymentTerm"},
 {header: "Payment Due Date", width: 150, sortable: true, dataIndex: "PaymentDueDate"},
 {header: "Profit Center", width: 150, sortable: true, dataIndex: "profitCenterName"},                         
 {header: "Created By", width: 150, sortable: true, dataIndex: "createdBy"},
 {header: "Created Date", width: 150, sortable: true, dataIndex: "createdDate"},
 {header: "Created Through", width: 150, sortable: true, dataIndex: "createdThrough"}]'
where GM.GRID_ID = 'LIST_OTC_OPTION_TRADES';
--dt
ALTER TABLE dt_derivative_trade ADD (latest_internal_action_ref_no  VARCHAR2(15));

ALTER TABLE dt_derivative_trade ADD (no_of_prompt_days  NUMBER(5));

ALTER TABLE dt_derivative_trade ADD (per_day_pricing_qty  NUMBER(25,5));

--dtul
ALTER TABLE DTUL_DERIVATIVE_TRADE_UL ADD (latest_internal_action_ref_no  VARCHAR2(15));

ALTER TABLE DTUL_DERIVATIVE_TRADE_UL ADD (no_of_prompt_days VARCHAR2(15));

ALTER TABLE DTUL_DERIVATIVE_TRADE_UL ADD (per_day_pricing_qty VARCHAR2(30));
rem PL/SQL Developer Test Script


create or replace function fn_cdc_noof_trading_days(pc_instrumentid varchar2,
                                                    pd_from_date    date,
                                                    pd_to_date      date)
  return number is
  vn_trading_days number;
  vd_from_date    date;
  vd_to_date      date;
begin
  vn_trading_days := 0;
  vd_from_date    := pd_from_date;
  vd_to_date      := pd_to_date;
  if vd_from_date is not null and vd_to_date is not null then
    while vd_from_date <= vd_to_date
    loop
      if not
          pkg_drid_generator.f_is_day_holiday(pc_instrumentid, vd_from_date) then
        vn_trading_days := vn_trading_days + 1;
      end if;
      vd_from_date := vd_from_date + 1;
    end loop;
  end if;
  return vn_trading_days;
exception
  when others then
    vn_trading_days := -1;
    return vn_trading_days;
end;
/
--set feedback off
--set autoprint off

rem Execute PL/SQL Block
/* Formatted on 2012/05/30 13:40 (Formatter Plus v4.8.8) */
declare
  v_no_of_prompt_days   number;
  v_per_day_pricing_qty number;
begin
  for temp in (select dam.internal_derivative_ref_no,
                      substr(max(to_char(axs.created_date,
                                         'yyyymmddhh24missff9') ||
                                 dam.internal_action_ref_no),
                             24) latest_internal_action_id,
                      dtm.deal_type_name,
                      drm.instrument_id,
                      dt.average_from_date,
                      dt.average_to_date,
                      dt.total_quantity
                 from dt_derivative_trade            dt,
                      dam_derivative_action_amapping dam,
                      axs_action_summary             axs,
                      dtm_deal_type_master           dtm,
                      drm_derivative_master          drm
                where dt.status <> 'Delete'
                  and dam.internal_derivative_ref_no =
                      dt.internal_derivative_ref_no
                  and dt.deal_type_id = dtm.deal_type_id
                  and dt.dr_id = drm.dr_id
                  and dam.internal_action_ref_no =
                      axs.internal_action_ref_no
                group by dam.internal_derivative_ref_no,
                         dtm.deal_type_name,
                         drm.instrument_id,
                         dt.average_from_date,
                         dt.average_to_date,
                         total_quantity)
  
  loop
    update dt_derivative_trade dt1
       set dt1.latest_internal_action_ref_no = temp.latest_internal_action_id
     where dt1.internal_derivative_ref_no = temp.internal_derivative_ref_no;
    if (temp.deal_type_name = 'OAF') then
      v_no_of_prompt_days   := fn_cdc_noof_trading_days(temp.instrument_id,
                                                        temp.average_from_date,
                                                        temp.average_to_date);
      v_per_day_pricing_qty := temp.total_quantity / v_no_of_prompt_days;
    
      update dt_derivative_trade dt2
         set dt2.no_of_prompt_days   = v_no_of_prompt_days,
             dt2.per_day_pricing_qty = v_per_day_pricing_qty
       where dt2.internal_derivative_ref_no =
             temp.internal_derivative_ref_no;
    end if;
  end loop;
  commit;
end;
/

rem PL/SQL Developer Test Script

--set feedback off
--set autoprint off

rem Execute PL/SQL Block
-- Created on 5/30/2012 by SIVACHALABATHI 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  update dtul_derivative_trade_ul dtul
     set dtul.latest_internal_action_ref_no = dtul.internal_action_ref_no;
  commit;
  for cc in (select dt.internal_derivative_ref_no,
                    dtm.deal_type_name,
                    drm.instrument_id,
                    dt.average_from_date,
                    dt.average_to_date,
                    dt.no_of_prompt_days,
                    dt.per_day_pricing_qty
               from dt_derivative_trade   dt,
                    dtm_deal_type_master  dtm,
                    drm_derivative_master drm
              where dt.status <> 'Delete'
                and dt.deal_type_id = dtm.deal_type_id
                and dt.dr_id = drm.dr_id
                and dtm.deal_type_name = 'OAF')
  loop
    update dtul_derivative_trade_ul dtul
       set dtul.no_of_prompt_days   = cc.no_of_prompt_days,
           dtul.per_day_pricing_qty = cc.per_day_pricing_qty
     where dtul.internal_derivative_ref_no = cc.internal_derivative_ref_no;
  
  end loop;
  commit;
end;
/

/* Formatted on 2012/05/22 18:58 (Formatter Plus v4.8.8) */
--for forward trades
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 1
 WHERE menu_id = 'FWD_TRADES-02'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 2
 WHERE menu_id = 'FWD_TRADES-03'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 3
 WHERE menu_id = 'FWD_TRADES-04'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 4
 WHERE menu_id = 'FWD_TRADES-05'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 6
 WHERE menu_id = 'FWD_TRADES-06'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 5
 WHERE menu_id = 'FWD_TRADES-07'
/
--for future trades

UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 2
 WHERE menu_id = 'FUT_TRADES-03'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 3
 WHERE menu_id = 'FUT_TRADES-04'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 4
 WHERE menu_id = 'FUT_TRADES-05'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 6
 WHERE menu_id = 'FUT_TRADES-07'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 7
 WHERE menu_id = 'FUT_TRADES-08'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 8
 WHERE menu_id = 'FUT_TRADES-09'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 9
 WHERE menu_id = 'FUT_TRADES-10'
/
--for exchange option trades

UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 6
 WHERE menu_id = 'EXCHANGE_OPTIONS-08'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 7
 WHERE menu_id = 'EXCHANGE_OPTIONS-09'
/
--for exchange swaps trades

UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 1
 WHERE menu_id = 'EXC_SWAP_TRADES-03'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 2
 WHERE menu_id = 'EXC_SWAP_TRADES-04'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 3
 WHERE menu_id = 'EXC_SWAP_TRADES-05'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 4
 WHERE menu_id = 'EXC_SWAP_TRADES-02'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 5
 WHERE menu_id = 'EXC_SWAP_TRADES-08'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 6
 WHERE menu_id = 'EXC_SWAP_TRADES-07'
/
--for OTC swaps trades

UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 1
 WHERE menu_id = 'OTC_SWAP_TRADES-03'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 2
 WHERE menu_id = 'OTC_SWAP_TRADES-04'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 3
 WHERE menu_id = 'OTC_SWAP_TRADES-05'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 4
 WHERE menu_id = 'OTC_SWAP_TRADES-02'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 5
 WHERE menu_id = 'OTC_SWAP_TRADES-08'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 6
 WHERE menu_id = 'OTC_SWAP_TRADES-07'
/
--for Internal trades

UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 1
 WHERE menu_id = 'INTERNAL_TRADES-03'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 2
 WHERE menu_id = 'INTERNAL_TRADES-04'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 3
 WHERE menu_id = 'INTERNAL_TRADES-05'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 4
 WHERE menu_id = 'INTERNAL_TRADES-02'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 5
 WHERE menu_id = 'INTERNAL_TRADES-06'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 6
 WHERE menu_id = 'INTERNAL_TRADES-07'
/
--for Avg Frwd trades

UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 1
 WHERE menu_id = 'AVG_FWD_TRADES-04'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 2
 WHERE menu_id = 'AVG_FWD_TRADES-05'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 3
 WHERE menu_id = 'AVG_FWD_TRADES-02'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 4
 WHERE menu_id = 'AVG_FWD_TRADES-03'
/
UPDATE gmc_grid_menu_configuration
   SET display_seq_no = 5
 WHERE menu_id = 'AVG_FWD_TRADES-06'
/
CREATE TABLE COQ_CURRENCY_OPTION_QUOTES
(
  COQ_ID           VARCHAR2(15 CHAR)            NOT NULL,
  TRADE_DATE       DATE                         NOT NULL,
  CORPORATE_ID     VARCHAR2(15 CHAR)            NOT NULL,
  INSTRUMENT_ID    VARCHAR2(15 CHAR)            NOT NULL,
  PRICE_SOURCE_ID  VARCHAR2(15 CHAR)            NOT NULL,
  CREATED_DATE     TIMESTAMP(6)                 NOT NULL,
  UPDATED_DATE     TIMESTAMP(6)                 NOT NULL,
  VERSION          NUMBER(4)                    NOT NULL,
  IS_DELETED       CHAR(1 CHAR)                 DEFAULT 'N'                   NOT NULL,
  IS_IMPORTED      CHAR(1 CHAR)
)
/

ALTER TABLE COQ_CURRENCY_OPTION_QUOTES ADD (
  CONSTRAINT PK_COQ
 PRIMARY KEY
 (COQ_ID))
/

ALTER TABLE COQ_CURRENCY_OPTION_QUOTES ADD (
CONSTRAINT FK_COQ_PRICE_SOURCE_ID 
 FOREIGN KEY (PRICE_SOURCE_ID) 
 REFERENCES PS_PRICE_SOURCE (PRICE_SOURCE_ID),
 CONSTRAINT FK_COQ_INSTRUMENT_ID 
 FOREIGN KEY (INSTRUMENT_ID) 
 REFERENCES DIM_DER_INSTRUMENT_MASTER (INSTRUMENT_ID),
  CONSTRAINT FK_COQ_CORPORATE_ID 
 FOREIGN KEY (CORPORATE_ID) 
 REFERENCES AK_CORPORATE (CORPORATE_ID))
/



CREATE TABLE COQD_CUR_OPTION_QUOTE_DETAIL
(
  COQD_ID              VARCHAR2(15 CHAR)         NOT NULL,
  COQ_ID               VARCHAR2(15 CHAR)         NOT NULL,
  DR_ID               VARCHAR2(15 CHAR)         NOT NULL,
  PRICE               NUMBER(25,5),
  AVAILABLE_PRICE_ID  VARCHAR2(15 CHAR)         NOT NULL,
  DELTA               NUMBER(25,5),
  GAMMA               NUMBER(25,5),
  THETA               NUMBER(25,5),
  WEGA                NUMBER(25,5),
  IS_DELETED          CHAR(1 CHAR)              DEFAULT 'N'                   NOT NULL,
  IS_IMPORTED         CHAR(1 CHAR),
  CREATED_DATE        TIMESTAMP(6),
  UPDATED_DATE        TIMESTAMP(6)
)
/


CREATE UNIQUE INDEX PK_COQD ON COQD_CUR_OPTION_QUOTE_DETAIL
(COQD_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


ALTER TABLE COQD_CUR_OPTION_QUOTE_DETAIL ADD (
  CONSTRAINT PK_COQD
 PRIMARY KEY
 (COQD_ID))
/

ALTER TABLE COQD_CUR_OPTION_QUOTE_DETAIL ADD (
  CONSTRAINT FK_COQD_COQ_ID 
 FOREIGN KEY (COQ_ID) 
 REFERENCES COQ_CURRENCY_OPTION_QUOTES (COQ_ID),
 CONSTRAINT FK_COQD_AVAILABLE_PRICE_ID 
 FOREIGN KEY (AVAILABLE_PRICE_ID) 
 REFERENCES APM_AVAILABLE_PRICE_MASTER (AVAILABLE_PRICE_ID)
 )
/




CREATE SEQUENCE SEQ_COQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/
  
  CREATE SEQUENCE SEQ_COQD
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/


/*ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN IS_STRIP;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN OPTION_STRIP_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN IS_PRIMARY_ROW;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN OPTION_START_DATE;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN OPTION_END_DATE;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN BROKER_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN BROKER_COMMISSION_TYPE_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN SETTLEMENT_PERIOD_TYPE_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN SETTLEMENT_PERIOD_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN OPTION_STRIP_START_DATE;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN OPTION_STRIP_END_DATE;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN STRIKE_RATE;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN STRIKE_RATE_UNIT_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN STRIP_PAYMENT_DUE_DATE;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN OPTION_PREM_CURR_CURVE_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN STRIP_PRICE_SOURCE_ID;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN PAR_INT_TREASURY_REF_NO;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN PREMIUM;
ALTER TABLE CT_CURRENCY_TRADE DROP COLUMN PREMIUM_UNIT_ID;
*/

-----------------------------
/*
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN OPTION_START_DATE
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN OPTION_END_DATE
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN BROKER_ID
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN BROKER_COMMISSION_TYPE_ID
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN SETTLEMENT_PERIOD_TYPE_ID
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN SETTLEMENT_PERIOD_ID
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN OPTION_STRIP_START_DATE
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN OPTION_STRIP_END_DATE
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN STRIKE_RATE
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN STRIP_PAYMENT_DUE_DATE
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN OPTION_PREM_CURR_CURVE_ID
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN STRIP_PRICE_SOURCE_ID
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN PAR_INT_TREASURY_REF_NO
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN PREMIUM
/
ALTER TABLE CTUL_CURRENCY_TRADE_UL DROP COLUMN PREMIUM_UNIT_ID;

*/
ALTER TABLE CT_CURRENCY_TRADE
ADD (OPTION_PREMIUM  NUMBER(20,10))
/
 
ALTER TABLE CT_CURRENCY_TRADE
ADD (OPTION_PREMIUM_UNIT_ID  VARCHAR2(20 CHAR))
/
 
ALTER TABLE CT_CURRENCY_TRADE
ADD (VALUE_DATE  DATE)
/
 
ALTER TABLE CT_CURRENCY_TRADE
ADD (PARENT_INT_FX_REF_NO  VARCHAR2(15 CHAR))
/



ALTER TABLE CTUL_CURRENCY_TRADE_UL
ADD (OPTION_PREMIUM  VARCHAR2 (30 Char))
/

 
ALTER TABLE CTUL_CURRENCY_TRADE_UL
ADD (OPTION_PREMIUM_UNIT_ID  VARCHAR2(20 CHAR))
/

 
ALTER TABLE CTUL_CURRENCY_TRADE_UL
ADD (VALUE_DATE  VARCHAR2 (30 Char))
/

 
ALTER TABLE CTUL_CURRENCY_TRADE_UL
ADD (PARENT_INT_FX_REF_NO  VARCHAR2(15 CHAR))
/
Insert into IRC_INTERNAL_REF_NO_CONFIG
   (INTERNAL_REF_NO_KEY, PREFIX, SEQ_NAME)
 Values
   ('PK_COQ', 'COQ', 'SEQ_COQ')
/
   
Insert into IRC_INTERNAL_REF_NO_CONFIG
   (INTERNAL_REF_NO_KEY, PREFIX, SEQ_NAME)
 Values
   ('PK_COQD', 'COQD', 'SEQ_COQD')

/



INSERT INTO amc_app_menu_configuration
            (menu_id, menu_display_name, display_seq_no, menu_level_no,
             link_called, icon_class, menu_parent_id, acl_id,
             tab_id, FEATURE_ID, is_deleted
            )
     VALUES ('CDC-M91', 'FX Option Quotes', 9, 2,
             '/cdc/loadFXOptionQuotes.action', NULL, 'CDC-M1', NULL,
             'Market Data', NULL, 'N'
            )
/

UPDATE amc_app_menu_configuration amc
   SET amc.link_called = '/cdc/newFxTrade.action?dealTypeId=DTM-2&gridId=ONF'
 WHERE amc.menu_id = 'T111'
 /

Insert into DDPM_DER_DEAL_PURPOSE_MAPPING
   (DEAL_TYPE_ID, PURPOSE_ID, ENTITY, IS_DELETED)
 Values
   ('DTM-4', 'DPM-3', 'Treasury', 'N')
/
Insert into DDPM_DER_DEAL_PURPOSE_MAPPING
   (DEAL_TYPE_ID, PURPOSE_ID, ENTITY, IS_DELETED)
 Values
   ('DTM-4', 'DPM-4', 'Treasury', 'N')
/

INSERT INTO ifm_import_file_master
            (file_type_id, file_type_name,
             table_name, proc_name, is_active, sample_file_name,
             remarks,
             column_model,
             record_model,
             function_name,
             file_mapping_table_name,
             insert_query,
             select_query,
             is_asynchronous, import_limit, context_path
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Fx Option Quotes',
             'IFXOQ_IMPORT_FX_OPTION_QUOTES', NULL, 'Y', 'FxOptionQuotes.xls',
             NULL,             
    '[{header: "Line No", width: 100, sortable: false,  dataIndex: "lineNo"},
      {header: "Bad Record", width: 100, sortable: true,renderer:processBadRecord,  dataIndex: "isBadRecord"},
      {header:"Trade Date", width: 100, sortable: false,  dataIndex:"tradeDate"},    
      {header:"Currency Instrument", width: 100, sortable: false,  dataIndex:"instrumentName"}, 
      {header:"Price Source", width: 100, sortable: false,  dataIndex:"priceSource"},
      {header:"Price Unit", width: 100, sortable: false,  dataIndex:"priceUnit"},
      {header:"Period", width: 100, sortable: false,  dataIndex:"period"},
      {header:"Strike Rate", width: 100, sortable: false,  dataIndex:"strikeRate"}, 
      {header:"Price Type", width: 100, sortable: false,  dataIndex:"priceType"},
      {header:"Price", width: 100, sortable: false,  dataIndex:"price"},     
      {header:"Delta", width: 100, sortable: false,  dataIndex:"delta"},
      {header:"Gamma", width: 100, sortable: false,  dataIndex:"gamma"},
      {header:"Theta", width: 100, sortable: false,  dataIndex:"theta"},
      {header:"Vega", width: 100, sortable: false,  dataIndex:"vega"}]',             
     '[{name: "lineNo", mapping: "lineNo"},
      {name: "isBadRecord", mapping: "isBadRecord"},
      {name: "tradeDate", mapping: "property1"},
      {name: "instrumentName", mapping: "property2"},
      {name: "priceSource", mapping: "property3"},
      {name: "priceUnit", mapping: "property4"},
      {name: "period", mapping: "property5"},
      {name: "strikeRate", mapping: "property6"},
      {name: "priceType", mapping: "property7"},
      {name: "price", mapping: "property8"},
      {name: "delta", mapping: "property9"},
      {name: "gamma", mapping: "property10"},
      {name: "theta", mapping: "property11"},
      {name: "vega", mapping: "property12"}]',
             'window.opener.saveFxOptionQuotesImport',
             'FMIIR_FILE_MAPPING_IIR',
             'insert into IVR_IMPORT_VALID_RECORD(TRANSACTION_ID,LINE_NO,IS_BAD_RECORD,property1,property2,property3,property4,property5,property6,property7,property8,property9,property10,property11,property12) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
             'rn,count(*) over() TOTAL_NO_OF_RECORDS,TRANSACTION_ID,LINE_NO,IS_BAD_RECORD,property1,property2,property3,property4,property5,property6,property7,property8,property9,property10,property11,property12 from IVR_IMPORT_VALID_RECORD',
             'N', 100, 'CDC'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Trade Date', 'TRADE_DATE',
             'Trade date for which the quotes are entered', 0, NULL, 1,
             'tradeDate'
            )
/	    

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name,
             db_column_name, remarks, min_value, mapped_column_name,
             column_order, property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Currency Instrument',
             'INSTRUMENT_NAME', 'Holds the name for instrument', 0, NULL,
             2, 'instrumentName'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Price Source', 'PRICE_SOURCE',
             'Holds the name for price source', 0, NULL, 3,
             'priceSource'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Price Unit', 'PRICE_UNIT',
             'Holds the name for price unit', 0, NULL, 4,
             'priceUnit'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Period', 'PERIOD',
             'Holds the name for period entered', 0, NULL, 5,
             'period'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Strike Rate', 'STRIKE_RATE',
             'Holds strike rate details', 0, NULL, 6,
             'strikeRate'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Price Type', 'PRICE_TYPE',
             'Holds price type details', 0, NULL, 7,
             'priceType'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name, remarks,
             min_value, mapped_column_name, column_order, property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Price', 'PRICE', 'Holds price',
             0, NULL, 8, 'price'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Delta', 'DELTA',
             'Holds the delta value', 0, NULL, 9,
             'delta'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Gamma', 'GAMMA',
             'Holds gamma value', 0, NULL, 10,
             'gamma'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name,
             remarks, min_value, mapped_column_name, column_order,
             property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Theta', 'THETA',
             'Holds theta value', 0, NULL, 11,
             'theta'
            )
/

INSERT INTO itcm_imp_table_column_mapping
            (file_type_id, file_column_name, db_column_name, remarks,
             min_value, mapped_column_name, column_order, property_name
            )
     VALUES ('IMPORT_FX_OPTION_QUOTES', 'Vega', 'VEGA', 'Holds vega value',
             0, NULL, 12, 'vega'
            )
/





UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{header: "Trade Ref. No.", width: 150, sortable: true, dataIndex: "tradeRefNo"},
	                 {header: "Underlying Instrument Ref. No.", width: 150, sortable: true, dataIndex: "underlyingInstrRefNo"},
                     {header: "Trade Date", width: 150, sortable: true, dataIndex: "tradeDate"},
                     {header: "Trader", width: 150, sortable: true, dataIndex: "traderName"},                     
                     {header: "External Trade Ref. No.", width: 150, sortable: true, dataIndex: "externalRefNo"},                     
                     {header: "Prompt/Delivery Details", width: 150, sortable: true, dataIndex: "deliveryDateMonth"},
                     {header: "B/S", width: 150, sortable: true, dataIndex: "buySell"},
                     {header: "Clearer", width: 150, sortable: true, dataIndex: "clearerName"},
                     {header: "Clearing Account", width: 150, sortable: true, dataIndex: "clearerAccount"},
                     {header: "Purpose", width: 150, sortable: true, dataIndex: "purposeDisplayName"},
                     {header: "Internal Trade Nos.", width: 150, sortable: true, dataIndex: "intTradeNumber"},
                     {header: "Strategy", width: 150, sortable: true, dataIndex: "strategyName"},
                     {header: "Trade Basis Price", width: 150, sortable: true, dataIndex: "tradePriceTypeId"},
                     {header: "Total Quantity", width: 150, sortable: true, dataIndex: "totalQuantity"},
                     {header: "Total Lots", width: 150, sortable: true, dataIndex: "totalLots"},
                     {header: "Closed Lots", width: 150, sortable: true, dataIndex: "closedLots"},
                     {header: "Open Lots", width: 150, sortable: true, dataIndex: "openLots"},                     
                     {header: "Price", width: 150, sortable: true, dataIndex: "priceDetails"},
                     {header: "Status", width: 150, sortable: true, dataIndex: "status"},                     
                     {header: "Profit Center", width: 150, sortable: true, dataIndex: "profitCenterName"},
                     {header: "Deal Type", width: 150, sortable: true, dataIndex: "dealType"},
                     {header: "Average Pricing Period", width: 150, sortable: true, dataIndex: "averagePricingPeriod"},
                     {header: "Created By", width: 150, sortable: true, dataIndex: "createdBy"},
                     {header: "Created Date", width: 150, sortable: true, dataIndex: "createdDate"},
                     {header: "Created Through", width: 150, sortable: true, dataIndex: "createdThrough"}
                     {header: "Exchange Instrument", width: 150, sortable: true, dataIndex: "instrumentName"},
                     {header: "Price Source", width: 150, sortable: true, dataIndex: "priceSource"},
                     {header: "Price Point", width: 150, sortable: true, dataIndex: "pricePoint"},
                     {header: "Premium/Discount", width: 150, sortable: true, dataIndex: "premium"}]'
WHERE GRID_ID = 'LIST_AVERAGE_FORWARDS'
/

UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","hideable":false,"id":"checker","sortable":false,"width":20},
{"dataIndex":"tradeRefNo","header":"Ref No","id":1,"sortable":true,"width":150},
{"dataIndex":"instrumentName","header":"Instrument","id":2,"sortable":true,"width":150},
{"dataIndex":"tradeDate","header":"Trade Date","id":3,"sortable":true,"width":150},
{"dataIndex":"traderName","header":"Trader","id":4,"sortable":true,"width":150},
{"dataIndex":"nominee","header":"Nominee","id":5,"sortable":true,"width":150},
{"dataIndex":"externalRefNo","header":"External Trade Ref. No.","id":6,"sortable":true,"width":150},
{"dataIndex":"deliveryDateMonth","header":"Prompt/Delivery Details","id":7,"sortable":true,"width":150},
{"dataIndex":"buySell","header":"B/S","id":8,"sortable":true,"width":150},
{"dataIndex":"expiryDate","header":"Expiry Date","id":9,"sortable":true,"width":150},
{"dataIndex":"clearerName","header":"Clearer","id":10,"sortable":true,"width":150},
{"dataIndex":"clearerAccount","header":"Clearer Account","id":11,"sortable":true,"width":150},
{"dataIndex":"clearerCommissionTypeName","header":"Clearer Commission Type","id":12,"sortable":true,"width":150},
{"dataIndex":"brokerName","header":"Broker","id":13,"sortable":true,"width":150},
{"dataIndex":"brokerCommissionTypeName","header":"Broker Commission Type","id":14,"sortable":true,"width":150},
{"dataIndex":"purposeDisplayName","header":"Purpose","id":15,"sortable":true,"width":150},
{"dataIndex":"dealType","header":"Deal Type","id":16,"sortable":true,"width":150},
{"dataIndex":"intTradeNumber","header":"Internal Trade Nos.","id":17,"sortable":true,"width":150},
{"dataIndex":"strategyName","header":"Strategy","id":18,"sortable":true,"width":150},
{"dataIndex":"totalQuantity","header":"Total Quantity","id":19,"sortable":true,"width":150},
{"dataIndex":"totalLots","header":"Total Lots","id":20,"sortable":true,"width":150},
{"dataIndex":"openLots","header":"Open Lots","id":21,"sortable":true,"width":150},
{"dataIndex":"closedLots","header":"Closed Lots","id":22,"sortable":true,"width":150},
{"dataIndex":"exercisedLots","header":"Exercised/Expired Lots","id":23,"sortable":true,"width":150},
{"dataIndex":"strikePrice","header":"Strike Price","id":24,"sortable":true,"width":150},
{"dataIndex":"premium","header":"Premium","id":25,"sortable":true,"width":150},
{"dataIndex":"status","header":"Status","id":26,"sortable":true,"width":150},
{"dataIndex":"profitCenterName","header":"Profit Center","id":27,"sortable":true,"width":150},
{"dataIndex":"createdBy","header":"Created By","id":28,"sortable":true,"width":150},
{"dataIndex":"createdDate","header":"Created Date","id":29,"sortable":true,"width":150},
{"dataIndex":"createdThrough","header":"Created Through","id":30,"sortable":true,"width":150},
{"dataIndex":"optionTypeName","header":"Option Type","id":31,"sortable":true,"width":150}]'
WHERE  GRID_ID = 'LIST_EXCHNG_OPTION_TRADES'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","id":"checker","sortable":false,"width":20},
{header: "Ref.No.", width: 150, sortable: true, dataIndex: "tradeRefNo"},
{header: "Product Quality", width: 150, sortable: true, dataIndex: "qualityName"},
{header: "Market Location", width: 150, sortable: true, dataIndex: "marketLocation"},
{header: "Instrument", width: 150, sortable: true, dataIndex: "instrumentName"},
{header: "Trade Date", width: 150, sortable: true, dataIndex: "tradeDate"},
{header: "Trader", width: 150, sortable: true, dataIndex: "traderName"},
{header: "Counter Party", width: 150, sortable: true, dataIndex: "counterParty"},
{header: "External Trade Ref. No.", width: 150, sortable: true, dataIndex: "externalRefNo"},
{header: "Master Contract Ref. No.", width: 150, sortable: true, dataIndex: "masterContractRefNo"},
{header: "Prompt/Delivery Details", width: 150, sortable: true, dataIndex: "marketLocation"},
{header: "B/S", width: 150, sortable: true, dataIndex: "buySell"},
{header: "Broker", width: 150, sortable: true, dataIndex: "brokerName"},
{header: "Broker Commission Type", width: 150, sortable: true, dataIndex: "brokerCommissionTypeName"},
{header: "Purpose", width: 150, sortable: true, dataIndex: "purposeDisplayName"},
{header: "Deal Type", width: 150, sortable: true, dataIndex: "dealType"},
{header: "Internal Trade Nos.", width: 150, sortable: true, dataIndex: "intTradeNumber"},
{header: "Strategy", width: 150, sortable: true, dataIndex: "strategyName"},
{header: "Total Quantity", width: 150, sortable: true, dataIndex: "TotalQuantity"},
{header: "Price", width: 150, sortable: true, dataIndex: "priceDetails"},
{header: "Status", width: 150, sortable: true, dataIndex: "status"},
{header: "Profit Center", width: 150, sortable: true, dataIndex: "profitCenterName"},
{header: "Trade Price", width: 150, sortable: true, dataIndex: "priceDetails"},
{header: "Created By", width: 150, sortable: true, dataIndex: "createdBy"},
{header: "Created Date", width: 150, sortable: true, dataIndex: "createdDate"},
{header: "Created Through", width: 150, sortable: true, dataIndex: "createdThrough"}]'
WHERE GRID_ID = 'LIST_EXCHANG_SWAP_TRADES'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{header: "Profit Center", width: 100, sortable: true,  dataIndex: "profitcenter"},
{header: "Exchange Instrument", width: 100, sortable: true,  dataIndex: "exchangeInst"},
{header: "Strike Price", width: 100, sortable: true,  dataIndex: "strikePrice"},
{header: "Prompt/Delivery Details", width: 100, sortable: true,  dataIndex: "delPeriod"},
{header: "Clearer", width: 100, sortable: true,  dataIndex: "clearer"},
{header: "Clearer Account", width: 100, sortable: true,  dataIndex: "clearerAcc"},
{header: "Commision Type", width: 100, sortable: true,  dataIndex: "commisionType"},
{header: "Buy Lots", width: 100, sortable: true,  dataIndex: "buyLots"},
{header: "Sell Lots", width: 100, sortable: true,  dataIndex: "sellLots"},
{header: "Available Lots", width: 100, sortable: true,  dataIndex: "availLots"}'
WHERE GRID_ID = 'LIST_SETTLEMENT_CLOSEOUT'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","hideable":false,"id":"checker","sortable":false,"width":20},
{"dataIndex":"tradeRefNo","header":"Ref No","id":1,"sortable":true,"width":150},
{"dataIndex":"qualityName","header":"Product Quality","id":2,"sortable":true,"width":150},
{"dataIndex":"marketLocation","header":"Market Location","id":3,"sortable":true,"width":150},
{"dataIndex":"instrumentName","header":"Instrument","id":4,"sortable":true,"width":150},
{"dataIndex":"tradeDate","header":"Trade Date","id":5,"sortable":true,"width":150},
{"dataIndex":"traderName","header":"Trader","id":6,"sortable":true,"width":150},
{"dataIndex":"counterParty","header":"Counter Party","id":7,"sortable":true,"width":150},
{"dataIndex":"externalRefNo","header":"External Trade Ref. No.","id":8,"sortable":true,"width":150},
{"dataIndex":"masterContractRefNo","header":"Master Contract Ref. No.","id":9,"sortable":true,"width":150},
{"dataIndex":"deliveryDateMonth","header":"Prompt/Delivery Details","id":10,"sortable":true,"width":150},
{"dataIndex":"buySell","header":"B/S","id":11,"sortable":true,"width":150},
{"dataIndex":"brokerName","header":"Broker","id":12,"sortable":true,"width":150},
{"dataIndex":"brokerCommissionTypeName","header":"Broker Commission Type","id":13,"sortable":true,"width":150},
{"dataIndex":"purposeDisplayName","header":"Purpose","id":14,"sortable":true,"width":150},
{"dataIndex":"dealType","header":"Deal Type","id":15,"sortable":true,"width":150},
{"dataIndex":"intTradeNumber","header":"Internal Trade Nos.","id":16,"sortable":true,"width":150},
{"dataIndex":"strategyName","header":"Strategy","id":17,"sortable":true,"width":150},
{"dataIndex":"totalQuantity","header":"Total Quantity","id":18,"sortable":true,"width":150},
{"dataIndex":"status","header":"Status","id":19,"sortable":true,"width":150},
{"dataIndex":"paymentTerm","header":"Payment Term","id":20,"sortable":true,"width":150},
{"dataIndex":"paymentDueDate","header":"Payment Due Date","id":21,"sortable":true,"width":150},
{"dataIndex":"profitCenterName","header":"Profit Center","id":22,"sortable":true,"width":150},
{"dataIndex":"tradePrice","header":"Trade Price","id":23,"sortable":true,"width":150},
{"dataIndex":"createdBy","header":"Created By","id":24,"sortable":true,"width":150},
{"dataIndex":"createdDate","header":"Created Date","id":25,"sortable":true,"width":150},
{"dataIndex":"createdThrough","header":"Created Through","id":26,"sortable":true,"width":150}]'
WHERE  GRID_ID = 'LIST_FWD_TRADES'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","hideable":false,"id":"checker","sortable":false,"width":20},
{"dataIndex":"tradeRefNo","header":"Ref No","id":1,"sortable":true,"width":150},
{"dataIndex":"parentTradeRefNo","header":"Original Trade Ref. No.","hidden":false,"id":2,"sortable":true,"width":150},
{"dataIndex":"tradeDate","header":"Trade Date","id":3,"sortable":true,"width":150},
{"dataIndex":"traderName","header":"Trader","id":4,"sortable":true,"width":150},
{"dataIndex":"nominee","header":"Nominee","id":5,"sortable":true,"width":150},
{"dataIndex":"externalRefNo","header":"External Trade Ref. No.","id":6,"sortable":true,"width":150},
{"dataIndex":"deliveryDateMonth","header":"Prompt/Delivery Details","id":7,"sortable":true,"width":150},
{"dataIndex":"buySell","header":"B/S","id":8,"sortable":true,"width":150},
{"dataIndex":"clearerName","header":"Clearer","id":9,"sortable":true,"width":150},
{"dataIndex":"clearerCommissionTypeName","header":"Clearer Commission Type","id":10,"sortable":true,"width":150},
{"dataIndex":"clearerAccount","header":"Clearer Account","id":11,"sortable":true,"width":150},
{"dataIndex":"brokerName","header":"Broker","id":12,"sortable":true,"width":150},
{"dataIndex":"brokerCommissionTypeName","header":"Broker Commission Type","id":13,"sortable":true,"width":150},
{"dataIndex":"purposeDisplayName","header":"Purpose","id":14,"sortable":true,"width":150},
{"dataIndex":"dealType","header":"Deal Type","id":15,"sortable":true,"width":150},
{"dataIndex":"intTradeNumber","header":"Internal Trade Nos.","id":16,"sortable":true,"width":150},
{"dataIndex":"strategyName","header":"Strategy","id":17,"sortable":true,"width":150},
{"dataIndex":"instrumentName","header":"Exchange Instrument","id":18,"sortable":true,"width":150},
{"dataIndex":"totalQuantity","header":"Total Quantity","id":19,"sortable":true,"width":150},
{"dataIndex":"totalLots","header":"Total Lots","id":20,"sortable":true,"width":150},
{"dataIndex":"openLots","header":"Open Lots","id":21,"sortable":true,"width":150},
{"dataIndex":"closedLots","header":"Closed Lots","id":22,"sortable":true,"width":150},
{"dataIndex":"status","header":"Status","id":23,"sortable":true,"width":150},
{"dataIndex":"profitCenterName","header":"Profit Center","id":24,"sortable":true,"width":150},
{"dataIndex":"tradePrice","header":"Trade Price","id":25,"sortable":true,"width":150},
{"dataIndex":"createdBy","header":"Created By","id":26,"sortable":true,"width":150},
{"dataIndex":"createdDate","header":"Created Date","id":27,"sortable":true,"width":150},
{"dataIndex":"createdThrough","header":"Created Through","id":28,"sortable":true,"width":150}]'
WHERE GRID_ID = 'LIST_FUT_TRADES'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{header: "Close Out Ref. No.", width: 100, sortable: true,  dataIndex: "internalCloseOutRefNo"},
                    {header: "Activity Date", width: 100, sortable: true,  dataIndex: "activityDate"},
                    {header: "Trade Details", width: 100, sortable: true,  dataIndex: "tradeDetails"},
                    {header: "Prompt/Delivery Details", width: 100, sortable: true,  dataIndex: "deliveryMonth"},
                    {header: "Profit Center 1", width: 100, sortable: true,  dataIndex: "profitCenter1Id"},
                    {header: "Profit Center 2", width: 100, sortable: true,  dataIndex: "profitCenter2Id"},
                    {header: "Mode", width: 100, sortable: true,  dataIndex: "mode"},
                    {header: "Total Closed Lots", width: 100, sortable: true,  dataIndex: "totalLotsClosed"},
                    {header: "Realized PnL", width: 100, sortable: true,  dataIndex: "realizedPNL"},
                    {header: "Created By", width: 120, sortable: true,  dataIndex: "traderName"},
                    {header: "Created Date", width: 120, sortable: true,  dataIndex: "createdDate"}]'
WHERE GRID_ID = 'LIST_INTERNAL_CLOSEOUT'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","id":"checker","sortable":false,"width":20},
{header: "Internal Ref. No.", width: 150, sortable: true, dataIndex: "aggregateTradeRefNo"},
{header: "Trade Date", width: 150, sortable: true, dataIndex: "tradeDate"},
{header: "Trader", width: 150, sortable: true, dataIndex: "trader"},
{header: "External Trade Ref.No.", width: 150, sortable: true, dataIndex: "externalRefNo"},
{header: "Prompt/Delivery Details", width: 150, sortable: true, dataIndex: "deliveryPeriodName"},
{header: "Trade Type 1", width: 150, sortable: true, dataIndex: "tradeType"},
{header: "Trade Type 2", width: 150, sortable: true, dataIndex: "tradeTypeLeg2"},
{header: "Strategy", width: 150, sortable: true, dataIndex: "strategy"},
{header: "Exchange Instrument", width: 150, sortable: true, dataIndex: "exchangeInstrument"},
{header: "Total Quantity", width: 150, sortable: true, dataIndex: "totalQuantity"},
{header: "Total Lots", width: 150, sortable: true, dataIndex: "totalLots"},
{header: "Open Lots", width: 150, sortable: true, dataIndex: "openLots"},
{header: "Closed Lots", width: 150, sortable: true, dataIndex: "closedLots"},
{header: "Price", width: 150, sortable: true, dataIndex: "tradePrice"},
{header: "Status", width: 150, sortable: true, dataIndex: "status"},
{header: "Profit Center 1", width: 150, sortable: true, dataIndex: "profitCenter"},
{header: "Profit Center 2", width: 150, sortable: true, dataIndex: "profitCenterLeg2"},
{header: "Created By", width: 150, sortable: true, dataIndex: "createdBy"},
{header: "Created Date", width: 150, sortable: true, dataIndex: "createdDate"},
{header: "Created Through", width: 150, sortable: true, dataIndex: "createdThrough"},
{header: "Deal Type", width: 150, sortable: true, dataIndex: "dealType"}]'
WHERE GRID_ID = 'LIST_INTERNAL_TRADES'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{header: "Close Out Ref. No.", width: 100, sortable: true,  dataIndex: "internalCloseOutRefNo"},
{header: "Activity Date", width: 100, sortable: true,  dataIndex: "activityDate"},
{header: "Trade Details", width: 100, sortable: true,  dataIndex: "tradeDetails"},
{header: "Prompt/Delivery Details", width: 100, sortable: true,  dataIndex: "deliveryMonth"},
{header: "Profit Center", width: 100, sortable: true,  dataIndex: "profitCenter1Id"},
{header: "Mode", width: 100, sortable: true,  dataIndex: "mode"},
{header: "Clearer", width: 100, sortable: true,  dataIndex: "clearerProfileName"},
{header: "Total Closed Lots", width: 100, sortable: true,  dataIndex: "totalLotsClosed"},
{header: "Realized PnL", width: 100, sortable: true,  dataIndex: "realizedPNL"},
{header: "Clearer Commission", width: 100, sortable: true,  dataIndex: "clearedCommission"},
{header: "Created By", width: 120, sortable: true,  dataIndex: "traderName"},
{header: "Created Date", width: 120, sortable: true,  dataIndex: "createdDate"}]'
WHERE GRID_ID = 'LIST_NORMAL_CLOSEOUT'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","id":"checker","sortable":false,"width":20},
 {header: "Ref No", width: 150, sortable: true, dataIndex: "tradeRefNo"},
 {header: "Product Quality", width: 150, sortable: true, dataIndex: "qualityName"},
 {header: "Market Location", width: 150, sortable: true, dataIndex: "marketLocation"},
 {header: "Instrument", width: 150, sortable: true, dataIndex: "instrumentName"},
 {header: "Trade Date", width: 150, sortable: true, dataIndex: "tradeDate"},
 {header: "Trader", width: 150, sortable: true, dataIndex: "traderName"},
 {header: "Counter Party", width: 150, sortable: true, dataIndex: "counterParty"},
 {header: "External Trade Ref. No.", width: 150, sortable: true, dataIndex: "externalRefNo"},
 {header: "Master Contract Ref. No.", width: 150, sortable: true, dataIndex: "masterContractRefNo"},
 {header: "Prompt/Delivery Details", width: 150, sortable: true, dataIndex: "deliveryDateMonth"},
 {header: "B/S", width: 150, sortable: true, dataIndex: "buySell"},                         
 {header: "Option Type", width: 150, sortable: true, dataIndex: "optionTypeName"},
 {header: "Average Period Start Date", width: 150, sortable: true, dataIndex: "avgPeriodStartDate"},
 {header: "Average Period End (Expiry) Date", width: 150, sortable: true, dataIndex: "avgPeriodEndDate"},                         
 {header: "Expiry Date", width: 150, sortable: true, dataIndex: "expiryDate"},
 {header: "Broker", width: 150, sortable: true, dataIndex: "brokerName"},
 {header: "Broker Commission Type", width: 150, sortable: true, dataIndex: "brokerCommissionTypeName"},
 {header: "Purpose", width: 150, sortable: true, dataIndex: "purposeDisplayName"},
 {header: "Deal Type", width: 150, sortable: true, dataIndex: "dealType"},
 {header: "Internal Trade Nos.", width: 150, sortable: true, dataIndex: "intTradeNumber"},
 {header: "Strategy", width: 150, sortable: true, dataIndex: "strategyName"},
 {header: "Total Quantity", width: 150, sortable: true, dataIndex: "totalQuantity"},
 {header: "Strike Price", width: 150, sortable: true, dataIndex: "strikePrice"},
 {header: "Premium", width: 150, sortable: true, dataIndex: "premium"},
 {header: "Status", width: 150, sortable: true, dataIndex: "status"},
 {header: "Payment Term", width: 150, sortable: true, dataIndex: "paymentTerm"},
 {header: "Payment Due Date", width: 150, sortable: true, dataIndex: "PaymentDueDate"},
 {header: "Profit Center", width: 150, sortable: true, dataIndex: "profitCenterName"},                         
 {header: "Created By", width: 150, sortable: true, dataIndex: "createdBy"},
 {header: "Created Date", width: 150, sortable: true, dataIndex: "createdDate"},
 {header: "Created Through", width: 150, sortable: true, dataIndex: "createdThrough"}]'
WHERE GRID_ID = 'LIST_OTC_OPTION_TRADES'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","id":"checker","sortable":false,"width":20},
{header: "Ref.No.", width: 150, sortable: true, dataIndex: "tradeRefNo"},
{header: "Product Quality", width: 150, sortable: true, dataIndex: "qualityName"},
{header: "Market Location", width: 150, sortable: true, dataIndex: "marketLocation"},
{header: "Instrument", width: 150, sortable: true, dataIndex: "instrumentName"},
{header: "Trade Date", width: 150, sortable: true, dataIndex: "tradeDate"},
{header: "Start Date", width: 120, sortable: true, dataIndex: "startDate"},
{header: "End Date", width: 120, sortable: true,align:"right", dataIndex: "endDate"},
{header: "Trader", width: 150, sortable: true, dataIndex: "traderName"},
{header: "Counter Party", width: 150, sortable: true, dataIndex: "counterParty"},
{header: "External Trade Ref. No.", width: 150, sortable: true, dataIndex: "externalRefNo"},
{header: "Master Contract Ref. No.", width: 150, sortable: true, dataIndex: "masterContractRefNo"},
{header: "Prompt/Delivery Details", width: 150, sortable: true, dataIndex: "marketLocation"},
{header: "B/S", width: 150, sortable: true, dataIndex: "buySell"},
{header: "Broker", width: 150, sortable: true, dataIndex: "brokerName"},
{header: "Broker Commission Type", width: 150, sortable: true, dataIndex: "brokerCommissionTypeName"},
{header: "Purpose", width: 150, sortable: true, dataIndex: "purposeDisplayName"},
{header: "Deal Type", width: 150, sortable: true, dataIndex: "dealType"},
{header: "Internal Trade Nos.", width: 150, sortable: true, dataIndex: "intTradeNumber"},
{header: "Strategy", width: 150, sortable: true, dataIndex: "strategyName"},
{header: "Total Quantity", width: 150, sortable: true, dataIndex: "TotalQuantity"},
{header: "Price", width: 150, sortable: true, dataIndex: "priceDetails"},
{header: "Status", width: 150, sortable: true, dataIndex: "status"},
{header: "Expiry Date", width: 150, sortable: true, dataIndex: "expiryDate"},
{header: "Strike Price", width: 150, sortable: true, dataIndex: "strikePrice"},
{header: "Premium", width: 150, sortable: true, dataIndex: "premium"},
{header: "Premium Due Date", width: 150, sortable: true, dataIndex: "premiumDueDate"},
{header: "Profit Center", width: 150, sortable: true, dataIndex: "profitCenterName"},
{header: "Trade Price", width: 150, sortable: true, dataIndex: "priceDetails"},
{header: "Created By", width: 150, sortable: true, dataIndex: "createdBy"},
{header: "Created Date", width: 150, sortable: true, dataIndex: "createdDate"},
{header: "Created Through", width: 150, sortable: true, dataIndex: "createdThrough"}]'
WHERE  GRID_ID = 'LIST_OTC_SWAP_OPTION_TRADES'
/
UPDATE GM_GRID_MASTER 
SET DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","id":"checker","sortable":false,"width":20},
{header: "Ref.No.", width: 150, sortable: true, dataIndex: "tradeRefNo"},
{header: "Original Trade Ref. No.", width: 150, sortable: true,renderer:ContractView,dataIndex: "parentTradeRefNo"},
{header: "Product Quality", width: 150, sortable: true, dataIndex: "qualityName"},
{header: "Market Location", width: 150, sortable: true, dataIndex: "marketLocation"},
{header: "Instrument", width: 150, sortable: true, dataIndex: "instrumentName"},
{header: "Trade Date", width: 150, sortable: true, dataIndex: "tradeDate"},
{header: "Trader", width: 150, sortable: true, dataIndex: "traderName"},
{header: "Counter Party", width: 150, sortable: true, dataIndex: "counterParty"},
{header: "External Trade Ref. No.", width: 150, sortable: true, dataIndex: "externalRefNo"},
{header: "Master Contract Ref. No.", width: 150, sortable: true, dataIndex: "masterContractRefNo"},
{header: "Prompt/Delivery Details", width: 150, sortable: true, dataIndex: "marketLocation"},
{header: "B/S", width: 150, sortable: true, dataIndex: "buySell"},
{header: "Broker", width: 150, sortable: true, dataIndex: "brokerName"},
{header: "Broker Commission Type", width: 150, sortable: true, dataIndex: "brokerCommissionTypeName"},
{header: "Purpose", width: 150, sortable: true, dataIndex: "purposeDisplayName"},
{header: "Deal Type", width: 150, sortable: true, dataIndex: "dealType"},
{header: "Internal Trade Nos.", width: 150, sortable: true, dataIndex: "intTradeNumber"},
{header: "Strategy", width: 150, sortable: true, dataIndex: "strategyName"},
{header: "Total Quantity", width: 150, sortable: true, dataIndex: "TotalQuantity"},
{header: "Price", width: 150, sortable: true, dataIndex: "priceDetails"},
{header: "Status", width: 150, sortable: true, dataIndex: "status"},
{header: "Profit Center", width: 150, sortable: true, dataIndex: "profitCenterName"},
{header: "Trade Price", width: 150, sortable: true, dataIndex: "priceDetails"},
{header: "Created By", width: 150, sortable: true, dataIndex: "createdBy"},
{header: "Created Date", width: 150, sortable: true, dataIndex: "createdDate"},
{header: "Created Through", width: 150, sortable: true, dataIndex: "createdThrough"}]'
WHERE  GRID_ID = 'LIST_OTC_SWAP_TRADES'
/

Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-01', 'FX_OPTION_TRADES', 'Operations', 1, 1, 
    NULL, 'function(){}', NULL, NULL, NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-02', 'FX_OPTION_TRADES', 'Exercise', 1, 2, 
    NULL, 'function(){exerciseFxOptionTrade();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-03', 'FX_OPTION_TRADES', 'Mark as Expired', 2, 2, 
    NULL, 'function(){markAsExpired();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-04', 'FX_OPTION_TRADES', 'Verify', 3, 2, 
    NULL, 'function(){verifyFxOptionTrades();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-05', 'FX_OPTION_TRADES', 'Unverify', 4, 2, 
    NULL, 'function(){unVerifyFxOptionTrades();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-06', 'FX_OPTION_TRADES', 'Delete', 5, 2, 
    NULL, 'function(){deleteFxOptionTrades();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-07', 'FX_OPTION_TRADES', 'Modify', 6, 2, 
    NULL, 'function(){modifyFxOptionTrade();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-08', 'FX_OPTION_TRADES', 'Copy', 7, 2, 
    NULL, 'function(){copyFxOptionTrade();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-09', 'FX_OPTION_TRADES', 'View', 8, 2, 
    NULL, 'function(){viewFxOptionTradeDetails();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('FX_OPTION_TRADES-10', 'FX_OPTION_TRADES', 'Import Fx Option Trade', 9, 2, 
    NULL, 'function(){importFxTrade();}', NULL, 'FX_OPTION_TRADES-01', NULL)
/





Insert into SLS_STATIC_LIST_SETUP
   (LIST_TYPE, VALUE_ID, IS_DEFAULT, DISPLAY_ORDER)
 Values
   ('currencyTradeStatus', 'Expired', 'N', 5)
/
Insert into SLS_STATIC_LIST_SETUP
   (LIST_TYPE, VALUE_ID, IS_DEFAULT, DISPLAY_ORDER)
 Values
   ('currencyTradeStatus', 'Exercised', 'N', 4)
/   
Insert into SLS_STATIC_LIST_SETUP
   (LIST_TYPE, VALUE_ID, IS_DEFAULT, DISPLAY_ORDER)
 Values
   ('currencyTradeStatus', 'None', 'N', 1)
/


UPDATE GM_GRID_MASTER GM
   SET GM.DEFAULT_COLUMN_MODEL_STATE = '[{"dataIndex":"","fixed":true,"header":"<div class=\"x-grid3-hd-checker\">&#160;</div>","hideable":false,"id":"checker","sortable":false,"width":20},{header: "Trade Date",  width: 100, sortable: true, dataIndex: ''tradeDate''},
            {header: "CP Name",  width: 100, sortable: true, dataIndex: ''counterPartyName''},
            {header: "Trade Ref No.",  width: 100, sortable: true, dataIndex: ''tradeRefNo''},
            {header: "Original Trade Ref No", width: 150, sortable: true, dataIndex: ''parentIntFxRefNo''},
            {header: "External Trade Ref No.",  width: 100, sortable: true, dataIndex: ''externalRefNo''},
            {header: "CCY Pair", width: 100,  sortable: true, dataIndex: ''currencyPairName''},
            {header: "Buy/Sell", width: 120, sortable: true, dataIndex: ''tradeType''},
            {header: "Foreign Currency", width: 120, sortable: true, dataIndex: ''frgnCurrency''},
            {header: "Foreign Currency Amount", width: 120, sortable: true,align:"right", dataIndex: ''frgnCurrencyAmount''},
            {header: "Exchange Rate", width: 120, sortable: true,align:"right", dataIndex: ''fxRateBaseToForeign''},
            {header: "Value Date", width: 120, sortable: true, dataIndex: ''valueDate''},
            {header: "Base Currency Amount", width: 120, sortable: true,align:"right", dataIndex: ''baseCurrencyAmount''},
            {header: "Profit Center", width: 120, sortable: true, dataIndex: ''profitCenterName''},
            {header: "Strategy", width: 120, sortable: true, dataIndex: ''strategy''},
            {header: "Bank Name/Account", width: 150, sortable: true, dataIndex: ''bankDetailsString''},
            {header: "Bank Charges", width: 150, sortable: true,align:"right", dataIndex: ''bankCharges''},
            {header: "Status", width: 150, sortable: true, dataIndex: ''status''},
            {header: "Created By", width: 150, sortable: true, dataIndex: ''createdBy''},
            {header: "Created On", width: 150, sortable: true, dataIndex: ''createdOn''}]'
 WHERE GM.GRID_ID = 'FX_TRADES'
 /
 
 UPDATE GM_GRID_MASTER GM
   SET GM.DEFAULT_RECORD_MODEL_STATE = '[{name: "internalTreasuryRefNo", mapping: "internalTreasuryRefNo"},
            {name: "counterPartyName", mapping: "counterPartyName"},
            {name: "externalRefNo", mapping: "externalRefNo"}, 
            {name: "tradeDate", mapping: "tradeDate"},
            {name: "tradeRefNo", mapping: "tradeRefNo"},
            {name: "parentIntFxRefNo", mapping: "parentIntFxRefNo"},
            {name: "exchangeInstrument", mapping: "exchangeInstrument"},
            {name: "currencyPairName", mapping: "currencyPairName"},
            {name: "tradeType", mapping: "tradeType"},
            {name: "frgnCurrency", mapping: "frgnCurrency"},
            {name: "frgnCurrencyAmount", mapping: "frgnCurrencyAmount"},
            {name: "exchangeRate", mapping: "exchangeRate"},
            {name: "fxRateBaseToForeign", mapping: "fxRateBaseToForeign"},
            {name: "valueDate", mapping: "valueDate"},
            {name: "baseCurrencyAmount", mapping: "baseCurrencyAmount"},
            {name: "strategy", mapping: "strategy"},
            {name: "profitCenterName", mapping: "profitCenterName"},
            {name: "bankDetailsString", mapping: "bankDetailsString"},
            {name: "bankCharges", mapping: "bankCharges"},
            {name: "status", mapping: "status"},
            {name: "allctdCntItemRefNos", mapping: "allctdCntItemRefNos"},
            {name: "allctdPhysicalAmt", mapping: "allctdPhysicalAmt"},
            {name: "createdBy", mapping: "createdBy"},
            {name: "createdOn", mapping: "createdOn"}]'
 WHERE GM.GRID_ID = 'FX_TRADES'
 /



Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('CDC_TR_OPTION_CREATE_TRADE', 'Currency', 'Create Treasury Option Trade', 'N', 'Create Treasury Option Trade', 
    'N', NULL)
/

Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('CDC_TR_OPTION_CREATE_TRADE', 'N', 'N', 'action_date', 'N', 
    NULL, NULL, NULL, 'N')
/
 
INSERT INTO AKM_ACTION_REF_KEY_MASTER
            (ACTION_KEY_ID, ACTION_KEY_DESC,
             VALIDATION_QUERY
            )
     VALUES ('CDC_Create_Opt', 'Create Treasury Option Trade',
             'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id'
            )
/

Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('CDC_TR_OPTION_EXPIRE_TRADE', 'Currency', 'Expire Treasury Option Trade', 'N', 'Expire Treasury Option Trade', 
    'N', NULL)

/

Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('CDC_TR_OPTION_EXPIRE_TRADE', 'N', 'N', 'action_date', 'N', 
    NULL, NULL, NULL, 'N')
    
/

INSERT INTO AKM_ACTION_REF_KEY_MASTER
            (ACTION_KEY_ID, ACTION_KEY_DESC,
             VALIDATION_QUERY
            )
     VALUES ('CDC_Expire_Opt', 'Expire Treasury Option Trade',
             'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id'
            )
            
/

Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('CDC_TR_OPTION_MODIFY_TRADE', 'Currency', 'Modify Treasury Option Trade', 'N', 'Modify Treasury Option Trade', 
    'N', NULL)

/

Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('CDC_TR_OPTION_MODIFY_TRADE', 'N', 'N', 'action_date', 'N', 
    NULL, NULL, NULL, 'N')
 /   


INSERT INTO AKM_ACTION_REF_KEY_MASTER
            (ACTION_KEY_ID, ACTION_KEY_DESC,
             VALIDATION_QUERY
            )
     VALUES ('CDC_Modify_Opt', 'Modify Treasury Option Trade',
             'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id'
            )
 /  

 Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('CDC_TR_OPTION_DELETE_TRADE', 'Currency', 'Delete Treasury Option Trade', 'N', 'Delete Treasury Option Trade', 
    'N', NULL)
/


Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('CDC_TR_OPTION_DELETE_TRADE', 'N', 'N', 'action_date', 'N', 
    NULL, NULL, NULL, 'N')
    
/

INSERT INTO AKM_ACTION_REF_KEY_MASTER
            (ACTION_KEY_ID, ACTION_KEY_DESC,
             VALIDATION_QUERY
            )
     VALUES ('CDC_Delete_Opt', 'Delete Treasury Option Trade',
             'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id'
            )

/ 

Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('CDC_TR_OPTION_VERIFY_TRADE', 'Currency', 'Verify Treasury Option Trade', 'N', 'Verify Treasury Option Trade', 
    'N', NULL)

/

Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('CDC_TR_OPTION_VERIFY_TRADE', 'N', 'N', 'action_date', 'N', 
    NULL, NULL, NULL, 'N')
    
/

INSERT INTO AKM_ACTION_REF_KEY_MASTER
            (ACTION_KEY_ID, ACTION_KEY_DESC,
             VALIDATION_QUERY
            )
     VALUES ('CDC_Verify_Opt', 'Verify Treasury Option Trade',
             'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id'
            )
 /  

 Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('CDC_TR_OPTION_UNVERIFY_TRADE', 'Currency', 'UnVerify Treasury Option Trade', 'N', 'UnVerify Treasury Option Trade', 
    'N', NULL)
/


Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('CDC_TR_OPTION_UNVERIFY_TRADE', 'N', 'N', 'action_date', 'N', 
    NULL, NULL, NULL, 'N')
    /
    


INSERT INTO AKM_ACTION_REF_KEY_MASTER
            (ACTION_KEY_ID, ACTION_KEY_DESC,
             VALIDATION_QUERY
            )
     VALUES ('TR_UnVerify', 'UnVerify Treasury Option Trade',
             'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id'
            )
            
/

Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('CDC_TR_OPTION_EXERCISE_TRADE', 'Currency', 'Exercise Treasury Option Trade', 'N', 'Exercise Treasury Option Trade', 
    'N', NULL)

/

Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('CDC_TR_OPTION_EXERCISE_TRADE', 'N', 'N', 'action_date', 'N', 
    NULL, NULL, NULL, 'N')
    
/

INSERT INTO AKM_ACTION_REF_KEY_MASTER
            (ACTION_KEY_ID, ACTION_KEY_DESC,
             VALIDATION_QUERY
            )
     VALUES ('TR_Exercise', 'Exercise Treasury Option Trade',
             'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id'
            )
            
/
SET DEFINE OFF;
declare
begin
 for cc in (select *
               from ak_corporate akc
              where akc.is_internal_corporate = 'N')
  loop
    dbms_output.put_line(cc.corporate_id);

INSERT INTO ARFM_ACTION_REF_NO_MAPPING
            (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID,
             ACTION_KEY_ID, IS_DELETED
            )
     VALUES ('CDC-TR-1-'||cc.corporate_id, cc.corporate_id, 'CDC_TR_OPTION_CREATE_TRADE',
             'CDC_Create_Opt', 'N'
            );

INSERT INTO ARF_ACTION_REF_NUMBER_FORMAT
            (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID,
             PREFIX, MIDDLE_NO_START_VALUE, MIDDLE_NO_LAST_USED_VALUE,
             SUFFIX, VERSION, IS_DELETED
            )
     VALUES ('CDC-TR-1'||cc.corporate_id, 'CDC_Create_Opt', cc.corporate_id,
             'CIN-', 0, 0,
             cc.corporate_id, 1, 'N'
            );
INSERT INTO ARFM_ACTION_REF_NO_MAPPING
            (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID,
             ACTION_KEY_ID, IS_DELETED
            )
     VALUES ('CDC-TR-2'||cc.corporate_id, cc.corporate_id, 'CDC_TR_OPTION_EXPIRE_TRADE',
             'CDC_Expire_Opt', 'N'
            );  


INSERT INTO ARF_ACTION_REF_NUMBER_FORMAT
            (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID,
             PREFIX, MIDDLE_NO_START_VALUE, MIDDLE_NO_LAST_USED_VALUE,
             SUFFIX, VERSION, IS_DELETED
            )
     VALUES ('CDC-TR-2'||cc.corporate_id, 'CDC_Expire_Opt', cc.corporate_id,
             'CIN-', 0, 0,
             cc.corporate_id, 1, 'N'
            );
INSERT INTO ARFM_ACTION_REF_NO_MAPPING
            (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID,
             ACTION_KEY_ID, IS_DELETED
            )
     VALUES ('CDC-TR-3'||cc.corporate_id, cc.corporate_id, 'CDC_TR_OPTION_MODIFY_TRADE',
             'CDC_Modify_Opt', 'N'
            );  

INSERT INTO ARF_ACTION_REF_NUMBER_FORMAT
            (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID,
             PREFIX, MIDDLE_NO_START_VALUE, MIDDLE_NO_LAST_USED_VALUE,
             SUFFIX, VERSION, IS_DELETED
            )
     VALUES ('CDC-TR-3'||cc.corporate_id, 'CDC_Modify_Opt', cc.corporate_id,
             'CIN-', 0, 0,
             cc.corporate_id, 1, 'N'
            ) ;
INSERT INTO ARFM_ACTION_REF_NO_MAPPING
            (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID,
             ACTION_KEY_ID, IS_DELETED
            )
     VALUES ('CDC-TR-4'||cc.corporate_id, cc.corporate_id, 'CDC_TR_OPTION_DELETE_TRADE',
             'CDC_Delete_Opt', 'N'
            ); 

INSERT INTO ARF_ACTION_REF_NUMBER_FORMAT
            (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID,
             PREFIX, MIDDLE_NO_START_VALUE, MIDDLE_NO_LAST_USED_VALUE,
             SUFFIX, VERSION, IS_DELETED
            )
     VALUES ('CDC-TR-4'||cc.corporate_id, 'CDC_Delete_Opt', cc.corporate_id,
             'CIN-', 0, 0,
             cc.corporate_id, 1, 'N'
            );
INSERT INTO ARFM_ACTION_REF_NO_MAPPING
            (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID,
             ACTION_KEY_ID, IS_DELETED
            )
     VALUES ('CDC-TR-5'||cc.corporate_id, cc.corporate_id, 'CDC_TR_OPTION_VERIFY_TRADE',
             'CDC_Verify_Opt', 'N'
            ); 

INSERT INTO ARF_ACTION_REF_NUMBER_FORMAT
            (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID,
             PREFIX, MIDDLE_NO_START_VALUE, MIDDLE_NO_LAST_USED_VALUE,
             SUFFIX, VERSION, IS_DELETED
            )
     VALUES ('CDC-TR-5'||cc.corporate_id, 'CDC_Verify_Opt', cc.corporate_id,
             'CIN-', 0, 0,
             cc.corporate_id, 1, 'N'
            );
	    
INSERT INTO ARFM_ACTION_REF_NO_MAPPING
            (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID,
             ACTION_KEY_ID, IS_DELETED
            )
     VALUES ('CDC-TR-6'||cc.corporate_id, cc.corporate_id, 'CDC_TR_OPTION_UNVERIFY_TRADE',
             'TR_UnVerify', 'N'
            );  

INSERT INTO ARF_ACTION_REF_NUMBER_FORMAT
            (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID,
             PREFIX, MIDDLE_NO_START_VALUE, MIDDLE_NO_LAST_USED_VALUE,
             SUFFIX, VERSION, IS_DELETED
            )
     VALUES ('CDC-TR-6'||cc.corporate_id, 'TR_UnVerify', cc.corporate_id,
             'CIN-', 0, 0,
             cc.corporate_id, 1, 'N'
            );

INSERT INTO ARFM_ACTION_REF_NO_MAPPING
            (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID,
             ACTION_KEY_ID, IS_DELETED
            )
     VALUES ('CDC-TR-7'||cc.corporate_id, cc.corporate_id, 'CDC_TR_OPTION_EXERCISE_TRADE',
             'TR_Exercise', 'N'
            ); 

INSERT INTO ARF_ACTION_REF_NUMBER_FORMAT
            (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID,
             PREFIX, MIDDLE_NO_START_VALUE, MIDDLE_NO_LAST_USED_VALUE,
             SUFFIX, VERSION, IS_DELETED
            )
     VALUES ('CDC-TR-7'||cc.corporate_id, 'TR_Exercise', cc.corporate_id,
             'CIN-', 0, 0,
             cc.corporate_id, 1, 'N'
            );	    
COMMIT;
 end loop;
commit;
end;

/
CREATE OR REPLACE PACKAGE BODY pkg_drid_generator is

  ------------------------------------------------------------------------------
  /* Function used to generate dr id */
  ------------------------------------------------------------------------------
  function f_get_drid(pc_trade_date           in date,
                      pc_instrumentid         in varchar2,
                      pc_price_point_id       in varchar2,
                      pc_delivery_period_id   in varchar2,
                      pc_period_type_id       in varchar2,
                      pc_date                 in date,
                      pc_month                in varchar2,
                      pc_year                 in number,
                      pc_start_date           in date,
                      pc_end_date             in date,
                      pc_strike_price         in number,
                      pc_strike_price_unit_id in varchar2,
                      pd_avg_wk_start_date    in date,
                      pd_avg_wk_end_date      in date) return varchar2 is
    -- Note:  pd_avg_wk_start_date, pd_avg_wk_end_date params added to generate the avg drid's undelying selected as week,
    -- in this case avg trade also will have start date,end date, week prompt date also will have start date,end date
    vc_underlying_instrument_id varchar2(15);
    vc_instrument_type          varchar2(50);
    vc_und_drid                 varchar2(15);
    vc_drid                     varchar2(15);
    vc_und_delivery_period_id   varchar2(15);
  begin
    begin
      select pm.period_type_name
        into pc_period_type
        from pm_period_master pm
       where pm.period_type_id = pc_period_type_id
         and pm.is_deleted = 'N';
    end;
    /* Printing Input Arguments */
    dbms_output.put_line('<!--------DRID Generator called with arguments: pc_period_type= ' ||
                         pc_period_type || ', pc_trade_date= ' ||
                         pc_trade_date || ', pc_instrumentid= ' ||
                         pc_instrumentid || ', pc_delivery_period_id= ' ||
                         pc_delivery_period_id || ', pc_period_type_id= ' ||
                         pc_period_type_id || ', pc_date= ' || pc_date ||
                         ', pc_month= ' || pc_month || ', pc_year= ' ||
                         pc_year || ', pc_start_date= ' || pc_start_date ||
                         ', pc_end_date= ' || pc_end_date ||
                         ', pc_strike_price= ' || pc_strike_price ||
                         ', pc_price_point_id ' || pc_price_point_id ||
                         ', pc_strike_price_unit_id= ' ||
                         pc_strike_price_unit_id || ' -------->');
    /* Opening the Instrument Cursor */
    p_open_instrument_cursor(pc_instrumentid);
    /* Opening the Delivery Period Cursor */
    p_open_del_period_cursor(pc_instrumentid, pc_delivery_period_id);
    /** Process DR-ID **/
    pc_dr_id := f_process_drid(pc_trade_date,
                               pc_instrumentid,
                               pc_price_point_id,
                               pc_delivery_period_id,
                               pc_period_type_id,
                               pc_date,
                               pc_month,
                               pc_year,
                               pc_start_date,
                               pc_end_date,
                               pc_strike_price,
                               pc_strike_price_unit_id,
                               pd_avg_wk_start_date,
                               pd_avg_wk_end_date);
    vc_drid  := pc_dr_id;
    -- Get the underlying instrument id and current instument type, for Options instruments underlying DRID has to be generated
    vc_underlying_instrument_id := nvl(cr_instrument_rec.underlying_instrument_id,
                                       'NA');
    vc_und_delivery_period_id   := nvl(cr_delivery_period_rec.underlying_delivery_period_id,
                                       pc_delivery_period_id);
    if vc_underlying_instrument_id = pc_instrumentid then
      vc_underlying_instrument_id := 'NA';
    end if;
    vc_instrument_type := nvl(cr_instrument_rec.instrument_type, 'NA');
    /* Closing the Instrument Cursor */
    p_close_instrument_cursor;
    /* Closing the Delivery Period Cursor */
    p_close_del_period_cursor;
    dbms_output.put_line('DrID Generated: ' || pc_dr_id);
    -- calculate for Options instruments underlying DRID
    if vc_instrument_type in ('Option Put', 'Option Call') and
       vc_underlying_instrument_id <> 'NA' and pc_dr_id is not null then
      vc_und_drid := fn_get_child_drid(vc_drid,
                                       vc_underlying_instrument_id,
                                       vc_und_delivery_period_id,
                                       pc_start_date,
                                       pc_end_date);
      dbms_output.put_line('child_drid Generated: ' || vc_und_drid);
    end if;
    if vc_instrument_type = 'Average' and
       vc_underlying_instrument_id <> 'NA' and pc_dr_id is not null then
      vc_und_drid := fn_get_child_drid(vc_drid,
                                       vc_underlying_instrument_id,
                                       vc_und_delivery_period_id,
                                       pd_avg_wk_start_date,
                                       pd_avg_wk_end_date);
      dbms_output.put_line('child_drid Generated: ' || vc_und_drid);
    end if;
    return vc_drid;
  end f_get_drid;

  ------------------------------------------------------------------------------
  /* Function used to Process the dr id */
  ------------------------------------------------------------------------------
  function f_process_drid(pc_trade_date           in date,
                          pc_instrumentid         in varchar2,
                          pc_price_point_id       in varchar2,
                          pc_delivery_period_id   in varchar2,
                          pc_period_type_id       in varchar2,
                          pc_date                 in date,
                          pc_month                in varchar2,
                          pc_year                 in number,
                          pc_start_date           in date,
                          pc_end_date             in date,
                          pc_strike_price         in number,
                          pc_strike_price_unit_id in varchar2,
                          pd_avg_wk_start_date    in date,
                          pd_avg_wk_end_date      in date) return varchar2 is
    --
    --Variables
    pc_curr_start_date     date;
    pc_curr_end_date       date;
    pc_prompt_date         date;
    pc_curr_date           date;
    pc_curr_month          varchar2(15);
    pc_curr_year           number(4);
    pc_first_notice_date   date;
    pc_last_notice_date    date;
    pc_first_tradable_date date;
    pc_last_tradable_date  date;
    pc_error_code          varchar2(15);
    --Exceptions
    exception_input_missing exception;
    exception_day_not_tradable exception;
    exception_month_not_tradable exception;
    exception_month_not_setup exception;
    exception_day_is_holiday exception;
  begin
    if (pc_delivery_period_id is not null) then
      pc_curr_date           := cr_delivery_period_rec.period_date;
      pc_curr_month          := cr_delivery_period_rec.period_month;
      pc_curr_year           := cr_delivery_period_rec.period_year;
      pc_curr_start_date     := cr_delivery_period_rec.period_start_date;
      pc_curr_end_date       := cr_delivery_period_rec.period_end_date;
      pc_first_notice_date   := cr_delivery_period_rec.first_notice_date;
      pc_last_notice_date    := cr_delivery_period_rec.last_notice_date;
      pc_first_tradable_date := cr_delivery_period_rec.first_trading_date;
      pc_last_tradable_date  := cr_delivery_period_rec.last_trading_date;
    else
      pc_curr_date       := pc_date;
      pc_curr_month      := pc_month;
      pc_curr_year       := pc_year;
      pc_curr_start_date := pc_start_date;
      pc_curr_end_date   := pc_end_date;
      --TODO How to get the FND, LND, FTD, LTD for Auto Mode
    end if;
    /* Run Validations */
    p_validate_data(pc_trade_date,
                    pc_instrumentid,
                    pc_price_point_id,
                    pc_delivery_period_id,
                    pc_period_type_id,
                    pc_curr_date,
                    pc_curr_month,
                    pc_curr_year,
                    pc_curr_start_date,
                    pc_curr_end_date,
                    pc_strike_price,
                    pc_strike_price_unit_id,
                    pc_error_code);
    if (pc_error_code = '-20001') then
      raise exception_input_missing;
    end if;
    if (pc_error_code = '-20002') then
      raise exception_month_not_setup;
    end if;
    if (pc_error_code = '-20003') then
      raise exception_month_not_tradable;
    end if;
    if (pc_error_code = '-20004') then
      raise exception_day_not_tradable;
    end if;
    if (pc_error_code = '-20005') then
      raise exception_day_is_holiday;
    end if;
    if (pc_period_type = 'Day') then
      pc_prompt_date := pc_curr_date;
      pc_dr_id       := f_get_existing_drid(pc_instrumentid,
                                            pc_price_point_id,
                                            pc_curr_date,
                                            null,
                                            null,
                                            pc_curr_start_date,
                                            pc_curr_end_date,
                                            pc_strike_price,
                                            pc_strike_price_unit_id);
    end if;
    if (pc_period_type = 'Month') then
      pc_prompt_date := f_get_prompt_date(pc_delivery_period_id,
                                          pc_curr_month,
                                          pc_curr_year,
                                          null,
                                          null);
      pc_dr_id       := f_get_existing_drid(pc_instrumentid,
                                            pc_price_point_id,
                                            null,
                                            pc_curr_month,
                                            pc_curr_year,
                                            pc_curr_start_date,
                                            pc_curr_end_date,
                                            pc_strike_price,
                                            pc_strike_price_unit_id);
    end if;
    if (pc_period_type = 'Week') then
      if cr_instrument_rec.instrument_type = 'Average' then
        pc_prompt_date := f_get_prompt_date(pc_delivery_period_id,
                                            null,
                                            null,
                                            pd_avg_wk_start_date,
                                            pd_avg_wk_end_date);
      else
        pc_prompt_date := f_get_prompt_date(pc_delivery_period_id,
                                            null,
                                            null,
                                            pc_curr_start_date,
                                            pc_curr_end_date);
      end if;
      pc_dr_id := f_get_existing_drid(pc_instrumentid,
                                      pc_price_point_id,
                                      pc_prompt_date,
                                      null,
                                      null,
                                      pc_curr_start_date,
                                      pc_curr_end_date,
                                      pc_strike_price,
                                      pc_strike_price_unit_id);
    end if;
    /* Generating DRID since it is returned NULL */
    dbms_output.put_line('checking1::' || pc_dr_id);
    if (pc_dr_id is null) then
      /* Generate DRID for the Delevery Period Passed */
      pc_dr_id := f_create_drid(pc_instrumentid,
                                pc_price_point_id,
                                pc_period_type_id,
                                cr_instrument_rec.delivery_calender_id,
                                pc_delivery_period_id,
                                pc_prompt_date,
                                pc_curr_date,
                                pc_curr_month,
                                pc_curr_year,
                                pc_curr_start_date,
                                pc_curr_end_date,
                                pc_strike_price,
                                pc_strike_price_unit_id,
                                pc_first_notice_date,
                                pc_last_notice_date,
                                pc_first_tradable_date,
                                pc_last_tradable_date,
                                pc_last_tradable_date);
    end if;
    return pc_dr_id;
    /* Catching Exceptions */
  exception
    when exception_input_missing then
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      raise_application_error(-20001,
                              'Inputs missing to complete derivative processing');
    when exception_month_not_setup then
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      raise_application_error(-20002,
                              'The selected month is not setup for this instrument');
    when exception_month_not_tradable then
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      raise_application_error(-20003,
                              'The selected Month/Year is not tradable for this instrument');
    when exception_day_not_tradable then
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      raise_application_error(-20004,
                              'The selected day is not tradable for this instrument');
    when exception_day_is_holiday then
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      raise_application_error(-20005,
                              'The selected day is an exchange holiday');
    when others then
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      raise_application_error(-20100,
                              'Error occured in pkg_drid_gen. Msg: ' ||
                              sqlerrm);
  end f_process_drid;

  ------------------------------------------------------------------------------
  /* Function used to generate DRIDs for Quotes */
  ------------------------------------------------------------------------------
  function f_generate_drid_for_quotes(pc_trade_date           in date,
                                      pc_instrumentid         in varchar2,
                                      pc_price_source_id      in varchar2,
                                      pc_strike_price         in number,
                                      pc_strike_price_unit_id in varchar2)
    return varchar2 is
    dridarray                  drid_varray := drid_varray();
    pc_prompt_del_id           varchar2(15);
    pc_start_date              date;
    pc_end_date                date;
    pc_period_from             number(10);
    pc_period_to               number(10);
    pc_equ_period_type         number(5);
    pc_pdc_period_type_id      varchar2(15);
    pc_month_prompt_start_date date;
    pc_varray_count            number(10);
    loop_index                 number(10);
    pc_quote_id                varchar2(15);
    pc_dr_id                   varchar2(15);
    pc_spot_frequency          varchar2(15);
    pc_price_point_type        varchar2(50);
    pc_price_point_applicable  char(1);
    vc_price_source_id         varchar2(15);
    vc_period_type_id          varchar2(15);
    cursor cr_del_period_list is
      select dpd.delivery_period_id
        from dpd_delivery_period_definition dpd
       where dpd.instrument_id = pc_instrumentid
         and dpd.is_deleted = 'N'
         and dpd.is_active = 'Y';
    cursor cr_price_point_list is
      select dipp.price_point_id,
             pp.price_point_name,
             pp.forward_count,
             pp.forward_count_type_id,
             pp.display_order,
             pm.period_type_id,
             pm.period_type_name,
             pm.equivalent_days
        from dip_der_instrument_pricing   dip,
             dipp_der_ins_pricing_prpoint dipp,
             pp_price_point               pp,
             pm_period_master             pm
       where dip.instrument_id = pc_instrumentid
         and dip.price_source_id = vc_price_source_id
         and dip.price_point_type = 'PRICE_POINT'
         and dip.is_deleted = 'N'
         and dip.instrument_pricing_id = dipp.instrument_pricing_id
         and dipp.is_deleted = 'N'
         and dipp.price_point_id = pp.price_point_id
         and pp.is_active = 'Y'
         and pp.is_deleted = 'N'
         and pp.forward_count_type_id = pm.period_type_id
         and pm.is_deleted = 'N'
       order by pp.display_order desc;
    cursor cr_daily_prompt_rule is
      select dpc.*
        from dpc_daily_prompt_calendar dpc
       where dpc.prompt_delivery_calendar_id = pc_prompt_del_id
         and dpc.is_deleted = 'N';
    cursor cr_weekly_prompt_rule is
      select wpc.*
        from wpc_weekly_prompt_calendar wpc
       where wpc.prompt_delivery_calendar_id = pc_prompt_del_id
         and wpc.is_deleted = 'N';
    cursor cr_monthly_prompt_rule is
      select mpc.*
        from mpc_monthly_prompt_calendar mpc
       where mpc.prompt_delivery_calendar_id = pc_prompt_del_id
         and mpc.is_deleted = 'N';
    cursor cr_applicable_months is
      select mpcm.*
        from mpcm_monthly_prompt_cal_month mpcm,
             mnm_month_name_master         mnm
       where mpcm.prompt_delivery_calendar_id = pc_prompt_del_id
         and mpcm.applicable_month = mnm.month_name_id
         and mpcm.is_deleted = 'N'
         and mnm.is_deleted = 'N'
       order by mnm.display_order;
    cr_daily_prompt_rule_rec   cr_daily_prompt_rule%rowtype;
    cr_weekly_prompt_rule_rec  cr_weekly_prompt_rule%rowtype;
    cr_monthly_prompt_rule_rec cr_monthly_prompt_rule%rowtype;
  begin
    pc_price_point_applicable := 'N';
    p_open_instrument_cursor(pc_instrumentid);
    --added by siva on 25-Apr-2011 for Quotes using price source and price points for LME
    --checking, given instument and price source input is applicable for Price Points or not
    vc_price_source_id := pc_price_source_id;
    --vc_price_source_id := 'PS-20';
    begin
      if vc_price_source_id is null then
        pc_price_point_applicable := 'N';
      else
        select dip.price_point_type
          into pc_price_point_type
          from dip_der_instrument_pricing dip
         where dip.instrument_id = pc_instrumentid
           and dip.price_source_id = vc_price_source_id
           and dip.is_deleted = 'N';
        if pc_price_point_type = 'PRICE_POINT' then
          pc_price_point_applicable := 'Y';
        else
          pc_price_point_applicable := 'N';
        end if;
      end if;
    exception
      when no_data_found then
        pc_price_point_applicable := 'N';
      when others then
        pc_price_point_applicable := 'N';
    end;
    --Checking if the instrument is spot
    if (cr_instrument_rec.instrument_type = 'Spot') then
      begin
        select pm.period_type_name
          into pc_spot_frequency
          from pm_period_master pm
         where pm.period_type_id = cr_instrument_rec.spot_frequency
           and pm.is_deleted = 'N';
      end;
      pc_period_type := 'Day';
      if (pc_spot_frequency = 'Month') then
        pc_start_date := to_date(to_char((sysdate -
                                         to_char(pc_trade_date, 'dd') + 1),
                                         'dd-mon-yyyy'));
      else
        pc_start_date := pc_trade_date;
      end if;
      pc_start_date := f_get_next_tradable_day(pc_instrumentid,
                                               pc_start_date);
      pc_dr_id      := f_get_existing_drid(pc_instrumentid,
                                           null,
                                           pc_start_date,
                                           null,
                                           null,
                                           null,
                                           null,
                                           null,
                                           null);
      if (pc_dr_id is null) then
        pc_dr_id := f_create_drid(pc_instrumentid,
                                  null,
                                  'PM-1',
                                  cr_instrument_rec.delivery_calender_id,
                                  null,
                                  pc_start_date,
                                  pc_start_date,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  last_day(pc_start_date)); --TODO
      end if;
      dridarray.extend();
      dridarray(dridarray.count) := pc_dr_id;
    else
      if pc_price_point_applicable = 'N' then
        if (cr_instrument_rec.is_manual_generate = 'Y') then
          /* Manual Generated DR ID*/
          dbms_output.put_line('Quote Generation Starts for Manual ');
          for cr_del_period_list_rec in cr_del_period_list
          loop
            p_open_del_period_cursor(pc_instrumentid,
                                     cr_del_period_list_rec.delivery_period_id);
            pc_dr_id := f_get_drid(pc_trade_date,
                                   pc_instrumentid,
                                   null,
                                   cr_delivery_period_rec.delivery_period_id,
                                   cr_delivery_period_rec.period_type_id,
                                   cr_delivery_period_rec.period_date,
                                   cr_delivery_period_rec.period_month,
                                   cr_delivery_period_rec.period_year,
                                   cr_delivery_period_rec.period_start_date,
                                   cr_delivery_period_rec.period_end_date,
                                   pc_strike_price,
                                   pc_strike_price_unit_id,
                                   null,
                                   null);
            dridarray.extend();
            dridarray(dridarray.count) := pc_dr_id;
            p_close_del_period_cursor;
          end loop;
        else
          /* Auto Generate DR ID*/
          dbms_output.put_line('Quote Generation Starts for Automatic ');
          pc_month_prompt_start_date := pc_trade_date;
          if (cr_instrument_rec.is_daily_cal_applicable = 'Y') then
            dbms_output.put_line('Generating Daily Quotes ');
            begin
              select pm.period_type_id
                into pc_pdc_period_type_id
                from pm_period_master pm
               where pm.period_type_name = 'Day'
                 and pm.is_deleted = 'N';
            end;
            pc_prompt_del_id := cr_instrument_rec.delivery_calender_id;
            open cr_daily_prompt_rule;
            fetch cr_daily_prompt_rule
              into cr_daily_prompt_rule_rec;
            pc_period_from := cr_daily_prompt_rule_rec.period_from;
            pc_period_from := pc_period_from - 1;
            pc_period_to   := cr_daily_prompt_rule_rec.period_to;
            begin
              select pm.equivalent_days
                into pc_equ_period_type
                from pm_period_master pm
               where pm.period_type_id =
                     cr_daily_prompt_rule_rec.period_type_id
                 and pm.is_deleted = 'N';
            end;
            pc_start_date := pc_trade_date +
                             (pc_period_from * pc_equ_period_type);
            pc_end_date   := pc_trade_date +
                             (pc_period_to * pc_equ_period_type);
            if (cr_daily_prompt_rule_rec.valid_till =
               'LAST DAY OF THE MONTH') then
              pc_end_date := last_day(pc_end_date);
            end if;
            pc_start_date := f_get_next_tradable_day(pc_instrumentid,
                                                     pc_start_date);
            pc_end_date   := f_get_next_tradable_day(pc_instrumentid,
                                                     pc_end_date);
            while (pc_start_date <= pc_end_date)
            loop
              pc_dr_id := f_get_drid(pc_trade_date,
                                     pc_instrumentid,
                                     null,
                                     null,
                                     pc_pdc_period_type_id,
                                     pc_start_date,
                                     null,
                                     null,
                                     null,
                                     null,
                                     pc_strike_price,
                                     pc_strike_price_unit_id,
                                     null,
                                     null);
              dridarray.extend();
              dridarray(dridarray.count) := pc_dr_id;
              pc_start_date := pc_start_date + 1;
              pc_start_date := f_get_next_tradable_day(pc_instrumentid,
                                                       pc_start_date);
            end loop;
            pc_month_prompt_start_date := pc_end_date;
            close cr_daily_prompt_rule;
          end if;
          if (cr_instrument_rec.is_weekly_cal_applicable = 'Y') then
            dbms_output.put_line('Generating Weekly Quotes ');
            begin
              select pm.period_type_id
                into pc_pdc_period_type_id
                from pm_period_master pm
               where pm.period_type_name = 'Week'
                 and pm.is_deleted = 'N';
            end;
            pc_prompt_del_id := cr_instrument_rec.delivery_calender_id;
            open cr_weekly_prompt_rule;
            fetch cr_weekly_prompt_rule
              into cr_weekly_prompt_rule_rec;
            pc_period_from := cr_weekly_prompt_rule_rec.period_from;
            pc_period_to   := cr_weekly_prompt_rule_rec.period_to;
            begin
              select pm.equivalent_days
                into pc_equ_period_type
                from pm_period_master pm
               where pm.period_type_id =
                     cr_weekly_prompt_rule_rec.period_type_id
                 and pm.is_deleted = 'N';
            end;
            pc_start_date := pc_trade_date +
                             (pc_period_from * pc_equ_period_type);
            pc_end_date   := pc_trade_date +
                             (pc_period_to * pc_equ_period_type);
            if (cr_weekly_prompt_rule_rec.valid_till =
               'LAST DAY OF THE MONTH') then
              pc_end_date := last_day(pc_end_date);
            end if;
            while (pc_start_date <= pc_end_date)
            loop
              pc_dr_id := f_get_drid(pc_trade_date,
                                     pc_instrumentid,
                                     null,
                                     null,
                                     pc_pdc_period_type_id,
                                     null,
                                     null,
                                     null,
                                     pc_start_date,
                                     (pc_start_date + 7),
                                     pc_strike_price,
                                     pc_strike_price_unit_id,
                                     null,
                                     null);
              dridarray.extend();
              dridarray(dridarray.count) := pc_dr_id;
              pc_start_date := (pc_start_date + 7) + 1;
            end loop;
            pc_month_prompt_start_date := pc_end_date;
            close cr_weekly_prompt_rule;
          end if;
          if (cr_instrument_rec.is_monthly_cal_applicable = 'Y') then
            dbms_output.put_line('Generating Monthly Quotes ');
            begin
              select pm.period_type_id
                into pc_pdc_period_type_id
                from pm_period_master pm
               where pm.period_type_name = 'Month'
                 and pm.is_deleted = 'N';
            end;
            pc_prompt_del_id := cr_instrument_rec.delivery_calender_id;
            --  dbms_output.put_line('pc_prompt_del_id ' || pc_prompt_del_id);
            open cr_monthly_prompt_rule;
            fetch cr_monthly_prompt_rule
              into cr_monthly_prompt_rule_rec;
            pc_period_to := cr_monthly_prompt_rule_rec.period_for;
            --  dbms_output.put_line('pc_period_to ' || pc_period_to);
            begin
              select pm.equivalent_days
                into pc_equ_period_type
                from pm_period_master pm
               where pm.period_type_id =
                     cr_monthly_prompt_rule_rec.period_type_id
                 and pm.is_deleted = 'N';
            end;
            pc_start_date := pc_month_prompt_start_date;
            --  dbms_output.put_line('pc_start_date ' || pc_start_date);
            pc_end_date := pc_month_prompt_start_date +
                           (pc_period_to * pc_equ_period_type);
            --   dbms_output.put_line('pc_end_date ' || pc_end_date);
            for cr_applicable_months_rec in cr_applicable_months
            loop
              pc_month_prompt_start_date := to_date(('01-' ||
                                                    cr_applicable_months_rec.applicable_month || '-' ||
                                                    to_char(pc_start_date,
                                                             'YYYY')),
                                                    'dd/mm/yyyy');
              loop
                if (pc_month_prompt_start_date >=
                   to_date(('01-' || to_char(pc_start_date, 'Mon-YYYY')),
                            'dd/mm/yyyy') and
                   pc_month_prompt_start_date <= pc_end_date) then
                  pc_dr_id := f_get_drid(pc_trade_date,
                                         pc_instrumentid,
                                         null,
                                         null,
                                         pc_pdc_period_type_id,
                                         null,
                                         to_char(pc_month_prompt_start_date,
                                                 'Mon'),
                                         to_char(pc_month_prompt_start_date,
                                                 'YYYY'),
                                         null,
                                         null,
                                         pc_strike_price,
                                         pc_strike_price_unit_id,
                                         null,
                                         null);
                  dridarray.extend();
                  dridarray(dridarray.count) := pc_dr_id;
                end if;
                pc_month_prompt_start_date := add_months(pc_month_prompt_start_date,
                                                         12);
                exit when pc_month_prompt_start_date > pc_end_date;
              end loop;
            end loop;
            close cr_monthly_prompt_rule;
          end if;
        end if;
      else
        --Generage DRID using price points, for price points day,month, weeks are not applicable,
        -- these are just point(text), we no need to generate promt date for this.
        --quotes has to be entered every day using old DRID's which created at first time
        for cr_pp in cr_price_point_list
        loop
          pc_start_date := pc_trade_date;
          begin
            select pm.period_type_name,
                   pm.period_type_id
              into pc_period_type,
                   vc_period_type_id
              from pm_period_master pm
             where upper(pm.period_type_name) = 'CUSTOM'
               and pm.is_active = 'Y'
               and pm.is_deleted = 'N';
          exception
            when no_data_found then
              pc_period_type    := 'Custom';
              vc_period_type_id := 'PM-6';
          end;
          if pc_period_type = 'Custom' then
            pc_start_date := pc_trade_date;
            pc_start_date := f_get_next_tradable_day(pc_instrumentid,
                                                     pc_start_date);
            pc_dr_id      := f_get_existing_drid(pc_instrumentid,
                                                 cr_pp.price_point_id,
                                                 pc_start_date,
                                                 null,
                                                 null,
                                                 null,
                                                 null,
                                                 null,
                                                 null);
            if (pc_dr_id is null) then
              pc_dr_id := f_create_drid(pc_instrumentid,
                                        cr_pp.price_point_id,
                                        vc_period_type_id,
                                        cr_instrument_rec.delivery_calender_id,
                                        null,
                                        pc_start_date,
                                        pc_start_date,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        last_day(pc_start_date)); --TODO
            end if;
            dridarray.extend();
            dridarray(dridarray.count) := pc_dr_id;
          end if;
          if pc_period_type = 'Day' then
            pc_start_date := pc_trade_date +
                             (cr_pp.forward_count * cr_pp.equivalent_days);
            pc_start_date := f_get_next_tradable_day(pc_instrumentid,
                                                     pc_start_date);
            pc_dr_id      := f_get_existing_drid(pc_instrumentid,
                                                 cr_pp.price_point_id,
                                                 pc_start_date,
                                                 null,
                                                 null,
                                                 null,
                                                 null,
                                                 null,
                                                 null);
            if (pc_dr_id is null) then
              pc_dr_id := f_create_drid(pc_instrumentid,
                                        cr_pp.price_point_id,
                                        'PM-1',
                                        cr_instrument_rec.delivery_calender_id,
                                        null,
                                        pc_start_date,
                                        pc_start_date,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        null,
                                        last_day(pc_start_date)); --TODO
            end if;
            dridarray.extend();
            dridarray(dridarray.count) := pc_dr_id;
          end if;
          if pc_period_type = 'Month' then
            pc_pdc_period_type_id := cr_pp.period_type_id;
            pc_prompt_del_id      := cr_instrument_rec.delivery_calender_id;
            pc_start_date         := pc_trade_date + (cr_pp.forward_count *
                                     cr_pp.equivalent_days);
            pc_end_date           := pc_start_date;
            pc_dr_id              := f_get_drid(pc_trade_date,
                                                pc_instrumentid,
                                                cr_pp.price_point_id,
                                                null,
                                                pc_pdc_period_type_id,
                                                null,
                                                to_char(pc_start_date, 'Mon'),
                                                to_char(pc_start_date,
                                                        'YYYY'),
                                                null,
                                                null,
                                                null,
                                                null,
                                                null,
                                                null);
            dridarray.extend();
            dridarray(dridarray.count) := pc_dr_id;
          end if;
        end loop;
      end if;
    end if;
    p_close_instrument_cursor;
    /* Inserting to the Quotes Table */
    delete x_quotes_drid;
    select seq_quote_drid.nextval into pc_quote_id from dual;
    pc_quote_id := 'DQ-DR-' || pc_quote_id;
    dbms_output.put_line('pc_quote_id ' || pc_quote_id);
    pc_varray_count := dridarray.count;
    loop_index      := 0;
    while (loop_index < pc_varray_count)
    loop
      loop_index := loop_index + 1;
      dridarray.extend();
      pc_dr_id := dridarray(loop_index);
      dbms_output.put_line('DrID Array for ' || loop_index || ': ' ||
                           pc_dr_id);
      insert into x_quotes_drid
      values
        (pc_quote_id, pc_dr_id, systimestamp);
    end loop;
    return pc_quote_id;
  end f_generate_drid_for_quotes;

  ------------------------------------------------------------------------------
  /* Private Function used to create the DR-ID */
  ------------------------------------------------------------------------------
  function f_create_drid(pc_instrument_id               in varchar2,
                         pc_price_point_id              in varchar2,
                         pc_period_type_id              in varchar2,
                         pc_prompt_delivery_calendar_id in varchar2,
                         pc_delivery_period_id          in varchar2,
                         pc_prompt_date                 in date,
                         pc_period_date                 in date,
                         pc_period_month                in varchar2,
                         pc_period_year                 in number,
                         pc_period_start_date           in date,
                         pc_period_end_date             in date,
                         pc_strike_price                in number,
                         pc_strike_price_unit_id        in varchar2,
                         pc_first_notice_date           in date,
                         pc_last_notice_date            in date,
                         pc_first_tradable_date         in date,
                         pc_last_tradable_date          in date,
                         pc_expiry_date                 in date)
    return varchar2 is
    pc_drid_name        varchar2(30);
    pc_drid             varchar2(15);
    pc_drid_seq         varchar2(15);
    pc_price_point_name varchar2(50);
  begin
    /* Generate DRID */
    select seq_drm.nextval into pc_drid_seq from dual;
    pc_drid := 'DR-' || pc_drid_seq;
    /* Get price point name */
    begin
      select pp.price_point_name
        into pc_price_point_name
        from pp_price_point pp
       where pp.price_point_id = pc_price_point_id
         and pp.is_deleted = 'N';
    exception
      when no_data_found then
        pc_price_point_name := '';
      when others then
        pc_price_point_name := '';
    end;
    if (pc_delivery_period_id is null) then
      if (pc_period_type = 'Day') then
        pc_drid_name := to_char(pc_period_date, 'dd-Mon-YYYY');
      end if;
      if (pc_period_type = 'Month') then
        pc_drid_name := pc_period_month || '-' || pc_period_year;
      end if;
      if (pc_period_type = 'Year') then
        pc_drid_name := pc_period_year;
      end if;
      if (pc_period_type = 'Week' or pc_period_type = 'Quarter' or
         pc_period_type = 'Season' or pc_period_type = 'Custom' or
         pc_period_type = 'Average') then
        pc_drid_name := to_char(pc_prompt_date, 'dd-Mon-YYYY');
      end if;
      if pc_price_point_id is not null and pc_period_type = 'Custom' then
        pc_drid_name := pc_price_point_name;
      else
        pc_drid_name := pc_drid_name;
      end if;
    else
      pc_drid_name := cr_delivery_period_rec.delivery_period_name;
    end if;
    insert into drm_derivative_master
      (dr_id,
       dr_id_name,
       instrument_id,
       price_point_id,
       period_type_id,
       prompt_delivery_calendar_id,
       delivery_period_id,
       prompt_date,
       period_date,
       period_month,
       period_year,
       period_start_date,
       period_end_date,
       strike_price,
       strike_price_unit_id,
       first_notice_date,
       last_notice_date,
       first_tradable_date,
       last_tradable_date,
       expiry_date,
       created_date,
       is_expired,
       is_deleted)
    values
      (pc_drid,
       pc_drid_name,
       pc_instrument_id,
       pc_price_point_id,
       pc_period_type_id,
       pc_prompt_delivery_calendar_id,
       pc_delivery_period_id,
       pc_prompt_date,
       pc_period_date,
       pc_period_month,
       pc_period_year,
       pc_period_start_date,
       pc_period_end_date,
       pc_strike_price,
       pc_strike_price_unit_id,
       pc_first_notice_date,
       pc_last_notice_date,
       pc_first_tradable_date,
       pc_last_tradable_date,
       pc_expiry_date,
       systimestamp,
       'N',
       'N');
    return pc_drid;
  end f_create_drid;

  ------------------------------------------------------------------------------
  /* Private Function used to get existing DR-ID for a given Period Type */
  ------------------------------------------------------------------------------
  function f_get_existing_drid(pc_instrument_id        in varchar2,
                               pc_price_point_id       in varchar2,
                               pc_date                 in date,
                               pc_period_month         in varchar2,
                               pc_period_year          in number,
                               pc_start_date           in date,
                               pc_end_date             in date,
                               pc_strike_price         in number,
                               pc_strike_price_unit_id in varchar2)
    return varchar2 is
    pc_drid varchar2(15);
  begin
    if cr_instrument_rec.instrument_type = 'Average' then
      if (pc_period_type = 'Day') then
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm,
                 pm_period_master      pm
           where drm.instrument_id = pc_instrument_id
             and drm.period_type_id = pm.period_type_id
             and pm.period_type_name = pc_period_type
             and drm.price_point_id = pc_price_point_id
             and drm.period_start_date = pc_start_date
             and drm.period_end_date = pc_end_date
             and drm.period_date = pc_date
             and drm.is_deleted = 'N'
             and pm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;
      end if;
      if (pc_period_type = 'Month') then
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm,
                 pm_period_master      pm
           where drm.instrument_id = pc_instrument_id
             and drm.period_type_id = pm.period_type_id
             and pm.period_type_name = pc_period_type
             and drm.price_point_id = pc_price_point_id
             and drm.period_start_date = pc_start_date
             and drm.period_end_date = pc_end_date
             and drm.period_month = pc_period_month
             and drm.period_year = pc_period_year
             and drm.is_deleted = 'N'
             and pm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;
      end if;
      if (pc_period_type = 'Week') then
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm,
                 pm_period_master      pm
           where drm.instrument_id = pc_instrument_id
             and drm.period_type_id = pm.period_type_id
             and pm.period_type_name = pc_period_type
             and drm.period_start_date = pc_start_date
             and drm.period_end_date = pc_end_date
             and drm.price_point_id = pc_price_point_id
             and drm.prompt_date = pc_date
             and drm.is_deleted = 'N'
             and pm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;
      end if;
    elsif cr_instrument_rec.instrument_type in
          ('Option Put', 'Option Call') then
      if (pc_period_type = 'Day') then
      
      if(pc_strike_price_unit_id is null or pc_strike_price_unit_id <> '') then
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm,
                 pm_period_master      pm
           where drm.instrument_id = pc_instrument_id
             and drm.period_type_id = pm.period_type_id
             and pm.period_type_name = pc_period_type
             and drm.price_point_id is null
             and drm.strike_price = pc_strike_price
             and drm.period_date = pc_date
             and drm.is_deleted = 'N'
             and pm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;
        else
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm,
                 pm_period_master      pm
           where drm.instrument_id = pc_instrument_id
             and drm.period_type_id = pm.period_type_id
             and pm.period_type_name = pc_period_type
             and drm.price_point_id is null
             and drm.strike_price = pc_strike_price
             and drm.strike_price_unit_id = pc_strike_price_unit_id
             and drm.period_date = pc_date
             and drm.is_deleted = 'N'
             and pm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;        
        end if;
      end if;
      if (pc_period_type = 'Month') then
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm,
                 pm_period_master      pm
           where drm.instrument_id = pc_instrument_id
             and drm.period_type_id = pm.period_type_id
             and pm.period_type_name = pc_period_type
             and drm.price_point_id is null
             and drm.strike_price = pc_strike_price
             and drm.strike_price_unit_id = pc_strike_price_unit_id
             and drm.period_month = pc_period_month
             and drm.period_year = pc_period_year
             and drm.is_deleted = 'N'
             and pm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;
      end if;
      if (pc_period_type = 'Week') then
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm,
                 pm_period_master      pm
           where drm.instrument_id = pc_instrument_id
             and drm.period_type_id = pm.period_type_id
             and pm.period_type_name = pc_period_type
             and drm.strike_price = pc_strike_price
             and drm.strike_price_unit_id = pc_strike_price_unit_id
             and drm.price_point_id is null
             and drm.prompt_date = pc_date
             and drm.is_deleted = 'N'
             and pm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;
      end if;
    else
      if pc_price_point_id is null then
        if (pc_period_type = 'Day') then
          begin
            select drm.dr_id
              into pc_drid
              from drm_derivative_master drm,
                   pm_period_master      pm
             where drm.instrument_id = pc_instrument_id
               and drm.period_type_id = pm.period_type_id
               and pm.period_type_name = pc_period_type
               and drm.price_point_id is null
               and drm.period_date = pc_date
               and drm.is_deleted = 'N'
               and pm.is_deleted = 'N';
          exception
            when no_data_found then
              pc_drid := null;
          end;
        end if;
        if (pc_period_type = 'Month') then
          begin
            select drm.dr_id
              into pc_drid
              from drm_derivative_master drm,
                   pm_period_master      pm
             where drm.instrument_id = pc_instrument_id
               and drm.period_type_id = pm.period_type_id
               and pm.period_type_name = pc_period_type
               and drm.price_point_id is null
               and drm.period_month = pc_period_month
               and drm.period_year = pc_period_year
               and drm.is_deleted = 'N'
               and pm.is_deleted = 'N';
               dbms_output.put_line('args here in fgetting dr_id:::'||pc_instrument_id || ' ' ||pc_period_type 
               || '  ' || pc_period_month || '  ' ||pc_period_year);
          exception
            when no_data_found then
              pc_drid := null;
          end;
        end if;
        if (pc_period_type = 'Week') then
          begin
            select drm.dr_id
              into pc_drid
              from drm_derivative_master drm,
                   pm_period_master      pm
             where drm.instrument_id = pc_instrument_id
               and drm.period_type_id = pm.period_type_id
               and pm.period_type_name = pc_period_type
               and drm.price_point_id is null
               and drm.prompt_date = pc_date
               and drm.is_deleted = 'N'
               and pm.is_deleted = 'N';
          exception
            when no_data_found then
              pc_drid := null;
          end;
        end if;
      else
        -- get DRID using price points
        begin
          select drm.dr_id
            into pc_drid
            from drm_derivative_master drm
           where drm.instrument_id = pc_instrument_id -- this instumnet should be future only
             and drm.price_point_id = pc_price_point_id
             and drm.is_deleted = 'N';
        exception
          when no_data_found then
            pc_drid := null;
        end;
        -- end if;
      end if;
    end if;
    return pc_drid;
  end f_get_existing_drid;

  function f_get_prompt_date(pc_delivery_period_id in varchar2,
                             pc_month              in varchar2,
                             pc_year               in number,
                             pc_start_date         in date,
                             pc_end_date           in date) return date is
    pc_prompt_date      date;
    pc_day_of_the_month number(2);
    pc_day_order        varchar2(15);
    pc_prompt_day       varchar2(15);
    pc_month_year       varchar2(15);
    pc_day_order_number number(1);
    workings_days       number;
    pd_date             date;
  begin
    if (pc_delivery_period_id is not null) then
      if (cr_instrument_rec.prompt_date_defn = 'First Notice Date' or
         cr_instrument_rec.prompt_date_defn = 'First_Notice_Date') then
        pc_prompt_date := cr_delivery_period_rec.first_notice_date +
                          nvl(cr_instrument_rec.prompt_days, 0);
      end if;
      if (cr_instrument_rec.prompt_date_defn = 'Last Notice Date' or
         cr_instrument_rec.prompt_date_defn = 'Last_Notice_Date') then
        pc_prompt_date := cr_delivery_period_rec.last_notice_date +
                          nvl(cr_instrument_rec.prompt_days, 0);
      end if;
      if (cr_instrument_rec.prompt_date_defn = 'Last Trading Date' or
         cr_instrument_rec.prompt_date_defn = 'Last_Trading_Date') then
        pc_prompt_date := cr_delivery_period_rec.last_trading_date +
                          nvl(cr_instrument_rec.prompt_days, 0);
      end if;
    else
      if (pc_period_type = 'Month') then
        begin
          pc_month_year := '01-' || pc_month || '-' || pc_year;
          pd_date:=pc_month_year;
          select mpc.day_of_the_month,
                 mpc.day_order,
                 mpc.prompt_day
            into pc_day_of_the_month,
                 pc_day_order,
                 pc_prompt_day
            from mpc_monthly_prompt_calendar mpc
           where mpc.prompt_delivery_calendar_id =
                 cr_instrument_rec.delivery_calender_id
             and mpc.is_deleted = 'N';
        
          if (pc_day_of_the_month is not null) then
            begin
              select to_date(pc_month_year, 'dd-Mon-YYYY') +
                     (pc_day_of_the_month - 1)
                into pc_prompt_date
                from dual;
            end;
          else
            if pc_prompt_day <> 'BD' then
              if (pc_day_order = 'First') then
                pc_day_order_number := 1;
              end if;
              if (pc_day_order = 'Second') then
                pc_day_order_number := 2;
              end if;
              if (pc_day_order = 'Third') then
                pc_day_order_number := 3;
              end if;
              if (pc_day_order = 'Fourth') then
                pc_day_order_number := 4;
              end if;
              select f_get_next_day(to_date(pc_month_year, 'dd-Mon-YYYY'),
                                    upper(substr(pc_prompt_day, 1, 3)),
                                    pc_day_order_number)
                into pc_prompt_date
                from dual;
            else
            
             if (pc_day_order = 'First') then
                pc_day_order_number := 1;
              end if;
              if (pc_day_order = 'Second') then
                pc_day_order_number := 2;
              end if;
              if (pc_day_order = 'Third') then
                pc_day_order_number := 3;
              end if;
              if (pc_day_order = 'Fourth') then
                pc_day_order_number := 4;
              end if;
              if (pc_day_order_number <=4) then
                workings_days := 0;
                while workings_days <> pc_day_order_number
                loop
                  if f_is_day_holiday(cr_instrument_rec.instrument_id,
                                      pd_date) then
                    pd_date := pd_date + 1;
                  else
                    workings_days := workings_days + 1;
                    if workings_days <> pc_day_order_number then
                      pd_date := pd_date + 1;
                    end if;
                  end if;
                end loop;
                pc_prompt_date := pd_date;
              end if;
            
              if (pc_day_order = 'Last') then
                pd_date := last_day(pd_date);
                while true
                loop
                  if f_is_day_holiday(cr_instrument_rec.instrument_id,
                                      pd_date) then
                    pd_date := pd_date - 1;
                  else
                    exit;
                  end if;
                end loop;
                pc_prompt_date := pd_date;
              else
               pd_date := last_day(pd_date);
                while true
                loop
                  if f_is_day_holiday(cr_instrument_rec.instrument_id,
                                      pd_date) then
                    pd_date := pd_date - 1;
                  else
                    exit;
                  end if;
                end loop;
                pc_prompt_date := pd_date;
              end if;
            
            end if;
          
          end if;
        end;
      end if;
    
      if (pc_period_type = 'Week') then
        begin
          select wpc.prompt_day
            into pc_prompt_day
            from wpc_weekly_prompt_calendar wpc
           where wpc.prompt_delivery_calendar_id =
                 cr_instrument_rec.delivery_calender_id
             and wpc.is_deleted = 'N';
          pc_day_order_number := 1;
          loop
            select f_get_next_day(pc_start_date,
                                  upper(substr(pc_prompt_day, 1, 3)),
                                  pc_day_order_number)
              into pc_prompt_date
              from dual;
            if (pc_prompt_date >= pc_start_date and
               pc_prompt_date <= pc_end_date) then
              pc_day_order_number := -1;
            else
              if (pc_day_order_number = 4) then
                pc_day_order_number := -1;
              else
                pc_day_order_number := pc_day_order_number + 1;
              end if;
            end if;
            exit when pc_day_order_number < 0;
          end loop;
        end;
      end if;
    end if;
    pc_prompt_date := f_get_next_tradable_day(cr_instrument_rec.instrument_id,
                                              pc_prompt_date);
    return pc_prompt_date;
  end f_get_prompt_date;

  ------------------------------------------------------------------------------
  /* Private Procedure used to validate the inputs */
  ------------------------------------------------------------------------------
  procedure p_validate_data(pc_trade_date           in date,
                            pc_instrumentid         in varchar2,
                            pc_price_point_id       in varchar2,
                            pc_delivery_period_id   in varchar2,
                            pc_period_type_id       in varchar2,
                            pc_date                 in date,
                            pc_month                in varchar2,
                            pc_year                 in number,
                            pc_start_date           in date,
                            pc_end_date             in date,
                            pc_strike_price         in number,
                            pc_strike_price_unit_id in varchar2,
                            pc_error_code           out varchar2) is
    --Variables
    pc_day_difference number(10);
    pc_app_month      varchar2(10);
    pc_month_year     varchar2(30);
  begin
    /* Validating Inputs */
    if (pc_trade_date is null or pc_instrumentid is null or
       pc_period_type_id is null) then
      pc_error_code := '-20001';
      return;
    end if;
    if (f_is_day_holiday(pc_instrumentid, pc_trade_date)) then
      pc_error_code := '-20005';
      return;
    end if;
    if (pc_period_type = 'Day') then
      if (pc_delivery_period_id is null and pc_date is null) then
        pc_error_code := '-20001';
        return;
      end if;
      begin
        select to_date(pc_date, 'dd-Mon-YYYY') -
               (pc_trade_date + dpc.period_to)
          into pc_day_difference
          from dpc_daily_prompt_calendar dpc,
               dim_der_instrument_master dim
         where dpc.prompt_delivery_calendar_id = dim.delivery_calender_id
           and dim.instrument_id = pc_instrumentid
           and dpc.is_deleted = 'N'
           and dim.is_deleted = 'N';
        if (pc_day_difference > 0) then
          pc_error_code := '-20004';
          return;
        end if;
      end;
    end if;
    if (pc_period_type = 'Month') then
      if (pc_delivery_period_id is null and
         (pc_month is null or pc_year is null)) then
        pc_error_code := '-20001';
        return;
      end if;
      /* Checking if the month is valid */
      begin
        select mpcm.applicable_month
          into pc_app_month
          from mpcm_monthly_prompt_cal_month mpcm,
               dim_der_instrument_master     dim
         where mpcm.prompt_delivery_calendar_id = dim.delivery_calender_id
           and dim.instrument_id = pc_instrumentid
           and mpcm.applicable_month = pc_month
           and mpcm.is_deleted = 'N'
           and dim.is_deleted = 'N';
      exception
        when no_data_found then
          pc_error_code := '-20002';
          return;
      end;
      begin
        pc_month_year := '01-' || pc_month || '-' || pc_year;
        dbms_output.put_line('pc_month_year : ' || pc_month_year);
        select to_date(pc_month_year, 'dd-Mon-YYYY') -
               add_months(pc_trade_date, mpc.period_for)
          into pc_day_difference
          from mpc_monthly_prompt_calendar mpc,
               dim_der_instrument_master   dim
         where mpc.prompt_delivery_calendar_id = dim.delivery_calender_id
           and dim.instrument_id = pc_instrumentid
           and mpc.is_deleted = 'N'
           and dim.is_deleted = 'N';
        if (pc_day_difference > 0) then
          --TODO Checking forward count when called from Quotes
          -- RAISE exception_month_not_tradable;
          pc_month_year := '01-' || pc_month || '-' || pc_year;
        end if;
      end;
    end if;
    if cr_instrument_rec.instrument_type in ('Option Put', 'Option Call') then
      if (pc_strike_price is null) then
        pc_error_code := '-20001';
        return;
      end if;
    end if;
  exception
    when others then
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      raise_application_error(-20099,
                              'Error occured in pkg_drid_gen. Msg: ' ||
                              sqlerrm);
  end p_validate_data;

  ------------------------------------------------------------------------------
  /*   Private function to check if a date is holiday */
  ------------------------------------------------------------------------------
  function f_is_day_holiday(pc_instrumentid in varchar2,
                            pc_trade_date   date) return boolean is
    pc_counter number(1);
    result_val boolean;
  begin
    --Checking the Week End Holiday List
    begin
      select count(*)
        into pc_counter
        from dual
       where to_char(pc_trade_date, 'Dy') in
             (select clwh.holiday
                from dim_der_instrument_master    dim,
                     clm_calendar_master          clm,
                     clwh_calendar_weekly_holiday clwh
               where dim.holiday_calender_id = clm.calendar_id
                 and clm.calendar_id = clwh.calendar_id
                 and dim.instrument_id = pc_instrumentid
                 and clm.is_deleted = 'N'
                 and clwh.is_deleted = 'N'
                 and dim.is_deleted = 'N');
      if (pc_counter = 1) then
        result_val := true;
      else
        result_val := false;
      end if;
      if (result_val = false) then
        --Checking Other Holiday List
        select count(*)
          into pc_counter
          from dual
         where trim(pc_trade_date) in
               (select trim(hl.holiday_date)
                  from hm_holiday_master         hm,
                       hl_holiday_list           hl,
                       dim_der_instrument_master dim,
                       clm_calendar_master       clm
                 where hm.holiday_id = hl.holiday_id
                   and dim.holiday_calender_id = clm.calendar_id
                   and clm.calendar_id = hm.calendar_id
                   and dim.instrument_id = pc_instrumentid
                   and hm.is_deleted = 'N'
                   and hl.is_deleted = 'N'
                   and dim.is_deleted = 'N'
                   and clm.is_deleted = 'N');
        if (pc_counter = 1) then
          result_val := true;
        else
          result_val := false;
        end if;
      end if;
    end;
    return result_val;
  end f_is_day_holiday;

  ------------------------------------------------------------------------------
  /* Private function to return a tradable day for a given date */
  ------------------------------------------------------------------------------
  function f_get_next_tradable_day(pc_instrumentid in varchar2,
                                   pc_date         date) return date is
    pc_next_tradable_day date;
    is_valid_date        boolean := true;
  begin
    pc_next_tradable_day := pc_date;
    if (f_is_day_holiday(pc_instrumentid, pc_date)) then
      while (is_valid_date = true)
      loop
        pc_next_tradable_day := pc_next_tradable_day + 1;
        if (f_is_day_holiday(pc_instrumentid, pc_next_tradable_day)) then
          is_valid_date := true;
        else
          is_valid_date := false;
        end if;
      end loop;
    end if;
    return pc_next_tradable_day;
  end f_get_next_tradable_day;

  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  function f_get_next_day(p_date     in date,
                          p_day      in varchar2,
                          p_position in number) return date is
    v_position_date      date;
    v_next_position      number;
    v_start_day          varchar2(10);
    v_first_day_position date;
  begin
    begin
      v_next_position := (p_position - 1) * 7;
      v_start_day     := to_char(to_date('01-' ||
                                         to_char(trunc(p_date), 'mon-yyyy'),
                                         'dd-mon-yyyy'),
                                 'dy');
      if upper(trim(v_start_day)) = upper(trim(p_day)) then
        v_first_day_position := to_date('01-' ||
                                        to_char(trunc(p_date), 'mon-yyyy'),
                                        'dd-mon-yyyy');
      else
        v_first_day_position := next_day(to_date('01-' ||
                                                 to_char(p_date, 'mon-yyyy'),
                                                 'dd-mon-yyyy'),
                                         trim(p_day));
      end if;
      if v_next_position <= 1 then
        v_position_date := trunc(v_first_day_position);
      else
        v_position_date := trunc(v_first_day_position) + v_next_position;
      end if;
    exception
      when no_data_found then
        return null;
      when others then
        return null;
    end;
    return v_position_date;
  end f_get_next_day;

  ------------------------------------------------------------------------------
  /* Private Procedure to Open Instrument Cursor */
  ------------------------------------------------------------------------------
  procedure p_open_instrument_cursor(pc_instrumentid in varchar2) is
  begin
    if not cr_instrument%isopen then
      pc_instr_id := pc_instrumentid;
      open cr_instrument;
      fetch cr_instrument
        into cr_instrument_rec;
   end if;
  end p_open_instrument_cursor;

  ------------------------------------------------------------------------------
  /* Private Procedure to Close Instrument Cursor */
  ------------------------------------------------------------------------------
  procedure p_close_instrument_cursor is
  begin
    if cr_instrument%isopen then
      close cr_instrument;
    end if;
  end p_close_instrument_cursor;

  ------------------------------------------------------------------------------
  /* Private Procedure to Open Delivery Period Cursor */
  ------------------------------------------------------------------------------
  procedure p_open_del_period_cursor(pc_instrumentid       in varchar2,
                                     pc_delivery_period_id in varchar2) is
  begin
    if not cr_delivery_period%isopen then
      pc_instr_id      := pc_instrumentid;
      pc_del_period_id := pc_delivery_period_id;
      open cr_delivery_period;
      fetch cr_delivery_period
        into cr_delivery_period_rec;
    end if;
  end p_open_del_period_cursor;

  ------------------------------------------------------------------------------
  /* Private Procedure to Close Delivery Period Cursor */
  ------------------------------------------------------------------------------
  procedure p_close_del_period_cursor is
  begin
    if cr_delivery_period%isopen then
      close cr_delivery_period;
    end if;
  end p_close_del_period_cursor;

  --
  function fn_get_child_drid(pc_drid                    in varchar2,
                             pc_underlying_instrumentid in varchar2,
                             pc_und_delivery_period_id  in varchar2,
                             pd_avg_wk_start_date       in date,
                             pd_avg_wk_end_date         in date)
    return varchar2 is
    vc_drid               varchar2(15);
    vc_child_drid         varchar2(15);
    vc_month              varchar2(5);
    vn_year               number;
    vc_period_type_id     varchar2(30);
    vc_calendar_id        varchar2(15);
    vd_und_prompt_date    date;
    vf_child_drid         varchar2(10) := 'Y';
    vc_delivery_period_id varchar2(15);
  begin
    dbms_output.put_line('fn_get_child_drid generation process starting...');
    vc_drid               := pc_drid;
    vc_delivery_period_id := pc_und_delivery_period_id;
    begin
      --Checking if the child dr id already exist
      select du.underlying_dr_id
        into vc_child_drid
        from du_derivative_underlying du
       where du.dr_id = vc_drid; --options/average drid
    exception
      when no_data_found then
        vf_child_drid := 'N';
    end;
    if vf_child_drid = 'N' then
      select nvl(drm.period_month, to_char(drm.prompt_date, 'Mon')),
             nvl(drm.period_year, to_char(drm.prompt_date, 'yyyy')),
             drm.prompt_delivery_calendar_id,
             drm.prompt_date,
             pm.period_type_id,
             pm.period_type_name
        into vc_month,
             vn_year,
             vc_calendar_id,
             vd_und_prompt_date,
             vc_period_type_id,
             pc_period_type
        from drm_derivative_master drm,
             pm_period_master      pm
       where drm.dr_id = vc_drid
         and drm.period_type_id = pm.period_type_id
         and drm.is_deleted = 'N'
         and pm.is_deleted = 'N';
      if pc_period_type = 'Day' then
        vc_month := null;
        vn_year  := null;
      end if;
      /* Opening the Instrument Cursor */
      p_open_instrument_cursor(pc_underlying_instrumentid);
      /* Opening the Delivery Period Cursor */
      p_open_del_period_cursor(pc_underlying_instrumentid,
                               vc_delivery_period_id);
      /** Process DR-ID **/
      vc_child_drid := f_process_drid(vd_und_prompt_date,
                                      pc_underlying_instrumentid,
                                      null,
                                      vc_delivery_period_id,
                                      vc_period_type_id,
                                      vd_und_prompt_date,
                                      vc_month,
                                      vn_year,
                                      pd_avg_wk_start_date,
                                      pd_avg_wk_end_date,
                                      null,
                                      null,
                                      null,
                                      null);
      /* Closing the Instrument Cursor */
      p_close_instrument_cursor;
      /* Closing the Delivery Period Cursor */
      p_close_del_period_cursor;
      if pc_drid is not null and vc_child_drid is not null then
        begin
          insert into du_derivative_underlying
            (dr_id, underlying_dr_id)
          values
            (vc_drid, vc_child_drid);
        end;
      end if;
    end if;
    -- end;
    dbms_output.put_line('f_get_child_drId generation process ending...' ||
                         vc_child_drid);
    return vc_child_drid;
  end fn_get_child_drid;

end pkg_drid_generator;
/
/* Formatted on 2012/06/01 15:56 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW V_CDC_BANK_FX_RATES AS
SELECT c.cfq_id, c.corporate_id, c.trade_date, c.instrument_id,
          c.price_source_id, c.created_date, c.updated_date, c.VERSION,
          c.is_deleted, cfqd.cfqd_id, cfqd.dr_id, cfqd.rate,
          cfqd.forward_point, cfqd.is_spot, cfqd.is_deleted cfqd_is_deleted
           , pdm.base_cur_id , pdm.quote_cur_id ,  cm.cur_code corporate_base_curency ,
           cm.cur_id corporate_base_curency_id

     FROM cfq_currency_forward_quotes c, cfqd_currency_fwd_quote_detail cfqd
     , ak_corporate ak , cm_currency_master cm  , dim_der_instrument_master dim ,
     pdd_product_derivative_def pdd, pdm_productmaster pdm


    WHERE c.cfq_id = cfqd.cfq_id  and c.corporate_id = ak.corporate_id
and c.instrument_id = dim.instrument_id and dim.product_derivative_id = pdd.derivative_def_id
and pdd.product_id = pdm.product_id
  and cm.cur_id = ak.base_cur_id
  and cfqd.is_spot = 'Y'
  and (pdm.base_cur_id = cm.cur_id or pdm.quote_cur_id = cm.cur_id)
      and c.instrument_id in
    (select distinct instrument_id from cci_corp_currency_instrument
    where is_deleted = 'N') and ak.is_deleted = 'N' AND ak.is_active = 'Y'
    and c.is_deleted = 'N' and cfqd.is_deleted = 'N' and cm.is_active = 'Y'
    and cm.is_deleted = 'N' and dim.is_active = 'Y' and dim.is_deleted = 'N'
    and pdd.is_active = 'Y' and pdd.is_deleted = 'N'
    and pdm.is_active = 'Y' and pdm.is_deleted = 'N' 
/
/* Formatted on 2012/06/01 15:56 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW V_CDC_DERIVATIVE_QUOTES_NEW AS
SELECT dq.dq_id, dq.trade_date, dq.corporate_id, dq.entry_type,
          dq.instrument_id, dq.price_source_id, dq.created_date,
          dq.updated_date, dq.VERSION, dq.is_deleted, d.dqd_id, d.dr_id,
          d.available_price_id, d.price, d.price_unit_id, d.delta, d.gamma,
          d.theta, d.wega, d.is_deleted dqd_is_deleted , pum.weight_unit_id ,
          gcd.group_qty_unit_id Base_Quantity_Id , ak.base_cur_id corporate_base_cur
     FROM dq_derivative_quotes dq, dqd_derivative_quote_detail d , dim_der_instrument_master  dim
     , div_der_instrument_valuation  div , pum_price_unit_master pum  , ak_corporate ak ,
     gcd_groupcorporatedetails  gcd
    WHERE dq.dq_id = d.dq_id  and dq.instrument_id = dim.instrument_id and dim.instrument_id  = div.instrument_id
      and dq.price_source_id = div.price_source_id and d.price_unit_id  = div.price_unit_id
      and d.available_price_id = div.available_price_id and dq.corporate_id = ak.corporate_id
      and ak.groupid = gcd.groupid
      and gcd.is_active = 'Y' and gcd.is_deleted = 'N'
      and ak.is_active = 'Y'  and ak.is_deleted = 'N'
        and dq.is_deleted = 'N'
       AND d.is_deleted = 'N' and d.price_unit_id = pum.price_unit_id and pum.is_active  = 'Y'
       and pum.is_deleted = 'N' and dim.is_deleted = 'N'  AND dim.is_active = 'Y'  and div.is_deleted = 'N'

/
/* Formatted on 2012/06/01 15:56 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW V_CDC_FX_TRADES AS
SELECT crtd."CTRD_ID",crtd."INTERNAL_TREASURY_REF_NO",crtd."TRADE_TYPE",crtd."CUR_ID",crtd."LEG_NO",crtd."AMOUNT",crtd."IS_BASE" FROM
      CRTD_CUR_TRADE_DETAILS crtd , ct_currency_trade ct , ak_corporate ak
      where ct.internal_treasury_ref_no = crtd.internal_treasury_ref_no
     and ct.corporate_id = ak.corporate_id and ak.base_cur_id <> crtd.cur_id  and ak.is_deleted
     = 'N' AND ak.is_active = 'Y'  and ct.status <> 'Delete'

/
CREATE OR REPLACE VIEW V_FXS_TRADE_STATUS AS
WITH exp_drid AS
        (SELECT eci.corporate_id, eci.ct_id
           FROM eci_expired_ct_id eci
          WHERE eci.process = 'EOD')
select fxs.corporate_id,
       fxs.matched_trade_int_fx_ref_no internal_treasury_ref_no,
       fxs.amount settlement_amount,
       fxs.cur_id settlement_cur_id,
       cm.cur_code settlement_cur_code,
       (case
         when ecdit.ct_id is null then
          null
         else
          'Settled'
       end) settlement_status
  from fxs_fx_settlement  fxs,
       cm_currency_master cm,
       exp_drid           ecdit
 where fxs.cur_id = cm.cur_id(+)
   and fxs.matched_trade_drid = ecdit.ct_id(+)
   and fxs.corporate_id = ecdit.corporate_id(+)
union all
select t.corporate_id,
       t.internal_treasury_ref_no,
       t.settlement_amount,
       t.settlement_cur_id,
       t.settlement_cur_code,
       (case
         when t.main_trade_status is not null then
          'Settled'
         else
          (case
         when t.settlement_count = 0 then
          null
         else
          (case
         when t.allocated_count = t.settlement_count and
              t.outstanding_amount = 0 then
          'Settled'
         else
          'Partially Settled'
       end) end) end) settlement_status
  from (select fxs.corporate_id,
               fxs.main_trade_int_fx_ref_no internal_treasury_ref_no,
               sum(fxs.amount) settlement_amount,
               nvl(ct.outstanding_amount,0)outstanding_amount,
               fxs.cur_id settlement_cur_id,
               cm.cur_code settlement_cur_code,
               count(fxs.matched_trade_int_fx_ref_no) allocated_count,
               max(case
                     when ecdit_main.ct_id is null then
                      null
                     else
                      'Settled'
                   end) main_trade_status,
               count(case
                       when ecdit.ct_id is null then
                        null
                       else
                        'Settled'
                     end) settlement_count
          from fxs_fx_settlement  fxs,
               ct_currency_trade  ct,
               cm_currency_master cm,
               exp_drid           ecdit,
               exp_drid           ecdit_main
         where fxs.cur_id = cm.cur_id(+)
           and fxs.main_trade_int_fx_ref_no = ct.internal_treasury_ref_no
           and fxs.corporate_id = ct.corporate_id
           and fxs.matched_trade_drid = ecdit.ct_id(+)
           and fxs.corporate_id = ecdit.corporate_id(+)
           and ct.dr_id = ecdit_main.ct_id(+)
           and ct.corporate_id = ecdit_main.corporate_id(+)
          -- and fxs.main_trade_int_fx_ref_no in ('FX-88', 'FX-89')
         group by fxs.corporate_id,
                  fxs.main_trade_int_fx_ref_no,
                  ct.outstanding_amount,
                  fxs.cur_id,
                  cm.cur_code) t;
/

create sequence SEQ_DTA
minvalue 1
maxvalue 1000000000000000000000000000
start with 1
increment by 1
cache 20;
create table DT_AVG
(
  DTA_ID                     VARCHAR2(15) not null,
  INTERNAL_DERIVATIVE_REF_NO NUMBER(5),
  PERIOD_DATE                DATE,
  QUANTITY                   NUMBER(25,5),
  QUANTITY_UNIT_ID           VARCHAR2(15),
  FIXED_PRICE                NUMBER(25,5),
  PRICE_UNIT_ID              VARCHAR2(15)
);

alter table DT_AVG add constraint PK_DTA_01 primary key (DTA_ID) using index ;
create index ID_DTA_01 on DT_AVG (INTERNAL_DERIVATIVE_REF_NO);

create table DT_QTY_LOG
(
  INTERNAL_DERIVATIVE_REF_NO NUMBER(5),
  DERIVATIVE_REF_NO          VARCHAR2(30),
  INTERNAL_ACTION_REF_NO     VARCHAR2(15),
  DR_ID                      VARCHAR2(15),
  CORPORATE_ID               VARCHAR2(15),
  STATUS                     VARCHAR2(15),
  ENTRY_TYPE                 VARCHAR2(30),
  QUANTITY_UNIT_ID           VARCHAR2(15),
  TOTAL_QUANTITY_DELTA       NUMBER(25,5),
  OPEN_QUANTITY_DELTA        NUMBER(25,4),
  CLOSED_QUANTITY_DELTA      NUMBER(25,4),
  EXERCISED_QUANTITY_DELTA   NUMBER(25,4),
  EXPIRED_QUANTITY_DELTA     NUMBER(25,4),
  TOTAL_LOTS_DELTA           NUMBER(5),
  OPEN_LOTS_DELTA            NUMBER(5),
  CLOSED_LOTS_DELTA          NUMBER(5),
  EXERCISED_LOTS_DELTA       NUMBER(5),
  EXPIRED_LOTS_DELTA         NUMBER(5)
);

create index ID_DQL_01 on DT_QTY_LOG (INTERNAL_DERIVATIVE_REF_NO);
CREATE OR REPLACE TRIGGER "TRG_INSERT_DT_AVG" 
    /**************************************************************************************************
           Trigger Name                       : TRG_INSERT_DT_QTY_LOG
           Author                             : Venu
           Created Date                       : 17th May 2012
           Purpose                            : To Insert into DT_QTY_LOG Table

           Modification History

           Modified Date  :
           Modified By  :
           Modify Description :

   ***************************************************************************************************/
AFTER INSERT OR UPDATE
   ON dt_derivative_trade
   FOR EACH ROW
DECLARE
	v_pr_start_dt   drm_derivative_master.period_start_date%TYPE;
	v_pr_end_dt     drm_derivative_master.period_end_date%TYPE;
	v_instrument_id drm_derivative_master.instrument_id%TYPE;
	v_instr_type_id dim_der_instrument_master.instrument_type_id%TYPE;
	v_instr_type    irm_instrument_type_master.instrument_type%TYPE;

	v_count NUMBER := 0;
BEGIN
	SELECT drm.period_start_date,
		 drm.period_end_date,
		 drm.instrument_id
	INTO   v_pr_start_dt,
		 v_pr_end_dt,
		 v_instrument_id
	FROM   drm_derivative_master drm
	WHERE  drm.dr_id = :NEW.dr_id;

	SELECT dim.instrument_type_id
	INTO   v_instr_type_id
	FROM   dim_der_instrument_master dim
	WHERE  dim.instrument_id = v_instrument_id;

	SELECT irm.instrument_type
	INTO   v_instr_type
	FROM   irm_instrument_type_master irm
	WHERE  irm.instrument_type_id = v_instr_type_id;

	IF v_instr_type = 'Average'
	THEN
		IF inserting
		THEN
		
			WHILE v_pr_start_dt <= v_pr_end_dt
			LOOP
				---- finding holidays
				IF NOT pkg_cdc_formula_builder.f_is_day_holiday(v_instrument_id, v_pr_start_dt)
				THEN
					INSERT INTO dt_avg
						(dta_id
						,internal_derivative_ref_no
						,period_date
						,fixed_price
						,quantity_unit_id)
					VALUES
						('DTA-' || seq_dta.NEXTVAL
						,:NEW.internal_derivative_ref_no
						,v_pr_start_dt
						,0
						,:NEW.quantity_unit_id);
					v_count := v_count + 1;
				
				END IF;
			
				v_pr_start_dt := v_pr_start_dt + 1;
			
			END LOOP;
			UPDATE dt_avg
			SET    quantity = :NEW.total_quantity / v_count
			WHERE  internal_derivative_ref_no = :NEW.internal_derivative_ref_no;
		ELSIF updating
		THEN
			IF :NEW.dr_id <> :OLD.dr_id
			THEN
				DELETE FROM dt_avg
				WHERE  internal_derivative_ref_no = :NEW.internal_derivative_ref_no;
                        
				WHILE v_pr_start_dt <= v_pr_end_dt
				LOOP
					---- finding holidays
					IF NOT pkg_cdc_formula_builder.f_is_day_holiday(v_instrument_id, v_pr_start_dt)
					THEN
						INSERT INTO dt_avg
							(dta_id
							,internal_derivative_ref_no
							,period_date
							,fixed_price
							,quantity_unit_id)
						VALUES
							('DTA-' || seq_dta.NEXTVAL
							,:NEW.internal_derivative_ref_no
							,v_pr_start_dt
							,0
							,:NEW.quantity_unit_id);
						v_count := v_count + 1;
					
					END IF;
				
					v_pr_start_dt := v_pr_start_dt + 1;
				
				END LOOP;
				UPDATE dt_avg
				SET    quantity = :NEW.total_quantity / v_count
				WHERE  internal_derivative_ref_no = :NEW.internal_derivative_ref_no;
			
				--only total_quantity changed
			ELSIF :NEW.total_quantity <> :OLD.total_quantity OR :NEW.quantity_unit_id <> :OLD.quantity_unit_id
			THEN
			
				SELECT COUNT(*)
				INTO   v_count
				FROM   dt_avg
				WHERE  internal_derivative_ref_no = :NEW.internal_derivative_ref_no;
			
				UPDATE dt_avg
				SET    quantity         = :NEW.total_quantity / v_count,
					 quantity_unit_id = :NEW.quantity_unit_id
				WHERE  internal_derivative_ref_no = :NEW.internal_derivative_ref_no;
			END IF;
		END IF;
	END IF;
END;
/
CREATE OR REPLACE TRIGGER "TRG_INSERT_DT_QTY_LOG" 
    /**************************************************************************************************
           Trigger Name                       : TRG_INSERT_DT_QTY_LOG
           Author                             : Venu
           Created Date                       : 17th May 2012
           Purpose                            : To Insert into DT_QTY_LOG Table

           Modification History

           Modified Date  :
           Modified By  :
           Modify Description :

   ***************************************************************************************************/
AFTER INSERT OR UPDATE
   ON dt_derivative_trade
   FOR EACH ROW
DECLARE
	v_total_qty      NUMBER(25, 4);
	v_open_qty       NUMBER(25, 4);
	v_closed_qty     NUMBER(25, 4);
	v_exercised_qty  NUMBER(25, 4);
	v_expired_qty    NUMBER(25, 4);
	v_total_lots     NUMBER(5);
	v_open_lots      NUMBER(5);
	v_closed_lots    NUMBER(5);
	v_exercised_lots NUMBER(5);
	v_expired_lots   NUMBER(5);
BEGIN
	--
	-- If updating then put the delta for Quantity columns as Old - New
	-- If inserting put the new value as is as Delta
	--
	IF updating
	THEN
		--Qty Unit is Not Updated
		IF (:NEW.quantity_unit_id = :OLD.quantity_unit_id)
		THEN
			v_total_qty      := NVL(:NEW.total_quantity,0) - NVL(:OLD.total_quantity,0);
			v_open_qty       := NVL(:NEW.open_quantity,0) - NVL(:OLD.open_quantity,0);
			v_closed_qty     := NVL(:NEW.closed_quantity,0) - NVL(:OLD.closed_quantity,0);
			v_exercised_qty  := NVL(:NEW.exercised_quantity,0) - NVL(:OLD.exercised_quantity,0);
			v_expired_qty    := NVL(:NEW.expired_quantity,0) - NVL(:OLD.expired_quantity,0);
			v_total_lots     := NVL(:NEW.total_lots,0) - NVL(:OLD.total_lots,0);
			v_open_lots      := NVL(:NEW.open_lots,0) - NVL(:OLD.open_lots,0);
			v_closed_lots    := NVL(:NEW.closed_lots,0) - NVL(:OLD.closed_lots,0);
			v_exercised_lots := NVL(:NEW.exercised_lots,0) - NVL(:OLD.exercised_lots,0);
			v_expired_lots   := NVL(:NEW.expired_lots,0) - NVL(:OLD.expired_lots,0);
		
			IF v_open_qty <> 0 OR v_closed_qty <> 0 OR v_exercised_qty <> 0 OR v_expired_qty <> 0 OR
			   v_total_lots <> 0 OR v_open_lots <> 0 OR v_closed_lots <> 0 OR v_exercised_lots <> 0 OR
			   v_expired_lots <> 0
			THEN
				INSERT INTO dt_qty_log
					(internal_derivative_ref_no
					,derivative_ref_no
					,internal_action_ref_no
					,dr_id
					,corporate_id
					,status
					,quantity_unit_id
					,total_quantity_delta
					,open_quantity_delta
					,closed_quantity_delta
					,exercised_quantity_delta
					,expired_quantity_delta
					,total_lots_delta
					,open_lots_delta
					,closed_lots_delta
					,exercised_lots_delta
					,expired_lots_delta
					,entry_type)
				VALUES
					(:NEW.internal_derivative_ref_no
					,:NEW.derivative_ref_no
					,:NEW.latest_internal_action_ref_no
					,:NEW.dr_id
					,:NEW.corporate_id
					,:NEW.status
					,:NEW.quantity_unit_id
					,v_total_qty
					,v_open_qty
					,v_closed_qty
					,v_exercised_qty
					,v_expired_qty
					,v_total_lots
					,v_open_lots
					,v_closed_lots
					,v_exercised_lots
					,v_expired_lots
					,'Update');
			END IF;
		ELSE
			--Qty Unit is Updated
			INSERT INTO dt_qty_log
				(internal_derivative_ref_no
				,derivative_ref_no
				,internal_action_ref_no
				,dr_id
				,corporate_id
				,status
				,quantity_unit_id
				,total_quantity_delta
				,open_quantity_delta
				,closed_quantity_delta
				,exercised_quantity_delta
				,expired_quantity_delta
				,total_lots_delta
				,open_lots_delta
				,closed_lots_delta
				,exercised_lots_delta
				,expired_lots_delta
				,entry_type)
			VALUES
				(:NEW.internal_derivative_ref_no
				,:NEW.derivative_ref_no
				,:NEW.latest_internal_action_ref_no
				,:NEW.dr_id
				,:NEW.corporate_id
				,:NEW.status
				,:NEW.quantity_unit_id
				,:NEW.total_quantity -
				 pkg_general.f_get_converted_quantity(NULL
										 ,:OLD.quantity_unit_id
										 ,:NEW.quantity_unit_id
										 ,:OLD.total_quantity)
				,:NEW.open_quantity -
				 pkg_general.f_get_converted_quantity(NULL
										 ,:OLD.quantity_unit_id
										 ,:NEW.quantity_unit_id
										 ,:OLD.open_quantity)
				,:NEW.closed_quantity -
				 pkg_general.f_get_converted_quantity(NULL
										 ,:OLD.quantity_unit_id
										 ,:NEW.quantity_unit_id
										 ,:OLD.closed_quantity)
				,:NEW.exercised_quantity -
				 pkg_general.f_get_converted_quantity(NULL
										 ,:OLD.quantity_unit_id
										 ,:NEW.quantity_unit_id
										 ,:OLD.exercised_quantity)
				,:NEW.expired_quantity -
				 pkg_general.f_get_converted_quantity(NULL
										 ,:OLD.quantity_unit_id
										 ,:NEW.quantity_unit_id
										 ,:OLD.expired_quantity)
				,:NEW.total_lots - :OLD.total_lots
				,:NEW.open_lots - :OLD.open_lots
				,:NEW.closed_lots - :OLD.closed_lots
				,:NEW.exercised_lots - :OLD.exercised_lots
				,:NEW.expired_lots - :OLD.expired_lots
				,'Update');
		
		END IF;
	
	ELSE
		--
		-- New Entry ( Entry Type=Insert)
		--
		INSERT INTO dt_qty_log
			(internal_derivative_ref_no
			,derivative_ref_no
			,internal_action_ref_no
			,dr_id
			,corporate_id
			,status
			,quantity_unit_id
			,total_quantity_delta
			,open_quantity_delta
			,closed_quantity_delta
			,exercised_quantity_delta
			,expired_quantity_delta
			,total_lots_delta
			,open_lots_delta
			,closed_lots_delta
			,exercised_lots_delta
			,expired_lots_delta
			,entry_type)
		VALUES
			(:NEW.internal_derivative_ref_no
			,:NEW.derivative_ref_no
			,:NEW.latest_internal_action_ref_no
			,:NEW.dr_id
			,:NEW.corporate_id
			,:NEW.status
			,:NEW.quantity_unit_id
			,:NEW.total_quantity
			,:NEW.open_quantity
			,:NEW.closed_quantity
			,:NEW.exercised_quantity
			,:NEW.expired_quantity
			,:NEW.total_lots
			,:NEW.open_lots
			,:NEW.closed_lots
			,:NEW.exercised_lots
			,:NEW.expired_lots
			,'Insert');
	
	END IF;
END;
/

commit;