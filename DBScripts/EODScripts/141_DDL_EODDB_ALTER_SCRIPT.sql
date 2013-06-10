CREATE TABLE PFRH_PRICE_FIX_REPORT_HEADER(
PROCESS_ID                         VARCHAR2(15),
EOD_TRADE_DATE                     DATE,
CORPORATE_ID                       VARCHAR2(15),
CORPORATE_NAME                     VARCHAR2(100),
PRODUCT_ID                         VARCHAR2(15),
PRODUCT_NAME                       VARCHAR2(200),
INSTRUMENT_ID                      VARCHAR2(15),
INSTRUMENT_NAME                    VARCHAR2(200),
PRICED_ARRIVED_QTY                 NUMBER(25,5),
PRICED_DELIVERED_QTY               NUMBER(25,5),
REALIZED_QTY                       NUMBER(25,5),
REALIZED_QTY_PREV_MONTH            NUMBER(25,5),
REALIZED_QTY_CURRENT_MONTH         NUMBER(25,5),
REALIZED_VALUE                     NUMBER(25,5),
PURCHASE_PRICE_FIX_QTY             NUMBER(25,5),
WAP_PURCHASE_PRICE_FIXATIONS       NUMBER(25,5),
SALES_PRICE_FIXATION_QTY           NUMBER(25,5),
WAP_SALES_PRICE_FIXATIONS          NUMBER(25,5),
PRICE_FIX_QTY_PURCHASE_OB          NUMBER(25,5),
PRICE_FIX_QTY_SALES_OB             NUMBER(25,5),
PRICE_FIX_QTY_PURCHASE_NEW         NUMBER(25,5),
PRICE_FIX_QTY_SALES_NEW            NUMBER(25,5));

CREATE TABLE PFRD_PRICE_FIX_REPORT_DETAIL(
PROCESS_ID                         VARCHAR2(15),
EOD_TRADE_DATE                     DATE,
SECTION_NAME                       VARCHAR2(100),
PURCHASE_SALES                     VARCHAR2(10),                      
CORPORATE_ID                       VARCHAR2(15),
CORPORATE_NAME                     VARCHAR2(100),
PRODUCT_ID                         VARCHAR2(15),
PRODUCT_NAME                       VARCHAR2(200),
ELEMENT_ID                         VARCHAR2(15),
INSTRUMENT_ID                      VARCHAR2(15),
INSTRUMENT_NAME                    VARCHAR2(200),
CP_ID                              VARCHAR2(15),
CP_NAME                            VARCHAR2(100),
INTERNAL_CONTRACT_REF_NO           VARCHAR2(15),
DELIVERY_ITEM_NO                   VARCHAR2(20),
CONTRACT_TYPE                      VARCHAR2(20),
PCDI_ID                            VARCHAR2(15),
CONTRACT_REF_NO_DEL_ITEM_NO        VARCHAR2(50),
INTERNAL_GMR_REF_NO                VARCHAR2(15),
GMR_REF_NO                         VARCHAR2(15),
PRICE_FIXED_DATE                   DATE,    
INTERNAL_ACTION_REF_NO             VARCHAR2(15),
PFD_ID                             VARCHAR2(15),
IS_NEW_PFC                         VARCHAR2(1),
PF_REF_NO                          VARCHAR2(100),
FIXED_QTY                          NUMBER(25,10),
FIXED_UNIT_BASE_QTY_FACTOR         NUMBER,
PRICE                              NUMBER(25,10),
PRICE_UNIT_ID                      VARCHAR2(15),
PRICE_UNIT_CUR_ID                  VARCHAR2(15),    
PRICE_UNIT_CUR_CODE                VARCHAR2(15),    
PRICE_UNIT_WEIGHT_UNIT_ID          VARCHAR2(15),    
PRICE_UNIT_WEIGHT_UNIT             VARCHAR2(15),    
PRICE_UNIT_WEIGHT                  NUMBER(7,2),
PRICE_UNIT_NAME                    VARCHAR2(50),
FX_PRICE_TO_BASE_CUR               NUMBER(25,10),
PRICE_IN_BASE_CUR                  NUMBER(25,10),
CONSUMED_QTY                       NUMBER(25,10),
FIXATION_VALUE                     NUMBER(25,10));



