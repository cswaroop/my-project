ALTER TABLE EVD_ECONOMIC_VALUE_DETAILS DROP PRIMARY KEY CASCADE;

DROP TABLE EVD_ECONOMIC_VALUE_DETAILS CASCADE CONSTRAINTS;

CREATE TABLE EVD_ECONOMIC_VALUE_DETAILS
(
  EVD_ID                    VARCHAR2(15),
  CORPORATE_ID              VARCHAR2(15),
  INTERNAL_ACTION_REF_NO    VARCHAR2(15),
  INTERNAL_CONTRACT_REF_NO  VARCHAR2(15),
  INTERNAL_GMR_REF_NO       VARCHAR2(15),
  STOCK_ID                  VARCHAR2(30),
  ELEMENT_ID                VARCHAR2(15),
  ELEMENT_TYPE              VARCHAR2(30),
  PCAR_ID                   VARCHAR2(15),
  WNSREFNO                  VARCHAR2(30),
  SELF_ASSAY_REF_NO         VARCHAR2(30),
  CP_ASSAY_REF_NO           VARCHAR2(30),
  SUBLOT_NO                 VARCHAR2(30),
  DRY_WEIGHT                NUMBER(25,10),
  WET_WEIGHT                NUMBER(25,10),
  WET_WEIGHT_UNIT_ID        VARCHAR2(15),
  SELF_ASSAY_SPLIT_LIMIT    NUMBER(25,10),
  CP_ASSAY_SPLIT_LIMIT      NUMBER(25,10),
  SELF_ASSAY_VALUE          NUMBER(25,10),
  CP_ASSAY_VALUE            NUMBER(25,10),
  DIFF_ASSAY_VALUE          NUMBER(25,10),
  ASSAY_VALUE_UNIT_ID       VARCHAR2(15),
  DIFF_PAYABLE_QTY          NUMBER(25,10),
  SPLIT_PAYABLE_QTY         NUMBER(25,10),
  QTY_UNIT_ID               VARCHAR2(15),
  PROV_PRICE                NUMBER(25,10),
  PROV_PRICE_UNIT_ID        VARCHAR2(15),
  ECONOMIC_VALUE            NUMBER(25,10),
  CUR_ID                    VARCHAR2(15),
  CREATED_DATE              TIMESTAMP(6),
  UPDATED_DATE              TIMESTAMP(6),
  CREATED_USER_ID           VARCHAR2(15),
  UPDATED_BY_USER_ID        VARCHAR2(15),
  IS_DEDUCTABLE             CHAR(1) DEFAULT 'N',
  IS_DELETED                CHAR(1) DEFAULT 'N',
  VERSION                   NUMBER(10)
)

ALTER TABLE EVD_ECONOMIC_VALUE_DETAILS ADD (CONSTRAINT PK_EVD PRIMARY KEY (EVD_ID));

ALTER TABLE EVD_ECONOMIC_VALUE_DETAILS ADD 
(
CONSTRAINT FK_EVD_CORPORATE_ID FOREIGN KEY (CORPORATE_ID) REFERENCES AK_CORPORATE (CORPORATE_ID),
CONSTRAINT FK_EVD_INTERNAL_ACTION_REF_NO FOREIGN KEY (INTERNAL_ACTION_REF_NO) REFERENCES AXS_ACTION_SUMMARY (INTERNAL_ACTION_REF_NO),
CONSTRAINT FK_EVD_INTERNAL_GMR_REF_NO FOREIGN KEY (INTERNAL_GMR_REF_NO) REFERENCES GMR_GOODS_MOVEMENT_RECORD (INTERNAL_GMR_REF_NO),
CONSTRAINT FK_EVD_INTERNAL_CON_REF_NO FOREIGN KEY (INTERNAL_CONTRACT_REF_NO) REFERENCES PCM_PHYSICAL_CONTRACT_MAIN (INTERNAL_CONTRACT_REF_NO),
CONSTRAINT FK_EVD_ELEMENT_ID FOREIGN KEY (ELEMENT_ID) REFERENCES AML_ATTRIBUTE_MASTER_LIST (ATTRIBUTE_ID),
CONSTRAINT CHK_EVD_ELEMENT_TYPE CHECK (ELEMENT_TYPE IN ('Payable','Returnable','None')),
CONSTRAINT FK_EVD_PCAR_ID FOREIGN KEY (PCAR_ID) REFERENCES PCAR_PC_ASSAYING_RULES (PCAR_ID),
CONSTRAINT FK_EVD_ASSAY_UNIT_ID FOREIGN KEY (ASSAY_VALUE_UNIT_ID) REFERENCES RM_RATIO_MASTER (RATIO_ID),
CONSTRAINT FK_EVD_QTY_UNIT_ID FOREIGN KEY (QTY_UNIT_ID) REFERENCES QUM_QUANTITY_UNIT_MASTER (QTY_UNIT_ID),
CONSTRAINT FK_EVD_PROV_PRICE_UNIT_ID FOREIGN KEY (PROV_PRICE_UNIT_ID) REFERENCES PPU_PRODUCT_PRICE_UNITS (INTERNAL_PRICE_UNIT_ID),
CONSTRAINT FK_EVD_CUR_ID FOREIGN KEY (CUR_ID) REFERENCES CM_CURRENCY_MASTER (CUR_ID),
CONSTRAINT FK_EVD_CREATED_USER_ID FOREIGN KEY (CREATED_USER_ID) REFERENCES AK_CORPORATE_USER (USER_ID),
CONSTRAINT FK_EVD_UPDATED_USER_ID FOREIGN KEY (UPDATED_BY_USER_ID) REFERENCES CM_CURRENCY_MASTER (CUR_ID)
);