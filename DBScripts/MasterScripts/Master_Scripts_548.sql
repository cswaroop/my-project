declare fetchQueryISRC CLOB := 'INSERT INTO IS_CONC_RC_CHILD(
        INTERNAL_INVOICE_REF_NO,
        RC_AMOUNT,
        ELEMENT_NAME,
        ELEMENT_ID,
        AMOUNT_UNIT,
        SUB_LOT_NO,
        DRY_QUANTITY,
        QUANTITY_UNIT_NAME,
        assay_details,
        rc_es_ds,
        BASE_RC,
        assay_uom,
        STOCK_REF_NO,
        BASEESCDESC_TYPE,
        PAYABLE_QTY,
        INTERNAL_DOC_REF_NO
        )

SELECT   invs.internal_invoice_ref_no AS internal_invoice_ref_no,
         SUM (inrc.rcharges_amount) AS rc_amount,
         aml.attribute_name AS element_name, aml.attribute_id AS element_id,
         cm.cur_code AS amount_unit, inrc.sub_lot_no AS sub_lot_no,
         inrc.lot_qty AS dry_quantity, qum.qty_unit AS quantity_unit_name,
         pqcapd.payable_percentage AS assay_details,

         (SELECT   SUM (rcharges_amount)
              FROM inrc_inv_refining_charges inrc_inner
             WHERE inrc_inner.internal_invoice_ref_no =
                                invs.internal_invoice_ref_no
               AND inrc_inner.grd_id = inrc.grd_id
               AND inrc_inner.baseescdesc_type = ''Esc/Desc''
               AND inrc_inner.baseescdesc_type <> ''Fixed''
          GROUP BY inrc_inner.element_id) AS rc_es_ds,
         (SELECT   SUM (rcharges_amount)
              FROM inrc_inv_refining_charges inrc_inner
             WHERE inrc_inner.internal_invoice_ref_no =
                                   invs.internal_invoice_ref_no
               AND inrc_inner.grd_id = inrc.grd_id
               AND inrc_inner.baseescdesc_type = ''Base''
          GROUP BY inrc_inner.element_id) AS BASE_RC,
         rm.ratio_name AS assay_uom,
         grd.internal_stock_ref_no AS stock_ref_no,
         stragg (DISTINCT inrc.baseescdesc_type) AS BASEESCDESC_TYPE,
            inrc.payable_qty
         || '' ''
         || NVL (qum_rm.qty_unit, qum.qty_unit) AS PAYABLE_QTY,
         ?
    FROM is_invoice_summary invs,
         inrc_inv_refining_charges inrc,
         aml_attribute_master_list aml,
         cm_currency_master cm,
         iam_invoice_assay_mapping iam,
         grd_goods_record_detail grd,
         qum_quantity_unit_master qum,
         ash_assay_header ash,
         asm_assay_sublot_mapping asm,
         pqca_pq_chemical_attributes pqca,
         pqcapd_prd_qlty_cattr_pay_dtls pqcapd,
         ppu_product_price_units ppu,
         pum_price_unit_master pum,
         rm_ratio_master rm,
         qum_quantity_unit_master qum_rm
   WHERE invs.internal_invoice_ref_no = inrc.internal_invoice_ref_no(+)
     AND inrc.element_id = aml.attribute_id(+)
     AND invs.invoice_cur_id = cm.cur_id
     AND invs.internal_invoice_ref_no = iam.internal_invoice_ref_no
     AND inrc.grd_id = iam.internal_grd_ref_no
     AND iam.internal_grd_ref_no = grd.internal_grd_ref_no
     AND grd.internal_grd_ref_no = inrc.grd_id
     AND grd.qty_unit_id = qum.qty_unit_id
     AND iam.ash_id = ash.ash_id
     AND ash.ash_id = asm.ash_id
     AND asm.asm_id = pqca.asm_id
     AND pqca.pqca_id = pqcapd.pqca_id
     AND pqca.element_id = inrc.element_id
     AND inrc.rcharges_price_unit_id = ppu.internal_price_unit_id
     AND ppu.price_unit_id = pum.price_unit_id
     AND pqca.unit_of_measure = rm.ratio_id
     AND rm.qty_unit_id_numerator = qum_rm.qty_unit_id(+)
     AND invs.internal_invoice_ref_no = ?
GROUP BY invs.internal_invoice_ref_no,
         aml.attribute_name,
         aml.attribute_id,
         cm.cur_code,
         inrc.sub_lot_no,
         qum.qty_unit,
         pqcapd.payable_percentage,
         rm.ratio_name,
         grd.internal_stock_ref_no,
         inrc.grd_id,
         inrc.lot_qty,
         inrc.element_id,
         inrc.payable_qty,
         qum_rm.qty_unit';