ALTER TABLE PCS_PURCHASE_CONTRACT_STATUS ADD INSTRUMENT_ID VARCHAR2(15);
ALTER TABLE PCS_PURCHASE_CONTRACT_STATUS ADD UNDERLYING_PRODUCT_ID VARCHAR2(15);

ALTER TABLE TCS2_TEMP_CS_PRICED ADD INSTRUMENT_ID VARCHAR2(15);
ALTER TABLE TCS2_TEMP_CS_PRICED ADD UNDERLYING_PRODUCT_ID VARCHAR2(15);

ALTER TABLE TCSM_TEMP_CONTRACT_STATUS_MAIN ADD INSTRUMENT_ID VARCHAR2(15);
ALTER TABLE TCSM_TEMP_CONTRACT_STATUS_MAIN ADD UNDERLYING_PRODUCT_ID VARCHAR2(15);

ALTER TABLE TCS1_TEMP_CS_PAYABLE ADD INSTRUMENT_ID VARCHAR2(15);
ALTER TABLE TCS1_TEMP_CS_PAYABLE ADD UNDERLYING_PRODUCT_ID VARCHAR2(15);

ALTER  TABLE PCM_PHYSICAL_CONTRACT_MAIN ADD IS_PASS_THROUGH VARCHAR2(1) DEFAULT 'N';

CREATE TABLE CSS_CONTRACT_STATUS_SUMMARY(
PROCESS_ID                VARCHAR2(15),
EOD_TRADE_DATE            DATE,
CORPORATE_ID              VARCHAR2(15),
CORPORATE_NAME            VARCHAR2(100),
PRODUCT_ID                VARCHAR2(15),
PRODUCT_NAME              VARCHAR2(200),
CONTRACT_TYPE             VARCHAR2(30),
PURCHASE_SALES            VARCHAR2(1),
INSTRUMENT_ID             VARCHAR2(15),
PRICED_ARRIVED_QTY        NUMBER,
PRICED_UNARRIVED_QTY      NUMBER,
UNPRICED_ARRIVED_QTY      NUMBER,
UNPRICED_UNARRIVED_QTY    NUMBER,
PRICED_DELIVERED_QTY      NUMBER,
PRICED_UNDELIVERED_QTY    NUMBER,
UNPRICED_DELIVERED_QTY    NUMBER,
UNPRICED_UNDELIVERED_QTY  NUMBER,
QTY_UNIT_ID               VARCHAR2(30),
QTY_UNIT                  VARCHAR2(15));

