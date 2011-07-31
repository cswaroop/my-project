Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-PIC', 'CREATE_PI', 'Concentrate Provisional Invoice', 'CREATE_PI', 1, 
    'INSERT INTO IS_D(
INVOICE_REF_NO,
INVOICE_TYPE_NAME,
INVOICE_CREATION_DATE,
INVOICE_QUANTITY,
INVOICED_QTY_UNIT,
INTERNAL_INVOICE_REF_NO,
INVOICE_AMOUNT,
ADDDITIONAL_CHARGES,
TAXES,
DUE_DATE,
SUPPLIRE_INVOICE_NO,
CONTRACT_DATE,
CONTRACT_REF_NO,
STOCK_QUANTITY,
STOCK_REF_NO,
INVOICE_AMOUNT_UNIT,
GMR_REF_NO,
GMR_QUALITY,
CONTRACT_QUANTITY,
CONTRACT_QTY_UNIT,
CONTRACT_TOLERANCE,
QUALITY,
PRODUCT,
CP_CONTRACT_REF_NO,
PAYMENT_TERM,
GMR_FINALIZE_QTY,
CP_NAME,
CP_ADDRESS,
CP_COUNTRY,
CP_CITY,
CP_STATE,
CP_ZIP,
CONTRACT_TYPE,
ORIGIN,
INCO_TERM_LOCATION,
NOTIFY_PARTY,
SALES_PURCHASE,
INTERNAL_DOC_REF_NO
)
select
INVS.INVOICE_REF_NO as INVOICE_REF_NO,
INVS.INVOICE_TYPE_NAME as INVOICE_TYPE_NAME,
INVS.INVOICE_CREATED_DATE as INVOICE_CREATION_DATE,
INVS.INVOICED_QTY as INVOICE_QUANTITY,
QUM_GMR.QTY_UNIT as INVOICED_QTY_UNIT,
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
INVS.TOTAL_AMOUNT_TO_PAY as INVOICE_AMOUNT,
INVS.TOTAL_OTHER_CHARGE_AMOUNT as ADDDITIONAL_CHARGES,
INVS.TOTAL_TAX_AMOUNT as TAXES,
INVS.PAYMENT_DUE_DATE as DUE_DATE,
INVS.CP_REF_NO as SUPPLIER_INVOICE_NO,
PCM.ISSUE_DATE as CONTRACT_DATE,
PCM.CONTRACT_REF_NO as CONTRACT_REF_NO,
sum(II.INVOICABLE_QTY) as STOCK_QUANTITY,
II.STOCK_REF_NO as STOCK_REF_NO,
CM.CUR_CODE as INVOICE_AMOUNT_UNIT,
GMR.GMR_REF_NO as GMR_REF_NO,
GMR.QTY as GMR_QUALITY,
PCPD.QTY_MAX_VAL as CONTRACT_QUANTITY,
QUM.QTY_UNIT as CONTRACT_QTY_UNIT,
PCPD.MAX_TOLERANCE as CONTRACT_TOLERANCE,
QAT.QUALITY_NAME as QUALITY,
PDM.PRODUCT_DESC as PRODUCT,
PCM.CP_CONTRACT_REF_NO as CP_CONTRACT_REF_NO,
PYM.PAYMENT_TERM as PAYMENT_TERM,
GMR.FINAL_WEIGHT as GMR_FINALIZE_QTY,
PHD.COMPANYNAME as CP_NAME,
PAD.ADDRESS as CP_ADDRESS,
CYM.COUNTRY_NAME as CP_COUNTRY,
CIM.CITY_NAME as CP_CITY,
SM.STATE_NAME as CP_STATE,
PAD.ZIP as CP_ZIP,
PCM.CONTRACT_TYPE as CONTRACT_TYPE,
CYMLOADING.COUNTRY_NAME as ORIGIN,
PCI.TERMS as INCO_TERM_LOCATION,
nvl(PHD1.COMPANYNAME, PHD2.COMPANYNAME) as NOTIFY_PARTY, 
PCI.CONTRACT_TYPE as SALES_PURCHASE,
?
from 
IS_INVOICE_SUMMARY invs,
IID_INVOICABLE_ITEM_DETAILS iid,
PCM_PHYSICAL_CONTRACT_MAIN pcm,
V_PCI pci,
II_INVOICABLE_ITEM ii,
CM_CURRENCY_MASTER cm,
GMR_GOODS_MOVEMENT_RECORD gmr,
PCPD_PC_PRODUCT_DEFINITION pcpd,
QUM_QUANTITY_UNIT_MASTER qum,
PCPQ_PC_PRODUCT_QUALITY pcpq,
QAT_QUALITY_ATTRIBUTES qat,
PDM_PRODUCTMASTER pdm,
PHD_PROFILEHEADERDETAILS phd,
PYM_PAYMENT_TERMS_MASTER pym,
PAD_PROFILE_ADDRESSES pad,
CYM_COUNTRYMASTER cym,
CIM_CITYMASTER cim,
SM_STATE_MASTER sm,
BPAT_BP_ADDRESS_TYPE bpat,
CYM_COUNTRYMASTER cymloading,
SAD_SHIPMENT_ADVICE sad,
SD_SHIPMENT_DETAIL sd,
PHD_PROFILEHEADERDETAILS phd1,
PHD_PROFILEHEADERDETAILS phd2,
QUM_QUANTITY_UNIT_MASTER qum_gmr
where
INVS.INTERNAL_INVOICE_REF_NO = IID.INTERNAL_INVOICE_REF_NO
and IID.INTERNAL_CONTRACT_ITEM_REF_NO = PCI.INTERNAL_CONTRACT_ITEM_REF_NO
and IID.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and IID.INVOICABLE_ITEM_ID = II.INVOICABLE_ITEM_ID
and IID.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO
and PCM.INVOICE_CURRENCY_ID = CM.CUR_ID
and II.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO
and PCM.INTERNAL_CONTRACT_REF_NO = PCPD.INTERNAL_CONTRACT_REF_NO
and PCPD.QTY_UNIT_ID = QUM.QTY_UNIT_ID
and PCPD.PCPD_ID = PCPQ.PCPD_ID
and PCPQ.QUALITY_TEMPLATE_ID = QAT.QUALITY_ID
and PCPD.PRODUCT_ID = PDM.PRODUCT_ID
and PCM.CP_ID = PHD.PROFILEID
and PCM.PAYMENT_TERM_ID = PYM.PAYMENT_TERM_ID
and PHD.PROFILEID = PAD.PROFILE_ID
and PAD.COUNTRY_ID = CYM.COUNTRY_ID
and PAD.CITY_ID = CIM.CITY_ID(+)
and PAD.STATE_ID = SM.STATE_ID(+)
and PAD.ADDRESS_TYPE = BPAT.BP_ADDRESS_TYPE_ID(+)
and CYMLOADING.COUNTRY_ID = GMR.LOADING_COUNTRY_ID(+)
and GMR.INTERNAL_GMR_REF_NO = SAD.INTERNAL_GMR_REF_NO(+)
and GMR.INTERNAL_GMR_REF_NO = SD.INTERNAL_GMR_REF_NO(+)
and SAD.CONSIGNEE_ID = PHD1.PROFILEID(+)
and SD.CONSIGNEE_ID = PHD2.PROFILEID(+)
and GMR.QTY_UNIT_ID = QUM_GMR.QTY_UNIT_ID(+)
and PAD.ADDRESS_TYPE = 'Main'
and INVS.INTERNAL_INVOICE_REF_NO = ?
group by
INVS.INVOICE_REF_NO,
INVS.INVOICE_TYPE_NAME,
INVS.INVOICE_CREATED_DATE,
INVS.INVOICED_QTY,
INVS.INTERNAL_INVOICE_REF_NO,
INVS.TOTAL_AMOUNT_TO_PAY,
INVS.TOTAL_OTHER_CHARGE_AMOUNT,
INVS.TOTAL_TAX_AMOUNT,
INVS.PAYMENT_DUE_DATE,
INVS.CP_REF_NO,
PCM.ISSUE_DATE,
PCM.CONTRACT_REF_NO,
II.STOCK_REF_NO,
CM.CUR_CODE,
GMR.GMR_REF_NO,
GMR.QTY,
PCPD.QTY_MAX_VAL,
QUM.QTY_UNIT,
PCPD.MAX_TOLERANCE,
QAT.QUALITY_NAME,
PDM.PRODUCT_DESC,
PCM.CP_CONTRACT_REF_NO,
PYM.PAYMENT_TERM,
GMR.FINAL_WEIGHT,
PHD.COMPANYNAME,
PAD.ADDRESS,
CYM.COUNTRY_NAME,
CIM.CITY_NAME,
SM.STATE_NAME,
PAD.ZIP,
PCM.CONTRACT_TYPE,
CYMLOADING.COUNTRY_NAME,
PCI.TERMS,
PHD1.COMPANYNAME,
PHD2.COMPANYNAME,
QUM_GMR.QTY_UNIT,
PCI.CONTRACT_TYPE', 'Y');





Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-PIC-C1', 'CREATE_PI', 'Concentrate Provisional Invoice', 'CREATE_PI', 2, 
    'INSERT INTO IS_CONC_PAYABLE_CHILD (
  INTERNAL_INVOICE_REF_NO,
  GMR_REF_NO,
  GMR_QUANTITY,
  GMR_QUALITY,
  GMR_QTY_UNIT,
  INVOICED_PRICE_UNIT,
  STOCK_REF_NO,
  STOCK_QTY,
  ELEMENT_NAME,
  INVOICE_PRICE,
  SUB_LOT_NO,
  ELEMENT_PRICE_UNIT,
  ASSAY_CONTENT,
  ASSAY_CONTENT_UNIT,
  ELEMENT_INVOICED_QTY,
  ELEMENT_INVOICED_QTY_UNIT,
  ELEMENT_ID,
  INTERNAL_DOC_REF_NO              
)
Select
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
GMR.GMR_REF_NO as GMR_REF_NO,
GMR.QTY as GMR_QUANTITY,
nvl(QAT.QUALITY_NAME, QAT1.QUALITY_NAME) as GMR_QUALITY,
QUM.QTY_UNIT as GMR_QTY_UNIT,
PUM.PRICE_UNIT_NAME as INVOICED_PRICE_UNIT,
nvl(GRD.INTERNAL_STOCK_REF_NO, DGRD.INTERNAL_STOCK_REF_NO) as STOCK_REF_NO,
nvl(GRD.QTY, DGRD.NET_WEIGHT) as STOCK_QTY,
AML.ATTRIBUTE_NAME AS ELEMENT_NAME,
IIED.ELEMENT_PAYABLE_PRICE AS INVOICE_PRICE,
IIED.SUB_LOT_NO AS SUB_LOT_NO,
PEPUM.PRICE_UNIT_NAME AS ELEMENT_PRICE_UNIT,
PQCA.PAYABLE_PERCENTAGE AS ASSAY_CONTENT,
RM.RATIO_NAME as ASSAY_CONTENT_UNIT,
IIED.ELEMENT_INVOICED_QTY AS ELEMENT_INVOICED_QTY,
QUMIIED.QTY_UNIT AS ELEMENT_INVOICED_QTY_UNIT,
AML.ATTRIBUTE_ID AS ELEMENT_ID,
?
from
IS_INVOICE_SUMMARY invs,
IID_INVOICABLE_ITEM_DETAILS iid,
GMR_GOODS_MOVEMENT_RECORD gmr,
QUM_QUANTITY_UNIT_MASTER qum,
QUM_QUANTITY_UNIT_MASTER quminv,
PPU_PRODUCT_PRICE_UNITS ppu,
PUM_PRICE_UNIT_MASTER pum,
GRD_GOODS_RECORD_DETAIL grd,
DGRD_DELIVERED_GRD dgrd,
QAT_QUALITY_ATTRIBUTES qat,
QAT_QUALITY_ATTRIBUTES qat1,
IIED_INV_ITEM_ELEMENT_DETAILS IIED,
AML_ATTRIBUTE_MASTER_LIST AML,
PPU_PRODUCT_PRICE_UNITS PEPU,
PUM_PRICE_UNIT_MASTER PEPUM,
ASH_ASSAY_HEADER ASH,
ASM_ASSAY_SUBLOT_MAPPING ASM,
PQCA_PQ_CHEMICAL_ATTRIBUTES PQCA,
IAM_INVOICE_ASSAY_MAPPING IAM,
RM_RATIO_MASTER rm,
QUM_QUANTITY_UNIT_MASTER QUMIIED
where
INVS.INTERNAL_INVOICE_REF_NO = IID.INTERNAL_INVOICE_REF_NO(+)
and IID.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO(+)
and GMR.QTY_UNIT_ID = QUM.QTY_UNIT_ID(+)
and IID.INVOICED_QTY_UNIT_ID = QUMINV.QTY_UNIT_ID(+)
and IID.NEW_INVOICE_PRICE_UNIT_ID = PPU.INTERNAL_PRICE_UNIT_ID(+)
and PPU.PRICE_UNIT_ID = PUM.PRICE_UNIT_ID(+)
and IID.STOCK_ID = GRD.INTERNAL_GRD_REF_NO(+)
and IID.STOCK_ID = DGRD.INTERNAL_GRD_REF_NO(+)
and GRD.QUALITY_ID = QAT.QUALITY_ID(+)
and DGRD.QUALITY_ID = QAT1.QUALITY_ID(+)
AND IIED.INTERNAL_INVOICE_REF_NO = INVS.INTERNAL_INVOICE_REF_NO(+)
AND AML.ATTRIBUTE_ID = IIED.ELEMENT_ID(+)
AND IIED.ELEMENT_PAYABLE_PRICE_UNIT_ID = PEPU.INTERNAL_PRICE_UNIT_ID(+)
AND PEPU.PRICE_UNIT_ID = PEPUM.PRICE_UNIT_ID(+)
AND IAM.INTERNAL_INVOICE_REF_NO = INVS.INTERNAL_INVOICE_REF_NO
AND IAM.ASH_ID = ASH.ASH_ID
AND ASH.ASH_ID = ASM.ASH_ID
AND ASM.ASM_ID = PQCA.ASM_ID
AND IIED.ELEMENT_ID = PQCA.ELEMENT_ID
and PQCA.UNIT_OF_MEASURE = RM.RATIO_ID
AND IIED.ELEMENT_INV_QTY_UNIT_ID = QUMIIED.QTY_UNIT_ID
and IID.INTERNAL_INVOICE_REF_NO = ?', 'Y');
      
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-PIC-C2', 'CREATE_PI', 'Concentrate Provisional Invoice', 'CREATE_PI', 3, 
    'INSERT INTO IS_CONC_TC_CHILD (
