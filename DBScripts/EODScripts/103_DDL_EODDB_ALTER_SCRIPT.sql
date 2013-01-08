DROP TABLE GED_GMR_EXCHANGE_DETAIL;

CREATE TABLE GED_GMR_EXCHANGE_DETAIL(
CORPORATE_ID         VARCHAR2(15),
INTERNAL_GMR_REF_NO  VARCHAR2(15),
INSTRUMENT_ID        VARCHAR2(15),
INSTRUMENT_NAME      VARCHAR2(100),
DERIVATIVE_DEF_ID    VARCHAR2(15),
DERIVATIVE_DEF_NAME  VARCHAR2(100),
EXCHANGE_ID          VARCHAR2(15),
EXCHANGE_NAME        VARCHAR2(100),
ELEMENT_ID           VARCHAR2(15),
PRICE_SOURCE_ID      VARCHAR2(15),
PRICE_SOURCE_NAME    VARCHAR2(30),
AVAILABLE_PRICE_ID   VARCHAR2(15),
AVAILABLE_PRICE_NAME VARCHAR2(30),
PRICE_UNIT_NAME      VARCHAR2(50),
PPU_PRICE_UNIT_ID    VARCHAR2(15),
PRICE_UNIT_ID        VARCHAR2(15),
DELIVERY_CALENDER_ID VARCHAR2(15),
IS_DAILY_CAL_APPLICABLE VARCHAR2(1),
IS_MONTHLY_CAL_APPLICABLE VARCHAR2(1));

DROP TABLE PAGE_PRICE_ALLOC_GMR_EXCHANGE;

CREATE TABLE PAGE_PRICE_ALLOC_GMR_EXCHANGE(
PROCESS_ID           VARCHAR2(15),
INTERNAL_GMR_REF_NO  VARCHAR2(15),
INSTRUMENT_ID        VARCHAR2(15),
INSTRUMENT_NAME      VARCHAR2(50),
DERIVATIVE_DEF_ID    VARCHAR2(15),
DERIVATIVE_DEF_NAME  VARCHAR2(50),
EXCHANGE_ID          VARCHAR2(15 ),
EXCHANGE_NAME        VARCHAR2(100),
ELEMENT_ID           VARCHAR2(15),
PRICE_SOURCE_ID      VARCHAR2(15),
PRICE_SOURCE_NAME    VARCHAR2(30),
AVAILABLE_PRICE_ID   VARCHAR2(15),
AVAILABLE_PRICE_NAME VARCHAR2(30),
PRICE_UNIT_NAME      VARCHAR2(50),
PPU_PRICE_UNIT_ID    VARCHAR2(15),
PRICE_UNIT_ID        VARCHAR2(15),
DELIVERY_CALENDER_ID VARCHAR2(15),
IS_DAILY_CAL_APPLICABLE VARCHAR2(1),
IS_MONTHLY_CAL_APPLICABLE VARCHAR2(1));


CREATE TABLE GFOC_GMR_FREIGHT_OTHER_CHARGE(
PROCESS_ID                      VARCHAR2(15 CHAR),
INTERNAL_GMR_REF_NO             VARCHAR2(15 CHAR),
INTERNAL_CONTRACT_REF_NO        VARCHAR2(15 CHAR),
IS_WNS_CREATED                  VARCHAR2(1 CHAR),
IS_INVOICED                     VARCHAR2(1 CHAR),
NO_OF_BAGS                      NUMBER(10),
NO_OF_SUBLOTS                   NUMBER(10),
DRY_QTY                         NUMBER(25,10),
WET_QTY                         NUMBER(25,10),
SMALL_LOT_CHARGE                NUMBER(25,10),
CONTAINER_CHARGE                NUMBER(25,10),
SAMPLING_CHARGE                 NUMBER(25,10),
HANDLING_CHARGE                 NUMBER(25,10),
LOCATION_VALUE                  NUMBER(25,10),
FREIGHT_ALLOWANCE               NUMBER(25,10),
IS_APPLY_CONTAINER_CHARGE       CHAR(1 CHAR),
IS_APPLY_FREIGHT_ALLOWANCE      CHAR(1 CHAR),
LATEST_INTERNAL_INVOICE_REF_NO  VARCHAR2(15 CHAR),
SHIPPED_QTY                     NUMBER(25,10),
GMR_QTY_UNIT_ID                 VARCHAR2(15 CHAR));

CREATE TABLE GPQ_GMR_PAYABLE_QTY(
PROCESS_ID          VARCHAR2(15),
INTERNAL_GMR_REF_NO VARCHAR2(15),
ELEMENT_ID          VARCHAR2(15),
PAYABLE_QTY         NUMBER(25,10),
QTY_UNIT_ID         VARCHAR2(15));

CREATE TABLE PED_PENALTY_ELEMENT_DETAILS (
PROCESS_ID                        VARCHAR2(15),
INTERNAL_GMR_REF_NO                VARCHAR2(15),
INTERNAL_GRD_REF_NO                VARCHAR2(15),
ELEMENT_ID                        VARCHAR2(15),
ELEMENT_NAME                        VARCHAR2(30),
WEG_AVG_PRICING_ASSAY_ID        VARCHAR2(15),
ASSAY_QTY                        NUMBER(25,10),            
ASSAY_QTY_UNIT_ID                VARCHAR2(15),
GRD_WET_QTY                        NUMBER(25,10),
GRD_DRY_QTY                        NUMBER(25,10),
GRD_QTY_UNIT_ID                    VARCHAR2(15));

