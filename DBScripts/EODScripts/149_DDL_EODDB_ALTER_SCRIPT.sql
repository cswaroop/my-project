ALTER TABLE PFRD_PRICE_FIX_REPORT_DETAIL ADD(
BASE_PRICE_UNIT_ID                       VARCHAR2(15),
BASE_PRICE_UNIT_NAME                     VARCHAR2(50));

ALTER TABLE PFRH_PRICE_FIX_REPORT_HEADER ADD(
BASE_PRICE_UNIT_ID                       VARCHAR2(15),
BASE_PRICE_UNIT_NAME                     VARCHAR2(50));

ALTER TABLE PFRHE_PFRH_EXTENSION ADD(
BASE_PRICE_UNIT_ID                       VARCHAR2(15),
BASE_PRICE_UNIT_NAME                     VARCHAR2(50));

CREATE TABLE ART1_ARRIVAL_REPORT_TEMP1(
GMR_REF_NO                VARCHAR2(30),
INTERNAL_GMR_REF_NO       VARCHAR2(15),
INTERNAL_GRD_REF_NO       VARCHAR2(15),
INTERNAL_STOCK_REF_NO     VARCHAR2(30),
CORPORATE_ID              VARCHAR2(15),
WAREHOUSE_PROFILE_ID      VARCHAR2(15),
WAREHOUSE_NAME            VARCHAR2(100),
SHED_ID                   VARCHAR2(15),
STORAGE_LOCATION_NAME     VARCHAR2(50),
PRODUCT_ID                VARCHAR2(15),
PRODUCT_NAME              VARCHAR2(200),
QUALITY_ID                VARCHAR2(15),
QUALITY_NAME              VARCHAR2(200),
WET_QTY                   NUMBER(25,5),
DRY_QTY                   NUMBER(25,5),
QTY_UNIT_ID               VARCHAR2(15),
QTY_UNIT                  VARCHAR2(15),
ELEMENT_ID                VARCHAR2(15),
ATTRIBUTE_NAME            VARCHAR2(30),
UNDERLYING_PRODUCT_ID     VARCHAR2(15),
UNDERLYING_PRODUCT_NAME   VARCHAR2(200),
BASE_QUANTITY_UNIT_ID     VARCHAR2(15),
BASE_QUANTITY_UNIT        VARCHAR2(15),
ASSAY_CONTENT             NUMBER(25,5),
ASSAY_QTY_UNIT_ID         VARCHAR2(15),
ASSAY_QTY_UNIT            VARCHAR2(15),
PAYABLE_QTY               NUMBER(25,5),
PAYABLE_QTY_UNIT_ID       VARCHAR2(15),
PAYABLE_QTY_UNIT          VARCHAR2(15),
ARRIVAL_STATUS            VARCHAR2(50),
CONC_BASE_QTY_UNIT_ID     VARCHAR2(15),
CONC_BASE_QTY_UNIT        VARCHAR2(15),
GRD_BASE_QTY_CONV_FACTOR  NUMBER,
PCDI_ID                   VARCHAR2(15),
PAY_CUR_ID                VARCHAR2(15),
PAY_CUR_CODE              VARCHAR2(15),
PAY_CUR_DECIMALS          NUMBER(2),
SECTION_NAME              VARCHAR2(15),
GRD_TO_GMR_QTY_FACTOR     NUMBER,
QTY_TYPE                  VARCHAR2(20),
GMR_WET_QTY               NUMBER(25,5),
ARRIVAL_OR_DELIVERY       VARCHAR2(15));

CREATE INDEX IDX_ART11 ON ART1_ARRIVAL_REPORT_TEMP1(CORPORATE_ID);