CREATE TABLE MBV_METAL_BALANCE_VALUATION(
PROCESS_ID                  VARCHAR2(15),
EOD_TRADE_DATE              DATE,
CORPORATE_ID                VARCHAR2(15 ),
CORPORATE_NAME              VARCHAR2(100 ),
PRODUCT_ID                  VARCHAR2(15 ),
PRODUCT_NAME                VARCHAR2(200 ),
INSTRUMENT_ID               VARCHAR2(15 ),
INSTRUMENT_NAME             VARCHAR2(200 ),
EXCHANGE_ID                 VARCHAR2(15 ),
EXCHANGE_NAME               VARCHAR2(200 ),
QTY_TO_BE_HEDGED            NUMBER(25,5),
PHY_REALIZED_OB             NUMBER(25,5),
PHY_REALIZED_QTY            NUMBER(25,5),
PHY_REALIZED_PNL            NUMBER(25,5),
PHY_REALIZED_CB             NUMBER(25,5),
PHY_UNR_PRICE_INV_PRICE     NUMBER(25,5),
PHY_UNR_PRICE_NA_INV_PRICE  NUMBER(25,5),
PHY_UNR_PRICE_ND_INV_PRICE  NUMBER(25,5),
REFERENTIAL_PRICE_DIFF      NUMBER(25,5),
CONTANGO_BW_DIFF            NUMBER(25,5),
PRICED_NOT_ARRIVED_QTY      NUMBER(25,5),
PRICED_NOT_DELIVERED_QTY    NUMBER(25,5),
METAL_DEBT_QTY              NUMBER(25,5),
METAL_DEBT_VALUE            NUMBER(25,5),
INVENTORY_UNREAL_PNL        NUMBER(25,5),
MONTH_END_PRICE             NUMBER(25,5),
MONTH_END_PRICE_UNIT_ID     VARCHAR2(15 ),
MONTH_END_PRICE_UNIT_NAME   VARCHAR2(15 ),
DER_REALIZED_QTY            NUMBER(25,5),
DER_REALIZED_PNL            NUMBER(25,5),
DER_UNREALIZED_PNL          NUMBER(25,5),
DER_REALIZED_OB             NUMBER(25,5),
QTY_DECIMALS                NUMBER(2),
CCY_DECIMALS                NUMBER(2),
TOTAL_INV_QTY               NUMBER(25,5),
PRICED_INV_QTY              NUMBER(25,5),
UNPRICED_INV_QTY            NUMBER(25,5),
UNR_PHY_PRICED_INV_PNL      NUMBER(25,5),
UNR_PHY_PRICED_NA_PNL       NUMBER(25,5),
UNR_PHY_PRICED_ND_PNL       NUMBER(25,5),
DER_REF_PRICE_DIFF          NUMBER(25,5),
PHY_REF_PRICE_DIFF          NUMBER(25,5),
CONTANGO_DUETO_QTY_PRICE    NUMBER(25,5),
CONTANGO_DUETO_QTY          NUMBER(25,5),
ACTUAL_HEDGED_QTY           NUMBER(25,5),
HEDGE_EFFECTIVENESS         NUMBER(25,5),
CURRENCY_UNIT               VARCHAR2(15 ),
QTY_UNIT                    VARCHAR2(15),
PRICED_NOT_ARRIVED_BM            NUMBER(25,5),
PRICED_NOT_ARRIVED_RM            NUMBER(25,5),
UNPRICED_ARRIVED_BM        NUMBER(25,5),
UNPRICED_ARRIVED_RM        NUMBER(25,5),
SALES_UNPRICED_DELIVERED_BM    NUMBER(25,5),
SALES_UNPRICED_DELIVERED_RM    NUMBER(25,5),
SALES_PRICED_NOT_DELIVERED_BM    NUMBER(25,5),
SALES_PRICED_NOT_DELIVERED_RM    NUMBER(25,5));


CREATE TABLE DIWAP_DI_WEIGHTED_AVG_PRICE(
PROCESS_ID                   VARCHAR2(15 CHAR),
EOD_TRADE_DATE               DATE,
PURCHASE_SALES               VARCHAR2(10),
CORPORATE_ID                 VARCHAR2(15),
CORPORATE_NAME               VARCHAR2(100),
PRODUCT_ID                   VARCHAR2(15),
PRODUCT_NAME                 VARCHAR2(200),
INSTRUMENT_ID                VARCHAR2(15),
INSTRUMENT_NAME              VARCHAR2(200),
PCDI_ID                      VARCHAR2(15),
CONTRACTT_TYPE               VARCHAR2(15),
WEIGHTED_AVG_PRICE           NUMBER(25,5),
WAP_PRICE_UNIT_ID            VARCHAR2(15),
WAP_PRICE_UNIT_NAME          VARCHAR2(50),
WAP_PRICE_CUR_ID             VARCHAR2(15),
WAP_PRICE_CUR_CODE           VARCHAR2(15),
WAP_PRICE_WEIGHT_UNIT_ID     VARCHAR2(15),
WAP_PRICE_WEIGHT_UNIT        VARCHAR2(15),
WAP_PRICE_WEIGHT             number(7,2),
ELEMENT_ID                   VARCHAR2(15),
ELEMENT_NAME                 VARCHAR2(30));