CREATE INDEX IDX_PED1 ON PED_PENALTY_ELEMENT_DETAILS(PROCESS_ID);

ALTER TABLE GETC_GMR_ELEMENT_TC_CHARGES ADD(
WEIGHT_TYPE                             VARCHAR2(3),
BASE_TC_VALUE                           NUMBER(25,10),
ESC_DESC_TC_VALUE                       NUMBER(25,10),
RANGE_TYPE								VARCHAR2(20));

ALTER TABLE GEPC_GMR_ELEMENT_PC_CHARGES ADD(
WEIGHT_TYPE                             VARCHAR2(3));

ALTER TABLE GRD_GOODS_RECORD_DETAIL ADD(
QTY_UNIT                            VARCHAR2(15),
DRY_WET_RATIO                       NUMBER(25,10),
GRD_TO_GMR_QTY_FACTOR               NUMBER,
QUALITY_NAME                        VARCHAR2(200),
PROFIT_CENTER_SHORT_NAME            VARCHAR2(15),
PROFIT_CENTER_NAME                  VARCHAR2(30),
ASSAY_HEADER_ID                     VARCHAR2(15),
WEG_AVG_PRICING_ASSAY_ID           VARCHAR2(15),
CONC_PRODUCT_ID                     VARCHAR2(15),
CONC_PRODUCT_NAME                   VARCHAR2(100),
PRODUCT_NAME                   VARCHAR2(100) );

ALTER TABLE GMR_GOODS_MOVEMENT_RECORD ADD(
DRY_QTY                               NUMBER(35,10),
WET_QTY                               NUMBER(35,10),
INVOICE_REF_NO                        VARCHAR2(15),
WAREHOUSE_NAME                        VARCHAR2(100),
IS_NEW_MTD                            VARCHAR2(1) DEFAULT 'N',
IS_NEW_YTD                            VARCHAR2(1) DEFAULT 'N',
IS_ASSAY_UPDATED_MTD                  VARCHAR2(1) DEFAULT 'N',
IS_ASSAY_UPDATED_YTD                  VARCHAR2(1) DEFAULT 'N',
ASSAY_FINAL_STATUS                    VARCHAR2(100),
QUALITY_NAME                          VARCHAR2(200),
INVOICE_CUR_ID                        VARCHAR2(15),
INVOICE_CUR_CODE                      VARCHAR2(15),
INVOICE_CUR_DECIMALS                  NUMBER(2),
GMR_STATUS                            VARCHAR2(30),
SHED_NAME                            VARCHAR2(50) );

ALTER TABLE GEPD_GMR_ELEMENT_PLEDGE_DETAIL ADD(
PLEDGE_INPUT_GMR_REF_NO VARCHAR2(15),
SUPPLIER_CP_NAME        VARCHAR2(100),
ELEMENT_NAME            VARCHAR2(30));

ALTER TABLE PCI_PHYSICAL_CONTRACT_ITEM ADD(M2M_INCOTERM_DESC VARCHAR2(20));

ALTER TABLE GMR_GOODS_MOVEMENT_RECORD ADD
(LOADING_COUNTRY_NAME VARCHAR2(50),
LOADING_CITY_NAME VARCHAR2(50),
LOADING_STATE_NAME VARCHAR2(50),
LOADING_REGION_ID VARCHAR2(15),
LOADING_REGION_NAME  VARCHAR2(50),
DISCHARGE_COUNTRY_NAME VARCHAR2(50),
DISCHARGE_CITY_NAME VARCHAR2(50),
DISCHARGE_STATE_NAME VARCHAR2(50),
DISCHARGE_REGION_ID VARCHAR2(15),
DISCHARGE_REGION_NAME VARCHAR2(50));

ALTER TABLE GMR_GOODS_MOVEMENT_RECORD ADD(
LOADING_COUNTRY_CUR_ID VARCHAR2(15),
LOADING_COUNTRY_CUR_CODE VARCHAR2(15),
DISCHARGE_COUNTRY_CUR_ID VARCHAR2(15),
DISCHARGE_COUNTRY_CUR_CODE VARCHAR2(15));

ALTER TABLE PCPD_PC_PRODUCT_DEFINITION ADD (PRODUCT_NAME VARCHAR2(100));

ALTER TABLE PCM_PHYSICAL_CONTRACT_MAIN ADD(
INVOICE_CUR_CODE VARCHAR2(15),
CP_NAME          VARCHAR2(100),
INVOICE_CUR_DECIMALS NUMBER(2));

DROP VIEW V_SPQ_LATEST_ASSAY;

DROP TABLE TGOC_TEMP_GMR_OTHER_CHARGE;

ALTER TABLE CGCP_CONC_GMR_COG_PRICE DROP COLUMN INTERNAL_GRD_REF_NO;

DROP TABLE CR_CUSTOMS_REPORT;
DROP TABLE TCR_TEMP_CR;

ALTER TABLE GEPD_GMR_ELEMENT_PLEDGE_DETAIL ADD PLEDGE_CP_NAME VARCHAR2(100);

ALTER TABLE GETC_GMR_ELEMENT_TC_CHARGES ADD CHARGE_TYPE VARCHAR2(10);