INTERNAL_INVOICE_REF_NO,
TC_AMOUNT,
ELEMENT_NAME,
ELEMENT_ID,
AMOUNT_UNIT,
INTERNAL_DOC_REF_NO
)
select 
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
INTC.TCHARGES_AMOUNT as TC_AMOUNT,
AML.ATTRIBUTE_NAME as ELEMENT_NAME,
AML.ATTRIBUTE_ID as ELEMENT_ID,
CM.CUR_CODE as AMOUNT_UNIT,
?
from
IS_INVOICE_SUMMARY invs,
INTC_INV_TREATMENT_CHARGES intc,
AML_ATTRIBUTE_MASTER_LIST aml,
CM_CURRENCY_MASTER cm,
V_PCI pci
where
INVS.INTERNAL_INVOICE_REF_NO = INTC.INTERNAL_INVOICE_REF_NO(+)
and INTC.ELEMENT_ID = AML.ATTRIBUTE_ID(+)
and PCI.INVOICE_CURRENCY_ID = CM.CUR_ID(+)
and INVS.INTERNAL_CONTRACT_REF_NO = PCI.INTERNAL_CONTRACT_REF_NO(+)
and INVS.INTERNAL_INVOICE_REF_NO = ?', 'Y');

Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-PIC-C3', 'CREATE_PI', 'Concentrate Provisional Invoice', 'CREATE_PI', 4, 
    'INSERT INTO IS_CONC_RC_CHILD (