create TABLE MBV_DI_VALUATION_PRICE
(
PROCESS_ID                 varchar2(15),
CONTRACT_REF_NO            VARCHAR2(30),
PCDI_ID                    VARCHAR2(15),
ELEMENT_ID                 VARCHAR2(15),
DELIVERY_DATE              DATE,
PRICE                      NUMBER(25,5),
PRICE_UNIT_ID              VARCHAR2(15),
PRICE_UNIT_CUR_ID          VARCHAR2 (15),    
PRICE_UNIT_CUR_CODE        VARCHAR2 (15),   
PRICE_UNIT_WEIGHT          NUMBER (7,2),
PRICE_UNIT_WEIGHT_UNIT_ID  VARCHAR2 (15), 
PRICE_UNIT_WEIGHT_UNIT     VARCHAR2 (15));


create table MBV_PHY_POSTION_DIFF_REPORT
(
  PROCESS_ID                     VARCHAR2(15),
  EOD_TRADE_DATE                 DATE,
  CORPORATE_ID                   VARCHAR2(15),
  CORPORATE_NAME                 VARCHAR2(100),
  PRODUCT_ID                     VARCHAR2(15),
  PRODUCT_NAME                   VARCHAR2(200),
  CONTRACT_DATE                  DATE,
  PURCHASE_SALES                 VARCHAR2(15),
  CONTRACT_TYPE                  VARCHAR2(15),
  INSTRUMENT_ID                  VARCHAR2(15),
  INSTRUMENT_NAME                VARCHAR2(200),
  CP_ID                          VARCHAR2(15),
  CP_NAME                        VARCHAR2(100),
  INTERNAL_CONTRACT_REF_NO       VARCHAR2(15),
  DELIVERY_ITEM_NO               VARCHAR2(20),
  CONTRACT_REF_NO_DEL_ITEM_NO    VARCHAR2(50),
  PCDI_ID                        VARCHAR2(15),
  ELEMENT_ID                     VARCHAR2 (15),
  ELEMENT_NAME                   VARCHAR2 (30),
  QTY                            NUMBER(25,10),
  QTY_UNIT_ID                    VARCHAR2(15),
  QTY_UNIT                       varchar2(15),
  DELIVERY_ARRIVAL_DATE          DATE,
  CON_PRICE                      NUMBER(25,5),
  CON_PRICE_UNIT_ID              VARCHAR2(15),
  CON_PRICE_UNIT_CUR_ID          VARCHAR2(15),
  CON_PRICE_UNIT_CUR_CODE        VARCHAR2(15),
  CON_PRICE_UNIT_WEIGHT_UNIT_ID  VARCHAR2(15),
  CON_PRICE_UNIT_WEIGHT_UNIT     VARCHAR2(15),
  CON_PRICE_UNIT_WEIGHT          NUMBER(7,2),
  CON_PRICE_UNIT_NAME            VARCHAR2(50),
  VAL_PRICE                      NUMBER(25,5),
  VAL_PRICE_UNIT_ID              VARCHAR2(15),
  VAL_PRICE_UNIT_CUR_ID          VARCHAR2(15),
  VAL_PRICE_UNIT_CUR_CODE        VARCHAR2(15),
  VAL_PRICE_UNIT_WEIGHT_UNIT_ID  VARCHAR2(15),
  VAL_PRICE_UNIT_WEIGHT_UNIT     VARCHAR2(15),
  VAL_PRICE_UNIT_WEIGHT          NUMBER(7,2),
  VAL_PRICE_UNIT_NAME            VARCHAR2(50),
  MON_END_PRICE                  NUMBER(25,5),
  MON_END_PRICE_UNIT_ID          VARCHAR2(15),
  MON_END_PRICE_UNIT_CUR_ID      VARCHAR2(15),
  MON_END_PRICE_UNIT_CUR_CODE    VARCHAR2(15),
  MON_END_PRICE_WEIGHT_UNIT_ID   VARCHAR2(15),
  MON_END_PRICE_UNIT_WEIGHT_UNIT VARCHAR2(15),
  MON_END_PRICE_UNIT_WEIGHT      NUMBER(7,2),
  MON_END_PRICE_UNIT_NAME        VARCHAR2(50),
  FX_CON_PRICE_TO_BASE_CUR       NUMBER(25,10),
  FX_VAL_PRICE_TO_BASE_CUR       NUMBER(25,10),
  FX_MONEND_PRICE_TO_BASE_CUR    NUMBER(25,10),  
  CONTRACT_PRICE_IN_BASE_CUR     NUMBER(25,5),
  VALUATION_PRICE_IN_BASE_CUR    NUMBER(25,5),
  MONTH_END_PRICE_IN_BASE_CUR    NUMBER(25,5),
  REFERENTIAL_PRICE_IN_BASE_CUR  NUMBER(25,5),
  CONTRACT_VALUE_IN_BASE_CUR     NUMBER(25,5),
  VALUATION_VALUE_IN_BASE_CUR    NUMBER(25,5),
  MONTH_END_VALUE_IN_BASE_CUR    NUMBER(25,5),
  REFERENTIAL_VALUE_IN_BASE_CUR  NUMBER(25,5),
  UNREALIZED_PNL_IN_BASE_CUR     NUMBER(25,5),
  CP_MAIN_CUR_ID                 VARCHAR2(15),
  CP_MAIN_CUR_CODE               VARCHAR2(15),
  VP_MAIN_CUR_ID                 VARCHAR2(15),
  VP_MAIN_CUR_CODE               VARCHAR2(15),
  MEP_MAIN_CUR_ID                VARCHAR2(15),
  MEP_MAIN_CUR_CODE              VARCHAR2(15),
  BASE_CUR_ID                    VARCHAR2(15),
  BASE_CUR_CODE                  VARCHAR2(15));

