alter table PCAD_PC_AGENCY_DETAIL modify  COMMISSION_VALUE NUMBER(25,10);
alter table PCAESL_ASSAY_ELEM_SPLIT_LIMITS modify  ASSAY_MIN_VALUE NUMBER(25,10);
alter table PCAESL_ASSAY_ELEM_SPLIT_LIMITS modify  ASSAY_MAX_VALUE NUMBER(25,10);
alter table PCAESL_ASSAY_ELEM_SPLIT_LIMITS modify  APPLICABLE_VALUE NUMBER(25,10);
alter table PCAP_PC_ATTRIBUTE_PENALTY modify  RANGE_MIN_VALUE NUMBER(25,10);
alter table PCAP_PC_ATTRIBUTE_PENALTY modify  RANGE_MAX_VALUE NUMBER(25,10);
alter table PCAP_PC_ATTRIBUTE_PENALTY modify  PENALTY_AMOUNT NUMBER(25,10);
alter table PCAP_PC_ATTRIBUTE_PENALTY modify  PER_INCREASE_VALUE NUMBER(25,10);
alter table PCAP_PC_ATTRIBUTE_PENALTY modify  DEDUCTED_PAYABLE_VALUE NUMBER(25,10);
alter table PCAR_PC_ASSAYING_RULES modify  SPLIT_LIMIT NUMBER(25,10);
alter table PCBPD_PC_BASE_PRICE_DETAIL modify  QTY_TO_BE_PRICED NUMBER(25,10);
alter table PCDB_PC_DELIVERY_BASIS modify  PREMIUM NUMBER(25,10);
alter table PCDI_PC_DELIVERY_ITEM modify  QTY_MIN_VAL NUMBER(25,10);
alter table PCDI_PC_DELIVERY_ITEM modify  QTY_MAX_VAL NUMBER(25,10);
alter table PCDI_PC_DELIVERY_ITEM modify  MIN_TOLERANCE NUMBER(25,10);
alter table PCDI_PC_DELIVERY_ITEM modify  MAX_TOLERANCE NUMBER(25,10);
alter table PCEPC_PC_ELEM_PAYABLE_CONTENT modify  RANGE_MIN_VALUE NUMBER(25,10);
alter table PCEPC_PC_ELEM_PAYABLE_CONTENT modify  RANGE_MAX_VALUE NUMBER(25,10);
alter table PCEPC_PC_ELEM_PAYABLE_CONTENT modify  PAYABLE_CONTENT_VALUE NUMBER(25,10);
alter table PCEPC_PC_ELEM_PAYABLE_CONTENT modify  ASSAY_DEDUCTION NUMBER(25,10);
alter table PCEPC_PC_ELEM_PAYABLE_CONTENT modify  REFINING_CHARGE_VALUE NUMBER(25,10);
alter table PCERC_PC_ELEM_REFINING_CHARGE modify  RANGE_MAX_VALUE NUMBER(25,10);
alter table PCERC_PC_ELEM_REFINING_CHARGE modify  REFINING_CHARGE NUMBER(25,10);
alter table PCERC_PC_ELEM_REFINING_CHARGE modify  ESC_DESC_VALUE NUMBER(25,10);
alter table PCERC_PC_ELEM_REFINING_CHARGE modify  RANGE_MIN_VALUE NUMBER(25,10);
alter table PCETC_PC_ELEM_TREATMENT_CHARGE modify  RANGE_MIN_VALUE NUMBER(25,10);
alter table PCETC_PC_ELEM_TREATMENT_CHARGE modify  RANGE_MAX_VALUE NUMBER(25,10);
alter table PCETC_PC_ELEM_TREATMENT_CHARGE modify  TREATMENT_CHARGE NUMBER(25,10);
alter table PCETC_PC_ELEM_TREATMENT_CHARGE modify  ESC_DESC_VALUE NUMBER(25,10);
alter table PCJV_PC_JV_DETAIL modify  PROFIT_SHARE_PERCENTAGE NUMBER(25,10);
alter table PCJV_PC_JV_DETAIL modify  LOSS_SHARE_PERCENTAGE NUMBER(25,10);
alter table PCM_PHYSICAL_CONTRACT_MAIN modify  WEIGHT_ALLOWANCE NUMBER(25,10);
alter table PCM_PHYSICAL_CONTRACT_MAIN modify  PROVISIONAL_PYMT_PCTG NUMBER(25,10);
alter table PCPD_PC_PRODUCT_DEFINITION modify  QTY_MIN_VAL NUMBER(25,10);
alter table PCPD_PC_PRODUCT_DEFINITION modify  QTY_MAX_VAL NUMBER(25,10);
alter table PCPD_PC_PRODUCT_DEFINITION modify  MIN_TOLERANCE NUMBER(25,10);
alter table PCPD_PC_PRODUCT_DEFINITION modify  MAX_TOLERANCE NUMBER(25,10);
alter table PCPQ_PC_PRODUCT_QUALITY modify  QTY_MIN_VAL NUMBER(25,10);
alter table PCPQ_PC_PRODUCT_QUALITY modify  QTY_MAX_VAL NUMBER(25,10);
alter table PCQPD_PC_QUAL_PREMIUM_DISCOUNT modify  PREMIUM_DISC_VALUE NUMBER(25,10);
alter table PFFXD_PHY_FORMULA_FX_DETAILS modify  FIXED_FX_RATE NUMBER(25,10);
alter table PQCA_PQ_CHEMICAL_ATTRIBUTES modify  MIN_VALUE NUMBER(25,10);
alter table PQCA_PQ_CHEMICAL_ATTRIBUTES modify  MAX_VALUE NUMBER(25,10);
alter table PQCA_PQ_CHEMICAL_ATTRIBUTES modify  TYPICAL NUMBER(25,10);
alter table PCI_PHYSICAL_CONTRACT_ITEM modify ITEM_QTY  NUMBER(25,10);


