DROP TABLE DIWAP_DI_WEIGHTED_AVG_PRICE;

DROP TABLE PFRH_PRICE_FIX_REPORT_HEADER;

CREATE TABLE PFRH_PRICE_FIX_REPORT_HEADER(
PROCESS_ID                    VARCHAR2(15 ),
EOD_TRADE_DATE                DATE,
CORPORATE_ID                  VARCHAR2(15 ),
CORPORATE_NAME                VARCHAR2(100 ),
PRODUCT_ID                    VARCHAR2(15 ),
PRODUCT_NAME                  VARCHAR2(200 ),
INSTRUMENT_ID                 VARCHAR2(15 ),
INSTRUMENT_NAME               VARCHAR2(200 ),
PRICED_ARRIVED_QTY            NUMBER(25,5),
PRICED_DELIVERED_QTY          NUMBER(25,5),
REALIZED_QTY                  NUMBER(25,5),
REALIZED_QTY_PREV_MONTH       NUMBER(25,5),
REALIZED_QTY_CURRENT_MONTH    NUMBER(25,5),
REALIZED_VALUE                NUMBER(25,5),
PURCHASE_PRICE_FIX_QTY        NUMBER(25,5),
WAP_PURCHASE_PRICE_FIXATIONS  NUMBER(25,5),
SALES_PRICE_FIXATION_QTY      NUMBER(25,5),
WAP_SALES_PRICE_FIXATIONS     NUMBER(25,5),
PRICE_FIX_QTY_PURCHASE_OB     NUMBER(25,5),
PRICE_FIX_QTY_SALES_OB        NUMBER(25,5),
PRICE_FIX_QTY_PURCHASE_NEW    NUMBER(25,5),
PRICE_FIX_QTY_SALES_NEW       NUMBER(25,5),
BASE_QTY_UNIT_ID              VARCHAR2(15 ),
BASE_QTY_UNIT                 VARCHAR2(15 ),
BASE_CUR_DECIMALS             NUMBER(2),
BASE_QTY_DECIMALS             NUMBER(2),
WAP_PRICE_UNIT_ID             VARCHAR2(15 ),
WAP_PRICE_UNIT_NAME           VARCHAR2(50 ),
WAP_PRICE_CUR_ID              VARCHAR2(15 ),
WAP_PRICE_CUR_CODE            VARCHAR2(15 ),
WAP_PRICE_WEIGHT_UNIT_ID      VARCHAR2(15 ),
WAP_PRICE_WEIGHT_UNIT         VARCHAR2(15 ),
WAP_PRICE_WEIGHT              NUMBER(7,2));

CREATE INDEX IDX_PFRH1 ON PFRH_PRICE_FIX_REPORT_HEADER(CORPORATE_ID,EOD_TRADE_DATE,PRODUCT_ID);

DROP TABLE PFRD_PRICE_FIX_REPORT_DETAIL;
CREATE TABLE PFRD_PRICE_FIX_REPORT_DETAIL
(
  PROCESS_ID                   VARCHAR2(15 ),
  EOD_TRADE_DATE               DATE,
  SECTION_NAME                 VARCHAR2(100 ),
  PURCHASE_SALES               VARCHAR2(10 ),
  CORPORATE_ID                 VARCHAR2(15 ),
  CORPORATE_NAME               VARCHAR2(100 ),
  PRODUCT_ID                   VARCHAR2(15 ),
  PRODUCT_NAME                 VARCHAR2(200 ),
  ELEMENT_ID                   VARCHAR2(15 ),
  INSTRUMENT_ID                VARCHAR2(15 ),
  INSTRUMENT_NAME              VARCHAR2(200 ),
  CP_ID                        VARCHAR2(15 ),
  CP_NAME                      VARCHAR2(100 ),
  INTERNAL_CONTRACT_REF_NO     VARCHAR2(15 ),
  DELIVERY_ITEM_NO             VARCHAR2(20 ),
  CONTRACT_TYPE                VARCHAR2(20 ),
  PCDI_ID                      VARCHAR2(15 ),
  CONTRACT_REF_NO_DEL_ITEM_NO  VARCHAR2(50 ),
  PRICE_FIXED_DATE             DATE,
  INTERNAL_ACTION_REF_NO       VARCHAR2(15 ),
  PFD_ID                       VARCHAR2(15 ),
  IS_NEW_PFC                   VARCHAR2(1 ),
  PF_REF_NO                    VARCHAR2(100 ),
  FIXED_QTY                    NUMBER(25,10),
  FIXED_UNIT_BASE_QTY_FACTOR   NUMBER,
  PRICE                        NUMBER(25,10),
  PRICE_UNIT_ID                VARCHAR2(15 ),
  PRICE_UNIT_CUR_ID            VARCHAR2(15 ),
  PRICE_UNIT_CUR_CODE          VARCHAR2(15 ),
  PRICE_UNIT_WEIGHT_UNIT_ID    VARCHAR2(15 ),
  PRICE_UNIT_WEIGHT_UNIT       VARCHAR2(15 ),
  PRICE_UNIT_WEIGHT            NUMBER(7,2),
  PRICE_UNIT_NAME              VARCHAR2(50 ),
  FX_PRICE_TO_BASE_CUR         NUMBER(25,10),
  PRICE_IN_BASE_CUR            NUMBER(25,10),
  CONSUMED_QTY                 NUMBER(25,10),
  FIXATION_VALUE               NUMBER(25,10),
  BASE_QTY_UNIT_ID             VARCHAR2(15 ),
  BASE_QTY_UNIT                VARCHAR2(15 ),
  IS_FREE_METAL                VARCHAR2(1) DEFAULT 'N');

CREATE INDEX IDX_PFRD1 ON PFRD_PRICE_FIX_REPORT_DETAIL(CORPORATE_ID,EOD_TRADE_DATE,PRODUCT_ID);

CREATE TABLE PFRHE_PFRH_EXTENSION(
PROCESS_ID                    VARCHAR2(15 ),
EOD_TRADE_DATE                DATE,
CORPORATE_ID                  VARCHAR2(15 ),
CORPORATE_NAME                VARCHAR2(100 ),
PRODUCT_ID                    VARCHAR2(15 ),
PRODUCT_NAME                  VARCHAR2(200),
PURCHASE_SALES                VARCHAR2(10),
FIXED_QTY                     NUMBER(25,5),
WEIGHTED_AVG_PRICE            NUMBER(25,5),
FROM_SECTION_NAME             VARCHAR2(100),
SECTION_NAME                  VARCHAR2(100),
CONSUMED_QTY                  NUMBER(25,5),
FIXATION_VALUE                NUMBER(25,5));