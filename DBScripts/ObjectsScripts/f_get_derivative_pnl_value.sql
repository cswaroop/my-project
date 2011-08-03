CREATE OR REPLACE FUNCTION f_get_derivative_pnl_value(
   pc_derivative_id              VARCHAR2 , pc_realized_status varchar2
)
   RETURN NUMBER
IS
   deal_item_value     VARCHAR2 (400);
   RESULT              NUMBER         := 0;
   curr_code           VARCHAR2 (15);
   pnl_qty             NUMBER;
   pnl_value           NUMBER;
   pc_open_qty         NUMBER;
   totalvalue          NUMBER;
   pc_total_qty        NUMBER;
   pc_from_qty_id      VARCHAR2 (15);
   pc_product_id       VARCHAR2 (15);
   base_unit_unit_id   VARCHAR2 (15);
  
BEGIN
   BEGIN
      SELECT cdc.product_id, cdc.quantity_unit_id, cdc.total_quantity
        INTO pc_product_id, pc_from_qty_id, pc_total_qty
        FROM v_cdc_derivative_trade cdc
       WHERE cdc.internal_derivative_ref_no = pc_derivative_id;
   END;

 
  
   BEGIN
       SELECT v_der.quantity, v_der.pnl_in_base_cur, v_der.base_qty_unit_id
        INTO pnl_qty, pnl_value, base_unit_unit_id
        FROM mv_dm_phy_derivative v_der
       WHERE v_der.internal_derivative_ref_no = pc_derivative_id 
            and v_der.PNL_TYPE = pc_realized_status ;
   END;

  
   IF pnl_qty <> 0
      THEN
         --RESULT := ((pnl_value / pnl_qty) * pc_open_qty);
         RESULT :=
              RESULT
            + (  (  pnl_value
                  / (pkg_general.f_get_converted_quantity (pc_product_id,
                                                           pc_from_qty_id,
                                                           base_unit_unit_id,
                                                           pnl_qty
                                                          )
                    )
                 )
               * (pkg_general.f_get_converted_quantity (pc_product_id,
                                                        pc_from_qty_id,
                                                        base_unit_unit_id,
                                                        pc_total_qty
                                                       )
                 )
              );
      ELSE
         RESULT := RESULT + pnl_value;
      END IF;
  

   RETURN round(RESULT,3);
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      RETURN 0;
END f_get_derivative_pnl_value;
/
