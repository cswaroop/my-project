ALTER TABLE IS_INVOICE_SUMMARY
 ADD (IS_INTERNAL_TOLLING  CHAR(1 CHAR)             DEFAULT 'N');


 CREATE TABLE IUED_INV_UTILITY_ERROR_DETAILS
(
  UTILITY_ID  VARCHAR2(15 CHAR),
  ERROR_MSG   VARCHAR2(200 CHAR)
)

ALTER TABLE IUED_INV_UTILITY_ERROR_DETAILS
 ADD (ERROR_ID  VARCHAR2(15 CHAR));

ALTER TABLE IUED_INV_UTILITY_ERROR_DETAILS
 ADD CONSTRAINT IUED_INV_UTILITY_ERROR_DETA_PK
 PRIMARY KEY
 (ERROR_ID);

CREATE TABLE IUM_INVOICE_UTILITY_MAPPING
(
  INTERNAL_UTILITY_REF_NO  VARCHAR2(15 CHAR),
  INTERNAL_INV_REF_NO      VARCHAR2(15 CHAR),
  INVOICE_REF_NO           VARCHAR2(15 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;


ALTER TABLE IUM_INVOICE_UTILITY_MAPPING ADD (
  CONSTRAINT IUM_INVOICE_UTILITY_MAPPING_PK
 PRIMARY KEY
 (INTERNAL_UTILITY_REF_NO));

ALTER TABLE IUM_INVOICE_UTILITY_MAPPING
 ADD (IUM_ID  VARCHAR2(15 CHAR));

ALTER TABLE IUM_INVOICE_UTILITY_MAPPING DROP
  CONSTRAINT IUM_INVOICE_UTILITY_MAPPING_PK;

ALTER TABLE IUM_INVOICE_UTILITY_MAPPING
MODIFY(IUM_ID  NOT NULL);


ALTER TABLE IUM_INVOICE_UTILITY_MAPPING
 ADD CONSTRAINT IUM_INVOICE_UTILITY_MAPPING_PK
 PRIMARY KEY
 (IUM_ID);

CREATE SEQUENCE SEQ_IUM
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 100000000000000000000000000
NOCACHE 
NOCYCLE 
NOORDER 