CREATE TABLE FCT1_FC_TEMP1(
GMR_REF_NO                  VARCHAR2(30 ),
INTERNAL_GMR_REF_NO         VARCHAR2(15 ),
INTERNAL_GRD_REF_NO         VARCHAR2(15 ),
INTERNAL_STOCK_REF_NO       VARCHAR2(30 ),
SUPP_INTERNAL_GMR_REF_NO    VARCHAR2(15 ),
SUPP_GMR_REF_NO             VARCHAR2(30 ),
CORPORATE_ID                VARCHAR2(15 ),
WAREHOUSE_PROFILE_ID        VARCHAR2(15 ),
COMPANYNAME                 VARCHAR2(100 ),
SHED_ID                     VARCHAR2(15 ),
STORAGE_LOCATION_NAME       VARCHAR2(50 ),
PRODUCT_ID                  VARCHAR2(15 ),
PRODUCT_DESC                VARCHAR2(200 ),
QUALITY_ID                  VARCHAR2(15 ),
QUALITY_NAME                VARCHAR2(200 ),
QTY                         NUMBER(25,10),
DRY_WET_QTY_RATIO           NUMBER(25,10),
WET_QTY                     NUMBER(25,10),
DRY_QTY                     NUMBER(25,10),
QTY_UNIT_ID                 VARCHAR2(15 ),
QTY_UNIT                    VARCHAR2(15 ),
ELEMENT_ID                  VARCHAR2(15 ),
ATTRIBUTE_NAME              VARCHAR2(30 ),
UNDERLYING_PRODUCT_ID       VARCHAR2(15 ),
UNDERLYING_PRODUCT_NAME     VARCHAR2(100 ),
BASE_QUANTITY_UNIT_ID       VARCHAR2(15 ),
BASE_QUANTITY_UNIT          VARCHAR2(15 ),
ASSAY_QTY                   NUMBER(25,10),
ASSAY_QTY_UNIT_ID           VARCHAR2(15 ),
ASSAY_QTY_UNIT              VARCHAR2(15 ),
PAYABLE_QTY                 NUMBER(25,10),
PAYABLE_QTY_UNIT_ID         VARCHAR2(15 ),
PAYABLE_QTY_UNIT            VARCHAR2(15 ),
POOL_NAME                   VARCHAR2(50 ),
CONC_BASE_QTY_UNIT_ID       VARCHAR2(15 ),
CONC_BASE_QTY_UNIT          VARCHAR2(15 ),
PAY_CUR_ID                  VARCHAR2(15 ),
PAY_CUR_CODE                VARCHAR2(15 ),
QTY_TYPE                    VARCHAR2(10 ),
PARENT_INTERNAL_GRD_REF_NO  VARCHAR2(15 ),
SECTION_NAME                VARCHAR2(15 ),
GRD_BASE_QTY_CONV_FACTOR    NUMBER,
PCDI_ID                     VARCHAR2(15 ),
PAY_CUR_DECIMALS            NUMBER(2),
FEEDING_POINT_ID            VARCHAR2(15 ),
FEEDING_POINT_NAME          VARCHAR2(30 ),
GRD_TO_GMR_QTY_FACTOR       NUMBER);

CREATE INDEX IDX_FCT11 ON FCT1_FC_TEMP1(CORPORATE_ID);

CREATE TABLE TCBP_TEMP_CB_PARENT_GRD(
CORPORATE_ID VARCHAR2(15),
PARENT_INTERNAL_GRD_REF_NO  VARCHAR2(15),
PARENT_INTERNAL_GMR_REF_NO  VARCHAR2(15));

CREATE INDEX IDX_TCBP1 ON TCBP_TEMP_CB_PARENT_GRD(CORPORATE_ID);

CREATE TABLE TGG_TEMP_GRD_GMR(
CORPORATE_ID    VARCHAR2(15),
SUPP_INTERNAL_GMR_REF_NO VARCHAR2(15),
SUPP_GMR_REF_NO VARCHAR2(30));

CREATE INDEX IDX_TGG1 ON TGG_TEMP_GRD_GMR(CORPORATE_ID);

CREATE TABLE TSPQ_TEMP_SPQ_ASM(
CORPORATE_ID VARCHAR2(15),
INTERNAL_GRD_REF_NO VARCHAR2(15),
DRY_WET_QTY_RATIO NUMBER,
ASSAY_HEADER_ID VARCHAR2(15),
WEG_AVG_PRICING_ASSAY_ID VARCHAR2(15));

CREATE INDEX IDX_TSPQ1 ON TSPQ_TEMP_SPQ_ASM(CORPORATE_ID);

CREATE TABLE TGMRC_GMR_CONTRACT_DETAILS(
CORPORATE_ID                VARCHAR2(15),
INTERNAL_GMR_REF_NO         VARCHAR2(15),
CONTRACT_REF_NO             VARCHAR2(30),
INTERNAL_CONTRACT_REF_NO    VARCHAR2(15),
CONTRACT_TYPE               VARCHAR2(15),
CP_ID                       VARCHAR2(15),
CP_NAME                     VARCHAR2(100),
INVOICE_CUR_ID              VARCHAR2(15),
INVOICE_CUR_CODE            VARCHAR2(15),
INVOICE_CUR_DECIMALS        NUMBER(2),
IS_TOLLING_CONTRACT         VARCHAR2(1),
PCM_CONTRACT_TYPE           VARCHAR2(15));

CREATE INDEX IDX_TGMRC1 ON TGMRC_GMR_CONTRACT_DETAILS(CORPORATE_ID);

DROP MATERIALIZED VIEW FMPFD_PRICE_FIXATION_DETAILS;
DROP TABLE FMPFD_PRICE_FIXATION_DETAILS;
CREATE MATERIALIZED VIEW  FMPFD_PRICE_FIXATION_DETAILS  REFRESH FAST ON DEMAND WITH PRIMARY KEY AS  SELECT * FROM  FMPFD_PRICE_FIXATION_DETAILS@eka_appdb;


DROP MATERIALIZED VIEW FMPFAM_PRICE_ACTION_MAPPING;
DROP TABLE FMPFAM_PRICE_ACTION_MAPPING;
CREATE MATERIALIZED VIEW  FMPFAM_PRICE_ACTION_MAPPING  REFRESH FAST ON DEMAND WITH PRIMARY KEY AS  SELECT * FROM  FMPFAM_PRICE_ACTION_MAPPING@eka_appdb;