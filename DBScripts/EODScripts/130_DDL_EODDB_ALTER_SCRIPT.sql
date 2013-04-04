ALTER TABLE GETC_GMR_ELEMENT_TC_CHARGES ADD CURRENCY_FACTOR NUMBER DEFAULT 1;
ALTER TABLE GERC_GMR_ELEMENT_RC_CHARGES ADD CURRENCY_FACTOR NUMBER DEFAULT 1;
ALTER TABLE GEPC_GMR_ELEMENT_PC_CHARGES ADD CURRENCY_FACTOR NUMBER DEFAULT 1;
ALTER TABLE GETC_GMR_ELEMENT_TC_CHARGES ADD TC_MAIN_CUR_ID VARCHAR2(15);
ALTER TABLE GERC_GMR_ELEMENT_RC_CHARGES ADD RC_MAIN_CUR_ID VARCHAR2(15);
ALTER TABLE GEPC_GMR_ELEMENT_PC_CHARGES ADD PC_MAIN_CUR_ID VARCHAR2(15);
UPDATE GETC_GMR_ELEMENT_TC_CHARGES SET TC_MAIN_CUR_ID = TC_CUR_ID;
UPDATE GERC_GMR_ELEMENT_RC_CHARGES SET RC_MAIN_CUR_ID = RC_CUR_ID;
UPDATE GEPC_GMR_ELEMENT_PC_CHARGES SET PC_MAIN_CUR_ID = PC_CUR_ID;
COMMIT;


