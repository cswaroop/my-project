CREATE TABLE TGI_TEMP_GMR_INVOICE
(
  CORPORATE_ID               VARCHAR2(15),
  PROCESS_ID                 VARCHAR2(15),
  INTERNAL_GMR_REF_NO        VARCHAR2(15),
  INTERNAL_INVOICE_REF_NO    VARCHAR2(15),
  INVOICE_ITEM_AMOUNT        NUMBER(25,10),
  INVOICE_CURRENCY_ID        VARCHAR2(15),
  INVOICE_TYPE               VARCHAR2(25),
  INVOICE_ISSUE_DATE         DATE,
  NEW_INVOICE_PRICE_UNIT_ID  VARCHAR2(15),
  INVOICE_REF_NO             VARCHAR2(30));
  
CREATE INDEX IDX_TGI1 ON TGI_TEMP_GMR_INVOICE(PROCESS_ID);
CREATE INDEX IDX_TGI2 ON TGI_TEMP_GMR_INVOICE(CORPORATE_ID);
 
CREATE TABLE TGC_TEMP_GMR_CHARGES
(
  CORPORATE_ID               VARCHAR2(15),
  INTERNAL_GMR_REF_NO        VARCHAR2(15),
  ELEMENT_ID                 VARCHAR2(15),
  INTERNAL_INVOICE_REF_NO    VARCHAR2(15),
  TC_AMT                     NUMBER(25,10),
  RC_AMT                     NUMBER(25,10),
  PENALTY_AMT                NUMBER(25,10),
  FREIGHT_AMT                NUMBER(25,10),
  OTHER_CHARGES_AMT          NUMBER(25,10),
  PROVISIONAL_PYMT_PCTG      NUMBER(10,4));  

CREATE INDEX IDX_TGC1 ON TGC_TEMP_GMR_CHARGES(INTERNAL_GMR_REF_NO,ELEMENT_ID,INTERNAL_INVOICE_REF_NO);
CREATE INDEX IDX_TGC2 ON TGC_TEMP_GMR_CHARGES(CORPORATE_ID);

ALTER TABLE PA_PURCHASE_ACCURAL_GMR ADD INTERNAL_GMR_REF_NO VARCHAR2(15);

ALTER TABLE PA_TEMP ADD LATEST_INTERNAL_INVOICE_REF_NO VARCHAR2(15);

ALTER TABLE PA_PURCHASE_ACCURAL_GMR ADD LATEST_INTERNAL_INVOICE_REF_NO VARCHAR2(15);