declare fetchQueryISTC CLOB := 'INSERT INTO IS_CONC_TC_CHILD (
INTERNAL_INVOICE_REF_NO,
TC_AMOUNT,
ELEMENT_ID,
AMOUNT_UNIT,
SUB_LOT_NO,
ELEMENT_NAME,
DRY_QUANTITY,
QUANTITY_UNIT_NAME,
WET_QUANTITY,
moisture,
ESC_DESC_AMOUNT,
BASE_TC,
stock_ref_no,
BASEESCDESC_TYPE,
INTERNAL_DOC_REF_NO
)
SELECT   invs.internal_invoice_ref_no AS internal_invoice_ref_no,SUM (intc.tcharges_amount) AS tc_amount,
         intc.element_id AS element_id, cm.cur_code AS amount_unit,
         intc.sub_lot_no AS sub_lot_no, aml.attribute_name AS element_name,
         SUM (intc.lot_qty) AS dry_qty, qum.qty_unit AS quantity_unit_name,
         SUM (iid.invoiced_qty) AS wet_quantity,
         ROUND (  ((SUM (iid.invoiced_qty) - SUM (intc.lot_qty)) * 100)
                / SUM (iid.invoiced_qty),
                5
               ) AS moisture,
         (SELECT SUM (intc_inner.tcharges_amount)
            FROM intc_inv_treatment_charges intc_inner
           WHERE intc_inner.internal_invoice_ref_no =
                                    invs.internal_invoice_ref_no
             AND intc_inner.grd_id = intc.grd_id
             AND intc_inner.baseescdesc_type = ''Esc/Desc'') AS ESC_DESC_AMOUNT,
         (SELECT SUM (intc_inner.tcharges_amount)
            FROM intc_inv_treatment_charges intc_inner
           WHERE intc_inner.internal_invoice_ref_no =
                                   invs.internal_invoice_ref_no
             AND intc_inner.grd_id = intc.grd_id
             AND intc_inner.baseescdesc_type = ''Base'') AS BASE_TC,
         grd.internal_stock_ref_no AS stock_ref_no,
         stragg (DISTINCT intc.baseescdesc_type) AS BASEESCDESC_TYPE, ?
    FROM is_invoice_summary invs,
         intc_inv_treatment_charges intc,
         cm_currency_master cm,
         ppu_product_price_units ppu,
         pum_price_unit_master pum,
         aml_attribute_master_list aml,
         grd_goods_record_detail grd,
         qum_quantity_unit_master qum,
         iid_invoicable_item_details iid
   WHERE invs.internal_invoice_ref_no = intc.internal_invoice_ref_no(+)
     AND invs.invoice_cur_id = cm.cur_id(+)
     AND intc.tcharges_price_unit_id = ppu.internal_price_unit_id(+)
     AND ppu.price_unit_id = pum.price_unit_id(+)
     AND intc.element_id = aml.attribute_id
     AND intc.grd_id = grd.internal_grd_ref_no
     AND grd.qty_unit_id = qum.qty_unit_id
     AND iid.internal_invoice_ref_no = invs.internal_invoice_ref_no
     AND iid.stock_id = intc.grd_id
     AND invs.internal_invoice_ref_no = ?
GROUP BY invs.internal_invoice_ref_no,
         intc.element_id,
         cm.cur_code,
         intc.sub_lot_no,
         aml.attribute_name,
         qum.qty_unit,
         grd.internal_stock_ref_no,
         intc.grd_id';
      
begin
UPDATE DGM_DOCUMENT_GENERATION_MASTER dgm set DGM.FETCH_QUERY = fetchQueryISRC where DGM.DOC_ID IN ('CREATE_PI','CREATE_FI','CREATE_DFI') and DGM.DGM_ID IN ('DGM-PIC-C3','DGM-FIC-C3','DGM-DFIC-C3') and DGM.IS_CONCENTRATE = 'Y' and DGM.SEQUENCE_ORDER = 4;

UPDATE DGM_DOCUMENT_GENERATION_MASTER dgm set DGM.FETCH_QUERY = fetchQueryISTC where DGM.DOC_ID IN ('CREATE_PI','CREATE_FI','CREATE_DFI') and DGM.DGM_ID IN ('DGM-PIC-C2','DGM-FIC-C2','DGM-DFIC-C2') and DGM.IS_CONCENTRATE = 'Y' and DGM.SEQUENCE_ORDER = 3;

commit;
end;