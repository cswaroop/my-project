 --- Scripts for recording Received Material Cancel


Insert into AXM_ACTION_MASTER
   (ACTION_ID, ENTITY_ID, ACTION_NAME, IS_NEW_GMR_APPLICABLE, ACTION_DESC, 
    IS_GENERATE_DOC_APPLICABLE, IS_REF_NO_GEN_APPLICABLE)
 Values
   ('RECORD_OUT_PUT_TOLLING_CANCEL', 'GMR Tolling ', 'Cancel Received Material', 'N', 'Cancel Received Material', 
    'N', NULL);



Insert into CAC_CORPORATE_ACTION_CONFIG
   (ACTION_ID, IS_ACCRUAL_POSSIBLE, IS_ESTIMATE_POSSIBLE, EFF_DATE_FIELD, IS_DOC_APPLICABLE, 
    GMR_STATUS_ID, SHIPMENT_STATUS, IS_AFLOAT, IS_INV_POSTING_REQD)
 Values
   ('RECORD_OUT_PUT_TOLLING_CANCEL', NULL, NULL, NULL, 'Y', 
    NULL, NULL, NULL, 'Y');


Insert into AKM_ACTION_REF_KEY_MASTER
   (ACTION_KEY_ID, ACTION_KEY_DESC, VALIDATION_QUERY)
 Values
   ('RO-CANCEL', 'RM Ref.No.', 'SELECT COUNT(*) FROM   AXS_ACTION_SUMMARY axs WHERE  axs.action_ref_no = :pc_action_ref_no AND    axs.corporate_id = :pc_corporate_id');

