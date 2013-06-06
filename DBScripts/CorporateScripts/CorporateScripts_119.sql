BEGIN
for cc in (select AKC.CORPORATE_ID from AK_CORPORATE akc where AKC.IS_ACTIVE='Y' and AKC.IS_INTERNAL_CORPORATE='N') 
loop

Insert into ARF_ACTION_REF_NUMBER_FORMAT
   (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID, PREFIX, MIDDLE_NO_START_VALUE, 
    MIDDLE_NO_LAST_USED_VALUE, SUFFIX, VERSION, IS_DELETED)
 Values
   ('ARF-CT-&'||CC.CORPORATE_ID, 'TemplateRefNo', CC.CORPORATE_ID, 'TMPL-', 1, 
    0,  '-'||CC.CORPORATE_ID, 1, 'N');

Insert into ARFM_ACTION_REF_NO_MAPPING
   (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID, ACTION_KEY_ID, IS_DELETED)
 Values
   ('ARFM-CT-&'||CC.CORPORATE_ID, CC.CORPORATE_ID, 'CREATE_TEMPLATE', 'TemplateRefNo', 'N');

Insert into ERC_EXTERNAL_REF_NO_CONFIG
   (CORPORATE_ID, EXTERNAL_REF_NO_KEY, PREFIX, MIDDLE_NO_LAST_USED_VALUE, SUFFIX, 
    IS_CONTINUOUS_MIDDLE_NO_REQ, SEQ_NAME)
 Values
   (CC.CORPORATE_ID, 'CREATE_TEMPLATE', 'TMPL-', 0, '-'||CC.CORPORATE_ID, 
    'N', 'SEQ_EXT_REF_GEN');

 end loop;

end;
