declare
fetchQry1 CLOB :='INSERT INTO IS_D (
INTERNAL_INVOICE_REF_NO,
CP_NAME,
CP_ITEM_STOCK_REF_NO,
INCO_TERM_LOCATION,
CONTRACT_REF_NO,
CP_CONTRACT_REF_NO,
CONTRACT_DATE,
PRODUCT,
INVOICE_QUANTITY,
INVOICED_QTY_UNIT,
QUALITY,
PAYMENT_TERM,
DUE_DATE,
INVOICE_CREATION_DATE,
INVOICE_AMOUNT,
INVOICE_AMOUNT_UNIT,
INVOICE_REF_NO,
CONTRACT_TYPE,
INVOICE_STATUS,
SALES_PURCHASE,
TOTAL_TAX_AMOUNT,
TOTAL_OTHER_CHARGE_AMOUNT,
INTERNAL_DOC_REF_NO
)
select
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
PHD.COMPANYNAME as CP_NAME,
INVS.CP_REF_NO as CP_ITEM_STOCK_REF_NO,
PCI.TERMS as INCO_TERM_LOCATION,
PCM.CONTRACT_REF_NO as CONTRACT_REF_NO,
PCM.CP_CONTRACT_REF_NO as CP_CONTRACT_REF_NO,
TO_CHAR(PCM.ISSUE_DATE,''dd-Mon-yyyy'') as CONTRACT_DATE,
PDM.PRODUCT_DESC as PRODUCT,
INVS.INVOICED_QTY as INVOICE_QUANTITY,
QUM.QTY_UNIT as INVOICED_QTY_UNIT,
stragg(QAT.QUALITY_NAME) as QUALITY,
PYM.PAYMENT_TERM as PAYMENT_TERM,
TO_CHAR(INVS.PAYMENT_DUE_DATE,''dd-Mon-yyyy'') as DUE_DATE,
TO_CHAR(INVS.INVOICE_ISSUE_DATE,''dd-Mon-yyyy'') as INVOICE_CREATION_DATE,
INVS.TOTAL_AMOUNT_TO_PAY as INVOICE_AMOUNT,
CM.CUR_CODE as INVOICE_AMOUNT_UNIT,
INVS.INVOICE_REF_NO as INVOICE_REF_NO,
PCM.CONTRACT_TYPE as CONTRACT_TYPE,
INVS.INVOICE_STATUS as INVOICE_STATUS,
PCM.PURCHASE_SALES as SALES_PURCHASE,
INVS.TOTAL_TAX_AMOUNT as TOTAL_TAX_AMOUNT,
INVS.TOTAL_OTHER_CHARGE_AMOUNT as TOTAL_OTHER_CHARGE_AMOUNT,
?
from
IS_INVOICE_SUMMARY invs,
APID_ADV_PAYMENT_ITEM_DETAILS apid,
PCM_PHYSICAL_CONTRACT_MAIN pcm,
V_PCI pci,
PHD_PROFILEHEADERDETAILS phd,
PDM_PRODUCTMASTER pdm,
QAT_QUALITY_ATTRIBUTES qat,
PCPD_PC_PRODUCT_DEFINITION pcpd,
CM_CURRENCY_MASTER cm,
PYM_PAYMENT_TERMS_MASTER pym,
QUM_QUANTITY_UNIT_MASTER qum,
PPU_PRODUCT_PRICE_UNITS ppu,
PUM_PRICE_UNIT_MASTER pum
where
INVS.INTERNAL_INVOICE_REF_NO = APID.INTERNAL_INVOICE_REF_NO
and APID.CONTRACT_ITEM_REF_NO = PCI.INTERNAL_CONTRACT_ITEM_REF_NO
and INVS.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and PCPD.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and PCPD.PRODUCT_ID = PDM.PRODUCT_ID
and PCPD.QTY_UNIT_ID = QUM.QTY_UNIT_ID
and PCPD.INPUT_OUTPUT = ''Input''
and PCI.QUALITY_ID = QAT.QUALITY_ID
AND PCM.CP_ID = PHD.PROFILEID(+)
and INVS.INVOICE_CUR_ID = CM.CUR_ID
and PCM.PAYMENT_TERM_ID = PYM.PAYMENT_TERM_ID
and APID.INVOICE_ITEM_PRICE_UNIT_ID = PPU.INTERNAL_PRICE_UNIT_ID(+)
and PPU.PRICE_UNIT_ID = PUM.PRICE_UNIT_ID
and INVS.INTERNAL_INVOICE_REF_NO = ?
group by
PCM.CONTRACT_REF_NO,
PDM.PRODUCT_DESC,
PHD.COMPANYNAME,
INVS.CP_REF_NO,
PCI.TERMS,
PCM.CP_CONTRACT_REF_NO,
PCM.ISSUE_DATE,
INVS.INVOICE_REF_NO,
INVS.INVOICE_ISSUE_DATE,
INVS.PAYMENT_DUE_DATE,
INVS.TOTAL_AMOUNT_TO_PAY,
CM.CUR_CODE,
PYM.PAYMENT_TERM,
PCM.CONTRACT_TYPE,
INVS.INVOICE_STATUS,
PCM.PURCHASE_SALES,
INVS.TOTAL_TAX_AMOUNT,
INVS.TOTAL_OTHER_CHARGE_AMOUNT,
PUM.PRICE_UNIT_NAME,
INVS.INTERNAL_INVOICE_REF_NO,
INVS.INVOICED_QTY,
QUM.QTY_UNIT';
begin

