CREATE TABLE PFRH_PRICE_FIX_REPORT_HEADER(
PROCESS_ID                         VARCHAR2(15),
EOD_TRADE_DATE                     DATE,
CORPORATE_ID                       VARCHAR2(15),
CORPORATE_NAME                     VARCHAR2(100),
PRODUCT_ID                         VARCHAR2(15),
PRODUCT_NAME                       VARCHAR2(200),
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
CP_ID                              VARCHAR2(15),
CP_NAME                            VARCHAR2(100),
INTERNAL_CONTRACT_REF_NO           VARCHAR2(15),
DELIVERY_ITEM_NO                   VARCHAR2(20),
CONTRACT_REF_NO_DEL_ITEM_NO        VARCHAR2(50),
INTERNAL_GMR_REF_NO                VARCHAR2(15),
GMR_REF_NO                         VARCHAR2(15),
PRICE_FIXED_DATE                   DATE,    
PF_REF_NO                          VARCHAR2(100),
FIXED_QTY                          NUMBER(25,10),
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

CREATE TABLE DDR_DERIVATIVE_DIFF_REPORT(
PROCESS_ID                         VARCHAR2(15),
EOD_TRADE_DATE                     DATE,
CORPORATE_ID                       VARCHAR2(15),
CORPORATE_NAME                     VARCHAR2(100),
PRODUCT_ID                         VARCHAR2(15),
PRODUCT_NAME                       VARCHAR2(200),
EXCHANGE_ID                        VARCHAR2(15),
EXCHANGE_NAME                      VARCHAR2(200),
INSTRUMENT_ID                      VARCHAR2(15),
INSTRUMENT_NAME                    VARCHAR2(200),
TRADE_DATE                         DATE,
INTERNAL_DERIVATIVE_REF_NO         VARCHAR2(10),
DERIVATIVE_REF_NO                  VARCHAR2(30),
EXTERNAL_REF_NO                    VARCHAR2(50),
TRADE_TYPE                         VARCHAR2(4),
TRADE_QTY                          NUMBER(25,5),
TRADE_PRICE                        NUMBER(25,5),
TRADE_PRICE_UNIT                   VARCHAR2(50),
PROMPT_DATE                        VARCHAR2(15),
FX_TRADE_TO_BASE_CCY               NUMBER(25,10),
TRADE_PRICE_IN_BASE_CCY            NUMBER(25,5),
TRADE_VALUE_IN_BASE_CCY           NUMBER(25,5),
VALUATION_PRICE                    NUMBER(25,5),
FX_VALUATION_TO_BASE_CCY           NUMBER(25,10),
VALUATION_PRICE_IN_BASE_CCY        NUMBER(25,5),
MONTH_END_PRICE                    NUMBER(25,5),
MONTH_END_PRICE_IN_BASE_CCY        NUMBER(25,5),
REF_PRICE_DIFF                     NUMBER(25,5),
VALUE_DIFF_REF_PRICE_DIFF          NUMBER(25,5));

CREATE TABLE MBVM_METAL_BALANCE_VAL_MAIN(
PROCESS_ID                         VARCHAR2(15),
EOD_TRADE_DATE                     DATE,
CORPORATE_ID                       VARCHAR2(15),
CORPORATE_NAME                     VARCHAR2(100),
PRODUCT_ID                         VARCHAR2(15),
PRODUCT_NAME                       VARCHAR2(200),
EXCHANGE_ID                        VARCHAR2(15),
EXCHANGE_NAME                      VARCHAR2(200),
PHY_REALIZED_OB                    NUMBER(25,5),
PHY_REALIZED_QTY                   NUMBER(25,5),
PHY_REALIZED_PNL                   NUMBER(25,5),
PHY_UNREAL_PRICE_INV_QTY           NUMBER(25,5),
PHY_UNR_PRICE_INV_PRICE            NUMBER(25,5),
PHY_UNR_PRICE_INV_M2M_PRICE        NUMBER(25,5),
PHY_UNREAL_PRICE_NA_INV_QTY        NUMBER(25,5),
PHY_UNR_PRICE_NA_INV_PRICE         NUMBER(25,5),
PHY_UNR_PRICE_NA_INV_M2M_PRICE     NUMBER(25,5),
PHY_UNREAL_PRICE_ND_INV_QTY        NUMBER(25,5),
PHY_UNR_PRICE_ND_INV_PRICE         NUMBER(25,5),
PHY_UNR_PRICE_ND_INV_M2M_PRICE     NUMBER(25,5),
REFERENTIAL_PRICE_DIFF             NUMBER(25,5),
CONTANGO_BW_DIFF                   NUMBER(25,5),
PRICED_ARRIVED_QTY                 NUMBER(25,5),
PRICED_NOT_ARRIVED_QTY             NUMBER(25,5),
UNPRICED_ARRIVED_QTY               NUMBER(25,5),
UNPRICED_NOT_ARRIVED_QTY           NUMBER(25,5),
PRICED_DELIVERED_QTY               NUMBER(25,5),
PRICED_NOT_DELIVERED_QTY           NUMBER(25,5),
UNPRICED_DELIVERED_QTY             NUMBER(25,5),
UNPRICED_NOT_DELIVERED_QTY         NUMBER(25,5),
METAL_DEBT_QTY                     NUMBER(25,5),
METAL_DEBT_VALUE                   NUMBER(25,5),
INVENTORY_UNREAL_PNL               NUMBER(25,5));

CREATE TABLE MBVD_METAL_BALANCE_VAL_DER(
PROCESS_ID                         VARCHAR2(15),
EOD_TRADE_DATE                     DATE,
CORPORATE_ID                       VARCHAR2(15),
CORPORATE_NAME                     VARCHAR2(100),
PRODUCT_ID                         VARCHAR2(15),
PRODUCT_NAME                       VARCHAR2(200),
EXCHANGE_ID                        VARCHAR2(15),
EXCHANGE_NAME                      VARCHAR2(200),
INSTRUMENT_ID                      VARCHAR2(15),
INSTRUMENT_NAME                    VARCHAR2(15),
MONTH_END_PRICE                    NUMBER(25,5),
REALIZED_QTY                       NUMBER(25,5),
REALIZED_PNL                       NUMBER(25,5),
UNREALIZED_PNL                     NUMBER(25,5));