create table  MBV_ALLOCATION_REPORT
(
PROCESS_ID                  VARCHAR2(15),
EOD_TRADE_DATE              DATE,
CORPORATE_ID                VARCHAR2 (15),
CORPORATE_NAME              VARCHAR2 (100),
SECTION_NAME                VARCHAR2(200),
CP_ID                       VARCHAR2 (15),
CP_NAME                     VARCHAR2 (200),
PRODUCT_ID                  VARCHAR2 (15),
PRODUCT_DESC                VARCHAR2 (200),
INSTRUMENT_ID               VARCHAR2(15),
INSTRUMENT_NAME             VARCHAR2(200),
INTERNAL_CONTRACT_REF_NO    VARCHAR2(15),
DELIVERY_ITEM_NO            VARCHAR2 (15),
GMR_REF_NO                  VARCHAR2 (30),
INTERNAL_GMR_REF_NO         VARCHAR2 (15),
PF_REF_NO                   VARCHAR2 (15),
EXTERNAL_REF_NO             VARCHAR2 (50),
DERIVATIVE_REF_NO           VARCHAR2 (30),
PURCHASE_QTY                NUMBER (25,4),
SALES_QTY                   NUMBER (25,4),
QTY_UNIT_ID                 VARCHAR2 (15),
QTY_UNIT                    VARCHAR2 (15),
PRICE                       NUMBER (25,5),
PRICE_UNIT_ID               VARCHAR2 (15),
PRICE_UNIT_CUR_ID           VARCHAR2(15),
PRICE_UNIT_CUR_CODE         VARCHAR2(15),
PRICE_UNIT_WEIGHT_UNIT_ID   VARCHAR2(15),
PRICE_UNIT_WEIGHT_UNIT      VARCHAR2(15),
PRICE_UNIT_WEIGHT           NUMBER(7,2),
PRICE_UNIT_NAME             VARCHAR2(15),
PROMPT_MONTH_YEAR           VARCHAR2 (15),
FX_RATE_PRICE_TO_BASE       NUMBER (38,18),
PRICE_IN_BASE_CCY           NUMBER (38,18),
PRICE_FIXED_DATE            DATE,
AMOUNT                      NUMBER (38,18),
BASE_CUR_ID                 VARCHAR2 (15),
BASE_CUR_NAME               VARCHAR2 (25));

