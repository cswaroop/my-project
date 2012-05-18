CREATE TABLE IEPD_D
(
  INTERNAL_INVOICE_REF_NO  VARCHAR2(30 CHAR),
  INVOICE_AMOUNT           NUMBER(25,10),
  DELIVERY_ITEM_REF_NO     VARCHAR2(50 CHAR),
  INTERNAL_GMR_REF_NO      VARCHAR2(30 CHAR),
  ELEMENT_ID               VARCHAR2(30 CHAR),
  ELEMENT_NAME             VARCHAR2(30 CHAR),
  FX_RATE                  NUMBER(25,10),
  GMR_REF_NO               VARCHAR2(50 CHAR),
  INVOICE_CUR_NAME         VARCHAR2(15 CHAR),
  INVOICE_PRICE_UNIT_NAME  VARCHAR2(50 CHAR),
  ADJUSTMENT               NUMBER(25,10),
  PRICE                    NUMBER(25,10),
  PRICE_FIXATION_DATE      DATE,
  PRICE_FIXATION_REF_NO    VARCHAR2(50 CHAR),
  PRICE_IN_PAY_IN_CUR      NUMBER(25,10),
  PRICING_CUR_NAME         VARCHAR2(15 CHAR),
  PRICING_PRICE_UNIT_NAME  VARCHAR2(50 CHAR),
  PRICING_TYPE             VARCHAR2(50 CHAR),
  PRODUCT_NAME             VARCHAR2(50 CHAR),
  QTY_PRICED               NUMBER(25,10),
  QTY_UNIT_NAME            VARCHAR2(15 CHAR),
  QP_START_DATE            DATE,
  QP_END_DATE              DATE,
  QP_PERIOD_TYPE           VARCHAR2(50 CHAR),
  INTERNAL_DOC_REF_NO      VARCHAR2(30 CHAR)
);

CREATE TABLE IEFPD_D
(
  INTERNAL_INVOICE_REF_NO      VARCHAR2(15 CHAR),
  INTERNAL_GMR_REF_NO          VARCHAR2(30 CHAR),
  GMR_REF_NO                   VARCHAR2(15 CHAR),
  ELEMENT_NAME                 VARCHAR2(30 CHAR),
  ELEMENT_ID                   VARCHAR2(30 CHAR),
  QTY_UNIT_NAME                VARCHAR2(15 CHAR),
  TOTAL_QTY_PRICED             NUMBER(25,10),
  WT_AVG_FX_RATE               NUMBER(25,10),
  WT_AVG_PRICE_IN_PRICING_CUR  NUMBER(25,10),
  PRICING_CUR_NAME             VARCHAR2(15 CHAR),
  WT_AVG_PRICE_IN_PAY_IN_CUR   NUMBER(25,10),
  PAY_IN_CUR_NAME              VARCHAR2(15 CHAR),
  INTERNAL_DOC_REF_NO          VARCHAR2(30 CHAR)
);

DROP SEQUENCE SEQ_IEFPD;

CREATE SEQUENCE SEQ_IEFPD
  START WITH 1
  MAXVALUE 1000000000000000000000000000
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;
  
DROP SEQUENCE SEQ_INVEPD;

CREATE SEQUENCE SEQ_INVEPD
  START WITH 1
  MAXVALUE 1000000000000000000000000000
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;  

CREATE TABLE IEFPD_IEF_PRICING_DETAIL
(
  IEFPD_ID                     VARCHAR2(15 CHAR),
  INTERNAL_INVOICE_REF_NO      VARCHAR2(15 CHAR),
  ELEMENT_ID                   VARCHAR2(15 CHAR),
  INTERNAL_GMR_REF_NO          VARCHAR2(15 CHAR),
  PCDI_ID                      VARCHAR2(15 CHAR),
  PRODUCT_ID                   VARCHAR2(15 CHAR),
  ELEMENT_NAME                 VARCHAR2(30 CHAR),
  QTY_UNIT_ID                  VARCHAR2(15 CHAR),
  QTY_UNIT_NAME                VARCHAR2(15 CHAR),
  TOTAL_QTY_PRICED             NUMBER(25,10),
  WT_AVG_FX_RATE               NUMBER(25,10),
  WT_AVG_PRICE_IN_PRICING_CUR  NUMBER(25,10),
  PRICING_CUR_ID               VARCHAR2(15 CHAR),
  PRICING_CUR_NAME             VARCHAR2(15 CHAR),
  WT_AVG_PRICE_IN_PAY_IN_CUR   NUMBER(25,10),
  PAY_IN_CUR_ID                VARCHAR2(15 CHAR),
  PAY_IN_CUR_NAME              VARCHAR2(15 CHAR),
  POFH_ID                      VARCHAR2(50 CHAR)
);

CREATE TABLE IEPD_INV_ELE_PRICING_DETAIL
(
  INVEPD_ID                VARCHAR2(15 CHAR),
  INTERNAL_INVOICE_REF_NO  VARCHAR2(15 CHAR),
  ELEMENT_ID               VARCHAR2(15 CHAR),
  INTERNAL_GMR_REF_NO      VARCHAR2(15 CHAR),
  PCDI_ID                  VARCHAR2(15 CHAR),
  PRODUCT_ID               VARCHAR2(15 CHAR),
  ELEMENT_NAME             VARCHAR2(30 CHAR),
  GMR_REF_NO               VARCHAR2(50 CHAR),
  PRICE_FIXATION_REF_NO    VARCHAR2(50 CHAR),
  PRICING_TYPE             VARCHAR2(50 CHAR),
  DELIVERY_ITEM_REF_NO     VARCHAR2(50 CHAR),
  PRICE_FIXATION_DATE      DATE,
  QTY_UNIT_ID              VARCHAR2(15 CHAR),
  QTY_UNIT_NAME            VARCHAR2(15 CHAR),
  QTY_PRICED               NUMBER(25,10),
  ADJUSTMENT               NUMBER(25,10),
  PRICE                    NUMBER(25,10),
  PRICING_CUR_ID           VARCHAR2(15 CHAR),
  PRICING_CUR_NAME         VARCHAR2(15 CHAR),
  FX_RATE                  NUMBER(25,10),
  PRICE_IN_PAY_IN_CUR      NUMBER(25,10),
  AMOUNT_IN_PAY_IN_CUR     NUMBER(25,10),
  PAY_IN_CUR_ID            VARCHAR2(15 CHAR),
  PAY_IN_CUR_NAME          VARCHAR2(15 CHAR),
  PAY_IN_PRICE_UNIT_ID     VARCHAR2(15 CHAR),
  PAY_IN_PRICE_UNIT_NAME   VARCHAR2(50 CHAR),
  PRICING_PRICE_UNIT_NAME  VARCHAR2(50 CHAR),
  PRICING_PRICE_UNIT_ID    VARCHAR2(15 CHAR),
  POFH_ID                  VARCHAR2(15 CHAR)
)