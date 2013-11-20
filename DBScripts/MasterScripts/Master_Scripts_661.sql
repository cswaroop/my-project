DECLARE
   fetchqueryisdfor_siconc    CLOB
      := 'INSERT INTO IS_D(
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
adjustment_amount, 
our_person_incharge, 
is_self_billing,
smelter_location,
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
'''' as CONTRACT_DATE,
stragg(PCM.CONTRACT_REF_NO) as CONTRACT_REF_NO,
sum(GMR.QTY) as STOCK_QUANTITY,
'''' as STOCK_REF_NO,
CM.CUR_CODE as INVOICE_AMOUNT_UNIT,
stragg(GMR.GMR_REF_NO) as GMR_REF_NO,
sum(GMR.QTY) as GMR_QUALITY,
sum(PCPD.QTY_MAX_VAL) as CONTRACT_QUANTITY,
QUM.QTY_UNIT as CONTRACT_QTY_UNIT,
stragg(PCPD.MAX_TOLERANCE) as CONTRACT_TOLERANCE,
stragg(QAT.QUALITY_NAME) as QUALITY,
stragg(PDM.PRODUCT_DESC) as PRODUCT,
stragg(PCM.CP_CONTRACT_REF_NO) as CP_CONTRACT_REF_NO,
stragg(PYM.PAYMENT_TERM) as PAYMENT_TERM,
sum(GMR.FINAL_WEIGHT) as GMR_FINALIZE_QTY,
stragg(PHD.COMPANYNAME) as CP_NAME,
stragg(PAD.ADDRESS) as CP_ADDRESS,
stragg(CYM.COUNTRY_NAME) as CP_COUNTRY,
stragg(CIM.CITY_NAME) as CP_CITY,
stragg(SM.STATE_NAME) as CP_STATE,
stragg(PAD.ZIP) as CP_ZIP,
stragg(distinct PCM.CONTRACT_TYPE) as CONTRACT_TYPE,
stragg(CYMLOADING.COUNTRY_NAME) as ORIGIN,
stragg(PCI.TERMS) as INCO_TERM_LOCATION,
stragg(nvl(PHD1.COMPANYNAME, PHD2.COMPANYNAME)) as NOTIFY_PARTY, 
stragg(distinct PCI.CONTRACT_TYPE) as SALES_PURCHASE,
INVS.INVOICE_STATUS as INVOICE_STATUS,
INVS.IS_INV_DRAFT as IS_INV_DRAFT,
invs.invoice_adjustment_amount As adjustment_amount,
(GAB.FIRSTNAME||'' ''||GAB.LASTNAME) AS our_person_incharge, pcm.is_self_billing as is_self_billing, F_STRING_AGGREGATE(phd3.companyname) AS smelter_location,
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
PHD_PROFILEHEADERDETAILS phd3,
QUM_QUANTITY_UNIT_MASTER qum_gmr,
SIGM_SERVICE_INV_GMR_MAPPING SIGM,
GCIM_GMR_CONTRACT_ITEM_MAPPING GCIM,
AK_CORPORATE_USER akuser,
GAB_GLOBALADDRESSBOOK gab,
AXS_ACTION_SUMMARY axs,
IAM_INVOICE_ACTION_MAPPING IAM
where
INVS.INTERNAL_INVOICE_REF_NO = SIGM.INTERNAL_INV_REF_NO
AND SIGM.IS_ACTIVE = ''Y''
AND SIGM.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO
AND GMR.INTERNAL_GMR_REF_NO = GCIM.INTERNAL_GMR_REF_NO
and GCIM.INTERNAL_CONTRACT_ITEM_REF_NO = PCI.INTERNAL_CONTRACT_ITEM_REF_NO
and GMR.INTERNAL_CONTRACT_REF_NO = PCM.INTERNAL_CONTRACT_REF_NO
and INVS.INVOICE_CUR_ID = CM.CUR_ID
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
AND PAD.ADDRESS_TYPE(+) = ''Billing''
and CYMLOADING.COUNTRY_ID(+) = GMR.LOADING_COUNTRY_ID
and GMR.INTERNAL_GMR_REF_NO = SAD.INTERNAL_GMR_REF_NO(+)
and GMR.INTERNAL_GMR_REF_NO = SD.INTERNAL_GMR_REF_NO(+)
and SAD.CONSIGNEE_ID = PHD1.PROFILEID(+)
and SD.CONSIGNEE_ID = PHD2.PROFILEID(+)
AND gmr.warehouse_profile_id = phd3.profileid(+)
and GMR.QTY_UNIT_ID = QUM_GMR.QTY_UNIT_ID(+)
and PAD.IS_DELETED = ''N''
AND INVS.INTERNAL_INVOICE_REF_NO = IAM.INTERNAL_INVOICE_REF_NO
AND IAM.INVOICE_ACTION_REF_NO = AXS.INTERNAL_ACTION_REF_NO
AND AXS.ACTION_ID != ''MODIFY_INVOICE''
AND AXS.CREATED_BY = AKUSER.USER_ID
AND AKUSER.GABID = GAB.GABID
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
CM.CUR_CODE,
QUM.QTY_UNIT,
QUM_GMR.QTY_UNIT,
INVS.AMOUNT_TO_PAY_BEFORE_ADJ,
INVS.INVOICE_STATUS, 
INVS.IS_INV_DRAFT,
invs.invoice_adjustment_amount,
GAB.FIRSTNAME,
GAB.LASTNAME,
pcm.is_self_billing';
   fetchqueryvatdfor_vatconc   CLOB
      := 'INSERT INTO vat_d
            (internal_invoice_ref_no, contract_ref_no, cp_contract_ref_no,
             inco_term_location, contract_date, cp_name, seller,
             contract_quantity, contract_tolerance, product, quality,
             notify_party, invoice_creation_date, invoice_due_date,
             invoice_ref_no, contract_type, invoice_status, sales_purchase,
             internal_doc_ref_no, vat_parent_ref_no, is_self_billing,
             our_person_incharge, smelter_location)
   SELECT   invs.internal_invoice_ref_no AS internal_invoice_ref_no,
            NVL (pcm.contract_ref_no, '''') AS contract_ref_no,
            NVL (pcm.cp_contract_ref_no, '''') AS cp_contract_ref_no,
            NVL (pym.payment_term, '''') AS inco_term_location,
            NVL (TO_CHAR (pcm.issue_date, ''dd-Mon-yyyy''),
                 '''') AS contract_date, phd.companyname AS cp_name,
            '''' AS seller, NVL (pcpd.qty_max_val, '''') AS contract_quantity,
            '''' AS contract_tolerance, NVL (pdm.product_desc, '''') AS product,
            NVL (qat.quality_name, '''') AS quality, '''' AS notify_party,
            TO_CHAR (invs.invoice_created_date,
                     ''dd-Mon-yyyy''
                    ) AS invoice_creation_date,
            TO_CHAR (invs.payment_due_date,
                     ''dd-Mon-yyyy'') AS invoice_due_date,
            invs.invoice_ref_no AS invoice_ref_no,
            NVL (pcm.contract_type, '''') AS contract_type,
            invs.invoice_status AS invoice_status,
            NVL (pcm.purchase_sales, '''') AS sales_purchase, ?,
            invs.vat_parent_ref_no AS vat_parent_ref_no,
            pcm.is_self_billing AS is_self_billing,
            (gab.firstname || '' '' || gab.lastname) AS our_person_incharge,
            F_STRING_AGGREGATE (phd_ware.companyname) AS warehouse
       FROM is_invoice_summary invs,
            ivd_invoice_vat_details ivd,
            pcm_physical_contract_main pcm,
            v_pci pci,
            phd_profileheaderdetails phd,
            pdm_productmaster pdm,
            pym_payment_terms_master pym,
            qat_quality_attributes qat,
            pcpd_pc_product_definition pcpd,
            iam_invoice_action_mapping iam,
            axs_action_summary axs,
            ak_corporate_user akuser,
            gab_globaladdressbook gab,
            vpcm_vat_parent_child_map vpcm,
            gmr_goods_movement_record gmr,
            iid_invoicable_item_details iid,
            phd_profileheaderdetails phd_ware
      WHERE invs.internal_invoice_ref_no = ivd.internal_invoice_ref_no
        AND invs.internal_contract_ref_no = pcm.internal_contract_ref_no(+)
        AND pcpd.internal_contract_ref_no(+) = pcm.internal_contract_ref_no
        AND pcpd.product_id = pdm.product_id(+)
        AND NVL (pcpd.input_output, ''Input'') = ''Input''
        AND pci.internal_contract_ref_no(+) = pcm.internal_contract_ref_no
        AND pci.quality_id = qat.quality_id(+)
        AND invs.cp_id = phd.profileid(+)
        AND invs.credit_term = pym.payment_term_id
        AND invs.internal_invoice_ref_no = iam.internal_invoice_ref_no
        AND iam.invoice_action_ref_no = axs.internal_action_ref_no
        AND axs.action_id != ''MODIFY_INVOICE''
        AND axs.created_by = akuser.user_id
        AND akuser.gabid = gab.gabid
        AND ivd.internal_invoice_ref_no = vpcm.vat_internal_invoice_ref_no(+)
        AND vpcm.internal_invoice_ref_no = iid.internal_invoice_ref_no(+)
        AND iid.internal_gmr_ref_no = gmr.internal_gmr_ref_no(+)
        AND gmr.warehouse_profile_id = phd_ware.profileid(+)
        AND invs.internal_invoice_ref_no = ?
   GROUP BY invs.internal_invoice_ref_no,
            pcm.contract_ref_no,
            pcm.cp_contract_ref_no,
            pym.payment_term,
            pcm.issue_date,
            phd.companyname,
            pcpd.qty_max_val,
            pdm.product_desc,
            qat.quality_name,
            invs.invoice_created_date,
            invs.payment_due_date,
            invs.invoice_ref_no,
            pcm.contract_type,
            invs.invoice_status,
            pcm.purchase_sales,
            invs.vat_parent_ref_no,
            pcm.is_self_billing,
            gab.firstname,
            gab.lastname';
BEGIN
   UPDATE dgm_document_generation_master dgm
      SET dgm.fetch_query = fetchqueryisdfor_siconc
    WHERE dgm.doc_id = 'CREATE_SI'
      AND dgm.dgm_id = 'DGM-SIC'
      AND dgm.sequence_order = 1
      AND dgm.is_concentrate = 'Y';

   UPDATE dgm_document_generation_master dgm
      SET dgm.fetch_query = fetchqueryvatdfor_vatconc
    WHERE dgm.doc_id = 'CREATE_VAT'
      AND dgm.dgm_id = 'DGM-VAT-1-CONC'
      AND dgm.sequence_order = 1
      AND dgm.is_concentrate = 'Y';

   COMMIT;
END;