DROP MATERIALIZED VIEW PFAM_PRICE_FIX_ACTION_MAPPING;
DROP TABLE PFAM_PRICE_FIX_ACTION_MAPPING;
CREATE MATERIALIZED VIEW  PFAM_PRICE_FIX_ACTION_MAPPING  REFRESH FAST ON DEMAND WITH PRIMARY KEY AS  SELECT * FROM  PFAM_PRICE_FIX_ACTION_MAPPING@eka_appdb;

create table MBV_ALLOCATION_REPORT_HEADER
( PROCESS_ID                     VARCHAR2(15),
  EOD_TRADE_DATE                 DATE,
  CORPORATE_ID                   VARCHAR2(15),
  CORPORATE_NAME                 VARCHAR2(100),
  PRODUCT_ID                     VARCHAR2(15),
  PRODUCT_NAME                   VARCHAR2(200),
  OPENING_BALANCE_QTY            NUMBER(25,5));

-- Create table
create table MBV_DERIVATIVE_DIFF_REPORT
(
  PROCESS_ID                 VARCHAR2(15),
  PROCESS_DATE               DATE,
  CORPORATE_ID               VARCHAR2(15),
  CORPORATE_NAME             VARCHAR2(100),
  PRODUCT_ID                 VARCHAR2(15),
  PRODUCT_NAME               VARCHAR2(200),
  EXCHANGE_ID                VARCHAR2(15),
  EXCHANGE_NAME              VARCHAR2(200),
  INSTRUMENT_ID              VARCHAR2(15),
  INSTRUMENT_NAME            VARCHAR2(200),
  INTERNAL_DERIVATIVE_REF_NO VARCHAR2(10),
  DERIVATIVE_REF_NO          VARCHAR2(30),
  EXTERNAL_REF_NO            VARCHAR2(50),
  TRADE_DATE                 DATE,
  TRADE_TYPE                 VARCHAR2(4),
  TRADE_QTY                  NUMBER(25,5),
  TRADE_QTY_UNIT             VARCHAR2(50),
  TRADE_QTY_UNIT_ID          VARCHAR2(15),
  TRADE_PRICE                NUMBER(25,5),
  TRADE_PRICE_UNIT           VARCHAR2(50),
  TRADE_PRICE_UNIT_ID        VARCHAR2(50),
  PROMPT_DATE                VARCHAR2(15),
  VALUATION_PRICE            NUMBER(25,5),
  VALUATION_PRICE_UNIT       VARCHAR2(50),
  VALUATION_PRICE_UNIT_ID    VARCHAR2(50),
  TRADE_VALUE_IN_TRADE_CCY   NUMBER(25,5),
  MARKET_VALUE_IN_TRADE_CCY  NUMBER(25,5),
  PNL_IN_TRADE_CCY           NUMBER(25,5),
  PNL_IN_BASE_CCY            NUMBER(25,5),
  FX_TRADE_TO_BASE_CCY       NUMBER(25,10),
  MONTH_END_PRICE            NUMBER(25,5),
  MONTH_END_PRICE_UNIT       VARCHAR2(50),
  MONTH_END_PRICE_UNIT_ID    VARCHAR2(50),
  MEP_VALUE_IN_BASE_CCY      NUMBER(25,5),
  SETT_VALUE_IN_BASE_CCY     NUMBER(25,5),
  FX_MEP_CCY_TO_BASE_CCY     NUMBER(25,10),
  VALUE_DIFF_IN_BASE_CCY     NUMBER(25,5),
  FX_SETT_CCY_TO_BASE_CCY    NUMBER(25,10),
  BASE_CUR_ID                VARCHAR2(15),
  BASE_CUR_CODE              VARCHAR2(15),
  TP_CUR_ID                  VARCHAR2(15),
  TP_CUR_CODE                VARCHAR2(50),
  VP_CUR_ID                  VARCHAR2(15),
  VP_CUR_CODE                VARCHAR2(50),
  MEP_CUR_ID                 VARCHAR2(15),
  MEP_CUR_CODE               VARCHAR2(50)
);
-- Add comments to the columns 
comment on column MBV_DERIVATIVE_DIFF_REPORT.VALUE_DIFF_IN_BASE_CCY
  is 'Calculated : difference between MEP_VALUE_IN_BASE_CCY,SETT_VALUE_IN_BASE_CCY';

