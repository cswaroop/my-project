ALTER TABLE PATD_PA_TEMP_DATA ADD(
IS_AFLOAT                       VARCHAR2(1),
IS_PLEDGE                       VARCHAR2(1),
SUPP_INTERNAL_GMR_REF_NO        VARCHAR2(15),
SUPP_GMR_REF_NO                 VARCHAR2(15));

ALTER TABLE PA_TEMP ADD(
IS_AFLOAT                       VARCHAR2(1),
IS_PLEDGE                       VARCHAR2(1),
SUPP_INTERNAL_GMR_REF_NO        VARCHAR2(15),
SUPP_GMR_REF_NO                 VARCHAR2(15));

ALTER TABLE PA_PURCHASE_ACCURAL ADD(
IS_AFLOAT                       VARCHAR2(1),
IS_PLEDGE                       VARCHAR2(1),
SUPP_INTERNAL_GMR_REF_NO        VARCHAR2(15),
SUPP_GMR_REF_NO                 VARCHAR2(15));

ALTER TABLE PA_PURCHASE_ACCURAL_GMR ADD(
IS_AFLOAT                       VARCHAR2(1),
IS_PLEDGE                       VARCHAR2(1),
SUPP_INTERNAL_GMR_REF_NO        VARCHAR2(15),
SUPP_GMR_REF_NO                 VARCHAR2(15));

CREATE TABLE GEPD_GMR_ELEMENT_PLEDGE_DETAIL
(
  GEPD_ID                 VARCHAR2(15 )     NOT NULL,
  CORPORATE_ID            VARCHAR2(15 )     NOT NULL,
  ACTIVITY_ACTION_ID      VARCHAR2(30 )     NOT NULL,
  ACTIVITY_REF_NO         VARCHAR2(30 )     NOT NULL,
  ACTIVITY_DATE           DATE              NOT NULL,
  INTERNAL_GMR_REF_NO     VARCHAR2(15 )     NOT NULL,
  PLEDGE_INPUT_GMR        VARCHAR2(15 )     NOT NULL,
  SUPPLIER_CP_ID          VARCHAR2(20 )     NOT NULL,
  PLEDGE_CP_ID            VARCHAR2(20 )     NOT NULL,
  PRODUCT_ID              VARCHAR2(15 )     NOT NULL,
  ELEMENT_ID              VARCHAR2(15 )     NOT NULL,
  ELEMENT_TYPE            VARCHAR2(11 )     NOT NULL,
  PLEDGE_QTY              NUMBER(25,10)     NOT NULL,
  PLEDGE_QTY_UNIT_ID      VARCHAR2(15 )     NOT NULL,
  INTERNAL_ACTION_REF_NO  VARCHAR2(15 )     NOT NULL,
  VERSION                 NUMBER(10),
  IS_ACTIVE               CHAR(1 )          NOT NULL,
  QUALITY_ID              VARCHAR2(15 )     NOT NULL,
  DUE_DATE                DATE,
  EXT_PLEDGE_QTY          NUMBER(25,10),
  DBD_ID                  VARCHAR2(15 ),
  PROCESS_ID              VARCHAR2(15 ));

CREATE INDEX IDX_GEPD1 ON GEPD_GMR_ELEMENT_PLEDGE_DETAIL(PROCESS_ID,INTERNAL_GMR_REF_NO,IS_ACTIVE);

ALTER TABLE PCI_PHYSICAL_CONTRACT_ITEM ADD (
QP_START_DATE DATE,
QP_END_DATE DATE);

ALTER TABLE TMPC_TEMP_M2M_PRE_CHECK ADD(
QP_END_DATE               DATE,
QP_FX_DATE               DATE,
VALUATION_FX_DATE        DATE);


CREATE TABLE TSQ_TEMP_STOCK_QUALITY
(CORPORATE_ID                       VARCHAR2(15),
INTERNAL_GRD_REF_NO                 VARCHAR2(15),
INTERNAL_CONTRACT_ITEM_REF_NO       VARCHAR2(15),
INTERNAL_CONTRACT_REF_NO            VARCHAR2(15),
PCPQ_ID                             VARCHAR2(15));

CREATE INDEX IDX_TSQ1 ON TSQ_TEMP_STOCK_QUALITY(CORPORATE_ID,INTERNAL_GRD_REF_NO);
CREATE INDEX IDX_TSQ2 ON TSQ_TEMP_STOCK_QUALITY(INTERNAL_GRD_REF_NO);
CREATE INDEX IDX_TGI3 ON TGI_TEMP_GMR_INVOICE(PROCESS_ID,INTERNAL_GMR_REF_NO);
CREATE INDEX IDX_II1 ON II_INVOICABLE_ITEM(INTERNAL_GMR_REF_NO,STOCK_ID);
CREATE INDEX IDX_SAC1 ON SAC_STOCK_ASSAY_CONTENT(INTERNAL_GRD_REF_NO,ELEMENT_ID);
CREATE INDEX IDX_PCMTE1 ON PCMTE_PCM_TOLLING_EXT (INT_CONTRACT_REF_NO,TOLLING_SERVICE_TYPE);

ALTER TABLE CGCP_CONC_GMR_COG_PRICE MODIFY(
FIXED_QTY                             NUMBER(35,10),
UNFIXED_QTY                           NUMBER(35,10),
PAYABLE_QTY                           NUMBER(35,10));

ALTER TABLE CCCP_CONC_CONTRACT_COG_PRICE MODIFY(
FIXED_QTY                             NUMBER(35,10),
UNFIXED_QTY                           NUMBER(35,10),
PAYABLE_QTY                           NUMBER(35,10));

ALTER TABLE BGCP_BASE_GMR_COG_PRICE MODIFY(
FIXED_QTY                             NUMBER(35,10),
UNFIXED_QTY                           NUMBER(35,10),
QTY                                   NUMBER(35,10));

ALTER TABLE BCCP_BASE_CONTRACT_COG_PRICE MODIFY(
FIXED_QTY                             NUMBER(35,10),
UNFIXED_QTY                           NUMBER(35,10));