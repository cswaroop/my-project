ALTER TABLE ICC_INVOICE_CONTAINER_CHARGES 
drop CONSTRAINT FK_ICC_STOCK_ID;

CREATE TABLE IS_DC_CHILD_D
(
  INTERNAL_INVOICE_REF_NO  VARCHAR2(30 CHAR),
  INTERNAL_DOC_REF_NO      VARCHAR2(30 CHAR),
  DESCRIPTION              VARCHAR2(30 CHAR),
  INVOICED_WEIGHT          VARCHAR2(30 CHAR),
  NEW_INVOICED_WEIGHT      VARCHAR2(30 CHAR),
  INVOICE_PRICE            VARCHAR2(30 CHAR),
  NEW_INVOICE_PRICE        VARCHAR2(30 CHAR),
  AMOUNT                   VARCHAR2(30 CHAR),
  NEW_AMOUNT               VARCHAR2(30 CHAR),
  OLD_INVOICE_AMOUNT       VARCHAR2(30 CHAR),
  NEW_INVOICE_AMOUNT       VARCHAR2(30 CHAR),
  NET_ADJUSTMENT           VARCHAR2(30 CHAR),
  OLD_PRICE_UNIT_NAME      VARCHAR2(30 CHAR),
  NEW_PRICE_UNIT_NAME      VARCHAR2(30 CHAR),
  OLD_INVOICE_CUR_UNIT     VARCHAR2(30 CHAR),
  NEW_INVOICE_CUR_UNIT     VARCHAR2(30 CHAR),
  INVOICE_CUR_UNIT         VARCHAR2(30 CHAR),
  INVOICE_QTY_UNIT_NAME    VARCHAR2(30 CHAR)
);