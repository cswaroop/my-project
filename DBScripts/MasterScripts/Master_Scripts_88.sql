Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-VAT-1', 'CREATE_VAT', 'VAT Invoice', 'CREATE_VAT', 1, 
    'INSERT INTO VAT_D (
INTERNAL_INVOICE_REF_NO,
CONTRACT_REF_NO,
CP_CONTRACT_REF_NO,
INCO_TERM_LOCATION,
CONTRACT_DATE,
CP_NAME,
SELLER,
CONTRACT_QUANTITY,
CONTRACT_TOLERANCE,
PRODUCT,
QUALITY,
NOTIFY_PARTY,
INVOICE_CREATION_DATE,
INVOICE_REF_NO,
CONTRACT_TYPE,
INVOICE_STATUS,
SALES_PURCHASE,
INTERNAL_DOC_REF_NO
)
select
INVS.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
PCM.CONTRACT_REF_NO as CONTRACT_REF_NO,
PCM.CP_CONTRACT_REF_NO as CP_CONTRACT_REF_NO,
PCI.TERMS as INCO_TERM_LOCATION,
TO_CHAR(PCM.ISSUE_DATE, ''dd-Mon-yyyy'') as CONTRACT_DATE,
PHD.COMPANYNAME as CP_NAME,
'''' as SELLER,
'''' as CONTRACT_QUANTITY,
'''' as CONTRACT_TOLERANCE,
PDM.PRODUCT_DESC as PRODUCT,
QAT.QUALITY_NAME as QUALITY,
'''' as NOTIFY_PARTY,
TO_CHAR(INVS.INVOICE_CREATED_DATE, ''dd-Mon-yyyy'') as INVOICE_CREATION_DATE,
INVS.INVOICE_REF_NO as INVOICE_REF_NO,
PCM.CONTRACT_TYPE as CONTRACT_TYPE,
INVS.INVOICE_STATUS as INVOICE_STATUS,
PCM.PURCHASE_SALES as SALES_PURCHASE,
?
from
IS_INVOICE_SUMMARY invs,
IVD_INVOICE_VAT_DETAILS ivd,
PCM_PHYSICAL_CONTRACT_MAIN pcm,
v_pci pci,
PHD_PROFILEHEADERDETAILS phd,
PDM_PRODUCTMASTER pdm,
QAT_QUALITY_ATTRIBUTES qat,
PCPD_PC_PRODUCT_DEFINITION pcpd
where
INVS.INTERNAL_INVOICE_REF_NO = IVD.INTERNAL_INVOICE_REF_NO
and INVS.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and PCPD.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and PCPD.PRODUCT_ID = PDM.PRODUCT_ID
and PCI.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and PCI.QUALITY_ID = QAT.QUALITY_ID
AND PCM.CP_ID = PHD.PROFILEID(+)
and INVS.INTERNAL_INVOICE_REF_NO = ?', 'N');

Insert into DGM_DOCUMENT_GENERATION_MASTER
   (DGM_ID, DOC_ID, DOC_NAME, ACTIVITY_ID, SEQUENCE_ORDER, 
    FETCH_QUERY, IS_CONCENTRATE)
 Values
   ('DGM-VAT-2', 'CREATE_VAT', 'VAT Invoice', 'CREATE_VAT', 2, 
    'INSERT INTO VAT_CHILD_D (
INTERNAL_INVOICE_REF_NO,
VAT_NO,
CP_VAT_NO,
VAT_CODE,
VAT_RATE,
VAT_AMOUNT,
VAT_AMOUNT_CUR,
INTERNAL_DOC_REF_NO
)
select
IVD.INTERNAL_INVOICE_REF_NO as INTERNAL_INVOICE_REF_NO,
IVD.OUR_VAT_NO as VAT_NO,
IVD.CP_VAT_NO as CP_VAT_NO,
TM.TAX_CODE as VAT_CODE,
IVD.VAT_RATE as VAT_RATE,
IVD.VAT_AMOUNT_IN_INV_CUR as VAT_AMOUNT,
CM.CUR_CODE as VAT_AMOUNT_CUR,
?
from
IVD_INVOICE_VAT_DETAILS ivd,
IS_INVOICE_SUMMARY invs,
CM_CURRENCY_MASTER cm,
TM_TAX_MASTER tm
where
INVS.INTERNAL_INVOICE_REF_NO = IVD.INTERNAL_INVOICE_REF_NO
and IVD.INVOICE_CUR_ID = CM.CUR_ID
and IVD.VAT_CODE = TM.TAX_ID
and INVS.INTERNAL_INVOICE_REF_NO = ?', 'N');



Insert into DM_DOCUMENT_MASTER
   (DOC_ID, DOC_NAME, DISPLAY_ORDER, VERSION, IS_ACTIVE, 
    IS_DELETED, ACTIVITY_ID)
 Values
   ('CREATE_VAT', 'Vat Invoice', 1, NULL, 'Y', 
    'N', NULL);

Insert into ADM_ACTION_DOCUMENT_MASTER
   (ADM_ID, ACTION_ID, DOC_ID, IS_DELETED)
 Values
   ('ADM-VAT-1', 'CREATE_VAT', 'CREATE_VAT', 'N');

Insert into DKM_DOC_REF_KEY_MASTER
   (DOC_KEY_ID, DOC_KEY_DESC, VALIDATION_QUERY)
 Values
   ('VAT_KEY_1', 'Vat Invoice', 'SELECT COUNT (*) FROM DS_DOCUMENT_SUMMARY ds WHERE DS.DOC_REF_NO = :pc_document_ref_no AND DS.CORPORATE_ID = :pc_corporate_id');

Insert into DKM_DOC_REF_KEY_MASTER
   (DOC_KEY_ID, DOC_KEY_DESC, VALIDATION_QUERY)
 Values
   ('VAT_KEY_2', 'Vat Invoice', 'SELECT COUNT (*) FROM DS_DOCUMENT_SUMMARY ds WHERE DS.DOC_REF_NO = :pc_document_ref_no AND DS.CORPORATE_ID = :pc_corporate_id');

