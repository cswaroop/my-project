CREATE TABLE SIGM_SERVICE_INV_GMR_MAPPING
(
  SIGM_ID              VARCHAR2(50 CHAR),
  INTERNAL_INV_REF_NO  VARCHAR2(50 CHAR),
  INTERNAL_GMR_REF_NO  VARCHAR2(50 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;


ALTER TABLE SIGM_SERVICE_INV_GMR_MAPPING ADD (
  CONSTRAINT SIGM_SERVICE_INV_GMR_MAPPINGPK
 PRIMARY KEY
 (SIGM_ID));


ALTER TABLE SIGM_SERVICE_INV_GMR_MAPPING
 ADD (IS_ACTIVE  CHAR(1 CHAR));


CREATE SEQUENCE SEQ_SIGM
START WITH 1000
INCREMENT BY 1
MINVALUE 1000
MAXVALUE 100000000000000000000000
NOCACHE 
NOCYCLE 
NOORDER 