INTERNAL_INVOICE_REF_NO,
RC_AMOUNT,
ELEMENT_NAME,
ELEMENT_ID,
AMOUNT_UNIT,
INTERNAL_DOC_REF_NO
)
select 
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
INRC.RCHARGES_AMOUNT as RC_AMOUNT,
AML.ATTRIBUTE_NAME as ELEMENT_NAME,
AML.ATTRIBUTE_ID as ELEMENT_ID,
CM.CUR_CODE as AMOUNT_UNIT,
?
from
IS_INVOICE_SUMMARY invs,
INRC_INV_REFINING_CHARGES inrc,
AML_ATTRIBUTE_MASTER_LIST aml,
CM_CURRENCY_MASTER cm,
V_PCI pci
where
INVS.INTERNAL_INVOICE_REF_NO = INRC.INTERNAL_INVOICE_REF_NO(+)
and INRC.ELEMENT_ID = AML.ATTRIBUTE_ID(+)
and PCI.INVOICE_CURRENCY_ID = CM.CUR_ID(+)
and INVS.INTERNAL_CONTRACT_REF_NO = PCI.INTERNAL_CONTRACT_REF_NO(+)
and INVS.INTERNAL_INVOICE_REF_NO = ?', 'Y');


Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-PIC-C4 ', 'CREATE_PI', 'Concentrate Provisional Invoice', 'CREATE_PI', 5, 
    'INSERT INTO IS_CONC_PENALTY_CHILD (