alter table PCADUL_PC_AGENCY_DETAIL_UL modify  COMMISSION_VALUE VARCHAR2(30);
alter table PCAESLUL_ASSAY_ELM_SPLT_LMT_UL modify  ASSAY_MIN_VALUE VARCHAR2(30);
alter table PCAESLUL_ASSAY_ELM_SPLT_LMT_UL modify  ASSAY_MAX_VALUE VARCHAR2(30);
alter table PCAESLUL_ASSAY_ELM_SPLT_LMT_UL modify  APPLICABLE_VALUE VARCHAR2(30);
alter table PCAPUL_ATTRIBUTE_PENALTY_UL modify  RANGE_MIN_VALUE VARCHAR2(30);
alter table PCAPUL_ATTRIBUTE_PENALTY_UL modify  RANGE_MAX_VALUE VARCHAR2(30);
alter table PCAPUL_ATTRIBUTE_PENALTY_UL modify  PENALTY_AMOUNT VARCHAR2(30);
alter table PCAPUL_ATTRIBUTE_PENALTY_UL modify  PER_INCREASE_VALUE VARCHAR2(30);
alter table PCAPUL_ATTRIBUTE_PENALTY_UL modify  DEDUCTED_PAYABLE_VALUE VARCHAR2(30);
alter table PCARUL_ASSAYING_RULES_UL modify  SPLIT_LIMIT VARCHAR2(30);
alter table PCBPDUL_PC_BASE_PRICE_DTL_UL modify  QTY_TO_BE_PRICED VARCHAR2(30);
alter table PCDBUL_PC_DELIVERY_BASIS_UL modify  PREMIUM VARCHAR2(30);
alter table PCDIUL_PC_DELIVERY_ITEM_UL modify  QTY_MIN_VAL VARCHAR2(30);
alter table PCDIUL_PC_DELIVERY_ITEM_UL modify  QTY_MAX_VAL VARCHAR2(30);
alter table PCDIUL_PC_DELIVERY_ITEM_UL modify  MIN_TOLERANCE VARCHAR2(30);
alter table PCDIUL_PC_DELIVERY_ITEM_UL modify  MAX_TOLERANCE VARCHAR2(30);
alter table PCEPCUL_ELEM_PAYBLE_CONTENT_UL modify  RANGE_MIN_VALUE VARCHAR2(30);
alter table PCEPCUL_ELEM_PAYBLE_CONTENT_UL modify  RANGE_MAX_VALUE VARCHAR2(30);
alter table PCEPCUL_ELEM_PAYBLE_CONTENT_UL modify  PAYABLE_CONTENT_VALUE VARCHAR2(30);
alter table PCEPCUL_ELEM_PAYBLE_CONTENT_UL modify  ASSAY_DEDUCTION VARCHAR2(30);
alter table PCEPCUL_ELEM_PAYBLE_CONTENT_UL modify  REFINING_CHARGE_VALUE VARCHAR2(30);
alter table PCERCUL_ELEM_REFING_CHARGE_UL modify  RANGE_MAX_VALUE VARCHAR2(30);
alter table PCERCUL_ELEM_REFING_CHARGE_UL modify  REFINING_CHARGE VARCHAR2(30);
alter table PCERCUL_ELEM_REFING_CHARGE_UL modify  ESC_DESC_VALUE VARCHAR2(30);
alter table PCERCUL_ELEM_REFING_CHARGE_UL modify  RANGE_MIN_VALUE VARCHAR2(30);
alter table PCETCUL_ELEM_TREATMNT_CHRG_UL modify  RANGE_MIN_VALUE VARCHAR2(30);
alter table PCETCUL_ELEM_TREATMNT_CHRG_UL modify  RANGE_MAX_VALUE VARCHAR2(30);
alter table PCETCUL_ELEM_TREATMNT_CHRG_UL modify  TREATMENT_CHARGE VARCHAR2(30);
alter table PCETCUL_ELEM_TREATMNT_CHRG_UL modify  ESC_DESC_VALUE VARCHAR2(30);
alter table PCJVUL_PC_JV_DETAIL_UL modify  PROFIT_SHARE_PERCENTAGE VARCHAR2(30);
alter table PCJVUL_PC_JV_DETAIL_UL modify  LOSS_SHARE_PERCENTAGE VARCHAR2(30);
alter table PCMUL_PHY_CONTRACT_MAIN_UL modify  WEIGHT_ALLOWANCE VARCHAR2(30);
alter table PCMUL_PHY_CONTRACT_MAIN_UL modify  PROVISIONAL_PYMT_PCTG VARCHAR2(30);
alter table PCPDUL_PC_PRODUCT_DEFINTN_UL modify  QTY_MIN_VAL VARCHAR2(30);
alter table PCPDUL_PC_PRODUCT_DEFINTN_UL modify  QTY_MAX_VAL VARCHAR2(30);
alter table PCPDUL_PC_PRODUCT_DEFINTN_UL modify  MIN_TOLERANCE VARCHAR2(30);
alter table PCPDUL_PC_PRODUCT_DEFINTN_UL modify  MAX_TOLERANCE VARCHAR2(30);
alter table PCPQUL_PC_PRODUCT_QUALITY_UL modify  QTY_MIN_VAL VARCHAR2(30);
alter table PCPQUL_PC_PRODUCT_QUALITY_UL modify  QTY_MAX_VAL VARCHAR2(30);
alter table PCQPDUL_PC_QUAL_PRM_DISCNT_UL modify  PREMIUM_DISC_VALUE VARCHAR2(30);
alter table PFFXDUL_PHY_FORMULA_FX_DTL_UL modify  FIXED_FX_RATE VARCHAR2(30);
alter table PCIUL_PHY_CONTRACT_ITEM_UL modify ITEM_QTY  VARCHAR2(30);
