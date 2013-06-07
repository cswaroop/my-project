create or replace view v_gmr_inv_other_charges as
select t.internal_gmr_ref_no,
       t.internal_invoice_ref_no,
       t.qty gmr_qty,
       nvl(is1.total_other_charge_amount, 0) total_other_charge_amount
  from (select iid.internal_gmr_ref_no,
               substr(max(to_char(axs.created_date, 'yyyymmddhh24missff9') ||
                          iam.internal_invoice_ref_no),
                      24) internal_invoice_ref_no,
               gmr.qty
          from is_invoice_summary          is1,
               iid_invoicable_item_details iid,
               iam_invoice_action_mapping  iam,
               axs_action_summary          axs,
               gmr_goods_movement_record   gmr
         where is1.is_active = 'Y'
           and is1.internal_invoice_ref_no = iid.internal_invoice_ref_no
           and iid.internal_gmr_ref_no = gmr.internal_gmr_ref_no
           and iam.internal_invoice_ref_no = is1.internal_invoice_ref_no
           and iam.invoice_action_ref_no = axs.internal_action_ref_no
         group by iid.internal_gmr_ref_no,
                  gmr.qty) t,
       is_invoice_summary is1
 where t.internal_invoice_ref_no = is1.internal_invoice_ref_no
