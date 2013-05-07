declare 
fetchQueryISDDraftSI clob := 'INSERT INTO IS_D(
INVOICE_REF_NO,
INVOICE_TYPE_NAME,
INVOICE_CREATION_DATE,
INVOICE_QUANTITY,
INVOICED_QTY_UNIT,
INTERNAL_INVOICE_REF_NO,
INVOICE_AMOUNT,
MATERIAL_COST,
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
INVOICE_STATUS,
IS_INV_DRAFT,
INTERNAL_DOC_REF_NO
)
select
INVS.INVOICE_REF_NO as INVOICE_REF_NO,
INVS.INVOICE_TYPE_NAME as INVOICE_TYPE_NAME,
INVS.INVOICE_ISSUE_DATE as INVOICE_CREATION_DATE,
INVS.INVOICED_QTY as INVOICE_QUANTITY,
QUM_GMR.QTY_UNIT as INVOICED_QTY_UNIT,
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
INVS.TOTAL_AMOUNT_TO_PAY as INVOICE_AMOUNT,
INVS.AMOUNT_TO_PAY_BEFORE_ADJ as MATERIAL_COST,
INVS.TOTAL_OTHER_CHARGE_AMOUNT as ADDDITIONAL_CHARGES,
INVS.TOTAL_TAX_AMOUNT as TAXES,
INVS.PAYMENT_DUE_DATE as DUE_DATE,
INVS.CP_REF_NO as SUPPLIER_INVOICE_NO,
PCM.ISSUE_DATE as CONTRACT_DATE,
PCM.CONTRACT_REF_NO as CONTRACT_REF_NO,
GMR.QTY as STOCK_QUANTITY,
'''' as STOCK_REF_NO,
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
INVS.INVOICE_STATUS as INVOICE_STATUS,
INVS.IS_INV_DRAFT as IS_INV_DRAFT,
?
from 
IS_INVOICE_SUMMARY invs,
PCM_PHYSICAL_CONTRACT_MAIN pcm,
V_PCI pci,
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
QUM_QUANTITY_UNIT_MASTER qum_gmr,
SIGM_SERVICE_INV_GMR_MAPPING SIGM,
GCIM_GMR_CONTRACT_ITEM_MAPPING GCIM
where
INVS.INTERNAL_INVOICE_REF_NO = SIGM.INTERNAL_INV_REF_NO
AND SIGM.IS_ACTIVE = ''Y''
AND SIGM.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO
AND GMR.INTERNAL_GMR_REF_NO = GCIM.INTERNAL_GMR_REF_NO
and GCIM.INTERNAL_CONTRACT_ITEM_REF_NO = PCI.INTERNAL_CONTRACT_ITEM_REF_NO
and GMR.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and PCM.INVOICE_CURRENCY_ID = CM.CUR_ID
and PCM.INTERNAL_CONTRACT_REF_NO = PCPD.INTERNAL_CONTRACT_REF_NO
and PCPD.QTY_UNIT_ID = QUM.QTY_UNIT_ID
and PCPD.PCPD_ID = PCPQ.PCPD_ID
and PCI.QUALITY_ID = QAT.QUALITY_ID
and PCPQ.QUALITY_TEMPLATE_ID = QAT.QUALITY_ID
and PCPD.PRODUCT_ID = PDM.PRODUCT_ID
and PCM.CP_ID = PHD.PROFILEID
and PCM.PAYMENT_TERM_ID = PYM.PAYMENT_TERM_ID
and PHD.PROFILEID = PAD.PROFILE_ID
and PAD.COUNTRY_ID = CYM.COUNTRY_ID
and PAD.CITY_ID = CIM.CITY_ID(+)
and PAD.STATE_ID = SM.STATE_ID(+)
and PAD.ADDRESS_TYPE = BPAT.BP_ADDRESS_TYPE_ID(+)
and CYMLOADING.COUNTRY_ID(+) = GMR.LOADING_COUNTRY_ID
and GMR.INTERNAL_GMR_REF_NO = SAD.INTERNAL_GMR_REF_NO(+)
and GMR.INTERNAL_GMR_REF_NO = SD.INTERNAL_GMR_REF_NO(+)
and SAD.CONSIGNEE_ID = PHD1.PROFILEID(+)
and SD.CONSIGNEE_ID = PHD2.PROFILEID(+)
and GMR.QTY_UNIT_ID = QUM_GMR.QTY_UNIT_ID(+)
and PAD.IS_DELETED = ''N''
and INVS.INTERNAL_INVOICE_REF_NO = ?
group by
INVS.INVOICE_REF_NO,
INVS.INVOICE_TYPE_NAME,
INVS.INVOICE_ISSUE_DATE,
INVS.INVOICED_QTY,
INVS.INTERNAL_INVOICE_REF_NO,
INVS.TOTAL_AMOUNT_TO_PAY,
INVS.TOTAL_OTHER_CHARGE_AMOUNT,
INVS.TOTAL_TAX_AMOUNT,
INVS.PAYMENT_DUE_DATE,
INVS.CP_REF_NO,
PCM.ISSUE_DATE,
PCM.CONTRACT_REF_NO,
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
PCI.CONTRACT_TYPE,
INVS.AMOUNT_TO_PAY_BEFORE_ADJ,
INVS.INVOICE_STATUS, 
INVS.IS_INV_DRAFT';


fetchQueryISBDSForSIDRAFT clob := 'INSERT INTO is_bds_child_d
            (internal_invoice_ref_no, beneficiary_name, bank_name, account_no,
             aba_rtn, instruction,remarks,internal_doc_ref_no)
   SELECT invs.internal_invoice_ref_no AS internal_invoice_ref_no,
          oipi.beneficiary_name AS beneficiary_name,
          phd.companyname AS bank_name, oipi.bank_account AS account_no,
          oipi.aba_no AS aba_rtn, oipi.instructions AS instruction, OIPI.REMARKS as remarks, ?
     FROM phd_profileheaderdetails phd,
          oba_our_bank_accounts oba,
          is_invoice_summary invs,
          oipi_our_inv_pay_instruction oipi  
    WHERE invs.internal_invoice_ref_no = oipi.internal_invoice_ref_no
      AND oba.bank_id = phd.profileid
      AND oba.bank_id = oipi.bank_id
      and OIPI.BANK_ACCOUNT_ID = OBA.ACCOUNT_ID
      AND invs.internal_invoice_ref_no = ?';
      
fetchQueryISBDPForSIDRAFT clob := 'INSERT INTO is_bdp_child_d
            (internal_invoice_ref_no, beneficiary_name, bank_name, account_no,
             aba_rtn, instruction, remarks, iban, internal_doc_ref_no)
   SELECT invs.internal_invoice_ref_no AS internal_invoice_ref_no,
          cpipi.beneficiary_name AS beneficiary_name,
          bpb.bank_name AS bank_name, bpa.account_no AS account_no,
          cpipi.aba_no AS aba_rtn, cpipi.instructions AS instruction,
          cpipi.remarks AS remarks, bpa.iban AS iban, ?
     FROM bpa_bp_bank_accounts bpa,
          bpb_business_partner_banks bpb,
          is_invoice_summary invs,
          cpipi_cp_inv_pay_instruction cpipi
    WHERE invs.internal_invoice_ref_no = cpipi.internal_invoice_ref_no
      AND cpipi.bank_id = bpa.bank_id
      AND bpa.bank_id = bpb.bank_id
      AND cpipi.bank_account_id = bpa.account_id
      AND invs.internal_invoice_ref_no = ?';

fetchQueryISCHILDForSIDRAFT clob :='INSERT INTO IS_CHILD_SI_D(
INTERNAL_INVOICE_REF_NO,
GMR_REF_NO,
COST_COMPONENT_NAME,
INVOICE_AMOUNT,
INVOICE_AMOUNT_UNIT,
INV_AMT_IN_INV_CUR,
INVOICE_CURRENCY,
INV_TO_ACCRUAL_FX_RATE,
INTERNAL_DOC_REF_NO
)
select
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
GMR.GMR_REF_NO as GMR_REF_NO,
SCM.COST_COMPONENT_NAME as COST_COMPONENT_NAME,
CS.TRANSACTION_AMT as INVOICE_AMOUNT,
CM1.CUR_CODE as INVOICE_AMOUNT_UNIT,
CS.INV_AMT_IN_INV_CUR as INV_AMT_IN_INV_CUR,
CM2.CUR_CODE as INVOICE_CURRENCY,
CS.INV_TO_ACCRUAL_CURR_FX as INV_TO_ACCRUAL_FX_RATE,?
from
IS_INVOICE_SUMMARY invs,
IAM_INVOICE_ACTION_MAPPING iam,
CS_COST_STORE cs,
CIGC_CONTRACT_ITEM_GMR_COST cigc,
GMR_GOODS_MOVEMENT_RECORD gmr,
SCM_SERVICE_CHARGE_MASTER scm,
CM_CURRENCY_MASTER cm1,
CM_CURRENCY_MASTER cm2
where
INVS.INTERNAL_INVOICE_REF_NO = IAM.INTERNAL_INVOICE_REF_NO
and IAM.INVOICE_ACTION_REF_NO = CS.INTERNAL_ACTION_REF_NO
and CS.COG_REF_NO = CIGC.COG_REF_NO
and CIGC.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO
and CS.COST_COMPONENT_ID = SCM.COST_ID
and CM1.CUR_ID(+) = CS.TRANSACTION_AMT_CUR_ID
AND CM2.CUR_ID(+) =  CS.INVOICE_CURRENCY
and INVS.INVOICE_TYPE = ''Service''
and INVS.INTERNAL_INVOICE_REF_NO = ?';

fetchQueryITDForSIDRAFT clob := 'INSERT INTO itd_d
            (internal_invoice_ref_no, tax_code, tax_rate, invoice_currency,
             fx_rate, amount, tax_currency, invoice_amount, applicable_on,
             internal_doc_ref_no)
   SELECT invs.internal_invoice_ref_no AS internal_invoice_ref_no,
          tm.tax_code AS tax_code, itd.tax_rate AS tax_rate,
          cm.cur_code AS invoice_currency, itd.fx_rate AS fx_rate,
          itd.tax_amount AS amount, cm_tax.cur_code AS tax_currency,
          itd.tax_amount_in_inv_cur AS invoice_amount,
          itd.applicable_on AS applicable_on, ?
     FROM is_invoice_summary invs,
          itd_invoice_tax_details itd,
          tm_tax_master tm,
          cm_currency_master cm,
          cm_currency_master cm_tax
    WHERE invs.internal_invoice_ref_no = itd.internal_invoice_ref_no
      AND itd.tax_code_id = tm.tax_id
      AND itd.invoice_cur_id = cm.cur_id
      AND itd.tax_amount_cur_id = cm_tax.cur_id
      AND itd.internal_invoice_ref_no = ?';

begin
    UPDATE DGM_DOCUMENT_GENERATION_MASTER DGM SET DGM.FETCH_QUERY = fetchQueryISDDraftSI WHERE DGM.DGM_ID='DGM-DFT-SI' AND DGM.DOC_ID='CREATE_DFT_SI';
    
    Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SI-1', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 2, 
    fetchQueryISCHILDForSIDRAFT, 'N');
    
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SI-2', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 3, 
    fetchQueryITDForSIDRAFT, 'N');
    
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SI-3', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 4, 
    fetchQueryISBDPForSIDRAFT, 'N');
    
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SI-4', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 5, 
    fetchQueryISBDSForSIDRAFT, 'N');
    
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SIC', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 1, 
    fetchQueryISDDraftSI, 'Y');

Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SIC-1', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 2, 
    fetchQueryISCHILDForSIDRAFT, 'Y');
    
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SIC-2', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 3, 
    fetchQueryITDForSIDRAFT, 'Y');
    
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SIC-3', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 4, 
    fetchQueryISBDPForSIDRAFT, 'Y');
    
Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-DFT-SIC-4', 'CREATE_DFT_SI', 'Draft Service Invoice', 'CREATE_DFT_SI', 5, 
    fetchQueryISBDSForSIDRAFT, 'Y');
commit;
end;