ALTER TABLE GEPD_GMR_ELEMENT_PLEDGE_DETAIL ADD
(
QUALITY_ID  VARCHAR2(15) NOT NULL,
CONSTRAINT FK_GEPD_QUALITY_ID FOREIGN KEY (QUALITY_ID) REFERENCES QAT_QUALITY_ATTRIBUTES (QUALITY_ID)
);

CREATE SEQUENCE SEQ_GEPD
  START WITH 1
  MAXVALUE 1000000000000000000000000000
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

  CREATE SEQUENCE SEQ_MTFS
  START WITH 1
  MAXVALUE 1000000000000000000000000000
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;