UPDATE dgm_document_generation_master dgm
   SET dgm.fetch_query = fetchqry1
 WHERE dgm.doc_id = 'CREATE_API'
   AND dgm.dgm_id IN ('DGM-API-1-1', 'DGM-API-1-1-CONC');
  
commit;
end;


DECLARE
   fetchqry1   CLOB
      := 'INSERT INTO is_bds_child_d
            (internal_invoice_ref_no, beneficiary_name, bank_name, account_no,
             aba_rtn, instruction,remarks,internal_doc_ref_no)
   SELECT invs.internal_invoice_ref_no AS internal_invoice_ref_no,
          oipi.beneficiary_name AS beneficiary_name,
          phd.companyname AS bank_name, oipi.bank_account AS account_no,
          oipi.aba_no AS aba_rtn, oipi.instructions AS instruction,'''' as remarks, ?
     FROM phd_profileheaderdetails phd,
          oba_our_bank_accounts oba,
          is_invoice_summary invs,
          oipi_our_inv_pay_instruction oipi  
    WHERE invs.internal_invoice_ref_no = oipi.internal_invoice_ref_no
      AND oba.bank_id = phd.profileid
      AND oba.bank_id = oipi.bank_id
      and OIPI.BANK_ACCOUNT_ID = OBA.ACCOUNT_ID
      AND invs.internal_invoice_ref_no = ?';
   fetchqry2   CLOB
      := 'INSERT INTO is_bdp_child_d
            (internal_invoice_ref_no, beneficiary_name, bank_name, account_no,
             aba_rtn, instruction,remarks,internal_doc_ref_no)
   SELECT invs.internal_invoice_ref_no AS internal_invoice_ref_no,
          cpipi.beneficiary_name AS beneficiary_name,
          bpb.bank_name AS bank_name, bpa.account_no AS account_no,
          cpipi.aba_no AS aba_rtn, cpipi.instructions AS instruction,'''' as remarks, ?
     FROM bpa_bp_bank_accounts bpa,
          bpb_business_partner_banks bpb,
          is_invoice_summary invs,
          cpipi_cp_inv_pay_instruction cpipi
    WHERE invs.internal_invoice_ref_no = cpipi.internal_invoice_ref_no
      AND cpipi.bank_id = bpa.bank_id
      AND bpa.bank_id = bpb.bank_id
      and CPIPI.BANK_ACCOUNT_ID = BPA.ACCOUNT_ID
      AND invs.internal_invoice_ref_no = ?';
BEGIN
   UPDATE dgm_document_generation_master dgm
      SET dgm.fetch_query = fetchqry1
    WHERE dgm.doc_id IN
             ('CREATE_API', 'CREATE_DFI', 'CREATE_FI', 'CREATE_PFI',
              'CREATE_PI', 'CREATE_SI')
      AND dgm.dgm_id IN
             ('DGM-API-2-CONC', 'DGM-API-2', 'DGM-DFIC-C5', 'DGM-DFI-C3',
              'DGM-FIC-C5', 'DGM-FI-C3', 'DGM-PFI-3', 'DGM-PFI-3-CONC',
              'DGM-PI-C3', 'DGM-PIC-C5', 'DGM-SI-3', 'DGM-SIC-3');

   UPDATE dgm_document_generation_master dgm
      SET dgm.fetch_query = fetchqry2
    WHERE dgm.doc_id IN
             ('CREATE_API', 'CREATE_DFI', 'CREATE_FI', 'CREATE_PFI',
              'CREATE_PI', 'CREATE_SI')
      AND dgm.dgm_id IN
             ('DGM-API-3-CONC', 'DGM-API-3', 'DGM-DFIC-C6', 'DGM-DFI-C4',
              'DGM-FIC-C6', 'DGM-FI-C4', 'DGM-PFI-4', 'DGM-PFI-4-CONC',
              'DGM-PI-C4', 'DGM-PIC-C6', 'DGM-SI-2', 'DGM-SIC-2');
END;