-- Add comments to the columns 
comment on column MBV_DERIVATIVE_DIFF_REPORT.TRADE_VALUE_IN_TRADE_CCY
  is 'From CDC';
comment on column MBV_DERIVATIVE_DIFF_REPORT.MARKET_VALUE_IN_TRADE_CCY
  is 'From CDC';
comment on column MBV_DERIVATIVE_DIFF_REPORT.PNL_IN_TRADE_CCY
  is 'From CDC';
comment on column MBV_DERIVATIVE_DIFF_REPORT.PNL_IN_BASE_CCY
  is 'From CDC';
comment on column MBV_DERIVATIVE_DIFF_REPORT.FX_TRADE_TO_BASE_CCY
  is 'From CDC';
comment on column MBV_DERIVATIVE_DIFF_REPORT.MONTH_END_PRICE
  is 'From Metals';
comment on column MBV_DERIVATIVE_DIFF_REPORT.MONTH_END_PRICE_UNIT
  is 'From Metals';
comment on column MBV_DERIVATIVE_DIFF_REPORT.MONTH_END_PRICE_UNIT_ID
  is 'From Metals';

comment on column MBV_DERIVATIVE_DIFF_REPORT.MEP_VALUE_IN_BASE_CCY
  is 'Month End Value in base currency'; 
comment on column MBV_DERIVATIVE_DIFF_REPORT.FX_MEP_CCY_TO_BASE_CCY
  is 'Corp Fx rate from MEP to base currency';
comment on column MBV_DERIVATIVE_DIFF_REPORT.FX_SETT_CCY_TO_BASE_CCY
  is 'Corp Fx rate from Settlement price to base currency';

comment on column MBV_DERIVATIVE_DIFF_REPORT.TP_CUR_ID
  is 'Trade Price Main Currency id';
comment on column MBV_DERIVATIVE_DIFF_REPORT.TP_CUR_CODE
  is 'Trade Price Main Currency code';
comment on column MBV_DERIVATIVE_DIFF_REPORT.VP_CUR_ID
  is 'Valuation Price Main Currency id';
comment on column MBV_DERIVATIVE_DIFF_REPORT.VP_CUR_CODE
  is 'Valuation Price Main Currency code';
comment on column MBV_DERIVATIVE_DIFF_REPORT.MEP_CUR_ID
  is 'Month end Price Main Currency id';
comment on column MBV_DERIVATIVE_DIFF_REPORT.MEP_CUR_CODE
  is 'Month end Price Main Currency code';

CREATE INDEX IDX_PFRD1 ON PFRD_PRICE_FIX_REPORT_DETAIL(CORPORATE_ID,EOD_TRADE_DATE);
CREATE INDEX IDX_PFRH1 ON PFRH_PRICE_FIX_REPORT_HEADER(EOD_TRADE_DATE);


