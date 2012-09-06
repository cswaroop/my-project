-----
CREATE INDEX IDX_PQCA1 ON PQCA_PQ_CHEMICAL_ATTRIBUTES(ASM_ID,ELEMENT_ID,UNIT_OF_MEASURE);
CREATE INDEX IDX_PQCAPD1 ON PQCAPD_PRD_QLTY_CATTR_PAY_DTLS(PQCA_ID);
CREATE INDEX IDX_ASM1 ON ASM_ASSAY_SUBLOT_MAPPING (ASH_ID,ASM_ID);
CREATE INDEX IDX_GPH1 ON GPH_GMR_PENALTY_HEADER(IS_ACTIVE,PCAPH_ID,INTERNAL_GMR_REF_NO);

------------------

ALTER TABLE PA_PURCHASE_ACCURAL_GMR ADD INVOICE_REF_NO VARCHAR2(30);
ALTER TABLE PA_TEMP ADD INVOICE_REF_NO VARCHAR2(30);

CREATE TABLE PATD_PA_TEMP_DATA (
INTERNAL_GMR_REF_NO            VARCHAR2(15),
INTERNAL_GRD_REF_NO            VARCHAR2(15),
GMR_REF_NO                     VARCHAR2(30),
GMR_PRICE                      NUMBER(25,10),
GMR_PRICE_UNIT_ID              VARCHAR2(15),
GMR_PRICE_UNIT_WEIGHT_UNIT_ID  VARCHAR2(15),
GMR_PRICE_UNIT_CUR_ID          VARCHAR2(15),
GMR_PRICE_UNIT_CUR_CODE        VARCHAR2(15),
PRODUCT_ID                     VARCHAR2(15),
ELEMENT_ID                     VARCHAR2(15),
ASH_ID                         VARCHAR2(15),
PAYABLE_QTY                    NUMBER(25,10),
PAYABLE_QTY_UNIT_ID            VARCHAR2(15),
ASSAY_QTY                      NUMBER(25,10),
ASSAY_QTY_UNIT_ID              VARCHAR2(15),
DRY_QTY                        NUMBER(25,10),
WET_QTY                        NUMBER(25,10),
GRD_QTY_UNIT_ID                VARCHAR2(15),
CORPORATE_ID                   VARCHAR2(15),
CORPORATE_NAME                 VARCHAR2(100),
CONC_PRODUCT_ID                VARCHAR2(15),
CONC_PRODUCT_NAME              VARCHAR2(100),
CONC_QUALITY_ID                VARCHAR2(15),
CONC_QUALITY_NAME              VARCHAR2(100),
PROFIT_CENTER_ID               VARCHAR2(15),
PROFIT_CENTER_NAME             VARCHAR2(100),
PROFIT_CENTER_SHORT_NAME       VARCHAR2(100),
PROCESS_ID                     VARCHAR2(15),
CONTRACT_TYPE                  VARCHAR2(15),
BASE_CUR_ID                    VARCHAR2(15),
BASE_CUR_CODE                  VARCHAR2(15),
BASE_CUR_DECIMAL               NUMBER(10),
ELEMENT_NAME                   VARCHAR2(30),
PAYABLE_TYPE                   VARCHAR2(25),
CP_ID                          VARCHAR2(15),
COUNTERPARTY_NAME              VARCHAR2(100),
PAY_CUR_ID                     VARCHAR2(15),
PAY_CUR_CODE                   VARCHAR2(15),
PAY_CUR_DECIMAL                NUMBER(10),
PCDI_ID                        VARCHAR2(15),
PLEDGE_STOCK_ID                VARCHAR2(15),
TC_AMT                         NUMBER(38,18),
RC_AMT                         NUMBER(38,18),
PENALTY_AMT                    NUMBER(38,18));

CREATE INDEX IDX_PATD1 ON PATD_PA_TEMP_DATA(CORPORATE_ID);
CREATE INDEX IDX_PATD2 ON PATD_PA_TEMP_DATA(PROCESS_ID,INTERNAL_GMR_REF_NO,ELEMENT_ID);

CREATE INDEX IDX_pcepc2 ON pcepc_pc_elem_payable_content (dbd_id,is_active,pcpch_id,position);

DROP INDEX IDX_pcaph1;
CREATE INDEX IDX_pcaph1 ON pcaph_pc_attr_penalty_header(Dbd_Id,is_active,pcaph_id);

------------------