INTERNAL_INVOICE_REF_NO,
PENALTY_AMOUNT,
ELEMENT_NAME,
ELEMENT_ID,
AMOUNT_UNIT,
INTERNAL_DOC_REF_NO
)
select 
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
SUM(IEPD.ELEMENT_PENALTY_AMOUNT) as PENALTY_AMOUNT,
AML.ATTRIBUTE_NAME as ELEMENT_NAME,
AML.ATTRIBUTE_ID as ELEMENT_ID,
CM.CUR_CODE as AMOUNT_UNIT,
?
from
IS_INVOICE_SUMMARY invs,
IEPD_INV_EPENALTY_DETAILS iepd,
AML_ATTRIBUTE_MASTER_LIST aml,
CM_CURRENCY_MASTER cm,
V_PCI pci
where
INVS.INTERNAL_INVOICE_REF_NO = IEPD.INTERNAL_INVOICE_REF_NO(+)
and IEPD.ELEMENT_ID = AML.ATTRIBUTE_ID(+)
and PCI.INVOICE_CURRENCY_ID = CM.CUR_ID(+)
and INVS.INTERNAL_CONTRACT_REF_NO = PCI.INTERNAL_CONTRACT_REF_NO(+)
and INVS.INTERNAL_INVOICE_REF_NO = ?
group by
INVS.INTERNAL_INVOICE_REF_NO,
AML.ATTRIBUTE_NAME,
AML.ATTRIBUTE_ID,
CM.CUR_CODE', 'Y');


Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-PIC-C5', 'CREATE_PI', 'Provisional Invoice', 'CREATE_PI', 6, 
    'INSERT INTO is_bds_child_d
            (internal_invoice_ref_no, beneficiary_name, bank_name, account_no,
             aba_rtn, instruction, internal_doc_ref_no)
   SELECT invs.internal_invoice_ref_no AS internal_invoice_ref_no,
          oipi.beneficiary_name AS beneficiary_name,
          phd.companyname AS bank_name, oipi.bank_account AS account_no,
          oipi.aba_no AS aba_rtn, oipi.instructions AS instruction, ?
     FROM phd_profileheaderdetails phd,
          is_invoice_summary invs,
          oipi_our_inv_pay_instruction oipi
    WHERE invs.internal_invoice_ref_no = oipi.internal_invoice_ref_no
      AND oipi.bank_id = phd.profileid
      AND invs.internal_invoice_ref_no = ?', 'Y');
      
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-PIC-C6', 'CREATE_PI', 'Provisional Invoice', 'CREATE_PI', 7, 
    'INSERT INTO is_bdp_child_d
            (internal_invoice_ref_no, beneficiary_name, bank_name, account_no,
             aba_rtn, instruction, internal_doc_ref_no)
   SELECT invs.internal_invoice_ref_no AS internal_invoice_ref_no,
          cpipi.beneficiary_name AS beneficiary_name,
          phd.companyname AS bank_name, cpipi.bank_account AS account_no,
          cpipi.aba_no AS aba_rtn, cpipi.instructions AS instruction, ?
     FROM phd_profileheaderdetails phd,
          is_invoice_summary invs,
          cpipi_cp_inv_pay_instruction cpipi
    WHERE invs.internal_invoice_ref_no = cpipi.internal_invoice_ref_no
      AND cpipi.bank_id = phd.profileid
      AND invs.internal_invoice_ref_no = ?', 'Y');